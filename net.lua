Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")
CoreGui = game:GetService("CoreGui")
RunService = game:GetService("RunService")
Workspace = game:GetService("Workspace")
Lighting = game:GetService("Lighting")
TweenService = game:GetService("TweenService")
HttpService = game:GetService("HttpService")

LocalPlayer = Players.LocalPlayer
Camera = Workspace.CurrentCamera
SelectedFont = Enum.Font.GothamBold
MenuFontId = "GothamBold"

MENU_FONT_OPTIONS = {
    { name = "Gotham Bold", id = "GothamBold" },
    { name = "Gotham", id = "Gotham" },
    { name = "Gotham Medium", id = "GothamMedium" },
    { name = "Code", id = "Code" },
    { name = "Builder Sans", id = "BuilderSans" },
    { name = "Builder Mono", id = "BuilderMono" },
    { name = "Roboto Mono", id = "RobotoMono" },
    { name = "Nunito", id = "Nunito" },
    { name = "Josefin Sans", id = "JosefinSans" },
    { name = "Jura", id = "Jura" },
    { name = "Ubuntu", id = "Ubuntu" },
    { name = "Source Sans", id = "SourceSans" },
    { name = "Arcade", id = "Arcade" },
    { name = "Special Elite", id = "SpecialElite" },
    { name = "Fredoka One", id = "FredokaOne" },
    { name = "Patrick Hand", id = "PatrickHand" },
    { name = "Legacy", id = "Legacy" },
    { name = "Highway", id = "Highway" },
    { name = "SciFi", id = "SciFi" },
    { name = "Cartoon", id = "Cartoon" },
}

function ResolveEnumFont(id)
    if typeof(id) == "EnumItem" then return id end
    local key = tostring(id or "GothamBold")
    local ok, f = pcall(function() return Enum.Font[key] end)
    if ok and f then return f end
    return Enum.Font.GothamBold
end

function GetDrawingFontIndex()
    
    local id = tostring((Config and Config.MenuFont) or MenuFontId or "GothamBold")
    if id == "Code" or id == "RobotoMono" or id == "BuilderMono" or id == "Legacy" or id == "Arcade" then
        return 3
    end
    if id == "SpecialElite" or id == "Highway" or id == "SciFi" then
        return 1
    end
    if id == "Gotham" or id == "GothamMedium" or id == "GothamBold" or id == "Nunito"
        or id == "JosefinSans" or id == "Ubuntu" or id == "SourceSans" or id == "BuilderSans" then
        return 2
    end
    return 2
end

function ApplyMenuFont(fontId)
    fontId = tostring(fontId or Config.MenuFont or "GothamBold")
    Config.MenuFont = fontId
    MenuFontId = fontId
    SelectedFont = ResolveEnumFont(fontId)
    Cache.DrawingFontIndex = GetDrawingFontIndex()

    local function applyTo(gui)
        if not gui then return end
        for _, d in ipairs(gui:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                local skip = false
                pcall(function()
                    if d:GetAttribute("AnxiumFontPreview") then skip = true end
                    if d:GetAttribute("AnxiumLockFont") then skip = true end
                end)
                if not skip then
                    pcall(function()
                        d.Font = SelectedFont
                        
                    end)
                end
            end
        end
    end
    pcall(function() applyTo(ScreenGui) end)
    pcall(function()
        if Cache.KillLogContainer then applyTo(Cache.KillLogContainer) end
    end)

    
    if Cache.EspLabels then
        for _, nameText in pairs(Cache.EspLabels) do
            if nameText then
                pcall(function()
                    if typeof(nameText) == "Instance" and nameText:IsA("TextLabel") then
                        nameText.Font = SelectedFont
                        nameText.TextSize = 14
                    elseif nameText.Font ~= nil then
                        nameText.Font = Cache.DrawingFontIndex or 2
                        nameText.Size = 14
                    end
                end)
            end
        end
    end
    if Cache.DrawingTexts then
        for _, t in pairs(Cache.DrawingTexts) do
            if t then
                pcall(function()
                    if typeof(t) == "Instance" and (t:IsA("TextLabel") or t:IsA("TextButton")) then
                        t.Font = SelectedFont
                    end
                end)
            end
        end
    end

    
    if Cache.MenuFontButtons then
        for id, btn in pairs(Cache.MenuFontButtons) do
            if btn then
                pcall(function()
                    local okF, f = pcall(function() return Enum.Font[id] end)
                    btn.Font = (okF and f) or SelectedFont
                end)
            end
        end
    end

    if Cache.HitSoundHeaderLbl then pcall(function() Cache.HitSoundHeaderLbl.Font = SelectedFont end) end
    if Cache.AnimHeaderLbl then pcall(function() Cache.AnimHeaderLbl.Font = SelectedFont end) end
    if Cache.MenuFontHeaderLbl then
        pcall(function()
            local pretty = fontId
            for _, e in ipairs(MENU_FONT_OPTIONS) do
                if e.id == fontId then pretty = e.name break end
            end
            Cache.MenuFontHeaderLbl.Text = "Menu Font  ·  " .. tostring(pretty)
            Cache.MenuFontHeaderLbl.Font = SelectedFont
        end)
    end
    if Cache.RefreshMenuFontList then pcall(Cache.RefreshMenuFontList) end
end

local fenv = getfenv()
Drawing = fenv.Drawing

LightingDefaults = {
    Ambient = Lighting.Ambient,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    Brightness = Lighting.Brightness,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor,
    Density = (Lighting:FindFirstChildOfClass("Atmosphere") and Lighting:FindFirstChildOfClass("Atmosphere").Density) or 0,
    Haze = (Lighting:FindFirstChildOfClass("Atmosphere") and Lighting:FindFirstChildOfClass("Atmosphere").Haze) or 0
}

Config = {
    EspEnabled = false,
    BoxEspEnabled = false,
    BoxFillGradientEnabled = false,
    BoxFillRotation = false,
    BoxFillRotationSpeed = 2,
    BoxOutlineGradient = false,
    EspBoxStyle = "Full", 
    Color_HealthbarTop = Color3.fromRGB(180, 140, 255),
    Color_HealthbarBottom = Color3.fromRGB(255, 255, 255),
    HealthbarEspEnabled = false,
    HealthbarStyle = "Gradient",
    ChamsEnabled = false,
    ChamsStyle = "Flat",
    NameEspEnabled = false,
    NameEspFillEnabled = false,
    Color_NameEspFill = Color3.fromRGB(0, 0, 0),
    NameEspFillCorner = 4,
    DistanceEspEnabled = false,
    SkeletonEnabled = false,
    TracersEnabled = false,
    TracerOrigin = "Bottom",
    TracerGradientEnabled = false,
    Color_TracerGradientB = Color3.fromRGB(255, 255, 255),
    FullbrightEnabled = false,
    CameraFovEnabled = false,
    CameraFovValue = 120,
    FpsBoostEnabled = false,

    CrosshairEnabled = false,
    CrosshairSize = 10,
    CrosshairGap = 4,
    CrosshairThickness = 1.4,
    CrosshairTransparency = 0,
    CrosshairDotEnabled = false,
    CrosshairDotSize = 3,
    CrosshairDotTransparency = 0,

    
    ScopeEnabled = false, 
    ScopeActive = false,  
    ScopeMode = "Hold",   
    ScopeKey = "",         
    ScopeLength = 80,     
    ScopeGap = 8,         
    ScopeThickness = 2,
    ScopeZoomFOV = 40,    
    ScopeZoomSpeed = 0.12, 
    ScopeGradientEnabled = false,
    ScopeDynamicEnabled = false,
    ScopeDynamicExpand = 30,
    Color_Scope = Color3.fromRGB(255, 255, 255),
    ScopeSoundEnabled = false, 
    ChinaHatEnabled = false,
    ChinaHatStyle = "Drawing", 
    ChinaHatMeshSize = 3,
    ChinaHatMeshTransparency = 0.5,
    ChinaHatMeshMaterial = "Neon",
    FogEnabled = false,
    NoFogEnabled = false,
    DayCycleEnabled = false,
    DayCycleTime = 14, 
    FootstepsEnabled = false,
    OrbitOrbsEnabled = false,
    TargetRingEnabled = false,
    TargetRingSpeed = 1.2, 
    TargetRingRadius = 2.2,
    TargetRingThickness = 0.16,
    TargetRingSegments = 40,
    TargetMarkerEnabled = false,
    TargetMarkerSize = 90,
    TargetMarkerTransparency = 0.15,
    TargetMarkerRotate = false,
    TargetMarkerRotateSpeed = 90,
    TargetDotEnabled = false,
    TargetDotSize = 28,
    TargetDotTransparency = 0.1,
    Color_TargetDot = Color3.fromRGB(180, 140, 255),
    TrailEnabled = false,
    AspectRatioEnabled = false,
    ThirdPersonEnabled = false,
    ActiveListEnabled = false,
    BindListEnabled = false,
    ActiveListTransparency = 0.05,
    BindListTransparency = 0.05,
    MenuKey = "RightShift", 
    MenuFont = "GothamBold",
    WatermarkPosition = "Center", 
    Keybinds = {}, 

    FakeFpsEnabled = false,
    FakeFpsValue = 67,
    FakeFpsIndex = 1,


    MultiJumpEnabled = false,
    AutoJumpEnabled = false,
    SpeedHackEnabled = false,
    NoclipEnabled = false,
    FlyEnabled = false,
    BHopEnabled = false,
    StrafeEnabled = false,
    StrafeSpeed = 22,
    AutoShiftEnabled = false,
    PeekAssistRadius = 5,
    PeekAssistDurationMs = 700,
    PeekAssistReturnDelayMs = 0,
    PeekAssistSegments = 48,
    PeekAssistThickness = 0.18,
    PeekAssistFillEnabled = false,
    PeekAssistTransparency = 0.28,
    Color_PeekAssist = Color3.fromRGB(180, 140, 255),
    Color_PeekAssistShot = Color3.fromRGB(255, 255, 255),
    WeaponAutoSwapEnabled = false,
    WeaponAutoSwapSlots = {}, 
    WeaponAutoSwapSpeed = 150, 
    StrafeMode = "Hybrid", 
    FakeLagEnabled = false,
    FakeLagRandomize = false,
    FakeLagJitter = 15, 
    FakeLagAnchorTime = 50, 
    FakeLagUnanchorTime = 35,
    FakeLagPause = 100, 
    SpinEnabled = false,
    SpinSpeed = 20,
    AimEnabled = false,
    AimTargetPart = "Head", 
    AimWallCheck = false, 
    ShowFovEnabled = false,
    FovFillEnabled = false,
    Color_FovFill = Color3.fromRGB(180, 140, 255),
    FovFillTransparency = 0.7,
    FovPulseEnabled = false,
    FovPulseSpeed = 3,
    FovPulseAmount = 0.12,
    FovDynamicEnabled = false,
    FovDynamicExpand = 40,
    TargetHudEnabled = false,
    TargetLineEnabled = false,
    TargetLineVisibleCheck = false,
    TargetLineTransparency = 0.15,
    Color_TargetLine = Color3.fromRGB(180, 140, 255),
    DarkModeEnabled = false,
    DarkModeIntensity = 50, 
    WorldColorEnabled = false,
    Color_World = Color3.fromRGB(180, 140, 255),
    WorldColorIntensity = 55,
    NoShadowsEnabled = false,
    HitMarkerEnabled = false,
    Color_HitMarker = Color3.fromRGB(255, 255, 255),
    HitMarkerDuration = 1.2,
    HitMarkerSize = 22,
    HitMarkerGap = 6,
    HitMarkerThickness = 3,
    HitMarkerRotation = 0,
    HitMarkerSpinSpeed = 0,
    TriggerbotEnabled = false,
    TriggerbotDelay = 0,
    TriggerbotAutowall = false,

    
    TeamCheckerEnabled = false,
    TeamEspEnabled = false,
    TeamNameEspEnabled = false,
    TeamDistanceEspEnabled = false,

    
    CustomHandsEnabled = false,
    HandsX = 0.2,
    HandsY = -0.155,
    HandsZ = 0.075,

    SilentAimV2Enabled = false,
    SilentV2Fov = 140,
    SilentV2ShowFov = false,
    SilentV2FovFillEnabled = false,
    Color_SilentV2FovFill = Color3.fromRGB(210, 180, 255),
    SilentV2FovFillTransparency = 0.7,
    SilentV2FovPulseEnabled = false,
    SilentV2FovDynamicEnabled = false,
    SilentV2FovDynamicExpand = 40,
    SilentV2TeamCheck = false,
    SilentV2VisibleCheck = false,
    SilentV2HitChance = 100,
    SilentV2TargetPart = "Head", 
    SilentV2Prediction = false,
    SilentV2PredictionAmount = 0.12,
    SilentV2Sticky = false,
    SilentV2MultipointEnabled = false,
    SilentV2Multipoint = {},
    Color_SilentV2Fov = Color3.fromRGB(180, 140, 255),

    CustomFireSoundEnabled = false,
    CustomFireSoundName = "Gun Fire",
    CustomFireSoundVolume = 1,

    TargetFlingEnabled = false,
    TargetFlingName = "",
    ClickFlingSelectEnabled = false,

    WalkSpeedValue = 32,
    FlySpeedValue = 50,
    BHopPower = 50,
    FovRadius = 150,
    AimSmoothValue = 0.18,
    FogDistanceValue = 300,
    AspectRatioValue = 1.333,
    OrbitSpeedValue = 4,
    ThirdPersonDistance = 12,

    JumpCircleSize = 5, 
    JumpCircleStartRadius = 0.8,
    JumpCircleThickness = 0.18,
    JumpCircleSegments = 48,
    JumpCircleExpandTime = 0.7,
    JumpCircleGlow = 4, 
    JumpCircleStyle = "Expand", 
    JumpCircleLife = 1.6, 

    ChinaHatHeightOffset = 0.5,
    ChinaHatHeight = 1.7,
    ChinaHatRadius = 2.3,
    ChinaHatSegments = 24,
    ChinaHatScale = 1.0,

    AngelHaloEnabled = false,
    AngelHaloHeight = 1.2,
    AngelHaloRadius = 1.15,
    AngelHaloTransparency = 0.2,
    AngelHaloThickness = 0.14,
    AngelHaloSegments = 36,
    AngelHaloRings = 1,
    AngelHaloGlow = 3,

    CurrentColorIndex = 1,

    
    Color_BoxEsp = Color3.fromRGB(180, 140, 255),
    Color_TeamEsp = Color3.fromRGB(210, 180, 255),
    Color_BoxEspFill = Color3.fromRGB(120, 90, 200), 
    Color_Chams = Color3.fromRGB(180, 140, 255),
    Color_ChamsVisible = Color3.fromRGB(180, 140, 255),
    Color_ChamsOccluded = Color3.fromRGB(180, 140, 255),
    ChamsVisCheckEnabled = false,
    Color_NameEsp = Color3.fromRGB(180, 140, 255),
    Color_NameEspB = Color3.fromRGB(255, 255, 255),
    NameEspGradientEnabled = false,
    Color_TeamNameEsp = Color3.fromRGB(210, 180, 255),
    Color_TeamNameEspB = Color3.fromRGB(255, 255, 255),
    TeamNameEspGradientEnabled = false,
    Color_Skeleton = Color3.fromRGB(180, 140, 255),
    Color_Tracers = Color3.fromRGB(180, 140, 255),
    Color_Healthbar = Color3.fromRGB(180, 140, 255),
    Color_Crosshair = Color3.fromRGB(180, 140, 255),
    Color_ChinaHat = Color3.fromRGB(180, 140, 255),
    Color_AngelHalo = Color3.fromRGB(255, 255, 255),
    Color_Fog = Color3.fromRGB(180, 140, 255),
    Color_WeaponFF = Color3.fromRGB(180, 140, 255),
    Color_ForceField = Color3.fromRGB(180, 140, 255),
    Color_BulletTracer = Color3.fromRGB(180, 140, 255),
    Color_Orbit = Color3.fromRGB(180, 140, 255),
    Color_TargetRing = Color3.fromRGB(180, 140, 255),
    Color_TargetMarker = Color3.fromRGB(210, 180, 255),
    Color_TargetHud = Color3.fromRGB(180, 140, 255),
    Color_JumpCircle = Color3.fromRGB(180, 140, 255),
    Color_FallingStars = Color3.fromRGB(255, 255, 255),
    FallingStarsEnabled = false,
    FallingStarsSize = 28,
    FallingStarsCount = 70,
    Color_Trail = Color3.fromRGB(180, 140, 255),
    Color_Aura = Color3.fromRGB(180, 140, 255),
    Color_Fov = Color3.fromRGB(180, 140, 255),

    AntiAimEnabled = false,
    AntiAimPitch = -45, 
    AntiAimYaw = 180,   
    AntiAimMode = "Static", 
    AntiAimJitter = 35,
    AntiAimSpinSpeed = 720,
    AntiAimTPRadius = 5,  
    AntiAimTPSpeed = 8,   

    AntiAimResolveEnabled = false,
    AntiAimResolveReturnMs = 60,
    AntiAimResolveHoldMs = 100,

    ForceFieldEnabled = false,
    ForceFieldRainbow = false,
    WeaponForceFieldEnabled = false,
    WeaponMaterialStyle = "ForceField", 
    KillFlashEnabled = false,
    KillLogsEnabled = false,
    HitLogsEnabled = false,
    KillFlashDuration = 0.85,
    Color_KillFlash = Color3.fromRGB(255, 255, 255),
    KillLightningEnabled = false,
    Color_KillLightning = Color3.fromRGB(255, 255, 255),
    KillLightningSize = 1.5,
    KillLightningDuration = 0.55,

    
    HitboxShow = false,
    Color_Hitbox = Color3.fromRGB(180, 140, 255),

    
    SpinCrosshairEnabled = false,
    SpinCrosshairSpeed = 180,
    DamageNumbersEnabled = false,
    Color_DamageNumber = Color3.fromRGB(255, 255, 255),
    SelfTransparencyEnabled = false,
    SelfTransparency = 0.4, 
    SelfChamsEnabled = false,
    Color_SelfChams = Color3.fromRGB(180, 140, 255),
    
    CloneChamsEnabled = false,
    Color_CloneChams = Color3.fromRGB(180, 140, 255),
    CloneInterval = 1,
    CloneFadeDelay = 1.5,
    CloneFadeTime = 1.2,
    CloneTransparency = 0.25,
    CloneChamsStyle = "Chams",
    DeathChamsStyle = "Chams",
    OffscreenArrowsEnabled = false,
    Color_OffscreenArrow = Color3.fromRGB(180, 140, 255), 
    Color_OffscreenArrowB = Color3.fromRGB(255, 255, 255), 
    ArrowSize = 34,
    ArrowDistance = 0.42, 
    ArrowShowDistance = false,
    ShowArrowRadius = false,
    ArrowGradientSpeed = 0.35,
    BlurGradientEnabled = false,
    BlurGradientAnimate = false,
    BlurGradientSpeed = 1,
    BlurGradientTransparency = 0.28,
    Color_BlurGradientA = Color3.fromRGB(130, 70, 255),
    Color_BlurGradientB = Color3.fromRGB(180, 140, 255),
    ArrowPosSmooth = 0.16,
    ArrowRotSmooth = 0.18,
    ArrowTransparency = 0.05,
    ArrowPulseEnabled = false,
    ArrowPulseSpeed = 3,
    ArrowEdgePadding = 55,
    DeathChamsEnabled = false,
    Color_DeathChams = Color3.fromRGB(180, 140, 255),
    DeathFadeDelay = 1.5,
    DeathFadeTime = 1.5,
    DeathBurstEnabled = false,
    DeathEffectsXRay = false,
    Color_DeathBurst = Color3.fromRGB(210, 180, 255),
    KillDissolveEnabled = false,
    Color_KillDissolve = Color3.fromRGB(180, 100, 255),
    BulletTracersEnabled = false,
    BulletTracerDuration = 2,
    BulletTracerCooldown = 120,
    BulletTracerTransparency = 0.15,

    
    AutowallEnabled = false,
    AutowallShowInfo = false,
    AutowallSize = 18,
    AutowallCorner = 3,
    AutowallTransparency = 0.15,
    AutowallSoftMax = 2.2,
    AutowallHardMax = 0.55,
    Color_AutowallPen = Color3.fromRGB(180, 140, 255),
    Color_AutowallMid = Color3.fromRGB(210, 180, 255),
    Color_AutowallBlock = Color3.fromRGB(255, 255, 255),

    AuraEnabled = false,
    ClassicPinkEnabled = false,
    ClassicAngelEnabled = false,
    ParticleStarlightEnabled = false,
    ParticleAngelEnabled = false,

    
    SelectedAnimPack = "Default",
    AnimPackIndex = 1,

}


ColorPalette = {
    Color3.fromRGB(230, 210, 255),
    Color3.fromRGB(200, 180, 240),
    Color3.fromRGB(180, 140, 255),
    Color3.fromRGB(160, 120, 220),
    Color3.fromRGB(255, 200, 220),
    Color3.fromRGB(255, 170, 190),
    Color3.fromRGB(255, 140, 170),
    Color3.fromRGB(255, 120, 140),
    Color3.fromRGB(180, 230, 255),
    Color3.fromRGB(140, 210, 255),
    Color3.fromRGB(120, 190, 240),
    Color3.fromRGB(100, 170, 220),
    Color3.fromRGB(180, 245, 220),
    Color3.fromRGB(150, 230, 200),
    Color3.fromRGB(120, 220, 180),
    Color3.fromRGB(255, 230, 190),
    Color3.fromRGB(255, 210, 160),
    Color3.fromRGB(255, 190, 140),
    Color3.fromRGB(240, 200, 255),
    Color3.fromRGB(220, 170, 240),
    Color3.fromRGB(200, 150, 220),
    Color3.fromRGB(255, 240, 245),
    Color3.fromRGB(240, 245, 255),
    Color3.fromRGB(230, 240, 235),
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(200, 200, 210),
    Color3.fromRGB(255, 100, 120),
    Color3.fromRGB(100, 200, 255),
    Color3.fromRGB(120, 255, 180),
    Color3.fromRGB(255, 180, 100),
    Color3.fromRGB(247, 255, 144),
    Color3.fromRGB(255, 250, 200),
    Color3.fromRGB(200, 255, 220),
    Color3.fromRGB(220, 240, 255),
    Color3.fromRGB(255, 220, 240),
    Color3.fromRGB(240, 220, 255),
    Color3.fromRGB(255, 235, 210),
    Color3.fromRGB(210, 255, 230),
}

Cache = {
    Highlights = {},
    Chams = {},
    Boxes = {},
    Healthbars = {},
    TracerLines = {},
    EspLabels = {},
    Skeletons = {},
    ActiveFootsteps = {},
    OrbitAngle = 0,
    LastFootstepPos = Vector3.zero,
    WasOnGround = true,
    JumpCircleCooldown = 0,
    FlyBodyVelocity = nil,
    FlyBodyGyro = nil,
    PlayerTrail = nil,
    TrailAtt0 = nil,
    TrailAtt1 = nil,
    SelectedTargetHighlight = nil,
    FireSoundAssets = {},
    FireSoundInstance = nil,
    FireSoundsReady = false,

    ChinaHatLines = {},
    ChinaHatTris = {},

    ForceFieldOriginals = {},
    ForceFieldConnection = nil,
    WeaponFFOriginals = {},
    WeaponFFConnections = {},
    WeaponFFCurrentTool = nil,
    WeaponFFKeepAlive = nil,
    ActiveClassicAuras = { Godly = {}, PinkAura = {}, AngelWing = {} },
    ActiveParticleAuras = { starlight = {}, angel = {} },
    LoadedParticleTemplates = {},
    AimLockTarget = nil
}


pcall(function()
    rawset(_G, "Config", Config)
    rawset(_G, "Cache", Cache)
end)

CachedPlayerList = {}

function RefreshPlayerCache()
    CachedPlayerList = Players:GetPlayers()
end


task.spawn(function()
    while true do
        task.wait(1.25)
        pcall(RefreshPlayerCache)
    end
end)

Players.PlayerAdded:Connect(RefreshPlayerCache)
Players.PlayerRemoving:Connect(function(p)
    RefreshPlayerCache()
    if Cache.TeamCache then Cache.TeamCache[p] = nil end
end)
RefreshPlayerCache()

RaycastParamsFootsteps = RaycastParams.new()
RaycastParamsFootsteps.FilterType = Enum.RaycastFilterType.Exclude

RaycastParamsTriggerbot = RaycastParams.new()
RaycastParamsTriggerbot.FilterType = Enum.RaycastFilterType.Exclude
RaycastParamsTriggerbot.IgnoreWater = true

Theme = {
    Bg = Color3.fromRGB(14, 14, 16),
    BgSecondary = Color3.fromRGB(18, 18, 22),
    BgTertiary = Color3.fromRGB(24, 24, 28),
    Sidebar = Color3.fromRGB(12, 12, 14),
    Card = Color3.fromRGB(20, 20, 24),
    Text = Color3.fromRGB(235, 235, 240),
    TextDim = Color3.fromRGB(130, 130, 140),
    Accent = Color3.fromRGB(160, 120, 255),
    AccentSoft = Color3.fromRGB(120, 90, 210),
    ToggleOff = Color3.fromRGB(48, 48, 56),
    ToggleOn = Color3.fromRGB(160, 120, 255),
    Stroke = Color3.fromRGB(36, 36, 44),
    TabActive = Color3.fromRGB(28, 28, 34)
}

Cache.ThemeAccentTracked = Cache.ThemeAccentTracked or {}


function AnxiumColorToHex(c)
    if typeof(c) ~= "Color3" then
        c = Theme.Accent or Color3.fromRGB(180, 140, 255)
    end
    local r = math.clamp(math.floor(c.R * 255 + 0.5), 0, 255)
    local g = math.clamp(math.floor(c.G * 255 + 0.5), 0, 255)
    local b = math.clamp(math.floor(c.B * 255 + 0.5), 0, 255)
    return string.format("#%02X%02X%02X", r, g, b)
end

function AnxiumUpdateBrandLogo()
    if not LogoLabel then return end
    local hex = AnxiumColorToHex(Theme.Accent)
    LogoLabel.RichText = true
    LogoLabel.Text = "ANXIUM<font color=\"" .. hex .. "\">HUB</font>"
    LogoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
end

function TrackThemeAccent(inst, prop)
    if not inst then return end
    Cache.ThemeAccentTracked = Cache.ThemeAccentTracked or {}
    prop = prop or "TextColor3"
    for _, e in ipairs(Cache.ThemeAccentTracked) do
        if e.inst == inst and e.prop == prop then return end
    end
    table.insert(Cache.ThemeAccentTracked, { inst = inst, prop = prop })
end

function LuaIO_CardColorFromAccent(accent)
    accent = accent or Theme.Accent or Color3.fromRGB(180, 140, 255)
    return Color3.new(
        math.clamp(accent.R * 0.22, 0, 1),
        math.clamp(accent.G * 0.22, 0, 1),
        math.clamp(accent.B * 0.28, 0, 1)
    )
end


Cache.GlowRegistry = Cache.GlowRegistry or {}
AddAnxiumGlow = function(parent, opts)
    if not parent then return nil end
    opts = opts or {}
    local amount = opts.Amount or 3
    local baseTrans = opts.BaseTransparency or 0.35
    local step = opts.Step or 0.18
    local thickness = opts.Thickness or 1
    local color = opts.Color or Theme.Accent or Color3.fromRGB(160, 120, 255)
    local layers = {}
    for i = 0, amount do
        local st = Instance.new("UIStroke")
        st.Name = "AnxiumGlow_" .. tostring(i)
        st.Color = color
        st.Thickness = thickness + i
        st.Transparency = math.clamp(baseTrans + i * step, 0, 0.95)
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        st.LineJoinMode = Enum.LineJoinMode.Round
        st.Parent = parent
        pcall(function() TrackThemeAccent(st, "Color") end)
        table.insert(layers, st)
    end
    table.insert(Cache.GlowRegistry, { parent = parent, layers = layers })
    return layers
end


AddSectionShine = function(row, label)
    if not row then return end
    local line = Instance.new("Frame")
    line.Name = "SectionShine"
    line.Size = UDim2.new(0, 48, 0, 2)
    line.Position = UDim2.new(0, 8, 1, -4)
    line.BackgroundColor3 = Theme.Accent
    line.BorderSizePixel = 0
    line.Parent = row
    pcall(function() TrackThemeAccent(line, "BackgroundColor3") end)
    local grad = Instance.new("UIGradient")
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.05),
        NumberSequenceKeypoint.new(0.55, 0.35),
        NumberSequenceKeypoint.new(1, 1),
    })
    grad.Parent = line
    local soft = Instance.new("Frame")
    soft.Name = "SectionShineSoft"
    soft.Size = UDim2.new(0, 72, 0, 6)
    soft.Position = UDim2.new(0, 4, 1, -7)
    soft.BackgroundColor3 = Theme.Accent
    soft.BackgroundTransparency = 0.82
    soft.BorderSizePixel = 0
    soft.ZIndex = 0
    soft.Parent = row
    pcall(function() TrackThemeAccent(soft, "BackgroundColor3") end)
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = soft
end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnxiumGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "AnxiumMenuBlur"
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

BlurGradientOverlay = Instance.new("Frame")
BlurGradientOverlay.Name = "AnxiumBlurGradientOverlay"
BlurGradientOverlay.Size = UDim2.fromScale(1, 1)
BlurGradientOverlay.Position = UDim2.fromScale(0, 0)
BlurGradientOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
BlurGradientOverlay.BackgroundTransparency = 1
BlurGradientOverlay.BorderSizePixel = 0
BlurGradientOverlay.Visible = false
BlurGradientOverlay.Active = false
BlurGradientOverlay.Selectable = false
BlurGradientOverlay.ZIndex = 1
BlurGradientOverlay.Parent = ScreenGui
BlurGradientOverlayGradient = Instance.new("UIGradient")
BlurGradientOverlayGradient.Rotation = 35
BlurGradientOverlayGradient.Color = ColorSequence.new(Config.Color_BlurGradientA, Config.Color_BlurGradientB)
BlurGradientOverlayGradient.Parent = BlurGradientOverlay

MakeDraggable = function(uiFrame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    local moveTween = nil
    dragHandle = dragHandle or uiFrame
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = uiFrame.Position
            if moveTween then pcall(function() moveTween:Cancel() end) moveTween = nil end
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local goal = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            
            if moveTween then pcall(function() moveTween:Cancel() end) end
            moveTween = TweenService:Create(
                uiFrame,
                TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Position = goal }
            )
            moveTween:Play()
        end
    end)
end

NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 280, 1, -24)
NotifContainer.Position = UDim2.new(1, -296, 0, 12)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.Parent = NotifContainer

Notify = function(title, message, duration)
    duration = duration or 2.6
    title = tostring(title or "Anxium")
    message = tostring(message or "")

    local Card = Instance.new("Frame")
    Card.Name = "NotifCard"
    Card.Size = UDim2.new(0, 268, 0, 48)
    Card.BackgroundColor3 = Theme.BgSecondary or Color3.fromRGB(20, 22, 28)
    Card.BackgroundTransparency = 1
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = true

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme.Accent
    Stroke.Thickness = 1
    Stroke.Transparency = 1
    Stroke.Parent = Card
    pcall(function() TrackThemeAccent(Stroke, "Color") end)

    local AccentBar = Instance.new("Frame")
    AccentBar.Name = "Accent"
    AccentBar.Size = UDim2.new(0, 3, 1, -10)
    AccentBar.Position = UDim2.new(0, 0, 0, 5)
    AccentBar.BackgroundColor3 = Theme.Accent
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = Card
    pcall(function() TrackThemeAccent(AccentBar, "BackgroundColor3") end)
    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1, 0)
        c.Parent = AccentBar
    end

    local IconBg = Instance.new("Frame")
    IconBg.Name = "IconBg"
    IconBg.Size = UDim2.fromOffset(32, 32)
    IconBg.Position = UDim2.new(0, 12, 0.5, -16)
    IconBg.BackgroundColor3 = Theme.BgTertiary or Color3.fromRGB(28, 31, 40)
    IconBg.BackgroundTransparency = 0.15
    IconBg.BorderSizePixel = 0
    IconBg.Parent = Card
    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = IconBg
    end

    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.fromOffset(20, 20)
    Icon.Position = UDim2.new(0.5, -10, 0.5, -10)
    Icon.Image = "rbxassetid://112102474509324"
    Icon.ImageColor3 = Theme.Accent
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.ImageTransparency = 1
    Icon.Parent = IconBg
    pcall(function() TrackThemeAccent(Icon, "ImageColor3") end)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Name = "Title"
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Size = UDim2.new(1, -60, 0, 16)
    TitleLbl.Position = UDim2.new(0, 52, 0, 8)
    TitleLbl.Font = SelectedFont or Enum.Font.GothamBold
    TitleLbl.TextSize = 12
    TitleLbl.TextColor3 = Theme.Accent
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextYAlignment = Enum.TextYAlignment.Center
    TitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLbl.Text = title
    TitleLbl.TextTransparency = 1
    TitleLbl.Parent = Card
    pcall(function() TrackThemeAccent(TitleLbl, "TextColor3") end)

    local MsgLbl = Instance.new("TextLabel")
    MsgLbl.Name = "Message"
    MsgLbl.BackgroundTransparency = 1
    MsgLbl.Size = UDim2.new(1, -60, 0, 16)
    MsgLbl.Position = UDim2.new(0, 52, 0, 24)
    MsgLbl.Font = SelectedFont or Enum.Font.Gotham
    MsgLbl.TextSize = 11
    MsgLbl.TextColor3 = Theme.Text or Color3.fromRGB(230, 232, 240)
    MsgLbl.TextXAlignment = Enum.TextXAlignment.Left
    MsgLbl.TextYAlignment = Enum.TextYAlignment.Center
    MsgLbl.TextTruncate = Enum.TextTruncate.AtEnd
    MsgLbl.Text = message
    MsgLbl.TextTransparency = 1
    MsgLbl.Parent = Card

    Card.Parent = NotifContainer

    local tiIn = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(Card, tiIn, { BackgroundTransparency = 0.08 }):Play()
    TweenService:Create(Stroke, tiIn, { Transparency = 0.45 }):Play()
    TweenService:Create(TitleLbl, tiIn, { TextTransparency = 0 }):Play()
    TweenService:Create(MsgLbl, tiIn, { TextTransparency = 0.12 }):Play()
    TweenService:Create(Icon, tiIn, { ImageTransparency = 0 }):Play()

    task.delay(duration, function()
        if not Card or not Card.Parent then return end
        local tiOut = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        TweenService:Create(Card, tiOut, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(Stroke, tiOut, { Transparency = 1 }):Play()
        TweenService:Create(TitleLbl, tiOut, { TextTransparency = 1 }):Play()
        TweenService:Create(MsgLbl, tiOut, { TextTransparency = 1 }):Play()
        TweenService:Create(Icon, tiOut, { ImageTransparency = 1 }):Play()
        task.wait(0.3)
        pcall(function() Card:Destroy() end)
    end)
end


local HUD_W, HUD_H = 180, 148


ActiveListFrame = Instance.new("Frame")
ActiveListFrame.Name = "ActiveFeaturesFrame"
ActiveListFrame.Size = UDim2.new(0, HUD_W, 0, HUD_H)
ActiveListFrame.Position = UDim2.new(0, 16, 0.38, -100)
ActiveListFrame.BackgroundColor3 = Theme.Bg
ActiveListFrame.BackgroundTransparency = tonumber(Config.ActiveListTransparency) or 0.05
ActiveListFrame.BorderSizePixel = 0
ActiveListFrame.ClipsDescendants = true
ActiveListFrame.Visible = Config.ActiveListEnabled == true
ActiveListFrame.Parent = ScreenGui
do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = ActiveListFrame
    local st = Instance.new("UIStroke")
    st.Name = "MenuStroke"
    st.Color = Theme.Stroke
    st.Thickness = 1
    st.Transparency = 0.35
    st.Parent = ActiveListFrame
    pcall(function() TrackThemeAccent(st, "Color") end)
end

ActiveHeader = Instance.new("Frame")
ActiveHeader.Name = "Header"
ActiveHeader.Size = UDim2.new(1, 0, 0, 28)
ActiveHeader.BackgroundColor3 = Theme.Sidebar
ActiveHeader.BackgroundTransparency = 0
ActiveHeader.BorderSizePixel = 0
ActiveHeader.Parent = ActiveListFrame

ActiveTitle = Instance.new("TextLabel")
ActiveTitle.Size = UDim2.new(1, -20, 1, 0)
ActiveTitle.Position = UDim2.new(0, 12, 0, 0)
ActiveTitle.BackgroundTransparency = 1
ActiveTitle.Text = "Active"
ActiveTitle.TextColor3 = Theme.Text
ActiveTitle.TextSize = 13
ActiveTitle.Font = SelectedFont
ActiveTitle.TextXAlignment = Enum.TextXAlignment.Left
ActiveTitle.Parent = ActiveHeader


do
    local bar = Instance.new("Frame")
    bar.Name = "AccentBar"
    bar.Size = UDim2.new(0, 3, 1, -8)
    bar.Position = UDim2.new(0, 0, 0, 4)
    bar.BackgroundColor3 = Theme.Accent
    bar.BorderSizePixel = 0
    bar.Parent = ActiveHeader
    pcall(function() TrackThemeAccent(bar, "BackgroundColor3") end)
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bar
end

ActiveContainer = Instance.new("ScrollingFrame")
ActiveContainer.Name = "ActiveContainer"
ActiveContainer.Size = UDim2.new(1, 0, 1, -28)
ActiveContainer.Position = UDim2.new(0, 0, 0, 28)
ActiveContainer.BackgroundColor3 = Theme.BgSecondary
ActiveContainer.BackgroundTransparency = 0.15
ActiveContainer.BorderSizePixel = 0
ActiveContainer.ScrollBarThickness = 3
ActiveContainer.ScrollBarImageColor3 = Theme.Accent
ActiveContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ActiveContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ActiveContainer.Parent = ActiveListFrame

ActiveLayout = Instance.new("UIListLayout")
ActiveLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
ActiveLayout.Padding = UDim.new(0, 1)
ActiveLayout.Parent = ActiveContainer

do
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.Parent = ActiveContainer
end

MakeDraggable(ActiveListFrame, ActiveHeader)

FeatureNamesMapping = {
    BoxEspEnabled = "2D Box ESP",
    BoxFillGradientEnabled = "Box Fill Gradient",
    HealthbarEspEnabled = "Healthbar ESP",
    ChamsEnabled = "Chams",
    ChamsVisCheckEnabled = "Enable Vis Colors",
    NameEspEnabled = "Name ESP",
    DistanceEspEnabled = "Distance ESP",
    SkeletonEnabled = "Skeleton ESP",
    TracersEnabled = "Tracers",
    TracerGradientEnabled = "Tracer Gradient",
    CrosshairEnabled = "Crosshair",
    ScopeEnabled = "Sniper Scope",
    ScopeGradientEnabled = "Scope Gradient",
    ScopeDynamicEnabled = "Scope Dynamic",
    FovDynamicEnabled = "FOV Dynamic",
    AntiAimResolveEnabled = "AA Shoot Resolve",
    SilentV2FovDynamicEnabled = "Silent FOV Dynamic",
    FullbrightEnabled = "Fullbright",
    CameraFovEnabled = "Camera FOV",
    FpsBoostEnabled = "FPS Boost",

    ChinaHatEnabled = "China Hat",
    AngelHaloEnabled = "Angel Halo",
    FakeLagEnabled = "Fake Lag",
    OrbitOrbsEnabled = "Neon Orbit",
    TargetRingEnabled = "Target Scan Ring",
    TargetMarkerEnabled = "Target Marker",
    TargetDotEnabled = "Target Dot",
    TrailEnabled = "Motion Trail",
    FogEnabled = "Custom Fog",
    NoFogEnabled = "No Fog",
    SelfTransparencyEnabled = "Self Transparency",
    DayCycleEnabled = "Day Cycle",
    FootstepsEnabled = "Jump Circles",
    FallingStarsEnabled = "Falling Stars",
    AspectRatioEnabled = "Aspect Ratio",
    ThirdPersonEnabled = "Third Person",
    AimEnabled = "Aimbot",
    AimWallCheck = "Aim Wall Check",
    ShowFovEnabled = "Show FOV",
    TargetHudEnabled = "Target HUD",
    TargetLineEnabled = "Target Line",
    TargetLineVisibleCheck = "TL Visible Check",
    DarkModeEnabled = "Dark Mode",
    WorldColorEnabled = "World Color",
    NoShadowsEnabled = "No Shadows",
    HitMarkerEnabled = "Hit Marker",
    TriggerbotEnabled = "Triggerbot",
    TriggerbotAutowall = "Trigger Autowall",
    SilentAimV2Enabled = "Silent Aim",
    TeamCheckerEnabled = "Team Checker",
    TeamEspEnabled = "Team ESP",
    TeamNameEspEnabled = "Team Name ESP",
    TeamDistanceEspEnabled = "Team Distance ESP",
    SilentV2ShowFov = "Show Silent FOV",
    CustomFireSoundEnabled = "Kill Sounds",
    SpinEnabled = "SpinBot",
    AntiAimEnabled = "Anti-Aim",
    SpeedHackEnabled = "Speed Hack",
    MultiJumpEnabled = "Double Jump",
    AutoJumpEnabled = "Auto Jump",
    NoclipEnabled = "Noclip",
    FlyEnabled = "Fly",
    BHopEnabled = "Bunny Hop",
    StrafeEnabled = "Strafe",
    AutoShiftEnabled = "Auto Shift",
    PeekAssist = "Peek Assist",
    WeaponAutoSwapEnabled = "Weapon Auto Swap",
    TargetFlingEnabled = "Target Fling",
    ClickFlingSelectEnabled = "Click Fling Select",
    ForceFieldEnabled = "Self ForceField",
    WeaponForceFieldEnabled = "Weapon Material",
    KillFlashEnabled = "Kill Flash",
    KillLogsEnabled = "Kill Logs",
    HitLogsEnabled = "Hit Logs",
    KillLightningEnabled = "Kill Lightning",
    SpinCrosshairEnabled = "Spin Crosshair",
    DamageNumbersEnabled = "Damage Numbers",
    SelfChamsEnabled = "Self Chams",
    CloneChamsEnabled = "Clone player",
    OffscreenArrowsEnabled = "Offscreen Arrows",
    ArrowPulseEnabled = "Arrow Pulse",
    DeathChamsEnabled = "Death player",
    DeathBurstEnabled = "Death Burst",
    KillDissolveEnabled = "Kill Dissolve",
    HitboxShow = "Show Hitboxes",
    BulletTracersEnabled = "Bullet Tracers",
    AutowallEnabled = "Autowall",
    AuraEnabled = "Aura",
    ClassicPinkEnabled = "Pink Aura",
    ClassicAngelEnabled = "Angel Wing",
    ParticleStarlightEnabled = "Starlight",
    ParticleAngelEnabled = "Angel",
    ActiveListEnabled = "Active Modules HUD",
    BindListEnabled = "Binds HUD",
    FakeFpsEnabled = "Fake FPS",
}


function ApplyHudPanelTransparency()
    local function setPanel(frame, header, container, amount)
        if not frame then return end
        amount = math.clamp(tonumber(amount) or 0.05, 0, 0.95)
        frame.BackgroundTransparency = amount
        if header then
            header.BackgroundTransparency = math.clamp(amount * 0.85, 0, 0.9)
        end
        if container then
            container.BackgroundTransparency = math.clamp(0.15 + amount * 0.7, 0.15, 0.95)
        end
        local stroke = frame:FindFirstChild("MenuStroke")
        if stroke and stroke:IsA("UIStroke") then
            stroke.Transparency = math.clamp(0.35 + amount * 0.5, 0.35, 0.92)
        end
    end
    pcall(function()
        setPanel(ActiveListFrame, ActiveHeader, ActiveContainer, Config.ActiveListTransparency)
        setPanel(BindListFrame, BindHeader, BindListContainer, Config.BindListTransparency)
    end)
end

UpdateActiveList = function()
    if not Config.ActiveListEnabled then
        ActiveListFrame.Visible = false
        return
    end
    ActiveListFrame.Visible = true
    pcall(ApplyHudPanelTransparency)

    for _, child in ipairs(ActiveContainer:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end

    local activeCount = 0
    for key, name in pairs(FeatureNamesMapping) do
        if Config[key] == true then
            activeCount = activeCount + 1
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 16)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
            lbl.TextSize = 12
            lbl.Font = SelectedFont
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = ActiveContainer
        end
    end
    ActiveListFrame.Size = UDim2.new(0, HUD_W or 180, 0, HUD_H or 148)
end


Config.Keybinds = Config.Keybinds or {}
Cache.BindToggles = Cache.BindToggles or {}
Cache.WaitingBindKey = nil 
Cache.BindIgnoreUntil = 0


BindableFeatureOrder = {
    "AimEnabled", "ShowFovEnabled", "SilentAimV2Enabled",
    "TriggerbotEnabled", "TargetHudEnabled", "TargetLineEnabled", "SpinEnabled", "AntiAimEnabled",
    "BoxEspEnabled", "HealthbarEspEnabled", "ChamsEnabled", "NameEspEnabled",
    "DistanceEspEnabled", "SkeletonEnabled", "TracersEnabled", "CrosshairEnabled", "SpinCrosshairEnabled",
    "DamageNumbersEnabled", "SelfChamsEnabled", "CloneChamsEnabled", "OffscreenArrowsEnabled", "DeathChamsEnabled", "DeathBurstEnabled", "KillDissolveEnabled",
        "FullbrightEnabled", "FpsBoostEnabled", "DarkModeEnabled", "WorldColorEnabled", "NoShadowsEnabled", "HitMarkerEnabled", "ChinaHatEnabled", "AngelHaloEnabled", "OrbitOrbsEnabled", "TargetDotEnabled",
    "TrailEnabled", "FogEnabled", "NoFogEnabled", "SelfTransparencyEnabled", "FootstepsEnabled", "AspectRatioEnabled",
    "ThirdPersonEnabled", "ForceFieldEnabled", "WeaponForceFieldEnabled",
    "HitboxShow", "BulletTracersEnabled", "AuraEnabled", "ClassicPinkEnabled",
    "ClassicAngelEnabled", "SpeedHackEnabled", "MultiJumpEnabled", "AutoJumpEnabled", "NoclipEnabled",
    "FlyEnabled", "BHopEnabled", "StrafeEnabled", "AutoShiftEnabled", "CustomFireSoundEnabled", "ActiveListEnabled",
    "BindListEnabled", "FakeFpsEnabled",
}

function GetFeatureDisplayName(key)
    return FeatureNamesMapping[key] or key
end

function RegisterBindToggle(key, fn)
    if type(key) == "string" and type(fn) == "function" then
        Cache.BindToggles[key] = fn
    end
end

function ClearKeyFromOtherFeatures(keyName, exceptKey)
    if not Config.Keybinds then return end
    for k, v in pairs(Config.Keybinds) do
        if k ~= exceptKey and v == keyName then
            Config.Keybinds[k] = nil
        end
    end
end

function SetFeatureKeybind(featureKey, keyName)
    if not featureKey then return end
    Config.Keybinds = Config.Keybinds or {}
    if not keyName or keyName == "" or keyName == "Unknown" then
        Config.Keybinds[featureKey] = nil
    else
        ClearKeyFromOtherFeatures(keyName, featureKey)
        Config.Keybinds[featureKey] = keyName
    end
    if UpdateBindList then UpdateBindList() end
end

function ForceDisableFeature(featureKey)
    
    pcall(function()
        if featureKey == "ChamsEnabled" then
            for _, ch in pairs(Cache.Chams or {}) do
                if ch then ch.Enabled = false end
            end
            if Cache.ChamsPartFallback then
                for plr, map in pairs(Cache.ChamsPartFallback) do
                    for part, data in pairs(map) do
                        if part and part.Parent and data then
                            pcall(function()
                                part.Material = data.Material
                                part.Color = data.Color
                            end)
                        end
                    end
                end
            end
        elseif featureKey == "BoxEspEnabled" or featureKey == "BoxFillGradientEnabled" then
            for _, boxData in pairs(Cache.Boxes or {}) do
                if boxData then
                    if boxData.Outline then boxData.Outline.Visible = false end
                    if boxData.Box then boxData.Box.Visible = false end
                    if boxData.Fill then boxData.Fill.Visible = false end
                    if boxData.Gradients then
                        for _, g in pairs(boxData.Gradients) do if g then g.Visible = false end end
                    end
                    if boxData.OutlineGrad then
                        for _, g in pairs(boxData.OutlineGrad) do if g then g.Visible = false end end
                    end
                    if boxData.Corners then
                        for _, ln in pairs(boxData.Corners) do if ln then ln.Visible = false end end
                    end
                    if boxData.Box3D then
                        for _, ln in pairs(boxData.Box3D) do if ln then ln.Visible = false end end
                    end
                end
            end
        elseif featureKey == "HealthbarEspEnabled" then
            for _, hb in pairs(Cache.Healthbars or {}) do
                if hb then
                    if hb.Bg then hb.Bg.Visible = false end
                    if hb.Fill then hb.Fill.Visible = false end
                    if hb.Segs then
                        for _, s in pairs(hb.Segs) do if s then s.Visible = false end end
                    end
                end
            end
        elseif featureKey == "NameEspEnabled" or featureKey == "DistanceEspEnabled" then
            for _, t in pairs(Cache.EspLabels or {}) do if t then t.Visible = false end end
        elseif featureKey == "SkeletonEnabled" then
            for _, parts in pairs(Cache.Skeletons or {}) do
                if parts then for _, ln in pairs(parts) do if ln then ln.Visible = false end end end
            end
        elseif featureKey == "TracersEnabled" then
            for _, tr in pairs(Cache.TracerLines or {}) do
                if typeof(tr) == "table" and tr.Segs then
                    for _, ln in ipairs(tr.Segs) do if ln then ln.Visible = false end end
                elseif tr then tr.Visible = false end
            end
        elseif featureKey == "CrosshairEnabled" then
            if CrosshairX then CrosshairX.Visible = false end
            if CrosshairY then CrosshairY.Visible = false end
            pcall(function() UserInputService.MouseIconEnabled = true end)
        elseif featureKey == "ScopeEnabled" then
            Config.ScopeActive = false
            pcall(function() if Scope_Hide then Scope_Hide() end end)
        elseif featureKey == "ShowFovEnabled" then
            if FovCircle then FovCircle.Visible = false end
        elseif featureKey == "AimEnabled" then
            Cache.AimLockTarget = nil


pcall(function()
    if Cache.AnxiumAntiAimHB then Cache.AnxiumAntiAimHB:Disconnect() end
end)
Cache.AnxiumAntiAimHB = RunService.Heartbeat:Connect(function(dt)
    if Config and Config.AntiAimEnabled then
        pcall(AntiAim_Update, dt)
    end
end)

        elseif featureKey == "FullbrightEnabled" or featureKey == "DarkModeEnabled" or featureKey == "WorldColorEnabled" or featureKey == "NoShadowsEnabled" then
            pcall(ApplyWorldVisuals)
            if not Config.FullbrightEnabled and not Config.DarkModeEnabled and not Config.WorldColorEnabled then
                Lighting.Ambient = LightingDefaults.Ambient
                Lighting.ColorShift_Bottom = LightingDefaults.ColorShift_Bottom
                Lighting.ColorShift_Top = LightingDefaults.ColorShift_Top
                Lighting.Brightness = LightingDefaults.Brightness
                Lighting.OutdoorAmbient = LightingDefaults.OutdoorAmbient
            end
        elseif featureKey == "FogEnabled" then
            local fogAtm = Lighting:FindFirstChild("AnxiumFogAtmosphere")
            if fogAtm then fogAtm:Destroy() end
            Lighting.FogStart = LightingDefaults.FogStart
            Lighting.FogEnd = LightingDefaults.FogEnd
            Lighting.FogColor = LightingDefaults.FogColor
            Cache.FogWasOn = false
        elseif featureKey == "ChinaHatEnabled" then
            for _, ln in pairs(Cache.ChinaHatLines or {}) do if ln then ln.Visible = false end end
            for _, t in pairs(Cache.ChinaHatTris or {}) do if t then pcall(function() t.Visible = false end) end end
        elseif featureKey == "AngelHaloEnabled" then
            pcall(AngelHalo_Hide)
        elseif featureKey == "OrbitOrbsEnabled" then
            if OrbitPart1 then OrbitPart1.Parent = nil end
            if OrbitPart2 then OrbitPart2.Parent = nil end
        elseif featureKey == "TargetMarkerEnabled" then
            if TargetMarker_Hide then pcall(TargetMarker_Hide) end
        elseif featureKey == "TargetDotEnabled" then
            if TargetDot_Hide then pcall(TargetDot_Hide) end
        elseif featureKey == "TargetRingEnabled" then
            pcall(function() if TargetRing_Hide then TargetRing_Hide() end end)
        elseif featureKey == "TrailEnabled" then
            if Cache.PlayerTrail then Cache.PlayerTrail.Enabled = false end
        elseif featureKey == "ForceFieldEnabled" then
            if ForceField_Toggle then ForceField_Toggle(false)
            elseif SetForceFieldEnabled then SetForceFieldEnabled(false) end
        elseif featureKey == "WeaponForceFieldEnabled" then
            if WeaponFF_RestoreAll then WeaponFF_RestoreAll() end
        elseif featureKey == "ThirdPersonEnabled" then
            if ThirdPerson_Disable then ThirdPerson_Disable() end
        elseif featureKey == "FlyEnabled" then
            if FlyV3_Stop then pcall(FlyV3_Stop) end
        elseif featureKey == "ActiveListEnabled" then
            if ActiveListFrame then ActiveListFrame.Visible = false end
        elseif featureKey == "BindListEnabled" then
            if BindListFrame then BindListFrame.Visible = false end
        elseif featureKey == "FakeFpsEnabled" then
            pcall(UpdateFakeFpsDisplay)
        elseif featureKey == "TargetHudEnabled" then
            if TargetHudFrame then TargetHudFrame.Visible = false end
        elseif featureKey == "TargetLineEnabled" then
            if TargetLine_Hide then TargetLine_Hide() end
        end
    end)
end

function ToggleFeatureByBind(featureKey)
    if not featureKey then return false end
    local before = Config[featureKey]
    local fn = Cache.BindToggles and Cache.BindToggles[featureKey]
    if fn then
        local ok, err = pcall(fn)
        if not ok then
            warn("[Anxium] bind toggle error:", featureKey, err)
        end
    end
    
    if typeof(Config[featureKey]) == "boolean" and Config[featureKey] == before then
        Config[featureKey] = not before
        local ui = Cache.FeatureUI and Cache.FeatureUI[featureKey]
        if ui and ui.bg and ui.knob then
            UpdateSwitch(Config[featureKey], ui.bg, ui.knob, GetFeatureDisplayName(featureKey))
        else
            Notify("Bind", (GetFeatureDisplayName(featureKey)) .. (Config[featureKey] and " enabled" or " disabled"))
            if UpdateActiveList then UpdateActiveList() end
        end
    end
    
    if Config[featureKey] == false then
        ForceDisableFeature(featureKey)
    end
    if UpdateBindList then UpdateBindList() end
    if UpdateActiveList then UpdateActiveList() end
    return true
end


BindListFrame = Instance.new("Frame")
BindListFrame.Name = "BindListFrame"
BindListFrame.Size = UDim2.new(0, HUD_W, 0, HUD_H)
BindListFrame.Position = UDim2.new(0, 16, 0.38, 80)
BindListFrame.BackgroundColor3 = Theme.Bg
BindListFrame.BackgroundTransparency = tonumber(Config.BindListTransparency) or 0.05
BindListFrame.BorderSizePixel = 0
BindListFrame.ClipsDescendants = true
BindListFrame.Visible = Config.BindListEnabled == true
BindListFrame.Parent = ScreenGui
do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = BindListFrame
    local st = Instance.new("UIStroke")
    st.Name = "MenuStroke"
    st.Color = Theme.Stroke
    st.Thickness = 1
    st.Transparency = 0.35
    st.Parent = BindListFrame
    pcall(function() TrackThemeAccent(st, "Color") end)
end

BindHeader = Instance.new("Frame")
BindHeader.Name = "Header"
BindHeader.Size = UDim2.new(1, 0, 0, 28)
BindHeader.BackgroundColor3 = Theme.Sidebar
BindHeader.BackgroundTransparency = 0
BindHeader.BorderSizePixel = 0
BindHeader.Parent = BindListFrame

BindListIcon = Instance.new("ImageLabel")
BindListIcon.Name = "BindListIcon"
BindListIcon.AnchorPoint = Vector2.new(0, 0.5)
BindListIcon.Position = UDim2.new(0, 12, 0.5, 0)
BindListIcon.Size = UDim2.fromOffset(16, 16)
BindListIcon.BackgroundTransparency = 1
BindListIcon.BorderSizePixel = 0
BindListIcon.Image = "rbxassetid://121978468376124"
BindListIcon.ScaleType = Enum.ScaleType.Fit
BindListIcon.Parent = BindHeader

BindListTitle = Instance.new("TextLabel")
BindListTitle.Size = UDim2.new(1, -40, 1, 0)
BindListTitle.Position = UDim2.new(0, 32, 0, 0)
BindListTitle.BackgroundTransparency = 1
BindListTitle.Text = "Binds"
BindListTitle.TextColor3 = Theme.Text
BindListTitle.TextSize = 13
BindListTitle.Font = SelectedFont
BindListTitle.TextXAlignment = Enum.TextXAlignment.Left
BindListTitle.TextStrokeTransparency = 1
BindListTitle.Parent = BindHeader

do
    local bar = Instance.new("Frame")
    bar.Name = "AccentBar"
    bar.Size = UDim2.new(0, 3, 1, -8)
    bar.Position = UDim2.new(0, 0, 0, 4)
    bar.BackgroundColor3 = Theme.Accent
    bar.BorderSizePixel = 0
    bar.Parent = BindHeader
    pcall(function() TrackThemeAccent(bar, "BackgroundColor3") end)
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bar
end

BindListContainer = Instance.new("ScrollingFrame")
BindListContainer.Name = "BindListContainer"
BindListContainer.Size = UDim2.new(1, 0, 1, -28)
BindListContainer.Position = UDim2.new(0, 0, 0, 28)
BindListContainer.BackgroundColor3 = Theme.BgSecondary
BindListContainer.BackgroundTransparency = 0.15
BindListContainer.BorderSizePixel = 0
BindListContainer.ScrollBarThickness = 3
BindListContainer.ScrollBarImageColor3 = Theme.Accent
BindListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
BindListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
BindListContainer.Parent = BindListFrame

BindLayout = Instance.new("UIListLayout")
BindLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
BindLayout.Padding = UDim.new(0, 0)
BindLayout.Parent = BindListContainer
do
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 0)
    pad.PaddingBottom = UDim.new(0, 0)
    pad.Parent = BindListContainer
end

pcall(ApplyHudPanelTransparency)
MakeDraggable(BindListFrame, BindHeader)

UpdateBindList = function()
    if not Config.BindListEnabled then
        if BindListFrame then BindListFrame.Visible = false end
        return
    end
    BindListFrame.Visible = true
    for _, child in ipairs(BindListContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            if child:IsA("UIListLayout") or child:IsA("UIPadding") then
                
            else
                child:Destroy()
            end
        end
    end
    
    for _, child in ipairs(BindListContainer:GetChildren()) do
        if child:IsA("Frame") or (child:IsA("TextLabel") and child.Name ~= "LayoutPad") then
            child:Destroy()
        end
    end

    local count = 0
    local binds = Config.Keybinds or {}

    local function addRow(displayName, keyName, on)
        count = count + 1
        local row = Instance.new("Frame")
        row.Name = "BindRow"
        row.Size = UDim2.new(1, -4, 0, 16)
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.Parent = BindListContainer

        local left = Instance.new("TextLabel")
        left.Size = UDim2.new(1, -52, 1, 0)
        left.Position = UDim2.new(0, 0, 0, 0)
        left.BackgroundTransparency = 1
        left.BorderSizePixel = 0
        left.Text = displayName
        left.TextColor3 = Color3.fromRGB(255, 255, 255)
        left.TextSize = 11
        left.Font = SelectedFont
        left.TextXAlignment = Enum.TextXAlignment.Left
        left.TextTruncate = Enum.TextTruncate.AtEnd
        left.TextStrokeTransparency = 1
        left.Parent = row

        local right = Instance.new("TextLabel")
        right.Size = UDim2.new(0, 52, 1, 0)
        right.Position = UDim2.new(1, -52, 0, 0)
        right.BackgroundTransparency = 1
        right.BorderSizePixel = 0
        right.Text = tostring(keyName)
        right.TextColor3 = on and Theme.Accent or Theme.TextDim
        right.TextSize = 11
        right.Font = SelectedFont
        right.TextXAlignment = Enum.TextXAlignment.Right
        right.TextStrokeTransparency = 1
        right.Parent = row
    end

    for _, key in ipairs(BindableFeatureOrder) do
        local keyName = binds[key]
        if keyName and keyName ~= "" then
            addRow(GetFeatureDisplayName(key), keyName, Config[key] == true)
        end
    end
    for key, keyName in pairs(binds) do
        local inOrder = false
        for _, k in ipairs(BindableFeatureOrder) do
            if k == key then inOrder = true break end
        end
        if not inOrder and keyName and keyName ~= "" then
            addRow(GetFeatureDisplayName(key), keyName, Config[key] == true)
        end
    end
    if count == 0 then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -10, 0, 16)
        lbl.BackgroundTransparency = 1
        lbl.Text = "No binds set"
        lbl.TextColor3 = Theme.TextDim
        lbl.TextSize = 11
        lbl.Font = SelectedFont
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = BindListContainer
        count = 1
    end
    BindListFrame.Size = UDim2.new(0, HUD_W or 180, 0, HUD_H or 148)
end

local function GetInputBindName(input)
    if not input then return nil end
    local uit = input.UserInputType
    if uit == Enum.UserInputType.Keyboard then
        local kc = input.KeyCode
        if kc and kc ~= Enum.KeyCode.Unknown then
            return kc.Name
        end
        return nil
    end
    if uit == Enum.UserInputType.MouseButton1 then return "MouseButton1" end
    if uit == Enum.UserInputType.MouseButton2 then return "MouseButton2" end
    if uit == Enum.UserInputType.MouseButton3 then return "MouseButton3" end
    return nil
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    local keyName = GetInputBindName(input)
    if not keyName then return end
    if tick() < (Cache.BindIgnoreUntil or 0) then return end

    local isKeyboard = input.UserInputType == Enum.UserInputType.Keyboard

    
    if Cache.WaitingMenuKey then
        if not isKeyboard then return end
        if tick() < (Cache.MenuKeyIgnoreUntil or 0) then return end
        Cache.WaitingMenuKey = false
        if keyName == "Escape" then
            Notify("Menu", "Bind cancelled")
            return
        end
        if keyName == "Backspace" or keyName == "Delete" then
            Config.MenuKey = "Insert"
            if Cache.MenuKeyLabel then
                Cache.MenuKeyLabel.Text = "[Insert]"
            end
            Notify("Menu", "Menu key reset to [Insert]")
            return
        end
        Config.MenuKey = keyName
        if Cache.MenuKeyLabel then
            Cache.MenuKeyLabel.Text = "[" .. keyName .. "]"
        end
        Notify("Menu", "Open key: [" .. keyName .. "]")
        return
    end

    
    if Cache.WaitingScopeKey then
        if tick() < (Cache.ScopeKeyIgnoreUntil or 0) then return end
        
        Cache.WaitingScopeKey = false
        if keyName == "Escape" then
            Notify("Scope", "Cancelled")
            return
        end
        Config.ScopeKey = keyName
        if Cache.ScopeKeyLabel then
            Cache.ScopeKeyLabel.Text = "[" .. keyName .. "]"
        end
        Notify("Scope", "ADS key: [" .. keyName .. "]")
        return
    end


    
    if Cache.WaitingBindKey then
        if not isKeyboard then return end
        local feat = Cache.WaitingBindKey
        Cache.WaitingBindKey = nil
        if keyName == "Escape" then
            Notify("Binds", "Bind cancelled")
            return
        end
        if keyName == "Backspace" or keyName == "Delete" then
            SetFeatureKeybind(feat, nil)
            Notify("Binds", GetFeatureDisplayName(feat) .. " bind cleared")
            return
        end
        SetFeatureKeybind(feat, keyName)
        Notify("Binds", GetFeatureDisplayName(feat) .. " → [" .. keyName .. "]")
        return
    end

    if gameProcessed and isKeyboard then return end

    
    if Config.ScopeEnabled and Config.ScopeKey and Config.ScopeKey ~= "" and keyName == Config.ScopeKey then
        if (Config.ScopeMode or "Hold") == "Toggle" then
            Scope_SetActive(not Config.ScopeActive)
        else
            Scope_SetActive(true)
        end
    end


    if not isKeyboard then return end

    
    local binds = Config.Keybinds or {}
    for feat, kn in pairs(binds) do
        if kn == keyName then
            if feat == "PeekAssist" then
                pcall(PeekAssist_Activate)
            else
                ToggleFeatureByBind(feat)
            end
            break
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    local keyName = GetInputBindName(input)
    if not keyName then return end
    if Config.ScopeEnabled and Config.ScopeKey and Config.ScopeKey ~= "" and keyName == Config.ScopeKey then
        if (Config.ScopeMode or "Hold") == "Hold" then
            Scope_SetActive(false)
        end
    end
end)

function StartListeningBind(featureKey)
    if not featureKey then return end
    Cache.WaitingBindKey = featureKey
    Cache.BindIgnoreUntil = tick() + 0.2
    Notify("Binds", "Press a key for " .. GetFeatureDisplayName(featureKey) .. " (Esc cancel, Backspace clear)")
end


CreateBindRow = function(featureKey, layoutOrder, parentTab)
    local name = GetFeatureDisplayName(featureKey)
    local host = ResolveUIParent(parentTab)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 30)
    Row.BackgroundColor3 = Theme.Card
    Row.BackgroundTransparency = 0
    Row.BorderSizePixel = 0
    Row.LayoutOrder = layoutOrder
    Row.Parent = host
    Row.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 12
    Label.Font = SelectedFont
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local KeyLbl = Instance.new("TextLabel")
    KeyLbl.Name = "KeyLbl"
    KeyLbl.Size = UDim2.new(0, 70, 0, 22)
    KeyLbl.Position = UDim2.new(1, -150, 0.5, -11)
    KeyLbl.BackgroundColor3 = Theme.BgTertiary
    KeyLbl.BorderSizePixel = 0
    KeyLbl.Text = (Config.Keybinds and Config.Keybinds[featureKey]) and ("[" .. Config.Keybinds[featureKey] .. "]") or "[-]"
    KeyLbl.TextColor3 = Theme.TextDim
    KeyLbl.TextSize = 11
    KeyLbl.Font = SelectedFont
    KeyLbl.Parent = Row

    local SetBtn = Instance.new("TextButton")
    SetBtn.Size = UDim2.new(0, 44, 0, 22)
    SetBtn.Position = UDim2.new(1, -72, 0.5, -11)
    SetBtn.BackgroundColor3 = Theme.Accent
    pcall(function() TrackThemeAccent(SetBtn, "BackgroundColor3") end)
    SetBtn.BorderSizePixel = 0
    SetBtn.Text = "Set"
    SetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SetBtn.TextSize = 11
    SetBtn.Font = SelectedFont
    SetBtn.Parent = Row

    local ClrBtn = Instance.new("TextButton")
    ClrBtn.Size = UDim2.new(0, 22, 0, 22)
    ClrBtn.Position = UDim2.new(1, -24, 0.5, -11)
    ClrBtn.BackgroundColor3 = Theme.BgTertiary
    ClrBtn.BorderSizePixel = 0
    ClrBtn.Text = "×"
    ClrBtn.TextColor3 = Theme.Text
    ClrBtn.TextSize = 14
    ClrBtn.Font = SelectedFont
    ClrBtn.Parent = Row

    SetBtn.MouseButton1Click:Connect(function()
        StartListeningBind(featureKey)
    end)
    ClrBtn.MouseButton1Click:Connect(function()
        SetFeatureKeybind(featureKey, nil)
        KeyLbl.Text = "[-]"
        Notify("Binds", name .. " bind cleared")
    end)

    Cache.BindKeyLabels = Cache.BindKeyLabels or {}
    Cache.BindKeyLabels[featureKey] = KeyLbl
    Cache.BindRows = Cache.BindRows or {}
    table.insert(Cache.BindRows, { Row = Row, Key = featureKey, Name = name:lower() })
    pcall(function() Row:SetAttribute("AnxiumBindRow", featureKey) end)
end

function RefreshBindKeyLabels()
    if not Cache.BindKeyLabels then return end
    for key, lbl in pairs(Cache.BindKeyLabels) do
        if lbl and lbl.Parent then
            local kn = Config.Keybinds and Config.Keybinds[key]
            lbl.Text = kn and ("[" .. kn .. "]") or "[-]"
        end
    end
end


local _oldUpdateBindList = UpdateBindList
UpdateBindList = function()
    _oldUpdateBindList()
    RefreshBindKeyLabels()
end


Cache.WM_LOGO_URL = "https://raw.githubusercontent.com/AnxiumClient/png/main/photo_2026-09-13_13-05-41.jpg"
Cache.WM_LOGO_FILE = "Anxium_wm_logo.jpg"
Cache.WM_H = 28
Cache.WM_PAD = 6
Cache.WM_LOGO = 26
Cache.WM_W = 318
Cache.WM_TITLE_W = 58
Cache.WM_FPS_W = 70
Cache.WM_TG_W = 118
Cache.WM_SEP_W = 10

WatermarkFrame = Instance.new("Frame")
WatermarkFrame.Name = "WatermarkFrame"
WatermarkFrame.Size = UDim2.fromOffset(Cache.WM_W, Cache.WM_H)
WatermarkFrame.Position = UDim2.new(0.5, -math.floor(Cache.WM_W / 2), 0, 10)
WatermarkFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
WatermarkFrame.BackgroundTransparency = 0.05
WatermarkFrame.BorderSizePixel = 0
WatermarkFrame.ClipsDescendants = false
WatermarkFrame.Parent = ScreenGui

WatermarkStroke = Instance.new("UIStroke")
WatermarkStroke.Color = Color3.fromRGB(0, 0, 0)
WatermarkStroke.Thickness = 1
WatermarkStroke.Transparency = 0.35
WatermarkStroke.Parent = WatermarkFrame

WatermarkCorner = nil

WatermarkLogo = Instance.new("ImageLabel")
WatermarkLogo.Name = "Logo"
WatermarkLogo.Size = UDim2.fromOffset(Cache.WM_LOGO, Cache.WM_LOGO)
WatermarkLogo.Position = UDim2.new(0, Cache.WM_PAD, 0.5, -math.floor(Cache.WM_LOGO / 2))
WatermarkLogo.BackgroundTransparency = 1
WatermarkLogo.BorderSizePixel = 0
WatermarkLogo.ScaleType = Enum.ScaleType.Fit
WatermarkLogo.Image = ""
WatermarkLogo.Parent = WatermarkFrame
pcall(function()
    WatermarkLogo.ResampleMode = Enum.ResamplerMode.Pixelated
end)
do
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 4)
    lc.Parent = WatermarkLogo
end

WatermarkLabel = Instance.new("TextLabel")
WatermarkLabel.Name = "WatermarkTitle"
WatermarkLabel.BackgroundTransparency = 1
WatermarkLabel.Text = "ANXIUM"
WatermarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkLabel.TextSize = 12
WatermarkLabel.Font = SelectedFont
WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
WatermarkLabel.TextYAlignment = Enum.TextYAlignment.Center
WatermarkLabel.Parent = WatermarkFrame

WatermarkSep = Instance.new("TextLabel")
WatermarkSep.Name = "WatermarkSep"
WatermarkSep.BackgroundTransparency = 1
WatermarkSep.Text = "|"
WatermarkSep.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkSep.TextSize = 12
WatermarkSep.Font = SelectedFont
WatermarkSep.TextXAlignment = Enum.TextXAlignment.Center
WatermarkSep.TextYAlignment = Enum.TextYAlignment.Center
WatermarkSep.Parent = WatermarkFrame

WatermarkFpsLabel = Instance.new("TextLabel")
WatermarkFpsLabel.Name = "WatermarkFps"
WatermarkFpsLabel.BackgroundTransparency = 1
WatermarkFpsLabel.Text = "fps: --"
WatermarkFpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkFpsLabel.TextSize = 12
WatermarkFpsLabel.Font = SelectedFont
WatermarkFpsLabel.TextXAlignment = Enum.TextXAlignment.Left
WatermarkFpsLabel.TextYAlignment = Enum.TextYAlignment.Center
WatermarkFpsLabel.Parent = WatermarkFrame

WatermarkSep2 = Instance.new("TextLabel")
WatermarkSep2.Name = "WatermarkSep2"
WatermarkSep2.BackgroundTransparency = 1
WatermarkSep2.Text = "|"
WatermarkSep2.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkSep2.TextSize = 12
WatermarkSep2.Font = SelectedFont
WatermarkSep2.TextXAlignment = Enum.TextXAlignment.Center
WatermarkSep2.TextYAlignment = Enum.TextYAlignment.Center
WatermarkSep2.Parent = WatermarkFrame

WatermarkTgLabel = Instance.new("TextLabel")
WatermarkTgLabel.Name = "WatermarkTg"
WatermarkTgLabel.BackgroundTransparency = 1
WatermarkTgLabel.Text = "t.me/AnxiumHub"
WatermarkTgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkTgLabel.TextSize = 12
WatermarkTgLabel.Font = SelectedFont
WatermarkTgLabel.TextXAlignment = Enum.TextXAlignment.Left
WatermarkTgLabel.TextYAlignment = Enum.TextYAlignment.Center
WatermarkTgLabel.Parent = WatermarkFrame

function WatermarkGrad_FromTheme()
    local a = (Theme and Theme.Accent) or Color3.fromRGB(160, 120, 255)
    local mid = Color3.new(
        a.R + (1 - a.R) * 0.45,
        a.G + (1 - a.G) * 0.45,
        a.B + (1 - a.B) * 0.45
    )
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, a),
        ColorSequenceKeypoint.new(0.55, mid),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
end

WatermarkGrad = Instance.new("UIGradient")
WatermarkGrad.Color = WatermarkGrad_FromTheme()
WatermarkGrad.Parent = WatermarkTgLabel

WatermarkFpsIcon = Instance.new("ImageLabel")
WatermarkFpsIcon.Name = "FpsIcon"
WatermarkFpsIcon.BackgroundTransparency = 1
WatermarkFpsIcon.Size = UDim2.fromOffset(14, 14)
WatermarkFpsIcon.Image = "rbxassetid://137527339160230"
WatermarkFpsIcon.ScaleType = Enum.ScaleType.Fit
WatermarkFpsIcon.Parent = WatermarkFrame

WatermarkTgIcon = Instance.new("ImageLabel")
WatermarkTgIcon.Name = "TgIcon"
WatermarkTgIcon.BackgroundTransparency = 1
WatermarkTgIcon.Size = UDim2.fromOffset(14, 14)
WatermarkTgIcon.Image = "rbxassetid://86131768436965"
WatermarkTgIcon.ScaleType = Enum.ScaleType.Fit
WatermarkTgIcon.Parent = WatermarkFrame

WatermarkCfgIcon = Instance.new("ImageLabel")
WatermarkCfgIcon.Name = "CfgIcon"
WatermarkCfgIcon.BackgroundTransparency = 1
WatermarkCfgIcon.Size = UDim2.fromOffset(14, 14)
WatermarkCfgIcon.Image = "rbxassetid://98868866618869"
WatermarkCfgIcon.ScaleType = Enum.ScaleType.Fit
WatermarkCfgIcon.Parent = WatermarkFrame

WatermarkCfgLabel = Instance.new("TextLabel")
WatermarkCfgLabel.Name = "WatermarkCfg"
WatermarkCfgLabel.BackgroundTransparency = 1
WatermarkCfgLabel.Text = "default"
WatermarkCfgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkCfgLabel.TextSize = 12
WatermarkCfgLabel.Font = SelectedFont
WatermarkCfgLabel.TextXAlignment = Enum.TextXAlignment.Left
WatermarkCfgLabel.TextYAlignment = Enum.TextYAlignment.Center
WatermarkCfgLabel.Parent = WatermarkFrame


function LayoutWatermark()
    if not WatermarkFrame then return end
    local h = Cache.WM_H or 28
    local pad = Cache.WM_PAD or 6
    local logo = Cache.WM_LOGO or 26
    local gap = 6
    local icon = 14
    local x = pad + logo + 8
    if WatermarkLogo then
        WatermarkLogo.Size = UDim2.fromOffset(logo, logo)
        WatermarkLogo.Position = UDim2.new(0, pad, 0.5, -math.floor(logo / 2))
    end
    if WatermarkLabel then
        WatermarkLabel.Size = UDim2.fromOffset(56, h)
        WatermarkLabel.Position = UDim2.fromOffset(x, 0)
        WatermarkLabel.Text = "ANXIUM"
        WatermarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    x = x + 56 + gap
    
    if WatermarkSep then WatermarkSep.Visible = false end
    if WatermarkSep2 then WatermarkSep2.Visible = false end
    if WatermarkFpsIcon then
        WatermarkFpsIcon.Size = UDim2.fromOffset(icon, icon)
        WatermarkFpsIcon.Position = UDim2.new(0, x, 0.5, -math.floor(icon / 2))
        WatermarkFpsIcon.Visible = true
    end
    x = x + icon + 3
    if WatermarkFpsLabel then
        WatermarkFpsLabel.Size = UDim2.fromOffset(64, h)
        WatermarkFpsLabel.Position = UDim2.fromOffset(x, 0)
        WatermarkFpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    x = x + 64 + gap
    if WatermarkTgIcon then
        WatermarkTgIcon.Size = UDim2.fromOffset(icon, icon)
        WatermarkTgIcon.Position = UDim2.new(0, x, 0.5, -math.floor(icon / 2))
        WatermarkTgIcon.Visible = true
    end
    x = x + icon + 3
    if WatermarkTgLabel then
        WatermarkTgLabel.Size = UDim2.fromOffset(110, h)
        WatermarkTgLabel.Position = UDim2.fromOffset(x, 0)
        WatermarkTgLabel.Text = "t.me/AnxiumHub"
        WatermarkTgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    x = x + 110 + gap
    if WatermarkCfgIcon then
        WatermarkCfgIcon.Size = UDim2.fromOffset(icon, icon)
        WatermarkCfgIcon.Position = UDim2.new(0, x, 0.5, -math.floor(icon / 2))
        WatermarkCfgIcon.Visible = true
    end
    x = x + icon + 3
    local cfgName = "none"
    pcall(function()
        if CfgIO and CfgIO.Current and tostring(CfgIO.Current) ~= "" then
            cfgName = tostring(CfgIO.Current)
        elseif Config.CurrentConfigName then
            cfgName = tostring(Config.CurrentConfigName)
        end
    end)
    if WatermarkCfgLabel then
        WatermarkCfgLabel.Text = cfgName
        WatermarkCfgLabel.Size = UDim2.fromOffset(math.clamp(#cfgName * 7 + 8, 40, 140), h)
        WatermarkCfgLabel.Position = UDim2.fromOffset(x, 0)
        WatermarkCfgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        x = x + WatermarkCfgLabel.Size.X.Offset + pad
    else
        x = x + 50 + pad
    end
    Cache.WM_W = math.max(x, 280)
    WatermarkFrame.Size = UDim2.fromOffset(Cache.WM_W, h)
    WatermarkFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    WatermarkFrame.BackgroundTransparency = 0.05
    if WatermarkGrad then
        WatermarkGrad.Color = WatermarkGrad_FromTheme and WatermarkGrad_FromTheme() or ColorSequence.new(Theme.Accent, Color3.fromRGB(255, 255, 255))
    end
end
Cache.LayoutWatermark = LayoutWatermark

function UpdateWatermarkPosition()
    if not WatermarkFrame then return end
    LayoutWatermark()

    local pos = Config.WatermarkPosition or "Center"
    local validPositions = {
        Left = true,
        Center = true,
        Right = true,
        BottomLeft = true,
        BottomCenter = true,
        BottomRight = true
    }

    if not validPositions[pos] then
        pos = "Center"
        Config.WatermarkPosition = pos
    end

    local sidePadding = 16
    local verticalPadding = 12

    if pos == "Left" then
        WatermarkFrame.AnchorPoint = Vector2.new(0, 0)
        WatermarkFrame.Position = UDim2.new(0, sidePadding, 0, verticalPadding)
    elseif pos == "Right" then
        WatermarkFrame.AnchorPoint = Vector2.new(1, 0)
        WatermarkFrame.Position = UDim2.new(1, -sidePadding, 0, verticalPadding)
    elseif pos == "BottomLeft" then
        WatermarkFrame.AnchorPoint = Vector2.new(0, 1)
        WatermarkFrame.Position = UDim2.new(0, sidePadding, 1, -verticalPadding)
    elseif pos == "BottomRight" then
        WatermarkFrame.AnchorPoint = Vector2.new(1, 1)
        WatermarkFrame.Position = UDim2.new(1, -sidePadding, 1, -verticalPadding)
    elseif pos == "BottomCenter" then
        WatermarkFrame.AnchorPoint = Vector2.new(0.5, 1)
        WatermarkFrame.Position = UDim2.new(0.5, 0, 1, -verticalPadding)
    else
        WatermarkFrame.AnchorPoint = Vector2.new(0.5, 0)
        WatermarkFrame.Position = UDim2.new(0.5, 0, 0, verticalPadding)
    end
end
Cache.UpdateWatermarkPosition = UpdateWatermarkPosition


Cache.WmFpsFrames = 0
Cache.WmFpsLast = tick()
Cache.WmFpsValue = 0
RunService.RenderStepped:Connect(function()
    
    pcall(function()
        if Config.AspectRatioEnabled and AspectRatio_Apply then
            AspectRatio_Apply()
        end
    end)
    Cache.WmFpsFrames = (Cache.WmFpsFrames or 0) + 1
    local now = tick()
    if now - (Cache.WmFpsLast or now) >= 0.5 then
        local realFps = math.floor(Cache.WmFpsFrames / (now - Cache.WmFpsLast) + 0.5)
        Cache.WmFpsLast = now
        Cache.WmFpsFrames = 0
        Cache.WmFpsValue = realFps
        if WatermarkFpsLabel then
            local shown = realFps
            if Config.FakeFpsEnabled then
                shown = tonumber(Config.FakeFpsValue) or realFps
            end
            WatermarkFpsLabel.Text = "fps: " .. tostring(shown)
        end
    end
end)

task.spawn(function()
    local asset = nil
    pcall(function()
        if typeof(getcustomasset) == "function" then
            local onDisk = false
            if typeof(isfile) == "function" then
                pcall(function() onDisk = isfile(Cache.WM_LOGO_FILE) end)
            end
            if not onDisk and typeof(writefile) == "function" then
                local ok, body = pcall(function() return game:HttpGet(Cache.WM_LOGO_URL) end)
                if ok and body and #body > 0 then
                    pcall(writefile, Cache.WM_LOGO_FILE, body)
                end
            end
            local okA, a = pcall(function() return getcustomasset(Cache.WM_LOGO_FILE) end)
            if okA and a then asset = a end
        end
    end)
    if not asset then asset = Cache.WM_LOGO_URL end
    if WatermarkLogo then
        WatermarkLogo.Image = tostring(asset)
    end
end)

task.defer(function()
    task.wait(0.1)
    pcall(UpdateWatermarkPosition)
end)


FAKE_FPS_OPTIONS = { 67, 1488, 69, 333, 1337, 666 }
FakeFpsFrame = nil
FakeFpsLabel = nil

function UpdateFakeFpsDisplay()
    if WatermarkFpsLabel then
        if Config.FakeFpsEnabled then
            WatermarkFpsLabel.Text = "fps: " .. tostring(Config.FakeFpsValue or 67)
        else
            local real = Cache.WmFpsValue
            if type(real) == "number" and real > 0 then
                WatermarkFpsLabel.Text = "fps: " .. tostring(real)
            end
        end
    end
end

FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1.5
FovCircle.NumSides = 96
FovCircle.Radius = Config.FovRadius
FovCircle.Filled = false
FovCircle.Visible = false
FovCircle.Color = Config.Color_Fov or Theme.Accent
FovCircleFill = Drawing.new("Circle")
FovCircleFill.Thickness = 0
FovCircleFill.NumSides = 96
FovCircleFill.Radius = Config.FovRadius
FovCircleFill.Filled = true
FovCircleFill.Visible = false
FovCircleFill.Color = Config.Color_FovFill or Config.Color_Fov or Theme.Accent
FovCircleFill.Transparency = Config.FovFillTransparency or 0.7
FovCircleFill.ZIndex = 1

Cache.CameraFovOld = nil
Cache.CameraFovConn = nil

Cache.DayCycleOld = Cache.DayCycleOld or nil
function DayCycle_Apply(saveBase)
    local t = tonumber(Config.DayCycleTime)
    if t == nil then t = 14 end
    t = math.clamp(t, 0, 24)
    Config.DayCycleTime = t
    if saveBase and Cache.DayCycleOld == nil then
        Cache.DayCycleOld = Lighting.ClockTime
    end
    pcall(function()
        Lighting.ClockTime = t
        
        local h = math.floor(t) % 24
        local m = math.floor((t - math.floor(t)) * 60)
        local s = math.floor((((t - math.floor(t)) * 60) - m) * 60)
        Lighting.TimeOfDay = string.format("%02d:%02d:%02d", h, m, s)
    end)
end
function DayCycle_Restore()
    if Cache.DayCycleOld ~= nil then
        pcall(function() Lighting.ClockTime = Cache.DayCycleOld end)
        Cache.DayCycleOld = nil
    end
end

function CameraFov_Apply()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    if Config.CameraFovEnabled then
        if Cache.CameraFovOld == nil then
            Cache.CameraFovOld = cam.FieldOfView
        end
        cam.FieldOfView = tonumber(Config.CameraFovValue) or 120
        if not Cache.CameraFovConn then
            Cache.CameraFovConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
                
                if Config.ScopeEnabled and Config.ScopeActive then return end
                if Config.CameraFovEnabled and Workspace.CurrentCamera then
                    Workspace.CurrentCamera.FieldOfView = tonumber(Config.CameraFovValue) or 120
                end
            end)
        end
    else
        if Cache.CameraFovConn then
            pcall(function() Cache.CameraFovConn:Disconnect() end)
            Cache.CameraFovConn = nil
        end
        if Cache.CameraFovOld ~= nil then
            pcall(function() cam.FieldOfView = Cache.CameraFovOld end)
            Cache.CameraFovOld = nil
        end
    end
end

Cache.FpsBoostModified = Cache.FpsBoostModified or {}
Cache.FpsBoostConns = Cache.FpsBoostConns or {}
Cache.FpsBoostToken = 0
Cache.FpsBoostLightingSaved = nil

function FpsBoost_Remember(inst, prop, newVal)
    if not inst then return end
    local bag = Cache.FpsBoostModified[inst]
    if not bag then
        bag = {}
        Cache.FpsBoostModified[inst] = bag
    end
    if bag[prop] == nil then
        local ok, old = pcall(function() return inst[prop] end)
        if ok then bag[prop] = old end
    end
    pcall(function() inst[prop] = newVal end)
end

function FpsBoost_StripPart(part)
    if not part or not part:IsA("BasePart") then return end
    pcall(function() FpsBoost_Remember(part, "Material", Enum.Material.SmoothPlastic) end)
    for _, ch in ipairs(part:GetChildren()) do
        if ch:IsA("Texture") or ch:IsA("Decal") then
            FpsBoost_Remember(ch, "Transparency", 1)
            pcall(function() FpsBoost_Remember(ch, "Texture", "") end)
        elseif ch:IsA("SurfaceAppearance") then
            pcall(function() ch:Destroy() end)
        end
    end
    if part:IsA("MeshPart") then
        pcall(function() FpsBoost_Remember(part, "TextureID", "") end)
    end
end

function FpsBoost_KillEffect(obj)
    if not obj then return end
    if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        FpsBoost_Remember(obj, "Enabled", false)
    elseif obj:IsA("Trail") or obj:IsA("Beam") then
        FpsBoost_Remember(obj, "Enabled", false)
    end
end

function FpsBoost_ApplyLighting()
    if not Cache.FpsBoostLightingSaved then
        Cache.FpsBoostLightingSaved = {
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            FogColor = Lighting.FogColor,
            GlobalShadows = Lighting.GlobalShadows,
            EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        }
    end
    pcall(function()
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)
    for _, ch in ipairs(Lighting:GetChildren()) do
        if ch:IsA("Atmosphere") then
            FpsBoost_Remember(ch, "Density", 0)
            FpsBoost_Remember(ch, "Haze", 0)
            FpsBoost_Remember(ch, "Glare", 0)
        elseif ch:IsA("BloomEffect") or ch:IsA("BlurEffect") or ch:IsA("SunRaysEffect")
            or ch:IsA("ColorCorrectionEffect") or ch:IsA("DepthOfFieldEffect") then
            FpsBoost_Remember(ch, "Enabled", false)
        elseif ch:IsA("Clouds") then
            FpsBoost_Remember(ch, "Enabled", false)
        end
    end
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        pcall(function() terrain.Decoration = false end)
    end
end

function FpsBoost_Restore()
    for inst, bag in pairs(Cache.FpsBoostModified) do
        if inst and inst.Parent then
            for prop, old in pairs(bag) do
                pcall(function() inst[prop] = old end)
            end
        end
    end
    table.clear(Cache.FpsBoostModified)
    local s = Cache.FpsBoostLightingSaved
    if s then
        pcall(function()
            Lighting.FogEnd = s.FogEnd
            Lighting.FogStart = s.FogStart
            Lighting.FogColor = s.FogColor
            Lighting.GlobalShadows = s.GlobalShadows
            Lighting.EnvironmentDiffuseScale = s.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = s.EnvironmentSpecularScale
        end)
    end
    Cache.FpsBoostLightingSaved = nil
end

function FpsBoost_Stop()
    Cache.FpsBoostToken = (Cache.FpsBoostToken or 0) + 1
    for _, c in ipairs(Cache.FpsBoostConns or {}) do
        pcall(function() c:Disconnect() end)
    end
    Cache.FpsBoostConns = {}
    FpsBoost_Restore()
end

function FpsBoost_Start()
    FpsBoost_Stop()
    if not Config.FpsBoostEnabled then return end
    Cache.FpsBoostToken = (Cache.FpsBoostToken or 0) + 1
    local token = Cache.FpsBoostToken
    FpsBoost_ApplyLighting()
    task.spawn(function()
        local n = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if token ~= Cache.FpsBoostToken or not Config.FpsBoostEnabled then return end
            if obj:IsA("BasePart") then
                FpsBoost_StripPart(obj)
            else
                FpsBoost_KillEffect(obj)
            end
            n = n + 1
            if n % 400 == 0 then task.wait() end
        end
    end)
    table.insert(Cache.FpsBoostConns, Workspace.DescendantAdded:Connect(function(obj)
        if not Config.FpsBoostEnabled then return end
        task.defer(function()
            if obj:IsA("BasePart") then
                FpsBoost_StripPart(obj)
            else
                FpsBoost_KillEffect(obj)
            end
        end)
    end))
    table.insert(Cache.FpsBoostConns, Lighting.DescendantAdded:Connect(function(obj)
        if not Config.FpsBoostEnabled then return end
        task.defer(function()
            if obj:IsA("Atmosphere") then
                pcall(function()
                    obj.Density = 0
                    obj.Haze = 0
                end)
            elseif obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect")
                or obj:IsA("DepthOfFieldEffect") or obj:IsA("ColorCorrectionEffect") then
                pcall(function() obj.Enabled = false end)
            end
        end)
    end))
end

function FpsBoost_Apply()
    if Config.FpsBoostEnabled then
        FpsBoost_Start()
    else
        FpsBoost_Stop()
    end
end

Cache.AutoShiftHeld = false
function AutoShift_Release()
    if not Cache.AutoShiftHeld then return end
    Cache.AutoShiftHeld = false
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
    end)
end

function AutoShift_Hold()
    if Cache.AutoShiftHeld then return end
    Cache.AutoShiftHeld = true
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
    end)
end

function AutoShift_Apply()
    if Config.AutoShiftEnabled then
        AutoShift_Hold()
    else
        AutoShift_Release()
    end
end

Cache.WeaponAutoSwapToken = 0
Cache.WeaponAutoSwapIndex = 0

function WeaponAutoSwap_NormalizeSlots()
    local src = Config.WeaponAutoSwapSlots
    local out = {}
    if type(src) == "table" then
        for _, v in ipairs(src) do
            local n = math.floor(tonumber(v) or 0)
            if n >= 1 and n <= 9 then
                table.insert(out, n)
            end
        end
    end
    Config.WeaponAutoSwapSlots = out
    return out
end

function WeaponAutoSwap_EquipSlot(slot)
    slot = math.clamp(math.floor(tonumber(slot) or 1), 1, 9)
    local keyMap = {
        Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three,
        Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six,
        Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine,
    }
    local key = keyMap[slot]
    if not key then return false end
    local ok = pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, key, false, game)
        task.wait(0.03)
        vim:SendKeyEvent(false, key, false, game)
    end)
    return ok
end

function WeaponAutoSwap_Stop()
    Cache.WeaponAutoSwapToken = (Cache.WeaponAutoSwapToken or 0) + 1
end

function WeaponAutoSwap_Start()
    WeaponAutoSwap_Stop()
    if not Config.WeaponAutoSwapEnabled then return end
    local slots = WeaponAutoSwap_NormalizeSlots()
    if #slots == 0 then
        Notify("Weapon Auto Swap", "Add at least one slot number")
        Config.WeaponAutoSwapEnabled = false
        if WeaponAutoSwapBg and WeaponAutoSwapKnob then
            pcall(function() UpdateSwitch(false, WeaponAutoSwapBg, WeaponAutoSwapKnob) end)
        end
        return
    end
    Cache.WeaponAutoSwapToken = (Cache.WeaponAutoSwapToken or 0) + 1
    local token = Cache.WeaponAutoSwapToken
    Cache.WeaponAutoSwapIndex = 0
    task.spawn(function()
        while Config.WeaponAutoSwapEnabled and Cache.WeaponAutoSwapToken == token do
            local slotsNow = WeaponAutoSwap_NormalizeSlots()
            if #slotsNow == 0 then break end
            Cache.WeaponAutoSwapIndex = (Cache.WeaponAutoSwapIndex or 0) % #slotsNow + 1
            local slot = slotsNow[Cache.WeaponAutoSwapIndex]
            WeaponAutoSwap_EquipSlot(slot)
            local ms = math.clamp(tonumber(Config.WeaponAutoSwapSpeed) or 150, 30, 2000)
            task.wait(ms / 1000)
        end
    end)
end

function WeaponAutoSwap_Apply()
    if Config.WeaponAutoSwapEnabled then
        WeaponAutoSwap_Start()
    else
        WeaponAutoSwap_Stop()
    end
end


if not Cache.AutoShiftHB then
    Cache.AutoShiftHB = RunService.Heartbeat:Connect(function()
        if Config and Config.AutoShiftEnabled then
            if not Cache.AutoShiftHeld then
                AutoShift_Hold()
            end
        elseif Cache.AutoShiftHeld then
            AutoShift_Release()
        end
    end)
end

TargetLineDraw = nil
if Drawing then
    pcall(function()
        TargetLineDraw = Drawing.new("Line")
        TargetLineDraw.Visible = false
        TargetLineDraw.Thickness = 1.8
        TargetLineDraw.Color = Config.Color_TargetLine or Color3.fromRGB(255, 100, 140)
        TargetLineDraw.Transparency = Config.TargetLineTransparency or 0.15
        TargetLineDraw.ZIndex = 4
    end)
end

function TargetLine_IsAlivePlayer(plr)
    if not plr or not plr.Parent or plr == LocalPlayer then return false end
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    return true
end

function TargetLine_GetClosestEnemy()
    local cam = Workspace.CurrentCamera
    local myChar = LocalPlayer.Character
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Head"))
    if not cam or not myRoot then return nil end
    local best, bestDist = nil, math.huge
    for _, plr in ipairs((CachedPlayerList or Players:GetPlayers())) do
        if TargetLine_IsAlivePlayer(plr) then
            local skip = false
            if Config.TeamCheckerEnabled and typeof(IsTeammate) == "function" then
                local ok, mate = pcall(IsTeammate, plr)
                if ok and mate then skip = true end
            end
            if not skip then
                local root = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
                if root then
                    local d = (root.Position - myRoot.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = plr
                    end
                end
            end
        end
    end
    return best
end

function TargetLine_GetTarget()
    local t = nil
    if Cache.SilentV2Target and TargetLine_IsAlivePlayer(Cache.SilentV2Target) then
        t = Cache.SilentV2Target
    elseif Config.AimEnabled and typeof(GetClosestPlayerInFOV) == "function" then
        local ok, got = pcall(GetClosestPlayerInFOV)
        if ok and got and TargetLine_IsAlivePlayer(got) then t = got end
    end
    
    if not t and not Config.TargetLineVisibleCheck then
        if Cache.TargetLineLast and TargetLine_IsAlivePlayer(Cache.TargetLineLast) then
            t = Cache.TargetLineLast
        else
            t = TargetLine_GetClosestEnemy()
        end
    end
    if t then Cache.TargetLineLast = t end
    return t
end

function TargetLine_Hide()
    if TargetLineDraw then
        pcall(function() TargetLineDraw.Visible = false end)
    end
end

function TargetLine_Update()
    if not Config.TargetLineEnabled or not TargetLineDraw then
        TargetLine_Hide()
        return
    end
    local cam = Workspace.CurrentCamera
    local myChar = LocalPlayer.Character
    if not cam or not myChar then
        TargetLine_Hide()
        return
    end
    local fromPart = myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Head")
    if not fromPart then
        TargetLine_Hide()
        return
    end
    local target = TargetLine_GetTarget()
    if not target or not target.Character then
        TargetLine_Hide()
        return
    end
    local toPart = target.Character:FindFirstChild("Head")
        or target.Character:FindFirstChild("HumanoidRootPart")
        or target.Character.PrimaryPart
    if not toPart then
        TargetLine_Hide()
        return
    end
    if Config.TargetLineVisibleCheck then
        local visible = false
        if typeof(IsVisibleToCamera) == "function" then
            local ok, res = pcall(IsVisibleToCamera, target, toPart)
            visible = ok and res == true
        else
            Cache._TLRayParams = Cache._TLRayParams or RaycastParams.new()
            local params = Cache._TLRayParams
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = { myChar }
            params.IgnoreWater = true
            local origin = cam.CFrame.Position
            local dir = toPart.Position - origin
            local hit = Workspace:Raycast(origin, dir, params)
            if not hit then
                visible = true
            elseif hit.Instance and hit.Instance:IsDescendantOf(target.Character) then
                visible = true
            end
        end
        if not visible then
            TargetLine_Hide()
            return
        end
    end
    local s0 = cam:WorldToViewportPoint(fromPart.Position)
    local s1 = cam:WorldToViewportPoint(toPart.Position)
    
    if s1.Z < 0 and s0.Z < 0 then
        TargetLine_Hide()
        return
    end
    TargetLineDraw.From = Vector2.new(s0.X, s0.Y)
    TargetLineDraw.To = Vector2.new(s1.X, s1.Y)
    TargetLineDraw.Color = Config.Color_TargetLine or Theme.Accent
    TargetLineDraw.Transparency = math.clamp(tonumber(Config.TargetLineTransparency) or 0.15, 0, 1)
    TargetLineDraw.Thickness = 1.8
    TargetLineDraw.Visible = true
end
CrosshairX = Drawing.new("Line")
CrosshairX.Thickness = 1.4
CrosshairX.Transparency = 1
CrosshairX.Visible = false
CrosshairX.Color = Config.Color_Crosshair or Theme.Accent

CrosshairY = Drawing.new("Line")
CrosshairY.Thickness = 1.4
CrosshairY.Transparency = 1
CrosshairY.Visible = false
CrosshairY.Color = Config.Color_Crosshair or Theme.Accent


Cache.ScopeBaseFOV = nil
Cache.ScopeTargetFOV = nil

function Scope_EnsureGui()
    if Cache.ScopeGui and Cache.ScopeGui.Parent and Cache.ScopeArms then
        return Cache.ScopeGui, Cache.ScopeArms
    end
    
    pcall(function()
        if Cache.ScopeGui then Cache.ScopeGui:Destroy() end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "AnxiumScopeGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
            gui.Parent = CoreGui
        elseif gethui then
            gui.Parent = gethui()
        else
            gui.Parent = CoreGui
        end
    end)
    if not gui.Parent then
        gui.Parent = ScreenGui or CoreGui
    end

    local arms = {}
    for _, name in ipairs({ "L", "R", "T", "B" }) do
        local f = Instance.new("Frame")
        f.Name = "ScopeArm" .. name
        f.BorderSizePixel = 0
        f.BackgroundColor3 = Config.Color_Scope or Color3.fromRGB(220, 220, 230)
        f.BackgroundTransparency = 0
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.ZIndex = 100
        f.Visible = false
        f.Parent = gui
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = f
        local grad = Instance.new("UIGradient")
        grad.Name = "ScopeGrad"
        local base = Config.Color_Scope or Color3.fromRGB(220, 220, 230)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.45, base),
            ColorSequenceKeypoint.new(1, Color3.new(base.R * 0.45, base.G * 0.45, base.B * 0.45)),
        })
        grad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0),
        })
        if name == "L" or name == "R" then
            grad.Rotation = 0
        else
            grad.Rotation = 90
        end
        grad.Enabled = Config.ScopeGradientEnabled == true
        grad.Parent = f
        arms[name] = f
    end

    Cache.ScopeGui = gui
    Cache.ScopeArms = arms
    Cache.ScopeLineH, Cache.ScopeLineV = nil, nil
    return gui, arms
end


ScopeCrossArms = ScopeCrossArms or {}
pcall(function()
    if Drawing and (not ScopeCrossArms.L) then
        for _, name in ipairs({ "L", "R", "T", "B" }) do
            local ln = Drawing.new("Line")
            ln.Thickness = 2
            ln.Transparency = 1
            ln.Visible = false
            ln.Color = Color3.fromRGB(220, 220, 230)
            ScopeCrossArms[name] = ln
        end
    end
end)

function Scope_Hide()
    Config.ScopeActive = false
    pcall(function()
        if Cache.ScopeArms then
            for _, f in pairs(Cache.ScopeArms) do
                if f then f.Visible = false end
            end
        end
        if Cache.ScopeLineH then Cache.ScopeLineH.Visible = false end
        if Cache.ScopeLineV then Cache.ScopeLineV.Visible = false end
        if ScopeCrossArms then
            for _, ln in pairs(ScopeCrossArms) do
                if ln then ln.Visible = false; ln.Transparency = 1 end
            end
        end
        if ScopeCrossH then ScopeCrossH.Visible = false; ScopeCrossH.Transparency = 1 end
        if ScopeCrossV then ScopeCrossV.Visible = false; ScopeCrossV.Transparency = 1 end
    end)
    pcall(function()
        local cam = Workspace.CurrentCamera or Camera
        if cam and Cache.ScopeBaseFOV then
            cam.FieldOfView = Cache.ScopeBaseFOV
        end
        Cache.ScopeBaseFOV = nil
        Cache.ScopeTargetFOV = nil
    end)
end

function Scope_SetActive(on)
    on = on and true or false
    if not Config.ScopeEnabled then
        Scope_Hide()
        return
    end
    local wasActive = Config.ScopeActive == true
    Config.ScopeActive = on
    if on then
        Cache.ScopeZoomSettled = false
        pcall(function()
            local cam = Workspace.CurrentCamera or Camera
            if not Cache.ScopeBaseFOV and cam then
                Cache.ScopeBaseFOV = cam.FieldOfView
            end
            Cache.ScopeTargetFOV = tonumber(Config.ScopeZoomFOV) or 40
        end)
        if not wasActive then
            pcall(PlayScopeSound)
        end
        pcall(function() if Scope_UpdateDraw then Scope_UpdateDraw() end end)
    else
        Scope_Hide()
    end
end

function Scope_UpdateDraw()
    local active = Config.ScopeEnabled == true and Config.ScopeActive == true
    local th = math.clamp(math.floor(tonumber(Config.ScopeThickness) or 2), 1, 12)
    local col = Config.Color_Scope or Color3.fromRGB(220, 220, 230)
    local gap = math.clamp(math.floor(tonumber(Config.ScopeGap) or 8), 0, 120)
    if Config.ScopeDynamicEnabled == true and active then
        local speed = 0
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.AssemblyLinearVelocity
            speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
        end
        local maxExtra = math.clamp(tonumber(Config.ScopeDynamicExpand) or 30, 0, 150)
        local target = 0
        if speed > 1.2 then
            target = maxExtra * math.clamp(speed / 16, 0, 1)
        end
        local cur = Cache.ScopeDynamicGap or 0
        Cache.ScopeDynamicGap = cur + (target - cur) * 0.2
        gap = gap + Cache.ScopeDynamicGap
    else
        Cache.ScopeDynamicGap = 0
    end
    local len = math.clamp(math.floor(tonumber(Config.ScopeLength) or 80), 8, 5000)

    local cam = Workspace.CurrentCamera or Camera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local cx, cy = vp.X * 0.5, vp.Y * 0.5
    
    local maxH = math.max(8, math.floor(cx - gap - 2))
    local maxV = math.max(8, math.floor(cy - gap - 2))
    local lenH = math.min(len, maxH)
    local lenV = math.min(len, maxV)

    local _, arms = Scope_EnsureGui()
    if arms then
        if active then
            
            local function applyArm(f, w, h, x, y, rot)
                if not f then return end
                f.BackgroundColor3 = col
                f.Size = UDim2.fromOffset(w, h)
                f.Position = UDim2.fromOffset(x, y)
                f.Visible = true
                local g = f:FindFirstChild("ScopeGrad")
                if g and g:IsA("UIGradient") then
                    if Config.ScopeGradientEnabled then
                        g.Enabled = true
                        local dark = Color3.new(col.R * 0.4, col.G * 0.4, col.B * 0.4)
                        g.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.4, col),
                            ColorSequenceKeypoint.new(1, dark),
                        })
                        g.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 0),
                        })
                        g.Rotation = rot
                    else
                        g.Enabled = false
                    end
                end
            end
            applyArm(arms.L, lenH, th, math.floor(cx - gap - lenH * 0.5), math.floor(cy), 0)
            applyArm(arms.R, lenH, th, math.floor(cx + gap + lenH * 0.5), math.floor(cy), 0)
            applyArm(arms.T, th, lenV, math.floor(cx), math.floor(cy - gap - lenV * 0.5), 90)
            applyArm(arms.B, th, lenV, math.floor(cx), math.floor(cy + gap + lenV * 0.5), 90)
        else
            for _, f in pairs(arms) do
                if f then f.Visible = false end
            end
        end
    end

    
    if ScopeCrossArms and ScopeCrossArms.L then
        if active then
            local function setArm(ln, x1, y1, x2, y2)
                ln.From = Vector2.new(x1, y1)
                ln.To = Vector2.new(x2, y2)
                ln.Color = col
                ln.Thickness = th
                ln.Transparency = 0
                ln.Visible = true
            end
            setArm(ScopeCrossArms.L, cx - gap - lenH, cy, cx - gap, cy)
            setArm(ScopeCrossArms.R, cx + gap, cy, cx + gap + lenH, cy)
            setArm(ScopeCrossArms.T, cx, cy - gap - lenV, cx, cy - gap)
            setArm(ScopeCrossArms.B, cx, cy + gap, cx, cy + gap + lenV)
        else
            for _, ln in pairs(ScopeCrossArms) do
                if ln then ln.Visible = false end
            end
        end
    end
end

function Scope_UpdateFOV()
    local cam = Workspace.CurrentCamera or Camera
    if not cam then return end
    Camera = cam

    if Config.ScopeEnabled and Config.ScopeActive then
        if not Cache.ScopeBaseFOV then
            if Config.CameraFovEnabled then
                Cache.ScopeBaseFOV = tonumber(Config.CameraFovValue) or cam.FieldOfView
            else
                Cache.ScopeBaseFOV = cam.FieldOfView
            end
            Cache.ScopeZoomSettled = false
        end
        local target = math.clamp(tonumber(Config.ScopeZoomFOV) or 40, 1, 120)
        Cache.ScopeTargetFOV = target
        
        if Cache.ScopeZoomSettled then
            if math.abs(cam.FieldOfView - target) > 0.75 then
                pcall(function() cam.FieldOfView = target end)
            end
        else
            local speed = math.clamp(tonumber(Config.ScopeZoomSpeed) or 0.2, 0.05, 1)
            local cur = cam.FieldOfView
            local nextFov = cur + (target - cur) * speed
            if math.abs(nextFov - target) < 0.4 then
                nextFov = target
                Cache.ScopeZoomSettled = true
            end
            pcall(function() cam.FieldOfView = nextFov end)
        end
    elseif Cache.ScopeBaseFOV then
        Cache.ScopeZoomSettled = false
        local speed = math.clamp(tonumber(Config.ScopeZoomSpeed) or 0.2, 0.05, 1)
        local base = Cache.ScopeBaseFOV
        local nextFov = cam.FieldOfView + (base - cam.FieldOfView) * speed
        pcall(function() cam.FieldOfView = nextFov end)
        if math.abs(cam.FieldOfView - base) < 0.25 then
            pcall(function() cam.FieldOfView = base end)
            Cache.ScopeBaseFOV = nil
            Cache.ScopeTargetFOV = nil
            if Config.CameraFovEnabled and CameraFov_Apply then
                pcall(CameraFov_Apply)
            end
        end
    end
end


Cache.CrosshairSpinAngle = 0
Cache.CrosshairSpinLines = {}
if Drawing then
    for i = 1, 4 do
        local ln = Drawing.new("Line")
        ln.Thickness = 1.6
        ln.Transparency = 1
        ln.Visible = false
        ln.Color = Config.Color_Crosshair or Theme.Accent
        Cache.CrosshairSpinLines[i] = ln
    end
end



function AngelHalo_Hide()
    pcall(function()
        if Cache.AngelHaloModel then
            Cache.AngelHaloModel:Destroy()
        end
    end)
    Cache.AngelHaloModel = nil
    Cache.AngelHaloSegs = nil
    Cache.AngelHaloSegCount = 0
    Cache.AngelHaloHead = nil
    Cache.AngelHaloSig = nil
end

function AngelHalo_Ensure(head)
    if not head then return nil end
    local rings = math.clamp(math.floor(tonumber(Config.AngelHaloRings) or 1), 1, 3)
    local segs = math.clamp(math.floor(tonumber(Config.AngelHaloSegments) or 36), 12, 48)
    local height = math.clamp(tonumber(Config.AngelHaloHeight) or 1.2, 0.2, 6)
    local baseR = math.clamp(tonumber(Config.AngelHaloRadius) or 1.15, 0.3, 5)
    local thick = math.clamp(tonumber(Config.AngelHaloThickness) or 0.14, 0.04, 0.5)
    local trans = math.clamp(tonumber(Config.AngelHaloTransparency) or 0.2, 0, 0.95)
    local col = Config.Color_AngelHalo or Color3.fromRGB(255, 230, 140)
    local total = rings * segs
    local glowN = math.clamp(tonumber(Config.AngelHaloGlow) or 3, 0, 12)
    local sig = string.format("%d_%d_%.2f_%.2f_%.2f_%.2f_%.1f_%.3f_%.3f_%.3f",
        rings, segs, height, baseR, thick, trans, glowN, col.R, col.G, col.B)

    if Cache.AngelHaloModel and Cache.AngelHaloModel.Parent
        and Cache.AngelHaloHead == head
        and Cache.AngelHaloSegCount == total
        and Cache.AngelHaloSig == sig then
        return Cache.AngelHaloSegs
    end

    AngelHalo_Hide()
    local model = Instance.new("Model")
    model.Name = "AnxiumAngelHalo"
    model.Parent = head

    local list = {}
    for r = 1, rings do
        local radius = baseR * (1 + (r - 1) * 0.28)
        local segLen = (2 * math.pi * radius / segs) * 1.35
        local yOff = height + (r - 1) * 0.06
        for i = 1, segs do
            local angle = (i / segs) * math.pi * 2
            local p = Instance.new("Part")
            p.Name = "Seg"
            p.Anchored = false
            p.CanCollide = false
            p.CanQuery = false
            p.CanTouch = false
            p.CastShadow = false
            p.Massless = true
            p.Material = Enum.Material.Neon
            p.Color = col
            p.Transparency = trans
            p.Size = Vector3.new(segLen, 0.035, thick)
            p.Parent = model
            local weld = Instance.new("Weld")
            weld.Name = "HaloWeld"
            weld.Part0 = head
            weld.Part1 = p
            local ox = math.cos(angle) * radius
            local oz = math.sin(angle) * radius
            weld.C0 = CFrame.new(ox, yOff, oz) * CFrame.Angles(0, -(angle + math.pi * 0.5), 0)
            weld.C1 = CFrame.new()
            weld.Parent = p
            list[#list + 1] = p
        end
    end
    
    local glowN = math.clamp(tonumber(Config.AngelHaloGlow) or 3, 0, 12)
    if glowN > 0.05 then
        local core = Instance.new("Part")
        core.Name = "HaloGlowCore"
        core.Anchored = false
        core.CanCollide = false
        core.CanQuery = false
        core.CanTouch = false
        core.CastShadow = false
        core.Massless = true
        core.Transparency = 1
        core.Size = Vector3.new(0.2, 0.2, 0.2)
        core.Parent = model
        local w = Instance.new("Weld")
        w.Part0 = head
        w.Part1 = core
        w.C0 = CFrame.new(0, height, 0)
        w.Parent = core
        local light = Instance.new("PointLight")
        light.Name = "HaloLight"
        light.Color = col
        light.Brightness = 0.35 + glowN * 0.25
        light.Range = 2 + glowN * 0.9
        light.Shadows = false
        light.Parent = core
    end
    Cache.AngelHaloModel = model
    Cache.AngelHaloSegs = list
    Cache.AngelHaloSegCount = total
    Cache.AngelHaloHead = head
    Cache.AngelHaloSig = sig
    return list
end

function AngelHalo_Update()
    if not Config.AngelHaloEnabled then
        AngelHalo_Hide()
        return
    end
    local char = LocalPlayer.Character
    if not char then AngelHalo_Hide() return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or (hum and hum.Health <= 0) then
        AngelHalo_Hide()
        return
    end
    local segs = AngelHalo_Ensure(head)
    if segs then
        local col = Config.Color_AngelHalo or Color3.fromRGB(255, 230, 140)
        if typeof(col) ~= "Color3" then
            col = Color3.fromRGB(255, 230, 140)
        end
        local trans = math.clamp(tonumber(Config.AngelHaloTransparency) or 0.2, 0, 0.95)
        for _, p in ipairs(segs) do
            if p and p.Parent and p.Name == "Seg" then
                p.Color = col
                p.Material = Enum.Material.Neon
                p.Transparency = trans
                pcall(function()
                    if p:IsA("MeshPart") then
                        p.TextureID = ""
                    end
                end)
            end
        end
        local model = Cache.AngelHaloModel
        if model then
            local core = model:FindFirstChild("HaloGlowCore")
            local light = core and core:FindFirstChild("HaloLight")
            if light and light:IsA("PointLight") then
                light.Color = col
                local glowN = math.clamp(tonumber(Config.AngelHaloGlow) or 3, 0, 12)
                light.Brightness = 0.35 + glowN * 0.25
                light.Range = 2 + glowN * 0.9
            end
        end
    end
end


function BuildHatDrawing()
    if not Drawing then return end
    for _, obj in ipairs(Cache.ChinaHatLines) do
        pcall(function()
            if obj.Line then obj.Line:Remove() end
            if obj.BaseLine then obj.BaseLine:Remove() end
        end)
    end
    for _, obj in ipairs(Cache.ChinaHatTris) do pcall(function() if obj then obj:Remove() end end) end
    Cache.ChinaHatLines = {}
    Cache.ChinaHatTris = {}

    for i = 1, Config.ChinaHatSegments do
        local line = Drawing.new("Line")
        line.ZIndex = 3
        line.Thickness = 1.5

        local baseLine = Drawing.new("Line")
        baseLine.ZIndex = 3
        baseLine.Thickness = 1.5

        local tri = Drawing.new("Triangle")
        tri.ZIndex = 1
        tri.Filled = true

        table.insert(Cache.ChinaHatLines, {Line = line, BaseLine = baseLine})
        table.insert(Cache.ChinaHatTris, tri)
    end
end

function HideHatDrawing()
    for i = 1, #Cache.ChinaHatLines do
        pcall(function()
            Cache.ChinaHatLines[i].Line.Visible = false
            Cache.ChinaHatLines[i].BaseLine.Visible = false
        end)
        pcall(function() Cache.ChinaHatTris[i].Visible = false end)
    end
end

function ChinaHatMesh_Destroy()
    pcall(function()
        if Cache.ChinaHatMesh then Cache.ChinaHatMesh:Destroy() end
    end)
    Cache.ChinaHatMesh = nil
    Cache.ChinaHatMeshWeld = nil
end

function ChinaHatMesh_Create()
    ChinaHatMesh_Destroy()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local mesh = Instance.new("MeshPart")
    mesh.Name = "AnxiumChinaHatMesh"
    mesh.MeshId = "rbxassetid://1778999"
    local sz = tonumber(Config.ChinaHatMeshSize) or 3
    mesh.Size = Vector3.new(sz, 0.75, sz)
    mesh.Transparency = tonumber(Config.ChinaHatMeshTransparency) or 0.5
    mesh.Color = Config.Color_ChinaHat or Theme.Accent
    local matName = Config.ChinaHatMeshMaterial or "Neon"
    pcall(function() mesh.Material = Enum.Material[matName] end)
    mesh.CanCollide = false
    mesh.Anchored = false
    mesh.CanQuery = false
    mesh.CastShadow = false
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = mesh
    weld.Part1 = head
    weld.Parent = mesh
    pcall(function()
        mesh.CFrame = head.CFrame * CFrame.new(0, 1, 0)
    end)
    mesh.Parent = char
    Cache.ChinaHatMesh = mesh
    Cache.ChinaHatMeshWeld = weld
end

function ChinaHatMesh_Update()
    local mesh = Cache.ChinaHatMesh
    if not mesh or not mesh.Parent then return end
    local sz = tonumber(Config.ChinaHatMeshSize) or 3
    mesh.Size = Vector3.new(sz, 0.6, sz)
    mesh.Transparency = tonumber(Config.ChinaHatMeshTransparency) or 0.5
    mesh.Color = Config.Color_ChinaHat or Theme.Accent
    local matName = Config.ChinaHatMeshMaterial or "Neon"
    pcall(function() mesh.Material = Enum.Material[matName] end)
end

function ChinaHat_ApplyStyle()
    local style = Config.ChinaHatStyle or "Drawing"
    if not Config.ChinaHatEnabled then
        HideHatDrawing()
        ChinaHatMesh_Destroy()
        return
    end
    if style == "Mesh" then
        HideHatDrawing()
        if not Cache.ChinaHatMesh or not Cache.ChinaHatMesh.Parent then
            ChinaHatMesh_Create()
        else
            ChinaHatMesh_Update()
        end
    else
        ChinaHatMesh_Destroy()
        if Drawing and (#(Cache.ChinaHatLines or {}) == 0) then
            BuildHatDrawing()
        end
    end
end

Cache.FakeLagToken = 0
function FakeLag_Stop()
    Cache.FakeLagToken = (Cache.FakeLagToken or 0) + 1
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = false end
    end)
end

function FakeLag_Start()
    FakeLag_Stop()
    local token = Cache.FakeLagToken
    task.spawn(function()
        local function rand(a, b)
            return a + math.random() * (b - a)
        end
        while Config.FakeLagEnabled and Cache.FakeLagToken == token do
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and root:IsA("BasePart") then
                local anchorT = (tonumber(Config.FakeLagAnchorTime) or 50) / 100
                local unanchorT = (tonumber(Config.FakeLagUnanchorTime) or 35) / 100
                local pauseT = (tonumber(Config.FakeLagPause) or 100) / 100
                local jitter = (tonumber(Config.FakeLagJitter) or 15) / 100
                if Config.FakeLagRandomize then
                    anchorT = math.max(0.05, anchorT + rand(-jitter, jitter))
                    unanchorT = math.max(0.05, unanchorT + rand(-jitter, jitter))
                    pauseT = math.max(0.05, pauseT + rand(-jitter, jitter))
                end
                
                if math.random() < 0.25 then
                    local count = math.random(2, 5)
                    for _ = 1, count do
                        if not Config.FakeLagEnabled or Cache.FakeLagToken ~= token then break end
                        root.Anchored = true
                        task.wait(rand(0.05, 0.12))
                        root.Anchored = false
                        task.wait(rand(0.05, 0.12))
                    end
                else
                    root.Anchored = true
                    task.wait(anchorT)
                    if Cache.FakeLagToken ~= token then break end
                    root.Anchored = false
                    task.wait(unanchorT + pauseT)
                end
            else
                task.wait(0.25)
            end
            task.wait()
        end
        pcall(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Anchored = false end
        end)
    end)
end

if Drawing then
    BuildHatDrawing()
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        BuildHatDrawing()
        if Config.ChinaHatEnabled and (Config.ChinaHatStyle or "Drawing") == "Mesh" then
            ChinaHatMesh_Create()
        end
        if Config.FakeLagEnabled then
            FakeLag_Start()
        end
    end)
end


OrbitPart1 = Instance.new("Part")
OrbitPart1.Size = Vector3.new(0.1, 0.1, 0.1)
OrbitPart1.Transparency = 1
OrbitPart1.CanCollide = false
OrbitPart1.Anchored = true

OrbAtt0_1 = Instance.new("Attachment", OrbitPart1)
OrbAtt0_1.Position = Vector3.new(0, 0.6, 0)
OrbAtt1_1 = Instance.new("Attachment", OrbitPart1)
OrbAtt1_1.Position = Vector3.new(0, -0.6, 0)

OrbTrail1 = Instance.new("Trail")
OrbTrail1.Attachment0 = OrbAtt0_1
OrbTrail1.Attachment1 = OrbAtt1_1
OrbTrail1.Lifetime = 0.28
OrbTrail1.LightEmission = 1
OrbTrail1.LightInfluence = 0
OrbTrail1.Color = ColorSequence.new(Theme.Accent)
OrbTrail1.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.05),
    NumberSequenceKeypoint.new(0.6, 0.3),
    NumberSequenceKeypoint.new(1, 1)
})
OrbTrail1.WidthScale = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.8),
    NumberSequenceKeypoint.new(1, 0.1)
})
OrbTrail1.Parent = OrbitPart1

OrbitPart2 = Instance.new("Part")
OrbitPart2.Size = Vector3.new(0.1, 0.1, 0.1)
OrbitPart2.Transparency = 1
OrbitPart2.CanCollide = false
OrbitPart2.Anchored = true

OrbAtt0_2 = Instance.new("Attachment", OrbitPart2)
OrbAtt0_2.Position = Vector3.new(0, 0.6, 0)
OrbAtt1_2 = Instance.new("Attachment", OrbitPart2)
OrbAtt1_2.Position = Vector3.new(0, -0.6, 0)

OrbTrail2 = Instance.new("Trail")
OrbTrail2.Attachment0 = OrbAtt0_2
OrbTrail2.Attachment1 = OrbAtt1_2
OrbTrail2.Lifetime = 0.28
OrbTrail2.LightEmission = 1
OrbTrail2.LightInfluence = 0
OrbTrail2.Color = ColorSequence.new(Theme.Accent)
OrbTrail2.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.05),
    NumberSequenceKeypoint.new(0.6, 0.3),
    NumberSequenceKeypoint.new(1, 1)
})
OrbTrail2.WidthScale = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.8),
    NumberSequenceKeypoint.new(1, 0.1)
})
OrbTrail2.Parent = OrbitPart2

SetupTrail = function(character)
    if not character then return end
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    if Cache.PlayerTrail then Cache.PlayerTrail:Destroy() end
    if Cache.TrailAtt0 then Cache.TrailAtt0:Destroy() end
    if Cache.TrailAtt1 then Cache.TrailAtt1:Destroy() end

    Cache.TrailAtt0 = Instance.new("Attachment")
    Cache.TrailAtt0.Name = "AnxiumTrailAtt0"
    Cache.TrailAtt0.Position = Vector3.new(0, 1, 0)
    Cache.TrailAtt0.Parent = hrp

    Cache.TrailAtt1 = Instance.new("Attachment")
    Cache.TrailAtt1.Name = "AnxiumTrailAtt1"
    Cache.TrailAtt1.Position = Vector3.new(0, -1, 0)
    Cache.TrailAtt1.Parent = hrp

    Cache.PlayerTrail = Instance.new("Trail")
    Cache.PlayerTrail.Name = "AnxiumTrail"
    Cache.PlayerTrail.Attachment0 = Cache.TrailAtt0
    Cache.PlayerTrail.Attachment1 = Cache.TrailAtt1
    Cache.PlayerTrail.Lifetime = 0.6
    Cache.PlayerTrail.LightEmission = 1
    Cache.PlayerTrail.LightInfluence = 0
    Cache.PlayerTrail.Color = ColorSequence.new(Config.Color_Trail or Theme.Accent)
    Cache.PlayerTrail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    Cache.PlayerTrail.Enabled = Config.TrailEnabled
    Cache.PlayerTrail.Parent = hrp
end

if LocalPlayer.Character then SetupTrail(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(SetupTrail)

function ForceField_SaveOriginals(char)
    if not char or Cache.ForceFieldOriginals[char] then return end
    Cache.ForceFieldOriginals[char] = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            Cache.ForceFieldOriginals[char][part] = {
                Color = part.Color,
                Material = part.Material
            }
        end
    end
end

function ForceField_Apply(char)
    if not char then return end
    ForceField_SaveOriginals(char)
    local col = Config.Color_ForceField or Theme.Accent
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = col
            part.Material = Enum.Material.ForceField
        end
    end
end

function ForceField_Restore(char)
    if not char or not Cache.ForceFieldOriginals[char] then return end
    for part, data in pairs(Cache.ForceFieldOriginals[char]) do
        if part and part.Parent and part:IsA("BasePart") then
            pcall(function()
                part.Color = data.Color
                part.Material = data.Material
            end)
        end
    end
    Cache.ForceFieldOriginals[char] = nil
end

function ForceField_Update()
    if not Config then return end
    local char = LocalPlayer.Character
    if not char or not Config.ForceFieldEnabled then return end
    local col = Config.Color_ForceField or Theme.Accent
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Material == Enum.Material.ForceField then
            part.Color = col
        end
    end
end

function ForceField_Toggle(enabled)
    Config.ForceFieldEnabled = enabled
    local char = LocalPlayer.Character
    if enabled then
        if char then ForceField_Apply(char) end
        if Cache.ForceFieldConnection then
            Cache.ForceFieldConnection:Disconnect()
            Cache.ForceFieldConnection = nil
        end
    else
        if Cache.ForceFieldConnection then
            Cache.ForceFieldConnection:Disconnect()
            Cache.ForceFieldConnection = nil
        end
        if char then ForceField_Restore(char) end
    end
end


Cache.WeaponFFPainted = Cache.WeaponFFPainted or {}
Cache.WeaponFFKeepAlive = nil
Cache.WeaponFFConnections = Cache.WeaponFFConnections or {}
Cache.WeaponFFCurrentTool = nil
Cache.WeaponFFLastApply = 0

function WeaponFF_NameIsLimb(name)
    local n = string.lower(tostring(name or "")):gsub("%s+", "")
    
    if n:find("barrel") or n:find("mag") or n:find("scope") or n:find("stock")
        or n:find("sight") or n:find("rail") or n:find("muzzle") or n:find("receiver")
        or n:find("slide") or n:find("bolt") or n:find("suppressor") or n:find("weapon")
        or n:find("gun") or n:find("knife") or n:find("blade") or n:find("handle")
        or n:find("guard") or n:find("grip") or n:find("trigger") or n:find("chamber")
        or n:find("clip") or n:find("ammo") or n:find("optic") or n:find("laser")
        or n:find("silencer") or n:find("compensator") or n:find("flash")
        or n:find("mesh") or n:find("part") or n:find("model") then
        return false
    end
    local limbs = {
        head=true, torso=true, humanoidrootpart=true,
        uppertorso=true, lowertorso=true,
        leftarm=true, rightarm=true, leftleg=true, rightleg=true,
        lefthand=true, righthand=true, leftfoot=true, rightfoot=true,
        leftupperarm=true, rightupperarm=true, leftlowerarm=true, rightlowerarm=true,
        leftupperleg=true, rightupperleg=true, leftlowerleg=true, rightlowerleg=true,
    }
    if limbs[n] then return true end
    if n:find("humanoid") then return true end
    
    if n == "arm" or n == "hand" or n == "glove" or n == "leg" or n == "foot"
        or n:find("leftarm") or n:find("rightarm") or n:find("leftleg") or n:find("rightleg")
        or n:find("lefthand") or n:find("righthand") or n:find("leftfoot") or n:find("rightfoot")
        or n:find("upperarm") or n:find("lowerarm") or n:find("upperleg") or n:find("lowerleg")
        or n:find("sleeve") or n:find("finger") or n:find("wrist") or n:find("elbow")
        or n:find("shoulder") or n:find("limb") then
        return true
    end
    return false
end

function WeaponFF_IsCubeHitbox(part)
    local s = part.Size
    local maxDim = math.max(s.X, s.Y, s.Z)
    local minDim = math.min(s.X, s.Y, s.Z)
    local vol = s.X * s.Y * s.Z
    
    if maxDim > 6 and minDim > 2.5 and vol > 40 then return true end
    if maxDim > 14 then return true end
    if vol > 80 then return true end
    return false
end

function WeaponFF_GetMaterial()
    local style = tostring(Config.WeaponMaterialStyle or "ForceField")
    local map = {
        ForceField = Enum.Material.ForceField,
        Neon = Enum.Material.Neon,
        Glass = Enum.Material.Glass,
        Ice = Enum.Material.Ice,
        Metal = Enum.Material.Metal,
        SmoothPlastic = Enum.Material.SmoothPlastic,
        Foil = Enum.Material.Foil,
        Plastic = Enum.Material.Plastic,
    }
    return map[style] or Enum.Material.ForceField
end

function WeaponFF_IsUnderWeapon(part)
    local p = part
    for _ = 1, 16 do
        p = p.Parent
        if not p or p == Workspace or p == game then break end
        if p:IsA("Tool") then return true end
        local n = string.lower(tostring(p.Name or ""))
        if n:find("viewmodel") or n:find("view_model") or n:find("view model")
            or n:find("weapon") or n:find("gun") or n:find("knife") or n:find("rifle")
            or n:find("pistol") or n:find("shotgun") or n:find("smg") or n:find("sniper")
            or n:find("arms") or n:find("fpmodel") or n:find("firstperson") or n:find("fps")
            or n:find("held") or n:find("equip") or n:find("weld") or n:find("item")
            or n == "camera" or n:find("vm_") or n:find("c_frame") then
            return true
        end
        
        if p == Workspace.CurrentCamera then return true end
    end
    return false
end


function WeaponFF_IsGunMesh(part)
    if not part then return false end
    if not (part:IsA("BasePart") or part:IsA("UnionOperation") or part:IsA("MeshPart")) then
        return false
    end
    if WeaponFF_IsCubeHitbox(part) then return false end
    local tr = 0
    pcall(function() tr = part.Transparency end)
    if tr >= 0.99 then return false end

    local under = WeaponFF_IsUnderWeapon(part)
    if under then
        
        if WeaponFF_NameIsLimb(part.Name) then return false end
        return true
    end

    if WeaponFF_NameIsLimb(part.Name) then return false end

    local s = part.Size
    local maxDim = math.max(s.X, s.Y, s.Z)
    local vol = s.X * s.Y * s.Z
    if maxDim > 16 or vol > 70 then return false end

    if part:IsA("MeshPart") or part:IsA("UnionOperation") then
        return true
    end
    for _, ch in ipairs(part:GetChildren()) do
        if ch:IsA("SpecialMesh") or ch:IsA("BlockMesh") or ch:IsA("CylinderMesh") then
            return true
        end
    end
    if maxDim <= 4 and vol <= 8 then return true end
    if maxDim <= 12 and vol <= 15 and (maxDim / math.max(math.min(s.X, s.Y, s.Z), 0.05)) >= 2.5 then
        return true
    end
    return false
end

function WeaponFF_Save(part)
    if not part or Cache.WeaponFFPainted[part] then return end
    local data = {
        Color = part.Color,
        Material = part.Material,
        Transparency = part.Transparency,
        Reflectance = part.Reflectance,
    }
    pcall(function() data.LocalTransparencyModifier = part.LocalTransparencyModifier end)
    if part:IsA("MeshPart") then
        data.TextureID = part.TextureID
    end
    data.Kids = {}
    for _, ch in ipairs(part:GetChildren()) do
        if ch:IsA("SpecialMesh") then
            data.Kids[#data.Kids + 1] = { kind = "mesh", obj = ch, tex = ch.TextureId }
        elseif ch:IsA("SurfaceAppearance") then
            data.Kids[#data.Kids + 1] = { kind = "sa", obj = ch, parent = ch.Parent }
        elseif ch:IsA("Decal") or ch:IsA("Texture") then
            data.Kids[#data.Kids + 1] = { kind = "dec", obj = ch, t = ch.Transparency }
        end
    end
    Cache.WeaponFFPainted[part] = data
end

function WeaponFF_PaintPart(part)
    if not WeaponFF_IsGunMesh(part) then return false end
    WeaponFF_Save(part)
    local col = Config.Color_WeaponFF or Theme.Accent
    local mat = WeaponFF_GetMaterial and WeaponFF_GetMaterial() or Enum.Material.ForceField
    local style = tostring(Config.WeaponMaterialStyle or "ForceField")
    local ok = pcall(function()
        part.Material = mat
        part.Color = col
        pcall(function() part.Color = col end)
        
        if style == "ForceField" then
            part.Reflectance = 0
            part.Transparency = math.clamp(math.min(part.Transparency, 0.1), 0, 0.15)
        elseif style == "Glass" then
            part.Reflectance = 0.15
            part.Transparency = 0.35
        elseif style == "Ice" then
            part.Reflectance = 0.25
            part.Transparency = 0.2
        elseif style == "Neon" then
            part.Reflectance = 0
            part.Transparency = 0
        elseif style == "Metal" then
            part.Reflectance = 0.35
            part.Transparency = 0
        elseif style == "Foil" then
            part.Reflectance = 0.55
            part.Transparency = 0
        elseif style == "SmoothPlastic" or style == "Plastic" then
            part.Reflectance = 0.05
            part.Transparency = 0
        else
            part.Reflectance = 0
            part.Transparency = 0
        end
        if part:IsA("MeshPart") then
            pcall(function() part.TextureID = "" end)
        end
        pcall(function()
            if part.LocalTransparencyModifier ~= nil then
                part.LocalTransparencyModifier = 0
            end
        end)
        for _, ch in ipairs(part:GetChildren()) do
            if ch:IsA("SpecialMesh") then
                pcall(function() ch.TextureId = "" end)
            elseif ch:IsA("SurfaceAppearance") then
                pcall(function() ch.Parent = nil end)
            elseif ch:IsA("Decal") or ch:IsA("Texture") then
                pcall(function() ch.Transparency = 1 end)
            end
        end
    end)
    return ok
end

function WeaponFF_Restore(part, data)
    if not part or not data then return end
    pcall(function()
        if data.Color then part.Color = data.Color end
        if data.Material then part.Material = data.Material end
        if data.Transparency ~= nil then part.Transparency = data.Transparency end
        if data.Reflectance ~= nil then part.Reflectance = data.Reflectance end
        if data.LocalTransparencyModifier ~= nil then
            pcall(function() part.LocalTransparencyModifier = data.LocalTransparencyModifier end)
        end
        if data.TextureID ~= nil and part:IsA("MeshPart") then
            part.TextureID = data.TextureID
        end
        if data.Kids then
            for _, k in ipairs(data.Kids) do
                if k.kind == "mesh" and k.obj then
                    pcall(function() k.obj.TextureId = k.tex end)
                elseif k.kind == "sa" and k.obj and k.parent then
                    pcall(function() k.obj.Parent = k.parent end)
                elseif k.kind == "dec" and k.obj then
                    pcall(function() k.obj.Transparency = k.t or 0 end)
                end
            end
        end
    end)
end

function WeaponFF_RestoreAll()
    for part, data in pairs(Cache.WeaponFFPainted) do
        if part then WeaponFF_Restore(part, data) end
    end
    Cache.WeaponFFPainted = {}
    Cache.WeaponFFCurrentTool = nil
end

function WeaponFF_PaintIn(container)
    if not container then return 0 end
    local painted = 0
    local function try(p)
        if WeaponFF_PaintPart(p) then painted = painted + 1 end
    end
    if container:IsA("BasePart") or container:IsA("UnionOperation") then
        try(container)
    end
    for _, d in ipairs(container:GetDescendants()) do
        if d:IsA("BasePart") or d:IsA("UnionOperation") or d:IsA("MeshPart") then
            try(d)
        end
    end
    return painted
end

function WeaponFF_CamViewmodels()
    local list = {}
    local cam = workspace.CurrentCamera
    if not cam then return list end
    for _, ch in ipairs(cam:GetChildren()) do
        if ch:IsA("Tool") or ch:IsA("Model") or ch:IsA("Folder") or ch:IsA("Accoutrement") then
            local n = string.lower(ch.Name or "")
            if not (n:find("blur") or n:find("bloom") or n:find("colorcorrection")) then
                list[#list + 1] = ch
            end
        end
    end
    return list
end

function WeaponFF_CharTools()
    local list = {}
    local char = LocalPlayer.Character
    if not char then return list end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") then
            list[#list + 1] = ch
        end
    end
    return list
end

function WeaponFF_ApplyAll()
    if not Config.WeaponForceFieldEnabled then return end
    Cache.WeaponFFLastApply = tick()

    for part, data in pairs(Cache.WeaponFFPainted) do
        if not part or not part.Parent then
            Cache.WeaponFFPainted[part] = nil
        end
    end

    local total = 0
    local paintedSet = {}

    local function paintContainer(c)
        if not c or paintedSet[c] then return end
        paintedSet[c] = true
        total = total + WeaponFF_PaintIn(c)
        if c:IsA("Tool") then Cache.WeaponFFCurrentTool = c end
    end

    
    for _, c in ipairs(WeaponFF_CamViewmodels()) do
        paintContainer(c)
    end

    
    for _, c in ipairs(WeaponFF_CharTools()) do
        paintContainer(c)
    end

    
    pcall(function()
        for _, name in ipairs({ "Viewmodel", "ViewModel", "ViewModels", "Arms", "FPSArms", "FirstPerson", "Camera", "Weapons" }) do
            local f = Workspace:FindFirstChild(name)
            if f then paintContainer(f) end
        end
        local cam = Workspace.CurrentCamera
        if cam then
            for _, ch in ipairs(cam:GetDescendants()) do
                if ch:IsA("BasePart") and WeaponFF_IsUnderWeapon(ch) then
                    if WeaponFF_PaintPart(ch) then total = total + 1 end
                end
            end
        end
    end)

    
    if total == 0 then
        local char = LocalPlayer.Character
        if char then
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("Tool") then
                    total = total + WeaponFF_PaintIn(d)
                end
            end
        end
    end

    Cache.WeaponFFLastApply = tick()
end

function WeaponFF_UpdateColor()
    if not Config.WeaponForceFieldEnabled then return end
    local col = Config.Color_WeaponFF or Theme.Accent
    local mat = (WeaponFF_GetMaterial and WeaponFF_GetMaterial()) or Enum.Material.ForceField
    local style = tostring(Config.WeaponMaterialStyle or "ForceField")
    for part, data in pairs(Cache.WeaponFFPainted) do
        if part and part.Parent and part:IsA("BasePart") then
            pcall(function()
                part.Material = mat
                part.Color = col
                if style == "ForceField" then
                    part.Reflectance = 0
                    part.Transparency = math.clamp(math.min(part.Transparency, 0.1), 0, 0.15)
                elseif style == "Glass" then
                    part.Reflectance = 0.15
                    part.Transparency = 0.35
                elseif style == "Ice" then
                    part.Reflectance = 0.25
                    part.Transparency = 0.2
                elseif style == "Neon" then
                    part.Reflectance = 0
                    part.Transparency = 0
                elseif style == "Metal" then
                    part.Reflectance = 0.35
                    part.Transparency = 0
                elseif style == "Foil" then
                    part.Reflectance = 0.55
                    part.Transparency = 0
                else
                    part.Reflectance = 0.05
                    part.Transparency = 0
                end
                if part:IsA("MeshPart") then
                    pcall(function() part.TextureID = "" end)
                end
                for _, ch in ipairs(part:GetChildren()) do
                    if ch:IsA("SpecialMesh") then
                        pcall(function() ch.TextureId = "" end)
                    elseif ch:IsA("SurfaceAppearance") then
                        pcall(function() ch.Parent = nil end)
                    elseif ch:IsA("Decal") or ch:IsA("Texture") then
                        pcall(function() ch.Transparency = 1 end)
                    end
                end
            end)
        end
    end
    Cache.WeaponFFLastApply = 0
    WeaponFF_ApplyAll()
end

function WeaponFF_Reassert()
    if not Config.WeaponForceFieldEnabled then return end
    local col = Config.Color_WeaponFF or Theme.Accent
    local now = tick()
    if now - (Cache.WeaponFFLastApply or 0) > 0.35 then
        WeaponFF_ApplyAll()
        return
    end
    local any = false
    local wantMat = (WeaponFF_GetMaterial and WeaponFF_GetMaterial()) or Enum.Material.ForceField
    local style = tostring(Config.WeaponMaterialStyle or "ForceField")
    for part, data in pairs(Cache.WeaponFFPainted) do
        if part and part.Parent and part:IsA("BasePart") then
            any = true
            if part.Material ~= wantMat or part.Color ~= col then
                pcall(function()
                    part.Material = wantMat
                    part.Color = col
                    if style == "ForceField" then
                        part.Reflectance = 0
                        part.Transparency = math.min(part.Transparency, 0.12)
                    elseif style == "Glass" then
                        part.Reflectance = 0.15
                        part.Transparency = 0.35
                    elseif style == "Ice" then
                        part.Reflectance = 0.25
                        part.Transparency = 0.2
                    elseif style == "Neon" then
                        part.Reflectance = 0
                        part.Transparency = 0
                    elseif style == "Metal" then
                        part.Reflectance = 0.35
                        part.Transparency = 0
                    elseif style == "Foil" then
                        part.Reflectance = 0.55
                        part.Transparency = 0
                    else
                        part.Reflectance = 0.05
                        part.Transparency = 0
                    end
                    if part:IsA("MeshPart") then part.TextureID = "" end
                    for _, ch in ipairs(part:GetChildren()) do
                        if ch:IsA("SurfaceAppearance") then ch.Parent = nil end
                        if ch:IsA("SpecialMesh") then ch.TextureId = "" end
                    end
                end)
            end
        else
            Cache.WeaponFFPainted[part] = nil
        end
    end
    
    if not any and now - (Cache.WeaponFFLastApply or 0) > 0.15 then
        WeaponFF_ApplyAll()
    end
end

function WeaponFF_OnCharacter(char)
    if not char then return end
    for _, k in ipairs({"ChildAdded", "ChildRemoved", "CamChild", "CamDesc"}) do
        if Cache.WeaponFFConnections[k] then
            pcall(function() Cache.WeaponFFConnections[k]:Disconnect() end)
            Cache.WeaponFFConnections[k] = nil
        end
    end

    Cache.WeaponFFConnections.ChildAdded = char.ChildAdded:Connect(function(child)
        if Config.WeaponForceFieldEnabled and child:IsA("Tool") then
            task.defer(WeaponFF_ApplyAll)
        end
    end)

    Cache.WeaponFFConnections.ChildRemoved = char.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            for part, data in pairs(Cache.WeaponFFPainted) do
                if part and (not part.Parent or part:IsDescendantOf(child)) then
                    WeaponFF_Restore(part, data)
                    Cache.WeaponFFPainted[part] = nil
                end
            end
            task.defer(WeaponFF_ApplyAll)
        end
    end)

    local cam = workspace.CurrentCamera
    if cam then
        Cache.WeaponFFConnections.CamChild = cam.ChildAdded:Connect(function()
            if Config.WeaponForceFieldEnabled then task.defer(WeaponFF_ApplyAll) end
        end)
        Cache.WeaponFFConnections.CamDesc = cam.DescendantAdded:Connect(function(desc)
            if Config.WeaponForceFieldEnabled and desc:IsA("BasePart") then
                task.defer(function()
                    if Config.WeaponForceFieldEnabled then
                        WeaponFF_PaintPart(desc)
                    end
                end)
            end
        end)
    end

    if Config.WeaponForceFieldEnabled then WeaponFF_ApplyAll() end
end

function WeaponFF_Toggle(enabled)
    Config.WeaponForceFieldEnabled = enabled and true or false
    if Cache.WeaponFFKeepAlive then
        pcall(function() Cache.WeaponFFKeepAlive:Disconnect() end)
        Cache.WeaponFFKeepAlive = nil
    end
    if enabled then
        if LocalPlayer.Character then WeaponFF_OnCharacter(LocalPlayer.Character) end
        WeaponFF_ApplyAll()
        Cache.WeaponFFKeepAlive = RunService.RenderStepped:Connect(function()
            Cache._wffN = (Cache._wffN or 0) + 1
            if Cache._wffN % 4 == 0 then
                WeaponFF_Reassert()
            end
        end)
    else
        WeaponFF_RestoreAll()
        for _, k in pairs(Cache.WeaponFFConnections) do
            pcall(function() k:Disconnect() end)
        end
        Cache.WeaponFFConnections = {}
    end
end

pcall(function()
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.15)
        if Config.WeaponForceFieldEnabled then
            WeaponFF_OnCharacter(char)
            WeaponFF_ApplyAll()
        end
    end)
end)
if LocalPlayer.Character and Config.WeaponForceFieldEnabled then
    task.defer(function() WeaponFF_OnCharacter(LocalPlayer.Character) end)
end


ClassicAuraIDs = {
    Godly = "rbxassetid://16699750981",
    PinkAura = "rbxassetid://115980859615239",
    AngelWing = "rbxassetid://90022969696073"
}

function tintAuraSubtree(root, color)
    if not root or not color then return end
    local seq = ColorSequence.new(color)
    local function tintOne(obj)
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                obj.Color = seq
            elseif obj:IsA("PointLight") or obj:IsA("Fire") or obj:IsA("Smoke") then
                obj.Color = color
            end
        end)
    end
    tintOne(root)
    for _, d in ipairs(root:GetDescendants()) do
        tintOne(d)
    end
end

function ClassicAura_Disable(name)
    if Cache.ActiveClassicAuras[name] then
        for _, v in ipairs(Cache.ActiveClassicAuras[name]) do
            if v and v.Parent then
                pcall(function() v:Destroy() end)
            end
        end
        Cache.ActiveClassicAuras[name] = {}
    end
end

function ClassicAura_Enable(char, name, color)
    if not char or not char.Parent then return end
    ClassicAura_Disable(name)

    local id = ClassicAuraIDs[name]
    if not id then return end

    local success, model = pcall(function()
        return game:GetObjects(id)[1]
    end)
    if not success or not model then return end

    local effects = {}
    for _, obj in pairs(model:GetDescendants()) do
        if not obj:IsA("BasePart") then
            pcall(function()
                local clone = obj:Clone()
                local parentName = obj.Parent and obj.Parent.Name
                local target = char:FindFirstChild(parentName) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
                if target then
                    clone.Parent = target
                    if color then tintAuraSubtree(clone, color) end
                    table.insert(effects, clone)
                end
            end)
        end
    end

    pcall(function() model:Destroy() end)
    Cache.ActiveClassicAuras[name] = effects
end

function ClassicAura_RefreshAll()
    local char = LocalPlayer.Character
    if not char then return end

    local ac = Config.Color_Aura or Theme.Accent
    if Config.AuraEnabled then ClassicAura_Enable(char, "Godly", ac) else ClassicAura_Disable("Godly") end
    if Config.ClassicPinkEnabled then ClassicAura_Enable(char, "PinkAura", ac) else ClassicAura_Disable("PinkAura") end
    if Config.ClassicAngelEnabled then ClassicAura_Enable(char, "AngelWing", ac) else ClassicAura_Disable("AngelWing") end
end

ParticleAuraIDs = {
    starlight = "rbxassetid://134645216613107",
    angel = "rbxassetid://97658130917593"
}

function getParticleTemplate(name)
    if Cache.LoadedParticleTemplates[name] then
        return Cache.LoadedParticleTemplates[name]
    end
    local id = ParticleAuraIDs[name]
    if not id then return nil end
    local ok, result = pcall(function()
        return game:GetObjects(id)[1]
    end)
    if ok and result then
        Cache.LoadedParticleTemplates[name] = result
        return result
    end
    return nil
end

function mapCharacterParts(character)
    local parts = {}
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("BasePart") then
            parts[child.Name] = child
        end
    end
    return parts
end

function setParticleEmittersEnabled(root, enabled)
    if not root then return end
    if root:IsA("ParticleEmitter") then pcall(function() root.Enabled = enabled end) end
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("ParticleEmitter") then pcall(function() d.Enabled = enabled end) end
    end
end

function ParticleAura_Disable(name)
    if Cache.ActiveParticleAuras[name] then
        for _, p in ipairs(Cache.ActiveParticleAuras[name]) do
            if p then pcall(function() p:Destroy() end) end
        end
        Cache.ActiveParticleAuras[name] = {}
    end
end

function ParticleAura_Enable(char, name, color)
    if not char then return end
    ParticleAura_Disable(name)

    local auraObj = getParticleTemplate(name)
    if not auraObj then return end

    local localParts = mapCharacterParts(char)
    local cloned = auraObj:Clone()
    local created = {}

    for _, part in ipairs(cloned:GetChildren()) do
        local targetPart = localParts[part.Name]
        if targetPart then
            for _, child in ipairs(part:GetChildren()) do
                pcall(function()
                    local inst = child:Clone()
                    inst.Name = "AnxiumParticleAura"
                    inst.Parent = targetPart
                    if color then tintAuraSubtree(inst, color) end
                    table.insert(created, inst)
                end)
            end
        end
    end

    pcall(function() cloned:Destroy() end)

    for _, p in ipairs(created) do
        setParticleEmittersEnabled(p, true)
    end

    Cache.ActiveParticleAuras[name] = created
end

function ParticleAura_RefreshAll()
    local char = LocalPlayer.Character
    if not char then return end

    local ac = Config.Color_Aura or Theme.Accent
    if Config.ParticleStarlightEnabled then ParticleAura_Enable(char, "starlight", ac) else ParticleAura_Disable("starlight") end
    if Config.ParticleAngelEnabled then ParticleAura_Enable(char, "angel", ac) else ParticleAura_Disable("angel") end
end

function ReapplyAurasAndForceField(char)
    task.wait(0.8)
    if not char or not char.Parent then return end
    if Config.ForceFieldEnabled then ForceField_Apply(char) end
    ClassicAura_RefreshAll()
    ParticleAura_RefreshAll()
end


Cache.ThirdPersonSavedMinZoom = nil
Cache.ThirdPersonSavedMaxZoom = nil
Cache.ThirdPersonUsingOffset = false
Cache.ThirdPersonToolConns = Cache.ThirdPersonToolConns or {}
Cache.ThirdPersonLastDist = nil

function ThirdPerson_IsFirstPersonLocked()
    local ok, mode = pcall(function() return LocalPlayer.CameraMode end)
    if ok and mode == Enum.CameraMode.LockFirstPerson then
        return true
    end
    local maxZ = LocalPlayer.CameraMaxZoomDistance
    if typeof(maxZ) == "number" and maxZ <= 1.5 then
        return true
    end
    return false
end

function ThirdPerson_SetBodyVisible(char, visible)
    if not char then return end
    local selfAmt = 0
    if visible then
        if typeof(GetSelfTransparencyAmount) == "function" then
            selfAmt = GetSelfTransparencyAmount()
        elseif Config and Config.SelfTransparencyEnabled then
            selfAmt = math.clamp(tonumber(Config.SelfTransparency) or 0.4, 0, 1)
        end
    else
        selfAmt = 1
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                if part.Name == "HumanoidRootPart" then
                    part.LocalTransparencyModifier = visible and 0 or 1
                else
                    part.LocalTransparencyModifier = selfAmt
                end
                part.CanQuery = true
            end)
        end
    end
end

function ThirdPerson_ApplyCharacter(char)
    ThirdPerson_SetBodyVisible(char, false)
end

function ThirdPerson_RestoreCharacter(char)
    ThirdPerson_SetBodyVisible(char, true)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() hum.CameraOffset = Vector3.zero end)
    end
end

function ThirdPerson_ClearToolConns()
    for _, c in pairs(Cache.ThirdPersonToolConns or {}) do
        pcall(function() c:Disconnect() end)
    end
    Cache.ThirdPersonToolConns = {}
end

function ThirdPerson_HookCharacter(char)
    ThirdPerson_ClearToolConns()
    if not char then return end
    local function reapply()
        if not Config.ThirdPersonEnabled then return end
        local dist = math.clamp(Config.ThirdPersonDistance or 12, 4, 50)
        pcall(function()
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMinZoomDistance = dist
            LocalPlayer.CameraMaxZoomDistance = dist
        end)
        ThirdPerson_SetBodyVisible(char, true)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum.CameraOffset = Vector3.zero end)
        end
    end
    Cache.ThirdPersonToolConns.ChildAdded = char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.defer(reapply)
            task.delay(0.08, reapply)
            pcall(function()
                Cache.ThirdPersonToolConns["eq_" .. tostring(child)] = child.Equipped:Connect(function()
                    task.defer(reapply)
                    task.delay(0.08, reapply)
                end)
                Cache.ThirdPersonToolConns["uneq_" .. tostring(child)] = child.Unequipped:Connect(function()
                    task.defer(reapply)
                end)
            end)
        end
    end)
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            pcall(function()
                Cache.ThirdPersonToolConns["eq_" .. tostring(child)] = child.Equipped:Connect(function()
                    task.defer(reapply)
                    task.delay(0.08, reapply)
                end)
                Cache.ThirdPersonToolConns["uneq_" .. tostring(child)] = child.Unequipped:Connect(function()
                    task.defer(reapply)
                end)
            end)
        end
    end
end

function ThirdPerson_ForceDistance(dist)
    dist = math.clamp(tonumber(dist) or 12, 4, 50)
    pcall(function()
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.DevEnableMouseLock = true
        LocalPlayer.CameraMinZoomDistance = dist
        LocalPlayer.CameraMaxZoomDistance = dist
    end)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local cam = Workspace.CurrentCamera or Camera
    if cam and hum then
        pcall(function()
            if cam.CameraType ~= Enum.CameraType.Custom and cam.CameraType ~= Enum.CameraType.Track then
                cam.CameraType = Enum.CameraType.Custom
            end
            if cam.CameraSubject ~= hum then
                cam.CameraSubject = hum
            end
        end)
    end
    if hum then
        pcall(function() hum.CameraOffset = Vector3.zero end)
    end
    Cache.ThirdPersonLastDist = dist
    return dist
end

function ThirdPerson_Enable()
    pcall(function()
        if Cache.ThirdPersonSavedMinZoom == nil then
            Cache.ThirdPersonSavedMinZoom = LocalPlayer.CameraMinZoomDistance
            Cache.ThirdPersonSavedMaxZoom = LocalPlayer.CameraMaxZoomDistance
        end
        local dist = math.clamp(Config.ThirdPersonDistance or 12, 4, 50)
        ThirdPerson_ForceDistance(dist)
        local char = LocalPlayer.Character
        if char then
            ThirdPerson_SetBodyVisible(char, true)
            ThirdPerson_HookCharacter(char)
        end
        Cache.ThirdPersonUsingOffset = false
    end)
end

function ThirdPerson_Disable()
    pcall(function()
        ThirdPerson_ClearToolConns()
        local restoreMin = tonumber(Cache.ThirdPersonSavedMinZoom)
        local restoreMax = tonumber(Cache.ThirdPersonSavedMaxZoom)
        Cache.ThirdPersonSavedMinZoom = nil
        Cache.ThirdPersonSavedMaxZoom = nil
        Cache.ThirdPersonUsingOffset = false
        Cache.ThirdPersonLastDist = nil
        if restoreMin == nil then restoreMin = 0.5 end
        if restoreMax == nil then restoreMax = 128 end
        if restoreMax < restoreMin then restoreMax = restoreMin end
        local function restoreCamera()
            pcall(function()
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
                LocalPlayer.CameraMinZoomDistance = restoreMin
                LocalPlayer.CameraMaxZoomDistance = restoreMax
            end)
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum.CameraOffset = Vector3.zero end)
            end
            local cam = Workspace.CurrentCamera or Camera
            if cam and hum then
                pcall(function()
                    cam.CameraType = Enum.CameraType.Custom
                    cam.CameraSubject = hum
                end)
            end
            if char then
                ThirdPerson_SetBodyVisible(char, true)
            end
        end
        restoreCamera()
        task.defer(restoreCamera)
        task.delay(0.1, restoreCamera)
        task.delay(0.3, restoreCamera)
    end)
end

LocalPlayer.CharacterAdded:Connect(ReapplyAurasAndForceField)
LocalPlayer.CharacterAdded:Connect(function(char)
    if not Config.ThirdPersonEnabled then return end
    task.spawn(function()
        for _, delay in ipairs({0.2, 0.6, 1.2}) do
            task.wait(delay)
            if not Config.ThirdPersonEnabled then return end
            if LocalPlayer.Character ~= char then return end
            ThirdPerson_Enable()
        end
    end)
end)
LocalPlayer.CharacterRemoving:Connect(function(char)
    if Cache.ForceFieldOriginals[char] then Cache.ForceFieldOriginals[char] = nil end
    ClassicAura_Disable("Godly")
    ClassicAura_Disable("PinkAura")
    ClassicAura_Disable("AngelWing")
    ParticleAura_Disable("starlight")
    ParticleAura_Disable("angel")
    ThirdPerson_RestoreCharacter(char)
end)

if LocalPlayer.Character then
    task.spawn(function() ReapplyAurasAndForceField(LocalPlayer.Character) end)
end

TargetHudFrame = Instance.new("CanvasGroup")
TargetHudFrame.Name = "AnxiumTargetHud"
TargetHudFrame.Size = UDim2.new(0, 240, 0, 78)
TargetHudFrame.Position = UDim2.new(0.5, 130, 0.5, 40)
TargetHudFrame.BackgroundColor3 = Theme.Bg
TargetHudFrame.BackgroundTransparency = 0.12
TargetHudFrame.GroupTransparency = 1
TargetHudFrame.BorderSizePixel = 0
TargetHudFrame.Visible = false
TargetHudFrame.ClipsDescendants = true
TargetHudFrame.Parent = ScreenGui

TargetHudStroke = Instance.new("UIStroke")
TargetHudStroke.Color = Config.Color_TargetHud or Color3.fromRGB(180, 140, 255)
TargetHudStroke.Thickness = 1
TargetHudStroke.Transparency = 1
TargetHudStroke.Parent = TargetHudFrame

TargetHudCorner = nil

MakeDraggable(TargetHudFrame)

TargetAvatar = Instance.new("ImageLabel")
TargetAvatar.Name = "TargetAvatar"
TargetAvatar.Size = UDim2.new(0, 54, 0, 54)
TargetAvatar.Position = UDim2.new(0, 12, 0.5, -27)
TargetAvatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TargetAvatar.BorderSizePixel = 0
TargetAvatar.ImageTransparency = 0
TargetAvatar.BackgroundTransparency = 0
TargetAvatar.ScaleType = Enum.ScaleType.Crop
TargetAvatar.ResampleMode = Enum.ResamplerMode.Pixelated
TargetAvatar.Image = ""
TargetAvatar.ZIndex = 5
TargetAvatar.ClipsDescendants = true
TargetAvatar.Parent = TargetHudFrame

AvatarCorner = nil


AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = Config.Color_TargetHud or Color3.fromRGB(180, 140, 255)
AvatarStroke.Thickness = 1.5
AvatarStroke.Transparency = 0.3
AvatarStroke.Parent = TargetAvatar


Cache.TargetHudThumbCache = {}
Cache.TargetHudLastUserId = nil

function GetAvatarUrl(userId)
    userId = tonumber(userId) or userId
    
    return {
        "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png",
        "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150",
        "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=150x150&format=Png&isCircular=false",
    }
end

function ApplyTargetAvatar(userId)
    if not userId then return end
    userId = tonumber(userId) or userId

    if Cache.TargetHudThumbCache[userId] then
        TargetAvatar.Image = Cache.TargetHudThumbCache[userId]
        TargetAvatar.ImageTransparency = 0
        return
    end

    
    local urls = GetAvatarUrl(userId)
    TargetAvatar.Image = urls[1]
    TargetAvatar.ImageTransparency = 0
    Cache.TargetHudThumbCache[userId] = urls[1]

    
    task.spawn(function()
        local ok, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(
                userId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if ok and type(thumb) == "string" and #thumb > 0 then
            Cache.TargetHudThumbCache[userId] = thumb
            if Cache.TargetHudLastUserId == userId then
                TargetAvatar.Image = thumb
                TargetAvatar.ImageTransparency = 0
            end
        end
    end)
end

TargetNameLabel = Instance.new("TextLabel")
TargetNameLabel.Name = "TargetName"
TargetNameLabel.Size = UDim2.new(1, -80, 0, 20)
TargetNameLabel.Position = UDim2.new(0, 76, 0, 12)
TargetNameLabel.BackgroundTransparency = 1
TargetNameLabel.Text = "Target"
TargetNameLabel.TextColor3 = Theme.Text
TargetNameLabel.TextSize = 14
TargetNameLabel.Font = SelectedFont
TargetNameLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetNameLabel.TextTransparency = 1
TargetNameLabel.Parent = TargetHudFrame

TargetHealthBg = Instance.new("Frame")
TargetHealthBg.Name = "HealthBg"
TargetHealthBg.Size = UDim2.new(1, -88, 0, 8)
TargetHealthBg.Position = UDim2.new(0, 76, 0, 38)
TargetHealthBg.BackgroundColor3 = Theme.BgTertiary
TargetHealthBg.BorderSizePixel = 0
TargetHealthBg.BackgroundTransparency = 1
TargetHealthBg.Parent = TargetHudFrame



TargetHealthFill = Instance.new("Frame")
TargetHealthFill.Name = "HealthFill"
TargetHealthFill.Size = UDim2.new(1, 0, 1, 0)
TargetHealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TargetHealthFill.BorderSizePixel = 0
TargetHealthFill.BackgroundTransparency = 1
TargetHealthFill.Parent = TargetHealthBg




TargetHealthGrad = Instance.new("UIGradient")
TargetHealthGrad.Name = "HealthGrad"
TargetHealthGrad.Rotation = 0
TargetHealthGrad.Parent = TargetHealthFill
Cache.TargetHealthGrad = TargetHealthGrad

function TargetHud_HealthGradFromColor(col)
    local a = col or (Config and Config.Color_TargetHud) or Color3.fromRGB(180, 140, 255)
    
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.35, a),
        ColorSequenceKeypoint.new(1, a),
    })
end


function ApplyTargetHudColor(color)
    color = color or (Config and Config.Color_TargetHud) or Color3.fromRGB(180, 140, 255)
    if Config then Config.Color_TargetHud = color end
    pcall(function()
        if TargetHudStroke then TargetHudStroke.Color = color end
        if AvatarStroke then AvatarStroke.Color = color end
        if Cache.TargetHealthGrad then
            Cache.TargetHealthGrad.Color = TargetHud_HealthGradFromColor(color)
        end
        if TargetHealthFill then
            TargetHealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

ApplyTargetHudTheme = ApplyTargetHudColor

ApplyTargetHudColor(Config.Color_TargetHud)

TargetInfoLabel = Instance.new("TextLabel")
TargetInfoLabel.Name = "TargetInfo"
TargetInfoLabel.Size = UDim2.new(1, -88, 0, 16)
TargetInfoLabel.Position = UDim2.new(0, 76, 0, 52)
TargetInfoLabel.BackgroundTransparency = 1
TargetInfoLabel.Text = "100 / 100  ·  0m"
TargetInfoLabel.TextColor3 = Theme.TextDim
TargetInfoLabel.TextSize = 11
TargetInfoLabel.Font = SelectedFont
TargetInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetInfoLabel.TextTransparency = 1
TargetInfoLabel.Parent = TargetHudFrame

TargetHudVisible = false
TargetHudTweens = {}
TargetHudAnimationId = 0

function CancelTargetHudTweens()
    for _, tw in ipairs(TargetHudTweens) do
        if tw then pcall(function() tw:Cancel() end) end
    end
    TargetHudTweens = {}
end

function ShowTargetHud()
    if TargetHudVisible then return end
    TargetHudVisible = true
    TargetHudAnimationId += 1
    local animationId = TargetHudAnimationId
    CancelTargetHudTweens()

    TargetHudFrame.Visible = true
    TargetHudFrame.GroupTransparency = 1
    TargetHudFrame.BackgroundTransparency = 0.12
    TargetHudStroke.Transparency = 0.35
    TargetAvatar.ImageTransparency = 0
    TargetAvatar.BackgroundTransparency = 0
    TargetNameLabel.TextTransparency = 0
    TargetInfoLabel.TextTransparency = 0
    TargetHealthBg.BackgroundTransparency = 0
    TargetHealthFill.BackgroundTransparency = 0

    local info = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    table.insert(TargetHudTweens, TweenService:Create(TargetHudFrame, info, {GroupTransparency = 0}))
    for _, tw in ipairs(TargetHudTweens) do tw:Play() end

    task.delay(0.31, function()
        if TargetHudVisible and TargetHudAnimationId == animationId then
            TargetHudFrame.GroupTransparency = 0
        end
    end)
end

function HideTargetHud()
    if not TargetHudVisible then return end
    TargetHudVisible = false
    TargetHudAnimationId += 1
    local animationId = TargetHudAnimationId
    CancelTargetHudTweens()

    local info = TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    table.insert(TargetHudTweens, TweenService:Create(TargetHudFrame, info, {GroupTransparency = 1}))
    for _, tw in ipairs(TargetHudTweens) do tw:Play() end

    task.delay(0.31, function()
        if not TargetHudVisible and TargetHudAnimationId == animationId then
            TargetHudFrame.Visible = false
            TargetHudFrame.GroupTransparency = 1
        end
    end)
end

ToggleButton = nil
ToggleIcon = nil
ToggleStroke = nil

MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "AnxiumMainFrame"
MainFrame.ZIndex = 2
MainFrame.Size = UDim2.new(0, 720, 0, 480)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -240)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.GroupTransparency = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
do
    local menuScale = Instance.new("UIScale")
    menuScale.Name = "AnxiumMenuScale"
    menuScale.Scale = 1
    menuScale.Parent = MainFrame
end


MainStroke = nil

pcall(function()
    if MainFrame then
        for _, d in ipairs(MainFrame:GetChildren()) do
            if d:IsA("UIStroke") and d.Name and (d.Name:find("AnxiumGlow") or d.Name == "MainStroke") then
                d:Destroy()
            end
        end
    end
end)

MainCorner = nil
MainFrame.ClipsDescendants = true


Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 168, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BackgroundTransparency = 0
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

SidebarCorner = nil


SidebarEdge = Instance.new("Frame")
SidebarEdge.Size = UDim2.new(0, 12, 1, 0)
SidebarEdge.Position = UDim2.new(1, -12, 0, 0)
SidebarEdge.BackgroundColor3 = Theme.Sidebar
SidebarEdge.BorderSizePixel = 0
SidebarEdge.Parent = Sidebar


SidebarTop = Instance.new("Frame")
SidebarTop.Name = "SidebarTop"
SidebarTop.Size = UDim2.new(1, 0, 0, 78)
SidebarTop.Position = UDim2.new(0, 0, 0, 0)
SidebarTop.BackgroundTransparency = 1
SidebarTop.BorderSizePixel = 0
SidebarTop.Parent = Sidebar

LogoLabel = Instance.new("TextLabel")
LogoLabel.Size = UDim2.new(1, -20, 0, 28)
LogoLabel.Position = UDim2.new(0, 14, 0, 10)
LogoLabel.BackgroundTransparency = 1
LogoLabel.RichText = true
LogoLabel.Text = "ANXIUM<font color=\"#B48CFF\">HUB</font>"
LogoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoLabel.TextSize = 18
LogoLabel.Font = Enum.Font.GothamBlack
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left
LogoLabel.TextYAlignment = Enum.TextYAlignment.Center
LogoLabel.Parent = SidebarTop
pcall(function()
    if AnxiumUpdateBrandLogo then AnxiumUpdateBrandLogo() end
end)

SearchFrame = Instance.new("Frame")
SearchFrame.Name = "SearchFrame"
SearchFrame.Size = UDim2.new(1, -16, 0, 30)
SearchFrame.Position = UDim2.new(0, 8, 0, 40)
SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchFrame.BackgroundTransparency = 0.94
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = SidebarTop
do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = SearchFrame
end
do
    local s = Instance.new("UIStroke")
    s.Color = Theme.Stroke
    s.Transparency = 0.55
    s.Thickness = 1
    s.Parent = SearchFrame
end

IconSearch = Instance.new("ImageLabel")
IconSearch.Name = "IconSearch"
IconSearch.AnchorPoint = Vector2.new(0, 0.5)
IconSearch.BackgroundTransparency = 1
IconSearch.BorderSizePixel = 0
IconSearch.Position = UDim2.new(0, 8, 0.5, 0)
IconSearch.Size = UDim2.new(0, 15, 0, 15)
IconSearch.Image = "rbxassetid://71309835376233"
IconSearch.ImageColor3 = Theme.TextDim
IconSearch.Parent = SearchFrame

SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.BackgroundTransparency = 1
SearchBox.BorderSizePixel = 0
SearchBox.ClipsDescendants = true
SearchBox.Position = UDim2.new(0, 28, 0, 0)
SearchBox.Size = UDim2.new(1, -32, 1, 0)
SearchBox.Font = SelectedFont
SearchBox.PlaceholderText = "Search"
SearchBox.PlaceholderColor3 = Theme.TextDim
SearchBox.Text = ""
SearchBox.TextColor3 = Theme.Text
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchFrame
Cache.SearchBox = SearchBox
Cache.IconSearch = IconSearch


SidebarDiv2 = Instance.new("Frame")
SidebarDiv2.Name = "SidebarDiv2"
SidebarDiv2.Size = UDim2.new(1, -16, 0, 1)
SidebarDiv2.Position = UDim2.new(0, 8, 0, 80)
SidebarDiv2.BackgroundColor3 = Theme.Stroke
SidebarDiv2.BackgroundTransparency = 0.45
SidebarDiv2.BorderSizePixel = 0
SidebarDiv2.Parent = Sidebar


SidebarTabs = Instance.new("Frame")
SidebarTabs.Name = "SidebarTabs"
SidebarTabs.Size = UDim2.new(1, -12, 1, -150)
SidebarTabs.Position = UDim2.new(0, 6, 0, 88)
SidebarTabs.BackgroundTransparency = 1
SidebarTabs.Parent = Sidebar

SidebarTabsLayout = Instance.new("UIListLayout")
SidebarTabsLayout.Padding = UDim.new(0, 3)
SidebarTabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarTabsLayout.Parent = SidebarTabs


ProfileBar = Instance.new("Frame")
ProfileBar.Name = "ProfileBar"
ProfileBar.Size = UDim2.new(1, -12, 0, 52)
ProfileBar.Position = UDim2.new(0, 6, 1, -58)
ProfileBar.BackgroundColor3 = Theme.BgTertiary
ProfileBar.BackgroundTransparency = 0.25
ProfileBar.BorderSizePixel = 0
ProfileBar.Parent = Sidebar

ProfileAvatar = Instance.new("ImageLabel")
ProfileAvatar.Name = "Avatar"
ProfileAvatar.Size = UDim2.new(0, 34, 0, 34)
ProfileAvatar.Position = UDim2.new(0, 8, 0.5, -17)
ProfileAvatar.BackgroundColor3 = Theme.BgTertiary
ProfileAvatar.BorderSizePixel = 0
ProfileAvatar.Image = ""
ProfileAvatar.Parent = ProfileBar
do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = ProfileAvatar
end

ProfileName = Instance.new("TextLabel")
ProfileName.Size = UDim2.new(1, -52, 0, 16)
ProfileName.Position = UDim2.new(0, 48, 0, 10)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
ProfileName.TextColor3 = Theme.Text
ProfileName.TextSize = 12
ProfileName.Font = SelectedFont
ProfileName.TextXAlignment = Enum.TextXAlignment.Left
ProfileName.TextTruncate = Enum.TextTruncate.AtEnd
ProfileName.Parent = ProfileBar

ProfileSub = Instance.new("TextLabel")
ProfileSub.Size = UDim2.new(1, -52, 0, 14)
ProfileSub.Position = UDim2.new(0, 48, 0, 28)
ProfileSub.BackgroundTransparency = 1
ProfileSub.Text = "@" .. LocalPlayer.Name
ProfileSub.TextColor3 = Theme.TextDim
ProfileSub.TextSize = 10
ProfileSub.Font = SelectedFont
ProfileSub.TextXAlignment = Enum.TextXAlignment.Left
ProfileSub.TextTruncate = Enum.TextTruncate.AtEnd
ProfileSub.Parent = ProfileBar

task.spawn(function()
    local ok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size48x48
        )
    end)
    if ok and thumb and ProfileAvatar then
        ProfileAvatar.Image = thumb
    end
end)


Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -168, 0, 44)
Header.Position = UDim2.new(0, 168, 0, 0)
Header.BackgroundColor3 = Theme.Bg
Header.BackgroundTransparency = 0
Header.BorderSizePixel = 0
Header.Parent = MainFrame


HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header


HeaderBottomFix = Instance.new("Frame")
HeaderBottomFix.Size = UDim2.new(1, 0, 0, 12)
HeaderBottomFix.Position = UDim2.new(0, 0, 1, -12)
HeaderBottomFix.BackgroundColor3 = Theme.Bg
HeaderBottomFix.BorderSizePixel = 0
HeaderBottomFix.Parent = Header

HeaderLeftFix = Instance.new("Frame")
HeaderLeftFix.Size = UDim2.new(0, 14, 1, 0)
HeaderLeftFix.Position = UDim2.new(0, 0, 0, 0)
HeaderLeftFix.BackgroundColor3 = Theme.Bg
HeaderLeftFix.BorderSizePixel = 0
HeaderLeftFix.Parent = Header

HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.BackgroundColor3 = Theme.Stroke
HeaderLine.BackgroundTransparency = 0.4
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 2
HeaderLine.Parent = Header

TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.RichText = false
TitleLabel.Text = "Combat"
TitleLabel.TextColor3 = Theme.Text
TitleLabel.TextSize = 15
TitleLabel.Font = SelectedFont
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

VersionTag = Instance.new("TextLabel")
VersionTag.Size = UDim2.new(0, 120, 1, 0)
VersionTag.Position = UDim2.new(1, -130, 0, 0)
VersionTag.BackgroundTransparency = 1
VersionTag.Text = "Beta 1.0.0"
VersionTag.TextColor3 = Theme.TextDim
VersionTag.TextSize = 11
VersionTag.Font = SelectedFont
VersionTag.TextXAlignment = Enum.TextXAlignment.Right
VersionTag.Parent = Header

MakeDraggable(MainFrame, Header)
MakeDraggable(MainFrame, LogoLabel)


HeaderFix = nil
HeaderCorner = nil
SidebarFix = nil

TabButtons = {}
TabFrames = {}
CurrentTab = "Visuals"

function ApplyMenuSearch(query)
    query = string.lower(tostring(query or "")):gsub("^%s+", ""):gsub("%s+$", "")
    local searching = query ~= ""
    Cache.MenuSearchQuery = query

    for tabName, btn in pairs(TabButtons or {}) do
        local scroll = TabFrames and TabFrames[tabName]
        local tabHit = (not searching) or (string.find(string.lower(tabName), query, 1, true) ~= nil)
        local anyRow = false
        if scroll then
            for _, d in ipairs(scroll:GetDescendants()) do
                if d:IsA("Frame") or d:IsA("TextButton") then
                    local st = nil
                    pcall(function() st = d:GetAttribute("AnxiumSearchText") end)
                    if st and st ~= "" then
                        local hit = (not searching) or (string.find(st, query, 1, true) ~= nil)
                        d.Visible = hit
                        if hit then anyRow = true end
                    end
                end
            end
            
            for _, ch in ipairs(scroll:GetChildren()) do
                if ch:IsA("Frame") and ch:FindFirstChild("GroupContent", true) then
                    local content = ch:FindFirstChild("GroupContent", true)
                    local show = not searching
                    if content then
                        for _, r in ipairs(content:GetChildren()) do
                            if r:IsA("GuiObject") and r.Visible and r:GetAttribute("AnxiumSearchText") then
                                show = true
                                break
                            end
                        end
                    end
                    if searching then ch.Visible = show or tabHit end
                    if not searching then ch.Visible = true end
                    if show then anyRow = true end
                end
            end
        end
        local showTab = (not searching) or tabHit or anyRow
        if btn then btn.Visible = showTab end
    end
end
Cache.ApplyMenuSearch = ApplyMenuSearch

function Anxium_StyleTabButton(btn, state)
    if not btn then return end
    local label = btn:FindFirstChild("TabLabel")
    local icon = btn:FindFirstChild("TabIcon")
    local accent = btn:FindFirstChild("ActiveAccent")
    if state == "active" then
        btn.BackgroundColor3 = Theme.TabActive or Color3.fromRGB(40, 40, 48)
        btn.BackgroundTransparency = 0
        if label then label.TextColor3 = Theme.Text end
        if icon then icon.ImageColor3 = Theme.Accent end
        if accent then
            accent.Visible = true
            accent.BackgroundColor3 = Theme.Accent
            accent.BackgroundTransparency = 0
        end
    elseif state == "hover" then
        btn.BackgroundColor3 = Theme.TabActive or Color3.fromRGB(40, 40, 48)
        btn.BackgroundTransparency = 0.45
        if label then label.TextColor3 = Theme.Text end
        if icon then icon.ImageColor3 = Color3.fromRGB(200, 200, 210) end
        if accent then
            accent.Visible = true
            accent.BackgroundColor3 = Theme.Accent
            accent.BackgroundTransparency = 0.55
        end
    else
        btn.BackgroundColor3 = Theme.TabActive or Color3.fromRGB(40, 40, 48)
        btn.BackgroundTransparency = 1
        if label then label.TextColor3 = Theme.TextDim end
        if icon then icon.ImageColor3 = Theme.TextDim end
        if accent then
            accent.BackgroundTransparency = 1
            accent.Visible = false
        end
    end
end

function Anxium_ClearTabHovers(exceptName)
    for name, btn in pairs(TabButtons or {}) do
        if name == exceptName then continue end
        if name == CurrentTab then
            Anxium_StyleTabButton(btn, "active")
            btn:SetAttribute("AnxiumTabState", "active")
        else
            Anxium_StyleTabButton(btn, "idle")
            btn:SetAttribute("AnxiumTabState", "idle")
        end
    end
end

function SwitchTab(tabName)
    CurrentTab = tabName
    pcall(function()
        if Cache.AnxiumOpenListFrame then
            AnxiumSetListOpen(Cache.AnxiumOpenListFrame, false)
        end
        if Cache.AnxiumListShell then
            Cache.AnxiumListShell.Visible = false
        end
        Cache.AnxiumOpenListFrame = nil
        Cache.AnxiumOpenListAnchor = nil
    end)
    for name, frame in pairs(TabFrames) do
        frame.Visible = (name == tabName)
        frame.ScrollBarImageTransparency = 0
    end
    for name, btn in pairs(TabButtons) do
        if name == tabName then
            Anxium_StyleTabButton(btn, "active")
            btn:SetAttribute("AnxiumTabState", "active")
        else
            Anxium_StyleTabButton(btn, "idle")
            btn:SetAttribute("AnxiumTabState", "idle")
        end
    end
    if TitleLabel then
        TitleLabel.Text = tostring(tabName)
        TitleLabel.TextTransparency = 0
    end
    local function forceTabCanvas(name)
        pcall(function()
            local fn = Cache.TabCanvasRefresh and Cache.TabCanvasRefresh[name]
            if fn then fn() end
            local frame = TabFrames and TabFrames[name]
            if not frame or not frame:IsA("ScrollingFrame") then return end
            local total = 0
            for _, child in ipairs(frame:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                    local hh = child.Size.Y.Offset
                    if hh < 1 then hh = child.AbsoluteSize.Y end
                    if hh > 0 then total = total + hh + 16 end
                end
            end
            local lay = frame:FindFirstChildOfClass("UIListLayout")
            if lay and lay.AbsoluteContentSize.Y > total then
                total = lay.AbsoluteContentSize.Y
            end
            frame.CanvasSize = UDim2.new(0, 0, 0, math.max(total + 48, 1))
        end)
    end
    task.defer(function() forceTabCanvas(tabName) end)
    task.delay(0.08, function() forceTabCanvas(tabName) end)
    task.delay(0.25, function() forceTabCanvas(tabName) end)
end


Cache.TabIconDefs = {
    Combat = "rbxassetid://134242818164054",   
    Visuals = "rbxassetid://100033680381365",  
    Movement = "rbxassetid://81589895647169",  
    Settings = "rbxassetid://80758916183665",  
    Configs = "rbxassetid://74748492079329",
    Scripts = "rbxassetid://79541605299928",
}

function Anxium_ResolveTabIcon(tabName)
    return Cache.TabIconDefs and Cache.TabIconDefs[tabName] or nil
end

function CreateSidebarTab(name, order)
    local Btn = Instance.new("TextButton")
    Btn.Name = "Tab_" .. name
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = Theme.TabActive
    Btn.BackgroundTransparency = 1
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.LayoutOrder = order
    Btn.Parent = SidebarTabs

    local Accent = Instance.new("Frame")
    Accent.Name = "ActiveAccent"
    Accent.Size = UDim2.new(0, 3, 0, 16)
    Accent.Position = UDim2.new(0, 4, 0.5, -8)
    Accent.BackgroundColor3 = Theme.Accent
    Accent.BorderSizePixel = 0
    Accent.Visible = false
    Accent.Parent = Btn
    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1, 0)
        c.Parent = Accent
    end

    local IconImg = Instance.new("ImageLabel")
    IconImg.Name = "TabIcon"
    IconImg.Size = UDim2.fromOffset(16, 16)
    IconImg.Position = UDim2.new(0, 12, 0.5, -8)
    IconImg.BackgroundTransparency = 1
    IconImg.BorderSizePixel = 0
    IconImg.Image = Anxium_ResolveTabIcon(name) or ""
    IconImg.ImageColor3 = Theme.TextDim
    IconImg.ScaleType = Enum.ScaleType.Fit
    IconImg.Parent = Btn

    local Label = Instance.new("TextLabel")
    Label.Name = "TabLabel"
    Label.Size = UDim2.new(1, -36, 1, 0)
    Label.Position = UDim2.new(0, 34, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Theme.TextDim
    Label.TextSize = 13
    Label.Font = SelectedFont
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Btn

    Btn:SetAttribute("AnxiumTabState", "idle")
    Btn.MouseEnter:Connect(function()
        Cache.HoveredTab = name
        Anxium_ClearTabHovers(name)
        if CurrentTab == name then
            Anxium_StyleTabButton(Btn, "active")
            Btn:SetAttribute("AnxiumTabState", "active")
            return
        end
        Anxium_StyleTabButton(Btn, "hover")
        Btn:SetAttribute("AnxiumTabState", "hover")
    end)
    Btn.MouseLeave:Connect(function()
        if Cache.HoveredTab == name then
            Cache.HoveredTab = nil
        end
        if CurrentTab == name then
            Anxium_StyleTabButton(Btn, "active")
            Btn:SetAttribute("AnxiumTabState", "active")
        else
            Anxium_StyleTabButton(Btn, "idle")
            Btn:SetAttribute("AnxiumTabState", "idle")
        end
    end)
    Btn.MouseButton1Click:Connect(function()
        Cache.HoveredTab = nil
        SwitchTab(name)
    end)

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -184, 1, -56)
    Scroll.Position = UDim2.new(0, 176, 0, 52)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = Theme.Accent
    Scroll.ScrollBarImageTransparency = 0
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.None
    Scroll.ScrollingEnabled = true
    Scroll.Active = true
    Scroll.ClipsDescendants = true
    Scroll.ElasticBehavior = Enum.ElasticBehavior.Never
    Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    Scroll.Visible = false
    Scroll.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.Padding = UDim.new(0, 16)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Scroll

    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop = UDim.new(0, 8)
    Pad.PaddingBottom = UDim.new(0, 20)
    Pad.Parent = Scroll

    local function refreshTabCanvas()
        local h = 0
        pcall(function()
            h = Layout.AbsoluteContentSize.Y
        end)
        h = h + 8 + 20 + 12
        if h < 1 then h = 1 end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, h)
    end
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshTabCanvas)
    Scroll.ChildAdded:Connect(function()
        task.defer(refreshTabCanvas)
    end)
    Scroll.ChildRemoved:Connect(function()
        task.defer(refreshTabCanvas)
    end)
    task.defer(refreshTabCanvas)
    task.delay(0.35, refreshTabCanvas)
    task.delay(1.0, refreshTabCanvas)

    TabButtons[name] = Btn
    TabFrames[name] = Scroll
    Cache.TabCanvasRefresh = Cache.TabCanvasRefresh or {}
    Cache.TabCanvasRefresh[name] = refreshTabCanvas
    return Scroll
end

VisualsTab = CreateSidebarTab("Visuals", 1)


pcall(function()
    if SearchBox then
        local function runSearch()
            if ApplyMenuSearch then ApplyMenuSearch(SearchBox.Text) end
        end
        SearchBox:GetPropertyChangedSignal("Text"):Connect(runSearch)
        SearchBox.FocusLost:Connect(runSearch)
    end
end)
CombatTab = CreateSidebarTab("Combat", 2)
MovementTab = CreateSidebarTab("Movement", 3)
ConfigsTab = CreateSidebarTab("Configs", 4)
ScriptsTab = CreateSidebarTab("Scripts", 5)
SettingsTab = CreateSidebarTab("Settings", 6)

AnimationsTab = SettingsTab
TrollingTab = nil


ColorPickerFrame = nil
ColorPickerCallback = nil
ColorPickerPreviewBtn = nil
ColorPickerState = {
    H = 0.75, S = 0.55, V = 1,
    DraggingSV = false, DraggingHue = false,
}

function CloseRGBPicker()
    if ColorPickerFrame then
        ColorPickerFrame.Visible = false
    end
    ColorPickerCallback = nil
    ColorPickerPreviewBtn = nil
    ColorPickerState.DraggingSV = false
    ColorPickerState.DraggingHue = false
end

function ColorToHex(col)
    local r = math.floor(col.R * 255 + 0.5)
    local g = math.floor(col.G * 255 + 0.5)
    local b = math.floor(col.B * 255 + 0.5)
    return string.format("#%02X%02X%02X", r, g, b)
end

function HexToColor(str)
    if not str then return nil end
    str = tostring(str):gsub("^%s+", ""):gsub("%s+$", "")
    local rr, gg, bb = str:match("^[Rr][Gg][Bb]%s*%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*%)$")
    if rr then
        return Color3.fromRGB(
            math.clamp(tonumber(rr) or 0, 0, 255),
            math.clamp(tonumber(gg) or 0, 0, 255),
            math.clamp(tonumber(bb) or 0, 0, 255)
        )
    end
    str = str:gsub("#", ""):gsub("%s", ""):gsub("^0x", "")
    if #str == 8 then
        str = str:sub(1, 6)
    end
    if #str == 3 then
        str = str:sub(1,1)..str:sub(1,1)..str:sub(2,2)..str:sub(2,2)..str:sub(3,3)..str:sub(3,3)
    end
    if #str ~= 6 then return nil end
    if not str:match("^[0-9A-Fa-f]+$") then return nil end
    local r = tonumber(str:sub(1, 2), 16)
    local g = tonumber(str:sub(3, 4), 16)
    local b = tonumber(str:sub(5, 6), 16)
    if r == nil or g == nil or b == nil then return nil end
    return Color3.fromRGB(r, g, b)
end

function OpenRGBPicker(currentColor, onApply, previewBtn)
    ColorPickerCallback = onApply
    ColorPickerPreviewBtn = previewBtn
    pcall(function()
        if Cache.AnxiumListShell then Cache.AnxiumListShell.Visible = false end
    end)

    local col0 = currentColor or Color3.fromRGB(180, 140, 255)
    local h0, s0, v0 = col0:ToHSV()
    ColorPickerState.H, ColorPickerState.S, ColorPickerState.V = h0, s0, v0
    Cache.PickerSelectedColor = col0

    if not ColorPickerFrame then
        ColorPickerFrame = Instance.new("Frame")
        ColorPickerFrame.Name = "AnxiumRGBPicker"
        ColorPickerFrame.Size = UDim2.new(0, 230, 0, 268)
        ColorPickerFrame.Position = UDim2.new(0.5, -115, 0.5, -134)
        ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        ColorPickerFrame.BorderSizePixel = 0
        ColorPickerFrame.ZIndex = 400
        ColorPickerFrame.Parent = ScreenGui
        local pc = Instance.new("UICorner")
        pc.CornerRadius = UDim.new(0, 0)
        pc.Parent = ColorPickerFrame

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -40, 0, 24)
        title.Position = UDim2.new(0, 10, 0, 4)
        title.BackgroundTransparency = 1
        title.Text = "Color Picker"
        title.TextColor3 = Color3.fromRGB(230, 230, 235)
        title.TextSize = 13
        title.Font = SelectedFont
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 121
        title.Parent = ColorPickerFrame

        local closeBtn = Instance.new("ImageButton")
        closeBtn.Size = UDim2.new(0, 22, 0, 22)
        closeBtn.Position = UDim2.new(1, -28, 0, 5)
        closeBtn.BackgroundTransparency = 1
        closeBtn.Image = "rbxassetid://115678228554812"
        closeBtn.ImageColor3 = Color3.fromRGB(200, 200, 210)
        closeBtn.ScaleType = Enum.ScaleType.Fit
        closeBtn.ZIndex = 121
        closeBtn.Parent = ColorPickerFrame
        closeBtn.MouseButton1Click:Connect(CloseRGBPicker)

        
        local satFrame = Instance.new("TextButton")
        satFrame.Name = "SatFrame"
        satFrame.Size = UDim2.new(0, 180, 0, 160)
        satFrame.Position = UDim2.new(0, 12, 0, 32)
        satFrame.BackgroundColor3 = Color3.fromHSV(0.75, 1, 1)
        satFrame.BorderSizePixel = 0
        satFrame.Text = ""
        satFrame.AutoButtonColor = false
        satFrame.ZIndex = 121
        satFrame.ClipsDescendants = true
        satFrame.Parent = ColorPickerFrame
        local satCorner = Instance.new("UICorner")
        satCorner.CornerRadius = UDim.new(0, 0)
        satCorner.Parent = satFrame

        
        local satWhite = Instance.new("Frame")
        satWhite.Name = "SatWhite"
        satWhite.Size = UDim2.new(1, 0, 1, 0)
        satWhite.BackgroundColor3 = Color3.new(1, 1, 1)
        satWhite.BorderSizePixel = 0
        satWhite.ZIndex = 122
        satWhite.Parent = satFrame
        local satWhiteGrad = Instance.new("UIGradient")
        satWhiteGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        })
        satWhiteGrad.Parent = satWhite

        
        local satBlack = Instance.new("Frame")
        satBlack.Name = "SatBlack"
        satBlack.Size = UDim2.new(1, 0, 1, 0)
        satBlack.BackgroundColor3 = Color3.new(0, 0, 0)
        satBlack.BorderSizePixel = 0
        satBlack.ZIndex = 123
        satBlack.Parent = satFrame
        local satBlackGrad = Instance.new("UIGradient")
        satBlackGrad.Rotation = 90
        satBlackGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        })
        satBlackGrad.Parent = satBlack

        
        local svCursor = Instance.new("Frame")
        svCursor.Name = "SVCursor"
        svCursor.Size = UDim2.new(0, 10, 0, 10)
        svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
        svCursor.BackgroundTransparency = 1
        svCursor.BorderSizePixel = 0
        svCursor.ZIndex = 125
        svCursor.Parent = satFrame
        local svStroke = Instance.new("UIStroke")
        svStroke.Color = Color3.new(1, 1, 1)
        svStroke.Thickness = 1.5
        svStroke.Parent = svCursor
        local svCorner = Instance.new("UICorner")
        svCorner.CornerRadius = UDim.new(1, 0)
        svCorner.Parent = svCursor
        local svInner = Instance.new("UIStroke")
        

        
        local hueFrame = Instance.new("TextButton")
        hueFrame.Name = "HueFrame"
        hueFrame.Size = UDim2.new(0, 18, 0, 160)
        hueFrame.Position = UDim2.new(0, 200, 0, 32)
        hueFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        hueFrame.BorderSizePixel = 0
        hueFrame.Text = ""
        hueFrame.AutoButtonColor = false
        hueFrame.ZIndex = 121
        hueFrame.Parent = ColorPickerFrame
        local hueCorner = Instance.new("UICorner")
        hueCorner.CornerRadius = UDim.new(0, 0)
        hueCorner.Parent = hueFrame
        local hueGrad = Instance.new("UIGradient")
        hueGrad.Rotation = 90
        hueGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromHSV(0, 1, 1)),
            ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
            ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
            ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.50, 1, 1)),
            ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
            ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
            ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1, 1, 1)),
        })
        hueGrad.Parent = hueFrame

        local hueCursor = Instance.new("Frame")
        hueCursor.Name = "HueCursor"
        hueCursor.Size = UDim2.new(1, 4, 0, 4)
        hueCursor.Position = UDim2.new(0.5, 0, 0, 0)
        hueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
        hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
        hueCursor.BorderSizePixel = 0
        hueCursor.ZIndex = 125
        hueCursor.Parent = hueFrame
        local hueCStroke = Instance.new("UIStroke")
        hueCStroke.Color = Color3.fromRGB(30, 30, 35)
        hueCStroke.Thickness = 1
        hueCStroke.Parent = hueCursor
        local hueCCorner = Instance.new("UICorner")
        hueCCorner.CornerRadius = UDim.new(0, 2)
        hueCCorner.Parent = hueCursor

        
        local preview = Instance.new("Frame")
        preview.Name = "Preview"
        preview.Size = UDim2.new(0, 36, 0, 28)
        preview.Position = UDim2.new(0, 12, 0, 202)
        preview.BorderSizePixel = 0
        preview.ZIndex = 121
        preview.Parent = ColorPickerFrame
        local prc = Instance.new("UICorner")
        prc.CornerRadius = UDim.new(0, 0)
        prc.Parent = preview

        
        local hexBox = Instance.new("TextBox")
        hexBox.Name = "HexBox"
        hexBox.Size = UDim2.new(0, 90, 0, 28)
        hexBox.Position = UDim2.new(0, 56, 0, 202)
        hexBox.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
        hexBox.BorderSizePixel = 0
        hexBox.Text = "#B48CFF"
        hexBox.TextColor3 = Color3.fromRGB(220, 220, 230)
        hexBox.TextSize = 12
        hexBox.Font = SelectedFont
        hexBox.ClearTextOnFocus = false
        hexBox.ZIndex = 121
        hexBox.Parent = ColorPickerFrame
        local hxc = Instance.new("UICorner")
        hxc.CornerRadius = UDim.new(0, 0)
        hxc.Parent = hexBox

        
        local apply = Instance.new("TextButton")
        apply.Name = "ApplyBtn"
        apply.Size = UDim2.new(0, 62, 0, 28)
        apply.Position = UDim2.new(1, -74, 0, 202)
        apply.BackgroundColor3 = Color3.fromRGB(160, 120, 255)
        apply.BorderSizePixel = 0
        apply.Text = "Apply"
        apply.TextColor3 = Color3.fromRGB(255, 255, 255)
        apply.TextSize = 12
        apply.Font = SelectedFont
        apply.ZIndex = 121
        apply.Parent = ColorPickerFrame

        
        local hint = Instance.new("TextLabel")
        hint.Size = UDim2.new(1, -20, 0, 18)
        hint.Position = UDim2.new(0, 12, 0, 238)
        hint.BackgroundTransparency = 1
        hint.Text = "Drag on square / hue · Enter hex · Apply"
        hint.TextColor3 = Color3.fromRGB(120, 120, 130)
        hint.TextSize = 10
        hint.Font = SelectedFont
        hint.TextXAlignment = Enum.TextXAlignment.Left
        hint.ZIndex = 121
        hint.Parent = ColorPickerFrame

        local function refreshFromHSV(live)
            local h = ColorPickerState.H
            local s = ColorPickerState.S
            local v = ColorPickerState.V
            local col = Color3.fromHSV(h, s, v)
            Cache.PickerSelectedColor = col
            satFrame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            preview.BackgroundColor3 = col
            hexBox.Text = ColorToHex(col)
            svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
            hueCursor.Position = UDim2.new(0.5, 0, h, 0)
            if ColorPickerPreviewBtn then
                pcall(function() ColorPickerPreviewBtn.BackgroundColor3 = col end)
            end
            if live and ColorPickerCallback then
                
            end
        end
        Cache.ColorPickerRefresh = refreshFromHSV

        local function setFromColor(col)
            if not col then return end
            local h, s, v = col:ToHSV()
            ColorPickerState.H, ColorPickerState.S, ColorPickerState.V = h, s, v
            refreshFromHSV(false)
        end
        Cache.ColorPickerSetFromColor = setFromColor

        local function updateFromMouse(absPos, mode)
            if mode == "sv" then
                local ap = satFrame.AbsolutePosition
                local as = satFrame.AbsoluteSize
                if as.X <= 0 or as.Y <= 0 then return end
                local sx = math.clamp((absPos.X - ap.X) / as.X, 0, 1)
                local sy = math.clamp((absPos.Y - ap.Y) / as.Y, 0, 1)
                ColorPickerState.S = sx
                ColorPickerState.V = 1 - sy
                refreshFromHSV(true)
            elseif mode == "hue" then
                local ap = hueFrame.AbsolutePosition
                local as = hueFrame.AbsoluteSize
                if as.Y <= 0 then return end
                local hy = math.clamp((absPos.Y - ap.Y) / as.Y, 0, 1)
                ColorPickerState.H = hy
                refreshFromHSV(true)
            end
        end

        satFrame.MouseButton1Down:Connect(function()
            ColorPickerState.DraggingSV = true
            updateFromMouse(UserInputService:GetMouseLocation(), "sv")
        end)
        hueFrame.MouseButton1Down:Connect(function()
            ColorPickerState.DraggingHue = true
            updateFromMouse(UserInputService:GetMouseLocation(), "hue")
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            if not ColorPickerFrame or not ColorPickerFrame.Visible then return end
            if ColorPickerState.DraggingSV then
                updateFromMouse(input.Position, "sv")
            elseif ColorPickerState.DraggingHue then
                updateFromMouse(input.Position, "hue")
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                ColorPickerState.DraggingSV = false
                ColorPickerState.DraggingHue = false
            end
        end)

        hexBox.FocusLost:Connect(function(enter)
            local c = HexToColor(hexBox.Text)
            if c then
                setFromColor(c)
                Cache.PickerSelectedColor = c
                if ColorPickerPreviewBtn then
                    pcall(function() ColorPickerPreviewBtn.BackgroundColor3 = c end)
                end
            else
                hexBox.Text = ColorToHex(Cache.PickerSelectedColor or col0)
            end
        end)
        hexBox:GetPropertyChangedSignal("Text"):Connect(function()
            local c = HexToColor(hexBox.Text)
            if c then
                Cache.PickerSelectedColor = c
                preview.BackgroundColor3 = c
                if ColorPickerPreviewBtn then
                    pcall(function() ColorPickerPreviewBtn.BackgroundColor3 = c end)
                end
            end
        end)

        apply.MouseButton1Click:Connect(function()
            local col = Cache.PickerSelectedColor or Color3.fromRGB(180, 140, 255)
            if ColorPickerCallback then
                pcall(ColorPickerCallback, col)
            end
            if ColorPickerPreviewBtn then
                pcall(function() ColorPickerPreviewBtn.BackgroundColor3 = col end)
            end
            CloseRGBPicker()
        end)

        MakeDraggable(ColorPickerFrame, title)
        refreshFromHSV(false)
    end

    if Cache.ColorPickerSetFromColor then
        Cache.ColorPickerSetFromColor(col0)
    end
    pcall(function()
        if Cache.AnxiumListShell then Cache.AnxiumListShell.Visible = false end
        ColorPickerFrame.Parent = ScreenGui
        ColorPickerFrame.Visible = false
        ColorPickerFrame.ZIndex = 400
        for _, node in ipairs(ColorPickerFrame:GetDescendants()) do
            if node:IsA("GuiObject") then
                node.ZIndex = math.max(node.ZIndex, 401)
            end
        end
    end)
    ColorPickerFrame.Visible = true
end


function AnxiumEnsureHeaderStroke(anchor)
    if not anchor then return end
    for _, ch in ipairs(anchor:GetChildren()) do
        if ch:IsA("UICorner") then
            pcall(function() ch:Destroy() end)
        end
    end
    local st = anchor:FindFirstChild("HeaderListStroke")
    if not st then
        st = Instance.new("UIStroke")
        st.Name = "HeaderListStroke"
        st.Thickness = 1
        st.Transparency = 0.35
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        st.Parent = anchor
        pcall(function()
            if TrackThemeAccent then TrackThemeAccent(st, "Color") end
        end)
    end
    st.Color = Theme.Accent or Color3.fromRGB(180, 140, 255)
    st.Thickness = 1
    st.Transparency = 0.35
    st.Enabled = true
    return st
end

function AnxiumMakeListArrow(parent)
    local img = Instance.new("ImageLabel")
    img.Name = "ListArrow"
    img.Size = UDim2.fromOffset(22, 22)
    img.Position = UDim2.new(1, -30, 0.5, -11)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://98648581502859"
    img.ImageColor3 = Theme.Text or Color3.fromRGB(220, 220, 230)
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = parent
    task.defer(function()
        pcall(AnxiumEnsureHeaderStroke, parent)
    end)
    return img
end

function AnxiumListFrameStroke(frame)
    if not frame then return end
    for _, ch in ipairs(frame:GetChildren()) do
        if ch:IsA("UICorner") then
            pcall(function() ch:Destroy() end)
        end
    end
    local old = frame:FindFirstChild("ListStroke")
    if old then old:Destroy() end
    local st = Instance.new("UIStroke")
    st.Name = "ListStroke"
    st.Color = Theme.Accent or Color3.fromRGB(180, 140, 255)
    st.Thickness = 1.5
    st.Transparency = 0.15
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    st.Enabled = false
    st.Parent = frame
    pcall(function()
        if TrackThemeAccent then TrackThemeAccent(st, "Color") end
    end)
    return st
end

function AnxiumEnsureListShell()
    local shell = Cache.AnxiumListShell
    if shell and shell.Parent then return shell end
    local parent = ScreenGui
    shell = Instance.new("Frame")
    shell.Name = "AnxiumListShell"
    shell.BackgroundTransparency = 1
    shell.BorderSizePixel = 0
    shell.ZIndex = 200
    shell.Visible = false
    shell.Parent = parent
    local st = Instance.new("UIStroke")
    st.Name = "ShellStroke"
    st.Thickness = 1
    st.Transparency = 0.35
    st.Color = Theme.Accent or Color3.fromRGB(180, 140, 255)
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    st.Parent = shell
    pcall(function()
        if TrackThemeAccent then TrackThemeAccent(st, "Color") end
    end)
    Cache.AnxiumListShell = shell
    return shell
end

function AnxiumUpdateListShell(anchor, listFrame)
    local shell = AnxiumEnsureListShell()
    if not anchor or not listFrame or not listFrame.Visible then
        shell.Visible = false
        return
    end
    if (listFrame.AbsoluteSize and listFrame.AbsoluteSize.Y or 0) < 8 then
        shell.Visible = false
        return
    end
    local origin = ScreenGui and ScreenGui.AbsolutePosition or Vector2.zero
    local aPos = anchor.AbsolutePosition - origin
    local aSize = anchor.AbsoluteSize
    local lPos = listFrame.AbsolutePosition - origin
    local lSize = listFrame.AbsoluteSize
    local x = math.min(aPos.X, lPos.X)
    local y = math.min(aPos.Y, lPos.Y)
    local r = math.max(aPos.X + aSize.X, lPos.X + lSize.X)
    local b = math.max(aPos.Y + aSize.Y, lPos.Y + lSize.Y)

    local clip = listFrame.Parent
    while clip and clip ~= ScreenGui do
        if clip:IsA("ScrollingFrame") or (clip:IsA("Frame") and clip.ClipsDescendants) then
            local cPos = clip.AbsolutePosition - origin
            local cSize = clip.AbsoluteSize
            x = math.max(x, cPos.X)
            y = math.max(y, cPos.Y)
            r = math.min(r, cPos.X + cSize.X)
            b = math.min(b, cPos.Y + cSize.Y)
            break
        end
        clip = clip.Parent
    end

    if r - x < 2 or b - y < 2 then
        shell.Visible = false
        return
    end

    shell.Position = UDim2.fromOffset(math.floor(x + 0.5), math.floor(y + 0.5))
    shell.Size = UDim2.fromOffset(math.max(math.floor(r - x + 0.5), 1), math.max(math.floor(b - y + 0.5), 1))
    local st = shell:FindFirstChild("ShellStroke")
    if st then
        st.Color = Theme.Accent or Color3.fromRGB(180, 140, 255)
        st.Thickness = 1
        st.Transparency = 0.35
        st.Enabled = true
    end
    shell.Visible = true
end

function AnxiumSetListOpen(listFrame, open, openHeight, anchor)
    if not listFrame then return end
    open = open and true or false
    if anchor then
        Cache.AnxiumListAnchors = Cache.AnxiumListAnchors or {}
        Cache.AnxiumListAnchors[listFrame] = anchor
        AnxiumEnsureHeaderStroke(anchor)
    else
        Cache.AnxiumListAnchors = Cache.AnxiumListAnchors or {}
        anchor = Cache.AnxiumListAnchors[listFrame]
    end

    if open then
        if Cache.AnxiumOpenListFrame and Cache.AnxiumOpenListFrame ~= listFrame then
            AnxiumSetListOpen(Cache.AnxiumOpenListFrame, false)
        end
        listFrame.Visible = true
        if openHeight then
            listFrame.Size = UDim2.new(0.96, 0, 0, openHeight)
        end
        listFrame.ClipsDescendants = true
        local function stripCorners(inst)
            if not inst then return end
            local function shouldKeep(corner)
                local p = corner.Parent
                if not p then return false end
                return false
            end
            for _, ch in ipairs(inst:GetDescendants()) do
                if ch:IsA("UICorner") and not shouldKeep(ch) then
                    pcall(function() ch:Destroy() end)
                end
            end
            for _, ch in ipairs(inst:GetChildren()) do
                if ch:IsA("UICorner") and not shouldKeep(ch) then
                    pcall(function() ch:Destroy() end)
                end
            end
        end
        stripCorners(listFrame)
        stripCorners(anchor)
        if Cache.AnxiumListShell then stripCorners(Cache.AnxiumListShell) end
        if anchor then
            for _, ch in ipairs(anchor:GetChildren()) do
                if ch:IsA("UICorner") then pcall(function() ch:Destroy() end) end
            end
        end
        local shell = Cache.AnxiumListShell
        if shell then
            for _, ch in ipairs(shell:GetChildren()) do
                if ch:IsA("UICorner") then pcall(function() ch:Destroy() end) end
            end
        end
        local st = listFrame:FindFirstChild("ListStroke")
        if st and st:IsA("UIStroke") then st.Enabled = false end
        for _, d in ipairs(listFrame:GetDescendants()) do
            if d:IsA("TextButton") then
                local bst = d:FindFirstChild("ItemStroke")
                if bst then bst.Enabled = false end
            end
        end
        if anchor then
            local hs = anchor:FindFirstChild("HeaderListStroke")
            if hs then hs.Enabled = false end
            local arrow = anchor:FindFirstChild("ListArrow", true)
            if arrow and arrow:IsA("ImageLabel") then
                arrow.Image = "rbxassetid://71457658246709"
                arrow.Rotation = 0
            end
        end
        Cache.AnxiumOpenListFrame = listFrame
        Cache.AnxiumOpenListAnchor = anchor
        task.defer(function()
            AnxiumUpdateListShell(anchor, listFrame)
            pcall(function()
                local tab = CurrentTab
                local fn = Cache.TabCanvasRefresh and Cache.TabCanvasRefresh[tab]
                if fn then fn() end
            end)
        end)
    else
        listFrame.Size = UDim2.new(0.96, 0, 0, 0)
        listFrame.Visible = false
        local st = listFrame:FindFirstChild("ListStroke")
        if st and st:IsA("UIStroke") then st.Enabled = false end
        local anchorRef = anchor or (Cache.AnxiumListAnchors and Cache.AnxiumListAnchors[listFrame])
        if anchorRef then
            AnxiumEnsureHeaderStroke(anchorRef)
            local arrow = anchorRef:FindFirstChild("ListArrow", true)
            if arrow and arrow:IsA("ImageLabel") then
                arrow.Image = "rbxassetid://98648581502859"
                arrow.Rotation = 0
            end
        end
        if Cache.AnxiumOpenListFrame == listFrame then
            Cache.AnxiumOpenListFrame = nil
            Cache.AnxiumOpenListAnchor = nil
        end
        local shell = Cache.AnxiumListShell
        if shell then shell.Visible = false end
        task.defer(function()
            pcall(function()
                local tab = CurrentTab
                local fn = Cache.TabCanvasRefresh and Cache.TabCanvasRefresh[tab]
                if fn then fn() end
            end)
        end)
    end
end

if not Cache._AnxiumListShellLoop then
    Cache._AnxiumListShellLoop = true
    RunService.RenderStepped:Connect(function()
        if not MenuOpen then
            local shell = Cache.AnxiumListShell
            if shell and shell.Visible then shell.Visible = false end
            return
        end
        if ColorPickerFrame and ColorPickerFrame.Visible then
            local shell = Cache.AnxiumListShell
            if shell and shell.Visible then shell.Visible = false end
            return
        end
        local lf = Cache.AnxiumOpenListFrame
        local an = Cache.AnxiumOpenListAnchor
        if lf and lf.Visible and an then
            AnxiumUpdateListShell(an, lf)
        else
            local shell = Cache.AnxiumListShell
            if shell and shell.Visible then shell.Visible = false end
        end
    end)
end

task.spawn(function()
    for _ = 1, 12 do
        task.wait(0.2)
        if ScreenGui then
            for _, gui in ipairs(ScreenGui:GetDescendants()) do
                if gui.Name == "ListArrow" and gui.Parent then
                    pcall(AnxiumEnsureHeaderStroke, gui.Parent)
                end
            end
        end
    end
end)

if ScreenGui and not Cache._AnxiumListStrokeHook then
    Cache._AnxiumListStrokeHook = true
    ScreenGui.DescendantAdded:Connect(function(d)
        if d and d.Name == "ListArrow" and d.Parent then
            task.defer(function()
                pcall(AnxiumEnsureHeaderStroke, d.Parent)
            end)
        end
    end)
end

CreateFeatureRow = function(name, layoutOrder, parentTab, colorKey)
    local host = ResolveUIParent(parentTab)
    local inGroup = host ~= parentTab
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(inGroup and 1 or 0.96, 0, 0, 36)
    Row.BackgroundColor3 = Theme.Card
    Row.BackgroundTransparency = inGroup and 1 or 0
    Row.BorderSizePixel = 0
    Row.LayoutOrder = layoutOrder
    Row.Parent = host
    pcall(function()
        Row:SetAttribute("AnxiumSearchText", string.lower(tostring(name or "")))
    end)

    if not inGroup then
    end

    local div = Instance.new("Frame")
    div.Name = "RowDivider"
    div.Size = UDim2.new(1, inGroup and -8 or -20, 0, 1)
    div.Position = UDim2.new(0, inGroup and 4 or 10, 1, -1)
    div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    div.BackgroundTransparency = 0.94
    div.BorderSizePixel = 0
    div.ZIndex = 2
    div.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, inGroup and 10 or 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = SelectedFont
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    if colorKey then
        local colBtn = Instance.new("TextButton")
        colBtn.Name = "ColorBtn"
        colBtn.Size = UDim2.new(0, 22, 0, 22)
        colBtn.Position = UDim2.new(1, -78, 0.5, -11)
        colBtn.BackgroundColor3 = Config[colorKey] or Theme.Accent
        colBtn.BorderSizePixel = 0
        colBtn.Text = ""
        colBtn.Parent = Row
        Cache.ColorButtons = Cache.ColorButtons or {}
        Cache.ColorButtons[colorKey] = colBtn
        pcall(function()
            colBtn:SetAttribute("AnxiumColorKey", tostring(colorKey))
        end)

        colBtn.MouseButton1Click:Connect(function()
            OpenRGBPicker(Config[colorKey] or Theme.Accent, function(col)
                Config[colorKey] = col
                colBtn.BackgroundColor3 = col
                
                pcall(function()
                    if colorKey == "Color_TargetRing" then
                        
                    elseif colorKey == "Color_Orbit" then
                        OrbTrail1.Color = ColorSequence.new(col)
                        OrbTrail2.Color = ColorSequence.new(col)
                    elseif colorKey == "Color_TargetLine" then
                        if TargetLineDraw then TargetLineDraw.Color = col end
                    elseif colorKey == "Color_TargetHud" then
                        if ApplyTargetHudColor then
                            ApplyTargetHudColor(col)
                        else
                            if TargetHudStroke then TargetHudStroke.Color = col end
                            if AvatarStroke then AvatarStroke.Color = col end
                            if TargetHealthFill then TargetHealthFill.BackgroundColor3 = Color3.fromRGB(255,255,255) end
                            if Cache.TargetHealthGrad and TargetHud_HealthGradFromColor then
                                Cache.TargetHealthGrad.Color = TargetHud_HealthGradFromColor(col)
                            end
                        end
                    elseif colorKey == "Color_Trail" then
                        if Cache.PlayerTrail then Cache.PlayerTrail.Color = ColorSequence.new(col) end
                    elseif colorKey == "Color_Fov" then
                        FovCircle.Color = col
                    elseif colorKey == "Color_FovFill" then
                        if FovCircleFill then FovCircleFill.Color = col end
                    elseif colorKey == "Color_SilentV2FovFill" then
                        if Cache.SilentV2FovCircleFill then Cache.SilentV2FovCircleFill.Color = col end
                    elseif colorKey == "Color_Aura" then
                        ClassicAura_RefreshAll()
                        if ParticleAura_RefreshAll then ParticleAura_RefreshAll() end
                    elseif colorKey == "Color_Chams" then
                        for _, ch in pairs(Cache.Chams) do
                            if ch and ch.Parent then ch.FillColor = col end
                        end
                    elseif colorKey == "Color_TeamEsp" then
                    elseif colorKey == "Color_BoxEsp" or colorKey == "Color_BoxEspFill" then
                        for _, boxData in pairs(Cache.Boxes) do
                            if boxData then
                                local c1 = Config.Color_BoxEsp or col
                                local c2 = Config.Color_BoxEspFill or Color3.fromRGB(80, 40, 160)
                                if boxData.Box then boxData.Box.Color = c1 end
                                if boxData.Fill then boxData.Fill.Color = c1 end
                                if boxData.Outline then
                                    boxData.Outline.Color = Color3.new(
                                        math.clamp(c1.R * 0.22, 0, 1),
                                        math.clamp(c1.G * 0.22, 0, 1),
                                        math.clamp(c1.B * 0.22, 0, 1)
                                    )
                                end
                                if boxData.Corners then
                                    for _, ln in pairs(boxData.Corners) do if ln then ln.Color = c1 end end
                                end
                                if boxData.Gradients then
                                    local steps = #boxData.Gradients
                                    for i, g in ipairs(boxData.Gradients) do
                                        if g then
                                            local t = (i - 1) / math.max(steps - 1, 1)
                                            g.Color = c1:Lerp(c2, t)
                                        end
                                    end
                                end
                            end
                        end
                    elseif colorKey == "Color_ForceField" then
                        if Config.ForceFieldEnabled then ForceField_Update() end
                    elseif colorKey == "Color_WeaponFF" then
                        Cache.WeaponFFLastApply = 0
                        if Config.WeaponForceFieldEnabled and WeaponFF_UpdateColor then
                            WeaponFF_UpdateColor()
                        end
                    elseif colorKey == "Color_AngelHalo" then
                        Cache.AngelHaloSig = nil
                        if Config.AngelHaloEnabled and AngelHalo_Update then
                            pcall(AngelHalo_Update)
                        end
                    elseif colorKey == "Color_ChinaHat" then
                        if Config.ChinaHatEnabled then
                            pcall(function()
                                if BuildHatDrawing then BuildHatDrawing() end
                            end)
                        end
                    elseif colorKey == "Color_JumpCircle" then
                    elseif colorKey == "Color_BulletTracer" then
                    elseif colorKey == "Color_FallingStars" then
                        if Cache.FallingStarsApply then pcall(Cache.FallingStarsApply) end
                    elseif colorKey == "Color_OffscreenArrow" then
                        if UV_RefreshArrowGradients then UV_RefreshArrowGradients() end
                    elseif colorKey == "Color_Crosshair" then
                        CrosshairX.Color = col
                        CrosshairY.Color = col
                    elseif colorKey == "Color_Tracers" or colorKey == "Color_TracerGradientB" then
                        for _, tr in pairs(Cache.TracerLines or {}) do
                            if typeof(tr) == "table" and tr.Segs then
                                for _, line in ipairs(tr.Segs) do if line then line.Color = col end end
                            elseif tr then tr.Color = col end
                        end
                    elseif colorKey == "Color_Healthbar" then
                        for _, hb in pairs(Cache.Healthbars or {}) do
                            if hb and hb.Fill then hb.Fill.Color = col end
                        end
                    end
                end)
                Notify("Color", name .. " color set")
            end, colBtn)
        end)
    end

    local SwitchBg = Instance.new("Frame")
    SwitchBg.Name = "SwitchBg"
    SwitchBg.Size = UDim2.new(0, 34, 0, 18)
    SwitchBg.AnchorPoint = Vector2.new(1, 0.5)
    SwitchBg.Position = UDim2.new(1, -10, 0.5, 0)
    SwitchBg.BackgroundColor3 = Theme.ToggleOff
    SwitchBg.BorderSizePixel = 0
    SwitchBg.ClipsDescendants = true
    SwitchBg.Parent = Row

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchBg

    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Name = "SwitchKnob"
    SwitchKnob.Size = UDim2.new(0, 14, 0, 14)
    SwitchKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    SwitchKnob.Position = UDim2.new(0, 9, 0.5, 0)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SwitchKnob.BorderSizePixel = 0
    SwitchKnob.ZIndex = 2
    SwitchKnob.Parent = SwitchBg

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SwitchKnob

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.ZIndex = 3
    Button.Parent = SwitchBg

    return Button, SwitchBg, SwitchKnob
end

Cache.GroupParentByTab = Cache.GroupParentByTab or {}

ResolveUIParent = function(parentTab)
    if parentTab and Cache.GroupParentByTab and Cache.GroupParentByTab[parentTab] then
        return Cache.GroupParentByTab[parentTab]
    end
    return parentTab
end

CreateGroupPanel = function(title, layoutOrder, parentTab)
    if not parentTab then return parentTab end
    local function prettyTitle(s)
        s = tostring(s or "")
        if s == "" then return s end
        return string.upper(string.sub(s, 1, 1)) .. string.lower(string.sub(s, 2))
    end
    local wrap = Instance.new("Frame")
    wrap.Name = "Group_" .. tostring(title):gsub("%s+", "_")
    wrap.Size = UDim2.new(0.96, 0, 0, 0)
    wrap.AutomaticSize = Enum.AutomaticSize.None
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel = 0
    wrap.LayoutOrder = layoutOrder or 0
    wrap.ClipsDescendants = false
    wrap.Parent = parentTab
    local wrapLay = Instance.new("UIListLayout")
    wrapLay.SortOrder = Enum.SortOrder.LayoutOrder
    wrapLay.Padding = UDim.new(0, 6)
    wrapLay.Parent = wrap
    local wrapPad = Instance.new("UIPadding")
    wrapPad.PaddingBottom = UDim.new(0, 6)
    wrapPad.Parent = wrap

    local head = Instance.new("TextLabel")
    head.Name = "GroupTitle"
    head.Size = UDim2.new(1, -4, 0, 16)
    head.BackgroundTransparency = 1
    head.Text = prettyTitle(title or "")
    head.TextColor3 = Theme.TextDim
    head.TextSize = 11
    head.Font = SelectedFont
    head.TextXAlignment = Enum.TextXAlignment.Left
    head.LayoutOrder = 0
    head.Parent = wrap
    Cache.SectionLabels = Cache.SectionLabels or {}
    table.insert(Cache.SectionLabels, head)

    local card = Instance.new("Frame")
    card.Name = "GroupCard"
    card.Size = UDim2.new(1, 0, 0, 12)
    card.AutomaticSize = Enum.AutomaticSize.None
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    card.BackgroundTransparency = 0
    card.BorderSizePixel = 0
    card.LayoutOrder = 1
    card.ClipsDescendants = false
    card.Parent = wrap
    local cardPad = Instance.new("UIPadding")
    cardPad.PaddingTop = UDim.new(0, 6)
    cardPad.PaddingBottom = UDim.new(0, 6)
    cardPad.PaddingLeft = UDim.new(0, 8)
    cardPad.PaddingRight = UDim.new(0, 8)
    cardPad.Parent = card
    local cardLay = Instance.new("UIListLayout")
    cardLay.SortOrder = Enum.SortOrder.LayoutOrder
    cardLay.Padding = UDim.new(0, 4)
    cardLay.Parent = card

    local content = Instance.new("Frame")
    content.Name = "GroupContent"
    content.Size = UDim2.new(1, 0, 0, 0)
    content.AutomaticSize = Enum.AutomaticSize.None
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.LayoutOrder = 0
    content.ClipsDescendants = false
    content.Parent = card
    local contentLay = Instance.new("UIListLayout")
    contentLay.SortOrder = Enum.SortOrder.LayoutOrder
    contentLay.Padding = UDim.new(0, 4)
    contentLay.Parent = content

    local function refreshSizes()
        local ch = 0
        pcall(function()
            ch = contentLay.AbsoluteContentSize.Y
        end)
        if ch < 1 then
            local sum = 0
            for _, child in ipairs(content:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible then
                    local h = child.AbsoluteSize.Y
                    if h < 1 then
                        h = child.Size.Y.Offset
                    end
                    if h > 0 then sum = sum + h + 4 end
                end
            end
            if sum > ch then ch = sum end
        end
        if ch < 0 then ch = 0 end
        content.Size = UDim2.new(1, 0, 0, ch)
        local cardH = ch + 12
        if cardH < 12 then cardH = 12 end
        card.Size = UDim2.new(1, 0, 0, cardH)
        local wrapH = 16 + 6 + cardH + 6
        wrap.Size = UDim2.new(0.96, 0, 0, wrapH)
        pcall(function()
            if parentTab and parentTab:IsA("ScrollingFrame") then
                local lay = parentTab:FindFirstChildOfClass("UIListLayout")
                if lay then
                    local h = 0
                    for _, child in ipairs(parentTab:GetChildren()) do
                        if child:IsA("GuiObject") and child.Visible and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                            local hh = child.Size.Y.Offset
                            if hh < 1 then hh = child.AbsoluteSize.Y end
                            if hh > 0 then h = h + hh + 16 end
                        end
                    end
                    if h < lay.AbsoluteContentSize.Y then h = lay.AbsoluteContentSize.Y end
                    parentTab.CanvasSize = UDim2.new(0, 0, 0, math.max(h + 40, 1))
                end
            end
        end)
    end
    contentLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        task.defer(refreshSizes)
    end)
    content.ChildAdded:Connect(function()
        task.defer(refreshSizes)
        task.delay(0.05, refreshSizes)
    end)
    content.ChildRemoved:Connect(function()
        task.defer(refreshSizes)
    end)
    task.defer(refreshSizes)
    task.delay(0.15, refreshSizes)
    task.delay(0.5, refreshSizes)
    task.delay(1.2, refreshSizes)

    Cache.GroupParentByTab[parentTab] = content
    return content
end

CreateSectionHeader = function(title, layoutOrder, parentTab)
    local clean = tostring(title or "Section")
    clean = clean:gsub("-", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if clean == "" then clean = "Section" end
    return CreateGroupPanel(clean, layoutOrder, parentTab)
end

EspGroupContent = CreateGroupPanel("ESP", 0, VisualsTab)
CreateGroupPanel("Aim", 0, CombatTab)
CreateGroupPanel("Movement", 0, MovementTab)

UpdateSwitch = function(state, bg, knob, featureName)
    local info = TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    pcall(function()
        if knob then
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Size = UDim2.new(0, 14, 0, 14)
        end
    end)
    if state then
        if bg then TweenService:Create(bg, info, {BackgroundColor3 = Theme.Accent}):Play() end
        if knob then
            TweenService:Create(knob, info, {Position = UDim2.new(1, -9, 0.5, 0)}):Play()
        end
        if bg then
            local g = bg:FindFirstChild("SwitchGlow")
            if g then TweenService:Create(g, info, {Transparency = 0.25, Thickness = 2}):Play() end
        end
    else
        if bg then TweenService:Create(bg, info, {BackgroundColor3 = Theme.ToggleOff}):Play() end
        if knob then
            TweenService:Create(knob, info, {Position = UDim2.new(0, 9, 0.5, 0)}):Play()
        end
        if bg then
            local g = bg:FindFirstChild("SwitchGlow")
            if g then TweenService:Create(g, info, {Transparency = 0.92, Thickness = 1.5}):Play() end
        end
    end
    if featureName then
        Notify("Anxium", featureName .. (state and " enabled" or " disabled"))
    end
    if UpdateActiveList then UpdateActiveList() end
    if UpdateBindList then UpdateBindList() end
end

CreateSliderRow = function(name, minVal, maxVal, defaultVal, layoutOrder, parentTab, callback)
    local host = ResolveUIParent(parentTab)
    local inGroup = host ~= parentTab
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(inGroup and 1 or 0.96, 0, 0, 48)
    Row.BackgroundColor3 = Theme.Card
    Row.BackgroundTransparency = inGroup and 1 or 0
    Row.BorderSizePixel = 0
    Row.LayoutOrder = layoutOrder
    Row.Parent = host
    pcall(function()
        Row:SetAttribute("AnxiumSearchText", string.lower(tostring(name or "")))
    end)

    local div = Instance.new("Frame")
    div.Name = "RowDivider"
    div.Size = UDim2.new(1, -16, 0, 1)
    div.Position = UDim2.new(0, 8, 1, -1)
    div.BackgroundColor3 = Color3.fromRGB(55, 58, 70)
    div.BackgroundTransparency = 0.35
    div.BorderSizePixel = 0
    div.ZIndex = 2
    div.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 0, 18)
    Label.Position = UDim2.new(0, 12, 0, 6)
    Label.BackgroundTransparency = 1
    do
        local dv = tonumber(defaultVal) or 0
        local span = maxVal - minVal
        local needFloat = (minVal % 1 ~= 0) or (maxVal % 1 ~= 0) or span <= 10
        if needFloat then
            if span <= 1 then
                Label.Text = name .. "  " .. string.format("%.3f", dv)
            elseif span <= 20 then
                Label.Text = name .. "  " .. string.format("%.2f", dv)
            else
                Label.Text = name .. "  " .. string.format("%.1f", dv)
            end
        else
            Label.Text = name .. "  " .. tostring(math.floor(dv + 0.5))
        end
    end
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = SelectedFont
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -24, 0, 5)
    SliderBar.Position = UDim2.new(0, 12, 1, -14)
    SliderBar.BackgroundColor3 = Theme.BgTertiary
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Row

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = Theme.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    Cache.SliderFills = Cache.SliderFills or {}
    table.insert(Cache.SliderFills, SliderFill)

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill

    
    pcall(function() TrackThemeAccent(SliderFill, "BackgroundColor3") end)

    local Knob = Instance.new("Frame")
    Knob.Name = "SliderKnob"
    Knob.Size = UDim2.fromOffset(9, 9)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((defaultVal - minVal) / math.max(maxVal - minVal, 1e-6), 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 2
    Knob.Parent = SliderBar
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local isDragging = false
    local function formatSliderValue(v)
        if typeof(v) ~= "number" then return tostring(v) end
        local span = maxVal - minVal
        local needFloat = (minVal % 1 ~= 0) or (maxVal % 1 ~= 0) or span <= 10
        if not needFloat then
            return tostring(math.floor(v + 0.5))
        end
        if span <= 1 then
            return string.format("%.3f", v)
        elseif span <= 20 then
            return string.format("%.2f", v)
        end
        return string.format("%.1f", v)
    end

    local function quantizeSliderValue(raw)
        local span = maxVal - minVal
        local needFloat = (minVal % 1 ~= 0) or (maxVal % 1 ~= 0) or span <= 10
        if not needFloat then
            return math.floor(raw + 0.5)
        end
        local decimals = 2
        if span <= 1 then
            decimals = 3
        elseif span <= 20 then
            decimals = 2
        else
            decimals = 1
        end
        local mult = 10 ^ decimals
        local v = math.floor(raw * mult + 0.5) / mult
        if v < minVal then v = minVal end
        if v > maxVal then v = maxVal end
        return v
    end

    local function UpdateSlider(input)
        local barSize = SliderBar.AbsoluteSize.X
        if barSize < 1 then barSize = 1 end
        local relX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / barSize, 0, 1)
        local raw = minVal + (maxVal - minVal) * relX
        local value = quantizeSliderValue(raw)
        local shownRel = math.clamp((value - minVal) / (maxVal - minVal), 0, 1)
        SliderFill.Size = UDim2.new(shownRel, 0, 1, 0)
        if Knob then
            Knob.Position = UDim2.new(shownRel, 0, 0.5, 0)
        end
        Label.Text = name .. "  " .. formatSliderValue(value)
        callback(value)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    local function applyVisual(newVal)
        newVal = quantizeSliderValue(tonumber(newVal) or minVal)
        local relX = math.clamp((newVal - minVal) / (maxVal - minVal), 0, 1)
        SliderFill.Size = UDim2.new(relX, 0, 1, 0)
        if Knob then
            Knob.Position = UDim2.new(relX, 0, 0.5, 0)
        end
        Label.Text = name .. "  " .. formatSliderValue(newVal)
        return newVal
    end
    Cache.SliderBinds = Cache.SliderBinds or {}
    Cache.SliderBinds[#Cache.SliderBinds + 1] = {
        name = tostring(name or ""),
        min = minVal,
        max = maxVal,
        apply = applyVisual,
    }
    return function(newVal, skipCallback)
        local v = applyVisual(newVal)
        if not skipCallback then
            callback(v)
        end
        return v
    end
end

function RefreshAllSliders()
    local getters = {
        ['Hat Global Scale'] = function() return math.floor((Config.ChinaHatScale or 1) * 10) end,
        ['Gradient Speed'] = function() return math.floor((tonumber(Config.BlurGradientSpeed) or 1) * 100) end,
        ['Dynamic Expand'] = function() return math.floor(tonumber(Config.ScopeDynamicExpand) or 30) end,
        ['FOV Dynamic Expand'] = function() return math.floor(tonumber(Config.FovDynamicExpand) or 40) end,
        ['Silent Dynamic Expand'] = function() return math.floor(tonumber(Config.SilentV2FovDynamicExpand) or 40) end,
        ['AA Resolve Return (ms)'] = function() return math.floor(tonumber(Config.AntiAimResolveReturnMs) or 60) end,
        ['AA Resolve Hold (ms)'] = function() return math.floor(tonumber(Config.AntiAimResolveHoldMs) or 100) end,
        ['Lightning Size'] = function() return math.floor((tonumber(Config.KillLightningSize) or 1.5) * 100) end,
        ['Lightning Duration'] = function() return math.floor((tonumber(Config.KillLightningDuration) or 0.55) * 100) end,
        ['Blur Transparency'] = function() return math.floor((tonumber(Config.BlurGradientTransparency) or 0.28) * 100) end,
        ['Name ESP Fill Corner'] = function() return math.floor(tonumber(Config.NameEspFillCorner) or 4) end,
        ['Hat Height Offset'] = function() return math.floor((Config.ChinaHatHeightOffset or 0.5) * 10) end,
        ['Hat Height'] = function() return math.floor((Config.ChinaHatHeight or 1.7) * 10) end,
        ['Hat Radius'] = function() return math.floor((Config.ChinaHatRadius or 2.3) * 10) end,
        ['Aspect Scale (%)'] = function() return math.floor((Config.AspectRatioValue or 1.333) * 100) end,
        ['Arrow Pulse Speed'] = function() return Config.ArrowPulseSpeed or 3 end,
        ['Scope Thickness'] = function() return math.clamp(math.floor(tonumber(Config.ScopeThickness) or 2), 1, 10) end,
        ['Fill Rot Speed'] = function() return Config.BoxFillRotationSpeed or 2 end,
        ['Spin Speed'] = function() return Config.SpinCrosshairSpeed or 180 end,
        ['Scope Line Length'] = function() return math.floor(tonumber(Config.ScopeLength) or 80) end,
        ['Scope Center Gap'] = function() return math.floor(tonumber(Config.ScopeGap) or 8) end,
        ['Scope Zoom FOV'] = function() return Config.ScopeZoomFOV or 40 end,
        ['Arrow Radius'] = function() return math.floor((Config.ArrowDistance or 0.42) * 100) end,
        ['Arrow Size'] = function() return math.floor(tonumber(Config.ArrowSize) or 34) end,
        ['Arrow Grad Speed'] = function() return math.floor((Config.ArrowGradientSpeed or 0.35) * 10) end,
        ['FOV Value'] = function() return Config.CameraFovValue or 120 end,
        ['Darkness'] = function() return math.floor(tonumber(Config.DarkModeIntensity) or 50) end,
        ['World Color Intensity'] = function() return math.floor(tonumber(Config.WorldColorIntensity) or 55) end,
        ['Hit Marker Duration'] = function() return tonumber(Config.HitMarkerDuration) or 1.2 end,
        ['Hit Marker Size'] = function() return math.floor(tonumber(Config.HitMarkerSize) or 18) end,
        ['Hit Marker Gap'] = function() return math.floor(tonumber(Config.HitMarkerGap) or 6) end,
        ['Hit Marker Thickness'] = function() return math.floor(tonumber(Config.HitMarkerThickness) or 3) end,
        ['Hit Marker Rotation'] = function() return tonumber(Config.HitMarkerRotation) or 0 end,
        ['Active HUD Transparency'] = function() return math.floor((tonumber(Config.ActiveListTransparency) or 0.05) * 100) end,
        ['Binds HUD Transparency'] = function() return math.floor((tonumber(Config.BindListTransparency) or 0.05) * 100) end,
        ['Mesh Size'] = function() return Config.ChinaHatMeshSize or 3 end,
        ['Mesh Transparency'] = function() return math.floor((Config.ChinaHatMeshTransparency or 0.5) * 100) end,
        ['Halo Height'] = function() return Config.AngelHaloHeight or 1.2 end,
        ['Halo Radius'] = function() return Config.AngelHaloRadius or 1.15 end,
        ['Halo Transparency'] = function() return math.floor((tonumber(Config.AngelHaloTransparency) or 0.2) * 100) end,
        ['Halo Thickness'] = function() return Config.AngelHaloThickness or 0.14 end,
        ['Halo Segments'] = function() return math.floor(tonumber(Config.AngelHaloSegments) or 36) end,
        ['Halo Rings'] = function() return math.floor(tonumber(Config.AngelHaloRings) or 1) end,
        ['Angel Halo Glow'] = function() return math.floor(tonumber(Config.AngelHaloGlow) or 3) end,
        ['Target Dot Size'] = function() return math.floor(tonumber(Config.TargetDotSize) or 28) end,
        ['Target Dot Transp %'] = function() return math.floor((tonumber(Config.TargetDotTransparency) or 0.1) * 100) end,
        ['Orbit Speed'] = function() return Config.OrbitSpeedValue end,
        ['Scan Speed'] = function() return Config.TargetRingSpeed or 1.2 end,
        ['Ring Radius'] = function() return Config.TargetRingRadius or 2.2 end,
        ['Marker Size'] = function() return Config.TargetMarkerSize or 90 end,
        ['Marker Trans'] = function() return math.floor((Config.TargetMarkerTransparency or 0.15) * 100) end,
        ['Marker Spin Speed'] = function() return Config.TargetMarkerRotateSpeed or 90 end,
        ['Fog Distance'] = function() return Config.FogDistanceValue end,
        ['Self Transparency Amount'] = function() return math.floor((tonumber(Config.SelfTransparency) or 0.4) * 100) end,
        ['Time of Day'] = function() return Config.DayCycleTime or 14 end,
        ['End Radius'] = function() return Config.JumpCircleSize or 5 end,
        ['Start Radius'] = function() return Config.JumpCircleStartRadius or 0.8 end,
        ['Ring Thickness'] = function() return Config.JumpCircleThickness or 0.18 end,
        ['Expand Time'] = function() return Config.JumpCircleExpandTime or 0.7 end,
        ['Segments'] = function() return math.floor(tonumber(Config.JumpCircleSegments) or 48) end,
        ['Star Size'] = function() return math.floor(tonumber(Config.FallingStarsSize) or 28) end,
        ['Star Count'] = function() return math.floor(tonumber(Config.FallingStarsCount) or 70) end,
        ['Cam Distance'] = function() return Config.ThirdPersonDistance end,
        ['Flash Duration (x0.1s)'] = function() return math.floor((Config.KillFlashDuration or 0.85) * 10) end,
        ['Tracer Cooldown (ms)'] = function() return math.floor(tonumber(Config.BulletTracerCooldown) or 120) end,
        ['Tracer Transparency'] = function() return math.floor((tonumber(Config.BulletTracerTransparency) or 0.15) * 100) end,
        ['Autowall Size'] = function() return math.floor(tonumber(Config.AutowallSize) or 18) end,
        ['Autowall Corner'] = function() return math.floor(tonumber(Config.AutowallCorner) or 3) end,
        ['Autowall Transparency'] = function() return math.floor((tonumber(Config.AutowallTransparency) or 0.15) * 100) end,
        ['FOV Fill Transparency'] = function() return math.floor((Config.FovFillTransparency or 0.7) * 100) end,
        ['FOV Pulse Speed'] = function() return Config.FovPulseSpeed or 3 end,
        ['FOV Pulse Amount'] = function() return math.floor((Config.FovPulseAmount or 0.12) * 100) end,
        ['FOV Size'] = function() return Config.FovRadius end,
        ['Aim Smooth'] = function() return math.floor((Config.AimSmoothValue or 0.18) * 100) end,
        ['Target Line Trans'] = function() return math.floor((Config.TargetLineTransparency or 0.15) * 100) end,
        ['AA Pitch'] = function() return Config.AntiAimPitch end,
        ['AA Yaw'] = function() return Config.AntiAimYaw end,
        ['AA Jitter Range'] = function() return Config.AntiAimJitter or 35 end,
        ['AA Spin Speed'] = function() return Config.AntiAimSpinSpeed or 720 end,
        ['AA TP Radius'] = function() return Config.AntiAimTPRadius or 5 end,
        ['AA TP Speed'] = function() return Config.AntiAimTPSpeed or 8 end,
        ['Trigger Delay (ms)'] = function() return Config.TriggerbotDelay end,
        ['WAS Speed (ms)'] = function() return Config.WeaponAutoSwapSpeed or 150 end,
        ['Silent Fill Transparency'] = function() return math.floor((Config.SilentV2FovFillTransparency or 0.7) * 100) end,
        ['Silent FOV'] = function() return Config.SilentV2Fov or 140 end,
        ['Silent Hit Chance'] = function() return Config.SilentV2HitChance or 100 end,
        ['Silent Predict x100'] = function() return math.floor((Config.SilentV2PredictionAmount or 0.12) * 100) end,
        ['Hit Volume'] = function() return math.floor(Config.CustomFireSoundVolume * 100) end,
        ['Fly Speed'] = function() return Config.FlySpeedValue or 50 end,
        ['BHop Force'] = function() return Config.BHopPower end,
        ['Strafe Speed'] = function() return Config.StrafeSpeed or 22 end,
        ['Peek Radius'] = function() return tonumber(Config.PeekAssistRadius) or 5 end,
        ['Effect Duration (ms)'] = function() return math.floor(tonumber(Config.PeekAssistDurationMs) or 700) end,
        ['Return Delay (ms)'] = function() return math.floor(tonumber(Config.PeekAssistReturnDelayMs) or 0) end,
        ['Effect Transparency'] = function() return math.floor((tonumber(Config.PeekAssistTransparency) or 0.28) * 100) end,
        ['Effect Thickness'] = function() return tonumber(Config.PeekAssistThickness) or 0.18 end,
        ['Effect Segments'] = function() return math.floor(tonumber(Config.PeekAssistSegments) or 48) end,
        ['FL Jitter'] = function() return Config.FakeLagJitter or 15 end,
        ['FL Anchor Time'] = function() return Config.FakeLagAnchorTime or 50 end,
        ['FL Unanchor Time'] = function() return Config.FakeLagUnanchorTime or 35 end,
        ['FL Pause'] = function() return Config.FakeLagPause or 100 end,
    }
    Cache.SliderBinds = Cache.SliderBinds or {}
    for _, bind in ipairs(Cache.SliderBinds) do
        if bind and typeof(bind.apply) == "function" then
            local v = nil
            local g = getters[bind.name]
            if g then
                local ok, r = pcall(g)
                if ok and r ~= nil then v = tonumber(r) or r end
            end
            if v ~= nil then
                pcall(bind.apply, v)
            end
        end
    end
    pcall(function()
        if Cache.RefreshSilentV2PartList then Cache.RefreshSilentV2PartList() end
        if Cache.RefreshAimPartList then Cache.RefreshAimPartList() end
        if Cache.RefreshMultipointList then Cache.RefreshMultipointList() end
        if Cache.RefreshPriorityList then Cache.RefreshPriorityList() end
        if Cache.RefreshAAModeList then Cache.RefreshAAModeList() end
        if Cache.RefreshMenuFontList then Cache.RefreshMenuFontList() end
        if Cache.StrafeModeHeaderLbl then
            Cache.StrafeModeHeaderLbl.Text = "Strafe Mode  ·  " .. tostring(Config.StrafeMode or "Hybrid")
        end
        if Cache.RefreshStrafeModeList then pcall(Cache.RefreshStrafeModeList) end
        if Cache.RefreshHitSoundList then pcall(Cache.RefreshHitSoundList) end
        if Cache.RefreshBoxStyleList then pcall(Cache.RefreshBoxStyleList) end
        if Cache.RefreshChamsStyleList then pcall(Cache.RefreshChamsStyleList) end
        if Cache.RefreshHealthbarStyleList then pcall(Cache.RefreshHealthbarStyleList) end
        if Cache.RefreshAnimList then pcall(Cache.RefreshAnimList) end
        if Cache.RefreshWeaponMaterialList then pcall(Cache.RefreshWeaponMaterialList) end
                if Cache.RefreshWatermarkPosList then pcall(Cache.RefreshWatermarkPosList) end
        if Cache.RefreshScopeModeList then pcall(Cache.RefreshScopeModeList) end
        if Cache.RefreshCloneStyleList then pcall(Cache.RefreshCloneStyleList) end
        if Cache.RefreshDeathStyleList then pcall(Cache.RefreshDeathStyleList) end
    end)
end

CreateTextBoxRow = function(name, placeholder, layoutOrder, parentTab, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0.96, 0, 0, 56)
    Row.BackgroundColor3 = Theme.BgSecondary
    Row.BackgroundTransparency = 0.45
    Row.BorderSizePixel = 0
    Row.LayoutOrder = layoutOrder
    Row.Parent = parentTab

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 18)
    Label.Position = UDim2.new(0, 12, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Theme.Text
    Label.TextSize = 12
    Label.Font = SelectedFont
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local TextBoxBg = Instance.new("Frame")
    TextBoxBg.Size = UDim2.new(1, -24, 0, 24)
    TextBoxBg.Position = UDim2.new(0, 12, 0, 26)
    TextBoxBg.BackgroundColor3 = Theme.BgTertiary
    TextBoxBg.BorderSizePixel = 0
    TextBoxBg.Parent = Row

    local TbCorner = Instance.new("UICorner")
    TbCorner.CornerRadius = UDim.new(0, 6)
    TbCorner.Parent = TextBoxBg

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -12, 1, 0)
    TextBox.Position = UDim2.new(0, 6, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = ""
    TextBox.PlaceholderText = placeholder
    TextBox.PlaceholderColor3 = Theme.TextDim
    TextBox.TextColor3 = Theme.Text
    TextBox.TextSize = 12
    TextBox.Font = SelectedFont
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.Parent = TextBoxBg

    TextBox.FocusLost:Connect(function()
        callback(TextBox.Text)
    end)

    return TextBox
end


BoxEspBtn, BoxEspBg, BoxEspKnob = CreateFeatureRow("2D Box ESP", 1, VisualsTab, "Color_BoxEsp")
TeamEspBtn, TeamEspBg, TeamEspKnob = CreateFeatureRow("Team ESP", 1.05, VisualsTab, "Color_TeamEsp")
TeamNameEspBtn, TeamNameEspBg, TeamNameEspKnob = CreateFeatureRow("Team Name ESP", 1.06, VisualsTab)
TeamDistEspBtn, TeamDistEspBg, TeamDistEspKnob = CreateFeatureRow("Team Distance ESP", 1.07, VisualsTab)
BoxFillBtn, BoxFillBg, BoxFillKnob = CreateFeatureRow("Box Fill Gradient", 1.2, VisualsTab, "Color_BoxEspFill")
BoxOutlineGradBtn, BoxOutlineGradBg, BoxOutlineGradKnob = CreateFeatureRow("Box Outline Gradient", 1.25, VisualsTab)
BoxFillRotBtn, BoxFillRotBg, BoxFillRotKnob = CreateFeatureRow("Fill Rotation", 1.3, VisualsTab)
CreateSliderRow("Fill Rot Speed", 0.1, 10, Config.BoxFillRotationSpeed or 2, 1.35, VisualsTab, function(val)
    Config.BoxFillRotationSpeed = val
end)


do
    local styles = { "Full", "Corner" }
    local Expanded = false
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "BoxStyleListHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.LayoutOrder = 2.5
    HeaderRow.Parent = ResolveUIParent(VisualsTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Box Style  ·  " .. tostring(Config.EspBoxStyle or "Full")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.BoxStyleHeaderLbl = HeaderLbl
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "BoxStyleList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.LayoutOrder = 2.51
    ListFrame.Visible = false
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    pcall(AnxiumListFrameStroke, ListFrame)
    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    local lay = Instance.new("UIListLayout")
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 3)
    lay.Parent = ListScroll
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)
    pad.Parent = ListScroll
    Cache.BoxStyleButtons = {}
    local function RefreshHighlight()
        local cur = Config.EspBoxStyle or "Full"
        if Cache.BoxStyleHeaderLbl then
            Cache.BoxStyleHeaderLbl.Text = "Box Style  ·  " .. tostring(cur)
        end
        for name, b in pairs(Cache.BoxStyleButtons) do
            if b and b.Parent then
                if name == cur then
                    b.BackgroundColor3 = Theme.Accent
                    b.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    b.BackgroundColor3 = Theme.BgTertiary
                    b.TextColor3 = Theme.Text
                end
            end
        end
    end
    Cache.RefreshBoxStyleList = RefreshHighlight
    for i, styleName in ipairs(styles) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 28)
        b.BackgroundColor3 = Theme.BgTertiary
        b.BorderSizePixel = 0
        b.Text = "  " .. styleName
        b.TextColor3 = Theme.Text
        b.TextSize = 12
        b.Font = SelectedFont
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.LayoutOrder = i
        b.Parent = ListScroll
        do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = b end
        Cache.BoxStyleButtons[styleName] = b
        b.MouseButton1Click:Connect(function()
            Config.EspBoxStyle = styleName
            RefreshHighlight()
            Notify("ESP", "Box style: " .. styleName)
        end)
    end
    RefreshHighlight()
    local listH = 28 * #styles + 16
    HeaderRow.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        if Expanded then AnxiumSetListOpen(ListFrame, true, listH, HeaderRow) else AnxiumSetListOpen(ListFrame, false) end
        if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 elseif ArrowLbl:IsA("TextLabel") then if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = Expanded and "▲" or "▼" end end

    end)
end


HealthbarEspBtn, HealthbarEspBg, HealthbarEspKnob = CreateFeatureRow("Healthbar ESP", 3, VisualsTab, "Color_Healthbar")
do
    local styles = { "Gradient", "Solid" }
    local Expanded = false
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "HealthbarStyleHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.LayoutOrder = 3.05
    HeaderRow.Parent = ResolveUIParent(VisualsTab)
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 8)
    hc.Parent = HeaderRow
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -36, 1, 0)
    HeaderLbl.Position = UDim2.fromOffset(12, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Healthbar Style  ·  " .. tostring(Config.HealthbarStyle or "Gradient")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.HealthbarStyleHeaderLbl = HeaderLbl
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)
    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "HealthbarStyleList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.BgSecondary
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.Visible = false
    ListFrame.LayoutOrder = 3.06
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 8)
    lc.Parent = ListFrame
    pcall(AnxiumListFrameStroke, ListFrame)
    local ListScroll = Instance.new("Frame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.fromOffset(4, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.Parent = ListFrame
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 3)
    ListLayout.Parent = ListScroll
    Cache.HealthbarStyleButtons = {}
    local function RefreshHealthbarStyleHighlight()
        local cur = Config.HealthbarStyle or "Gradient"
        if Cache.HealthbarStyleHeaderLbl then
            Cache.HealthbarStyleHeaderLbl.Text = "Healthbar Style  ·  " .. tostring(cur)
        end
        for name, btn in pairs(Cache.HealthbarStyleButtons) do
            if btn and btn.Parent then
                if name == cur then
                    btn.BackgroundColor3 = Theme.Accent
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    btn.BackgroundColor3 = Theme.BgTertiary
                    btn.TextColor3 = Theme.Text
                end
            end
        end
    end
    Cache.RefreshHealthbarStyleHighlight = RefreshHealthbarStyleHighlight
    for i, name in ipairs(styles) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Theme.Text
        btn.TextSize = 12
        btn.Font = SelectedFont
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.Parent = ListScroll
        Cache.HealthbarStyleButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            Config.HealthbarStyle = name
            RefreshHealthbarStyleHighlight()
            Notify("ESP", "Healthbar: " .. name)
        end)
    end
    RefreshHealthbarStyleHighlight()
    local listH = 28 * #styles + 16
    HeaderRow.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        if Expanded then AnxiumSetListOpen(ListFrame, true, listH, HeaderRow) else AnxiumSetListOpen(ListFrame, false) end
        if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 elseif ArrowLbl:IsA("TextLabel") then if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = Expanded and "▲" or "▼" end end

    end)
end
CreateGroupPanel("Chams", 3.95, VisualsTab)
ChamsBtn, ChamsBg, ChamsKnob = CreateFeatureRow("Chams (Wallhack)", 4, VisualsTab, "Color_Chams")
do
    local styles = { "Flat", "Metallic", "Glow", "Outline", "Soft", "Solid", "Pearlescent" }
    local Expanded = false
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "ChamsStyleHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.LayoutOrder = 4.02
    HeaderRow.Parent = ResolveUIParent(VisualsTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Chams Style  ·  " .. tostring(Config.ChamsStyle or "Flat")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.ChamsStyleHeaderLbl = HeaderLbl
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)
    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "ChamsStyleList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.LayoutOrder = 4.03
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    pcall(AnxiumListFrameStroke, ListFrame)
    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    local lay = Instance.new("UIListLayout")
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 3)
    lay.Parent = ListScroll
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)
    pad.Parent = ListScroll
    Cache.ChamsStyleButtons = {}
    local function RefreshChamsStyleHighlight()
        local cur = Config.ChamsStyle or "Flat"
        if Cache.ChamsStyleHeaderLbl then
            Cache.ChamsStyleHeaderLbl.Text = "Chams Style  ·  " .. tostring(cur)
        end
        for name, b in pairs(Cache.ChamsStyleButtons) do
            if b and b.Parent then
                if name == cur then
                    b.BackgroundColor3 = Theme.Accent
                    b.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    b.BackgroundColor3 = Theme.BgTertiary
                    b.TextColor3 = Theme.Text
                end
            end
        end
    end
    Cache.RefreshChamsStyleList = RefreshChamsStyleHighlight
    for i, styleName in ipairs(styles) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 28)
        b.BackgroundColor3 = Theme.BgTertiary
        b.BorderSizePixel = 0
        b.Text = "  " .. styleName
        b.TextColor3 = Theme.Text
        b.TextSize = 12
        b.Font = SelectedFont
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.LayoutOrder = i
        b.Parent = ListScroll
        do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = b end
        Cache.ChamsStyleButtons[styleName] = b
        b.MouseButton1Click:Connect(function()
            Config.ChamsStyle = styleName
            Cache.ChamsForceRefresh = true
            RefreshChamsStyleHighlight()
            Notify("Chams", "Style: " .. styleName)
        end)
    end
    RefreshChamsStyleHighlight()
    local listH = 28 * #styles + 16
    HeaderRow.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        if Expanded then AnxiumSetListOpen(ListFrame, true, listH, HeaderRow) else AnxiumSetListOpen(ListFrame, false) end
        if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 elseif ArrowLbl:IsA("TextLabel") then if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = Expanded and "▲" or "▼" end end
    end)
end
CreateGroupPanel("Chams Vis Colors", 4.04, VisualsTab)
ChamsVisBtn, ChamsVisBg, ChamsVisKnob = CreateFeatureRow("Enable Vis Colors", 4.05, VisualsTab)
do
    local ColorListScroll
    local function CreateChamsColorRow(label, colorKey)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 30)
        Row.BackgroundColor3 = Theme.BgTertiary
        Row.BackgroundTransparency = 0
        Row.BorderSizePixel = 0
        Row.LayoutOrder = 1
        Row.Parent = ColorListScroll
        local rc = Instance.new("UICorner")
        rc.CornerRadius = UDim.new(0, 6)
        rc.Parent = Row

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, -52, 1, 0)
        Lbl.Position = UDim2.new(0, 12, 0, 0)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = label
        Lbl.TextColor3 = Theme.Text
        Lbl.TextSize = 12
        Lbl.Font = SelectedFont
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = Row

        local colBtn = Instance.new("TextButton")
        colBtn.Name = "ColorBtn"
        colBtn.Size = UDim2.new(0, 22, 0, 22)
        colBtn.Position = UDim2.new(1, -34, 0.5, -11)
        colBtn.BackgroundColor3 = Config[colorKey] or Theme.Accent
        colBtn.BorderSizePixel = 0
        colBtn.Text = ""
        colBtn.AutoButtonColor = false
        colBtn.Parent = Row



        colBtn.MouseButton1Click:Connect(function()
            if not OpenRGBPicker then return end
            OpenRGBPicker(Config[colorKey] or Theme.Accent, function(col)
                Config[colorKey] = col
                colBtn.BackgroundColor3 = col
            end, colBtn)
        end)

        Cache.ColorButtons = Cache.ColorButtons or {}
        Cache.ColorButtons[colorKey] = colBtn
        pcall(function() colBtn:SetAttribute("AnxiumColorKey", colorKey) end)

        if colorKey == "Color_ChamsVisible" then
            Cache.ChamsVisColorBtn = colBtn
        else
            Cache.ChamsOccColorBtn = colBtn
        end
    end

    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "ChamsVisColorListHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BackgroundTransparency = 0
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = 4.06
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = ResolveUIParent(VisualsTab)

    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Colors"
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow

    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "ChamsVisColorList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BackgroundTransparency = 0
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = 4.065
    ListFrame.ClipsDescendants = true
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    pcall(AnxiumListFrameStroke, ListFrame)

    ColorListScroll = Instance.new("ScrollingFrame")
    ColorListScroll.Size = UDim2.new(1, -8, 1, -8)
    ColorListScroll.Position = UDim2.new(0, 4, 0, 4)
    ColorListScroll.BackgroundTransparency = 1
    ColorListScroll.BorderSizePixel = 0
    ColorListScroll.ScrollBarThickness = 3
    ColorListScroll.ScrollBarImageColor3 = Theme.Accent
    ColorListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColorListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColorListScroll.Parent = ListFrame

    local ColorListLayout = Instance.new("UIListLayout")
    ColorListLayout.Padding = UDim.new(0, 3)
    ColorListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ColorListLayout.Parent = ColorListScroll

    local ColorListPad = Instance.new("UIPadding")
    ColorListPad.PaddingTop = UDim.new(0, 4)
    ColorListPad.PaddingBottom = UDim.new(0, 4)
    ColorListPad.PaddingLeft = UDim.new(0, 4)
    ColorListPad.PaddingRight = UDim.new(0, 4)
    ColorListPad.Parent = ColorListScroll

    CreateChamsColorRow("Visible Color", "Color_ChamsVisible")
    CreateChamsColorRow("Behind Wall Color", "Color_ChamsOccluded")

    local listOpen = false
    local LIST_H = 2 * 33 + 12
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
end
if EspGroupContent then
    Cache.GroupParentByTab[VisualsTab] = EspGroupContent
end
NameEspBtn, NameEspBg, NameEspKnob = CreateFeatureRow("Name ESP", 5, VisualsTab, "Color_NameEsp")
DistEspBtn, DistEspBg, DistEspKnob = CreateFeatureRow("Distance ESP", 6, VisualsTab, "Color_NameEsp")
CreateGroupPanel("Name ESP Gradient", 6.05, VisualsTab)
NameEspGradBtn, NameEspGradBg, NameEspGradKnob = CreateFeatureRow("Enemy Name Gradient", 6.06, VisualsTab)
TeamNameEspGradBtn, TeamNameEspGradBg, TeamNameEspGradKnob = CreateFeatureRow("Team Name Gradient", 6.07, VisualsTab)
do
    local ColorListScroll
    local function CreateNameGradColorRow(label, colorKey, defaultCol)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 30)
        Row.BackgroundColor3 = Theme.BgTertiary
        Row.BackgroundTransparency = 0
        Row.BorderSizePixel = 0
        Row.LayoutOrder = 1
        Row.Parent = ColorListScroll

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, -52, 1, 0)
        Lbl.Position = UDim2.new(0, 12, 0, 0)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = label
        Lbl.TextColor3 = Theme.Text
        Lbl.TextSize = 12
        Lbl.Font = SelectedFont
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = Row

        local colBtn = Instance.new("TextButton")
        colBtn.Name = "ColorBtn"
        colBtn.Size = UDim2.fromOffset(22, 22)
        colBtn.Position = UDim2.new(1, -34, 0.5, -11)
        colBtn.BackgroundColor3 = Config[colorKey] or defaultCol
        colBtn.BorderSizePixel = 0
        colBtn.Text = ""
        colBtn.Parent = Row

        Cache.ColorButtons = Cache.ColorButtons or {}
        Cache.ColorButtons[colorKey] = colBtn
        pcall(function() colBtn:SetAttribute("AnxiumColorKey", colorKey) end)
        colBtn.MouseButton1Click:Connect(function()
            OpenRGBPicker(Config[colorKey] or defaultCol, function(col)
                Config[colorKey] = col
                colBtn.BackgroundColor3 = col
                if NameEsp_RefreshGradients then pcall(NameEsp_RefreshGradients) end
                Notify("Color", label .. " set")
            end)
        end)
    end

    local Expanded = false
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "NameEspGradientListHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.LayoutOrder = 6.08
    HeaderRow.Parent = ResolveUIParent(VisualsTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Name ESP Gradient Colors"
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "NameEspGradientList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.LayoutOrder = 6.09
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    AnxiumListFrameStroke(ListFrame)

    ColorListScroll = Instance.new("ScrollingFrame")
    ColorListScroll.Size = UDim2.new(1, -8, 1, -8)
    ColorListScroll.Position = UDim2.new(0, 4, 0, 4)
    ColorListScroll.BackgroundTransparency = 1
    ColorListScroll.BorderSizePixel = 0
    ColorListScroll.ScrollBarThickness = 3
    ColorListScroll.ScrollBarImageColor3 = Theme.Accent
    ColorListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColorListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColorListScroll.Parent = ListFrame

    local ColorListLayout = Instance.new("UIListLayout")
    ColorListLayout.Padding = UDim.new(0, 3)
    ColorListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ColorListLayout.Parent = ColorListScroll

    local ColorListPad = Instance.new("UIPadding")
    ColorListPad.PaddingTop = UDim.new(0, 4)
    ColorListPad.PaddingBottom = UDim.new(0, 4)
    ColorListPad.PaddingLeft = UDim.new(0, 4)
    ColorListPad.PaddingRight = UDim.new(0, 4)
    ColorListPad.Parent = ColorListScroll

    CreateNameGradColorRow("Enemy Gradient A", "Color_NameEsp", Color3.fromRGB(180, 140, 255))
    CreateNameGradColorRow("Enemy Gradient B", "Color_NameEspB", Color3.fromRGB(255, 255, 255))
    CreateNameGradColorRow("Team Gradient A", "Color_TeamNameEsp", Color3.fromRGB(210, 180, 255))
    CreateNameGradColorRow("Team Gradient B", "Color_TeamNameEspB", Color3.fromRGB(255, 255, 255))

    local listOpen = false
    local LIST_H = 4 * 33 + 12
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
end

CreateGroupPanel("Name ESP Fill", 6.1, VisualsTab)
NameEspFillBtn, NameEspFillBg, NameEspFillKnob = CreateFeatureRow("Name ESP Fill", 6.11, VisualsTab)
NameEspFillBtn.MouseButton1Click:Connect(function()
    Config.NameEspFillEnabled = not Config.NameEspFillEnabled
    UpdateSwitch(Config.NameEspFillEnabled, NameEspFillBg, NameEspFillKnob, "Name ESP Fill")
end)

do
    local host = ResolveUIParent(VisualsTab)
    local Row = Instance.new("Frame")
    Row.Name = "NameEspFillColorRow"
    Row.Size = UDim2.new(1, 0, 0, 36)
    Row.BackgroundTransparency = 1
    Row.BorderSizePixel = 0
    Row.LayoutOrder = 6.12
    Row.Parent = host
    pcall(function()
        Row:SetAttribute("AnxiumSearchText", "fill color name esp")
    end)

    local div = Instance.new("Frame")
    div.Name = "RowDivider"
    div.Size = UDim2.new(1, -8, 0, 1)
    div.Position = UDim2.new(0, 4, 1, -1)
    div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    div.BackgroundTransparency = 0.94
    div.BorderSizePixel = 0
    div.ZIndex = 2
    div.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -54, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "Fill Color"
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = SelectedFont
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ColorBtn = Instance.new("TextButton")
    ColorBtn.Name = "NameEspFillColorButton"
    ColorBtn.Size = UDim2.fromOffset(20, 20)
    ColorBtn.Position = UDim2.new(1, -34, 0.5, -10)
    ColorBtn.BackgroundColor3 = Config.Color_NameEspFill or Color3.fromRGB(0, 0, 0)
    ColorBtn.BorderSizePixel = 0
    ColorBtn.Text = ""
    ColorBtn.AutoButtonColor = false
    ColorBtn.Parent = Row

    Cache.ColorButtons = Cache.ColorButtons or {}
    Cache.ColorButtons.Color_NameEspFill = ColorBtn
    pcall(function() ColorBtn:SetAttribute("AnxiumColorKey", "Color_NameEspFill") end)
    ColorBtn.MouseButton1Click:Connect(function()
        OpenRGBPicker(Config.Color_NameEspFill or Color3.fromRGB(0, 0, 0), function(col)
            Config.Color_NameEspFill = col
            ColorBtn.BackgroundColor3 = col
            NameEsp_RefreshGradients()
            Notify("Color", "Name ESP fill color set")
        end)
    end)
end

CreateSliderRow("Name ESP Fill Corner", 0, 12, Config.NameEspFillCorner or 4, 6.13, VisualsTab, function(value)
    Config.NameEspFillCorner = math.floor(value + 0.5)
    NameEsp_RefreshGradients()
end)
do
    local host = ResolveUIParent(VisualsTab)
    if host then
        for _, ch in ipairs(host:GetChildren()) do
            if ch:IsA("Frame") and math.abs((ch.LayoutOrder or 0) - 6.13) < 0.001 then
                local d = ch:FindFirstChild("RowDivider")
                if d then d:Destroy() end
            end
        end
    end
end

local BlurGradientGroup = CreateGroupPanel("Blur Background Gradient", 90, VisualsTab)
Cache.GroupParentByTab[VisualsTab] = EspGroupContent
do
    local function createBlurGradientColorRow(label, colorKey, defaultColor, order)
        local row = Instance.new("Frame")
        row.Name = "BlurGradientColorRow"
        row.Size = UDim2.new(0.96, 0, 0, 32)
        row.BackgroundColor3 = Theme.Card
        row.BorderSizePixel = 0
        row.LayoutOrder = order
        row.Parent = BlurGradientGroup

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -54, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = Theme.Text
        lbl.TextSize = 12
        lbl.Font = SelectedFont
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local btn = Instance.new("TextButton")
        btn.Name = "ColorBtn"
        btn.Size = UDim2.fromOffset(22, 22)
        btn.Position = UDim2.new(1, -34, 0.5, -11)
        btn.BackgroundColor3 = Config[colorKey] or defaultColor
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = row
        local cbc = Instance.new("UICorner")
        cbc.CornerRadius = UDim.new(0, 0)
        cbc.Parent = btn
        Cache.ColorButtons = Cache.ColorButtons or {}
        Cache.ColorButtons[colorKey] = btn
        btn:SetAttribute("AnxiumColorKey", colorKey)
        btn.MouseButton1Click:Connect(function()
            OpenRGBPicker(Config[colorKey] or defaultColor, function(col)
                Config[colorKey] = col
                btn.BackgroundColor3 = col
                BlurGradientOverlayGradient.Color = ColorSequence.new(Config.Color_BlurGradientA, Config.Color_BlurGradientB)
                Notify("Blur Gradient", label .. " updated")
            end, btn)
        end)
    end

    local toggleRow = Instance.new("Frame")
    toggleRow.Name = "BlurGradientToggleRow"
    toggleRow.Size = UDim2.new(0.96, 0, 0, 36)
    toggleRow.BackgroundColor3 = Theme.Card
    toggleRow.BorderSizePixel = 0
    toggleRow.LayoutOrder = 1
    toggleRow.Parent = BlurGradientGroup

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -70, 1, 0)
    toggleLabel.Position = UDim2.new(0, 14, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Blur Background Gradient"
    toggleLabel.TextColor3 = Theme.Text
    toggleLabel.TextSize = 13
    toggleLabel.Font = SelectedFont
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleRow

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.fromOffset(34, 18)
    toggleBg.AnchorPoint = Vector2.new(1, 0.5)
    toggleBg.Position = UDim2.new(1, -10, 0.5, 0)
    toggleBg.BackgroundColor3 = Config.BlurGradientEnabled and Theme.Accent or Theme.ToggleOff
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = toggleRow
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(Config.BlurGradientEnabled and 1 or 0, Config.BlurGradientEnabled and -9 or 9, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.fromScale(1, 1)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleBg
    toggleBtn.MouseButton1Click:Connect(function()
        Config.BlurGradientEnabled = not Config.BlurGradientEnabled
        local enabled = Config.BlurGradientEnabled
        TweenService:Create(toggleBg, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = enabled and Theme.Accent or Theme.ToggleOff
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(enabled and 1 or 0, enabled and -9 or 9, 0.5, 0)
        }):Play()
        if not enabled then
            BlurGradientOverlay.Visible = false
            BlurGradientOverlay.BackgroundTransparency = 1
        elseif MenuOpen then
            BlurGradientOverlay.Visible = true
            TweenService:Create(BlurGradientOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = (Config.BlurGradientTransparency or 0.28)
            }):Play()
        end
    end)

    local animateRow = Instance.new("Frame")
    animateRow.Name = "BlurGradientAnimateRow"
    animateRow.Size = UDim2.new(0.96, 0, 0, 36)
    animateRow.BackgroundColor3 = Theme.Card
    animateRow.BorderSizePixel = 0
    animateRow.LayoutOrder = 2
    animateRow.Parent = BlurGradientGroup
    local animateLabel = Instance.new("TextLabel")
    animateLabel.Size = UDim2.new(1, -70, 1, 0)
    animateLabel.Position = UDim2.new(0, 14, 0, 0)
    animateLabel.BackgroundTransparency = 1
    animateLabel.Text = "Animate Two Colors"
    animateLabel.TextColor3 = Theme.Text
    animateLabel.TextSize = 13
    animateLabel.Font = SelectedFont
    animateLabel.TextXAlignment = Enum.TextXAlignment.Left
    animateLabel.Parent = animateRow
    local animBg = Instance.new("Frame")
    animBg.Size = UDim2.fromOffset(34, 18)
    animBg.AnchorPoint = Vector2.new(1, 0.5)
    animBg.Position = UDim2.new(1, -10, 0.5, 0)
    animBg.BackgroundColor3 = Config.BlurGradientAnimate and Theme.Accent or Theme.ToggleOff
    animBg.BorderSizePixel = 0
    animBg.Parent = animateRow
    local animCorner = Instance.new("UICorner")
    animCorner.CornerRadius = UDim.new(1, 0)
    animCorner.Parent = animBg
    local animKnob = Instance.new("Frame")
    animKnob.Size = UDim2.fromOffset(14, 14)
    animKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    animKnob.Position = UDim2.new(Config.BlurGradientAnimate and 1 or 0, Config.BlurGradientAnimate and -9 or 9, 0.5, 0)
    animKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    animKnob.BorderSizePixel = 0
    animKnob.Parent = animBg
    local animKnobCorner = Instance.new("UICorner")
    animKnobCorner.CornerRadius = UDim.new(1, 0)
    animKnobCorner.Parent = animKnob
    local animBtn = Instance.new("TextButton")
    animBtn.Size = UDim2.fromScale(1, 1)
    animBtn.BackgroundTransparency = 1
    animBtn.Text = ""
    animBtn.Parent = animBg
    animBtn.MouseButton1Click:Connect(function()
        Config.BlurGradientAnimate = not Config.BlurGradientAnimate
        local enabled = Config.BlurGradientAnimate
        TweenService:Create(animBg, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = enabled and Theme.Accent or Theme.ToggleOff
        }):Play()
        TweenService:Create(animKnob, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(enabled and 1 or 0, enabled and -9 or 9, 0.5, 0)
        }):Play()
    end)

    Cache.BlurGradientToggleBg = toggleBg
    Cache.BlurGradientToggleKnob = knob
    Cache.BlurGradientAnimateBg = animBg
    Cache.BlurGradientAnimateKnob = animKnob

    local listHeader = Instance.new("TextButton")
    listHeader.Name = "BlurGradientColorsHeader"
    listHeader.Size = UDim2.new(0.96, 0, 0, 34)
    listHeader.BackgroundColor3 = Theme.Card
    listHeader.BorderSizePixel = 0
    listHeader.AutoButtonColor = false
    listHeader.Text = ""
    listHeader.LayoutOrder = 3
    listHeader.Parent = BlurGradientGroup
    local listLabel = Instance.new("TextLabel")
    listLabel.Size = UDim2.new(1, -40, 1, 0)
    listLabel.Position = UDim2.new(0, 12, 0, 0)
    listLabel.BackgroundTransparency = 1
    listLabel.Text = "Blur Gradient Colors"
    listLabel.TextColor3 = Theme.Text
    listLabel.TextSize = 12
    listLabel.Font = SelectedFont
    listLabel.TextXAlignment = Enum.TextXAlignment.Left
    listLabel.Parent = listHeader
    local listArrow = AnxiumMakeListArrow(listHeader)

    local listFrame = Instance.new("Frame")
    listFrame.Name = "BlurGradientColorsList"
    listFrame.Size = UDim2.new(0.96, 0, 0, 0)
    listFrame.Visible = false
    listFrame.BackgroundColor3 = Theme.Card
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.LayoutOrder = 4
    listFrame.Parent = BlurGradientGroup
    AnxiumListFrameStroke(listFrame)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -8, 1, -8)
    scroll.Position = UDim2.fromOffset(4, 4)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Theme.Accent
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = listFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 3)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)
    padding.Parent = scroll
    local savedParent = BlurGradientGroup
    local function makeColorRow(label, key, defaultColor, order)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Theme.BgTertiary
        row.BorderSizePixel = 0
        row.LayoutOrder = order
        row.Parent = scroll
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -52, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = Theme.Text
        lbl.TextSize = 12
        lbl.Font = SelectedFont
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        local btn = Instance.new("TextButton")
        btn.Name = "ColorBtn"
        btn.Size = UDim2.fromOffset(22, 22)
        btn.Position = UDim2.new(1, -34, 0.5, -11)
        btn.BackgroundColor3 = Config[key] or defaultColor
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = row
        local cbc = Instance.new("UICorner")
        cbc.CornerRadius = UDim.new(0, 0)
        cbc.Parent = btn
        Cache.ColorButtons = Cache.ColorButtons or {}
        Cache.ColorButtons[key] = btn
        btn:SetAttribute("AnxiumColorKey", key)
        btn.MouseButton1Click:Connect(function()
            OpenRGBPicker(Config[key] or defaultColor, function(col)
                Config[key] = col
                btn.BackgroundColor3 = col
                BlurGradientOverlayGradient.Color = ColorSequence.new(Config.Color_BlurGradientA, Config.Color_BlurGradientB)
                Notify("Blur Gradient", label .. " updated")
            end, btn)
        end)
    end
    makeColorRow("Gradient Color A", "Color_BlurGradientA", Color3.fromRGB(130, 70, 255), 1)
    makeColorRow("Gradient Color B", "Color_BlurGradientB", Color3.fromRGB(180, 140, 255), 2)
    local expanded = false
    listHeader.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            AnxiumSetListOpen(listFrame, true, 2 * 33 + 12, listHeader)
            if listArrow:IsA("ImageLabel") then listArrow.Image = "rbxassetid://71457658246709"; listArrow.Rotation = 0 else listArrow.Text = "▲" end
        else
            AnxiumSetListOpen(listFrame, false)
            if listArrow:IsA("ImageLabel") then listArrow.Image = "rbxassetid://98648581502859"; listArrow.Rotation = 0 else listArrow.Text = "▼" end
        end
    end)

    CreateSliderRow("Gradient Speed", 10, 300, math.floor((tonumber(Config.BlurGradientSpeed) or 1) * 100), 5, BlurGradientGroup, function(val)
        Config.BlurGradientSpeed = math.clamp((val or 100) / 100, 0.1, 3)
    end)
    CreateSliderRow("Blur Transparency", 0, 90, math.floor((tonumber(Config.BlurGradientTransparency) or 0.28) * 100), 6, BlurGradientGroup, function(val)
        Config.BlurGradientTransparency = math.clamp((val or 28) / 100, 0, 0.9)
        pcall(function()
            if Config.BlurGradientEnabled and MenuOpen and BlurGradientOverlay then
                BlurGradientOverlay.BackgroundTransparency = Config.BlurGradientTransparency
            end
        end)
    end)
end

SkelBtn, SkelBg, SkelKnob = CreateFeatureRow("Skeleton ESP", 7, VisualsTab, "Color_Skeleton")
TracerBtn, TracerBg, TracerKnob = CreateFeatureRow("Tracers", 8, VisualsTab, "Color_Tracers")
do
    local opts = { "Bottom", "Middle", "Top" }
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = 8.05
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = ResolveUIParent(VisualsTab)

    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.fromOffset(12, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Tracer Origin  ·  " .. tostring(Config.TracerOrigin or "Bottom")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.TracerOriginHeaderLbl = HeaderLbl

    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = 8.06
    ListFrame.ClipsDescendants = true
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    pcall(AnxiumListFrameStroke, ListFrame)

    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -12, 1, -8)
    ListScroll.Position = UDim2.fromOffset(6, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 3)
    lay.Parent = ListScroll

    local optButtons = {}
    local function refreshTracerOriginList()
        local cur = tostring(Config.TracerOrigin or "Bottom")
        if HeaderLbl then HeaderLbl.Text = "Tracer Origin  ·  " .. cur end
        for name, btn in pairs(optButtons) do
            if name == cur then
                btn.BackgroundColor3 = Theme.Accent
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Theme.BgTertiary
                btn.TextColor3 = Theme.Text
            end
        end
    end
    Cache.RefreshTracerOriginList = refreshTracerOriginList

    for i, name in ipairs(opts) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Theme.Text
        btn.TextSize = 12
        btn.Font = SelectedFont
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.Parent = ListScroll
        optButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            Config.TracerOrigin = name
            refreshTracerOriginList()
            Notify("Tracers", "Origin: " .. name)
        end)
    end
    refreshTracerOriginList()

    local listOpen = false
    local LIST_H = #opts * 31 + 12
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
end
TracerGradBtn, TracerGradBg, TracerGradKnob = CreateFeatureRow("Tracer Gradient", 8.08, VisualsTab, "Color_TracerGradientB")
CreateGroupPanel("Crosshair / Scope", 8.5, VisualsTab)
CrossBtn, CrossBg, CrossKnob = CreateFeatureRow("Custom Crosshair", 9, VisualsTab, "Color_Crosshair")
CreateSliderRow("Crosshair Size", 4, 40, math.floor(tonumber(Config.CrosshairSize) or 10), 9.05, VisualsTab, function(val)
    Config.CrosshairSize = math.floor(val + 0.5)
end)
CreateSliderRow("Crosshair Gap", 0, 24, math.floor(tonumber(Config.CrosshairGap) or 4), 9.06, VisualsTab, function(val)
    Config.CrosshairGap = math.floor(val + 0.5)
end)
CreateSliderRow("Crosshair Thickness", 1, 6, tonumber(Config.CrosshairThickness) or 1.4, 9.07, VisualsTab, function(val)
    Config.CrosshairThickness = val
end)
CreateSliderRow("Crosshair Transparency", 0, 90, math.floor((tonumber(Config.CrosshairTransparency) or 0) * 100), 9.08, VisualsTab, function(val)
    Config.CrosshairTransparency = val / 100
end)
CrossDotBtn, CrossDotBg, CrossDotKnob = CreateFeatureRow("Crosshair Center Dot", 9.09, VisualsTab)
CreateSliderRow("Dot Size", 1, 12, math.floor(tonumber(Config.CrosshairDotSize) or 3), 9.095, VisualsTab, function(val)
    Config.CrosshairDotSize = math.floor(val + 0.5)
end)
CreateSliderRow("Dot Transparency", 0, 90, math.floor((tonumber(Config.CrosshairDotTransparency) or 0) * 100), 9.096, VisualsTab, function(val)
    Config.CrosshairDotTransparency = val / 100
end)
SpinCrossBtn, SpinCrossBg, SpinCrossKnob = CreateFeatureRow("Spin Crosshair", 9.2, VisualsTab, "Color_Crosshair")
CreateSliderRow("Spin Speed", 30, 400, Config.SpinCrosshairSpeed or 180, 9.3, VisualsTab, function(val)
    Config.SpinCrosshairSpeed = val
end)

ScopeBtn, ScopeBg, ScopeKnob = CreateFeatureRow("Sniper Scope", 9.4, VisualsTab, "Color_Scope")
ScopeGradBtn, ScopeGradBg, ScopeGradKnob = CreateFeatureRow("Scope Gradient", 9.41, VisualsTab)
ScopeDynBtn, ScopeDynBg, ScopeDynKnob = CreateFeatureRow("Scope Dynamic", 9.412, VisualsTab)
ScopeSoundBtn, ScopeSoundBg, ScopeSoundKnob = CreateFeatureRow("Scope Sound", 9.415, VisualsTab)
CreateSliderRow("Dynamic Expand", 0, 120, math.floor(tonumber(Config.ScopeDynamicExpand) or 30), 9.416, VisualsTab, function(val)
    Config.ScopeDynamicExpand = math.floor(val + 0.5)
end)
CreateSliderRow("Scope Thickness", 1, 10, math.clamp(math.floor(tonumber(Config.ScopeThickness) or 2), 1, 10), 9.42, VisualsTab, function(val)
    Config.ScopeThickness = val
end)
CreateSliderRow("Scope Line Length", 20, 2500, math.floor(tonumber(Config.ScopeLength) or 80), 9.43, VisualsTab, function(val)
    Config.ScopeLength = math.floor(val + 0.5)
    if Scope_UpdateDraw then pcall(Scope_UpdateDraw) end
end)
CreateSliderRow("Scope Center Gap", 0, 80, math.floor(tonumber(Config.ScopeGap) or 8), 9.435, VisualsTab, function(val)
    Config.ScopeGap = math.floor(val + 0.5)
    if Scope_UpdateDraw then pcall(Scope_UpdateDraw) end
end)
CreateSliderRow("Scope Zoom FOV", 15, 70, Config.ScopeZoomFOV or 40, 9.44, VisualsTab, function(val)
    Config.ScopeZoomFOV = val
    if Config.ScopeActive then Cache.ScopeTargetFOV = val end
end)
do
    local modes = { "Hold", "Toggle" }
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "ScopeModeHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.LayoutOrder = 9.45
    HeaderRow.Parent = ResolveUIParent(VisualsTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Style  ·  " .. tostring(Config.ScopeMode or "Hold")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.ScopeModeHeaderLbl = HeaderLbl
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)
    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "ScopeModeList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.LayoutOrder = 9.451
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    pcall(AnxiumListFrameStroke, ListFrame)
    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 3)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ListScroll
    local Expanded = false
    local function refresh()
        local cur = Config.ScopeMode or "Hold"
        if Cache.ScopeModeHeaderLbl then
            Cache.ScopeModeHeaderLbl.Text = "Style  ·  " .. tostring(cur)
        end
        for _, ch in ipairs(ListScroll:GetChildren()) do
            if ch:IsA("TextButton") then
                local name = ch.Text:gsub("^%s+", "")
                if name == cur then
                    ch.BackgroundColor3 = Theme.Accent
                    ch.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    ch.BackgroundColor3 = Theme.BgTertiary
                    ch.TextColor3 = Theme.Text
                end
            end
        end
    end
    for i, name in ipairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Theme.Text
        btn.TextSize = 12
        btn.Font = SelectedFont
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.Parent = ListScroll
        do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn end
        btn.MouseButton1Click:Connect(function()
            Config.ScopeMode = name
            refresh()
            Notify("Scope", "Mode: " .. name)
        end)
    end
    refresh()
    HeaderRow.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        local listH = #modes * 31 + 12
        if Expanded then AnxiumSetListOpen(ListFrame, true, listH, HeaderRow) else AnxiumSetListOpen(ListFrame, false) end
        if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 end
    end)
    Cache.ScopeModeBtn = HeaderRow
end

do
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0.96, 0, 0, 34)
    Row.BackgroundColor3 = Theme.Card
    Row.BorderSizePixel = 0
    Row.LayoutOrder = 9.48
    Row.Parent = ResolveUIParent(VisualsTab)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Row
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "Scope Key"
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = SelectedFont
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row
    local KeyLbl = Instance.new("TextLabel")
    KeyLbl.Size = UDim2.new(0, 70, 0, 22)
    KeyLbl.Position = UDim2.new(1, -150, 0.5, -11)
    KeyLbl.BackgroundColor3 = Theme.BgTertiary
    KeyLbl.BorderSizePixel = 0
    KeyLbl.Text = (Config.ScopeKey and Config.ScopeKey ~= "") and ("[" .. Config.ScopeKey .. "]") or "[-]"
    KeyLbl.TextColor3 = Theme.TextDim
    KeyLbl.TextSize = 11
    KeyLbl.Font = SelectedFont
    KeyLbl.Parent = Row
    local SetBtn = Instance.new("TextButton")
    SetBtn.Size = UDim2.new(0, 44, 0, 22)
    SetBtn.Position = UDim2.new(1, -72, 0.5, -11)
    SetBtn.BackgroundColor3 = Theme.Accent
    pcall(function() TrackThemeAccent(SetBtn, "BackgroundColor3") end)
    SetBtn.BorderSizePixel = 0
    SetBtn.Text = "Set"
    SetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SetBtn.TextSize = 11
    SetBtn.Font = SelectedFont
    SetBtn.Parent = Row
    local ClrBtn = Instance.new("TextButton")
    ClrBtn.Size = UDim2.new(0, 22, 0, 22)
    ClrBtn.Position = UDim2.new(1, -24, 0.5, -11)
    ClrBtn.BackgroundColor3 = Theme.BgTertiary
    ClrBtn.BorderSizePixel = 0
    ClrBtn.Text = "×"
    ClrBtn.TextColor3 = Theme.Text
    ClrBtn.TextSize = 14
    ClrBtn.Font = SelectedFont
    ClrBtn.Parent = Row
    Cache.ScopeKeyLabel = KeyLbl
    SetBtn.MouseButton1Click:Connect(function()
        Cache.WaitingScopeKey = true
        Cache.ScopeKeyIgnoreUntil = tick() + 0.25
        Notify("Scope", "Press key or mouse button for ADS (Esc cancel)")
    end)
    ClrBtn.MouseButton1Click:Connect(function()
        Config.ScopeKey = ""
        KeyLbl.Text = "[-]"
        Notify("Scope", "Key cleared")
    end)
end
CreateGroupPanel("Players / Extra", 9.65, VisualsTab)
DmgNumBtn, DmgNumBg, DmgNumKnob = CreateFeatureRow("Damage Numbers", 9.7, VisualsTab, "Color_DamageNumber")
SelfChamsBtn, SelfChamsBg, SelfChamsKnob = CreateFeatureRow("Self Chams (Highlight)", 9.9, VisualsTab, "Color_SelfChams")

CloneChamsBtn, CloneChamsBg, CloneChamsKnob = CreateFeatureRow("Clone player", 9.92, VisualsTab, "Color_CloneChams")
OffscreenBtn, OffscreenBg, OffscreenKnob = CreateFeatureRow("Offscreen Arrows", 9.93, VisualsTab)
do
    local ColorListScroll
    local function CreateArrowColorRow(label, colorKey, defaultColor)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 30)
        Row.BackgroundColor3 = Theme.BgTertiary
        Row.BackgroundTransparency = 0
        Row.BorderSizePixel = 0
        Row.LayoutOrder = 1
        Row.Parent = ColorListScroll
        local rc = Instance.new("UICorner")
        rc.CornerRadius = UDim.new(0, 6)
        rc.Parent = Row

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, -52, 1, 0)
        Lbl.Position = UDim2.new(0, 12, 0, 0)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = label
        Lbl.TextColor3 = Theme.Text
        Lbl.TextSize = 12
        Lbl.Font = SelectedFont
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = Row

        local colBtn = Instance.new("TextButton")
        colBtn.Name = "ColorBtn"
        colBtn.Size = UDim2.new(0, 22, 0, 22)
        colBtn.Position = UDim2.new(1, -34, 0.5, -11)
        colBtn.BackgroundColor3 = Config[colorKey] or defaultColor or Theme.Accent
        colBtn.BorderSizePixel = 0
        colBtn.Text = ""
        colBtn.AutoButtonColor = false
        colBtn.Parent = Row



        colBtn.MouseButton1Click:Connect(function()
            if not OpenRGBPicker then return end
            OpenRGBPicker(Config[colorKey] or defaultColor or Theme.Accent, function(col)
                Config[colorKey] = col
                colBtn.BackgroundColor3 = col
                if UV_RefreshArrowGradients then UV_RefreshArrowGradients() end
            end, colBtn)
        end)

        Cache.ColorButtons = Cache.ColorButtons or {}
        Cache.ColorButtons[colorKey] = colBtn
        pcall(function() colBtn:SetAttribute("AnxiumColorKey", colorKey) end)

        if colorKey == "Color_OffscreenArrow" then
            Cache.ArrowColorABtn = colBtn
        elseif colorKey == "Color_OffscreenArrowB" then
            Cache.ArrowColorBBtn = colBtn
        end
    end

    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "ArrowColorListHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BackgroundTransparency = 0
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = 9.932
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = ResolveUIParent(VisualsTab)

    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Arrow Colors"
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow

    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "ArrowColorList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BackgroundTransparency = 0
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = 9.933
    ListFrame.ClipsDescendants = true
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    pcall(AnxiumListFrameStroke, ListFrame)

    ColorListScroll = Instance.new("ScrollingFrame")
    ColorListScroll.Size = UDim2.new(1, -8, 1, -8)
    ColorListScroll.Position = UDim2.new(0, 4, 0, 4)
    ColorListScroll.BackgroundTransparency = 1
    ColorListScroll.BorderSizePixel = 0
    ColorListScroll.ScrollBarThickness = 3
    ColorListScroll.ScrollBarImageColor3 = Theme.Accent
    ColorListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColorListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColorListScroll.Parent = ListFrame

    local ColorListLayout = Instance.new("UIListLayout")
    ColorListLayout.Padding = UDim.new(0, 3)
    ColorListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ColorListLayout.Parent = ColorListScroll

    local ColorListPad = Instance.new("UIPadding")
    ColorListPad.PaddingTop = UDim.new(0, 4)
    ColorListPad.PaddingBottom = UDim.new(0, 4)
    ColorListPad.PaddingLeft = UDim.new(0, 4)
    ColorListPad.PaddingRight = UDim.new(0, 4)
    ColorListPad.Parent = ColorListScroll

    CreateArrowColorRow("Gradient Color A", "Color_OffscreenArrow", Color3.fromRGB(255, 70, 70))
    CreateArrowColorRow("Gradient Color B", "Color_OffscreenArrowB", Color3.fromRGB(255, 150, 80))

    local listOpen = false
    local LIST_H = 2 * 33 + 12
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
end
CreateSliderRow("Arrow Radius", 10, 48, math.floor((Config.ArrowDistance or 0.42) * 100), 9.935, VisualsTab, function(val)
    Config.ArrowDistance = math.clamp(val / 100, 0.1, 0.48)
end)
CreateSliderRow("Arrow Size", 10, 100, math.floor(tonumber(Config.ArrowSize) or 34), 9.936, VisualsTab, function(val)
    Config.ArrowSize = math.floor(val)
end)
CreateSliderRow("Arrow Grad Speed", 0, 50, math.floor((Config.ArrowGradientSpeed or 0.35) * 10), 9.937, VisualsTab, function(val)
    Config.ArrowGradientSpeed = val / 10
end)
ArrowPulseBtn, ArrowPulseBg, ArrowPulseKnob = CreateFeatureRow("Arrow Pulse", 9.938, VisualsTab)
CreateSliderRow("Arrow Pulse Speed", 0.5, 12, Config.ArrowPulseSpeed or 3, 9.939, VisualsTab, function(val)
    Config.ArrowPulseSpeed = val
end)

DeathChamsBtn, DeathChamsBg, DeathChamsKnob = CreateFeatureRow("Death player", 9.94, VisualsTab, "Color_DeathChams")


do
    local styles = { "Chams", "FF" }
    local function makeMaterialList(label, layoutOrder, getStyle, setStyle, headerCacheKey)
        local Expanded = false
        local HeaderRow = Instance.new("TextButton")
        HeaderRow.Name = label:gsub("%s+", "") .. "ListHeader"
        HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
        HeaderRow.BackgroundColor3 = Theme.Card
        HeaderRow.BorderSizePixel = 0
        HeaderRow.AutoButtonColor = false
        HeaderRow.Text = ""
        HeaderRow.LayoutOrder = layoutOrder
        HeaderRow.Parent = ResolveUIParent(VisualsTab)
        local HeaderLbl = Instance.new("TextLabel")
        HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
        HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
        HeaderLbl.BackgroundTransparency = 1
        HeaderLbl.Text = label .. "  ·  " .. tostring(getStyle() or "Chams")
        HeaderLbl.TextColor3 = Theme.Text
        HeaderLbl.TextSize = 12
        HeaderLbl.Font = SelectedFont
        HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
        HeaderLbl.Parent = HeaderRow
        if headerCacheKey then Cache[headerCacheKey] = HeaderLbl end
        local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

        local ListFrame = Instance.new("Frame")
        ListFrame.Name = label:gsub("%s+", "") .. "List"
        ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
        ListFrame.Visible = false
        ListFrame.BackgroundColor3 = Theme.Card
        ListFrame.BorderSizePixel = 0
        ListFrame.ClipsDescendants = true
        ListFrame.LayoutOrder = layoutOrder + 0.001
        ListFrame.Parent = ResolveUIParent(VisualsTab)
        AnxiumListFrameStroke(ListFrame)
        local listLay = Instance.new("UIListLayout")
        listLay.SortOrder = Enum.SortOrder.LayoutOrder
        listLay.Padding = UDim.new(0, 2)
        listLay.Parent = ListFrame
        local listPad = Instance.new("UIPadding")
        listPad.PaddingTop = UDim.new(0, 4)
        listPad.PaddingBottom = UDim.new(0, 4)
        listPad.PaddingLeft = UDim.new(0, 4)
        listPad.PaddingRight = UDim.new(0, 4)
        listPad.Parent = ListFrame

        local function refreshHighlight()
            local cur = getStyle() or "Chams"
            for _, ch in ipairs(ListFrame:GetChildren()) do
                if ch:IsA("TextButton") then
                    local name = (ch:GetAttribute("StyleName") or ch.Text:gsub("^%s+", ""))
                    if name == cur then
                        ch.BackgroundColor3 = Theme.Accent or Color3.fromRGB(180, 140, 255)
                        ch.TextColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        ch.BackgroundColor3 = Theme.BgTertiary
                        ch.TextColor3 = Theme.Text
                    end
                end
            end
            HeaderLbl.Text = label .. "  ·  " .. tostring(cur)
        end

        for i, styleName in ipairs(styles) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -4, 0, 28)
            btn.BackgroundColor3 = Theme.BgTertiary
            btn.BorderSizePixel = 0
            btn.Text = "  " .. styleName
            btn.TextColor3 = Theme.Text
            btn.TextSize = 13
            btn.Font = SelectedFont
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.LayoutOrder = i
            btn.AutoButtonColor = true
            btn:SetAttribute("StyleName", styleName)
            btn.Parent = ListFrame
            btn.MouseButton1Click:Connect(function()
                setStyle(styleName)
                refreshHighlight()
                Notify("Visuals", label .. ": " .. styleName)
            end)
        end
        refreshHighlight()

        HeaderRow.MouseButton1Click:Connect(function()
            Expanded = not Expanded
            if Expanded then
                local h = #styles * 30 + 12
                AnxiumSetListOpen(ListFrame, true, h, HeaderRow)
                if ArrowLbl:IsA("ImageLabel") then
                    ArrowLbl.Image = "rbxassetid://71457658246709"
                    ArrowLbl.Rotation = 0
                end
            else
                AnxiumSetListOpen(ListFrame, false, nil, HeaderRow)
                if ArrowLbl:IsA("ImageLabel") then
                    ArrowLbl.Image = "rbxassetid://98648581502859"
                    ArrowLbl.Rotation = 0
                end
            end
        end)
        AnxiumSetListOpen(ListFrame, false, nil, HeaderRow)
    end

    makeMaterialList("Clone material", 9.925, function()
        return Config.CloneChamsStyle or "Chams"
    end, function(v) Config.CloneChamsStyle = v end, "CloneMaterialHeaderLbl")

    makeMaterialList("Death material", 9.945, function()
        return Config.DeathChamsStyle or "Chams"
    end, function(v) Config.DeathChamsStyle = v end, "DeathMaterialHeaderLbl")
end
DeathBurstBtn, DeathBurstBg, DeathBurstKnob = CreateFeatureRow("Death Burst", 9.95, VisualsTab, "Color_DeathBurst")
KillDissolveBtn, KillDissolveBg, KillDissolveKnob = CreateFeatureRow("Kill Dissolve", 9.96, VisualsTab, "Color_KillDissolve")
DeathXRayBtn, DeathXRayBg, DeathXRayKnob = CreateFeatureRow("Death FX Through Walls", 9.97, VisualsTab)
KillFlashBtn, KillFlashBg, KillFlashKnob = CreateFeatureRow("Kill Flash (Screen)", 9.972, VisualsTab, "Color_KillFlash")
CreateSliderRow("Flash Duration (x0.1s)", 2, 25, math.floor((Config.KillFlashDuration or 0.85) * 10), 9.973, VisualsTab, function(val)
    Config.KillFlashDuration = val / 10
end)
KillLightningBtn, KillLightningBg, KillLightningKnob = CreateFeatureRow("Kill Lightning", 9.974, VisualsTab, "Color_KillLightning")
CreateSliderRow("Lightning Size", 40, 400, math.floor((tonumber(Config.KillLightningSize) or 1.5) * 100), 9.975, VisualsTab, function(val)
    Config.KillLightningSize = math.clamp((val or 150) / 100, 0.4, 4)
end)
CreateSliderRow("Lightning Duration", 10, 300, math.floor((tonumber(Config.KillLightningDuration) or 0.55) * 100), 9.976, VisualsTab, function(val)
    Config.KillLightningDuration = math.clamp((val or 55) / 100, 0.1, 3)
end)
KillLogsBtn, KillLogsBg, KillLogsKnob = CreateFeatureRow("Kill Logs", 9.977, VisualsTab)
HitLogsBtn, HitLogsBg, HitLogsKnob = CreateFeatureRow("Hit Logs", 9.978, VisualsTab)
CreateGroupPanel("Camera", 9.8, VisualsTab)
CameraFovBtn, CameraFovBg, CameraFovKnob = CreateFeatureRow("Camera FOV", 9.9, VisualsTab)
CreateSliderRow("FOV Value", 1, 120, Config.CameraFovValue or 120, 9.95, VisualsTab, function(val)
    Config.CameraFovValue = val
    if Config.CameraFovEnabled then CameraFov_Apply() end
end)
FpsBoostBtn, FpsBoostBg, FpsBoostKnob = CreateFeatureRow("FPS Boost", 9.98, VisualsTab)
FullBtn, FullBg, FullKnob = CreateFeatureRow("Fullbright", 10, VisualsTab)

DarkModeBtn, DarkModeBg, DarkModeKnob = CreateFeatureRow("Dark Mode", 10.5, VisualsTab)
CreateSliderRow("Darkness", 0, 100, math.floor(tonumber(Config.DarkModeIntensity) or 50), 10.55, VisualsTab, function(val)
    Config.DarkModeIntensity = val
end)
WorldColorBtn, WorldColorBg, WorldColorKnob = CreateFeatureRow("World Color", 10.6, VisualsTab, "Color_World")
CreateSliderRow("World Color Intensity", 0, 100, math.floor(tonumber(Config.WorldColorIntensity) or 55), 10.62, VisualsTab, function(val)
    Config.WorldColorIntensity = val
    if Config.WorldColorEnabled then pcall(ApplyWorldVisuals) end
end)
NoShadowsBtn, NoShadowsBg, NoShadowsKnob = CreateFeatureRow("No Shadows", 10.7, VisualsTab)
HitMarkerBtn, HitMarkerBg, HitMarkerKnob = CreateFeatureRow("Hit Marker", 10.8, VisualsTab, "Color_HitMarker")
CreateSliderRow("Hit Marker Duration", 0.2, 3, tonumber(Config.HitMarkerDuration) or 1.2, 10.85, VisualsTab, function(val)
    Config.HitMarkerDuration = val
end)
CreateSliderRow("Hit Marker Size", 8, 40, math.floor(tonumber(Config.HitMarkerSize) or 18), 10.86, VisualsTab, function(val)
    Config.HitMarkerSize = math.floor(val + 0.5)
end)
CreateSliderRow("Hit Marker Gap", 2, 16, math.floor(tonumber(Config.HitMarkerGap) or 6), 10.87, VisualsTab, function(val)
    Config.HitMarkerGap = math.floor(val + 0.5)
end)
CreateSliderRow("Hit Marker Thickness", 1, 8, math.floor(tonumber(Config.HitMarkerThickness) or 3), 10.88, VisualsTab, function(val)
    Config.HitMarkerThickness = math.floor(val + 0.5)
end)
CreateSliderRow("Hit Marker Rotation", 0, 360, tonumber(Config.HitMarkerRotation) or 0, 10.89, VisualsTab, function(val)
    Config.HitMarkerRotation = val
end)

ActiveListBtn, ActiveListBg, ActiveListKnob = CreateFeatureRow("Active Modules HUD", 11, VisualsTab)
CreateSliderRow("Active HUD Transparency", 0, 95, math.floor((tonumber(Config.ActiveListTransparency) or 0.05) * 100), 11.05, VisualsTab, function(val)
    Config.ActiveListTransparency = val / 100
    pcall(ApplyHudPanelTransparency)
end)
BindListBtn, BindListBg, BindListKnob = CreateFeatureRow("Binds HUD", 11.5, VisualsTab)
CreateSliderRow("Binds HUD Transparency", 0, 95, math.floor((tonumber(Config.BindListTransparency) or 0.05) * 100), 11.55, VisualsTab, function(val)
    Config.BindListTransparency = val / 100
    pcall(ApplyHudPanelTransparency)
end)
UpdateSwitch(Config.ActiveListEnabled, ActiveListBg, ActiveListKnob)
FakeFpsBtn, FakeFpsBg, FakeFpsKnob = CreateFeatureRow("Fake FPS", 11.2, VisualsTab)
do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.96, 0, 0, 36)
    row.BackgroundColor3 = Theme.BgSecondary
    row.BackgroundTransparency = 0.45
    row.BorderSizePixel = 0
    row.LayoutOrder = 11.3
    row.Parent = ResolveUIParent(VisualsTab)
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 9)
    rc.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.45, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "FPS Value"
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 12
    lbl.Font = SelectedFont
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local cycle = Instance.new("TextButton")
    cycle.Size = UDim2.new(0, 90, 0, 24)
    cycle.Position = UDim2.new(1, -102, 0.5, -12)
    cycle.BackgroundColor3 = Theme.BgTertiary
    cycle.BorderSizePixel = 0
    cycle.Text = tostring(Config.FakeFpsValue or 67)
    cycle.TextColor3 = Theme.Text
    cycle.TextSize = 12
    cycle.Font = SelectedFont
    cycle.Parent = row
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 6)
    cc.Parent = cycle
    local opts = { 67, 1488, 69, 333, 1337, 666 }
    cycle.MouseButton1Click:Connect(function()
        Config.FakeFpsIndex = (Config.FakeFpsIndex or 1) % #opts + 1
        Config.FakeFpsValue = opts[Config.FakeFpsIndex]
        cycle.Text = tostring(Config.FakeFpsValue)
        UpdateFakeFpsDisplay()
        Notify("Fake FPS", "Set to " .. tostring(Config.FakeFpsValue))
    end)
    Cache.FakeFpsCycleBtn = cycle
end

CreateGroupPanel("China Hat", 11.9, VisualsTab)
HatBtn, HatBg, HatKnob = CreateFeatureRow("China Hat", 12, VisualsTab, "Color_ChinaHat")
do
    local styles = { "Drawing", "Mesh" }
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "ChinaHatStyleHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.LayoutOrder = 12.1
    HeaderRow.Parent = ResolveUIParent(VisualsTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Style  ·  " .. tostring(Config.ChinaHatStyle or "Drawing")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.ChinaHatStyleHeaderLbl = HeaderLbl
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)
    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "ChinaHatStyleList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.LayoutOrder = 12.11
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    pcall(AnxiumListFrameStroke, ListFrame)
    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 3)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ListScroll
    local Expanded = false
    local function refresh()
        local cur = Config.ChinaHatStyle or "Drawing"
        if Cache.ChinaHatStyleHeaderLbl then
            Cache.ChinaHatStyleHeaderLbl.Text = "Style  ·  " .. tostring(cur)
        end
        for _, ch in ipairs(ListScroll:GetChildren()) do
            if ch:IsA("TextButton") then
                if ch.Text:find(cur, 1, true) then
                    ch.BackgroundColor3 = Theme.Accent
                    ch.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    ch.BackgroundColor3 = Theme.BgTertiary
                    ch.TextColor3 = Theme.Text
                end
            end
        end
    end
    for i, name in ipairs(styles) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Theme.Text
        btn.TextSize = 12
        btn.Font = SelectedFont
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.Parent = ListScroll
        do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn end
        btn.MouseButton1Click:Connect(function()
            Config.ChinaHatStyle = name
            ChinaHat_ApplyStyle()
            refresh()
            Notify("China Hat", "Style: " .. name)
        end)
    end
    refresh()
    HeaderRow.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        local listH = #styles * 31 + 12
        if Expanded then AnxiumSetListOpen(ListFrame, true, listH, HeaderRow) else AnxiumSetListOpen(ListFrame, false) end
        if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 end
    end)
end
CreateSliderRow("Hat Global Scale", 5, 30, 10, 13, VisualsTab, function(val) Config.ChinaHatScale = val / 10 end)
CreateSliderRow("Hat Height Offset", 0, 20, 5, 14, VisualsTab, function(val) Config.ChinaHatHeightOffset = val / 10 end)
CreateSliderRow("Hat Height", 5, 40, 17, 15, VisualsTab, function(val) Config.ChinaHatHeight = val / 10 end)
CreateSliderRow("Hat Radius", 10, 50, 23, 16, VisualsTab, function(val) Config.ChinaHatRadius = val / 10 end)
CreateSliderRow("Mesh Size", 1, 5, Config.ChinaHatMeshSize or 3, 16.2, VisualsTab, function(val)
    Config.ChinaHatMeshSize = val
    ChinaHatMesh_Update()
end)
CreateSliderRow("Mesh Transparency", 0, 100, math.floor((Config.ChinaHatMeshTransparency or 0.5) * 100), 16.3, VisualsTab, function(val)
    Config.ChinaHatMeshTransparency = val / 100
    ChinaHatMesh_Update()
end)

CreateGroupPanel("Angel Halo", 16.5, VisualsTab)
AngelHaloBtn, AngelHaloBg, AngelHaloKnob = CreateFeatureRow("Angel Halo", 16.55, VisualsTab, "Color_AngelHalo")
CreateSliderRow("Halo Height", 0.2, 4, Config.AngelHaloHeight or 1.2, 16.56, VisualsTab, function(val)
    Config.AngelHaloHeight = val
end)
CreateSliderRow("Halo Radius", 0.3, 4, Config.AngelHaloRadius or 1.15, 16.57, VisualsTab, function(val)
    Config.AngelHaloRadius = val
end)
CreateSliderRow("Halo Transparency", 0, 100, math.floor((tonumber(Config.AngelHaloTransparency) or 0.2) * 100), 16.58, VisualsTab, function(val)
    Config.AngelHaloTransparency = val / 100
end)
CreateSliderRow("Halo Thickness", 0.04, 0.4, Config.AngelHaloThickness or 0.14, 16.59, VisualsTab, function(val)
    Config.AngelHaloThickness = val
end)
CreateSliderRow("Halo Segments", 12, 64, math.floor(tonumber(Config.AngelHaloSegments) or 36), 16.6, VisualsTab, function(val)
    Config.AngelHaloSegments = math.floor(val + 0.5)
    pcall(AngelHalo_Hide)
end)
CreateSliderRow("Halo Rings", 1, 3, math.floor(tonumber(Config.AngelHaloRings) or 1), 16.61, VisualsTab, function(val)
    Config.AngelHaloRings = math.clamp(math.floor(val + 0.5), 1, 3)
    pcall(AngelHalo_Hide)
end)

CreateGroupPanel("World / FX", 16.8, VisualsTab)
CreateSliderRow("Angel Halo Glow", 0, 12, math.floor(tonumber(Config.AngelHaloGlow) or 3), 16.95, VisualsTab, function(val)
    Config.AngelHaloGlow = math.floor(val + 0.5)
    Cache.AngelHaloSig = nil
end)
TargetDotBtn, TargetDotBg, TargetDotKnob = CreateFeatureRow("Target Dot", 17.4, VisualsTab, "Color_TargetDot")
CreateSliderRow("Target Dot Size", 10, 120, math.floor(tonumber(Config.TargetDotSize) or 28), 17.41, VisualsTab, function(val)
    Config.TargetDotSize = math.floor(val + 0.5)
end)
CreateSliderRow("Target Dot Transp %", 0, 90, math.floor((tonumber(Config.TargetDotTransparency) or 0.1) * 100), 17.42, VisualsTab, function(val)
    Config.TargetDotTransparency = val / 100
end)
OrbitOrbsBtn, OrbitOrbsBg, OrbitOrbsKnob = CreateFeatureRow("Neon Orbit Bands", 17, VisualsTab, "Color_Orbit")
CreateSliderRow("Orbit Speed", 1, 20, Config.OrbitSpeedValue, 18, VisualsTab, function(val) Config.OrbitSpeedValue = val end)
TargetRingBtn, TargetRingBg, TargetRingKnob = CreateFeatureRow("Target Scan Ring", 18.2, VisualsTab, "Color_TargetRing")
CreateSliderRow("Scan Speed", 0.2, 5, Config.TargetRingSpeed or 1.2, 18.3, VisualsTab, function(val)
    Config.TargetRingSpeed = val
end)
CreateSliderRow("Ring Radius", 0.8, 6, Config.TargetRingRadius or 2.2, 18.4, VisualsTab, function(val)
    Config.TargetRingRadius = val
end)

TargetMarkerBtn, TargetMarkerBg, TargetMarkerKnob = CreateFeatureRow("Target Marker", 18.5, VisualsTab, "Color_TargetMarker")
CreateSliderRow("Marker Size", 40, 200, Config.TargetMarkerSize or 90, 18.51, VisualsTab, function(val)
    Config.TargetMarkerSize = val
end)
CreateSliderRow("Marker Trans", 0, 100, math.floor((Config.TargetMarkerTransparency or 0.15) * 100), 18.52, VisualsTab, function(val)
    Config.TargetMarkerTransparency = val / 100
end)
TargetMarkerRotBtn, TargetMarkerRotBg, TargetMarkerRotKnob = CreateFeatureRow("Marker Rotate", 18.53, VisualsTab)
CreateSliderRow("Marker Spin Speed", 0, 360, Config.TargetMarkerRotateSpeed or 90, 18.54, VisualsTab, function(val)
    Config.TargetMarkerRotateSpeed = val
end)
TrailBtn, TrailBg, TrailKnob = CreateFeatureRow("Motion Trail", 19, VisualsTab, "Color_Trail")
NoFogBtn, NoFogBg, NoFogKnob = CreateFeatureRow("No Fog", 19.9, VisualsTab)
FogBtn, FogBg, FogKnob = CreateFeatureRow("Custom Fog", 20, VisualsTab, "Color_Fog")
CreateSliderRow("Fog Distance", 50, 2000, Config.FogDistanceValue, 21, VisualsTab, function(val) Config.FogDistanceValue = val end)
SelfTransBtn, SelfTransBg, SelfTransKnob = CreateFeatureRow("Self Transparency", 21.05, VisualsTab)
CreateSliderRow("Self Transparency Amount", 0, 100, math.floor((tonumber(Config.SelfTransparency) or 0.4) * 100), 21.06, VisualsTab, function(val)
    Config.SelfTransparency = val / 100
    if Config.SelfTransparencyEnabled then pcall(ApplySelfTransparency) end
end)
DayCycleBtn, DayCycleBg, DayCycleKnob = CreateFeatureRow("Day Cycle", 21.2, VisualsTab)
CreateSliderRow("Time of Day", 0, 24, Config.DayCycleTime or 14, 21.3, VisualsTab, function(val)
    Config.DayCycleTime = val
    if Config.DayCycleEnabled and DayCycle_Apply then DayCycle_Apply() end
end)

FootstepsBtn, FootstepsBg, FootstepsKnob = CreateFeatureRow("Jump Circles", 22, VisualsTab, "Color_JumpCircle")
CreateSliderRow("End Radius", 1, 12, Config.JumpCircleSize or 5, 23, VisualsTab, function(val) Config.JumpCircleSize = val end)
CreateSliderRow("Start Radius", 0.2, 4, Config.JumpCircleStartRadius or 0.8, 23.5, VisualsTab, function(val) Config.JumpCircleStartRadius = val end)
CreateSliderRow("Ring Thickness", 0.05, 0.6, Config.JumpCircleThickness or 0.18, 24, VisualsTab, function(val) Config.JumpCircleThickness = val end)
CreateSliderRow("Expand Time", 0.2, 2, Config.JumpCircleExpandTime or 0.7, 24.2, VisualsTab, function(val) Config.JumpCircleExpandTime = val end)
CreateSliderRow("Segments", 16, 80, math.floor(tonumber(Config.JumpCircleSegments) or 48), 24.3, VisualsTab, function(val)
    Config.JumpCircleSegments = math.floor(val + 0.5)
end)

FallingStarsBtn, FallingStarsBg, FallingStarsKnob = CreateFeatureRow("Falling Stars", 24.4, VisualsTab, "Color_FallingStars")
CreateSliderRow("Star Size", 8, 90, math.floor(tonumber(Config.FallingStarsSize) or 28), 24.45, VisualsTab, function(val)
    Config.FallingStarsSize = math.floor(val + 0.5)
    if Cache.FallingStarsApply then Cache.FallingStarsApply() end
end)
CreateSliderRow("Star Count", 20, 150, math.floor(tonumber(Config.FallingStarsCount) or 70), 24.46, VisualsTab, function(val)
    Config.FallingStarsCount = math.floor(val + 0.5)
    if Cache.FallingStarsRebuild then Cache.FallingStarsRebuild() end
end)

AspectBtn, AspectBg, AspectKnob = CreateFeatureRow("Aspect Ratio", 25, VisualsTab)
CreateSliderRow("Aspect Scale (%)", 50, 200, 133, 26, VisualsTab, function(val) Config.AspectRatioValue = val / 100 end)

ThirdPersonBtn, ThirdPersonBg, ThirdPersonKnob = CreateFeatureRow("Third Person", 27, VisualsTab)
CreateSliderRow("Cam Distance", 5, 50, Config.ThirdPersonDistance, 28, VisualsTab, function(val)
    Config.ThirdPersonDistance = val
    if Config.ThirdPersonEnabled and ThirdPerson_ForceDistance then
        ThirdPerson_ForceDistance(val)
    end
end)

CreateSectionHeader("- Materials -", 29, VisualsTab)
FFBtn, FFBg, FFKnob = CreateFeatureRow("Self ForceField", 30, VisualsTab, "Color_ForceField")
WeaponFFBtn, WeaponFFBg, WeaponFFKnob = CreateFeatureRow("Weapon Material", 31, VisualsTab, "Color_WeaponFF")
do
    local styles = { "ForceField", "Neon", "Glass", "Ice", "Metal", "SmoothPlastic", "Foil", "Plastic" }
    local Expanded = false
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "WeaponStyleListHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = 31.05
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = ResolveUIParent(VisualsTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Weapon Style  ·  " .. tostring(Config.WeaponMaterialStyle or "ForceField")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.WeaponStyleHeaderLbl = HeaderLbl
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "WeaponStyleList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.BgSecondary
    ListFrame.BackgroundTransparency = 0.15
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.LayoutOrder = 31.06
    ListFrame.Visible = false
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    pcall(AnxiumListFrameStroke, ListFrame)
    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 4
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    local lay = Instance.new("UIListLayout")
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 4)
    lay.Parent = ListScroll
    Cache.WeaponStyleButtons = {}
    local function RefreshHighlight()
        local cur = Config.WeaponMaterialStyle or "ForceField"
        if Cache.WeaponStyleHeaderLbl then
            Cache.WeaponStyleHeaderLbl.Text = "Weapon Style  ·  " .. tostring(cur)
        end
        for name, b in pairs(Cache.WeaponStyleButtons) do
            if b and b.Parent then
                if name == cur then
                    b.BackgroundColor3 = Theme.Accent
                    b.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    b.BackgroundColor3 = Theme.BgTertiary
                    b.TextColor3 = Theme.Text
                end
            end
        end
    end
    Cache.RefreshWeaponStyleList = RefreshHighlight
    for i, styleName in ipairs(styles) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -4, 0, 28)
        b.BackgroundColor3 = Theme.BgTertiary
        b.BorderSizePixel = 0
        b.Text = "  " .. styleName
        b.TextColor3 = Theme.Text
        b.TextSize = 13
        b.Font = SelectedFont
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.LayoutOrder = i
        b.Parent = ListScroll
        Cache.WeaponStyleButtons[styleName] = b
        b.MouseButton1Click:Connect(function()
            Config.WeaponMaterialStyle = styleName
            RefreshHighlight()
            if Config.WeaponForceFieldEnabled then
                pcall(function()
                    if WeaponFF_RestoreAll then WeaponFF_RestoreAll() end
                    if WeaponFF_ApplyAll then WeaponFF_ApplyAll() end
                end)
            end
            Notify("Weapon Material", styleName)
        end)
    end
    RefreshHighlight()
    local listH = math.min(28 * #styles + 16, 200)
    HeaderRow.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        if Expanded then AnxiumSetListOpen(ListFrame, true, listH, HeaderRow) else AnxiumSetListOpen(ListFrame, false) end
        if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 elseif ArrowLbl:IsA("TextLabel") then if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = Expanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = Expanded and "▲" or "▼" end end
    end)
end
HitboxShowBtn, HitboxShowBg, HitboxShowKnob = CreateFeatureRow("Show Hitboxes", 15.5, CombatTab, "Color_Hitbox")
BulletTracerBtn, BulletTracerBg, BulletTracerKnob = CreateFeatureRow("Bullet Tracers", 32.5, VisualsTab, "Color_BulletTracer")
CreateSliderRow("Tracer Cooldown (ms)", 0, 5000, math.floor(tonumber(Config.BulletTracerCooldown) or 120), 32.51, VisualsTab, function(val)
    Config.BulletTracerCooldown = math.floor(val + 0.5)
end)
CreateSliderRow("Tracer Transparency", 0, 90, math.floor((tonumber(Config.BulletTracerTransparency) or 0.15) * 100), 32.52, VisualsTab, function(val)
    Config.BulletTracerTransparency = math.clamp(val, 0, 90) / 100
end)




CreateSectionHeader("- Autowall -", 31.8, VisualsTab)
AutowallBtn, AutowallBg, AutowallKnob = CreateFeatureRow("Autowall", 31.81, VisualsTab)
AutowallInfoBtn, AutowallInfoBg, AutowallInfoKnob = CreateFeatureRow("Autowall Info", 31.82, VisualsTab)
CreateSliderRow("Autowall Size", 8, 48, math.floor(tonumber(Config.AutowallSize) or 18), 31.83, VisualsTab, function(val)
    Config.AutowallSize = val
    if Cache.AutowallApply then Cache.AutowallApply() end
end)
CreateSliderRow("Autowall Corner", 0, 20, math.floor(tonumber(Config.AutowallCorner) or 3), 31.84, VisualsTab, function(val)
    Config.AutowallCorner = val
    if Cache.AutowallApply then Cache.AutowallApply() end
end)
CreateSliderRow("Autowall Transparency", 0, 90, math.floor((tonumber(Config.AutowallTransparency) or 0.15) * 100), 31.85, VisualsTab, function(val)
    Config.AutowallTransparency = math.clamp(val, 0, 90) / 100
    if Cache.AutowallApply then Cache.AutowallApply() end
end)
do
    local ColorListScroll
    local function CreateAWColorRow(label, colorKey)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 30)
        Row.BackgroundColor3 = Theme.BgTertiary
        Row.BackgroundTransparency = 0
        Row.BorderSizePixel = 0
        Row.LayoutOrder = 1
        Row.Parent = ColorListScroll
        do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = Row end
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -44, 1, 0)
        lbl.Position = UDim2.fromOffset(10, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = Theme.Text
        lbl.TextSize = 12
        lbl.Font = SelectedFont
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = Row
        local colBtn = Instance.new("TextButton")
        colBtn.Size = UDim2.fromOffset(22, 22)
        colBtn.Position = UDim2.new(1, -30, 0.5, -11)
        colBtn.BackgroundColor3 = Config[colorKey] or Theme.Accent
        colBtn.BorderSizePixel = 0
        colBtn.Text = ""
        colBtn.AutoButtonColor = false
        colBtn.Parent = Row

        colBtn.MouseButton1Click:Connect(function()
            if not OpenRGBPicker then return end
            OpenRGBPicker(Config[colorKey] or Theme.Accent, function(col)
                Config[colorKey] = col
                colBtn.BackgroundColor3 = col
            end, colBtn)
        end)
        Cache.ColorButtons = Cache.ColorButtons or {}
        Cache.ColorButtons[colorKey] = colBtn
        pcall(function() colBtn:SetAttribute("AnxiumColorKey", colorKey) end)
    end

    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "AutowallColorListHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = 31.86
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = ResolveUIParent(VisualsTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Colors"
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)
    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "AutowallColorList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = 31.87
    ListFrame.ClipsDescendants = true
    ListFrame.Parent = ResolveUIParent(VisualsTab)
    pcall(AnxiumListFrameStroke, ListFrame)
    ColorListScroll = Instance.new("ScrollingFrame")
    ColorListScroll.Size = UDim2.new(1, -8, 1, -8)
    ColorListScroll.Position = UDim2.new(0, 4, 0, 4)
    ColorListScroll.BackgroundTransparency = 1
    ColorListScroll.BorderSizePixel = 0
    ColorListScroll.ScrollBarThickness = 3
    ColorListScroll.ScrollBarImageColor3 = Theme.Accent
    ColorListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColorListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColorListScroll.Parent = ListFrame
    local ColorListLayout = Instance.new("UIListLayout")
    ColorListLayout.Padding = UDim.new(0, 3)
    ColorListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ColorListLayout.Parent = ColorListScroll
    local ColorListPad = Instance.new("UIPadding")
    ColorListPad.PaddingTop = UDim.new(0, 4)
    ColorListPad.PaddingBottom = UDim.new(0, 4)
    ColorListPad.PaddingLeft = UDim.new(0, 4)
    ColorListPad.PaddingRight = UDim.new(0, 4)
    ColorListPad.Parent = ColorListScroll
    CreateAWColorRow("Can Penetrate", "Color_AutowallPen")
    CreateAWColorRow("Maybe", "Color_AutowallMid")
    CreateAWColorRow("Cannot", "Color_AutowallBlock")
    local listOpen = false
    local LIST_H = 3 * 33 + 12
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
end

CreateSectionHeader("- Auras -", 32, VisualsTab)
AuraBtn, AuraBg, AuraKnob = CreateFeatureRow("Aura", 33, VisualsTab, "Color_Aura")
ClassicPinkBtn, ClassicPinkBg, ClassicPinkKnob = CreateFeatureRow("Pink Aura", 34, VisualsTab, "Color_Aura")
ClassicAngelBtn, ClassicAngelBg, ClassicAngelKnob = CreateFeatureRow("Angel Wing", 35, VisualsTab, "Color_Aura")
ParticleStarBtn, ParticleStarBg, ParticleStarKnob = CreateFeatureRow("Starlight", 36, VisualsTab, "Color_Aura")
ParticleAngelBtn, ParticleAngelBg, ParticleAngelKnob = CreateFeatureRow("Angel", 37, VisualsTab, "Color_Aura")

TeamCheckerBtn, TeamCheckerBg, TeamCheckerKnob = CreateFeatureRow("Team Checker", 0.5, CombatTab)
AimBtn, AimBg, AimKnob = CreateFeatureRow("Aimbot", 1, CombatTab)
AimWallBtn, AimWallBg, AimWallKnob = CreateFeatureRow("Aim Wall Check", 1.2, CombatTab)
ShowFovBtn, ShowFovBg, ShowFovKnob = CreateFeatureRow("Show FOV", 2, CombatTab, "Color_Fov")
FovFillBtn, FovFillBg, FovFillKnob = CreateFeatureRow("FOV Fill", 2.1, CombatTab, "Color_FovFill")
CreateSliderRow("FOV Fill Transparency", 0, 100, math.floor((Config.FovFillTransparency or 0.7) * 100), 2.2, CombatTab, function(val)
    Config.FovFillTransparency = val / 100
    if FovCircleFill then FovCircleFill.Transparency = Config.FovFillTransparency end
end)
FovPulseBtn, FovPulseBg, FovPulseKnob = CreateFeatureRow("FOV Pulse", 2.3, CombatTab)
CreateSliderRow("FOV Pulse Speed", 0.5, 12, Config.FovPulseSpeed or 3, 2.35, CombatTab, function(val)
    Config.FovPulseSpeed = val
end)
CreateSliderRow("FOV Pulse Amount", 1, 40, math.floor((Config.FovPulseAmount or 0.12) * 100), 2.36, CombatTab, function(val)
    Config.FovPulseAmount = val / 100
end)
CreateSliderRow("FOV Size", 30, 500, Config.FovRadius, 3, CombatTab, function(val)
    Config.FovRadius = val
    FovCircle.Radius = Config.FovRadius
    if FovCircleFill then FovCircleFill.Radius = Config.FovRadius end
end)
FovDynBtn, FovDynBg, FovDynKnob = CreateFeatureRow("FOV Dynamic", 3.05, CombatTab)
CreateSliderRow("FOV Dynamic Expand", 0, 150, math.floor(tonumber(Config.FovDynamicExpand) or 40), 3.06, CombatTab, function(val)
    Config.FovDynamicExpand = math.floor(val + 0.5)
end)
CreateSliderRow("Aim Smooth", 1, 100, math.floor((Config.AimSmoothValue or 0.18) * 100), 5, CombatTab, function(val)
    Config.AimSmoothValue = math.clamp(val / 100, 0.01, 1)
end)


CreateBodyPartList = function(title, layoutOrder, getPart, setPart, parentTab)
    parentTab = parentTab or CombatTab
    local host = ResolveUIParent(parentTab)
    local parts = BODY_PART_OPTIONS or { "Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", "Random", "Closest" }

    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BackgroundTransparency = 0
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = layoutOrder
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = host

    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.fromOffset(12, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextSize = 12
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.Text = title .. "  ·  " .. tostring(getPart() or "Head")
    HeaderLbl.Parent = HeaderRow

    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BackgroundTransparency = 0
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = layoutOrder + 0.01
    ListFrame.ClipsDescendants = true
    ListFrame.Visible = false
    ListFrame.Parent = host
    pcall(AnxiumListFrameStroke, ListFrame)

    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    pcall(function() TrackThemeAccent(ListScroll, "ScrollBarImageColor3") end)

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 3)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ListScroll

    local ListPad = Instance.new("UIPadding")
    ListPad.PaddingTop = UDim.new(0, 4)
    ListPad.PaddingBottom = UDim.new(0, 4)
    ListPad.PaddingLeft = UDim.new(0, 4)
    ListPad.PaddingRight = UDim.new(0, 4)
    ListPad.Parent = ListScroll

    local buttons = {}
    local function refresh()
        local cur = getPart() or "Head"
        HeaderLbl.Text = title .. "  ·  " .. tostring(cur)
        for name, btn in pairs(buttons) do
            if name == cur then
                btn.BackgroundColor3 = Theme.Accent
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Theme.BgTertiary
                btn.TextColor3 = Theme.Text
            end
        end
    end

    for i, name in ipairs(parts) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Theme.Text
        btn.TextSize = 12
        btn.Font = SelectedFont
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.Parent = ListScroll
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = btn
        end
        buttons[name] = btn
        btn.MouseButton1Click:Connect(function()
            setPart(name)
            refresh()
            Notify(title, "Selected: " .. name)
        end)
    end
    refresh()

    local listOpen = false
    local LIST_H = math.min(#parts * 31 + 12, 220)
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)

    return refresh
end

Cache.RefreshAimPartList = CreateBodyPartList("Aimbot Hit Part", 5.1, function()
    return Config.AimTargetPart or "Head"
end, function(v) Config.AimTargetPart = v end, CombatTab)

TargetHudBtn, TargetHudBg, TargetHudKnob = CreateFeatureRow("Target HUD", 6, CombatTab, "Color_TargetHud")
TargetLineBtn, TargetLineBg, TargetLineKnob = CreateFeatureRow("Target Line", 6.1, CombatTab, "Color_TargetLine")
TargetLineVisBtn, TargetLineVisBg, TargetLineVisKnob = CreateFeatureRow("TL Visible Check", 6.12, CombatTab)
CreateSliderRow("Target Line Trans", 0, 100, math.floor((Config.TargetLineTransparency or 0.15) * 100), 6.15, CombatTab, function(val)
    Config.TargetLineTransparency = val / 100
end)
SpinBtn, SpinBg, SpinKnob = CreateFeatureRow("SpinBot", 7, CombatTab)
CreateSliderRow("Spin Speed", 0, 500, Config.SpinSpeed, 8, CombatTab, function(val) 
    Config.SpinSpeed = val 
    if Config.SpinEnabled then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local spinObj = hrp:FindFirstChild("Spinning")
            if spinObj then spinObj.AngularVelocity = Vector3.new(0, val, 0) end
        end
    end
end)

CreateGroupPanel("Anti-Aim", 8.4, CombatTab)
AntiAimBtn, AntiAimBg, AntiAimKnob = CreateFeatureRow("Anti-Aim", 8.5, CombatTab)
CreateSliderRow("AA Pitch", -75, 75, Config.AntiAimPitch, 8.6, CombatTab, function(val)
    Config.AntiAimPitch = val
end)
CreateSliderRow("AA Yaw", -180, 180, Config.AntiAimYaw, 8.7, CombatTab, function(val)
    Config.AntiAimYaw = val
end)
do
    local modes = { "Static", "Jitter", "Spin", "TP" }

    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = 8.75
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = ResolveUIParent(CombatTab)

    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.fromOffset(12, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "AA Mode  ·  " .. tostring(Config.AntiAimMode or "Static")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.AntiAimModeBtn = HeaderLbl

    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = 8.76
    ListFrame.ClipsDescendants = true
    ListFrame.Visible = false
    ListFrame.Parent = ResolveUIParent(CombatTab)
    pcall(AnxiumListFrameStroke, ListFrame)

    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -12, 1, -8)
    ListScroll.Position = UDim2.fromOffset(6, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 3)
    lay.Parent = ListScroll

    local modeButtons = {}
    local function refreshAAModeList()
        local cur = Config.AntiAimMode or "Static"
        if HeaderLbl then HeaderLbl.Text = "AA Mode  ·  " .. tostring(cur) end
        for name, btn in pairs(modeButtons) do
            if name == cur then
                btn.BackgroundColor3 = Theme.Accent
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Theme.BgTertiary
                btn.TextColor3 = Theme.Text
            end
        end
    end
    Cache.RefreshAAModeList = refreshAAModeList

    for i, name in ipairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Theme.Text
        btn.TextSize = 12
        btn.Font = SelectedFont
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.Parent = ListScroll
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = btn
        end
        modeButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            Config.AntiAimMode = name
            refreshAAModeList()
            Notify("Anti-Aim", "Mode: " .. name)
        end)
    end
    refreshAAModeList()

    local listOpen = false
    local LIST_H = #modes * 31 + 12
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
end
CreateSliderRow("AA Jitter Range", 5, 90, Config.AntiAimJitter or 35, 8.8, CombatTab, function(val)
    Config.AntiAimJitter = val
end)
CreateSliderRow("AA Spin Speed", 90, 1440, Config.AntiAimSpinSpeed or 720, 8.85, CombatTab, function(val)
    Config.AntiAimSpinSpeed = val
end)
CreateSliderRow("AA TP Radius", 1, 25, Config.AntiAimTPRadius or 5, 8.86, CombatTab, function(val)
    Config.AntiAimTPRadius = val
end)
CreateSliderRow("AA TP Speed", 1, 30, Config.AntiAimTPSpeed or 8, 8.87, CombatTab, function(val)
    Config.AntiAimTPSpeed = val
end)
AntiAimResolveBtn, AntiAimResolveBg, AntiAimResolveKnob = CreateFeatureRow("AA Shoot Resolve", 8.88, CombatTab)
CreateSliderRow("AA Resolve Return (ms)", 0, 500, math.floor(tonumber(Config.AntiAimResolveReturnMs) or 60), 8.89, CombatTab, function(val)
    Config.AntiAimResolveReturnMs = math.floor(val + 0.5)
end)
CreateSliderRow("AA Resolve Hold (ms)", 10, 500, math.floor(tonumber(Config.AntiAimResolveHoldMs) or 100), 8.90, CombatTab, function(val)
    Config.AntiAimResolveHoldMs = math.floor(val + 0.5)
end)

CreateGroupPanel("Trigger / Misc", 8.95, CombatTab)
TriggerbotBtn, TriggerbotBg, TriggerbotKnob = CreateFeatureRow("Triggerbot", 9, CombatTab)
CreateSliderRow("Trigger Delay (ms)", 0, 200, Config.TriggerbotDelay, 10, CombatTab, function(val)
    Config.TriggerbotDelay = val
end)
TriggerbotAWBtn, TriggerbotAWBg, TriggerbotAWKnob = CreateFeatureRow("Trigger Autowall", 10.02, CombatTab)

WeaponAutoSwapBtn, WeaponAutoSwapBg, WeaponAutoSwapKnob = CreateFeatureRow("Weapon Auto Swap", 10.05, CombatTab)
CreateSliderRow("WAS Speed (ms)", 30, 1000, Config.WeaponAutoSwapSpeed or 150, 10.06, CombatTab, function(val)
    Config.WeaponAutoSwapSpeed = math.floor(val + 0.5)
end)
do
    Config.WeaponAutoSwapSlots = Config.WeaponAutoSwapSlots or {}
    local host = ResolveUIParent(CombatTab)

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = Theme.Card
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.LayoutOrder = 10.07
    row.Parent = host

    local div = Instance.new("Frame")
    div.Name = "RowDivider"
    div.Size = UDim2.new(1, -16, 0, 1)
    div.Position = UDim2.new(0, 8, 1, -1)
    div.BackgroundColor3 = Color3.fromRGB(55, 58, 70)
    div.BackgroundTransparency = 0.35
    div.BorderSizePixel = 0
    div.ZIndex = 2
    div.Parent = row

    local listLbl = Instance.new("TextLabel")
    listLbl.Size = UDim2.new(1, -120, 1, 0)
    listLbl.Position = UDim2.fromOffset(12, 0)
    listLbl.BackgroundTransparency = 1
    listLbl.TextXAlignment = Enum.TextXAlignment.Left
    listLbl.Font = SelectedFont
    listLbl.TextSize = 12
    listLbl.TextColor3 = Theme.Text
    listLbl.Parent = row
    Cache.WeaponAutoSwapListLbl = listLbl

    local function refreshListLbl()
        local slots = WeaponAutoSwap_NormalizeSlots and WeaponAutoSwap_NormalizeSlots() or (Config.WeaponAutoSwapSlots or {})
        if #slots == 0 then
            listLbl.Text = "Slots: (empty)"
        else
            listLbl.Text = "Slots: " .. table.concat(slots, ", ")
        end
    end
    Cache.RefreshWeaponAutoSwapList = refreshListLbl
    refreshListLbl()

    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.fromOffset(48, 24)
    addBtn.Position = UDim2.new(1, -108, 0.5, -12)
    addBtn.BackgroundColor3 = Theme.Accent
    addBtn.BorderSizePixel = 0
    addBtn.Text = "Add"
    addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addBtn.TextSize = 11
    addBtn.Font = SelectedFont
    addBtn.Parent = row
    pcall(function() TrackThemeAccent(addBtn, "BackgroundColor3") end)

    local clrBtn = Instance.new("TextButton")
    clrBtn.Size = UDim2.fromOffset(48, 24)
    clrBtn.Position = UDim2.new(1, -54, 0.5, -12)
    clrBtn.BackgroundColor3 = Theme.BgTertiary
    clrBtn.BorderSizePixel = 0
    clrBtn.Text = "Clear"
    clrBtn.TextColor3 = Theme.Text
    clrBtn.TextSize = 11
    clrBtn.Font = SelectedFont
    clrBtn.Parent = row

    local pickRow = Instance.new("Frame")
    pickRow.Size = UDim2.new(1, 0, 0, 34)
    pickRow.BackgroundColor3 = Theme.Card
    pickRow.BackgroundTransparency = 1
    pickRow.BorderSizePixel = 0
    pickRow.LayoutOrder = 10.075
    pickRow.Parent = host

    local div2 = Instance.new("Frame")
    div2.Name = "RowDivider"
    div2.Size = UDim2.new(1, -16, 0, 1)
    div2.Position = UDim2.new(0, 8, 1, -1)
    div2.BackgroundColor3 = Color3.fromRGB(55, 58, 70)
    div2.BackgroundTransparency = 0.35
    div2.BorderSizePixel = 0
    div2.ZIndex = 2
    div2.Parent = pickRow

    local pickLbl = Instance.new("TextLabel")
    pickLbl.Size = UDim2.new(0.55, 0, 1, 0)
    pickLbl.Position = UDim2.fromOffset(12, 0)
    pickLbl.BackgroundTransparency = 1
    pickLbl.Text = "Type number (1-9)"
    pickLbl.TextColor3 = Theme.Text
    pickLbl.TextSize = 12
    pickLbl.Font = SelectedFont
    pickLbl.TextXAlignment = Enum.TextXAlignment.Left
    pickLbl.Parent = pickRow

    local numBox = Instance.new("TextBox")
    numBox.Size = UDim2.fromOffset(56, 24)
    numBox.Position = UDim2.new(1, -68, 0.5, -12)
    numBox.BackgroundColor3 = Theme.BgTertiary
    numBox.BorderSizePixel = 0
    numBox.Text = ""
    numBox.PlaceholderText = "#"
    numBox.TextColor3 = Theme.Accent
    numBox.PlaceholderColor3 = Theme.TextDim
    numBox.TextSize = 13
    numBox.Font = SelectedFont
    numBox.ClearTextOnFocus = false
    numBox.Parent = pickRow
    pcall(function() TrackThemeAccent(numBox, "TextColor3") end)
    Cache.WeaponAutoSwapNumBox = numBox

    numBox:GetPropertyChangedSignal("Text"):Connect(function()
        local t = numBox.Text:gsub("%D", "")
        if #t > 1 then t = t:sub(1, 1) end
        if t ~= "" then
            local n = tonumber(t)
            if not n or n < 1 or n > 9 then t = "" end
        end
        if numBox.Text ~= t then numBox.Text = t end
    end)

    local function tryAdd()
        local n = math.floor(tonumber(numBox.Text) or 0)
        if n < 1 or n > 9 then
            Notify("Weapon Auto Swap", "Enter 1-9")
            return
        end
        Config.WeaponAutoSwapSlots = Config.WeaponAutoSwapSlots or {}
        if #Config.WeaponAutoSwapSlots >= 9 then
            Notify("Weapon Auto Swap", "Max 9 slots")
            return
        end
        table.insert(Config.WeaponAutoSwapSlots, n)
        numBox.Text = ""
        refreshListLbl()
        Notify("Weapon Auto Swap", "Added " .. tostring(n))
    end

    addBtn.MouseButton1Click:Connect(tryAdd)
    numBox.FocusLost:Connect(function(enter)
        if enter then tryAdd() end
    end)
    clrBtn.MouseButton1Click:Connect(function()
        Config.WeaponAutoSwapSlots = {}
        refreshListLbl()
        Notify("Weapon Auto Swap", "Cleared")
    end)
end

CreateSectionHeader("- Silent Aim -", 10.8, CombatTab)
SilentV2Btn, SilentV2Bg, SilentV2Knob = CreateFeatureRow("Silent Aim", 10.81, CombatTab)
SilentV2FovBtn, SilentV2FovBg, SilentV2FovKnob = CreateFeatureRow("Show Silent FOV", 10.82, CombatTab, "Color_SilentV2Fov")
SilentV2FovFillBtn, SilentV2FovFillBg, SilentV2FovFillKnob = CreateFeatureRow("Silent FOV Fill", 10.825, CombatTab, "Color_SilentV2FovFill")
CreateSliderRow("Silent Fill Transparency", 0, 100, math.floor((Config.SilentV2FovFillTransparency or 0.7) * 100), 10.828, CombatTab, function(val)
    Config.SilentV2FovFillTransparency = val / 100
    if Cache.SilentV2FovCircleFill then Cache.SilentV2FovCircleFill.Transparency = Config.SilentV2FovFillTransparency end
end)
SilentV2FovPulseBtn, SilentV2FovPulseBg, SilentV2FovPulseKnob = CreateFeatureRow("Silent FOV Pulse", 10.829, CombatTab)
CreateSliderRow("Silent FOV", 20, 500, Config.SilentV2Fov or 140, 10.83, CombatTab, function(val)
    Config.SilentV2Fov = val
    if Cache.SilentV2FovCircle then Cache.SilentV2FovCircle.Radius = val end
    if Cache.SilentV2FovCircleFill then Cache.SilentV2FovCircleFill.Radius = val end
end)
SilentFovDynBtn, SilentFovDynBg, SilentFovDynKnob = CreateFeatureRow("Silent FOV Dynamic", 10.832, CombatTab)
CreateSliderRow("Silent Dynamic Expand", 0, 150, math.floor(tonumber(Config.SilentV2FovDynamicExpand) or 40), 10.833, CombatTab, function(val)
    Config.SilentV2FovDynamicExpand = math.floor(val + 0.5)
end)
CreateSliderRow("Silent Hit Chance", 1, 100, Config.SilentV2HitChance or 100, 10.84, CombatTab, function(val)
    Config.SilentV2HitChance = val
end)
Cache.RefreshSilentV2PartList = CreateBodyPartList("Silent Hit Part", 10.845, function()
    return Config.SilentV2TargetPart or "Head"
end, function(v) Config.SilentV2TargetPart = v end, CombatTab)
SilentV2MultiBtn, SilentV2MultiBg, SilentV2MultiKnob = CreateFeatureRow("Silent Multipoint", 10.848, CombatTab)

do
    local parts = { "Head", "UpperTorso", "Torso", "HumanoidRootPart", "LowerTorso" }
    local Expanded = false
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "SilentMultipointHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.LayoutOrder = 10.849
    HeaderRow.Parent = ResolveUIParent(CombatTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Multipoint Parts"
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.MultipointHeaderLbl = HeaderLbl
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "SilentMultipointList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.LayoutOrder = 10.8491
    ListFrame.Parent = ResolveUIParent(CombatTab)
    pcall(AnxiumListFrameStroke, ListFrame)
    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    local lay = Instance.new("UIListLayout")
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 3)
    lay.Parent = ListScroll
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)
    pad.Parent = ListScroll
    Cache.MultipointButtons = {}
    local function RefreshHighlight()
        if type(Config.SilentV2Multipoint) ~= "table" then
            Config.SilentV2Multipoint = {}
        end
        for name, b in pairs(Cache.MultipointButtons) do
            if b and b.Parent then
                local on = Config.SilentV2Multipoint[name] == true
                b.Text = "  " .. name
                if on then
                    b.BackgroundColor3 = Theme.Accent
                    b.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    b.BackgroundColor3 = Theme.BgTertiary
                    b.TextColor3 = Theme.Text
                end
            end
        end
    end
    Cache.RefreshMultipointList = RefreshHighlight
    for i, partName in ipairs(parts) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 28)
        b.BackgroundColor3 = Theme.BgTertiary
        b.BorderSizePixel = 0
        b.Text = "  " .. partName
        b.TextColor3 = Theme.Text
        b.TextSize = 12
        b.Font = SelectedFont
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.LayoutOrder = i
        b.Parent = ListScroll
        Cache.MultipointButtons[partName] = b
        b.MouseButton1Click:Connect(function()
            if type(Config.SilentV2Multipoint) ~= "table" then
                Config.SilentV2Multipoint = {}
            end
            Config.SilentV2Multipoint[partName] = not (Config.SilentV2Multipoint[partName] == true)
            RefreshHighlight()
            Notify("Silent Aim", partName)
        end)
    end
    RefreshHighlight()
    local listH = 28 * #parts + 16
    HeaderRow.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        if Expanded then
            AnxiumSetListOpen(ListFrame, true, listH, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then
                ArrowLbl.Image = "rbxassetid://71457658246709"
                ArrowLbl.Rotation = 0
            else
                ArrowLbl.Text = "▲"
            end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then
                ArrowLbl.Image = "rbxassetid://98648581502859"
                ArrowLbl.Rotation = 0
            else
                ArrowLbl.Text = "▼"
            end
        end
    end)
end

SilentV2TeamBtn, SilentV2TeamBg, SilentV2TeamKnob = CreateFeatureRow("Silent Team Check", 10.85, CombatTab)
SilentV2VisBtn, SilentV2VisBg, SilentV2VisKnob = CreateFeatureRow("Silent Visible Check", 10.86, CombatTab)
SilentV2PredBtn, SilentV2PredBg, SilentV2PredKnob = CreateFeatureRow("Silent Prediction", 10.87, CombatTab)
CreateSliderRow("Silent Predict x100", 0, 30, math.floor((Config.SilentV2PredictionAmount or 0.12) * 100), 10.88, CombatTab, function(val)
    Config.SilentV2PredictionAmount = val / 100
end)
SilentV2StickyBtn, SilentV2StickyBg, SilentV2StickyKnob = CreateFeatureRow("Silent Sticky", 10.89, CombatTab)

CreateSectionHeader("- Kill Sounds -", 11, CombatTab)
FireSoundBtn, FireSoundBg, FireSoundKnob = CreateFeatureRow("Kill Sounds", 12, CombatTab)
CreateSliderRow("Hit Volume", 0, 100, math.floor(Config.CustomFireSoundVolume * 100), 13, CombatTab, function(val)
    Config.CustomFireSoundVolume = val / 100
    if Cache.FireSoundInstance then
        Cache.FireSoundInstance.Volume = Config.CustomFireSoundVolume
    end
end)

do
    local soundOptions = {
        "Gun Fire", "Hammer Hit", "Bow Ding", "Cod Hit", "Uwu",
        "Button", "Click", "Neverlose", "Standart", "Fatality", "Headshot",
        "Click1", "Agpa1", "Agpa2", "Camera1", "Bonk5", "Bubble3",
        "Hentai1", "Hentai2", "Hentai3", "Hentai4",
        "Odin Svinia", "Skeet",
    }

    
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "HitSoundListHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BackgroundTransparency = 0
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = 13.1
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = ResolveUIParent(CombatTab)

    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Sound List  ·  " .. tostring(Config.CustomFireSoundName or "Gun Fire")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.HitSoundHeaderLbl = HeaderLbl

    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    
    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "HitSoundList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BackgroundTransparency = 0
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = 13.2
    ListFrame.ClipsDescendants = true
    ListFrame.Visible = false
    ListFrame.Parent = ResolveUIParent(CombatTab)
    pcall(AnxiumListFrameStroke, ListFrame)

    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 3)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ListScroll

    local ListPad = Instance.new("UIPadding")
    ListPad.PaddingTop = UDim.new(0, 4)
    ListPad.PaddingBottom = UDim.new(0, 4)
    ListPad.PaddingLeft = UDim.new(0, 4)
    ListPad.PaddingRight = UDim.new(0, 4)
    ListPad.Parent = ListScroll

    Cache.HitSoundButtons = {}

    local function RefreshHitSoundHighlight()
        local cur = Config.CustomFireSoundName or "Gun Fire"
        if Cache.HitSoundHeaderLbl then
            Cache.HitSoundHeaderLbl.Text = "Sound List  ·  " .. tostring(cur)
        end
        for name, btn in pairs(Cache.HitSoundButtons) do
            if btn and btn.Parent then
                if name == cur then
                    btn.BackgroundColor3 = Theme.Accent
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    btn.BackgroundColor3 = Theme.BgTertiary
                    btn.TextColor3 = Theme.Text
                end
            end
        end
    end
    Cache.RefreshHitSoundHighlight = RefreshHitSoundHighlight

    for i, name in ipairs(soundOptions) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. name
        btn.TextColor3 = Theme.Text
        btn.TextSize = 12
        btn.Font = SelectedFont
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.Parent = ListScroll
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = btn
        end
        Cache.HitSoundButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            Config.CustomFireSoundName = name
            RefreshHitSoundHighlight()
            Notify("Kill Sounds", "Selected: " .. name)
            
            pcall(function()
                if PlayHitSounds then PlayHitSounds() end
            end)
        end)
    end
    RefreshHitSoundHighlight()

    local listOpen = false
    local LIST_H = math.min(8, #soundOptions) * 31 + 12
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
end

SpeedBtn, SpeedBg, SpeedKnob = CreateFeatureRow("Speed Hack", 1, MovementTab)
JumpBtn, JumpBg, JumpKnob = CreateFeatureRow("Double Jump", 2, MovementTab)
AutoJumpBtn, AutoJumpBg, AutoJumpKnob = CreateFeatureRow("Auto Jump", 2.1, MovementTab)
NoclipBtn, NoclipBg, NoclipKnob = CreateFeatureRow("Noclip", 3, MovementTab)
FlyBtn, FlyBg, FlyKnob = CreateFeatureRow("Fly", 4, MovementTab)
CreateSliderRow("Fly Speed", 1, 300, Config.FlySpeedValue or 50, 4.1, MovementTab, function(val)
    Config.FlySpeedValue = val
end)
BHopBtn, BHopBg, BHopKnob = CreateFeatureRow("Bunny Hop", 5, MovementTab)
CreateSliderRow("BHop Force", 10, 150, Config.BHopPower, 6, MovementTab, function(val) Config.BHopPower = val end)
StrafeBtn, StrafeBg, StrafeKnob = CreateFeatureRow("Strafe", 7, MovementTab)
CreateSliderRow("Strafe Speed", 8, 80, Config.StrafeSpeed or 22, 8, MovementTab, function(val)
    Config.StrafeSpeed = val
end)
do
    local modes = { "Hybrid", "Velocity", "CFrame" }
    local Expanded = false
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "StrafeModeListHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.LayoutOrder = 9
    HeaderRow.Parent = ResolveUIParent(MovementTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Strafe Mode  ·  " .. tostring(Config.StrafeMode or "Hybrid")
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.StrafeModeHeaderLbl = HeaderLbl
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "StrafeModeList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.LayoutOrder = 9.01
    ListFrame.Parent = ResolveUIParent(MovementTab)
    AnxiumListFrameStroke(ListFrame)
    local listLay = Instance.new("UIListLayout")
    listLay.SortOrder = Enum.SortOrder.LayoutOrder
    listLay.Padding = UDim.new(0, 2)
    listLay.Parent = ListFrame
    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 4)
    listPad.PaddingBottom = UDim.new(0, 4)
    listPad.PaddingLeft = UDim.new(0, 4)
    listPad.PaddingRight = UDim.new(0, 4)
    listPad.Parent = ListFrame

    local function refreshHighlight()
        local cur = Config.StrafeMode or "Hybrid"
        for _, ch in ipairs(ListFrame:GetChildren()) do
            if ch:IsA("TextButton") then
                local name = ch:GetAttribute("ModeName") or ch.Text:gsub("^%s+", "")
                if name == cur then
                    ch.BackgroundColor3 = Theme.Accent or Color3.fromRGB(180, 140, 255)
                    ch.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    ch.BackgroundColor3 = Theme.BgTertiary
                    ch.TextColor3 = Theme.Text
                end
            end
        end
        HeaderLbl.Text = "Strafe Mode  ·  " .. tostring(cur)
    end

    for i, modeName in ipairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. modeName
        btn.TextColor3 = Theme.Text
        btn.TextSize = 13
        btn.Font = SelectedFont
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = i
        btn.AutoButtonColor = true
        btn:SetAttribute("ModeName", modeName)
        btn.Parent = ListFrame
        btn.MouseButton1Click:Connect(function()
            Config.StrafeMode = modeName
            refreshHighlight()
            Notify("Strafe", "Mode: " .. modeName)
        end)
    end
    refreshHighlight()

    HeaderRow.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        if Expanded then
            local h = #modes * 30 + 12
            AnxiumSetListOpen(ListFrame, true, h, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then
                ArrowLbl.Image = "rbxassetid://71457658246709"
                ArrowLbl.Rotation = 0
            end
        else
            AnxiumSetListOpen(ListFrame, false, nil, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then
                ArrowLbl.Image = "rbxassetid://98648581502859"
                ArrowLbl.Rotation = 0
            end
        end
    end)
    AnxiumSetListOpen(ListFrame, false, nil, HeaderRow)
end

AutoShiftBtn, AutoShiftBg, AutoShiftKnob = CreateFeatureRow("Auto Shift", 8.5, MovementTab)

CreateGroupPanel("Peek Assist", 8.65, MovementTab)
PeekAssistFillBtn, PeekAssistFillBg, PeekAssistFillKnob = CreateFeatureRow("Peek Assist Fill", 8.7, MovementTab)
do
    local ColorListScroll
    local function CreatePeekAssistColorRow(label, colorKey, defaultColor)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 30)
        Row.BackgroundColor3 = Theme.BgTertiary
        Row.BackgroundTransparency = 0
        Row.BorderSizePixel = 0
        Row.LayoutOrder = 1
        Row.Parent = ColorListScroll
        local rc = Instance.new("UICorner")
        rc.CornerRadius = UDim.new(0, 6)
        rc.Parent = Row

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, -52, 1, 0)
        Lbl.Position = UDim2.new(0, 12, 0, 0)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = label
        Lbl.TextColor3 = Theme.Text
        Lbl.TextSize = 12
        Lbl.Font = SelectedFont
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = Row

        local colBtn = Instance.new("TextButton")
        colBtn.Name = "ColorBtn"
        colBtn.Size = UDim2.new(0, 22, 0, 22)
        colBtn.Position = UDim2.new(1, -34, 0.5, -11)
        colBtn.BackgroundColor3 = Config[colorKey] or defaultColor or Theme.Accent
        colBtn.BorderSizePixel = 0
        colBtn.Text = ""
        colBtn.AutoButtonColor = false
        colBtn.Parent = Row



        colBtn.MouseButton1Click:Connect(function()
            if not OpenRGBPicker then return end
            OpenRGBPicker(Config[colorKey] or defaultColor or Theme.Accent, function(col)
                Config[colorKey] = col
                colBtn.BackgroundColor3 = col
            end, colBtn)
        end)

        Cache.ColorButtons = Cache.ColorButtons or {}
        Cache.ColorButtons[colorKey] = colBtn
        pcall(function() colBtn:SetAttribute("AnxiumColorKey", colorKey) end)

        if colorKey == "Color_PeekAssist" then
            PeekAssistStartColorBtn = colBtn
        elseif colorKey == "Color_PeekAssistShot" then
            PeekAssistShotColorBtn = colBtn
        end
    end

    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "PeekAssistColorListHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BackgroundTransparency = 0
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = 8.71
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = ResolveUIParent(MovementTab)

    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Colors"
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow

    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "PeekAssistColorList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BackgroundTransparency = 0
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = 8.72
    ListFrame.ClipsDescendants = true
    ListFrame.Parent = ResolveUIParent(MovementTab)
    pcall(AnxiumListFrameStroke, ListFrame)

    ColorListScroll = Instance.new("ScrollingFrame")
    ColorListScroll.Size = UDim2.new(1, -8, 1, -8)
    ColorListScroll.Position = UDim2.new(0, 4, 0, 4)
    ColorListScroll.BackgroundTransparency = 1
    ColorListScroll.BorderSizePixel = 0
    ColorListScroll.ScrollBarThickness = 3
    ColorListScroll.ScrollBarImageColor3 = Theme.Accent
    ColorListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ColorListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ColorListScroll.Parent = ListFrame

    local ColorListLayout = Instance.new("UIListLayout")
    ColorListLayout.Padding = UDim.new(0, 3)
    ColorListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ColorListLayout.Parent = ColorListScroll

    local ColorListPad = Instance.new("UIPadding")
    ColorListPad.PaddingTop = UDim.new(0, 4)
    ColorListPad.PaddingBottom = UDim.new(0, 4)
    ColorListPad.PaddingLeft = UDim.new(0, 4)
    ColorListPad.PaddingRight = UDim.new(0, 4)
    ColorListPad.Parent = ColorListScroll

    CreatePeekAssistColorRow("Start Position Color", "Color_PeekAssist", Theme.Accent)
    CreatePeekAssistColorRow("Shot Effect Color", "Color_PeekAssistShot", Color3.fromRGB(255, 100, 160))

    local listOpen = false
    local LIST_H = 2 * 33 + 12
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
end
CreateSliderRow("Peek Radius", 1, 12, Config.PeekAssistRadius or 5, 8.73, MovementTab, function(val)
    Config.PeekAssistRadius = val
end)
CreateSliderRow("Effect Duration (ms)", 100, 2000, math.floor(tonumber(Config.PeekAssistDurationMs) or 700), 8.74, MovementTab, function(val)
    Config.PeekAssistDurationMs = math.floor(val + 0.5)
end)
CreateSliderRow("Return Delay (ms)", 0, 2000, math.floor(tonumber(Config.PeekAssistReturnDelayMs) or 0), 8.75, MovementTab, function(val)
    Config.PeekAssistReturnDelayMs = math.floor(val + 0.5)
end)
CreateSliderRow("Effect Transparency", 0, 100, math.floor((tonumber(Config.PeekAssistTransparency) or 0.28) * 100), 8.76, MovementTab, function(val)
    Config.PeekAssistTransparency = val / 100
end)
CreateSliderRow("Effect Thickness", 0.05, 0.6, Config.PeekAssistThickness or 0.18, 8.77, MovementTab, function(val)
    Config.PeekAssistThickness = val
end)
CreateSliderRow("Effect Segments", 16, 80, math.floor(tonumber(Config.PeekAssistSegments) or 48), 8.78, MovementTab, function(val)
    Config.PeekAssistSegments = math.floor(val + 0.5)
end)
do
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0.96, 0, 0, 34)
    Row.BackgroundColor3 = Theme.Card
    Row.BorderSizePixel = 0
    Row.LayoutOrder = 8.79
    Row.Parent = ResolveUIParent(MovementTab)
    local Rc = Instance.new("UICorner")
    Rc.CornerRadius = UDim.new(0, 8)
    Rc.Parent = Row
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -20, 1, 0)
    Lbl.Position = UDim2.fromOffset(12, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = "Peek Assist bind → Settings / Binds"
    Lbl.TextColor3 = Theme.TextDim
    Lbl.TextSize = 11
    Lbl.Font = SelectedFont
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Row
end

CreateGroupPanel("Fake Lag", 9.5, MovementTab)
FakeLagBtn, FakeLagBg, FakeLagKnob = CreateFeatureRow("Fake Lag", 10, MovementTab)
FakeLagRandBtn, FakeLagRandBg, FakeLagRandKnob = CreateFeatureRow("FL Randomize", 11, MovementTab)
CreateSliderRow("FL Jitter", 0, 100, Config.FakeLagJitter or 15, 12, MovementTab, function(val)
    Config.FakeLagJitter = val
end)
CreateSliderRow("FL Anchor Time", 1, 200, Config.FakeLagAnchorTime or 50, 13, MovementTab, function(val)
    Config.FakeLagAnchorTime = val
end)
CreateSliderRow("FL Unanchor Time", 1, 200, Config.FakeLagUnanchorTime or 35, 14, MovementTab, function(val)
    Config.FakeLagUnanchorTime = val
end)
CreateSliderRow("FL Pause", 0, 300, Config.FakeLagPause or 100, 15, MovementTab, function(val)
    Config.FakeLagPause = val
end)


AnxiumAnimPacks = {
    Astronaut = {Idle=891621366, Idle2=891633237, Idle3=1047759695, Walk=891667138, Run=891636393, Jump=891627522, Climb=891609353, Fall=891617961, Swim=891639666, SwimIdle=891663592, Weight=9, Weight2=1},
    Bold = {Idle=16738333868, Idle2=16738334710, Idle3=16738335517, Walk=16738340646, Run=16738337225, Jump=16738336650, Climb=16738332169, Fall=16738333171, Swim=16738339158, SwimIdle=16738339817, Weight=9, Weight2=1},
    Borock = {Idle=3293641938, Idle2=3293642554, Idle3=3710131919, Walk=2510202577, Run=3236836670, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
    Bubbly = {Idle=910004836, Idle2=910009958, Idle3=1018536639, Walk=910034870, Run=910025107, Jump=910016857, Climb=909997997, Fall=910001910, Swim=910028158, SwimIdle=910030921, Weight=9, Weight2=1},
    Cartoony = {Idle=742637544, Idle2=742638445, Idle3=885477856, Walk=742640026, Run=742638842, Jump=742637942, Climb=742636889, Fall=742637151, Swim=742639220, SwimIdle=742639812, Weight=9, Weight2=1},
    Confident = {Idle=1069977950, Idle2=1069987858, Idle3=1116160740, Walk=1070017263, Run=1070001516, Jump=1069984524, Climb=1069946257, Fall=1069973677, Swim=1070009914, SwimIdle=1070012133, Weight=9, Weight2=1},
    Cowboy = {Idle=1014390418, Idle2=1014398616, Idle3=1159487651, Walk=1014421541, Run=1014401683, Jump=1014394726, Climb=1014380606, Fall=1014384571, Swim=1014406523, SwimIdle=1014411816, Weight=9, Weight2=1},
    Elder = {Idle=845397899, Idle2=845400520, Idle3=901160519, Walk=845403856, Run=845386501, Jump=845398858, Climb=845392038, Fall=845396048, Swim=845401742, SwimIdle=845403127, Weight=9, Weight2=1},
    Ghost = {Idle=616006778, Idle2=616008087, Idle3=616008087, Walk=616013216, Run=616013216, Jump=616008936, Climb=0, Fall=616005863, Swim=616011509, SwimIdle=616012453, Weight=9, Weight2=1},
    Knight = {Idle=657595757, Idle2=657568135, Idle3=885499184, Walk=657552124, Run=657564596, Jump=658409194, Climb=658360781, Fall=657600338, Swim=657560551, SwimIdle=657557095, Weight=9, Weight2=1},
    Levitation = {Idle=616006778, Idle2=616008087, Idle3=886862142, Walk=616013216, Run=616010382, Jump=616008936, Climb=616003713, Fall=616005863, Swim=616011509, SwimIdle=616012453, Weight=9, Weight2=1},
    Mage = {Idle=707742142, Idle2=707855907, Idle3=885508740, Walk=707897309, Run=707861613, Jump=707853694, Climb=707826056, Fall=707829716, Swim=707876443, SwimIdle=707894699, Weight=9, Weight2=1},
    Mocap = {Idle=913367814, Idle2=913373430, Walk=913402848, Run=913376220, Jump=913370268, Climb=913362637, Fall=913365531, Swim=913384386, SwimIdle=913389285, Weight=9, Weight2=1},
    Ninja = {Idle=656117400, Idle2=656118341, Idle3=886742569, Walk=656121766, Run=656118852, Jump=656117878, Climb=656114359, Fall=656115606, Swim=656119721, SwimIdle=656121397, Weight=9, Weight2=1},
    Oldschool = {Idle=5319828216, Idle2=5319831086, Idle3=5392107832, Walk=5319847204, Run=5319844329, Jump=5319841935, Climb=5319816685, Fall=5319839762, Swim=5319850266, SwimIdle=5319852613, Weight=9, Weight2=1},
    Patrol = {Idle=1149612882, Idle2=1150842221, Idle3=1159573567, Walk=1151231493, Run=1150967949, Jump=1150944216, Climb=1148811837, Fall=1148863382, Swim=1151204998, SwimIdle=1151221899, Weight=9, Weight2=1},
    Pirate = {Idle=750781874, Idle2=750782770, Idle3=885515365, Walk=750785693, Run=750783738, Jump=750782230, Climb=750779899, Fall=750780242, Swim=750784579, SwimIdle=750785176, Weight=9, Weight2=1},
    Popstar = {Idle=1212900985, Idle2=1150842221, Idle3=1239733474, Walk=1212980338, Run=1212980348, Jump=1212954642, Climb=1213044953, Fall=1212900995, Swim=1212852603, SwimIdle=1070012133, Weight=9, Weight2=1},
    Princess = {Idle=941003647, Idle2=941013098, Idle3=1159195712, Walk=941028902, Run=941015281, Jump=941008832, Climb=940996062, Fall=941000007, Swim=941018893, SwimIdle=941025398, Weight=9, Weight2=1},
    R15 = {Idle=4211217646, Idle2=4211218409, Walk=4211223236, Run=4211220381, Jump=4211219390, Climb=4211214992, Fall=4211216152, Swim=4211221314, SwimIdle=4374694239, Weight=9, Weight2=1},
    Realistic = {Idle=17172918855, Idle2=17173014241, Idle3=17173014241, Walk=11600249883, Run=11600211410, Jump=11600210487, Climb=11600205519, Fall=11600206437, Swim=11600212676, SwimIdle=11600213505, Weight=9, Weight2=1},
    Robot = {Idle=616088211, Idle2=616089559, Idle3=885531463, Walk=616095330, Run=616091570, Jump=616090535, Climb=616086039, Fall=616087089, Swim=616092998, SwimIdle=616094091, Weight=9, Weight2=1},
    Rthro = {Idle=2510196951, Idle2=2510197257, Idle3=3711062489, Walk=2510202577, Run=2510198475, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
    Sneaky = {Idle=1132473842, Idle2=1132477671, Walk=1132510133, Run=1132494274, Jump=1132489853, Climb=1132461372, Fall=1132469004, Swim=1132500520, SwimIdle=1132506407, Weight=9, Weight2=1},
    Stylish = {Idle=616136790, Idle2=616138447, Idle3=886888594, Walk=616146177, Run=616140816, Jump=616139451, Climb=616133594, Fall=616134815, Swim=616143378, SwimIdle=616144772, Weight=9, Weight2=1},
    Superhero = {Idle=616111295, Idle2=616113536, Idle3=885535855, Walk=616122287, Run=616117076, Jump=616115533, Climb=616104706, Fall=616108001, Swim=616119360, SwimIdle=616120861, Weight=9, Weight2=1},
    Toy = {Idle=782841498, Idle2=782845736, Idle3=980952228, Walk=782843345, Run=782842708, Jump=782847020, Climb=782843869, Fall=782846423, Swim=782844582, SwimIdle=782845186, Weight=9, Weight2=1},
    Udzal = {Idle=3303162274, Idle2=3303162549, Idle3=3710161342, Walk=3303162967, Run=3236836670, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
    Unboxed = {Idle=98281136301627, Idle2=138183121662404, Idle3=133117300343405, Walk=90478085024465, Run=134824450619865, Jump=121454505477205, Climb=121145883950231, Fall=94788218468396, Swim=105962919001086, SwimIdle=129126268464847, Weight=9, Weight2=1},
    Vampire = {Idle=1083445855, Idle2=1083450166, Idle3=1088037547, Walk=1083473930, Run=1083462077, Jump=1083455352, Climb=1083439238, Fall=1083443587, Swim=1083464683, SwimIdle=1083467779, Weight=9, Weight2=1},
    Werewolf = {Idle=1083195517, Idle2=1083214717, Idle3=1099492820, Walk=1083178339, Run=1083216690, Jump=1083218792, Climb=1083182000, Fall=1083189019, Swim=1083222527, SwimIdle=1083225406, Weight=9, Weight2=1},
    Zombie = {Idle=616158929, Idle2=616160636, Idle3=885545458, Walk=616168032, Run=616163682, Jump=616161997, Climb=616156119, Fall=616157476, Swim=616165109, SwimIdle=616166655, Weight=9, Weight2=1},
}

AnxiumAnimList = {}
for name in pairs(AnxiumAnimPacks) do
    table.insert(AnxiumAnimList, name)
end
table.sort(AnxiumAnimList, function(a, b) return a:lower() < b:lower() end)
table.insert(AnxiumAnimList, 1, "Default")

ANIM_URL = "http://www.roblox.com/asset/?id="

function Anxium_SaveOriginalAnims()
    local char = LocalPlayer.Character
    if not char then return end
    local Animate = char:FindFirstChild("Animate")
    if not Animate then return end
    if Cache.OriginalAnims then return end
    local ok, data = pcall(function()
        local o = {}
        if Animate:FindFirstChild("idle") then
            o.Idle = Animate.idle.Animation1 and Animate.idle.Animation1.AnimationId
            o.Idle2 = Animate.idle.Animation2 and Animate.idle.Animation2.AnimationId
            if Animate.idle.Animation1 and Animate.idle.Animation1:FindFirstChild("Weight") then
                o.Weight = Animate.idle.Animation1.Weight.Value
            end
            if Animate.idle.Animation2 and Animate.idle.Animation2:FindFirstChild("Weight") then
                o.Weight2 = Animate.idle.Animation2.Weight.Value
            end
        end
        if Animate:FindFirstChild("pose") then
            local a = Animate.pose:FindFirstChildOfClass("Animation")
            if a then o.Idle3 = a.AnimationId end
        end
        local function aid(folder)
            local a = folder and folder:FindFirstChildOfClass("Animation")
            return a and a.AnimationId
        end
        o.Walk = aid(Animate:FindFirstChild("walk"))
        o.Run = aid(Animate:FindFirstChild("run"))
        o.Jump = aid(Animate:FindFirstChild("jump"))
        o.Climb = aid(Animate:FindFirstChild("climb"))
        o.Fall = aid(Animate:FindFirstChild("fall"))
        o.Swim = aid(Animate:FindFirstChild("swim"))
        o.SwimIdle = aid(Animate:FindFirstChild("swimidle"))
        return o
    end)
    if ok and data then Cache.OriginalAnims = data end
end

function Anxium_RefreshAnims()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local Animate = char:FindFirstChild("Animate")
    if not hum or not Animate then return end
    pcall(function()
        Animate.Disabled = true
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            t:Stop()
        end
        Animate.Disabled = false
        local s = hum.WalkSpeed
        hum.WalkSpeed = 0
        task.wait()
        hum.WalkSpeed = s
    end)
end

function Anxium_SetAnimId(animObj, id)
    if not animObj or not id then return end
    local sid = tostring(id)
    if sid:find("rbxassetid://") or sid:find("http") then
        animObj.AnimationId = sid
    else
        animObj.AnimationId = ANIM_URL .. sid
    end
end

function Anxium_PlayAnimationBody(pack)
    local char = LocalPlayer.Character
    if not char then return false end
    local Animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 3)
    if not Animate then return false end
    Anxium_SaveOriginalAnims()

    local function applyIds(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10, weight, weight2)
        pcall(function()
            if Animate:FindFirstChild("idle") then
                if Animate.idle:FindFirstChild("Animation1") then
                    Anxium_SetAnimId(Animate.idle.Animation1, id1)
                    if Animate.idle.Animation1:FindFirstChild("Weight") and weight then
                        Animate.idle.Animation1.Weight.Value = tonumber(weight) or 9
                    end
                end
                if Animate.idle:FindFirstChild("Animation2") then
                    Anxium_SetAnimId(Animate.idle.Animation2, id2)
                    if Animate.idle.Animation2:FindFirstChild("Weight") and weight2 then
                        Animate.idle.Animation2.Weight.Value = tonumber(weight2) or 1
                    end
                end
            end
            if id3 and Animate:FindFirstChild("pose") then
                local a = Animate.pose:FindFirstChildOfClass("Animation")
                if a then Anxium_SetAnimId(a, id3) end
            end
            local map = {
                walk = id4, run = id5, jump = id6, climb = id7, fall = id8,
                swim = id9, swimidle = id10,
            }
            for folderName, id in pairs(map) do
                local folder = Animate:FindFirstChild(folderName)
                if folder and id then
                    local a = folder:FindFirstChildOfClass("Animation")
                    if a then Anxium_SetAnimId(a, id) end
                end
            end
        end)
    end

    if not pack or pack == "Default" then
        local o = Cache.OriginalAnims
        if o then
            applyIds(o.Idle, o.Idle2, o.Idle3, o.Walk, o.Run, o.Jump, o.Climb, o.Fall, o.Swim, o.SwimIdle, o.Weight, o.Weight2)
        end
    else
        local p = AnxiumAnimPacks[pack]
        if not p then return false end
        applyIds(p.Idle, p.Idle2, p.Idle3, p.Walk, p.Run, p.Jump, p.Climb, p.Fall, p.Swim, p.SwimIdle, p.Weight or 9, p.Weight2 or 1)
    end
    Anxium_RefreshAnims()
    return true
end

function Anxium_ApplySelectedPack()
    local name = Config.SelectedAnimPack or "Default"
    local ok = Anxium_PlayAnimationBody(name)
    if ok then
        Notify("Animations", "Pack: " .. tostring(name))
    else
        Notify("Animations", "Failed (need R15 Animate)")
    end
end


LocalPlayer.CharacterAdded:Connect(function(char)
    task.delay(1.0, function()
        Cache.OriginalAnims = nil 
        Anxium_SaveOriginalAnims()
        if Config.SelectedAnimPack and Config.SelectedAnimPack ~= "Default" then
            Anxium_PlayAnimationBody(Config.SelectedAnimPack)
        end
    end)
end)
if LocalPlayer.Character then
    task.defer(Anxium_SaveOriginalAnims)
end


do
    CreateSectionHeader("- Animation Packs (R15) -", 100, SettingsTab)

    
    local AnimExpanded = false
    local AnimHeaderRow = Instance.new("TextButton")
    AnimHeaderRow.Name = "AnimPackListHeader"
    AnimHeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    AnimHeaderRow.BackgroundColor3 = Theme.Card
    AnimHeaderRow.BorderSizePixel = 0
    AnimHeaderRow.LayoutOrder = 101
    AnimHeaderRow.AutoButtonColor = false
    AnimHeaderRow.Text = ""
    AnimHeaderRow.Parent = ResolveUIParent(SettingsTab)
    do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = AnimHeaderRow
    end
    local AnimHeaderLbl = Instance.new("TextLabel")
    AnimHeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    AnimHeaderLbl.Position = UDim2.new(0, 12, 0, 0)
    AnimHeaderLbl.BackgroundTransparency = 1
    AnimHeaderLbl.Text = "Animation List  ·  " .. tostring(Config.SelectedAnimPack or "Default")
    AnimHeaderLbl.TextColor3 = Theme.Text
    AnimHeaderLbl.TextSize = 12
    AnimHeaderLbl.Font = SelectedFont
    AnimHeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    AnimHeaderLbl.Parent = AnimHeaderRow
    Cache.AnimHeaderLbl = AnimHeaderLbl
    local AnimArrow = AnxiumMakeListArrow(AnimHeaderRow)
    pcall(function()
        AnimHeaderRow:SetAttribute("AnxiumSearchText", "animation packs anim list")
    end)

    local SelectedLbl = Instance.new("TextLabel")
    SelectedLbl.Size = UDim2.new(1, -20, 0, 22)
    SelectedLbl.BackgroundTransparency = 1
    SelectedLbl.LayoutOrder = 102
    SelectedLbl.Text = "Selected: " .. tostring(Config.SelectedAnimPack or "Default")
    SelectedLbl.TextColor3 = Theme.Accent
    SelectedLbl.TextSize = 12
    SelectedLbl.Font = SelectedFont
    SelectedLbl.TextXAlignment = Enum.TextXAlignment.Left
    SelectedLbl.Parent = ResolveUIParent(SettingsTab)
    SelectedLbl.Visible = false
    pcall(function()
        SelectedLbl:SetAttribute("AnxiumSearchText", "animation selected pack")
    end)
    Cache.AnimSelectedLabel = SelectedLbl
    pcall(function() TrackThemeAccent(SelectedLbl, "TextColor3") end)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "AnimPackList"
    ListFrame.Visible = false
    ListFrame.Size = UDim2.new(1, -20, 0, 320)
    ListFrame.BackgroundColor3 = Theme.BgSecondary
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = 103
    ListFrame.ClipsDescendants = true
    ListFrame.Parent = ResolveUIParent(SettingsTab)
    pcall(AnxiumListFrameStroke, ListFrame)

    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 4
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 4)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ListScroll

    local ListPad = Instance.new("UIPadding")
    ListPad.PaddingTop = UDim.new(0, 4)
    ListPad.PaddingBottom = UDim.new(0, 4)
    ListPad.PaddingLeft = UDim.new(0, 4)
    ListPad.PaddingRight = UDim.new(0, 4)
    ListPad.Parent = ListScroll

    Cache.AnimPackButtons = {}

    local function RefreshAnimPackHighlight()
        local cur = Config.SelectedAnimPack or "Default"
        for name, btn in pairs(Cache.AnimPackButtons) do
            if btn and btn.Parent then
                if name == cur then
                    btn.BackgroundColor3 = Theme.Accent
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    btn.BackgroundColor3 = Theme.BgTertiary
                    btn.TextColor3 = Theme.Text
                end
            end
        end
        SelectedLbl.Text = "Selected: " .. tostring(cur)
    end

    for i, packName in ipairs(AnxiumAnimList) do
        local btn = Instance.new("TextButton")
        btn.Name = "Pack_" .. packName
        btn.Size = UDim2.new(1, -4, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. packName
        btn.TextColor3 = Theme.Text
        btn.TextSize = 13
        btn.Font = SelectedFont
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = i
        btn.AutoButtonColor = true
        btn.Parent = ListScroll
        Cache.AnimPackButtons[packName] = btn
        btn.MouseButton1Click:Connect(function()
            Config.SelectedAnimPack = packName
            Config.AnimPackIndex = i
            RefreshAnimPackHighlight()
            Anxium_PlayAnimationBody(packName)
            Notify("Animations", "Pack: " .. packName)
        end)
    end
    RefreshAnimPackHighlight()

    local Hint = Instance.new("TextLabel")
    Hint.Size = UDim2.new(1, -20, 0, 28)
    Hint.BackgroundTransparency = 1
    Hint.LayoutOrder = 104
    Hint.Text = "Click a pack to apply (R15). Default = original."
    Hint.TextColor3 = Theme.TextDim
    Hint.TextSize = 11
    Hint.Font = SelectedFont
    Hint.TextXAlignment = Enum.TextXAlignment.Left
    Hint.TextWrapped = true
    Hint.Visible = false
    Hint.Parent = ResolveUIParent(SettingsTab)
    pcall(function()
        Hint:SetAttribute("AnxiumSearchText", "animation packs hint")
        ListFrame:SetAttribute("AnxiumSearchText", "animation packs list")
    end)

    
    local animListH = 220
    AnimHeaderRow.MouseButton1Click:Connect(function()
        AnimExpanded = not AnimExpanded
        if SelectedLbl then SelectedLbl.Visible = AnimExpanded end
        if AnimArrow and AnimArrow:IsA("ImageLabel") then
            AnimArrow.Image = AnimExpanded and "rbxassetid://71457658246709" or "rbxassetid://98648581502859"
            AnimArrow.Rotation = 0
        end
        if AnimExpanded then
            pcall(AnxiumSetListOpen, ListFrame, true, animListH, AnimHeaderRow)
        else
            pcall(AnxiumSetListOpen, ListFrame, false)
        end
    end)

    
    local _oldRefresh = RefreshAnimPackHighlight
    RefreshAnimPackHighlight = function()
        if _oldRefresh then _oldRefresh() end
        if Cache.AnimHeaderLbl then
            Cache.AnimHeaderLbl.Text = "Animation List  ·  " .. tostring(Config.SelectedAnimPack or "Default")
        end
    end
end


ColorRow = Instance.new("Frame")
ColorRow.Size = UDim2.new(0.96, 0, 0, 40)
ColorRow.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
ColorRow.BackgroundTransparency = 0.15
ColorRow.BorderSizePixel = 0
ColorRow.LayoutOrder = 37
ColorRow.Parent = SettingsTab

ColorTitle = Instance.new("TextLabel")
ColorTitle.Size = UDim2.new(0.7, 0, 1, 0)
ColorTitle.Position = UDim2.new(0, 12, 0, 0)
ColorTitle.BackgroundTransparency = 1
ColorTitle.Text = "Theme Color"
ColorTitle.TextColor3 = Theme.Text
ColorTitle.TextSize = 12
ColorTitle.Font = SelectedFont
ColorTitle.TextXAlignment = Enum.TextXAlignment.Left
ColorTitle.Parent = ColorRow

ColorPickerBtn = Instance.new("TextButton")
ColorPickerBtn.Size = UDim2.new(0, 20, 0, 20)
ColorPickerBtn.Position = UDim2.new(1, -34, 0.5, -10)
ColorPickerBtn.BackgroundColor3 = Theme.Accent
ColorPickerBtn.BorderSizePixel = 0
ColorPickerBtn.Text = ""
ColorPickerBtn.AutoButtonColor = false
ColorPickerBtn.Parent = ColorRow


function ApplyAccentColor(color)
    if typeof(color) ~= "Color3" then return end
    Theme.Accent = color
    Theme.ToggleOn = color
    pcall(function() ColorPickerBtn.BackgroundColor3 = color end)
    pcall(function()
        if WatermarkGrad and WatermarkGrad_FromTheme then
            WatermarkGrad.Color = WatermarkGrad_FromTheme()
        end
    end)

    
    pcall(function()
        if TitleLabel then TitleLabel.TextColor3 = Theme.Text end
        if AnxiumUpdateBrandLogo then AnxiumUpdateBrandLogo() end
        if VersionTag then VersionTag.TextColor3 = Theme.TextDim end
    end)
    pcall(function()
        if ToggleStroke then ToggleStroke.Color = Color3.fromRGB(55, 55, 65) end
        if ToggleButton then ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) end
    end)

    
    pcall(function()
        for _, btn in pairs(TabButtons or {}) do
            local accent = btn:FindFirstChild("ActiveAccent")
            if accent then
                accent.BackgroundColor3 = color
            end
        end
        if typeof(SwitchTab) == "function" and CurrentTab then
            SwitchTab(CurrentTab)
        end
    end)

    
    pcall(function()
        Cache.SectionLabels = Cache.SectionLabels or {}
        for _, lbl in ipairs(Cache.SectionLabels) do
            if lbl and lbl.Parent then
                lbl.TextColor3 = color
            end
        end
    end)

    
    pcall(function()
        for _, btn in pairs(TabButtons or {}) do
            local accent = btn:FindFirstChild("ActiveAccent")
            if accent then accent.BackgroundColor3 = color end
        end
    end)

    
    pcall(function()
        if RefreshAllSwitches then RefreshAllSwitches() end
        if RefreshAllColorButtons then pcall(RefreshAllColorButtons) end
        if RefreshAllSliders then pcall(RefreshAllSliders) end
        
        if Cache and Cache.FeatureUI then
            for key, ui in pairs(Cache.FeatureUI) do
                if ui and ui.bg and Config and Config[key] == true then
                    ui.bg.BackgroundColor3 = color
                end
            end
        end
    end)

    
    pcall(function()
        Cache.SliderFills = Cache.SliderFills or {}
        for _, fill in ipairs(Cache.SliderFills) do
            if fill and fill.Parent then
                fill.BackgroundColor3 = color
            end
        end
    end)

    
    pcall(function()
        for _, frame in pairs(TabFrames or {}) do
            if frame and frame:IsA("ScrollingFrame") then
                frame.ScrollBarImageColor3 = color
            end
        end
        if ActiveContainer then ActiveContainer.ScrollBarImageColor3 = color end
        if BindListContainer then BindListContainer.ScrollBarImageColor3 = color end
    end)

    pcall(function()
        if UpdateActiveList then UpdateActiveList() end
        if UpdateBindList then UpdateBindList() end
    end)

    
    pcall(function()
        Cache.ThemeAccentTracked = Cache.ThemeAccentTracked or {}
        for _, e in ipairs(Cache.ThemeAccentTracked) do
            local inst, prop = e.inst, e.prop or "TextColor3"
            if inst and inst.Parent then
                pcall(function()
                    if prop == "LuaCardBg" then
                        inst.BackgroundColor3 = LuaIO_CardColorFromAccent(color)
                    elseif prop == "BackgroundColor3" then
                        inst.BackgroundColor3 = color
                    elseif prop == "ImageColor3" then
                        inst.ImageColor3 = color
                    elseif prop == "Color" then
                        
                        inst.Color = color
                    elseif prop == "TextColor3" then
                        inst.TextColor3 = color
                    else
                        
                        if inst:IsA("UIStroke") then
                            inst.Color = color
                        elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
                            inst.ImageColor3 = color
                        elseif inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                            inst.TextColor3 = color
                        elseif inst:IsA("GuiObject") then
                            inst.BackgroundColor3 = color
                        end
                    end
                end)
            end
        end
    end)

    
    

    
    pcall(function()
        if Cache.RefreshHitSoundHighlight then Cache.RefreshHitSoundHighlight() end
    end)

    
    pcall(function()
        if Cache.AnimPackButtons then
            local cur = Config.SelectedAnimPack or "Default"
            for name, btn in pairs(Cache.AnimPackButtons) do
                if btn and btn.Parent then
                    if name == cur then
                        btn.BackgroundColor3 = color
                        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        btn.BackgroundColor3 = Theme.BgTertiary or Theme.Card
                        btn.TextColor3 = Theme.Text
                    end
                end
            end
        end
        if Cache.AnimSelectedLabel and Cache.AnimSelectedLabel.Parent then
            Cache.AnimSelectedLabel.TextColor3 = color
        end
    end)

    
    pcall(function()
        if MainFrame then
            for _, d in ipairs(MainFrame:GetDescendants()) do
                if d:IsA("TextButton") and (d.Name == "ApplyBtn" or d.Name == "SetBindBtn" or d.Name == "ConfigAction") then
                    d.BackgroundColor3 = color
                end
            end
        end
    end)

    Notify("Theme", "Theme color applied")
end

ColorPickerBtn.MouseButton1Click:Connect(function()
    OpenRGBPicker(Theme.Accent, function(col)
        ApplyAccentColor(col)
    end, ColorPickerBtn)
end)


CreateSectionHeader("- Menu -", 38, SettingsTab)


do
    local host = ResolveUIParent(SettingsTab)
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.LayoutOrder = 38.25
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.Parent = host
    local pretty = Config.MenuFont or "GothamBold"
    for _, e in ipairs(MENU_FONT_OPTIONS) do
        if e.id == pretty then pretty = e.name break end
    end
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.Size = UDim2.new(1, -40, 1, 0)
    HeaderLbl.Position = UDim2.fromOffset(12, 0)
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Text = "Menu Font  ·  " .. tostring(pretty)
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextSize = 12
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Parent = HeaderRow
    Cache.MenuFontHeaderLbl = HeaderLbl

    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "MenuFontList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.Card
    ListFrame.BorderSizePixel = 0
    ListFrame.LayoutOrder = 38.26
    ListFrame.ClipsDescendants = true
    ListFrame.Visible = false
    ListFrame.Parent = host
    pcall(AnxiumListFrameStroke, ListFrame)
    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, -8, 1, -8)
    ListScroll.Position = UDim2.new(0, 4, 0, 4)
    ListScroll.BackgroundTransparency = 1
    ListScroll.BorderSizePixel = 0
    ListScroll.ScrollBarThickness = 3
    ListScroll.ScrollBarImageColor3 = Theme.Accent
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListScroll.Parent = ListFrame
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 3)
    lay.Parent = ListScroll
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)
    pad.Parent = ListScroll

    local buttons = {}
    local function refreshFontList()
        local cur = Config.MenuFont or "GothamBold"
        for id, btn in pairs(buttons) do
            if id == cur then
                btn.BackgroundColor3 = Theme.Accent
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Theme.BgTertiary
                btn.TextColor3 = Theme.Text
            end
            
            pcall(function()
                local okF, f = pcall(function() return Enum.Font[id] end)
                btn.Font = (okF and f) or SelectedFont
            end)
        end
    end
    Cache.RefreshMenuFontList = refreshFontList
    Cache.MenuFontButtons = buttons

    for i, entry in ipairs(MENU_FONT_OPTIONS) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Theme.BgTertiary
        btn.BorderSizePixel = 0
        btn.Text = "  " .. entry.name
        btn.TextColor3 = Theme.Text
        btn.TextSize = 12
        local okF, f = pcall(function() return Enum.Font[entry.id] end)
        btn.Font = (okF and f) or SelectedFont
        pcall(function() btn:SetAttribute("AnxiumFontPreview", entry.id) end)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.Parent = ListScroll
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = btn
        end
        buttons[entry.id] = btn
        btn.MouseButton1Click:Connect(function()
            ApplyMenuFont(entry.id)
            refreshFontList()
            Notify("Menu Font", entry.name)
        end)
    end
    refreshFontList()
    pcall(function()
        if Config.MenuFont and Config.MenuFont ~= "GothamBold" then
            ApplyMenuFont(Config.MenuFont)
        end
    end)

    local listOpen = false
    local LIST_H = 220
    HeaderRow.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        pcall(function()
            for _, d in ipairs(ScreenGui:GetDescendants()) do
                if d.Name == "WatermarkPosList" and d.Visible then
                    AnxiumSetListOpen(d, false)
                end
            end
        end)
        if listOpen then
            AnxiumSetListOpen(ListFrame, true, LIST_H, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
end

do
    local positions = { "Left", "Center", "Right", "BottomLeft", "BottomCenter", "BottomRight" }
    local HeaderRow = Instance.new("TextButton")
    HeaderRow.Name = "WatermarkPosHeader"
    HeaderRow.Size = UDim2.new(0.96, 0, 0, 34)
    HeaderRow.BackgroundColor3 = Theme.Card
    HeaderRow.BorderSizePixel = 0
    HeaderRow.AutoButtonColor = false
    HeaderRow.Text = ""
    HeaderRow.LayoutOrder = 38.55
    HeaderRow.Parent = ResolveUIParent(SettingsTab)
    local HeaderLbl = Instance.new("TextLabel")
    HeaderLbl.BackgroundTransparency = 1
    HeaderLbl.Size = UDim2.new(1, -36, 1, 0)
    HeaderLbl.Position = UDim2.fromOffset(12, 0)
    HeaderLbl.Font = SelectedFont
    HeaderLbl.TextSize = 13
    HeaderLbl.TextColor3 = Theme.Text
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.Text = "Watermark Pos  ·  " .. tostring(Config.WatermarkPosition or "Center")
    Cache.WatermarkPosHeaderLbl = HeaderLbl
    HeaderLbl.Parent = HeaderRow
    Cache.WatermarkPosHeaderLbl = HeaderLbl
    local ArrowLbl = AnxiumMakeListArrow(HeaderRow)
    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "WatermarkPosList"
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Visible = false
    ListFrame.BackgroundColor3 = Theme.BgSecondary
    ListFrame.BorderSizePixel = 0
    ListFrame.ClipsDescendants = true
    ListFrame.LayoutOrder = 38.56
    ListFrame.Visible = false
    ListFrame.Size = UDim2.new(0.96, 0, 0, 0)
    ListFrame.Parent = ResolveUIParent(SettingsTab)
    pcall(AnxiumListFrameStroke, ListFrame)
    local listLay = Instance.new("UIListLayout")
    listLay.SortOrder = Enum.SortOrder.LayoutOrder
    listLay.Padding = UDim.new(0, 2)
    listLay.Parent = ListFrame
    local open = false
    Cache.WatermarkPosButtons = {}
    local function RefreshWmPosHighlight()
        local cur = Config.WatermarkPosition or "Center"
        if Cache.WatermarkPosHeaderLbl then
            Cache.WatermarkPosHeaderLbl.Text = "Watermark Pos  ·  " .. tostring(cur)
        end
        for name, btn in pairs(Cache.WatermarkPosButtons) do
            if btn then
                btn.BackgroundColor3 = (name == cur) and (Theme.AccentSoft or Theme.Accent) or Theme.Card
            end
        end
    end
    Cache.RefreshWmPosHighlight = RefreshWmPosHighlight
    Cache.RefreshWatermarkPosList = RefreshWmPosHighlight
    for i, name in ipairs(positions) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 28)
        btn.BackgroundColor3 = Theme.Card
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Font = SelectedFont
        btn.TextSize = 12
        btn.TextColor3 = Theme.Text
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Text = "  " .. name
        btn.LayoutOrder = i
        btn.Parent = ListFrame
        do
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = btn
        end
        Cache.WatermarkPosButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            Config.WatermarkPosition = name
            RefreshWmPosHighlight()
            if UpdateWatermarkPosition then UpdateWatermarkPosition() end
        end)
    end
    RefreshWmPosHighlight()
    HeaderRow.MouseButton1Click:Connect(function()
        open = not open
        pcall(function()
            for _, d in ipairs(ScreenGui:GetDescendants()) do
                if d.Name == "MenuFontList" or (d:IsA("Frame") and d.LayoutOrder == 38.26) then
                    if d.Visible and d ~= ListFrame then AnxiumSetListOpen(d, false) end
                end
            end
        end)
        if open then
            AnxiumSetListOpen(ListFrame, true, #positions * 30 + 6, HeaderRow)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://71457658246709"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▲" end
        else
            AnxiumSetListOpen(ListFrame, false)
            if ArrowLbl:IsA("ImageLabel") then ArrowLbl.Image = "rbxassetid://98648581502859"; ArrowLbl.Rotation = 0 else ArrowLbl.Text = "▼" end
        end
    end)
    AnxiumSetListOpen(ListFrame, false)
end
do
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 36)
    Row.BackgroundColor3 = Theme.Card
    Row.BackgroundTransparency = 1
    Row.BorderSizePixel = 0
    Row.LayoutOrder = 38.1
    Row.Parent = ResolveUIParent(SettingsTab)
    pcall(function()
        Row:SetAttribute("AnxiumSearchText", "menu key")
    end)
    local div = Instance.new("Frame")
    div.Name = "RowDivider"
    div.Size = UDim2.new(1, -8, 0, 1)
    div.Position = UDim2.new(0, 4, 1, -1)
    div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    div.BackgroundTransparency = 0.94
    div.BorderSizePixel = 0
    div.ZIndex = 2
    div.Parent = Row
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.45, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "Menu Key"
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = SelectedFont
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row
    local KeyLbl = Instance.new("TextLabel")
    KeyLbl.Size = UDim2.new(0, 70, 0, 22)
    KeyLbl.Position = UDim2.new(1, -150, 0.5, -11)
    KeyLbl.BackgroundTransparency = 1
    KeyLbl.BorderSizePixel = 0
    local mk = (Config.MenuKey and Config.MenuKey ~= "") and Config.MenuKey or "RightShift"
    KeyLbl.Text = "[" .. mk .. "]"
    KeyLbl.TextColor3 = Theme.TextDim
    KeyLbl.TextSize = 11
    KeyLbl.Font = SelectedFont
    KeyLbl.Parent = Row
    Cache.MenuKeyLabel = KeyLbl
    local SetBtn = Instance.new("TextButton")
    SetBtn.Size = UDim2.new(0, 44, 0, 22)
    SetBtn.Position = UDim2.new(1, -72, 0.5, -11)
    SetBtn.BackgroundColor3 = Theme.Accent
    pcall(function() TrackThemeAccent(SetBtn, "BackgroundColor3") end)
    SetBtn.BorderSizePixel = 0
    SetBtn.Text = "Set"
    SetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SetBtn.TextSize = 11
    SetBtn.Font = SelectedFont
    SetBtn.Parent = Row
    local ClrBtn = Instance.new("TextButton")
    ClrBtn.Size = UDim2.new(0, 22, 0, 22)
    ClrBtn.Position = UDim2.new(1, -24, 0.5, -11)
    ClrBtn.BackgroundColor3 = Theme.BgTertiary
    ClrBtn.BorderSizePixel = 0
    ClrBtn.Text = "x"
    ClrBtn.TextColor3 = Theme.Text
    ClrBtn.TextSize = 14
    ClrBtn.Font = SelectedFont
    ClrBtn.Parent = Row
    SetBtn.MouseButton1Click:Connect(function()
        Cache.WaitingMenuKey = true
        Cache.MenuKeyIgnoreUntil = tick() + 0.25
        if Cache.MenuKeyLabel then Cache.MenuKeyLabel.Text = "[...]" end
        Notify("Menu", "Press a key for menu open (Esc = cancel)")
    end)
    ClrBtn.MouseButton1Click:Connect(function()
        Config.MenuKey = "Insert"
        if Cache.MenuKeyLabel then Cache.MenuKeyLabel.Text = "[Insert]" end
        Notify("Menu", "Menu key reset to [Insert]")
    end)
end


CreateSectionHeader("- Keybinds -", 40, SettingsTab)
do
    local host = ResolveUIParent(SettingsTab)
    if host then
        local lay = host:FindFirstChildOfClass("UIListLayout")
        if lay then lay.Padding = UDim.new(0, 2) end
        local card = host.Parent
        if card then
            local clay = card:FindFirstChildOfClass("UIListLayout")
            if clay then clay.Padding = UDim.new(0, 2) end
        end
    end
end
BindListSettingsBtn, BindListSettingsBg, BindListSettingsKnob = CreateFeatureRow("Binds HUD", 41, SettingsTab)
do
    local searchRow = Instance.new("Frame")
    searchRow.Size = UDim2.new(1, 0, 0, 30)
    searchRow.BackgroundColor3 = Theme.Card
    searchRow.BorderSizePixel = 0
    searchRow.LayoutOrder = 41.5
    searchRow.Parent = ResolveUIParent(SettingsTab)
    local src = Instance.new("UICorner")
    src.CornerRadius = UDim.new(0, 8)
    src.Parent = searchRow
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "BindSearchBox"
    searchBox.Size = UDim2.new(1, -20, 1, -8)
    searchBox.Position = UDim2.new(0, 10, 0, 4)
    searchBox.BackgroundTransparency = 1
    searchBox.BorderSizePixel = 0
    searchBox.Font = SelectedFont
    searchBox.PlaceholderText = "Search binds..."
    searchBox.PlaceholderColor3 = Theme.TextDim
    searchBox.Text = ""
    searchBox.TextColor3 = Theme.Text
    searchBox.TextSize = 12
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchRow
    Cache.BindSearchBox = searchBox
    local function filterBinds()
        local q = string.lower(tostring(searchBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", ""))
        for _, e in ipairs(Cache.BindRows or {}) do
            if e.Row then
                if q == "" then
                    e.Row.Visible = true
                else
                    local name = e.Name or ""
                    local key = string.lower(tostring(e.Key or ""))
                    e.Row.Visible = (string.find(name, q, 1, true) ~= nil) or (string.find(key, q, 1, true) ~= nil)
                end
            end
        end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(filterBinds)
    Cache.FilterBindRows = filterBinds
end
local bindOrder = 42
BIND_SETTINGS_KEYS = {
    "AimEnabled", "SilentAimV2Enabled", "TriggerbotEnabled", "WeaponAutoSwapEnabled", "ShowFovEnabled", "SilentV2ShowFov",
    "BoxEspEnabled", "ChamsEnabled", "NameEspEnabled", "HealthbarEspEnabled", "SkeletonEnabled",
    "TracersEnabled", "CrosshairEnabled", "FullbrightEnabled", "FpsBoostEnabled", "ChinaHatEnabled",
    "SpeedHackEnabled", "FlyEnabled", "NoclipEnabled", "BHopEnabled", "MultiJumpEnabled", "AutoJumpEnabled", "AutoShiftEnabled", "StrafeEnabled", "PeekAssist",
    "ForceFieldEnabled", "WeaponForceFieldEnabled", "BulletTracersEnabled",
    "SpinEnabled", "AntiAimEnabled", "FakeLagEnabled", "TargetHudEnabled", "TargetLineEnabled", "FogEnabled", "TrailEnabled",
    "ThirdPersonEnabled", "AspectRatioEnabled", "FootstepsEnabled",
}
for _, fk in ipairs(BIND_SETTINGS_KEYS) do
    CreateBindRow(fk, bindOrder, SettingsTab)
    bindOrder = bindOrder + 1
end
BindListSettingsBtn.MouseButton1Click:Connect(function()
    Config.BindListEnabled = not Config.BindListEnabled
    UpdateSwitch(Config.BindListEnabled, BindListSettingsBg, BindListSettingsKnob, "Binds HUD")
    if BindListBg and BindListKnob then
        pcall(function() UpdateSwitch(Config.BindListEnabled, BindListBg, BindListKnob) end)
    end
    if UpdateBindList then UpdateBindList() end
end)


CfgIO = {
    
    Folder = "AnxiumHubConfigs",
    IndexFile = "AnxiumHubConfigs/_index.json",
    IndexFileAlt = "AnxiumHubConfigs_index.json",
    LastFile = "AnxiumHubConfigs/_last.txt",
    LastFileAlt = "AnxiumHubConfigs_last.txt",
    Marker = "__anxium_hub",
    Current = "default",
    List = {},
    Index = 1,
    NameBox = nil,
    ListFrame = nil,
    SelectBtn = nil,
    RowButtons = {},
}

function SanitizeConfigName(name)
    name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
    name = name:gsub("[^%w%-%_ ]", "")
    if name == "" then name = "default" end
    return name
end

function EnsureConfigFolder()
    if typeof(makefolder) == "function" then
        pcall(makefolder, CfgIO.Folder)
    end
end

function GetConfigPath(name)
    return CfgIO.Folder .. "/" .. SanitizeConfigName(name) .. ".json"
end

function SerializeConfig(overrideName)
    local cfgName = overrideName or CfgIO.Current or "default"
    if CfgIO.NameBox and type(CfgIO.NameBox.Text) == "string" and CfgIO.NameBox.Text ~= "" then
        cfgName = SanitizeConfigName(CfgIO.NameBox.Text)
    end
    local data = {
        [CfgIO.Marker] = true,
        version = 3,
        name = SanitizeConfigName(cfgName),
        Config = {},
        Accent = { R = Theme.Accent.R, G = Theme.Accent.G, B = Theme.Accent.B },
        CurrentColorIndex = Config.CurrentColorIndex
    }
    local function copyTable(t, depth)
        depth = depth or 0
        if depth > 4 then return nil end
        local out = {}
        for kk, vv in pairs(t) do
            local tk, tv = type(kk), typeof(vv)
            if tk ~= "string" and tk ~= "number" then
                
            elseif tv == "boolean" or tv == "number" or tv == "string" then
                out[kk] = vv
            elseif tv == "Color3" then
                out[kk] = { __color = true, R = vv.R, G = vv.G, B = vv.B }
            elseif tv == "table" then
                local sub = copyTable(vv, depth + 1)
                if sub then out[kk] = sub end
            end
        end
        return out
    end
    for k, v in pairs(Config) do
        local t = typeof(v)
        if t == "boolean" or t == "number" or t == "string" then
            data.Config[k] = v
        elseif t == "Color3" then
            
            data.Config[k] = { __color = true, R = v.R, G = v.G, B = v.B }
        elseif t == "table" then
            local sub = copyTable(v, 0)
            if sub then data.Config[k] = sub end
        end
    end
    return HttpService:JSONEncode(data)
end


function ApplyBlurGradientFromConfig()
    local enabled = Config.BlurGradientEnabled == true
    local animate = Config.BlurGradientAnimate == true
    local colorA = Config.Color_BlurGradientA or Color3.fromRGB(130, 70, 255)
    local colorB = Config.Color_BlurGradientB or Color3.fromRGB(180, 140, 255)
    pcall(function()
        if BlurGradientOverlay then
            BlurGradientOverlay.Visible = enabled and (MenuOpen == true)
            if enabled and MenuOpen then
                BlurGradientOverlay.BackgroundTransparency = math.clamp(tonumber(Config.BlurGradientTransparency) or 0.28, 0, 0.9)
            elseif not enabled then
                BlurGradientOverlay.BackgroundTransparency = 1
            end
        end
        if BlurGradientOverlayGradient then
            BlurGradientOverlayGradient.Color = ColorSequence.new(colorA, colorB)
        end
    end)
    pcall(function()
        local bg = Cache.BlurGradientToggleBg
        local kn = Cache.BlurGradientToggleKnob
        if bg then
            bg.BackgroundColor3 = enabled and (Theme.Accent or Color3.fromRGB(180, 140, 255)) or Theme.ToggleOff
        end
        if kn then
            kn.Position = UDim2.new(enabled and 1 or 0, enabled and -9 or 9, 0.5, 0)
        end
        local abg = Cache.BlurGradientAnimateBg
        local akn = Cache.BlurGradientAnimateKnob
        if abg then
            abg.BackgroundColor3 = animate and (Theme.Accent or Color3.fromRGB(180, 140, 255)) or Theme.ToggleOff
        end
        if akn then
            akn.Position = UDim2.new(animate and 1 or 0, animate and -9 or 9, 0.5, 0)
        end
    end)
    pcall(function()
        if Cache.ColorButtons then
            if Cache.ColorButtons.Color_BlurGradientA then
                Cache.ColorButtons.Color_BlurGradientA.BackgroundColor3 = colorA
            end
            if Cache.ColorButtons.Color_BlurGradientB then
                Cache.ColorButtons.Color_BlurGradientB.BackgroundColor3 = colorB
            end
        end
    end)
end

function ApplyLoadedConfig(data)
    if type(data) ~= "table" then return false end
    
    local cfgTable = data.Config
    if type(cfgTable) ~= "table" and (data.BoxEspEnabled ~= nil or data.EspEnabled ~= nil) then
        cfgTable = data
    end
    if type(cfgTable) ~= "table" then return false end
    local function toColor3(v)
        if typeof(v) == "Color3" then return v end
        if type(v) ~= "table" then return nil end
        local r, g, b = tonumber(v.R), tonumber(v.G), tonumber(v.B)
        if not r or not g or not b then
            r = tonumber(v[1]); g = tonumber(v[2]); b = tonumber(v[3])
        end
        if not r or not g or not b then return nil end
        
        if r > 1 or g > 1 or b > 1 then
            return Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
        end
        return Color3.new(math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1))
    end
    local applied = 0
    for k, v in pairs(cfgTable) do
        if k == "__color" or k == CfgIO.Marker then
            
        elseif type(k) == "string" then
            local expected = Config[k]
            local expType = expected ~= nil and typeof(expected) or nil
            
            if expType == nil then
                if type(v) == "boolean" then expType = "boolean"
                elseif type(v) == "number" then expType = "number"
                elseif type(v) == "string" then expType = "string"
                elseif type(v) == "table" and (v.__color or (v.R ~= nil and v.G ~= nil and v.B ~= nil)) then expType = "Color3"
                end
            end
            if type(v) == "table" and (v.__color or (v.R ~= nil and v.G ~= nil and v.B ~= nil and expType == "Color3")) then
                local col = toColor3(v)
                if col then
                    Config[k] = col
                    applied = applied + 1
                end
            elseif expType == "Color3" then
                local col = toColor3(v)
                if col then Config[k] = col applied = applied + 1 end
            elseif expType == "boolean" then
                if type(v) == "boolean" then
                    Config[k] = v; applied = applied + 1
                elseif v == 1 or v == "true" or v == "1" then
                    Config[k] = true; applied = applied + 1
                elseif v == 0 or v == "false" or v == "0" then
                    Config[k] = false; applied = applied + 1
                end
            elseif expType == "number" then
                local num = tonumber(v)
                if num then Config[k] = num applied = applied + 1 end
            elseif expType == "string" then
                Config[k] = tostring(v); applied = applied + 1
            elseif expType == "table" and type(v) == "table" then
                if k == "Keybinds" then
                    Config.Keybinds = {}
                    for bk, bv in pairs(v) do
                        if type(bk) == "string" and type(bv) == "string" then
                            Config.Keybinds[bk] = bv
                        end
                    end
                    applied = applied + 1
                elseif k == "WeaponAutoSwapSlots" then
                    local slots = {}
                    for _, n in pairs(v) do
                        local num = tonumber(n)
                        if num then slots[#slots + 1] = math.floor(num) end
                    end
                    table.sort(slots)
                    Config.WeaponAutoSwapSlots = slots
                    applied = applied + 1
                else
                    Config[k] = v; applied = applied + 1
                end
            elseif expected == nil and type(v) == "boolean" then
                Config[k] = v; applied = applied + 1
            elseif expected == nil and type(v) == "number" then
                Config[k] = v; applied = applied + 1
            elseif expected == nil and type(v) == "string" then
                Config[k] = v; applied = applied + 1
            elseif expected == nil and type(v) == "table" and v.__color then
                local col = toColor3(v)
                if col then Config[k] = col applied = applied + 1 end
            elseif expType == typeof(v) then
                Config[k] = v; applied = applied + 1
            end
        end
    end
    if type(data.Accent) == "table" and data.Accent.R then
        local r = tonumber(data.Accent.R) or 0
        local g = tonumber(data.Accent.G) or 0
        local b = tonumber(data.Accent.B) or 0
        Theme.Accent = Color3.new(r, g, b)
        Theme.ToggleOn = Theme.Accent
        if ColorPickerBtn then ColorPickerBtn.BackgroundColor3 = Theme.Accent end
    end
    if typeof(data.CurrentColorIndex) == "number" then
        Config.CurrentColorIndex = data.CurrentColorIndex
    end
    if type(data.name) == "string" and data.name ~= "" then
        CfgIO.Current = SanitizeConfigName(data.name)
        if CfgIO.NameBox then CfgIO.NameBox.Text = CfgIO.Current end
    end
    
    pcall(function()
        if Cache.AntiAimModeBtn then
            Cache.AntiAimModeBtn.Text = "AA Mode  ·  " .. tostring(Config.AntiAimMode or "Static")
        end
        if Cache.RefreshAAModeList then pcall(Cache.RefreshAAModeList) end
            if Cache.RefreshTracerOriginList then pcall(Cache.RefreshTracerOriginList) end
        if Cache.RefreshSilentV2PartList then pcall(Cache.RefreshSilentV2PartList) end
        if Cache.RefreshMultipointList then pcall(Cache.RefreshMultipointList) end
    end)
    pcall(function()
        if RefreshAllSwitches then RefreshAllSwitches() end
        if RefreshAllColorButtons then pcall(RefreshAllColorButtons) end
        if RefreshAllSliders then pcall(RefreshAllSliders) end
        if RefreshAllSliders then RefreshAllSliders() end
        if ApplyBlurGradientFromConfig then pcall(ApplyBlurGradientFromConfig) end
        if UpdateWatermarkPosition then pcall(UpdateWatermarkPosition) end
        if LayoutWatermark then pcall(LayoutWatermark) end
        if Cache.RefreshWatermarkPosList then pcall(Cache.RefreshWatermarkPosList) end
        if Cache.RefreshWmPosHighlight then pcall(Cache.RefreshWmPosHighlight) end
        if Cache.WatermarkPosHeaderLbl then
            Cache.WatermarkPosHeaderLbl.Text = "Watermark Pos  ·  " .. tostring(Config.WatermarkPosition or "Center")
        end
        if UpdateWatermarkPosition then pcall(UpdateWatermarkPosition) end
    end)
    return applied > 0
end


function RefreshAllColorButtons()
    Cache.ColorButtons = Cache.ColorButtons or {}
    local function toCol(col)
        if typeof(col) == "Color3" then return col end
        if type(col) == "table" then
            local r, g, b = tonumber(col.R), tonumber(col.G), tonumber(col.B)
            if not r then r, g, b = tonumber(col[1]), tonumber(col[2]), tonumber(col[3]) end
            if r and g and b then
                if r > 1 or g > 1 or b > 1 then
                    return Color3.fromRGB(math.clamp(r,0,255), math.clamp(g,0,255), math.clamp(b,0,255))
                end
                return Color3.new(math.clamp(r,0,1), math.clamp(g,0,1), math.clamp(b,0,1))
            end
        end
        return nil
    end
    local function applyCol(btn, col)
        if not btn or not btn.Parent then return end
        local c = toCol(col)
        if not c then return end
        pcall(function() btn.BackgroundColor3 = c end)
    end
    for key, btn in pairs(Cache.ColorButtons) do
        applyCol(btn, Config[key])
    end
    pcall(function()
        if ScreenGui then
            for _, d in ipairs(ScreenGui:GetDescendants()) do
                if d:IsA("TextButton") or d:IsA("ImageButton") or d:IsA("Frame") then
                    local key = nil
                    pcall(function() key = d:GetAttribute("AnxiumColorKey") end)
                    if type(key) == "string" and Config[key] ~= nil then
                        applyCol(d, Config[key])
                        Cache.ColorButtons[key] = d
                    end
                end
            end
        end
    end)
    applyCol(Cache.ArrowColorBBtn, Config.Color_OffscreenArrowB)
    applyCol(Cache.NameEspGradBBtn, Config.Color_NameEspB)
    applyCol(Cache.ChamsVisColorBtn, Config.Color_ChamsVisible)
    applyCol(Cache.ChamsOccColorBtn, Config.Color_ChamsOccluded)
    pcall(function()
        if UV_RefreshArrowGradients then UV_RefreshArrowGradients() end
    end)
end

function RefreshAllSwitches()
    local pairsList = {
        { Config.BoxEspEnabled, BoxEspBg, BoxEspKnob },
        { Config.HealthbarEspEnabled, HealthbarEspBg, HealthbarEspKnob },
        { Config.ChamsEnabled, ChamsBg, ChamsKnob },
        { Config.ChamsVisCheckEnabled, ChamsVisBg, ChamsVisKnob },
        { Config.NameEspEnabled, NameEspBg, NameEspKnob },
        { Config.NameEspFillEnabled, NameEspFillBg, NameEspFillKnob },
        { Config.DistanceEspEnabled, DistEspBg, DistEspKnob },
        { Config.NameEspGradientEnabled, NameEspGradBg, NameEspGradKnob },
        { Config.TeamNameEspGradientEnabled, TeamNameEspGradBg, TeamNameEspGradKnob },
        { Config.SkeletonEnabled, SkelBg, SkelKnob },
        { Config.TracersEnabled, TracerBg, TracerKnob },
        { Config.TracerGradientEnabled, TracerGradBg, TracerGradKnob },
        { Config.CrosshairEnabled, CrossBg, CrossKnob },
        { Config.CrosshairDotEnabled, CrossDotBg, CrossDotKnob },
        { Config.SpinCrosshairEnabled, SpinCrossBg, SpinCrossKnob },
        { Config.ScopeEnabled, ScopeBg, ScopeKnob },
        { Config.ScopeGradientEnabled, ScopeGradBg, ScopeGradKnob },
        { Config.ScopeDynamicEnabled, ScopeDynBg, ScopeDynKnob },
        { Config.ScopeSoundEnabled, ScopeSoundBg, ScopeSoundKnob },
        { Config.DamageNumbersEnabled, DmgNumBg, DmgNumKnob },
        { Config.WorldColorEnabled, WorldColorBg, WorldColorKnob },
        { Config.NoShadowsEnabled, NoShadowsBg, NoShadowsKnob },
        { Config.HitMarkerEnabled, HitMarkerBg, HitMarkerKnob },
        { Config.SelfChamsEnabled, SelfChamsBg, SelfChamsKnob },
        { Config.CloneChamsEnabled, CloneChamsBg, CloneChamsKnob },
        { Config.OffscreenArrowsEnabled, OffscreenBg, OffscreenKnob },
        { Config.ArrowPulseEnabled, ArrowPulseBg, ArrowPulseKnob },
        { Config.FallingStarsEnabled, FallingStarsBg, FallingStarsKnob },
        { Config.DeathChamsEnabled, DeathChamsBg, DeathChamsKnob },
        { Config.DeathBurstEnabled, DeathBurstBg, DeathBurstKnob },
        { Config.KillDissolveEnabled, KillDissolveBg, KillDissolveKnob },
        { Config.CameraFovEnabled, CameraFovBg, CameraFovKnob },
        { Config.FpsBoostEnabled, FpsBoostBg, FpsBoostKnob },
        { Config.FullbrightEnabled, FullBg, FullKnob },
        { Config.DarkModeEnabled, DarkModeBg, DarkModeKnob },
        { Config.NoFogEnabled, NoFogBg, NoFogKnob },
        { Config.SelfTransparencyEnabled, SelfTransBg, SelfTransKnob },
        { Config.AngelHaloEnabled, AngelHaloBg, AngelHaloKnob },

        { Config.ActiveListEnabled, ActiveListBg, ActiveListKnob },
        { Config.FakeFpsEnabled, FakeFpsBg, FakeFpsKnob },
        { Config.ChinaHatEnabled, HatBg, HatKnob },
        { Config.FakeLagEnabled, FakeLagBg, FakeLagKnob },
        { Config.FakeLagRandomize, FakeLagRandBg, FakeLagRandKnob },
        { Config.OrbitOrbsEnabled, OrbitOrbsBg, OrbitOrbsKnob },
        { Config.TargetRingEnabled, TargetRingBg, TargetRingKnob },
        { Config.TargetMarkerEnabled, TargetMarkerBg, TargetMarkerKnob },
        { Config.TargetDotEnabled, TargetDotBg, TargetDotKnob },
        { Config.TargetMarkerRotate, TargetMarkerRotBg, TargetMarkerRotKnob },
        { Config.TrailEnabled, TrailBg, TrailKnob },
        { Config.FogEnabled, FogBg, FogKnob },
        { Config.DayCycleEnabled, DayCycleBg, DayCycleKnob },
        { Config.FootstepsEnabled, FootstepsBg, FootstepsKnob },
        { Config.AspectRatioEnabled, AspectBg, AspectKnob },
        { Config.ThirdPersonEnabled, ThirdPersonBg, ThirdPersonKnob },
        { Config.ForceFieldEnabled, FFBg, FFKnob },
        { Config.WeaponForceFieldEnabled, WeaponFFBg, WeaponFFKnob },
        { Config.KillFlashEnabled, KillFlashBg, KillFlashKnob },
        { Config.KillLightningEnabled, KillLightningBg, KillLightningKnob },
        { Config.KillLogsEnabled, KillLogsBg, KillLogsKnob },
        { Config.HitLogsEnabled, HitLogsBg, HitLogsKnob },
        { Config.HitboxShow, HitboxShowBg, HitboxShowKnob },
        { Config.BulletTracersEnabled, BulletTracerBg, BulletTracerKnob },
        { Config.AutowallEnabled, AutowallBg, AutowallKnob },
        { Config.AutowallShowInfo, AutowallInfoBg, AutowallInfoKnob },
        { Config.BindListEnabled, BindListSettingsBg or BindListBg, BindListSettingsKnob or BindListKnob },
        { Config.AuraEnabled, AuraBg, AuraKnob },
        { Config.ClassicPinkEnabled, ClassicPinkBg, ClassicPinkKnob },
        { Config.ClassicAngelEnabled, ClassicAngelBg, ClassicAngelKnob },
        { Config.ParticleStarlightEnabled, ParticleStarBg, ParticleStarKnob },
        { Config.ParticleAngelEnabled, ParticleAngelBg, ParticleAngelKnob },
        { Config.TeamCheckerEnabled, TeamCheckerBg, TeamCheckerKnob },
        { Config.TeamEspEnabled, TeamEspBg, TeamEspKnob },
        { Config.TeamNameEspEnabled, TeamNameEspBg, TeamNameEspKnob },
        { Config.TeamDistanceEspEnabled, TeamDistEspBg, TeamDistEspKnob },
        { Config.AimEnabled, AimBg, AimKnob },
        { Config.AimWallCheck, AimWallBg, AimWallKnob },
        { Config.ShowFovEnabled, ShowFovBg, ShowFovKnob },
        { Config.FovFillEnabled, FovFillBg, FovFillKnob },
        { Config.FovPulseEnabled, FovPulseBg, FovPulseKnob },
        { Config.TargetHudEnabled, TargetHudBg, TargetHudKnob },
        { Config.TargetLineEnabled, TargetLineBg, TargetLineKnob },
        { Config.TargetLineVisibleCheck, TargetLineVisBg, TargetLineVisKnob },
        { Config.DarkModeEnabled, DarkModeBg, DarkModeKnob },
        { Config.SpinEnabled, SpinBg, SpinKnob },
        { Config.AntiAimEnabled, AntiAimBg, AntiAimKnob },
        { Config.AntiAimResolveEnabled, AntiAimResolveBg, AntiAimResolveKnob },
        { Config.TriggerbotEnabled, TriggerbotBg, TriggerbotKnob },
        { Config.TriggerbotAutowall, TriggerbotAWBg, TriggerbotAWKnob },
        { Config.WeaponAutoSwapEnabled, WeaponAutoSwapBg, WeaponAutoSwapKnob },
        { Config.CustomFireSoundEnabled, FireSoundBg, FireSoundKnob },
        { Config.SpeedHackEnabled, SpeedBg, SpeedKnob },
        { Config.MultiJumpEnabled, JumpBg, JumpKnob },
        { Config.AutoJumpEnabled, AutoJumpBg, AutoJumpKnob },
        { Config.NoclipEnabled, NoclipBg, NoclipKnob },
        { Config.FlyEnabled, FlyBg, FlyKnob },
        { Config.BHopEnabled, BHopBg, BHopKnob },
        { Config.StrafeEnabled, StrafeBg, StrafeKnob },
        { Config.AutoShiftEnabled, AutoShiftBg, AutoShiftKnob },
        { Config.PeekAssistFillEnabled, PeekAssistFillBg, PeekAssistFillKnob },
        { Config.BoxFillGradientEnabled, BoxFillBg, BoxFillKnob },
        { Config.BoxOutlineGradient, BoxOutlineGradBg, BoxOutlineGradKnob },
        { Config.BoxFillRotation, BoxFillRotBg, BoxFillRotKnob },
        { Config.SilentAimV2Enabled, SilentV2Bg, SilentV2Knob },
        { Config.SilentV2ShowFov, SilentV2FovBg, SilentV2FovKnob },
        { Config.SilentV2FovFillEnabled, SilentV2FovFillBg, SilentV2FovFillKnob },
        { Config.SilentV2TeamCheck, SilentV2TeamBg, SilentV2TeamKnob },
        { Config.SilentV2VisibleCheck, SilentV2VisBg, SilentV2VisKnob },
        { Config.SilentV2Sticky, SilentV2StickyBg, SilentV2StickyKnob },
        { Config.SilentV2Prediction, SilentV2PredBg, SilentV2PredKnob },
        { Config.SilentV2FovPulseEnabled, SilentV2FovPulseBg, SilentV2FovPulseKnob },
        { Config.FovDynamicEnabled, FovDynBg, FovDynKnob },
        { Config.SilentV2FovDynamicEnabled, SilentFovDynBg, SilentFovDynKnob },
        { Config.SilentV2MultipointEnabled, SilentV2MultiBg, SilentV2MultiKnob },
        { Config.ForceFieldRainbow, FFRainbowBg, FFRainbowKnob },
    }
    for _, item in ipairs(pairsList) do
        local state, bg, knob = item[1], item[2], item[3]
        if bg and knob then
            pcall(function()
                knob.AnchorPoint = Vector2.new(0.5, 0.5)
                if state then
                    bg.BackgroundColor3 = Theme.Accent
                    knob.Position = UDim2.new(1, -9, 0.5, 0)
                    local g = bg:FindFirstChild("SwitchGlow")
                    if g then g.Transparency = 0.25; g.Thickness = 2; g.Color = Theme.Accent end
                else
                    bg.BackgroundColor3 = Theme.ToggleOff
                    knob.Position = UDim2.new(0, 9, 0.5, 0)
                    local g = bg:FindFirstChild("SwitchGlow")
                    if g then g.Transparency = 0.92; g.Thickness = 1.5 end
                end
            end)
        end
    end
    
    pcall(function()
        for _, highlight in pairs(Cache.Highlights) do
            if highlight and highlight.Parent then
                highlight.Enabled = false
            end
        end
    end)
    pcall(function()
        for plr, chams in pairs(Cache.Chams) do
            if chams and chams.Parent then
                chams.Enabled = Config.ChamsEnabled
                chams.FillColor = GetEspColorForPlayer(plr, Config.Color_Chams or Theme.Accent)
            end
        end
    end)
    pcall(function()
        if Cache.PlayerTrail then
            Cache.PlayerTrail.Enabled = Config.TrailEnabled
            Cache.PlayerTrail.Color = ColorSequence.new(Config.Color_Trail or Theme.Accent)
        end
    end)
    pcall(function()
        FovCircle.Color = Config.Color_Fov or Theme.Accent
        FovCircle.Radius = Config.FovRadius
        FovCircle.Visible = Config.ShowFovEnabled
        FovCircle.Color = Config.Color_Fov or Theme.Accent
        CrosshairX.Color = Config.Color_Crosshair or Theme.Accent
        CrosshairY.Color = Config.Color_Crosshair or Theme.Accent
    end)
    pcall(function()
        for _, boxData in pairs(Cache.Boxes) do
            if boxData then
                if boxData.Box then boxData.Box.Color = Theme.Accent end
                if boxData.Corners then
                    for _, ln in pairs(boxData.Corners) do if ln then ln.Color = Theme.Accent end end
                end
            end
        end
        for _, line in pairs(Cache.TracerLines) do
            if line then line.Color = Config.Color_Tracers or Theme.Accent end
        end
        for _, parts in pairs(Cache.Skeletons) do
            if parts then
                for _, line in pairs(parts) do
                    if line then line.Color = Theme.Accent end
                end
            end
        end
        for _, nameText in pairs(Cache.EspLabels) do
            if nameText then
                pcall(function()
                    if typeof(nameText) == "Instance" and nameText:IsA("TextLabel") then
                        nameText.TextColor3 = Config.Color_NameEsp or Theme.Accent
                        nameText.Font = SelectedFont or Enum.Font.GothamBold
                    else
                        nameText.Color = GetEspColorForPlayer(targetPlayer, Config.Color_NameEsp or Theme.Accent)
                    end
                end)
            end
        end
    end)
    pcall(function() UserInputService.MouseIconEnabled = not Config.CrosshairEnabled end)
    pcall(UpdateActiveList)
    pcall(function() ForceField_Toggle(Config.ForceFieldEnabled) end)
    pcall(ClassicAura_RefreshAll)
    pcall(ParticleAura_RefreshAll)

    
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if Config.SpinEnabled then
            if hum then hum.AutoRotate = false end
            if hrp then
                for _, v in pairs(hrp:GetChildren()) do
                    if v.Name == "Spinning" then v:Destroy() end
                end
                local Spin = Instance.new("BodyAngularVelocity")
                Spin.Name = "Spinning"
                Spin.Parent = hrp
                Spin.MaxTorque = Vector3.new(0, math.huge, 0)
                Spin.AngularVelocity = Vector3.new(0, Config.SpinSpeed or 20, 0)
            end
        else
            if hum then hum.AutoRotate = true end
            if hrp then
                for _, v in pairs(hrp:GetChildren()) do
                    if v.Name == "Spinning" then v:Destroy() end
                end
            end
        end
    end)

    
    pcall(function()
        if not Config.SpeedHackEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
        if Config.ThirdPersonEnabled then
            ThirdPerson_Enable()
        else
            ThirdPerson_Disable()
        end
    end)
end


do
    local function isDeleted(content)
        if type(content) ~= "string" or #content < 2 then return true end
        return content:find('"__deleted"') ~= nil
    end

    local function fsWrite(p, c)
        if typeof(writefile) ~= "function" then return false end
        return pcall(writefile, p, c) and true or false
    end

    local function fsRead(p)
        if typeof(readfile) ~= "function" then return nil end
        local ok, c = pcall(readfile, p)
        if ok and type(c) == "string" and #c > 0 then return c end
        return nil
    end

    local function fsDelete(p)
        pcall(function() if typeof(delfile) == "function" then delfile(p) end end)
        pcall(function() if typeof(deletefile) == "function" then deletefile(p) end end)
        local gone = false
        if typeof(isfile) == "function" then
            local ok, ex = pcall(isfile, p)
            if ok and not ex then gone = true end
        end
        if not gone then fsWrite(p, '{"__deleted":true}') end
        return true
    end

    local function pathCandidates(name)
        name = SanitizeConfigName(name)
        local f = name .. ".json"
        
        return {
            CfgIO.Folder .. "/" .. f,
            CfgIO.Folder .. "\\" .. f,
            "./" .. CfgIO.Folder .. "/" .. f,
        }
    end

    local function isOurs(content)
        if type(content) ~= "string" or #content < 2 then return false end
        if isDeleted(content) then return false end
        if content:find('"' .. CfgIO.Marker .. '"') then return true end
        if content:find('"Config"') and content:find('"Accent"') then return true end
        return false
    end

    local function readIndex()
        local raw = fsRead(CfgIO.IndexFile) or fsRead(CfgIO.IndexFileAlt)
        if not raw then return {} end
        local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not ok or type(data) ~= "table" then return {} end
        local names, src = {}, (data.names or data)
        if type(src) ~= "table" then return {} end
        local seen = {}
        for _, n in ipairs(src) do
            if type(n) == "string" and n ~= "" and n ~= "_last" and n ~= "_index" then
                n = SanitizeConfigName(n)
                if not seen[n] then seen[n] = true table.insert(names, n) end
            end
        end
        return names
    end

    local function writeIndex(names)
        EnsureConfigFolder()
        local clean, seen = {}, {}
        for _, n in ipairs(names or {}) do
            n = SanitizeConfigName(n)
            if n ~= "" and n ~= "_last" and n ~= "_index" and not seen[n] then
                seen[n] = true
                table.insert(clean, n)
            end
        end
        table.sort(clean)
        local payload = HttpService:JSONEncode({ names = clean, version = 1 })
        fsWrite(CfgIO.IndexFile, payload)
        fsWrite(CfgIO.IndexFileAlt, payload)
        return clean
    end

    local function readConfigFile(name)
        name = SanitizeConfigName(name)
        for _, p in ipairs(pathCandidates(name)) do
            local c = fsRead(p)
            if c and isOurs(c) then return c, p end
        end
        return nil, nil
    end

    local function writeConfigFile(name, json)
        name = SanitizeConfigName(name)
        EnsureConfigFolder()
        
        local stamped = json
        if type(json) == "string" and not json:find('"' .. CfgIO.Marker .. '"') then
            if json:sub(1, 1) == "{" then
                stamped = '{"' .. CfgIO.Marker .. '":true,' .. json:sub(2)
            end
        end
        for _, p in ipairs(pathCandidates(name)) do
            if fsWrite(p, stamped) then
                local body = fsRead(p)
                if body and isOurs(body) then
                    return true, p
                end
            end
        end
        return false, nil
    end

    local function deleteConfigFile(name)
        name = SanitizeConfigName(name)
        for _, p in ipairs(pathCandidates(name)) do
            fsDelete(p)
        end
        return true
    end

    local function scanListfiles()
        local found = {}
        if typeof(listfiles) ~= "function" then return found end
        
        for _, dir in ipairs({ CfgIO.Folder, CfgIO.Folder .. "/", "./" .. CfgIO.Folder }) do
            local ok, res = pcall(listfiles, dir)
            if ok and type(res) == "table" then
                for _, fpath in ipairs(res) do
                    local s = tostring(fpath):gsub("\\", "/")
                    local base = s:match("([^/]+)$") or s
                    if base == "_last.txt" or base == "_index.json" or base:find("_index") then
                        
                    elseif base:match("%.json$") then
                        local name = base:match("(.+)%.json$")
                        if name and name ~= "" and name ~= "_last" and name ~= "_index" then
                            name = SanitizeConfigName(name)
                            local content = fsRead(fpath)
                            if content and isOurs(content) then
                                found[name] = true
                            end
                        end
                    end
                end
            end
        end
        return found
    end

    function CfgIO.RebuildListUI()
        local frame = CfgIO.ListFrame
        if not frame then return end
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        CfgIO.RowButtons = {}
        if #CfgIO.List == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, -8, 0, 28)
            empty.BackgroundTransparency = 1
            empty.Text = "No configs yet - type a name and press Create"
            empty.TextColor3 = Theme.TextDim
            empty.TextSize = 11
            empty.Font = SelectedFont
            empty.TextXAlignment = Enum.TextXAlignment.Left
            empty.Parent = frame
            return
        end
        for i, name in ipairs(CfgIO.List) do
            local row = Instance.new("TextButton")
            row.Name = "Cfg_" .. name
            row.Size = UDim2.new(1, -8, 0, 28)
            local selected = (name == CfgIO.Current or i == CfgIO.Index)
            row.BackgroundColor3 = selected and Color3.fromRGB(55, 45, 80) or Theme.BgTertiary
            row.BackgroundTransparency = 0.15
            row.BorderSizePixel = 0
            row.Text = "  " .. name
            row.TextColor3 = (name == CfgIO.Current) and Theme.Accent or Theme.Text
            row.TextSize = 12
            row.Font = SelectedFont
            row.TextXAlignment = Enum.TextXAlignment.Left
            row.LayoutOrder = i
            row.Parent = frame
            CfgIO.RowButtons[name] = row
            row.MouseButton1Click:Connect(function()
                CfgIO.Index = i
                CfgIO.Current = name
                if CfgIO.NameBox then CfgIO.NameBox.Text = name end
                CfgIO.RebuildListUI()
            end)
            row.MouseButton2Click:Connect(function()
                CfgIO.Index = i
                CfgIO.Current = name
                if CfgIO.NameBox then CfgIO.NameBox.Text = name end
                CfgIO.Load()
            end)
        end
    end

    function CfgIO.RefreshList()
        EnsureConfigFolder()
        local merged, seen = {}, {}

        local function add(n)
            n = SanitizeConfigName(n)
            if n == "" or seen[n] then return end
            if select(1, readConfigFile(n)) then
                seen[n] = true
                table.insert(merged, n)
            end
        end

        for _, n in ipairs(readIndex()) do add(n) end
        for n, _ in pairs(scanListfiles()) do add(n) end

        table.sort(merged)
        for i = #CfgIO.List, 1, -1 do CfgIO.List[i] = nil end
        for _, n in ipairs(merged) do table.insert(CfgIO.List, n) end
        writeIndex(CfgIO.List)

        if CfgIO.Index < 1 then CfgIO.Index = 1 end
        if #CfgIO.List == 0 then
            CfgIO.Index = 1
        elseif CfgIO.Index > #CfgIO.List then
            CfgIO.Index = #CfgIO.List
        end
        if CfgIO.SelectBtn then
            CfgIO.SelectBtn.Text = (#CfgIO.List == 0) and "(no configs)" or CfgIO.List[CfgIO.Index]
        end
        ConfigList = CfgIO.List
        ConfigListIndex = CfgIO.Index
        CurrentConfigName = CfgIO.Current
        pcall(CfgIO.RebuildListUI)
        return CfgIO.List
    end

    function CfgIO.Remember(name)
        if not name or name == "" then return end
        EnsureConfigFolder()
        local n = SanitizeConfigName(name)
        fsWrite(CfgIO.LastFile, n)
        fsWrite(CfgIO.LastFileAlt, n)
    end

    function CfgIO.GetLast()
        local content = fsRead(CfgIO.LastFile) or fsRead(CfgIO.LastFileAlt)
        if content then
            local name = content:gsub("%s+", "")
            if name ~= "" and not name:find("{") then
                return SanitizeConfigName(name)
            end
        end
        return nil
    end

    function CfgIO.Rename()
        if typeof(writefile) ~= "function" then
            Notify("Config", "writefile not available on this executor")
            return false
        end
        local oldName = CfgIO.Current
        if (not oldName or oldName == "") and #CfgIO.List > 0 and CfgIO.List[CfgIO.Index] then
            oldName = CfgIO.List[CfgIO.Index]
        end
        if not oldName or oldName == "" then
            Notify("Config", "Select a config to rename")
            return false
        end
        oldName = SanitizeConfigName(oldName)

        local newName = ""
        if CfgIO.NameBox and type(CfgIO.NameBox.Text) == "string" then
            newName = CfgIO.NameBox.Text
        end
        newName = SanitizeConfigName(newName)
        if newName == "" then
            Notify("Config", "Enter a new name first")
            return false
        end
        if newName == oldName then
            Notify("Config", "Name is the same")
            return false
        end

        local content = select(1, readConfigFile(oldName))
        if not content then
            Notify("Config", "Old config not found: " .. oldName)
            return false
        end

        
        local updated = content
        local okDec, data = pcall(function() return HttpService:JSONDecode(content) end)
        if okDec and type(data) == "table" then
            data.name = newName
            local okEnc, json = pcall(function() return HttpService:JSONEncode(data) end)
            if okEnc and type(json) == "string" then
                updated = json
            end
        else
            
            updated = content:gsub('"name"%s*:%s*"[^"]*"', '"name":"' .. newName .. '"', 1)
        end

        local wrote = writeConfigFile(newName, updated)
        if not wrote then
            Notify("Config", "Failed to write: " .. newName)
            return false
        end

        deleteConfigFile(oldName)

        for i, n in ipairs(CfgIO.List) do
            if n == oldName then
                CfgIO.List[i] = newName
            end
        end
        
        local seen, clean = {}, {}
        for _, n in ipairs(CfgIO.List) do
            n = SanitizeConfigName(n)
            if n ~= "" and not seen[n] then
                seen[n] = true
                table.insert(clean, n)
            end
        end
        table.sort(clean)
        CfgIO.List = clean
        CfgIO.Current = newName
        for i, n in ipairs(CfgIO.List) do
            if n == newName then CfgIO.Index = i break end
        end
        if CfgIO.NameBox then CfgIO.NameBox.Text = newName end
        writeIndex(CfgIO.List)
        CfgIO.Remember(newName)
        CurrentConfigName = newName
        Config.CurrentConfigName = newName
        if CfgIO.SelectBtn then
            CfgIO.SelectBtn.Text = newName
        end
        CfgIO.RefreshList()
        
        CfgIO.Current = newName
        for i, n in ipairs(CfgIO.List) do
            if n == newName then CfgIO.Index = i break end
        end
        if CfgIO.NameBox then CfgIO.NameBox.Text = newName end
        if CfgIO.SelectBtn then CfgIO.SelectBtn.Text = newName end
        pcall(CfgIO.RebuildListUI)
        if LayoutWatermark then pcall(LayoutWatermark) end
        Notify("Config", "Renamed: " .. oldName .. " → " .. newName)
        return true
    end

    function CfgIO.Save()
        if typeof(writefile) ~= "function" then
            Notify("Config", "writefile not available on this executor")
            return false
        end
        local rawName = ""
        if CfgIO.NameBox and type(CfgIO.NameBox.Text) == "string" then
            rawName = CfgIO.NameBox.Text
        end
        if rawName == "" and #CfgIO.List > 0 and CfgIO.List[CfgIO.Index] then
            rawName = CfgIO.List[CfgIO.Index]
        end
        if rawName == "" then rawName = CfgIO.Current or "default" end
        local name = SanitizeConfigName(rawName)
        EnsureConfigFolder()
        CfgIO.Current = name
        local okSer, json = pcall(function() return SerializeConfig(name) end)
        if not okSer or not json or #json < 2 then
            Notify("Config", "Serialize failed")
            return false
        end
        local wrote = writeConfigFile(name, json)
        if not wrote then
            Notify("Config", "Write failed for: " .. name)
            return false
        end
        CfgIO.Current = name
        if CfgIO.NameBox then CfgIO.NameBox.Text = name end
        CfgIO.Remember(name)
        local found = false
        for _, n in ipairs(CfgIO.List) do
            if n == name then found = true break end
        end
        if not found then table.insert(CfgIO.List, name) end
        table.sort(CfgIO.List)
        for i, n in ipairs(CfgIO.List) do
            if n == name then CfgIO.Index = i break end
        end
        writeIndex(CfgIO.List)
        CfgIO.RefreshList()
        for i, n in ipairs(CfgIO.List) do
            if n == name then CfgIO.Index = i break end
        end
        Notify("Config", "Saved: " .. name)
        return true
    end

    local function postLoadApply(name)
        name = name or CfgIO.Current or "default"
        CfgIO.Current = SanitizeConfigName(name)
        if CfgIO.NameBox then CfgIO.NameBox.Text = CfgIO.Current end
        pcall(function()
            if RefreshAllSwitches then RefreshAllSwitches() end
            if RefreshAllSliders then pcall(RefreshAllSliders) end
        end)
        pcall(function()
            if typeof(ApplyAccentColor) == "function" then ApplyAccentColor(Theme.Accent) end
            if typeof(ApplyMenuFont) == "function" then
                pcall(ApplyMenuFont, Config.MenuFont or "GothamBold")
            end
            if Cache.FallingStarsSetEnabled then
                pcall(Cache.FallingStarsSetEnabled, Config.FallingStarsEnabled == true)
            end
            if Cache.RefreshMenuFontList then pcall(Cache.RefreshMenuFontList) end
        end)
        pcall(function()
            if RefreshAllColorButtons then RefreshAllColorButtons() end
            if UV_RefreshArrowGradients then UV_RefreshArrowGradients() end
        end)
        task.defer(function()
            pcall(function()
                if RefreshAllColorButtons then RefreshAllColorButtons() end
                if UV_RefreshArrowGradients then UV_RefreshArrowGradients() end
            end)
        end)

        pcall(function()
            if Cache.AnimHeaderLbl then
                Cache.AnimHeaderLbl.Text = "Animation List  ·  " .. tostring(Config.SelectedAnimPack or "Default")
            end
            if Cache.AnimSelectedLabel then
                Cache.AnimSelectedLabel.Text = "Selected: " .. tostring(Config.SelectedAnimPack or "Default")
            end
            if Config.SelectedAnimPack and Config.SelectedAnimPack ~= "Default" then
                if Anxium_PlayAnimationBody then
                    Anxium_PlayAnimationBody(Config.SelectedAnimPack)
                end
            end
        end)
        pcall(function()
            for _, p in ipairs((CachedPlayerList or Players:GetPlayers())) do
                if p ~= LocalPlayer and ApplyEspToPlayer then ApplyEspToPlayer(p) end
            end
        end)
        pcall(function()
            if Config.ForceFieldEnabled and ForceField_Toggle then ForceField_Toggle(true) end
            if Config.WeaponForceFieldEnabled and WeaponFF_Toggle then WeaponFF_Toggle(true) end
            if Config.TrailEnabled and LocalPlayer.Character and SetupTrail then SetupTrail(LocalPlayer.Character) end
            if ClassicAura_RefreshAll then ClassicAura_RefreshAll() end
            if ParticleAura_RefreshAll then ParticleAura_RefreshAll() end
            if FovCircle then
                FovCircle.Visible = Config.ShowFovEnabled
                FovCircle.Radius = Config.FovRadius or 150
                FovCircle.Color = Config.Color_Fov or Theme.Accent
            end
            if Cache and Cache.SilentV2FovCircle then
                Cache.SilentV2FovCircle.Radius = Config.SilentV2Fov or 140
                Cache.SilentV2FovCircle.Color = Config.Color_SilentV2Fov or Color3.fromRGB(120, 200, 255)
            end
            if CrosshairX then CrosshairX.Color = Config.Color_Crosshair or Theme.Accent end
            if CrosshairY then CrosshairY.Color = Config.Color_Crosshair or Theme.Accent end
            UserInputService.MouseIconEnabled = not (Config.CrosshairEnabled or Config.SpinCrosshairEnabled)
            if ActiveListFrame then ActiveListFrame.Visible = Config.ActiveListEnabled == true end
            if BindListFrame then BindListFrame.Visible = Config.BindListEnabled == true end
            if UpdateActiveList then UpdateActiveList() end
            if UpdateFakeFpsDisplay then UpdateFakeFpsDisplay() end
            if UpdateBindList then UpdateBindList() end
            if Config.ThirdPersonEnabled and ThirdPerson_Enable then ThirdPerson_Enable()
            elseif ThirdPerson_Disable then ThirdPerson_Disable() end
            Cache.ChamsForceRefresh = true
            if Config.TeamCheckerEnabled and RefreshTeamIgnoreVisuals then RefreshTeamIgnoreVisuals() end
            
            if Config.SelectedAnimPack and Anxium_PlayAnimationBody then
                Anxium_PlayAnimationBody(Config.SelectedAnimPack)
            end
            if Cache.AnimPackButtons then
                local cur = Config.SelectedAnimPack or "Default"
                for nameBtn, btn in pairs(Cache.AnimPackButtons) do
                    if btn and btn.Parent then
                        if nameBtn == cur then
                            btn.BackgroundColor3 = Theme.Accent
                            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        else
                            btn.BackgroundColor3 = Theme.BgTertiary
                            btn.TextColor3 = Theme.Text
                        end
                    end
                end
            end
            if Cache.AnimHeaderLbl then
                Cache.AnimHeaderLbl.Text = "Animation List  ·  " .. tostring(Config.SelectedAnimPack or "Default")
            end
            if Cache.MenuKeyLabel then
                local mk = (Config.MenuKey and Config.MenuKey ~= "") and Config.MenuKey or "RightShift"
                Cache.MenuKeyLabel.Text = "[" .. mk .. "]"
            end
            if Config.MenuKey == nil or Config.MenuKey == "" then
                Config.MenuKey = "Insert"
            end

            if type(Config.WatermarkPosition) ~= "string" or (
                Config.WatermarkPosition ~= "Left"
                and Config.WatermarkPosition ~= "Center"
                and Config.WatermarkPosition ~= "Right"
                and Config.WatermarkPosition ~= "BottomLeft"
                and Config.WatermarkPosition ~= "BottomCenter"
                and Config.WatermarkPosition ~= "BottomRight"
            ) then
                Config.WatermarkPosition = "Center"
            end
            if Cache.WatermarkPosBtn then
                Cache.WatermarkPosBtn.Text = tostring(Config.WatermarkPosition)
            end
            if LayoutWatermark then LayoutWatermark() end
            if UpdateWatermarkPosition then UpdateWatermarkPosition() end
            if ChinaHat_ApplyStyle then ChinaHat_ApplyStyle() end
            if Cache.ChinaHatStyleBtn then
                Cache.ChinaHatStyleBtn.Text = tostring(Config.ChinaHatStyle or "Drawing")
            end
            if Config.FakeLagEnabled then
                FakeLag_Start()
            else
                FakeLag_Stop()
            end
            if CameraFov_Apply then CameraFov_Apply() end
            if FpsBoost_Apply then FpsBoost_Apply() end
            if AutoShift_Apply then AutoShift_Apply() end
            if WeaponAutoSwap_Apply then WeaponAutoSwap_Apply() end
            if Cache.RefreshWeaponAutoSwapList then pcall(Cache.RefreshWeaponAutoSwapList) end

            if Cache.AutowallSetEnabled then
                Cache.AutowallSetEnabled(Config.AutowallEnabled == true)
            end
            if Cache.AutowallApply then Cache.AutowallApply() end
            if ActiveListFrame then
                ActiveListFrame.Visible = Config.ActiveListEnabled == true
            end
            if BindListFrame then
                BindListFrame.Visible = Config.BindListEnabled == true
            end
            if Cache.ChinaHatStyleBtn then
                Cache.ChinaHatStyleBtn.Text = tostring(Config.ChinaHatStyle or "Drawing")
            end
            if Cache.AntiAimModeBtn then
                local mode = Config.AntiAimMode or "Static"
                if Cache.AntiAimModeBtn:IsA("TextLabel") or Cache.AntiAimModeBtn:IsA("TextButton") then
                    local t = Cache.AntiAimModeBtn.Text or ""
                    if t:find("AA Mode") or t == "" or not t:find(mode) then
                        Cache.AntiAimModeBtn.Text = "AA Mode  ·  " .. tostring(mode)
                    end
                end
            end
            if Cache.RefreshAAModeList then pcall(Cache.RefreshAAModeList) end
            if Cache.RefreshHitSoundHighlight then pcall(Cache.RefreshHitSoundHighlight) end
            if Cache.RefreshHealthbarStyleHighlight then pcall(Cache.RefreshHealthbarStyleHighlight) end
            if Cache.RefreshChamsStyleList then pcall(Cache.RefreshChamsStyleList) end
            if Cache.RefreshBoxStyleList then pcall(Cache.RefreshBoxStyleList) end
            if Cache.RefreshWeaponStyleList then pcall(Cache.RefreshWeaponStyleList) end
                        if Cache.RefreshAimPartList then pcall(Cache.RefreshAimPartList) end
            if Cache.RefreshSilentV2PartList then pcall(Cache.RefreshSilentV2PartList) end
            if Cache.RefreshMultipointList then pcall(Cache.RefreshMultipointList) end
            if Cache.HitSoundHeaderLbl then
                Cache.HitSoundHeaderLbl.Text = "Sound List  ·  " .. tostring(Config.CustomFireSoundName or "Gun Fire")
            end
            if Cache.BoxStyleHeaderLbl then
                Cache.BoxStyleHeaderLbl.Text = "Box Style  ·  " .. tostring(Config.EspBoxStyle or "Full")
            end
            if Cache.ChamsStyleHeaderLbl then
                Cache.ChamsStyleHeaderLbl.Text = "Chams Style  ·  " .. tostring(Config.ChamsStyle or "Flat")
            end
            if Cache.HealthbarStyleHeaderLbl then
                Cache.HealthbarStyleHeaderLbl.Text = "Healthbar Style  ·  " .. tostring(Config.HealthbarStyle or "Gradient")
            end
            if Cache.WeaponStyleHeaderLbl then
                Cache.WeaponStyleHeaderLbl.Text = "Weapon Style  ·  " .. tostring(Config.WeaponMaterialStyle or "ForceField")
            end
            if Cache.FakeFpsCycleBtn then
                Cache.FakeFpsCycleBtn.Text = tostring(Config.FakeFpsValue or 67)
            end
            if Cache.WeaponMaterialBtn then
                Cache.WeaponMaterialBtn.Text = tostring(Config.WeaponMaterialStyle or Config.WeaponMaterial or "ForceField")
            end
            if Scope_UpdateFOV then pcall(Scope_UpdateFOV) end
            if Scope_UpdateDraw then pcall(Scope_UpdateDraw) end
            if UpdateFakeFpsDisplay then pcall(UpdateFakeFpsDisplay) end

            pcall(function()
                if ApplyWorldVisuals then ApplyWorldVisuals() end
            end)
            pcall(function()
                if Config.SelfTransparencyEnabled and SelfTransparency_Bind then
                    SelfTransparency_Bind()
                elseif SelfTransparency_Bind then
                    SelfTransparency_Bind()
                end
            end)
            pcall(function()
                if Config.NoShadowsEnabled then
                    Lighting.GlobalShadows = false
                end
            end)
        end)
        pcall(CfgIO.RebuildListUI)
    end

    function CfgIO.Load()
        if typeof(readfile) ~= "function" then
            Notify("Config", "readfile not available")
            return false
        end
        local name = nil
        if #CfgIO.List > 0 and CfgIO.List[CfgIO.Index] then
            name = CfgIO.List[CfgIO.Index]
        elseif CfgIO.NameBox and CfgIO.NameBox.Text ~= "" then
            name = SanitizeConfigName(CfgIO.NameBox.Text)
        elseif CfgIO.Current then
            name = SanitizeConfigName(CfgIO.Current)
        end
        if not name or name == "" then
            Notify("Config", "No config selected")
            return false
        end
        local content = select(1, readConfigFile(name))
        if not content then
            Notify("Config", "Failed to read: " .. tostring(name))
            return false
        end
        local okJson, data = pcall(function() return HttpService:JSONDecode(content) end)
        if not okJson or type(data) ~= "table" then
            Notify("Config", "Invalid JSON: " .. tostring(name))
            return false
        end
        if not ApplyLoadedConfig(data) then
            Notify("Config", "Apply failed: " .. tostring(name))
            return false
        end
        CfgIO.Current = name
        if CfgIO.NameBox then CfgIO.NameBox.Text = name end
        CfgIO.Remember(name)
        for i, n in ipairs(CfgIO.List) do
            if n == name then CfgIO.Index = i break end
        end
        postLoadApply(name)
        Notify("Config", "Loaded: " .. name)
        return true
    end

    function CfgIO.Delete()
        local name = nil
        if #CfgIO.List > 0 and CfgIO.List[CfgIO.Index] then
            name = CfgIO.List[CfgIO.Index]
        elseif CfgIO.NameBox and CfgIO.NameBox.Text ~= "" then
            name = SanitizeConfigName(CfgIO.NameBox.Text)
        end
        if not name or name == "" then
            Notify("Config", "No config to delete")
            return false
        end

        
        deleteConfigFile(name)

        
        for i = #CfgIO.List, 1, -1 do
            if CfgIO.List[i] == name then
                table.remove(CfgIO.List, i)
            end
        end
        writeIndex(CfgIO.List)

        if CfgIO.Index > #CfgIO.List then
            CfgIO.Index = math.max(1, #CfgIO.List)
        end
        if CfgIO.Index < 1 then CfgIO.Index = 1 end

        local nextName = (#CfgIO.List > 0 and CfgIO.List[CfgIO.Index]) or ""
        if CfgIO.NameBox then CfgIO.NameBox.Text = nextName end
        if CfgIO.Current == name then
            CfgIO.Current = nextName ~= "" and nextName or "default"
        end

        local last = CfgIO.GetLast()
        if last == name then
            if nextName ~= "" then
                CfgIO.Remember(nextName)
            else
                fsWrite(CfgIO.LastFile, "")
                fsWrite(CfgIO.LastFileAlt, "")
            end
        end

        
        pcall(CfgIO.RebuildListUI)

        
        CfgIO.RefreshList()
        pcall(CfgIO.RebuildListUI)

        ConfigList = CfgIO.List
        ConfigListIndex = CfgIO.Index
        CurrentConfigName = CfgIO.Current

        Notify("Config", "Deleted: " .. name)
        return true
    end


    local function setClipboardText(str)
        if type(str) ~= "string" or str == "" then return false end
        local ok = false
        pcall(function()
            if typeof(setclipboard) == "function" then setclipboard(str) ok = true end
        end)
        if ok then return true end
        pcall(function()
            if typeof(toclipboard) == "function" then toclipboard(str) ok = true end
        end)
        if ok then return true end
        pcall(function()
            if typeof(setrbxclipboard) == "function" then setrbxclipboard(str) ok = true end
        end)
        if ok then return true end
        pcall(function()
            if Clipboard and typeof(Clipboard.set) == "function" then Clipboard.set(str) ok = true end
        end)
        return ok
    end


    
    function CfgIO.CopyCode()
        local name = nil
        if #CfgIO.List > 0 and CfgIO.List[CfgIO.Index] then
            name = CfgIO.List[CfgIO.Index]
        elseif CfgIO.NameBox and CfgIO.NameBox.Text ~= "" then
            name = SanitizeConfigName(CfgIO.NameBox.Text)
        else
            name = SanitizeConfigName(CfgIO.Current or "default")
        end
        CfgIO.Current = name
        if CfgIO.NameBox then CfgIO.NameBox.Text = name end

        local json = nil
        
        local fileBody = select(1, readConfigFile(name))
        if fileBody and not isDeleted(fileBody) then
            json = fileBody
        else
            local okSer, ser = pcall(SerializeConfig)
            if okSer and type(ser) == "string" and #ser > 2 then
                json = ser
                if not json:find('"' .. CfgIO.Marker .. '"') and json:sub(1, 1) == "{" then
                    json = '{"' .. CfgIO.Marker .. '":true,' .. json:sub(2)
                end
            end
        end
        if not json or #json < 2 then
            Notify("Config", "Nothing to copy")
            return false
        end
        if setClipboardText(json) then
            Notify("Config", "Code copied (" .. name .. ") - upload to GitHub")
            return true
        end
        Notify("Config", "Clipboard not available on this executor")
        return false
    end


    
    local function githubRawUrls(url)
        local list = {}
        if type(url) ~= "string" then return list end
        url = url:gsub("^%s+", ""):gsub("%s+$", "")
        if url == "" then return list end

        local function add(u)
            if type(u) ~= "string" or u == "" then return end
            for _, e in ipairs(list) do if e == u then return end end
            list[#list + 1] = u
        end

        if url:find("raw%.githubusercontent%.com", 1) or url:find("gist%.githubusercontent%.com", 1) then
            add(url)
            return list
        end

        local owner, repo, branch, fpath = url:match("github%.com/([^/]+)/([^/]+)/blob/([^/]+)/(.+)")
        if owner then
            fpath = fpath:gsub("%?.*$", ""):gsub("#.*$", "")
            add("https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/" .. branch .. "/" .. fpath)
            add("https://cdn.jsdelivr.net/gh/" .. owner .. "/" .. repo .. "@" .. branch .. "/" .. fpath)
            return list
        end

        owner, repo, branch, fpath = url:match("github%.com/([^/]+)/([^/]+)/raw/([^/]+)/(.+)")
        if owner then
            fpath = fpath:gsub("%?.*$", ""):gsub("#.*$", "")
            add("https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/" .. branch .. "/" .. fpath)
            return list
        end

        owner, repo, fpath = url:match("raw%.githubusercontent%.com/([^/]+)/([^/]+)/refs/heads/(.+)")
        if owner then
            fpath = fpath:gsub("%?.*$", ""):gsub("#.*$", "")
            add("https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/refs/heads/" .. fpath)
            local b2, rest = fpath:match("^([^/]+)/(.+)$")
            if b2 and rest then
                add("https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/" .. b2 .. "/" .. rest)
            end
            return list
        end

        local gistUser, gistId = url:match("gist%.github%.com/([^/]+)/([a-fA-F0-9]+)")
        if gistId then
            add("https://gist.githubusercontent.com/" .. (gistUser or "anonymous") .. "/" .. gistId .. "/raw")
            return list
        end

        if url:match("^https?://") then
            add(url)
        end
        return list
    end

    local function httpGetBody(url)
        local reqFn = nil
        pcall(function()
            if typeof(request) == "function" then reqFn = request
            elseif typeof(http_request) == "function" then reqFn = http_request
            elseif syn and typeof(syn.request) == "function" then reqFn = syn.request
            elseif http and typeof(http.request) == "function" then reqFn = http.request
            end
        end)
        if reqFn then
            local ok, res = pcall(function()
                return reqFn({
                    Url = url,
                    Method = "GET",
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                        ["Accept"] = "application/json,text/plain,*/*",
                    },
                })
            end)
            if ok and type(res) == "table" then
                local body = res.Body or res.body or res.Data or res.data
                if type(body) == "string" and #body > 0 then return body end
            end
        end
        local ok2, body2 = pcall(function() return game:HttpGet(url) end)
        if ok2 and type(body2) == "string" then return body2 end
        return nil
    end

    local function parseConfigJson(body)
        if type(body) ~= "string" then return nil end
        body = body:gsub("^%s+", ""):gsub("%s+$", "")
        body = body:gsub("^```[%w]*%s*", ""):gsub("%s*```$", "")
        if body:sub(1, 3) == "\239\187\191" then body = body:sub(4) end
        local a = body:find("{", 1, true)
        local b = body:reverse():find("}", 1, true)
        if a and b then body = body:sub(a, #body - b + 1) end
        local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
        if ok and type(data) == "table" then return data end
        return nil
    end

    function CfgIO.LoadFromGitHub(url)
        url = url or (CfgIO.GitHubBox and CfgIO.GitHubBox.Text) or ""
        if type(url) ~= "string" then url = "" end
        url = url:gsub("^%s+", ""):gsub("%s+$", "")

        if url:sub(1, 1) == "{" then
            local data = parseConfigJson(url)
            if type(data) ~= "table" then
                Notify("GitHub", "Invalid JSON")
                return false
            end
            if not ApplyLoadedConfig(data) then
                Notify("GitHub", "Apply failed (not an Anxium config?)")
                return false
            end
            local name = SanitizeConfigName(
                (type(data.name) == "string" and data.name)
                or (CfgIO.NameBox and CfgIO.NameBox.Text)
                or "github"
            )
            if name == "" or name == "default" then name = "github" end
            CfgIO.Current = name
            if CfgIO.NameBox then CfgIO.NameBox.Text = name end
            postLoadApply(name)
            Notify("GitHub", "Loaded: " .. name)
            return true
        end

        local candidates = githubRawUrls(url)
        if not candidates or #candidates == 0 then
            Notify("GitHub", "Enter a public GitHub / raw link")
            return false
        end
        Notify("GitHub", "Downloading...")
        local body = nil
        for _, rawUrl in ipairs(candidates) do
            local got = httpGetBody(rawUrl)
            if type(got) == "string" and #got >= 5 then
                local head = got:sub(1, 200):lower()
                if not head:find("<!doctype") and not head:find("<html") then
                    body = got
                    break
                end
            end
        end
        if type(body) ~= "string" or #body < 5 then
            Notify("GitHub", "Download failed (private repo / bad link)")
            return false
        end
        local data = parseConfigJson(body)
        if type(data) ~= "table" then
            Notify("GitHub", "Invalid config JSON")
            return false
        end
        if not ApplyLoadedConfig(data) then
            Notify("GitHub", "Apply failed (not an Anxium config?)")
            return false
        end
        local name = SanitizeConfigName(
            (type(data.name) == "string" and data.name)
            or (CfgIO.NameBox and CfgIO.NameBox.Text)
            or "github"
        )
        if name == "" or name == "default" then name = "github" end
        CfgIO.Current = name
        if CfgIO.NameBox then CfgIO.NameBox.Text = name end
        pcall(function()
            if typeof(writefile) == "function" then
                local okSer, json = pcall(SerializeConfig)
                if okSer and json then
                    writeConfigFile(name, json)
                    local found = false
                    for _, n in ipairs(CfgIO.List) do if n == name then found = true break end end
                    if not found then table.insert(CfgIO.List, name) end
                    table.sort(CfgIO.List)
                    for i, n in ipairs(CfgIO.List) do if n == name then CfgIO.Index = i break end end
                    writeIndex(CfgIO.List)
                    CfgIO.Remember(name)
                    CfgIO.RefreshList()
                end
            end
        end)
        postLoadApply(name)
        Notify("GitHub", "Loaded: " .. name)
        return true
    end

    function CfgIO.Create()
        local rawName = ""
        if CfgIO.NameBox and type(CfgIO.NameBox.Text) == "string" then
            rawName = CfgIO.NameBox.Text
        end
        if rawName == "" then
            Notify("Config", "Enter a name first")
            return false
        end
        local name = SanitizeConfigName(rawName)
        CfgIO.Current = name
        if CfgIO.NameBox then CfgIO.NameBox.Text = name end
        
        local ok = CfgIO.Save()
        if ok then
            Notify("Config", "Created: " .. name)
        end
        return ok
    end

    
    RefreshConfigList = function() return CfgIO.RefreshList() end
    RebuildConfigListUI = function() return CfgIO.RebuildListUI() end
    SaveCurrentConfig = function() return CfgIO.Save() end
    LoadSelectedConfig = function() return CfgIO.Load() end
    DeleteSelectedConfig = function() return CfgIO.Delete() end
    IsDeletedConfigContent = isDeleted
    ReadConfigFile = readConfigFile
    WriteIndex = writeIndex
end


ConfigList = CfgIO.List
ConfigListIndex = 1
CurrentConfigName = "default"
ConfigNameBox = nil
ConfigSelectBtn = nil
ConfigListFrame = nil


do
    for _, child in ipairs(ConfigsTab:GetChildren()) do
        if child:IsA("GuiObject") then
            local n = child.Name
            if n == "ConfigNameRow" or n == "ConfigSelectRow" or n == "ConfigBtnRow"
                or n == "ConfigListRow" or n == "ConfigSection"
                or n == "GitHubRow" or n == "GitHubBtnRow" then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

CreateSectionHeader("- Config -", 1, ConfigsTab)

do
    local NameRow = Instance.new("Frame")
    NameRow.Name = "ConfigNameRow"
    NameRow.Size = UDim2.new(0.96, 0, 0, 40)
    NameRow.BackgroundColor3 = Theme.BgSecondary
    NameRow.BackgroundTransparency = 0.45
    NameRow.BorderSizePixel = 0
    NameRow.LayoutOrder = 2
    NameRow.Parent = ResolveUIParent(ConfigsTab)
    local nc = Instance.new("UIStroke")
    nc.Color = Theme.Stroke
    nc.Thickness = 1
    nc.Transparency = 0.2
    nc.Parent = NameRow
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(0.4, 0, 1, 0)
    nl.Position = UDim2.new(0, 12, 0, 0)
    nl.BackgroundTransparency = 1
    nl.Text = "Name"
    nl.TextColor3 = Theme.Text
    nl.TextSize = 12
    nl.Font = SelectedFont
    nl.TextXAlignment = Enum.TextXAlignment.Left
    nl.Parent = NameRow
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 160, 0, 26)
    box.Position = UDim2.new(1, -172, 0.5, -13)
    box.BackgroundColor3 = Theme.BgTertiary
    box.BorderSizePixel = 0
    box.Text = CfgIO.Current or "default"
    box.PlaceholderText = "new config name..."
    box.TextColor3 = Theme.Text
    box.PlaceholderColor3 = Theme.TextDim
    box.TextSize = 12
    box.Font = SelectedFont
    box.ClearTextOnFocus = false
    box.Parent = NameRow
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Theme.Stroke
    boxStroke.Thickness = 1
    boxStroke.Transparency = 0.15
    boxStroke.Parent = box
    CfgIO.NameBox = box
    ConfigNameBox = box
end

do
    local ListRow = Instance.new("Frame")
    ListRow.Name = "ConfigListRow"
    ListRow.Size = UDim2.new(0.96, 0, 0, 168)
    ListRow.BackgroundColor3 = Theme.BgSecondary
    ListRow.BackgroundTransparency = 0.45
    ListRow.BorderSizePixel = 0
    ListRow.LayoutOrder = 3
    ListRow.ClipsDescendants = true
    ListRow.Parent = ResolveUIParent(ConfigsTab)
    local lc = Instance.new("UIStroke")
    lc.Color = Theme.Stroke
    lc.Thickness = 1
    lc.Transparency = 0.2
    lc.Parent = ListRow

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -16, 0, 22)
    header.Position = UDim2.new(0, 12, 0, 4)
    header.BackgroundTransparency = 1
    header.Text = "Saved configs"
    header.TextColor3 = Theme.Text
    header.TextSize = 12
    header.Font = SelectedFont
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = ListRow

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "ConfigListScroll"
    scroll.Size = UDim2.new(1, -16, 1, -30)
    scroll.Position = UDim2.new(0, 8, 0, 26)
    scroll.BackgroundColor3 = Theme.BgTertiary
    scroll.BackgroundTransparency = 0.15
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Theme.Accent
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = ListRow
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 4)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = scroll
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)
    pad.Parent = scroll
    CfgIO.ListFrame = scroll
    ConfigListFrame = scroll

    local hidden = Instance.new("TextButton")
    hidden.Visible = false
    hidden.Size = UDim2.new(0, 1, 0, 1)
    hidden.Text = "(no configs)"
    hidden.Parent = ListRow
    CfgIO.SelectBtn = hidden
    ConfigSelectBtn = hidden
end

do
    local BtnRow = Instance.new("Frame")
    BtnRow.Name = "ConfigBtnRow"
    BtnRow.Size = UDim2.new(0.96, 0, 0, 74)
    BtnRow.BackgroundTransparency = 1
    BtnRow.BorderSizePixel = 0
    BtnRow.LayoutOrder = 5
    BtnRow.Parent = ResolveUIParent(ConfigsTab)

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0.32, -4, 0, 32)
    grid.CellPadding = UDim2.new(0.02, 0, 0, 5)
    grid.FillDirection = Enum.FillDirection.Horizontal
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Left
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = BtnRow

    local function MakeCfgBtn(text, order, color, callback, iconId)
        local b = Instance.new("TextButton")
        b.BackgroundColor3 = color
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = true
        b.LayoutOrder = order
        b.Parent = BtnRow
        local outline = Instance.new("UIStroke")
        outline.Color = Theme.Stroke
        outline.Thickness = 1
        outline.Transparency = 0.15
        outline.Parent = b
        if iconId and iconId ~= "" then
            local ic = Instance.new("ImageLabel")
            ic.Name = "Icon"
            ic.BackgroundTransparency = 1
            ic.Size = UDim2.fromOffset(14, 14)
            ic.Position = UDim2.new(0, 10, 0.5, -7)
            ic.Image = iconId
            ic.ScaleType = Enum.ScaleType.Fit
            ic.Parent = b
        end
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Label"
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, iconId and -30 or -12, 1, 0)
        lbl.Position = UDim2.new(0, iconId and 28 or 6, 0, 0)
        lbl.Text = text
        lbl.TextColor3 = Theme.Text
        lbl.TextSize = 12
        lbl.Font = SelectedFont
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.Parent = b
        b.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
        return b
    end

    MakeCfgBtn("Save", 1, Theme.BgSecondary, function() CfgIO.Save() end, "rbxassetid://122894934359450")
    MakeCfgBtn("Create", 2, Theme.BgSecondary, function() CfgIO.Create() end, "rbxassetid://74194167957081")
    MakeCfgBtn("Load", 3, Theme.BgSecondary, function() CfgIO.Load() end, "rbxassetid://132295854994374")
    MakeCfgBtn("Rename", 4, Theme.BgSecondary, function() CfgIO.Rename() end, "rbxassetid://82156880342025")
    MakeCfgBtn("Code", 5, Theme.Accent, function() CfgIO.CopyCode() end, "rbxassetid://75851496262862")
    MakeCfgBtn("Delete", 6, Color3.fromRGB(90, 40, 45), function() CfgIO.Delete() end, "rbxassetid://115678228554812")
end


do
    CreateSectionHeader("- GitHub configs -", 6, ConfigsTab)

    local PbRow = Instance.new("Frame")
    PbRow.Name = "GitHubRow"
    PbRow.Size = UDim2.new(0.96, 0, 0, 36)
    PbRow.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
    PbRow.BackgroundTransparency = 0.15
    PbRow.BorderSizePixel = 0
    PbRow.ClipsDescendants = true
    PbRow.LayoutOrder = 7
    PbRow.Parent = ResolveUIParent(ConfigsTab)
    local pbc = Instance.new("UIStroke")
    pbc.Color = Theme.Stroke
    pbc.Thickness = 1
    pbc.Transparency = 0.2
    pbc.Parent = PbRow

    local pbLabel = Instance.new("TextLabel")
    pbLabel.Size = UDim2.new(0, 36, 1, 0)
    pbLabel.Position = UDim2.new(0, 10, 0, 0)
    pbLabel.BackgroundTransparency = 1
    pbLabel.Text = "URL"
    pbLabel.TextColor3 = Theme.TextDim
    pbLabel.TextSize = 11
    pbLabel.Font = SelectedFont
    pbLabel.TextXAlignment = Enum.TextXAlignment.Left
    pbLabel.Parent = PbRow

    local pbBox = Instance.new("TextBox")
    pbBox.Name = "GitHubBox"
    
    pbBox.Size = UDim2.new(1, -58, 0, 24)
    pbBox.Position = UDim2.new(0, 46, 0.5, -12)
    pbBox.BackgroundColor3 = Theme.BgTertiary
    pbBox.BorderSizePixel = 0
    pbBox.ClipsDescendants = true
    pbBox.Text = ""
    pbBox.PlaceholderText = "github.com/.../config.json"
    pbBox.TextColor3 = Theme.Text
    pbBox.PlaceholderColor3 = Theme.TextDim
    pbBox.TextSize = 11
    pbBox.Font = SelectedFont
    pbBox.TextXAlignment = Enum.TextXAlignment.Left
    pbBox.TextYAlignment = Enum.TextYAlignment.Center
    pbBox.ClearTextOnFocus = false
    pbBox.TextWrapped = false
    pcall(function()
        pbBox.TextTruncate = Enum.TextTruncate.AtEnd
    end)
    pbBox.Parent = PbRow
    
    local pbPad = Instance.new("UIPadding")
    pbPad.PaddingLeft = UDim.new(0, 8)
    pbPad.PaddingRight = UDim.new(0, 8)
    pbPad.Parent = pbBox
    CfgIO.GitHubBox = pbBox

    local PbBtnRow = Instance.new("Frame")
    PbBtnRow.Name = "GitHubBtnRow"
    PbBtnRow.Size = UDim2.new(0.96, 0, 0, 36)
    PbBtnRow.BackgroundTransparency = 1
    PbBtnRow.BorderSizePixel = 0
    PbBtnRow.LayoutOrder = 8
    PbBtnRow.Parent = ResolveUIParent(ConfigsTab)

    local loadPb = Instance.new("TextButton")
    loadPb.Size = UDim2.new(0, 150, 0, 28)
    loadPb.Position = UDim2.new(0, 0, 0.5, -14)
    loadPb.BackgroundColor3 = Theme.Accent
    loadPb.BorderSizePixel = 0
    loadPb.Text = ""
    loadPb.AutoButtonColor = true
    loadPb.Parent = PbBtnRow
    local lpc = Instance.new("UIStroke")
    lpc.Color = Theme.Stroke
    lpc.Thickness = 1
    lpc.Transparency = 0.15
    lpc.Parent = loadPb
    local ghIcon = Instance.new("ImageLabel")
    ghIcon.Name = "Icon"
    ghIcon.BackgroundTransparency = 1
    ghIcon.Size = UDim2.fromOffset(15, 15)
    ghIcon.Position = UDim2.new(0, 10, 0.5, -7.5)
    ghIcon.Image = "rbxassetid://140138081031269"
    ghIcon.ScaleType = Enum.ScaleType.Fit
    ghIcon.Parent = loadPb
    local ghLbl = Instance.new("TextLabel")
    ghLbl.Name = "Label"
    ghLbl.BackgroundTransparency = 1
    ghLbl.Size = UDim2.new(1, -30, 1, 0)
    ghLbl.Position = UDim2.new(0, 28, 0, 0)
    ghLbl.Text = "Load from GitHub"
    ghLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    ghLbl.TextSize = 12
    ghLbl.Font = SelectedFont
    ghLbl.TextXAlignment = Enum.TextXAlignment.Left
    ghLbl.TextYAlignment = Enum.TextYAlignment.Center
    ghLbl.Parent = loadPb
    pcall(function() TrackThemeAccent(loadPb, "BackgroundColor3") end)
    loadPb.MouseButton1Click:Connect(function()
        pcall(function()
            if CfgIO.LoadFromGitHub then
                CfgIO.LoadFromGitHub(CfgIO.GitHubBox and CfgIO.GitHubBox.Text)
            end
        end)
    end)

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -160, 1, 0)
    hint.Position = UDim2.new(0, 160, 0, 0)
    hint.BackgroundTransparency = 1
    hint.Text = "Public GitHub blob/raw JSON link"
    hint.TextColor3 = Theme.TextDim
    hint.TextSize = 10
    hint.Font = SelectedFont
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Parent = PbBtnRow
end




LuaIO = {
    Folder = "AnxiumHubScripts",
    IndexFile = "AnxiumHubScripts/_index.json",
    Scripts = {}, 
    Order = {},
    ListFrame = nil,
    GitHubBox = nil,
    RowButtons = {},
}

function LuaIO_EnsureFolder()
    pcall(function()
        if typeof(makefolder) == "function" then
            makefolder(LuaIO.Folder)
        end
    end)
end

function LuaIO_SanitizeName(name)
    name = tostring(name or "script"):gsub("[^%w%._%-]", "_")
    if name == "" then name = "script" end
    if not name:lower():find("%.lua$") then
        
    end
    return name
end

function LuaIO_NameFromUrl(url)
    url = tostring(url or "")
    local file = url:match("([^/]+)$") or "script.lua"
    file = file:gsub("%?.*$", ""):gsub("#.*$", "")
    if file == "" then file = "script.lua" end
    return LuaIO_SanitizeName(file)
end

function LuaIO_GithubRawUrls(url)
    url = tostring(url or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local list, seen = {}, {}
    local function add(u)
        if u and u ~= "" and not seen[u] then
            seen[u] = true
            list[#list + 1] = u
        end
    end
    if url == "" then return list end
    if url:find("raw%.githubusercontent%.com", 1) or url:find("gist%.githubusercontent%.com", 1) then
        add(url)
        return list
    end
    local owner, repo, branch, fpath = url:match("github%.com/([^/]+)/([^/]+)/blob/([^/]+)/(.+)")
    if owner then
        add("https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/" .. branch .. "/" .. fpath)
    end
    owner, repo, branch, fpath = url:match("github%.com/([^/]+)/([^/]+)/raw/([^/]+)/(.+)")
    if owner then
        add("https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/" .. branch .. "/" .. fpath)
    end
    local gistUser, gistId = url:match("gist%.github%.com/([^/]+)/([a-fA-F0-9]+)")
    if gistId then
        add("https://gist.githubusercontent.com/" .. (gistUser or "anonymous") .. "/" .. gistId .. "/raw")
    end
    add(url)
    return list
end

function LuaIO_HttpGet(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and #body > 0 then return body end
    return nil
end

function LuaIO_SaveIndex()
    LuaIO_EnsureFolder()
    local meta = {}
    for _, n in ipairs(LuaIO.Order) do
        local e = LuaIO.Scripts[n]
        meta[#meta + 1] = {
            name = n,
            loadedAt = (e and e.loadedAt) or os.time(),
        }
    end
    local payload = HttpService:JSONEncode(meta)
    pcall(function()
        if writefile then writefile(LuaIO.IndexFile, payload) end
    end)
    for name, entry in pairs(LuaIO.Scripts) do
        if entry and entry.source then
            pcall(function()
                if writefile then
                    writefile(LuaIO.Folder .. "/" .. name, entry.source)
                end
            end)
        end
    end
end

function LuaIO_LoadIndex()
    LuaIO_EnsureFolder()
    local raw = nil
    pcall(function()
        if readfile and isfile and isfile(LuaIO.IndexFile) then
            raw = readfile(LuaIO.IndexFile)
        elseif readfile then
            raw = readfile(LuaIO.IndexFile)
        end
    end)
    if type(raw) ~= "string" or raw == "" then return end
    local ok, arr = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(arr) ~= "table" then return end
    for _, item in ipairs(arr) do
        local name, loadedAt = nil, os.time()
        if type(item) == "string" then
            name = item
        elseif type(item) == "table" then
            name = item.name or item[1]
            loadedAt = tonumber(item.loadedAt) or os.time()
        end
        if not name then continue end
        name = LuaIO_SanitizeName(name)
        if not LuaIO.Scripts[name] then
            local src = nil
            pcall(function()
                if readfile then src = readfile(LuaIO.Folder .. "/" .. name) end
            end)
            if type(src) == "string" and #src > 0 then
                LuaIO.Scripts[name] = {
                    name = name,
                    source = src,
                    running = false,
                    stop = false,
                    thread = nil,
                    loadedAt = loadedAt,
                }
                LuaIO.Order[#LuaIO.Order + 1] = name
            end
        end
    end
end

function LuaIO_FormatDate(ts)
    ts = tonumber(ts) or os.time()
    local ok, s = pcall(function()
        return os.date("%d.%m.%Y %H:%M:%S", ts)
    end)
    if ok and s then return tostring(s) end
    return tostring(ts)
end

function LuaIO_AddScript(name, source)
    name = LuaIO_SanitizeName(name)
    local isNew = LuaIO.Scripts[name] == nil
    local prev = LuaIO.Scripts[name]
    local loadedAt = (prev and prev.loadedAt) or os.time()
    if isNew then loadedAt = os.time() end
    LuaIO.Scripts[name] = {
        name = name,
        source = source,
        running = (prev and prev.running) or false,
        stop = false,
        thread = prev and prev.thread or nil,
        loadedAt = loadedAt,
        connections = prev and prev.connections or {},
        threads = prev and prev.threads or {},
        instances = prev and prev.instances or {},
        drawings = prev and prev.drawings or {},
    }
    if isNew then
        LuaIO.Order[#LuaIO.Order + 1] = name
    end
    LuaIO_SaveIndex()
    return name
end

function LuaIO_Remove(name)
    name = LuaIO_SanitizeName(name)
    if LuaIO.Scripts[name] and LuaIO.Scripts[name].running then
        LuaIO_Stop(name)
    end
    LuaIO.Scripts[name] = nil
    for i = #LuaIO.Order, 1, -1 do
        if LuaIO.Order[i] == name then table.remove(LuaIO.Order, i) end
    end
    pcall(function()
        if delfile then delfile(LuaIO.Folder .. "/" .. name) end
    end)
    LuaIO_SaveIndex()
    LuaIO_RebuildListUI()
end

function LuaIO_Start(name)
    name = LuaIO_SanitizeName(name)
    local entry = LuaIO.Scripts[name]
    if not entry or type(entry.source) ~= "string" then
        Notify("Scripts", "Script not found")
        return
    end
    if entry.running then return end

    entry.stop = false
    entry.running = true
    entry.connections = nil
    entry.threads = nil
    entry.instances = nil
    entry.drawings = nil

    pcall(LuaIO_UpdateRow, name)
    pcall(LuaIO_RebuildListUI)

    local src = entry.source
    
    entry.thread = task.spawn(function()
        local compiled, cerr = loadstring(src)
        if not compiled then
            entry.running = false
            entry.thread = nil
            Notify("Scripts", "Compile error: " .. tostring(cerr))
            pcall(LuaIO_UpdateRow, name)
            pcall(LuaIO_RebuildListUI)
            return
        end
        local ok, runtimeErr = pcall(compiled)
        entry.thread = nil
        if not ok then
            entry.running = false
            Notify("Scripts", name .. " error: " .. tostring(runtimeErr))
            pcall(LuaIO_UpdateRow, name)
            pcall(LuaIO_RebuildListUI)
            return
        end
        
    end)
    Notify("Scripts", "Started: " .. name)
end

function LuaIO_Stop(name)
    
    name = LuaIO_SanitizeName(name)
    local entry = LuaIO.Scripts[name]
    if not entry then return end
    Notify("Scripts", "Stop disabled - rejoin to unload")
end

function LuaIO_UpdateRow(name)
    name = LuaIO_SanitizeName(name)
    local entry = LuaIO.Scripts[name]
    if not entry or not LuaIO.ListFrame then return end
    local running = entry.running == true
    local dateStr = LuaIO_FormatDate(entry.loadedAt or os.time())
    for _, row in ipairs(LuaIO.ListFrame:GetChildren()) do
        if row:IsA("Frame") and row.Name == "LuaScriptRow" then
            local match = false
            for _, d in ipairs(row:GetChildren()) do
                if d:IsA("TextLabel") and d.Text == name then match = true break end
            end
            if not match then continue end
            local dateVal = row:FindFirstChild("DateValue")
            if dateVal then
                dateVal.Text = dateStr
                dateVal.TextColor3 = Theme.Accent or Color3.fromRGB(180, 140, 255)
            end
            local btn = row:FindFirstChild("RunBtn")
            if btn then
                btn.Visible = true
                local lbl = btn:FindFirstChild("BtnLabel") or btn:FindFirstChildWhichIsA("TextLabel")
                local ic = btn:FindFirstChild("Icon")
                if running then
                    btn.AutoButtonColor = false
                    btn.Active = false
                    btn.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
                    if lbl then lbl.Text = "Loaded" end
                    if ic then ic.ImageTransparency = 0.45 end
                else
                    btn.AutoButtonColor = true
                    btn.Active = true
                    btn.BackgroundColor3 = Theme.Accent or Color3.fromRGB(180, 140, 255)
                    if lbl then lbl.Text = "Start" end
                    if ic then
                        ic.Image = "rbxassetid://76386816441302"
                        ic.ImageTransparency = 0
                    end
                end
            end
            return
        end
    end
end

function LuaIO_LoadFromGitHub(url)
    url = tostring(url or (LuaIO.GitHubBox and LuaIO.GitHubBox.Text) or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if url == "" then
        Notify("Scripts", "Enter a GitHub / raw .lua link")
        return
    end
    local candidates = LuaIO_GithubRawUrls(url)
    Notify("Scripts", "Downloading...")
    local body, used = nil, nil
    for _, u in ipairs(candidates) do
        body = LuaIO_HttpGet(u)
        if body then used = u break end
    end
    if not body then
        Notify("Scripts", "Download failed (private / bad link)")
        return
    end
    local name = LuaIO_NameFromUrl(used or url)
    
    local fromOrig = LuaIO_NameFromUrl(url)
    if fromOrig and fromOrig ~= "script" then name = fromOrig end
    LuaIO_AddScript(name, body)
    Notify("Scripts", "Added: " .. name)
    LuaIO_RebuildListUI()
end

function LuaIO_RebuildListUI()
    local frame = LuaIO.ListFrame
    if not frame then return end
    for _, ch in ipairs(frame:GetChildren()) do
        if ch.Name == "LuaScriptRow" or ch.Name == "LuaEmptyLabel" then
            pcall(function() ch:Destroy() end)
        end
    end
    LuaIO.RowButtons = {}
    
    pcall(function()
        local alive = {}
        for _, e in ipairs(Cache.ThemeAccentTracked or {}) do
            if e.inst and e.inst.Parent then
                alive[#alive + 1] = e
            end
        end
        Cache.ThemeAccentTracked = alive
    end)
    if #LuaIO.Order == 0 then
        local empty = Instance.new("TextLabel")
        empty.Name = "LuaEmptyLabel"
        empty.Size = UDim2.new(1, -8, 0, 28)
        empty.BackgroundTransparency = 1
        empty.Text = "No scripts - load from GitHub"
        empty.TextColor3 = Theme.TextDim
        empty.TextSize = 12
        empty.Font = SelectedFont
        empty.LayoutOrder = 0
        empty.Parent = frame
        return
    end
    for i, name in ipairs(LuaIO.Order) do
        local entry = LuaIO.Scripts[name]
        if not entry then continue end
        local running = entry.running == true

        local accent = Theme.Accent or Color3.fromRGB(180, 140, 255)
        local cardCol = LuaIO_CardColorFromAccent(accent)
        local row = Instance.new("Frame")
        row.Name = "LuaScriptRow"
        row.Size = UDim2.new(1, 0, 0, 48)
        row.BackgroundColor3 = cardCol
        row.BackgroundTransparency = 0.15
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        row.Parent = frame
        pcall(function() TrackThemeAccent(row, "LuaCardBg") end)
        do
            local st = Instance.new("UIStroke")
            st.Color = accent
            st.Thickness = 1
            st.Transparency = 0.65
            st.Parent = row
            pcall(function() TrackThemeAccent(st, "Color") end)
        end

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, -110, 0, 20)
        title.Position = UDim2.fromOffset(12, 5)
        title.Font = SelectedFont
        title.TextSize = 13
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Text = name
        title.Parent = row

        local datePrefix = Instance.new("TextLabel")
        datePrefix.Name = "DatePrefix"
        datePrefix.BackgroundTransparency = 1
        datePrefix.AutomaticSize = Enum.AutomaticSize.X
        datePrefix.Size = UDim2.new(0, 0, 0, 16)
        datePrefix.Position = UDim2.fromOffset(12, 26)
        datePrefix.Font = SelectedFont
        datePrefix.TextSize = 11
        datePrefix.TextColor3 = Color3.fromRGB(150, 152, 160)
        datePrefix.TextXAlignment = Enum.TextXAlignment.Left
        datePrefix.Text = "upload date: "
        datePrefix.Parent = row

        local dateVal = Instance.new("TextLabel")
        dateVal.Name = "DateValue"
        dateVal.BackgroundTransparency = 1
        dateVal.Size = UDim2.new(1, -120, 0, 16)
        dateVal.Position = UDim2.fromOffset(88, 26)
        dateVal.Font = SelectedFont
        dateVal.TextSize = 11
        dateVal.TextColor3 = accent
        dateVal.TextXAlignment = Enum.TextXAlignment.Left
        dateVal.Text = LuaIO_FormatDate(entry.loadedAt or os.time())
        dateVal.Parent = row
        pcall(function() TrackThemeAccent(dateVal, "TextColor3") end)
        pcall(function()
            local function syncDatePos()
                local w = datePrefix.TextBounds.X
                if w < 4 then w = 72 end
                dateVal.Position = UDim2.fromOffset(12 + w + 2, 26)
            end
            datePrefix:GetPropertyChangedSignal("TextBounds"):Connect(syncDatePos)
            task.defer(syncDatePos)
        end)

        local btn = Instance.new("TextButton")
        btn.Name = "RunBtn"
        btn.Size = UDim2.fromOffset(88, 28)
        btn.Position = UDim2.new(1, -96, 0.5, -14)
        btn.BackgroundColor3 = running and Color3.fromRGB(40, 42, 50) or Theme.Accent
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = not running
        btn.Active = not running
        btn.Parent = row
        if not running then
            pcall(function() TrackThemeAccent(btn, "BackgroundColor3") end)
        end

        local ic = Instance.new("ImageLabel")
        ic.Name = "Icon"
        ic.BackgroundTransparency = 1
        ic.Size = UDim2.fromOffset(14, 14)
        ic.Position = UDim2.new(0, 8, 0.5, -7)
        ic.Image = "rbxassetid://76386816441302"
        ic.ImageTransparency = running and 0.45 or 0
        ic.ScaleType = Enum.ScaleType.Fit
        ic.ZIndex = 2
        ic.Parent = btn

        local lbl = Instance.new("TextLabel")
        lbl.Name = "BtnLabel"
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, -28, 1, 0)
        lbl.Position = UDim2.fromOffset(26, 0)
        lbl.Font = SelectedFont
        lbl.TextSize = 12
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.Text = running and "Loaded" or "Start"
        lbl.ZIndex = 2
        lbl.Parent = btn

        btn.MouseButton1Click:Connect(function()
            if not entry.running then
                LuaIO_Start(name)
            end
        end)

        
        local del = Instance.new("TextButton")
        del.Name = "DeleteBtn"
        del.Size = UDim2.fromOffset(28, 28)
        del.Position = UDim2.new(1, -128, 0.5, -14)
        del.BackgroundColor3 = Theme.BgSecondary
        del.BorderSizePixel = 0
        del.Text = ""
        del.AutoButtonColor = true
        del.Parent = row
        local delIcon = Instance.new("ImageLabel")
        delIcon.Name = "Icon"
        delIcon.BackgroundTransparency = 1
        delIcon.Size = UDim2.fromOffset(14, 14)
        delIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
        delIcon.Image = "rbxassetid://126010725826757"
        delIcon.ScaleType = Enum.ScaleType.Fit
        delIcon.Parent = del
        del.MouseButton1Click:Connect(function()
            LuaIO_Remove(name)
        end)

        LuaIO.RowButtons[name] = btn
    end
end

do
    CreateSectionHeader("- Lua Scripts -", 1, ScriptsTab)

    local PbRow = Instance.new("Frame")
    PbRow.Name = "LuaGitHubRow"
    PbRow.Size = UDim2.new(1, -8, 0, 36)
    PbRow.BackgroundColor3 = Theme.Card
    PbRow.BackgroundTransparency = 0
    PbRow.BorderSizePixel = 0
    PbRow.ClipsDescendants = true
    PbRow.LayoutOrder = 2
    PbRow.Parent = ResolveUIParent(ScriptsTab)

    local pbLabel = Instance.new("TextLabel")
    pbLabel.Size = UDim2.new(0, 36, 1, 0)
    pbLabel.Position = UDim2.fromOffset(10, 0)
    pbLabel.BackgroundTransparency = 1
    pbLabel.Text = "URL"
    pbLabel.TextColor3 = Theme.TextDim
    pbLabel.TextSize = 11
    pbLabel.Font = SelectedFont
    pbLabel.TextXAlignment = Enum.TextXAlignment.Left
    pbLabel.Parent = PbRow

    local pbBox = Instance.new("TextBox")
    pbBox.Name = "LuaGitHubBox"
    pbBox.Size = UDim2.new(1, -58, 0, 24)
    pbBox.Position = UDim2.new(0, 46, 0.5, -12)
    pbBox.BackgroundTransparency = 1
    pbBox.BorderSizePixel = 0
    pbBox.ClipsDescendants = true
    pbBox.Text = ""
    pbBox.PlaceholderText = "github.com/.../script.lua"
    pbBox.TextColor3 = Theme.Text
    pbBox.PlaceholderColor3 = Theme.TextDim
    pbBox.TextSize = 11
    pbBox.Font = SelectedFont
    pbBox.TextXAlignment = Enum.TextXAlignment.Left
    pbBox.ClearTextOnFocus = false
    pbBox.Parent = PbRow
    LuaIO.GitHubBox = pbBox

    local PbBtnRow = Instance.new("Frame")
    PbBtnRow.Size = UDim2.new(1, -8, 0, 36)
    PbBtnRow.BackgroundTransparency = 1
    PbBtnRow.LayoutOrder = 3
    PbBtnRow.Parent = ResolveUIParent(ScriptsTab)

    local loadPb = Instance.new("TextButton")
    loadPb.Size = UDim2.new(0, 150, 0, 28)
    loadPb.Position = UDim2.new(0, 0, 0.5, -14)
    loadPb.BackgroundColor3 = Theme.Accent
    loadPb.BorderSizePixel = 0
    loadPb.Text = ""
    loadPb.AutoButtonColor = true
    loadPb.Parent = PbBtnRow
    local ghIcon = Instance.new("ImageLabel")
    ghIcon.BackgroundTransparency = 1
    ghIcon.Size = UDim2.fromOffset(15, 15)
    ghIcon.Position = UDim2.new(0, 10, 0.5, -7.5)
    ghIcon.Image = "rbxassetid://140138081031269"
    ghIcon.ScaleType = Enum.ScaleType.Fit
    ghIcon.Parent = loadPb
    local ghLbl = Instance.new("TextLabel")
    ghLbl.BackgroundTransparency = 1
    ghLbl.Size = UDim2.new(1, -30, 1, 0)
    ghLbl.Position = UDim2.fromOffset(28, 0)
    ghLbl.Text = "Load from GitHub"
    ghLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    ghLbl.TextSize = 12
    ghLbl.Font = SelectedFont
    ghLbl.TextXAlignment = Enum.TextXAlignment.Left
    ghLbl.Parent = loadPb
    pcall(function() TrackThemeAccent(loadPb, "BackgroundColor3") end)
    loadPb.MouseButton1Click:Connect(function()
        pcall(LuaIO_LoadFromGitHub)
    end)

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -160, 1, 0)
    hint.Position = UDim2.fromOffset(160, 0)
    hint.BackgroundTransparency = 1
    hint.Text = "Public GitHub blob/raw .lua link"
    hint.TextColor3 = Theme.TextDim
    hint.TextSize = 10
    hint.Font = SelectedFont
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Parent = PbBtnRow

    CreateSectionHeader("- My Scripts -", 4, ScriptsTab)

    local ListRow = Instance.new("Frame")
    ListRow.Name = "LuaListRow"
    ListRow.Size = UDim2.new(1, -8, 0, 220)
    ListRow.BackgroundTransparency = 1
    ListRow.BorderSizePixel = 0
    ListRow.LayoutOrder = 5
    ListRow.Parent = ResolveUIParent(ScriptsTab)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.Position = UDim2.fromOffset(0, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Theme.Accent
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = ListRow
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 6)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = scroll
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 0)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 0)
    pad.PaddingRight = UDim.new(0, 0)
    pad.Parent = scroll
    LuaIO.ListFrame = scroll
end

task.spawn(function()
    task.wait(0.15)
    pcall(LuaIO_LoadIndex)
    pcall(LuaIO_RebuildListUI)
end)


task.spawn(function()
    for _ = 1, 12 do
        task.wait(0.08)
        EnsureConfigFolder()
        if typeof(writefile) == "function" or typeof(readfile) == "function" then
            break
        end
    end
    EnsureConfigFolder()
    CfgIO.RefreshList()
    pcall(CfgIO.RebuildListUI)
end)

task.defer(function()
    task.wait(0.5)
    CfgIO.RefreshList()
    pcall(CfgIO.RebuildListUI)
end)


MenuOpen = false
local MenuAnimationId = 0
local MenuActiveTweens = {}

local function CancelMenuTweens()
    for _, tween in ipairs(MenuActiveTweens) do
        pcall(function() tween:Cancel() end)
    end
    table.clear(MenuActiveTweens)
end

local function PlayMenuTween(object, info, properties)
    local tween = TweenService:Create(object, info, properties)
    table.insert(MenuActiveTweens, tween)
    tween:Play()
    return tween
end

function SetMenuOpen(open)
    MenuOpen = open and true or false
    MenuAnimationId += 1
    local animationId = MenuAnimationId
    CancelMenuTweens()

    pcall(function()
        if Cache.AnxiumOpenListFrame then
            AnxiumSetListOpen(Cache.AnxiumOpenListFrame, false)
        end
        if Cache.AnxiumListShell then
            Cache.AnxiumListShell.Visible = false
        end
    end)

    if MenuOpen then
        pcall(function()
            Cache.AnxiumOpenListFrame = nil
            Cache.AnxiumOpenListAnchor = nil
        end)

        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 720, 0, 480)
        pcall(function()
            MainFrame.GroupTransparency = 1
        end)
        BlurGradientOverlayGradient.Color = ColorSequence.new(Config.Color_BlurGradientA or Color3.fromRGB(130, 70, 255), Config.Color_BlurGradientB or Color3.fromRGB(180, 140, 255))
        BlurGradientOverlay.Visible = Config.BlurGradientEnabled == true
        BlurGradientOverlay.BackgroundTransparency = 1

        local fadeIn = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        PlayMenuTween(MainFrame, fadeIn, {GroupTransparency = 0})
        PlayMenuTween(BlurEffect, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 18})
        if Config.BlurGradientEnabled then
            PlayMenuTween(BlurGradientOverlay, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = (Config.BlurGradientTransparency or 0.28)})
        end
        local function forceAllTabCanvas()
            pcall(function()
                for name, frame in pairs(TabFrames or {}) do
                    if frame and frame:IsA("ScrollingFrame") then
                        local total = 0
                        for _, child in ipairs(frame:GetChildren()) do
                            if child:IsA("GuiObject") and child.Visible and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                                local hh = child.Size.Y.Offset
                                if hh < 1 then hh = child.AbsoluteSize.Y end
                                if hh > 0 then total = total + hh + 16 end
                            end
                        end
                        local lay = frame:FindFirstChildOfClass("UIListLayout")
                        if lay and lay.AbsoluteContentSize.Y > total then
                            total = lay.AbsoluteContentSize.Y
                        end
                        frame.CanvasSize = UDim2.new(0, 0, 0, math.max(total + 48, 1))
                    end
                    local fn = Cache.TabCanvasRefresh and Cache.TabCanvasRefresh[name]
                    if fn then pcall(fn) end
                end
            end)
        end
        task.defer(forceAllTabCanvas)
        task.delay(0.1, forceAllTabCanvas)
        task.delay(0.35, forceAllTabCanvas)
    else
        pcall(function()
            Cache.AnxiumOpenListFrame = nil
            Cache.AnxiumOpenListAnchor = nil
        end)

        local fadeOut = TweenInfo.new(0.30, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        PlayMenuTween(MainFrame, fadeOut, {GroupTransparency = 1})
        PlayMenuTween(BlurEffect, TweenInfo.new(0.30, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = 0})
        PlayMenuTween(BlurGradientOverlay, TweenInfo.new(0.30, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})

        task.delay(0.31, function()
            if MenuAnimationId == animationId and not MenuOpen then
                MainFrame.Visible = false
                BlurGradientOverlay.Visible = false
                pcall(function()
                    MainFrame.GroupTransparency = 0
                end)
            end
        end)
    end
end

function ToggleMenu()
    SetMenuOpen(not MenuOpen)
end

if ToggleButton and ToggleButton.Parent then
    ToggleButton.MouseButton1Click:Connect(function()
        ToggleMenu()
    end)
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local keyCode = input.KeyCode
    if not keyCode or keyCode == Enum.KeyCode.Unknown then return end
    local menuKey = (Config.MenuKey and Config.MenuKey ~= "") and Config.MenuKey or "RightShift"
    if keyCode.Name == menuKey then
        
        if Cache.WaitingMenuKey or Cache.WaitingScopeKey or Cache.WaitingBindKey then return end
        ToggleMenu()
    end
end)

SwitchTab("Visuals")
pcall(UpdateFakeFpsDisplay)
task.spawn(function()
    for _ = 1, 8 do
        task.wait(0.15)
        pcall(function()
            for name, frame in pairs(TabFrames or {}) do
                if frame and frame:IsA("ScrollingFrame") then
                    local total = 0
                    for _, child in ipairs(frame:GetChildren()) do
                        if child:IsA("GuiObject") and child.Visible and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                            local hh = child.Size.Y.Offset
                            if hh < 1 then hh = child.AbsoluteSize.Y end
                            if hh > 0 then total = total + hh + 16 end
                        end
                    end
                    local lay = frame:FindFirstChildOfClass("UIListLayout")
                    if lay and lay.AbsoluteContentSize.Y > total then
                        total = lay.AbsoluteContentSize.Y
                    end
                    frame.CanvasSize = UDim2.new(0, 0, 0, math.max(total + 48, 1))
                end
            end
        end)
    end
end)

TriggerTargetHighlightAnimation = function(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local char = targetPlayer.Character

    if Cache.SelectedTargetHighlight and Cache.SelectedTargetHighlight.Parent then
        Cache.SelectedTargetHighlight:Destroy()
        Cache.SelectedTargetHighlight = nil
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "AnxiumSelectChams"
    highlight.Adornee = char
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Theme.Accent
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 1
    highlight.Enabled = true
    highlight.Parent = char
    Cache.SelectedTargetHighlight = highlight

    local tweenIn = TweenService:Create(highlight, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        FillTransparency = 0.35,
        OutlineTransparency = 0
    })
    tweenIn:Play()

    task.delay(2.4, function()
        if highlight and highlight.Parent then
            local tweenOut = TweenService:Create(highlight, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                FillTransparency = 1,
                OutlineTransparency = 1
            })
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                if highlight and highlight.Parent then
                    highlight:Destroy()
                    if Cache.SelectedTargetHighlight == highlight then
                        Cache.SelectedTargetHighlight = nil
                    end
                end
            end)
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not Config.ClickFlingSelectEnabled or gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local closestPlayer = nil
        local shortestDist = math.huge

        for _, player in ipairs(CachedPlayerList) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if head and humanoid and humanoid.Health > 0 then
                    local screenPos, onScreen = WorldToScreen(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortestDist and dist < 80 then
                            shortestDist = dist
                            closestPlayer = player
                        end
                    end
                end
            end
        end

        if closestPlayer then
            Config.TargetFlingName = closestPlayer.Name
            Notify("Trolling", "Selected: " .. (closestPlayer.DisplayName or closestPlayer.Name))
            TriggerTargetHighlightAnimation(closestPlayer)
        end
    end
end)

function ShouldSkipEspPlayer(player)
    if not player or player == LocalPlayer then return true end
    if Config.TeamCheckerEnabled and IsTeammate and IsTeammate(player) then
        return not (Config.TeamEspEnabled == true)
    end
    return false
end

function IsEspTeammate(player)
    if not player or player == LocalPlayer then return false end
    if not Config.TeamCheckerEnabled then return false end
    if not (IsTeammate and IsTeammate(player)) then return false end
    return Config.TeamEspEnabled == true
end

function GetEspColorForPlayer(player, enemyColor)
    if Config.TeamCheckerEnabled and IsTeammate and IsTeammate(player) and Config.TeamEspEnabled then
        return Config.Color_TeamEsp or Color3.fromRGB(80, 180, 255)
    end
    return enemyColor or (Theme and Theme.Accent) or Color3.fromRGB(180, 140, 255)
end

function ShouldSkipNameEsp(player)
    return ShouldSkipEspPlayer(player)
end

function ShouldSkipDistanceEsp(player)
    return ShouldSkipEspPlayer(player)
end


ApplyEspToPlayer = function(targetPlayer)
    if targetPlayer == LocalPlayer then return end

    local function CleanupPlayerDrawings()
        if Cache.EspLabels[targetPlayer] then
            pcall(function()
                local t = Cache.EspLabels[targetPlayer]
                if typeof(t) == "Instance" then t:Destroy() elseif t.Remove then t:Remove() end
            end)
            Cache.EspLabels[targetPlayer] = nil
        end
        if Cache.Skeletons[targetPlayer] then
            for _, line in pairs(Cache.Skeletons[targetPlayer]) do
                pcall(function() if line then line:Remove() end end)
            end
            Cache.Skeletons[targetPlayer] = nil
        end
        if Cache.Boxes[targetPlayer] then
            local b = Cache.Boxes[targetPlayer]
            pcall(function() if b.Outline then b.Outline:Remove() end end)
            pcall(function() if b.Box then b.Box:Remove() end end)
            pcall(function() if b.Fill then b.Fill:Remove() end end)
            if b.Gradients then
                for _, g in pairs(b.Gradients) do pcall(function() if g then g:Remove() end end) end
            end
            if b.OutlineGrad then
                for _, g in pairs(b.OutlineGrad) do pcall(function() if g then g:Remove() end end) end
            end
            if b.Corners then
                for _, ln in pairs(b.Corners) do pcall(function() if ln then ln:Remove() end end) end
            end
            if b.Box3D then
                for _, ln in pairs(b.Box3D) do pcall(function() if ln then ln:Remove() end end) end
            end
            Cache.Boxes[targetPlayer] = nil
        end
        if Cache.Healthbars[targetPlayer] then
            pcall(function()
                local hb = Cache.Healthbars[targetPlayer]
                if hb.Bg then hb.Bg:Remove() end
                if hb.Fill then hb.Fill:Remove() end
                if hb.Segs then
                    for _, s in pairs(hb.Segs) do
                        pcall(function() if s then s:Remove() end end)
                    end
                end
            end)
            Cache.Healthbars[targetPlayer] = nil
        end
    end

    local function CharacterAdded(character)
        if not character then return end
        local hasDraw = Cache.Boxes[targetPlayer] and Cache.Boxes[targetPlayer].Box
        if not hasDraw then
            CleanupPlayerDrawings()
        end

        local highlight = character:FindFirstChild("AnxiumHighlight") or Instance.new("Highlight")
        highlight.Name = "AnxiumHighlight"
        highlight.Adornee = character
        highlight.FillColor = Theme.Accent
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Enabled = false
        highlight.Parent = character
        Cache.Highlights[targetPlayer] = highlight

        
        local chams = Cache.Chams[targetPlayer]
        if chams and chams.Parent then
            pcall(function() chams:Destroy() end)
        end
        chams = Instance.new("Highlight")
        chams.Name = "AnxiumChams_" .. tostring(targetPlayer.UserId)
        chams.Adornee = character
        chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        chams.FillColor = GetEspColorForPlayer(targetPlayer, Config.Color_Chams or Theme.Accent)
        chams.OutlineColor = Color3.fromRGB(255, 255, 255)
        chams.FillTransparency = 0.4
        chams.OutlineTransparency = 0.2
        local skipTeam = Config.TeamCheckerEnabled and IsTeammate and IsTeammate(targetPlayer)
        chams.Enabled = Config.ChamsEnabled and not skipTeam
        
        local okParent = pcall(function()
            if gethui then chams.Parent = gethui()
            elseif syn and syn.protect_gui then chams.Parent = CoreGui
            else chams.Parent = ScreenGui end
        end)
        if not okParent then
            chams.Parent = character
        end
        Cache.Chams[targetPlayer] = chams

        
        Cache.ChamsPartFallback = Cache.ChamsPartFallback or {}
        if Cache.ChamsPartFallback[targetPlayer] then
            for part, data in pairs(Cache.ChamsPartFallback[targetPlayer]) do
                if part and part.Parent and data then
                    pcall(function()
                        part.Material = data.Material
                        part.Color = data.Color
                    end)
                end
            end
        end
        Cache.ChamsPartFallback[targetPlayer] = {}
        
        if Config.ChamsEnabled and Config.ChamsForcePartFallback == true and not (Config.TeamCheckerEnabled and IsTeammate and IsTeammate(targetPlayer)) then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Transparency < 0.95 then
                    Cache.ChamsPartFallback[targetPlayer][part] = {
                        Material = part.Material,
                        Color = part.Color,
                    }
                    pcall(function()
                        part.Material = Enum.Material.ForceField
                        part.Color = GetEspColorForPlayer(targetPlayer, Config.Color_Chams or Theme.Accent)
                    end)
                end
            end
        elseif Config.TeamCheckerEnabled and IsTeammate and IsTeammate(targetPlayer) then
            pcall(Chams_RestoreParts, targetPlayer)
        end

        
        do
            local existing = Cache.EspLabels[targetPlayer]
            local okDraw = existing and typeof(existing) ~= "Instance" and existing.Remove ~= nil
            if not okDraw then
                if existing then
                    pcall(function()
                        if typeof(existing) == "Instance" then existing:Destroy()
                        elseif existing.Remove then existing:Remove() end
                    end)
                end
                local nameText = Drawing.new("Text")
                nameText.Center = true
                nameText.Outline = true
                nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
                nameText.Size = 14
                nameText.Font = Cache.DrawingFontIndex or 2
                nameText.Color = GetEspColorForPlayer(targetPlayer, Config.Color_NameEsp or Theme.Accent)
                nameText.Transparency = 1
                nameText.Visible = false
                nameText.Text = ""
                Cache.EspLabels[targetPlayer] = nameText
            end
        end

        if not Cache.Boxes[targetPlayer] then
        local skelParts = {
            Head = Drawing.new("Line"),
            Neck = Drawing.new("Line"),
            Spine = Drawing.new("Line"),
            LeftUpperArm = Drawing.new("Line"),
            LeftLowerArm = Drawing.new("Line"),
            LeftHand = Drawing.new("Line"),
            RightUpperArm = Drawing.new("Line"),
            RightLowerArm = Drawing.new("Line"),
            RightHand = Drawing.new("Line"),
            LeftUpperLeg = Drawing.new("Line"),
            LeftLowerLeg = Drawing.new("Line"),
            LeftFoot = Drawing.new("Line"),
            RightUpperLeg = Drawing.new("Line"),
            RightLowerLeg = Drawing.new("Line"),
            RightFoot = Drawing.new("Line"),
            HeadCircle = Drawing.new("Circle"),
        }
        for name, line in pairs(skelParts) do
            if name == "HeadCircle" then
                line.Thickness = 1.65
                line.Filled = false
                line.NumSides = 24
                line.Radius = 6
                line.Transparency = 1
                line.Color = Theme.Accent
                line.Visible = false
            else
                line.Thickness = 1.65
                line.Transparency = 1
                line.Color = Theme.Accent
                line.Visible = false
            end
        end
        Cache.Skeletons[targetPlayer] = skelParts

        
        local boxOutline = Drawing.new("Square")
        boxOutline.Thickness = 2.5
        boxOutline.Filled = false
        boxOutline.Color = Color3.fromRGB(20, 12, 30) 
        boxOutline.Visible = false

        local boxLine = Drawing.new("Square")
        boxLine.Thickness = 1.4
        boxLine.Filled = false
        boxLine.Color = GetEspColorForPlayer(targetPlayer, Config.Color_BoxEsp or Theme.Accent)
        boxLine.Visible = false

        
        local boxFill = Drawing.new("Square")
        boxFill.Thickness = 1
        boxFill.Filled = true
        boxFill.Color = GetEspColorForPlayer(targetPlayer, Config.Color_BoxEsp or Theme.Accent)
        boxFill.Transparency = 0.82
        boxFill.Visible = false

        
        local gradients = {}
        for i = 1, 48 do
            local g = Drawing.new("Line")
            g.Thickness = 3
            g.Transparency = 0.15
            g.Visible = false
            gradients[i] = g
        end
        local outlineGrad = {} 
        for i = 1, 16 do
            local ln = Drawing.new("Line")
            ln.Thickness = 1.35
            ln.Transparency = 0
            ln.Visible = false
            outlineGrad[i] = ln
        end

        
        local corners = {}
        for i = 1, 8 do
            local ln = Drawing.new("Line")
            ln.Thickness = 1.6
            ln.Color = GetEspColorForPlayer(targetPlayer, Config.Color_BoxEsp or Theme.Accent)
            ln.Visible = false
            corners[i] = ln
        end

        
        local box3d = {}
        for i = 1, 24 do
            local ln = Drawing.new("Line")
            ln.Thickness = 1.85
            ln.Color = GetEspColorForPlayer(targetPlayer, Config.Color_BoxEsp or Theme.Accent)
            ln.Transparency = 0
            ln.Visible = false
            box3d[i] = ln
        end

        Cache.Boxes[targetPlayer] = {
            Outline = boxOutline,
            Box = boxLine,
            Fill = boxFill,
            Gradients = gradients,
            OutlineGrad = outlineGrad,
            Corners = corners,
            Box3D = box3d,
        }

        local hbBg = Drawing.new("Square")
        hbBg.Thickness = 1
        hbBg.Filled = true
        hbBg.Color = Color3.fromRGB(0, 0, 0)
        hbBg.Visible = false

        local hbFill = Drawing.new("Square")
        hbFill.Thickness = 1
        hbFill.Filled = true
        hbFill.Color = Color3.fromRGB(0, 255, 0)
        hbFill.Visible = false

        local hbSegs = {}
        for i = 1, 12 do
            local ln = Drawing.new("Line")
            ln.Thickness = 3
            ln.Visible = false
            hbSegs[i] = ln
        end

        Cache.Healthbars[targetPlayer] = {Bg = hbBg, Fill = hbFill, Segs = hbSegs}
        end
    end

    if targetPlayer.Character then CharacterAdded(targetPlayer.Character) end
    targetPlayer.CharacterAdded:Connect(CharacterAdded)
    targetPlayer.CharacterRemoving:Connect(CleanupPlayerDrawings)
end

CreateTracer = function(targetPlayer)
    if targetPlayer == LocalPlayer then return end
    pcall(function()
        local old = Cache.TracerLines[targetPlayer]
        if old then
            if typeof(old) == "table" and old.Segs then
                for _, ln in ipairs(old.Segs) do pcall(function() if ln and ln.Remove then ln:Remove() end end) end
            elseif old.Remove then
                old:Remove()
            end
        end
    end)
    local segs = {}
    local n = 10
    for i = 1, n do
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Transparency = 1
        line.Visible = false
        segs[i] = line
    end
    Cache.TracerLines[targetPlayer] = { Segs = segs, N = n }
end


for _, player in ipairs(CachedPlayerList) do
    ApplyEspToPlayer(player)
    CreateTracer(player)
end

Players.PlayerAdded:Connect(function(player)
    ApplyEspToPlayer(player)
    CreateTracer(player)
end)

Players.PlayerRemoving:Connect(function(player)
    Cache.Highlights[player] = nil
    Cache.Chams[player] = nil
    if Cache.EspLabels[player] then
        pcall(function()
            local t = Cache.EspLabels[player]
            if typeof(t) == "Instance" then t:Destroy() elseif t.Remove then t:Remove() end
        end)
        Cache.EspLabels[player] = nil
    end
    if Cache.TracerLines[player] then
        local tr = Cache.TracerLines[player]
        pcall(function()
            if typeof(tr) == "table" and tr.Segs then
                for _, ln in ipairs(tr.Segs) do if ln and ln.Remove then ln:Remove() end end
            elseif tr.Remove then
                tr:Remove()
            end
        end)
        Cache.TracerLines[player] = nil
    end
    if Cache.Skeletons[player] then
        for _, line in pairs(Cache.Skeletons[player]) do line:Remove() end
        Cache.Skeletons[player] = nil
    end
    if Cache.Boxes[player] then
        local b = Cache.Boxes[player]
        pcall(function() if b.Outline then b.Outline:Remove() end end)
        pcall(function() if b.Box then b.Box:Remove() end end)
        pcall(function() if b.Fill then b.Fill:Remove() end end)
        if b.Gradients then
            for _, g in pairs(b.Gradients) do pcall(function() if g then g:Remove() end end) end
        end
        if b.Corners then
            for _, ln in pairs(b.Corners) do pcall(function() if ln then ln:Remove() end end) end
        end
        if b.Box3D then
            for _, ln in pairs(b.Box3D) do pcall(function() if ln then ln:Remove() end end) end
        end
        Cache.Boxes[player] = nil
    end
    if Cache.Healthbars[player] then
        pcall(function()
            local hb = Cache.Healthbars[player]
            if hb.Bg then hb.Bg:Remove() end
            if hb.Fill then hb.Fill:Remove() end
            if hb.Segs then
                for _, s in pairs(hb.Segs) do
                    pcall(function() if s then s:Remove() end end)
                end
            end
        end)
        Cache.Healthbars[player] = nil
    end
end)


function AntiAim_EnsureGyro(hrp)
    local g = hrp:FindFirstChild("AnxiumAAGyro")
    if g and g:IsA("BodyGyro") then return g end
    for _, c in ipairs(hrp:GetChildren()) do
        if c.Name == "AnxiumAAGyro" then pcall(function() c:Destroy() end) end
    end
    g = Instance.new("BodyGyro")
    g.Name = "AnxiumAAGyro"
    g.P = 9e4
    g.D = 2000
    g.MaxTorque = Vector3.new(0, 12e6, 0) 
    g.CFrame = hrp.CFrame
    g.Parent = hrp
    return g
end

function AntiAim_ClearGyro()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local g = hrp:FindFirstChild("AnxiumAAGyro")
        if g then pcall(function() g:Destroy() end) end
    end
end


function GetSelfTransparencyAmount()
    if not Config or not Config.SelfTransparencyEnabled then
        return 0
    end
    return math.clamp(tonumber(Config.SelfTransparency) or 0.4, 0, 1)
end

function ApplySelfTransparency()
    local char = LocalPlayer.Character
    if not char then return end
    if Config.ThirdPersonEnabled then return end
    local amount = GetSelfTransparencyAmount()

    local function isHeldWeapon(inst)
        if not inst then return false end
        if inst:FindFirstAncestorOfClass("Tool") then return true end
        
        local p = inst.Parent
        while p and p ~= char do
            if p:IsA("Tool") then return true end
            local n = string.lower(tostring(p.Name or ""))
            if n == "handle" or n:find("weapon", 1, true) or n:find("gun", 1, true)
                or n:find("knife", 1, true) or n:find("sword", 1, true)
                or n:find("rifle", 1, true) or n:find("pistol", 1, true)
                or n:find("viewmodel", 1, true) or n:find("arms", 1, true) then
                
                if p:IsA("Model") or p:IsA("Folder") then
                    return true
                end
            end
            p = p.Parent
        end
        return false
    end

    for _, d in ipairs(char:GetDescendants()) do
        if isHeldWeapon(d) then
            
            if d:IsA("BasePart") then
                pcall(function() d.LocalTransparencyModifier = 0 end)
            end
        elseif d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
            pcall(function()
                d.LocalTransparencyModifier = amount
            end)
        elseif d:IsA("Decal") or d:IsA("Texture") then
            if isHeldWeapon(d) then
                
            else
                pcall(function()
                    if amount > 0 then
                        if d:GetAttribute("AnxiumSelfTransOrig") == nil then
                            d:SetAttribute("AnxiumSelfTransOrig", d.Transparency)
                        end
                        d.Transparency = math.clamp(amount, 0, 1)
                    else
                        local orig = d:GetAttribute("AnxiumSelfTransOrig")
                        if typeof(orig) == "number" then d.Transparency = orig end
                    end
                end)
            end
        end
    end
    Cache.SelfTransApplied = amount
end

function SelfTransparency_Bind()
    pcall(function()
        RunService:UnbindFromRenderStep("AnxiumSelfTrans")
    end)
    if not Config.SelfTransparencyEnabled then
        pcall(ApplySelfTransparency)
        return
    end
    RunService:BindToRenderStep("AnxiumSelfTrans", Enum.RenderPriority.Camera.Value + 25, function()
        if Config.SelfTransparencyEnabled and not Config.ThirdPersonEnabled then
            ApplySelfTransparency()
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.defer(function()
        task.wait(0.25)
        if Config.SelfTransparencyEnabled then
            pcall(SelfTransparency_Bind)
            pcall(ApplySelfTransparency)
        end
    end)
end)


function AntiAim_Update(dt)
    if not Config.AntiAimEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hrp:IsA("BasePart") then return end

    if hum then
        pcall(function()
            hum.PlatformStand = false
            hum.AutoRotate = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        end)
    end

    local mode = Config.AntiAimMode or "Static"
    local yawOffDeg = Config.AntiAimYaw or 180
    local pitchDeg = math.clamp(Config.AntiAimPitch or -45, -75, 75)
    local pitch = math.rad(pitchDeg)
    dt = dt or 0.016

    local cam = Workspace.CurrentCamera
    local camYaw = 0
    if cam then
        local lv = cam.CFrame.LookVector
        camYaw = math.atan2(-lv.X, -lv.Z)
    end

    if mode == "Jitter" then
        local j = Config.AntiAimJitter or 35
        yawOffDeg = yawOffDeg + (math.random() * 2 - 1) * j
    elseif mode == "Spin" then
        Cache.AntiAimSpinAngle = (Cache.AntiAimSpinAngle or 0) + math.rad(Config.AntiAimSpinSpeed or 720) * dt
        yawOffDeg = math.deg(Cache.AntiAimSpinAngle)
    end

    local targetYaw = camYaw + math.rad(yawOffDeg)

    local resolveActive = false
    if Config.AntiAimResolveEnabled == true then
        local untilT = Cache.AntiAimResolveUntil
        if untilT and tick() < untilT then
            resolveActive = true
        elseif untilT then
            Cache.AntiAimResolveUntil = nil
        end
    end

    if mode == "Static" and not resolveActive then
        local md = Vector3.zero
        if hum then
            pcall(function() md = hum.MoveDirection end)
        end
        local moveFlat = Vector3.new(md.X, 0, md.Z)
        if moveFlat.Magnitude < 0.08 then
            
            local v = hrp.AssemblyLinearVelocity
            moveFlat = Vector3.new(v.X, 0, v.Z)
        end
        if moveFlat.Magnitude > 0.15 then
            local inv = -moveFlat.Unit 
            targetYaw = math.atan2(-inv.X, -inv.Z)
            Cache.AntiAimLastStaticYaw = targetYaw
        elseif Cache.AntiAimLastStaticYaw then
            targetYaw = Cache.AntiAimLastStaticYaw
        else
            
            targetYaw = camYaw + math.rad(yawOffDeg)
        end
    end
    local pos = hrp.Position
    local vel = hrp.AssemblyLinearVelocity

    if mode == "TP" then
        local radius = tonumber(Config.AntiAimTPRadius) or 5
        local speed = math.max(tonumber(Config.AntiAimTPSpeed) or 8, 0.5)
        Cache.AntiAimTPAcc = (Cache.AntiAimTPAcc or 0) + dt * speed
        if Cache.AntiAimTPAcc >= 1 then
            Cache.AntiAimTPAcc = Cache.AntiAimTPAcc - math.floor(Cache.AntiAimTPAcc)
            Cache.AntiAimTPSide = -(Cache.AntiAimTPSide or 1)
        end
        local side = Cache.AntiAimTPSide or 1
        local flat
        if cam then
            local lv = cam.CFrame.LookVector
            flat = Vector3.new(lv.X, 0, lv.Z)
            if flat.Magnitude > 1e-3 then
                flat = flat.Unit
            else
                flat = Vector3.new(0, 0, -1)
            end
        else
            flat = Vector3.new(0, 0, -1)
        end
        local right = Vector3.new(flat.Z, 0, -flat.X)
        local last = Cache.AntiAimTPLastOffset
        if typeof(last) ~= "Vector3" then last = Vector3.zero end
        local newOff = right * (radius * side)
        pos = pos - last + newOff
        Cache.AntiAimTPLastOffset = newOff
    else
        
        if Cache.AntiAimTPLastOffset then
            Cache.AntiAimTPLastOffset = nil
            Cache.AntiAimTPAcc = 0
        end
    end

    if resolveActive then
        targetYaw = camYaw
        pitch = 0
    end

    local targetCF = CFrame.new(pos) * CFrame.Angles(0, targetYaw, 0)
    pcall(function()
        hrp.CFrame = targetCF
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, vel.Y, vel.Z)
    end)

    local gyro = AntiAim_EnsureGyro(hrp)
    if gyro then
        gyro.CFrame = targetCF
        gyro.MaxTorque = Vector3.new(0, 12e6, 0)
    end

    Cache.AntiAimMotorBases = Cache.AntiAimMotorBases or {}
    for _, m in ipairs(char:GetDescendants()) do
        if m:IsA("Motor6D") then
            local n = m.Name
            if n == "Waist" or n == "Neck" then
                if not Cache.AntiAimMotorBases[m] then
                    Cache.AntiAimMotorBases[m] = m.C0
                end
                local base = Cache.AntiAimMotorBases[m]
                local amount = (n == "Neck") and (pitch * 0.9) or (pitch * 0.65)
                pcall(function()
                    m.C0 = base * CFrame.Angles(amount, 0, 0)
                end)
            end
        end
    end
end

function AntiAim_TriggerResolve()
    if not Config.AntiAimEnabled or Config.AntiAimResolveEnabled ~= true then return end
    local hold = math.clamp((tonumber(Config.AntiAimResolveHoldMs) or 100) / 1000, 0.01, 1.5)
    local ret = math.clamp((tonumber(Config.AntiAimResolveReturnMs) or 60) / 1000, 0, 1)
    Cache.AntiAimResolveUntil = tick() + hold + ret
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        pcall(AntiAim_TriggerResolve)
    end
end)

function AntiAim_RestoreMotors()
    Cache.AntiAimTPLastOffset = nil
    Cache.AntiAimTPAcc = 0
    Cache.AntiAimTPSide = 1
    if Cache.AntiAimMotorBases then
        for m, base in pairs(Cache.AntiAimMotorBases) do
            if m and m.Parent then
                pcall(function() m.C0 = base end)
            end
        end
        Cache.AntiAimMotorBases = {}
    end
    AntiAim_ClearGyro()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum.AutoRotate = true end) end
    Cache.AntiAimSpinAngle = 0
    Cache.AntiAimLastStaticYaw = nil
end

Cache.AimLockTarget = nil


function GetCharHumanoid(char)
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then return hum end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("Humanoid") then return d end
    end
    return nil
end

function GetCharRoot(char)
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("HRP") or char:FindFirstChild("Root") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if hrp and hrp:IsA("BasePart") then return hrp end
    if char.PrimaryPart then return char.PrimaryPart end
    local hum = GetCharHumanoid(char)
    if hum and hum.RootPart then return hum.RootPart end
    
    local best, bestVol = nil, 0
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") and d.Transparency < 1 then
            local v = d.Size.X * d.Size.Y * d.Size.Z
            if v > bestVol then bestVol = v; best = d end
        end
    end
    return best
end

function GetCharHead(char)
    if not char then return nil end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("head") or char:FindFirstChild("Helmet")
    if head and head:IsA("BasePart") then return head end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then
            local n = string.lower(d.Name)
            if n == "head" or n:find("head") or n == "helmet" then return d end
        end
    end
    local root = GetCharRoot(char)
    return root
end

function GetPlayerCharacter(player)
    if not player then return nil end
    local char = player.Character
    if char and char.Parent then return char end
    
    local byName = workspace:FindFirstChild(player.Name)
    if byName and byName:IsA("Model") and GetCharHumanoid(byName) then
        return byName
    end
    return char
end


Cache._AimWallParams = Cache._AimWallParams or RaycastParams.new()
Cache._AimWallParams.FilterType = Enum.RaycastFilterType.Exclude
Cache._AimWallParams.IgnoreWater = true

function IsVisibleToCamera(player, part)
    if not part then return false end
    local origin = Camera and Camera.CFrame.Position
    if not origin then return false end
    local char = player and (GetPlayerCharacter and GetPlayerCharacter(player) or player.Character)
    if not char then return false end

    local params = Cache._AimWallParams
    local filter = { LocalPlayer.Character }
    
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then table.insert(filter, cam) end
    end)
    params.FilterDescendantsInstances = filter

    local dir = part.Position - origin
    local dist = dir.Magnitude
    if dist < 0.05 then return true end

    local result = Workspace:Raycast(origin, dir, params)
    if not result then
        
        return true
    end
    
    return result.Instance and result.Instance:IsDescendantOf(char)
end

BODY_PART_OPTIONS = { "Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", "Random", "Closest" }

function ResolveAimPart(char, mode)
    if not char then return nil end
    mode = mode or "Head"
    local function pick(name)
        if name == "Torso" then
            return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        end
        return char:FindFirstChild(name)
    end
    if mode == "Random" then
        local pool = {}
        for _, n in ipairs({ "Head", "HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso" }) do
            local p = pick(n)
            if p then table.insert(pool, p) end
        end
        if #pool > 0 then return pool[math.random(1, #pool)] end
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    end
    if mode == "Closest" then
        local cam = Workspace.CurrentCamera
        if not cam then return pick("Head") end
        local mouse = UserInputService:GetMouseLocation()
        local best, bestD = nil, math.huge
        for _, n in ipairs({ "Head", "HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso" }) do
            local p = pick(n)
            if p then
                local sp, onScreen = cam:WorldToViewportPoint(p.Position)
                if onScreen and sp.Z > 0 then
                    local d = (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
                    if d < bestD then
                        bestD = d
                        best = p
                    end
                end
            end
        end
        return best or pick("Head") or char:FindFirstChild("HumanoidRootPart")
    end
    return pick(mode) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

function IsValidAimTarget(player)
    if not player or player == LocalPlayer then return false end
    if Config.TeamCheckerEnabled and IsTeammate and IsTeammate(player) then
        return false
    end
    local char = GetPlayerCharacter(player)
    if not char then return false end
    local humanoid = GetCharHumanoid(char)
    local aimPart = ResolveAimPart(char, Config.AimTargetPart or "Head")
    if not aimPart then
        aimPart = GetCharHead(char) or GetCharRoot(char)
    end
    if not aimPart then return false end
    if humanoid and humanoid.Health <= 0 then return false end
    if not humanoid then
        local root = GetCharRoot(char)
        if not root then return false end
    end
    if Config.AimWallCheck then
        if not IsVisibleToCamera(player, aimPart) then
            return false
        end
    end
    return true, aimPart, humanoid
end


function WorldToScreen(worldPos)
    local cam = Workspace.CurrentCamera or Camera
    if not cam then
        return Vector3.new(0, 0, 0), false
    end
    local sp, onScreen = cam:WorldToViewportPoint(worldPos)
    return sp, onScreen and sp.Z > 0
end



function AspectRatio_Apply()
    local cam = Workspace.CurrentCamera or Camera
    if not cam then return end
    if not Config.AspectRatioEnabled then return end
    local s = tonumber(Config.AspectRatioValue) or 1
    if s < 0.05 then s = 0.05 end
    if math.abs(s - 1) < 0.001 then return end
    local cf = cam.CFrame
    
    local look = cf.LookVector
    local right = cf.RightVector
    
    local up = right:Cross(look)
    if up.Magnitude < 1e-4 then
        up = cf.UpVector
    else
        up = up.Unit
    end
    right = look:Cross(up).Unit
    cam.CFrame = CFrame.fromMatrix(cf.Position, right, up * s, -look)
end

function GetMovementDynamicExtra(enabled, maxExtra, cacheKey)
    cacheKey = cacheKey or "_dynExtra"
    if not enabled then
        Cache[cacheKey] = 0
        return 0
    end
    local speed = 0
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local vel = hrp.AssemblyLinearVelocity
        speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
    end
    maxExtra = math.clamp(tonumber(maxExtra) or 40, 0, 200)
    local target = 0
    if speed > 1.2 then
        target = maxExtra * math.clamp(speed / 16, 0, 1)
    end
    local cur = Cache[cacheKey] or 0
    cur = cur + (target - cur) * 0.2
    Cache[cacheKey] = cur
    return cur
end

GetClosestPlayerInFOV = function()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
        Cache.AimLockTarget = nil
        return nil
    end

    local fovCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local fovRadius = (Config.FovRadius or 150) + GetMovementDynamicExtra(Config.FovDynamicEnabled == true, Config.FovDynamicExpand, "FovDynamicExtra")

    
    local closestPlayer = nil
    local shortestScreenDist = math.huge

    for i = 1, #CachedPlayerList do
        local player = CachedPlayerList[i]
        local ok, head = IsValidAimTarget(player)
        if ok then
            local pos, onScreen = WorldToScreen(head.Position)
            if onScreen and pos.Z > 0 then
                local screenDist = (Vector2.new(pos.X, pos.Y) - fovCenter).Magnitude
                if screenDist <= fovRadius and screenDist < shortestScreenDist then
                    shortestScreenDist = screenDist
                    closestPlayer = player
                end
            end
        end
    end

    Cache.AimLockTarget = closestPlayer
    return closestPlayer
end


Cache.TeamCache = Cache.TeamCache or {}
TEAM_STATUS = {
    lobby = true, play = true, playing = true, spectator = true, spectate = true,
    menu = true, waiting = true, none = true, afk = true,
    ["n/a"] = true, na = true, unknown = true, unassigned = true,
    
}

function _teamStatusName(name)
    if name == nil then return true end
    local s = string.lower(tostring(name)):gsub("%s+", "")
    if s == "" or s == "0" or s == "nil" then return true end
    return TEAM_STATUS[s] == true
end

function _normTeamName(name)
    return string.lower(tostring(name or "")):gsub("%s+", "")
end

function _rawIsTeammate(player)
    if not player or player == LocalPlayer then return false end

    local myTeam = LocalPlayer.Team
    local theirTeam = player.Team

    
    if myTeam ~= nil and theirTeam ~= nil then
        local myName = _normTeamName(myTeam.Name)
        local theirName = _normTeamName(theirTeam.Name)

        
        if _teamStatusName(myName) then
            return false
        end

        
        if myTeam == theirTeam or myName == theirName then
            return true
        end

        
        return false
    end

    
    if (myTeam ~= nil) ~= (theirTeam ~= nil) then
        return false
    end

    
    if LocalPlayer.TeamColor and player.TeamColor then
        local okEq = false
        pcall(function() okEq = (LocalPlayer.TeamColor == player.TeamColor) end)
        if okEq then
            local cn = string.lower(tostring(LocalPlayer.TeamColor.Name or ""))
            if cn ~= "" and cn ~= "white" and cn ~= "mediumstonegrey" and cn ~= "ghostgrey"
                and cn ~= "black" and cn ~= "darkstonegrey" and cn ~= "midgray"
                and cn ~= "really black" then
                return true
            end
        end
    end

    
    local attrKeys = {
        "Team", "TeamName", "TeamId", "team", "teamName", "teamId",
        "Faction", "Side", "Squad", "Party", "Alliance",
        "TeamNumber", "TeamIndex",
    }
    for _, key in ipairs(attrKeys) do
        local ok1, a = pcall(function() return LocalPlayer:GetAttribute(key) end)
        local ok2, b = pcall(function() return player:GetAttribute(key) end)
        if ok1 and ok2 and a ~= nil and b ~= nil and a == b then
            if not _teamStatusName(a) and a ~= "" and a ~= 0 and a ~= false then
                return true
            end
        end
    end

    
    local ok, same = pcall(function()
        local names = { "Team", "TeamValue", "TeamName", "Faction", "Side" }
        local myVal, theirVal
        for _, n in ipairs(names) do
            myVal = myVal or LocalPlayer:FindFirstChild(n)
            theirVal = theirVal or player:FindFirstChild(n)
        end
        if myVal and theirVal then
            local a = myVal:IsA("ValueBase") and myVal.Value or myVal.Name
            local b = theirVal:IsA("ValueBase") and theirVal.Value or theirVal.Name
            if a ~= nil and b ~= nil and a == b and not _teamStatusName(a) then
                return true
            end
        end
        local mls = LocalPlayer:FindFirstChild("leaderstats")
        local tls = player:FindFirstChild("leaderstats")
        if mls and tls then
            local mt = mls:FindFirstChild("Team") or mls:FindFirstChild("Faction")
            local tt = tls:FindFirstChild("Team") or tls:FindFirstChild("Faction")
            if mt and tt and mt:IsA("ValueBase") and tt:IsA("ValueBase") then
                if mt.Value == tt.Value and not _teamStatusName(mt.Value) then
                    return true
                end
            end
        end
        return false
    end)
    if ok and same then return true end

    return false
end



function ApplyChamsStyle(hl, col, style)
    if not hl then return end
    style = tostring(style or (Config and Config.ChamsStyle) or "Flat")
    col = col or Color3.fromRGB(180, 140, 255)
    hl.FillColor = col
    if style == "Metallic" then
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.12
        hl.OutlineTransparency = 0.05
    elseif style == "Glow" then
        hl.OutlineColor = col
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
    elseif style == "Outline" then
        hl.OutlineColor = col
        hl.FillTransparency = 1
        hl.OutlineTransparency = 0
    elseif style == "Soft" then
        hl.OutlineColor = col
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0.35
    elseif style == "Solid" then
        hl.OutlineColor = col
        hl.FillTransparency = 0.05
        hl.OutlineTransparency = 0.25
    elseif style == "Pearlescent" then
        local pearl = col:Lerp(Color3.new(1, 1, 1), 0.35)
        hl.FillColor = pearl
        hl.OutlineColor = col
        hl.FillTransparency = 0.2
        hl.OutlineTransparency = 0.15
    else
        hl.OutlineColor = col
        hl.FillTransparency = 0.22
        hl.OutlineTransparency = 0.45
    end
end

function Chams_RestoreParts(player)
    Cache.ChamsPartFallback = Cache.ChamsPartFallback or {}
    local map = Cache.ChamsPartFallback[player]
    if not map then return end
    for part, data in pairs(map) do
        if part and part.Parent and data then
            pcall(function()
                part.Material = data.Material
                part.Color = data.Color
            end)
        end
    end
    Cache.ChamsPartFallback[player] = {}
end

IsTeammate = function(player)
    if not player or player == LocalPlayer then return false end
    local now = tick()
    local ent = Cache.TeamCache[player]
    if ent and (now - ent.t) < 0.2 then
        return ent.v
    end
    local v = _rawIsTeammate(player)
    Cache.TeamCache[player] = { t = now, v = v }
    return v
end


pcall(function()
    LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
        Cache.TeamCache = {}
        if Config.TeamCheckerEnabled and RefreshTeamIgnoreVisuals then
            task.defer(RefreshTeamIgnoreVisuals)
        end
    end)
    LocalPlayer:GetPropertyChangedSignal("TeamColor"):Connect(function()
        Cache.TeamCache = {}
    end)
end)

GetPartPos = function(char, partName)
    local part = char:FindFirstChild(partName)
    if part then
        local vec, on = WorldToScreen(part.Position)
        if on and vec.Z > 0.1 then return Vector2.new(vec.X, vec.Y) end
    end
    return nil
end

GetPlayerByName = function(targetName)
    if targetName == "" then return nil end
    targetName = targetName:lower()
    for _, p in ipairs(CachedPlayerList) do
        if p ~= LocalPlayer then
            if p.Name:lower():sub(1, #targetName) == targetName or p.DisplayName:lower():sub(1, #targetName) == targetName then
                return p
            end
        end
    end
    return nil
end

TriggerbotLastShot = 0
Cache.TriggerbotPendingUntil = 0
Cache.TriggerbotPendingTarget = nil


function Triggerbot_AutowallHit(player)
    if not player or not player.Character or not Camera then return false end
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local head = player.Character:FindFirstChild("Head")
        or player.Character:FindFirstChild("HumanoidRootPart")
        or player.Character.PrimaryPart
    if not head then return false end
    local origin = Camera.CFrame.Position
    local targetPos = head.Position
    local totalDir = targetPos - origin
    local dist = totalDir.Magnitude
    if dist < 0.5 or dist > 1200 then return false end
    local dir = totalDir.Unit
    local softMax = tonumber(Config.AutowallSoftMax) or 2.2
    local hardMax = tonumber(Config.AutowallHardMax) or 0.55
    local thickness = 0
    local pos = origin
    local remain = dist + 0.5
    local ignore = { myChar }
    for _ = 1, 8 do
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = ignore
        params.IgnoreWater = true
        local result = Workspace:Raycast(pos, dir * remain, params)
        if not result or not result.Instance then
            return false
        end
        if result.Instance:IsDescendantOf(player.Character) then
            return thickness <= softMax
        end
        local part = result.Instance
        local size = 0.4
        pcall(function()
            if part:IsA("BasePart") then
                size = math.min(part.Size.X, part.Size.Y, part.Size.Z)
            end
        end)
        if size > hardMax * 3 and thickness > 0 then
            return false
        end
        thickness = thickness + math.clamp(size, 0.05, 2.5)
        if thickness > softMax then
            return false
        end
        table.insert(ignore, part)
        pos = result.Position + dir * 0.05
        remain = (targetPos - pos).Magnitude + 0.4
        if remain <= 0.1 then break end
    end
    return false
end

function Triggerbot_HasLineOfSight(player, aimPart)
    if not player or not player.Character or not Camera then return false end
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local part = aimPart
    if not part or not part.Parent then
        part = player.Character:FindFirstChild("Head")
            or player.Character:FindFirstChild("HumanoidRootPart")
            or player.Character.PrimaryPart
    end
    if not part or not part:IsA("BasePart") then return false end

    local origin = Camera.CFrame.Position
    local targetPos = part.Position
    local dir = targetPos - origin
    local dist = dir.Magnitude
    if dist < 0.5 or dist > 1200 then return false end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { myChar }
    params.IgnoreWater = true

    local result = Workspace:Raycast(origin, dir.Unit * (dist + 0.35), params)
    if not result or not result.Instance then
        return dist < 4
    end
    if result.Instance:IsDescendantOf(player.Character) then
        return true
    end
    if Config.TriggerbotAutowall then
        return Triggerbot_AutowallHit(player)
    end
    return false
end

function Triggerbot_GetTargetUnderCrosshair()
    if not Camera then return nil end
    local myChar = LocalPlayer.Character
    if not myChar then return nil end

    RaycastParamsTriggerbot.FilterDescendantsInstances = { myChar }
    RaycastParamsTriggerbot.IgnoreWater = true

    local result = Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 1000, RaycastParamsTriggerbot)
    if result and result.Instance then
        local hit = result.Instance
        for _, player in ipairs(CachedPlayerList or Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and hit:IsDescendantOf(player.Character) then
                if Config.TeamCheckerEnabled and IsTeammate and IsTeammate(player) then
                    return nil
                end
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    return player
                end
            end
        end
    end

    if Config.TriggerbotAutowall then
        local origin = Camera.CFrame.Position
        local look = Camera.CFrame.LookVector
        local best, bestDot = nil, 0.992
        for _, player in ipairs(CachedPlayerList or Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not (Config.TeamCheckerEnabled and IsTeammate and IsTeammate(player)) then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    local head = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and head then
                        local to = (head.Position - origin)
                        if to.Magnitude > 1 and to.Magnitude < 900 then
                            local dot = look:Dot(to.Unit)
                            if dot >= bestDot and Triggerbot_AutowallHit(player) then
                                bestDot = dot
                                best = player
                            end
                        end
                    end
                end
            end
        end
        return best
    end
    return nil
end


function Triggerbot_GetSilentFovTarget()
    if not Config then return nil end
    if Config.SilentAimV2Enabled and Cache and Cache.SilentV2Target then
        local tv = Cache.SilentV2Target
        local part = Cache.SilentV2Part
        if tv and tv ~= LocalPlayer then
            local ok = false
            pcall(function()
                local char = tv.Character
                if not char then return end
                if Config.TeamCheckerEnabled and IsTeammate and IsTeammate(tv) then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then return end
                if not Triggerbot_HasLineOfSight(tv, part) then return end
                ok = true
            end)
            if ok then return tv end
        end
    end
    return nil
end

function Triggerbot_Click()
    local hold = 0.014 + math.random() * 0.012 
    if typeof(mouse1press) == "function" and typeof(mouse1release) == "function" then
        mouse1press()
        task.delay(hold, function() pcall(mouse1release) end)
        return true
    end
    if typeof(mouse1click) == "function" then
        mouse1click()
        return true
    end
    return false
end

RunService.Heartbeat:Connect(function()
    if not Config then return end

    if Config.TriggerbotEnabled then
        local now = tick()

        
        if Cache.TriggerbotPendingTarget and now >= (Cache.TriggerbotPendingUntil or 0) then
            local pending = Cache.TriggerbotPendingTarget
            Cache.TriggerbotPendingTarget = nil
            Cache.TriggerbotPendingUntil = 0
            
            local still = Triggerbot_GetTargetUnderCrosshair()
            if not still then
                still = Triggerbot_GetSilentFovTarget()
            end
            
            if still == pending then
                local aimPart = nil
                if Cache and Cache.SilentV2Target == pending then
                    aimPart = Cache.SilentV2Part
                end
                if not Triggerbot_HasLineOfSight(pending, aimPart) then
                    Cache.TriggerbotPendingTarget = nil
                    Cache.TriggerbotPendingUntil = 0
                else
                local minGap = math.max((Config.TriggerbotDelay or 0) / 1000, 0.018)
                if now - TriggerbotLastShot >= minGap then
                    if Triggerbot_Click() then
                        TriggerbotLastShot = now
                        if Cache then
                            Cache.LastShotTime = now
                            Cache.LastShotTarget = pending
                            Cache.RecentDamageTargets = Cache.RecentDamageTargets or {}
                            Cache.RecentDamageTargets[pending] = now
                        end
                        pcall(function()
                            if typeof(MarkRecentTarget) == "function" then MarkRecentTarget(pending) end
                        end)
                    end
                end
                end
            end
        elseif not Cache.TriggerbotPendingTarget then
            
            local target = Triggerbot_GetTargetUnderCrosshair()
            
            if not target then
                target = Triggerbot_GetSilentFovTarget()
            end
            if target then
                local delaySec = (Config.TriggerbotDelay or 0) / 1000
                local minGap = math.max(delaySec, 0.018) + (math.random() * 0.01)
                if now - TriggerbotLastShot >= minGap then
                    local react = 0.004 + math.random() * 0.012
                    Cache.TriggerbotPendingTarget = target
                    Cache.TriggerbotPendingUntil = now + react
                end
            end
        end
    else
        Cache.TriggerbotPendingTarget = nil
        Cache.TriggerbotPendingUntil = 0
    end

    if Config.TargetFlingEnabled then
        local targetPlayer = GetPlayerByName(Config.TargetFlingName)
        local myChar = LocalPlayer.Character

        if targetPlayer and targetPlayer.Character and myChar then
            local myHrp = myChar:FindFirstChild("HumanoidRootPart")
            local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

            if myHrp and targetHrp then
                myHrp.AssemblyAngularVelocity = Vector3.new(0, 99999, 0)
                myHrp.AssemblyLinearVelocity = Vector3.zero
                myHrp.CFrame = targetHrp.CFrame

                for _, part in ipairs(myChar:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end

    if Config.BHopEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local wantHop = UserInputService:IsKeyDown(Enum.KeyCode.Space) or (Config.AutoJumpEnabled == true)
            if humanoid and hrp and wantHop then
                if humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid.Jump = true
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    if humanoid.MoveDirection.Magnitude > 0 then
                        local impulse = humanoid.MoveDirection.Unit * (Config.BHopPower or 50)
                        local currentY = hrp.AssemblyLinearVelocity.Y
                        local jumpY = currentY > 0 and currentY or 35
                        hrp.AssemblyLinearVelocity = Vector3.new(impulse.X, jumpY, impulse.Z)
                    end
                end
            end
        end
    end
end)

function NameEsp_DestroyBill(player)
    Cache.EspNameBills = Cache.EspNameBills or {}
    local data = Cache.EspNameBills[player]
    if data then
        pcall(function()
            if data.bill then data.bill:Destroy() end
            if data.label and data.label.Parent and data.label:IsA("TextLabel") and data.screen then
                data.label:Destroy()
            end
            if data.draw and data.draw.Remove then data.draw:Remove() end
        end)
        Cache.EspNameBills[player] = nil
    end
    local old = Cache.EspLabels and Cache.EspLabels[player]
    if old then
        pcall(function()
            if typeof(old) == "Instance" then old:Destroy()
            elseif old.Remove then old:Remove()
            else old.Visible = false end
        end)
        Cache.EspLabels[player] = nil
    end
end

function NameEsp_GetScreenGui()
    if Cache.EspNameScreenGui and Cache.EspNameScreenGui.Parent then
        return Cache.EspNameScreenGui
    end
    local sg = Instance.new("ScreenGui")
    sg.Name = "AnxiumNameEspGui"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 50
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        sg.Parent = game:GetService("CoreGui")
    end)
    if not sg.Parent then
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    Cache.EspNameScreenGui = sg
    return sg
end

function NameEsp_EnsureBill(player, adornee)
    Cache.EspNameBills = Cache.EspNameBills or {}
    local data = Cache.EspNameBills[player]
    if data and data.label and data.label.Parent then
        return data
    end
    NameEsp_DestroyBill(player)
    local sg = NameEsp_GetScreenGui()
    local lbl = Instance.new("TextLabel")
    lbl.Name = "Name_" .. tostring(player.UserId)
    lbl.BackgroundTransparency = Config.NameEspFillEnabled and 0 or 1
    lbl.BackgroundColor3 = Config.Color_NameEspFill or Color3.fromRGB(24, 20, 34)
    lbl.Size = UDim2.fromOffset(220, 20)
    lbl.AnchorPoint = Vector2.new(0.5, 1)
    lbl.Position = UDim2.fromOffset(-5000, -5000)
    lbl.Font = SelectedFont or Enum.Font.GothamBold
    lbl.TextSize = 15
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeTransparency = 0.2
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Visible = false
    lbl.Parent = sg
    local fillCorner = Instance.new("UICorner")
    fillCorner.Name = "NameEspFillCorner"
    fillCorner.CornerRadius = UDim.new(0, math.clamp(tonumber(Config.NameEspFillCorner) or 4, 0, 12))
    fillCorner.Parent = lbl
    local grad = Instance.new("UIGradient")
    grad.Name = "NameGrad"
    grad.Rotation = 0
    grad.Enabled = false
    grad.Parent = lbl
    data = { label = lbl, grad = grad, screen = true, player = player }
    Cache.EspNameBills[player] = data
    return data
end

function NameEsp_FitLabelToText(data)
    if not data or not data.label then return end
    local lbl = data.label
    local txt = lbl.Text or ""
    if txt == "" then return end
    local font = lbl.Font or SelectedFont or Enum.Font.GothamBold
    local size = lbl.TextSize or 15
    local bounds = Vector2.new(0, 0)
    pcall(function()
        bounds = game:GetService("TextService"):GetTextSize(txt, size, font, Vector2.new(2000, 64))
    end)
    local w = math.clamp(math.ceil(bounds.X + 10), 24, 420)
    local h = math.clamp(math.ceil(math.max(bounds.Y, size) + 6), 18, 48)
    lbl.Size = UDim2.fromOffset(w, h)
end

function NameEsp_ApplyGradient(data)
    if not data or not data.grad or not data.label then return end
    local isTeam = data.player and IsEspTeammate and IsEspTeammate(data.player)
    local c1, c2, useGrad
    if isTeam then
        c1 = Config.Color_TeamNameEsp or Config.Color_TeamEsp or Color3.fromRGB(80, 180, 255)
        c2 = Config.Color_TeamNameEspB or c1:Lerp(Color3.fromRGB(255, 255, 255), 0.35)
        useGrad = Config.TeamNameEspGradientEnabled == true
    else
        c1 = Config.Color_NameEsp or Theme.Accent or Color3.fromRGB(180, 140, 255)
        c2 = Config.Color_NameEspB or Color3.fromRGB(255, 120, 200)
        useGrad = Config.NameEspGradientEnabled == true
    end
    NameEsp_FitLabelToText(data)
    data.label.BackgroundTransparency = Config.NameEspFillEnabled and 0 or 1
    data.label.BackgroundColor3 = Config.Color_NameEspFill or Color3.fromRGB(24, 20, 34)
    local fillCorner = data.label:FindFirstChild("NameEspFillCorner")
    if fillCorner and fillCorner:IsA("UICorner") then
        fillCorner.CornerRadius = UDim.new(0, math.clamp(tonumber(Config.NameEspFillCorner) or 4, 0, 12))
    end
    if useGrad then
        data.grad.Enabled = true
        data.grad.Rotation = 0
        data.grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(0.5, c1:Lerp(c2, 0.5)),
            ColorSequenceKeypoint.new(1, c2),
        })
        data.label.TextColor3 = Color3.fromRGB(255, 255, 255)
        data.label.TextStrokeTransparency = 0.15
        data.label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    else
        data.grad.Enabled = false
        data.label.TextColor3 = c1
        data.label.TextStrokeTransparency = 0.2
    end
end

function NameEsp_RefreshGradients()
    for _, data in pairs(Cache.EspNameBills or {}) do
        pcall(NameEsp_ApplyGradient, data)
    end
end


RunService.RenderStepped:Connect(function(dt)
    Cache.FrameN = (Cache.FrameN or 0) + 1
    local frameN = Cache.FrameN
    dt = (typeof(dt) == "number" and dt > 0 and dt < 0.1) and dt or 0.016
    Camera = Workspace.CurrentCamera or Camera

    if not Config then return end
    
    if Config.BulletTracersEnabled then
        pcall(function()
            if Cache and typeof(Cache.UpdateBulletTracers) == "function" then
                Cache.UpdateBulletTracers()
            elseif typeof(UpdateBulletTracers) == "function" then
                UpdateBulletTracers()
            end
        end)
    end
    if Config.KillFlashEnabled or Config.DeathBurstEnabled then
        pcall(function()
            if Cache and typeof(Cache.UpdateKillFX) == "function" then
                Cache.UpdateKillFX()
            elseif typeof(UpdateKillFX) == "function" then
                UpdateKillFX()
            end
        end)
    end

    if Config.AspectRatioEnabled and AspectRatio_Apply then
        Cache._arN = (Cache._arN or 0) + 1
        if Cache._arN % 3 == 0 then
            pcall(AspectRatio_Apply)
        end
    end
    Camera = Workspace.CurrentCamera or Camera
    local vp = Camera.ViewportSize
    local screenCenter = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHead = myChar and myChar:FindFirstChild("Head")

    local currentTarget = nil
    if Config.AimEnabled or Config.TargetHudEnabled or Config.TargetMarkerEnabled or Config.TargetRingEnabled then
        if Config.AimEnabled or Config.TargetHudEnabled then
            currentTarget = GetClosestPlayerInFOV()
        end
    else
        Cache.AimLockTarget = nil
    end

    local orbitTargetHrp = nil
    if Config.TargetHudEnabled and currentTarget and currentTarget.Character then
        local targetChar = currentTarget.Character
        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")

        if targetHrp and targetHum and targetHum.Health > 0 then
            orbitTargetHrp = targetHrp
            ShowTargetHud()

            
            local uid = currentTarget.UserId
            if Cache.TargetHudLastUserId ~= uid then
                Cache.TargetHudLastUserId = uid
                ApplyTargetAvatar(uid)
            end
            
            TargetAvatar.ImageTransparency = 0
            if TargetAvatar.Image == "" or TargetAvatar.Image == nil then
                ApplyTargetAvatar(uid)
            end

            TargetNameLabel.Text = currentTarget.DisplayName or currentTarget.Name

            local hp = math.clamp(targetHum.Health, 0, targetHum.MaxHealth)
            local maxHp = math.max(targetHum.MaxHealth, 1)

            TargetHealthFill.Size = UDim2.new(hp / maxHp, 0, 1, 0)
            TargetHealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local hudCol = Config.Color_TargetHud or Color3.fromRGB(180, 140, 255)
            if Cache.TargetHealthGrad and Cache._targetHudGradCol ~= hudCol then
                Cache._targetHudGradCol = hudCol
                if ApplyTargetHudColor then ApplyTargetHudColor(hudCol) end
            end
            if AvatarStroke then AvatarStroke.Color = hudCol end
            if TargetHudStroke then TargetHudStroke.Color = hudCol end

            local distStuds = myHrp and (targetHrp.Position - myHrp.Position).Magnitude or 0
            TargetInfoLabel.Text = math.floor(hp) .. " / " .. math.floor(maxHp) .. "  ·  " .. math.floor(distStuds * 0.28) .. "m"
        else
            HideTargetHud()
            Cache.TargetHudLastUserId = nil
        end
    else
        HideTargetHud()
    end

    
    local orbitHrp = nil
    if Config.OrbitOrbsEnabled then
        orbitHrp = orbitTargetHrp or myHrp
    else
        if OrbitPart1 and OrbitPart1.Parent then OrbitPart1.Parent = nil end
        if OrbitPart2 and OrbitPart2.Parent then OrbitPart2.Parent = nil end
    end


    
    if Config.TargetMarkerEnabled then
        local markerTarget = nil
        if orbitTargetHrp then
            markerTarget = orbitTargetHrp
        elseif myHrp then
            local bestD, bestH
            for _, plr in ipairs(CachedPlayerList or {}) do
                if plr ~= LocalPlayer then
                    if not (Config.TeamCheckerEnabled and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team) then
                        local ch = plr.Character
                        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.Health > 0 then
                            local d = (hrp.Position - myHrp.Position).Magnitude
                            if not bestD or d < bestD then bestD, bestH = d, hrp end
                        end
                    end
                end
            end
            markerTarget = bestH
        end
        if markerTarget and TargetMarker_Update then
            pcall(TargetMarker_Update, markerTarget, dt or 0.016)
        elseif TargetMarker_Hide then
            pcall(TargetMarker_Hide)
        end
    elseif TargetMarker_Hide then
        pcall(TargetMarker_Hide)
    end

    
    do
        if Config.TargetRingEnabled then
            
            local ringTarget = nil
            local myRoot = myHrp
            if myRoot then
                local bestD = math.huge
                for _, plr in ipairs(CachedPlayerList or Players:GetPlayers()) do
                    if plr ~= LocalPlayer then
                        if not (ShouldSkipEspPlayer(plr)) then
                            local ch = plr.Character
                            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                            if hrp and hum and hum.Health > 0 then
                                local d = (hrp.Position - myRoot.Position).Magnitude
                                if d < bestD then
                                    bestD = d
                                    ringTarget = hrp
                                end
                            end
                        end
                    end
                end
            end
            if ringTarget and TargetRing_Update then
                pcall(TargetRing_Update, ringTarget, dt or 0.016)
            elseif TargetRing_Hide then
                pcall(TargetRing_Hide)
            end
        elseif TargetRing_Hide then
            pcall(TargetRing_Hide)
        end
    end

    if Config.OrbitOrbsEnabled and orbitHrp then
        orbitTargetHrp = orbitHrp
        if not OrbitPart1.Parent then OrbitPart1.Parent = Workspace end
        if not OrbitPart2.Parent then OrbitPart2.Parent = Workspace end

        if frameN % 30 == 0 then local ocol = Config.Color_Orbit or Theme.Accent; OrbTrail1.Color = ColorSequence.new(ocol); OrbTrail2.Color = ColorSequence.new(ocol) end
        Cache.OrbitAngle = (Cache.OrbitAngle + Config.OrbitSpeedValue) % 360
        local rad = math.rad(Cache.OrbitAngle)
        local heightWave1 = math.sin(rad * 2) * 0.6
        local heightWave2 = math.cos(rad * 2) * 0.6

        local pos1 = orbitTargetHrp.Position + Vector3.new(math.cos(rad) * 3.5, heightWave1, math.sin(rad) * 3.5)
        local pos2 = orbitTargetHrp.Position + Vector3.new(math.cos(rad + math.pi) * 3.5, heightWave2, math.sin(rad + math.pi) * 3.5)

        OrbitPart1.CFrame = CFrame.new(pos1, pos1 + Vector3.new(-math.sin(rad), 0, math.cos(rad)))
        OrbitPart2.CFrame = CFrame.new(pos2, pos2 + Vector3.new(-math.sin(rad + math.pi) * 3.5, heightWave2, math.sin(rad + math.pi) * 3.5))
    else
        if OrbitPart1.Parent then OrbitPart1.Parent = nil end
        if OrbitPart2.Parent then OrbitPart2.Parent = nil end
    end

    
    local needBoxDraw = Config.BoxEspEnabled or Config.HealthbarEspEnabled
    local needAnyEsp = needBoxDraw or Config.NameEspEnabled or Config.DistanceEspEnabled
        or Config.SkeletonEnabled or Config.TracersEnabled
    local nPlayers = #(CachedPlayerList or {})
    Cache._espLodFrame = (Cache._espLodFrame or 0) + 1
    local vpSize = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
    local vpX, vpY = vpSize.X, vpSize.Y
    local boxCol = Config.Color_BoxEsp or Theme.Accent
    local boxFillCol = Config.Color_BoxEspFill or Color3.fromRGB(80, 40, 160)
    local boxStyle = Config.EspBoxStyle or "Full"
    if boxStyle == "Box3D" then boxStyle = "Full" end

    
    Cache._boxCleanN = (Cache._boxCleanN or 0) + 1
    if Cache._boxCleanN % 30 == 0 then
        for plr, b in pairs(Cache.Boxes) do
            local dead = (not plr) or (not plr.Parent)
            if not dead then
                local ch = plr.Character
                if not ch then
                    dead = true
                else
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 0 then dead = true end
                end
            end
            if dead and b then
                if b.Outline then b.Outline.Visible = false end
                if b.Box then b.Box.Visible = false end
                if b.Fill then b.Fill.Visible = false end
                if b.Gradients then for _, g in pairs(b.Gradients) do if g then g.Visible = false end end end
                if b.OutlineGrad then for _, g in pairs(b.OutlineGrad) do if g then g.Visible = false end end end
                if b.Corners then for _, ln in pairs(b.Corners) do if ln then ln.Visible = false end end end
                if b.Box3D then for _, ln in pairs(b.Box3D) do if ln then ln.Visible = false end end end
                local hb = Cache.Healthbars and Cache.Healthbars[plr]
                if hb then
                    if hb.Bg then hb.Bg.Visible = false; hb.Bg.Position = Vector2.new(-9000, -9000) end
                    if hb.Fill then hb.Fill.Visible = false; hb.Fill.Position = Vector2.new(-9000, -9000) end
                    if hb.Segs then
                        for _, s in pairs(hb.Segs) do
                            if s then s.Visible = false; s.From = Vector2.new(0,0); s.To = Vector2.new(0,0) end
                        end
                    end
                end
            end
        end
    end

    local healthbarDrawn = {}
    Cache._espLiteMode = (nPlayers or 0) > 16
    local function HB_HardHide(hb)
        if not hb then return end
        pcall(function()
            if hb.Bg then
                hb.Bg.Visible = false
                hb.Bg.Size = Vector2.new(0, 0)
                hb.Bg.Position = Vector2.new(-10000, -10000)
            end
            if hb.Fill then
                hb.Fill.Visible = false
                hb.Fill.Size = Vector2.new(0, 0)
                hb.Fill.Position = Vector2.new(-10000, -10000)
            end
            if hb.Segs then
                for _, s in pairs(hb.Segs) do
                    if s then
                        s.Visible = false
                        s.Thickness = 0
                        s.From = Vector2.new(-10000, -10000)
                        s.To = Vector2.new(-10000, -10000)
                    end
                end
            end
        end)
    end
    pcall(function()
        if Cache._hbCleanN == nil then Cache._hbCleanN = 0 end
        Cache._hbCleanN = Cache._hbCleanN + 1
        if Cache._hbCleanN % 20 == 0 then
            for plr, hb in pairs(Cache.Healthbars or {}) do
                if not plr or not plr.Parent then
                    pcall(function()
                        if hb and hb.Bg then hb.Bg:Remove() end
                        if hb and hb.Fill then hb.Fill:Remove() end
                        if hb and hb.Segs then
                            for _, s in pairs(hb.Segs) do
                                if s then pcall(function() s:Remove() end) end
                            end
                        end
                    end)
                    Cache.Healthbars[plr] = nil
                end
            end
        end
    end)
    if needAnyEsp or next(Cache.Boxes) ~= nil then
    for player, boxData in pairs(Cache.Boxes) do
        pcall(function()
            local hbData = Cache.Healthbars[player]

            local function hideBox()
                if Cache.EspScreenRect then Cache.EspScreenRect[player] = nil end
                if boxData then
                    if boxData.Outline then boxData.Outline.Visible = false end
                    if boxData.Box then boxData.Box.Visible = false end
                    if boxData.Fill then boxData.Fill.Visible = false end
                    if boxData.Gradients then
                        for _, g in pairs(boxData.Gradients) do if g then g.Visible = false end end
                    end
                    if boxData.OutlineGrad then
                        for _, g in pairs(boxData.OutlineGrad) do if g then g.Visible = false end end
                    end
                    if boxData.Corners then
                        for _, ln in pairs(boxData.Corners) do if ln then ln.Visible = false end end
                    end
                    if boxData.Box3D then
                        for _, ln in pairs(boxData.Box3D) do if ln then ln.Visible = false end end
                    end
                end
                if hbData then
                    if hbData.Bg then hbData.Bg.Visible = false; hbData.Bg.Position = Vector2.new(-9000,-9000) end
                    if hbData.Fill then hbData.Fill.Visible = false; hbData.Fill.Position = Vector2.new(-9000,-9000) end
                    if hbData.Segs then
                        for _, s in pairs(hbData.Segs) do
                            if s then s.Visible = false; s.From = Vector2.new(0,0); s.To = Vector2.new(0,0) end
                        end
                    end
                end
            end

            if not player or not player.Parent then
                hideBox()
                return
            end
            if ShouldSkipEspPlayer(player) then
                hideBox()
                return
            end
            if not needBoxDraw then
                hideBox()
                return
            end

            local char = (GetPlayerCharacter and GetPlayerCharacter(player)) or player.Character
            if not char or not boxData then hideBox() return end
            local hum = GetCharHumanoid and GetCharHumanoid(char) or char:FindFirstChildOfClass("Humanoid")
            local hrp = GetCharRoot and GetCharRoot(char) or char:FindFirstChild("HumanoidRootPart")
            local head = GetCharHead and GetCharHead(char) or char:FindFirstChild("Head")
            if not (hrp and head) then hideBox() return end
            if hum and hum.Health <= 0 then hideBox() return end

            
            local hrpPos = hrp.Position
            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
            local center = hrpPos + Vector3.new(0, isR15 and 0.55 or 0.35, 0)
            local half = Vector3.new(
                isR15 and 1.35 or 1.25,
                isR15 and 3.15 or 2.95,
                isR15 and 1.35 or 1.25
            )

            local minX, maxX = math.huge, -math.huge
            local minY, maxY = math.huge, -math.huge
            local anyFront = false
            local behindCount = 0
            local cam = Workspace.CurrentCamera or Camera
            if not cam then hideBox() return end
            local vp = cam.ViewportSize
            local vpX, vpY = vp.X, vp.Y

            for ox = -1, 1, 2 do
                for oy = -1, 1, 2 do
                    for oz = -1, 1, 2 do
                        local wp = center + Vector3.new(half.X * ox, half.Y * oy, half.Z * oz)
                        local sp = WorldToScreen(wp)
                        if sp.Z > 0.05 then
                            anyFront = true
                            if sp.X < minX then minX = sp.X end
                            if sp.X > maxX then maxX = sp.X end
                            if sp.Y < minY then minY = sp.Y end
                            if sp.Y > maxY then maxY = sp.Y end
                        else
                            behindCount = behindCount + 1
                        end
                    end
                end
            end

            if not anyFront then
                hideBox()
                return
            end

            if behindCount >= 6 or maxX - minX < 2 or maxY - minY < 2 then
                local topSP = WorldToScreen(head.Position + Vector3.new(0, 0.85, 0))
                local botSP = WorldToScreen(hrpPos - Vector3.new(0, isR15 and 3.0 or 2.8, 0))
                local midSP = WorldToScreen(hrpPos)
                if topSP.Z < 0.05 and botSP.Z < 0.05 then
                    hideBox()
                    return
                end
                local topY = topSP.Z > 0.05 and topSP.Y or (midSP.Y - 40)
                local botY = botSP.Z > 0.05 and botSP.Y or (midSP.Y + 40)
                if topY > botY then topY, botY = botY, topY end
                local cx = midSP.Z > 0.05 and midSP.X or ((topSP.X + botSP.X) * 0.5)
                local h = math.max(botY - topY, 8)
                local w = h * 0.55
                minX, maxX = cx - w * 0.5, cx + w * 0.5
                minY, maxY = topY, botY
            end

            local width = maxX - minX
            local height = maxY - minY

            if width ~= width or height ~= height or width < 2 or height < 2 or width > vpX * 1.5 or height > vpY * 1.5 then
                hideBox()
                return
            end

            if maxX < -40 or maxY < -40 or minX > vpX + 40 or minY > vpY + 40 then
                hideBox()
                return
            end

            local padX = math.clamp(width * 0.06, 1, 6)
            local padY = math.clamp(height * 0.03, 1, 5)
            minX = minX - padX
            minY = minY - padY
            width = width + padX * 2
            height = height + padY * 2

            Cache.EspScreenRect = Cache.EspScreenRect or {}
            Cache.EspScreenRect[player] = {
                x = minX, y = minY, w = width, h = height,
                cx = minX + width * 0.5, top = minY
            }

            local boxPos = Vector2.new(minX, minY)
            local style = boxStyle
            local col = GetEspColorForPlayer(player, boxCol)
            local fillColBase = boxFillCol
            if IsEspTeammate(player) then
                fillColBase = Config.Color_TeamEsp or fillColBase
            end

            if Config.BoxEspEnabled then
                local fillCol = fillColBase

                local function hideAllBox()
                    if boxData.Outline then boxData.Outline.Visible = false end
                    if boxData.Box then boxData.Box.Visible = false end
                    if boxData.Fill then boxData.Fill.Visible = false end
                    if boxData.Gradients then
                        for _, g in pairs(boxData.Gradients) do if g then g.Visible = false end end
                    end
                    if boxData.OutlineGrad then
                        for _, g in pairs(boxData.OutlineGrad) do if g then g.Visible = false end end
                    end
                    if boxData.Corners then
                        for _, ln in pairs(boxData.Corners) do if ln then ln.Visible = false end end
                    end
                    if boxData.Box3D then
                        for _, ln in pairs(boxData.Box3D) do if ln then ln.Visible = false end end
                    end
                end

                local function drawGradientFill()
                    if not Config.BoxFillGradientEnabled then
                        if boxData.Gradients then
                            for _, g in pairs(boxData.Gradients) do if g then g.Visible = false end end
                        end
                        if boxData.Fill then boxData.Fill.Visible = false end
                        return
                    end
                    local colorA = col
                    local colorB = fillCol or col
                    if typeof(colorA) ~= "Color3" then colorA = Config.Color_BoxEsp or Theme.Accent end
                    if typeof(colorB) ~= "Color3" then colorB = Config.Color_BoxEspFill or colorA end
                    local x, y, w, h = boxPos.X, boxPos.Y, width, height
                    if w < 2 or h < 2 then
                        if boxData.Gradients then
                            for _, g in pairs(boxData.Gradients) do if g then g.Visible = false end end
                        end
                        return
                    end
                    local angle = math.pi * 0.5
                    if Config.BoxFillRotation then
                        angle = (tick() * (Config.BoxFillRotationSpeed or 2)) % (math.pi * 2)
                    end
                    local dx, dy = math.cos(angle), math.sin(angle)
                    local cx, cy = x + w * 0.5, y + h * 0.5
                    local maxDot = math.max((math.abs(dx) * w + math.abs(dy) * h) * 0.5, 1)
                    local lines = boxData.Gradients or {}
                    local nLines = #lines
                    if nLines < 1 then
                        if boxData.Fill then
                            boxData.Fill.Visible = true
                            boxData.Fill.Color = colorA:Lerp(colorB, 0.5)
                            boxData.Fill.Transparency = 0.75
                        end
                        return
                    end
                    local maxRows = nLines
                    if (#(CachedPlayerList or {}) > 20) then
                        maxRows = math.min(nLines, 24)
                    end
                    local targetRows = math.clamp(math.floor(h * 0.85), 8, maxRows)
                    if targetRows < 1 then targetRows = 1 end
                    local rowH = h / targetRows
                    for i = 1, targetRows do
                        local py = y + (i - 0.5) * rowH
                        local t = (i - 1) / math.max(targetRows - 1, 1)
                        local dotL = ((x - cx) * dx + (py - cy) * dy) / maxDot
                        local dotR = ((x + w - cx) * dx + (py - cy) * dy) / maxDot
                        local tL = math.clamp(dotL * 0.5 + 0.5, 0, 1)
                        local tR = math.clamp(dotR * 0.5 + 0.5, 0, 1)
                        local tBlend = (tL + tR) * 0.5
                        tBlend = tBlend * 0.65 + t * 0.35
                        local line = lines[i]
                        if line then
                            line.Color = colorA:Lerp(colorB, tBlend)
                            line.Thickness = math.clamp(rowH + 1.1, 2, 6)
                            line.Transparency = 0.18
                            line.From = Vector2.new(x + 0.5, py)
                            line.To = Vector2.new(x + w - 0.5, py)
                            line.Visible = true
                        end
                    end
                    for i = targetRows + 1, nLines do
                        if lines[i] then lines[i].Visible = false end
                    end
                    if boxData.Fill then boxData.Fill.Visible = false end

                    
                    local og = boxData.OutlineGrad
                    if og and Config.BoxOutlineGradient ~= false and Config.BoxEspEnabled then
                        local colorA = col
                        local colorB = fillCol
                        local x, y, w, h = minX, minY, width, height
                        local rotOff = 0
                        if Config.BoxFillRotation then
                            rotOff = ((tick() * (Config.BoxFillRotationSpeed or 2) * 0.15) % 1)
                        end
                        local GRAD_STEPS = 4
                        local sides = {
                            {x, y, x + w, y},
                            {x + w, y, x + w, y + h},
                            {x + w, y + h, x, y + h},
                            {x, y + h, x, y},
                        }
                        local idx = 0
                        for si = 1, 4 do
                            local s = sides[si]
                            local x1, y1, x2, y2 = s[1], s[2], s[3], s[4]
                            for step = 0, GRAD_STEPS - 1 do
                                idx = idx + 1
                                local tA = step / GRAD_STEPS
                                local tB = (step + 1) / GRAD_STEPS
                                local tMid = (((si - 1) / 4) + (tA / 4) + rotOff) % 1
                                local line = og[idx]
                                if line then
                                    line.From = Vector2.new(x1 + (x2 - x1) * tA, y1 + (y2 - y1) * tA)
                                    line.To = Vector2.new(x1 + (x2 - x1) * tB, y1 + (y2 - y1) * tB)
                                    line.Color = colorA:Lerp(colorB, tMid)
                                    line.Thickness = 1.5
                                    line.Visible = true
                                end
                            end
                        end
                        for i = idx + 1, #og do if og[i] then og[i].Visible = false end end
                        
                        if boxData.Outline then boxData.Outline.Visible = false end
                        if boxData.Box then boxData.Box.Visible = false end
                    elseif og then
                        for _, ln in pairs(og) do if ln then ln.Visible = false end end
                    end
                end

                if style == "Corner" and boxData.Corners then
                    hideAllBox()
                    local cornerLen = math.clamp(math.min(width, height) * 0.25, 7, 20)
                    local x1, y1 = minX, minY
                    local x2, y2 = minX + width, minY + height
                    local c = boxData.Corners
                    local function edge(i, a, b)
                        c[i].From = a; c[i].To = b; c[i].Color = col; c[i].Thickness = 1.8; c[i].Visible = true
                    end
                    edge(1, Vector2.new(x1, y1), Vector2.new(x1 + cornerLen, y1))
                    edge(2, Vector2.new(x1, y1), Vector2.new(x1, y1 + cornerLen))
                    edge(3, Vector2.new(x2, y1), Vector2.new(x2 - cornerLen, y1))
                    edge(4, Vector2.new(x2, y1), Vector2.new(x2, y1 + cornerLen))
                    edge(5, Vector2.new(x1, y2), Vector2.new(x1 + cornerLen, y2))
                    edge(6, Vector2.new(x1, y2), Vector2.new(x1, y2 - cornerLen))
                    edge(7, Vector2.new(x2, y2), Vector2.new(x2 - cornerLen, y2))
                    edge(8, Vector2.new(x2, y2), Vector2.new(x2, y2 - cornerLen))
                    drawGradientFill()

                else
                    
                    hideAllBox()
                    local outlineCol = Color3.new(
                        math.clamp(col.R * 0.22, 0, 1),
                        math.clamp(col.G * 0.22, 0, 1),
                        math.clamp(col.B * 0.22, 0, 1)
                    )
                    if boxData.Outline then
                        boxData.Outline.Size = Vector2.new(width, height)
                        boxData.Outline.Position = boxPos
                        boxData.Outline.Color = outlineCol
                        boxData.Outline.Thickness = 2.5
                        boxData.Outline.Visible = true
                    end
                    if boxData.Box then
                        boxData.Box.Size = Vector2.new(width, height)
                        boxData.Box.Position = boxPos
                        boxData.Box.Color = col
                        boxData.Box.Thickness = 1.4
                        boxData.Box.Visible = true
                    end
                    drawGradientFill()
                end
            else
                hideBox()
            end

            if Config.HealthbarEspEnabled and hbData and hbData.Bg then
                local liveHum = hum
                if char then
                    liveHum = (GetCharHumanoid and GetCharHumanoid(char)) or char:FindFirstChildOfClass("Humanoid") or hum
                end
                local hp, maxHp = 0, 100
                local hasHp = false
                if char then
                    local aHp = char:GetAttribute("Health")
                    local aMax = char:GetAttribute("MaxHealth")
                    if aHp ~= nil then
                        hp = tonumber(aHp) or 0
                        maxHp = tonumber(aMax) or 100
                        hasHp = true
                    end
                end
                if not hasHp and liveHum then
                    hp = tonumber(liveHum.Health) or 0
                    maxHp = tonumber(liveHum.MaxHealth) or 100
                    hasHp = true
                end
                if maxHp <= 0 then maxHp = 100 end
                local isDeadAttr = char and (char:GetAttribute("Dead") == true)
                if hasHp and hp > 0 and not isDeadAttr then
                    healthbarDrawn[player] = true
                    local barWidth = 3
                    local barPos = Vector2.new(minX - barWidth - 4, minY)
                    local healthPct = math.clamp(hp / maxHp, 0, 1)
                    local healthHeight = math.max(height * healthPct, 0)
                    hbData.Bg.Size = Vector2.new(barWidth + 2, height)
                    hbData.Bg.Position = Vector2.new(barPos.X - 1, barPos.Y)
                    hbData.Bg.Color = Color3.fromRGB(10, 10, 12)
                    hbData.Bg.Transparency = 0.35
                    hbData.Bg.Visible = true
                    
                    local base = Config.Color_Healthbar or Theme.Accent or Color3.fromRGB(180, 140, 255)
                    local topC = Color3.new(
                        math.clamp(base.R + (1 - base.R) * 0.55, 0, 1),
                        math.clamp(base.G + (1 - base.G) * 0.55, 0, 1),
                        math.clamp(base.B + (1 - base.B) * 0.55, 0, 1)
                    )
                    local midC = base
                    local botC = Color3.new(
                        math.clamp(base.R * 0.35, 0, 1),
                        math.clamp(base.G * 0.35, 0, 1),
                        math.clamp(base.B * 0.35, 0, 1)
                    )
                    local segs = hbData.Segs
                    local style = Config.HealthbarStyle or "Gradient"
                    local topCol = Config.Color_HealthbarTop or Color3.fromRGB(40, 255, 80)
                    local botCol = Config.Color_HealthbarBottom or Color3.fromRGB(255, 40, 40)
                    if style == "Solid" then
                        if segs then
                            for _, s in pairs(segs) do
                                if s then s.Visible = false; s.From = Vector2.new(0,0); s.To = Vector2.new(0,0) end
                            end
                        end
                        
                        local solidCol = Config.Color_Healthbar or Theme.Accent or Color3.fromRGB(180, 140, 255)
                        if hbData.Fill and healthHeight > 0.5 then
                            hbData.Fill.Size = Vector2.new(barWidth, math.max(healthHeight, 1))
                            hbData.Fill.Position = Vector2.new(barPos.X, barPos.Y + (height - healthHeight))
                            hbData.Fill.Color = solidCol
                            hbData.Fill.Visible = true
                        elseif hbData.Fill then
                            hbData.Fill.Visible = false
                        end
                    elseif style == "Gradient" and segs then
                        if hbData.Fill then hbData.Fill.Visible = false end
                        local n = #segs
                        local activeSegCount = math.clamp(math.floor(n * healthPct + 0.5), (healthPct > 0.02) and 1 or 0, n)
                        local fillTop = barPos.Y + (height - healthHeight)
                        local segH = (activeSegCount > 0) and (healthHeight / activeSegCount) or 0
                        
                        local accent = base
                        local white = Color3.fromRGB(255, 255, 255)
                        for i = 1, n do
                            local ln = segs[i]
                            if not ln then continue end
                            if i <= activeSegCount and segH > 0 then
                                local t = (i - 0.5) / math.max(activeSegCount, 1)
                                local col
                                if t < 0.35 then
                                    col = white:Lerp(accent, t / 0.35)
                                else
                                    col = accent
                                end
                                local py1 = fillTop + (i - 1) * segH
                                local py2 = fillTop + i * segH
                                ln.From = Vector2.new(barPos.X + barWidth * 0.5, py1)
                                ln.To = Vector2.new(barPos.X + barWidth * 0.5, py2)
                                ln.Thickness = barWidth
                                ln.Color = col
                                ln.Visible = true
                            else
                                ln.Visible = false
                                ln.From = Vector2.new(0, 0)
                                ln.To = Vector2.new(0, 0)
                            end
                        end
                    else
                        if segs then
                            for _, s in pairs(segs) do
                                if s then s.Visible = false; s.From = Vector2.new(0,0); s.To = Vector2.new(0,0) end
                            end
                        end
                        if hbData.Fill and healthHeight > 0.5 then
                            hbData.Fill.Size = Vector2.new(barWidth, math.max(healthHeight, 1))
                            hbData.Fill.Position = Vector2.new(barPos.X, barPos.Y + (height - healthHeight))
                            hbData.Fill.Color = topCol:Lerp(botCol, 1 - healthPct)
                            hbData.Fill.Visible = true
                        elseif hbData.Fill then
                            hbData.Fill.Visible = false
                        end
                    end
                end
            elseif hbData then
            end
        end)
    end

    
    pcall(function()
        for plr, hb in pairs(Cache.Healthbars or {}) do
            if not hb then continue end
            local ok = healthbarDrawn[plr] == true and plr and plr.Parent
            if ok then
                local ch = plr.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                if not ch or not hum or hum.Health <= 0 then ok = false end
            end
            if not ok then
                HB_HardHide(hb)
            end
        end
    end)
    end


    if Config.ThirdPersonEnabled then
        pcall(function()
            local dist = math.clamp(Config.ThirdPersonDistance or 12, 4, 50)
            local minZ = LocalPlayer.CameraMinZoomDistance
            local maxZ = LocalPlayer.CameraMaxZoomDistance
            if minZ ~= dist or maxZ ~= dist then
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
                LocalPlayer.CameraMinZoomDistance = dist
                LocalPlayer.CameraMaxZoomDistance = dist
            end
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                local off = hum.CameraOffset
                if off.Magnitude > 0.05 then
                    hum.CameraOffset = Vector3.zero
                end
            end
            if Config.SelfTransparencyEnabled then
                pcall(ApplySelfTransparency)
            end
        end)
    end

    if Config.AimEnabled then
        
        local aimTarget = GetClosestPlayerInFOV()
        if aimTarget then
            local ok, targetHead, hum = IsValidAimTarget(aimTarget)
            if ok and targetHead then
                local smooth = math.clamp(Config.AimSmoothValue or 0.18, 0.01, 1)
                local aimPos = targetHead.Position
                local dist = (aimPos - Camera.CFrame.Position).Magnitude
                if dist < 12 then
                    local char = GetPlayerCharacter(aimTarget) or aimTarget.Character
                    local root = char and GetCharRoot(char)
                    if root then aimPos = root.Position + Vector3.new(0, 0.5, 0) end
                end
                local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, aimPos)
                if smooth >= 0.99 then
                    Camera.CFrame = targetCFrame
                else
                    
                    local t = math.clamp(smooth, 0.08, 1)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, t)
                end
            else
                Cache.AimLockTarget = nil
            end
        else
            Cache.AimLockTarget = nil
        end
    else
        Cache.AimLockTarget = nil
    end

    if Config.AntiAimEnabled then
        pcall(function() AntiAim_Update(1/60) end)
    end

    

    if Config.DayCycleEnabled then
        pcall(function()
            local t = math.clamp(tonumber(Config.DayCycleTime) or 14, 0, 24)
            if math.abs(Lighting.ClockTime - t) > 0.02 then
                Lighting.ClockTime = t
            end
        end)
    end

    if Config.FullbrightEnabled and (frameN % 15 == 0) then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
    elseif Config.DarkModeEnabled and (frameN % 15 == 0) then
        local intensity = math.clamp((tonumber(Config.DarkModeIntensity) or 50) / 100, 0, 1)
        local bright = 1.4 - intensity * 1.25
        local amb = 70 - intensity * 55
        local out = 62 - intensity * 50
        local top = 48 - intensity * 40
        local bot = 36 - intensity * 30
        Lighting.Brightness = math.clamp(bright, 0.15, 1.5)
        Lighting.Ambient = Color3.fromRGB(amb, amb, amb + 8)
        Lighting.OutdoorAmbient = Color3.fromRGB(out, out + 2, out + 12)
        Lighting.ColorShift_Top = Color3.fromRGB(top, top + 2, top + 12)
        Lighting.ColorShift_Bottom = Color3.fromRGB(bot, bot + 2, bot + 10)
    end
    if (Config.WorldColorEnabled or Config.NoShadowsEnabled or Cache.WorldColorWasOn or Cache.NoShadowsWasOn) and (frameN % 45 == 0) then
        pcall(ApplyWorldVisuals)
    end

    if Config.SelfTransparencyEnabled then
        if not Cache.SelfTransWasOn then
            pcall(SelfTransparency_Bind)
        end
        Cache.SelfTransWasOn = true
    elseif Cache.SelfTransWasOn then
        pcall(function() RunService:UnbindFromRenderStep("AnxiumSelfTrans") end)
        pcall(ApplySelfTransparency)
        Cache.SelfTransWasOn = false
    end

    if Config.NoFogEnabled then
        pcall(function()
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
            for _, child in ipairs(Lighting:GetChildren()) do
                if child:IsA("Atmosphere") then
                    child.Density = 0
                    child.Haze = 0
                end
            end
        end)
        Cache.NoFogWasOn = true
    elseif Cache.NoFogWasOn then
        pcall(function()
            Lighting.FogStart = LightingDefaults.FogStart
            Lighting.FogEnd = LightingDefaults.FogEnd
            Lighting.FogColor = LightingDefaults.FogColor
        end)
        Cache.NoFogWasOn = false
    end

    if Config.FogEnabled and not Config.NoFogEnabled then
        
        pcall(function()
            Lighting.FogStart = 0
            Lighting.FogEnd = math.max(Config.FogDistanceValue or 300, 20)
            Lighting.FogColor = Config.Color_Fog or Theme.Accent
            local fogAtm = Lighting:FindFirstChild("AnxiumFogAtmosphere")
            if not fogAtm then
                fogAtm = Instance.new("Atmosphere")
                fogAtm.Name = "AnxiumFogAtmosphere"
                fogAtm.Parent = Lighting
            end
            local dens = math.clamp(0.25 + (500 - math.min(Config.FogDistanceValue or 300, 500)) / 2000, 0.15, 0.55)
            if fogAtm.Density ~= dens then fogAtm.Density = dens end
            fogAtm.Haze = 2.5
            fogAtm.Color = Config.Color_Fog or Theme.Accent
            fogAtm.Decay = Config.Color_Fog or Theme.Accent
            
            if frameN % 20 == 0 then
                for _, child in ipairs(Lighting:GetChildren()) do
                    if child:IsA("Atmosphere") and child.Name ~= "AnxiumFogAtmosphere" then
                        child.Density = 0
                        child.Haze = 0
                    end
                end
            end
        end)
    elseif Cache.FogWasOn then
        local fogAtm = Lighting:FindFirstChild("AnxiumFogAtmosphere")
        if fogAtm then fogAtm:Destroy() end
        pcall(function()
            Lighting.FogStart = LightingDefaults.FogStart
            Lighting.FogEnd = LightingDefaults.FogEnd
            Lighting.FogColor = LightingDefaults.FogColor
        end)
        Cache.FogWasOn = false
    end
    if Config.FogEnabled then Cache.FogWasOn = true end

    
    if not Config.ChamsEnabled then
        for _, ch in pairs(Cache.Chams or {}) do
            if ch then ch.Enabled = false end
        end
        if Cache.ChamsPartFallback then
            for plr, map in pairs(Cache.ChamsPartFallback) do
                if map and next(map) then
                    pcall(Chams_RestoreParts, plr)
                end
            end
        end
    elseif Config.ChamsEnabled then
        local enemyChamsCol = Config.Color_Chams or Theme.Accent
        Cache.ChamsTick = (Cache.ChamsTick or 0) + 1
        local doParts = (Cache.ChamsTick % 90 == 0) or Cache.ChamsForceRefresh
        Cache.ChamsForceRefresh = false
        local list = CachedPlayerList
        local nPlr = #list
        
        local step = (nPlr > 18) and 3 or ((nPlr > 10) and 2 or 1)
        local phase = (Cache.ChamsTick or 0) % step
        for i = 1, nPlr do
            if step > 1 and (i % step) ~= phase then
                
            else
            local player = list[i]
            if player ~= LocalPlayer then
                local char = player.Character
                local chams = Cache.Chams[player]
                
                if ShouldSkipEspPlayer(player) then
                    if chams then chams.Enabled = false end
                    
                    if Cache.ChamsPartFallback and Cache.ChamsPartFallback[player] and next(Cache.ChamsPartFallback[player]) then
                        pcall(Chams_RestoreParts, player)
                    end
                elseif char and char.Parent then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local alive = not hum or hum.Health > 0
                    if alive then
                        if not chams or not chams.Parent then
                            chams = Instance.new("Highlight")
                            chams.Name = "AnxiumChams_" .. tostring(player.UserId)
                            chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            chams.FillTransparency = 0.35
                            chams.OutlineTransparency = 0.1
                            chams.OutlineColor = Color3.fromRGB(255, 255, 255)
                            pcall(function()
                                if gethui then
                                    chams.Parent = gethui()
                                else
                                    chams.Parent = ScreenGui
                                end
                            end)
                            if not chams.Parent then
                                chams.Parent = CoreGui
                            end
                            Cache.Chams[player] = chams
                        end
                        chams.Adornee = char
                        chams.Enabled = true
                        local useCol = GetEspColorForPlayer(player, enemyChamsCol)
                        if Config.ChamsVisCheckEnabled and not IsEspTeammate(player) then
                            local cacheKey = player
                            local tickN = Cache.ChamsTick or 0
                            local cached = Cache.ChamsVisCache and Cache.ChamsVisCache[cacheKey]
                            if (not cached) or (tickN % 4 == 0) then
                                local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                                local vis = true
                                if head and typeof(IsVisibleToCamera) == "function" then
                                    local ok, res = pcall(IsVisibleToCamera, player, head)
                                    vis = ok and res == true
                                end
                                Cache.ChamsVisCache = Cache.ChamsVisCache or {}
                                Cache.ChamsVisCache[cacheKey] = vis
                                cached = vis
                            end
                            useCol = cached and (Config.Color_ChamsVisible or enemyChamsCol) or (Config.Color_ChamsOccluded or enemyChamsCol)
                        end
                        chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        ApplyChamsStyle(chams, useCol, Config.ChamsStyle)
                        if Cache.ChamsPartFallback and Cache.ChamsPartFallback[player] and next(Cache.ChamsPartFallback[player]) then
                            pcall(Chams_RestoreParts, player)
                        end
                        Cache.ChamsLastCol = Cache.ChamsLastCol or {}
                        Cache.ChamsLastCol[player] = useCol
                    elseif chams then
                        chams.Enabled = false
                    end
                elseif chams then
                    chams.Enabled = false
                end
            end
            end 
        end
    end

    if Config.AngelHaloEnabled then
        pcall(AngelHalo_Update)
    else
        pcall(AngelHalo_Hide)
    end
    do
        local tHrp = nil
        local tPlr = Cache.AimLockTarget or Cache.SilentV2Target or Cache.LastShotTarget
        if tPlr and typeof(tPlr) == "Instance" and tPlr:IsA("Player") and tPlr.Character then
            tHrp = tPlr.Character:FindFirstChild("HumanoidRootPart")
        end
        if Config.TargetDotEnabled then
            pcall(TargetDot_Update)
        elseif TargetDot_Hide then
            pcall(TargetDot_Hide)
        end
    end

    if Config.FootstepsEnabled and myHrp and myChar then
        local humanoid = myChar:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local onGround = humanoid.FloorMaterial ~= Enum.Material.Air
            local now = tick()

            if Cache.WasOnGround and not onGround and myHrp.AssemblyLinearVelocity.Y > 8 and (now - Cache.JumpCircleCooldown) > 0.35 then
                Cache.JumpCircleCooldown = now
                
                pcall(function()
                    local folder = Workspace:FindFirstChild("AnxiumJumpCircles")
                    if not folder then
                        folder = Instance.new("Folder")
                        folder.Name = "AnxiumJumpCircles"
                        folder.Parent = Workspace
                    end
                    do
                        local kids = folder:GetChildren()
                        while #kids > 3 do
                            pcall(function() kids[1]:Destroy() end)
                            table.remove(kids, 1)
                        end
                    end
                    RaycastParamsFootsteps.FilterDescendantsInstances = { myChar, folder }
                    local rayResult = Workspace:Raycast(myHrp.Position, Vector3.new(0, -15, 0), RaycastParamsFootsteps)
                    local floorPos = (rayResult and rayResult.Position or (myHrp.Position - Vector3.new(0, 3, 0))) + Vector3.new(0, 0.1, 0)
                    local col = Config.Color_JumpCircle or Theme.Accent
                    local segs = math.clamp(math.floor(tonumber(Config.JumpCircleSegments) or 48), 16, 80)
                    local startR = math.clamp(tonumber(Config.JumpCircleStartRadius) or 0.8, 0.15, 6)
                    local endR = math.clamp(tonumber(Config.JumpCircleSize) or 5, 0.5, 20)
                    local thick = math.clamp(tonumber(Config.JumpCircleThickness) or 0.18, 0.04, 1)
                    local expandT = math.clamp(tonumber(Config.JumpCircleExpandTime) or Config.JumpCircleLife or 0.7, 0.15, 3)

                    local model = Instance.new("Model")
                    model.Name = "JumpRing"
                    model.Parent = folder

                    local center = Instance.new("Part")
                    center.Name = "Center"
                    center.Anchored = true
                    center.CanCollide = false
                    center.CanQuery = false
                    center.CanTouch = false
                    center.CastShadow = false
                    center.Transparency = 1
                    center.Size = Vector3.new(0.1, 0.1, 0.1)
                    center.CFrame = CFrame.new(floorPos)
                    center.Parent = model

                    local startCirc = 2 * math.pi * startR
                    local startSegLen = (startCirc / segs) * 1.5
                    local endCirc = 2 * math.pi * endR
                    local endSegLen = (endCirc / segs) * 1.5
                    local tweenInfo = TweenInfo.new(expandT, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                    for i = 1, segs do
                        local angle = (i / segs) * math.pi * 2
                        local part = Instance.new("Part")
                        part.Name = "Seg"
                        part.Anchored = true
                        part.CanCollide = false
                        part.CanQuery = false
                        part.CanTouch = false
                        part.CastShadow = false
                        part.Material = Enum.Material.Neon
                        part.Color = col
                        part.Transparency = 0.15
                        part.Size = Vector3.new(startSegLen, 0.02, thick)
                        part.Parent = model

                        local pos = center.CFrame * CFrame.new(math.cos(angle) * startR, 0, math.sin(angle) * startR)
                        local tangent = angle + math.pi / 2
                        part.CFrame = CFrame.new(pos.Position) * CFrame.Angles(0, -tangent, 0)

                        local newPos = center.CFrame * CFrame.new(math.cos(angle) * endR, 0, math.sin(angle) * endR)
                        local newCF = CFrame.new(newPos.Position) * CFrame.Angles(0, -tangent, 0)
                        TweenService:Create(part, tweenInfo, {
                            CFrame = newCF,
                            Size = Vector3.new(endSegLen, 0.02, thick),
                            Transparency = 1,
                        }):Play()
                    end

                    task.delay(expandT + 0.35, function()
                        if model and model.Parent then model:Destroy() end
                    end)
                end)
            end

            Cache.WasOnGround = onGround
        end
    end

    if Config.ChinaHatEnabled and myHead then
      Cache._hatFrame = (Cache._hatFrame or 0) + 1
      if Cache._hatFrame % 2 == 0 then
      if (Config.ChinaHatStyle or "Drawing") == "Mesh" then
        HideHatDrawing()
        if not Cache.ChinaHatMesh or not Cache.ChinaHatMesh.Parent then
            ChinaHatMesh_Create()
        else
            ChinaHatMesh_Update()
        end
      elseif Drawing then
        ChinaHatMesh_Destroy()
        local scale = Config.ChinaHatScale or 1.0
        local hatHeight = (Config.ChinaHatHeight or 1.7) * scale
        local hatRadius = (Config.ChinaHatRadius or 2.3) * scale
        local hatCol = Config.Color_ChinaHat or Theme.Accent

        local headPos = myHead.Position + Vector3.new(0, Config.ChinaHatHeightOffset or 0.5, 0)
        local topPos = headPos + Vector3.new(0, hatHeight, 0)
        local segs = math.max(tonumber(Config.ChinaHatSegments) or 24, 8)
        local step = (math.pi * 2) / segs

        for i = 1, segs do
            local a1 = (i - 1) * step
            local a2 = i * step

            local base1 = headPos + Vector3.new(math.cos(a1) * hatRadius, 0, math.sin(a1) * hatRadius)
            local base2 = headPos + Vector3.new(math.cos(a2) * hatRadius, 0, math.sin(a2) * hatRadius)

            local s1 = WorldToScreen(base1)
            local s2 = WorldToScreen(base2)
            local s3 = WorldToScreen(topPos)

            local lines = Cache.ChinaHatLines[i]
            local tri = Cache.ChinaHatTris[i]

            if lines and tri and s1.Z > 0 and s2.Z > 0 and s3.Z > 0 then
                pcall(function()
                    lines.Line.Visible = true
                    lines.Line.From = Vector2.new(s1.X, s1.Y)
                    lines.Line.To = Vector2.new(s3.X, s3.Y)
                    lines.Line.Color = hatCol
                    lines.Line.Transparency = 0.75

                    lines.BaseLine.Visible = true
                    lines.BaseLine.From = Vector2.new(s1.X, s1.Y)
                    lines.BaseLine.To = Vector2.new(s2.X, s2.Y)
                    lines.BaseLine.Color = hatCol
                    lines.BaseLine.Transparency = 0.75
                end)

                pcall(function()
                    tri.Visible = true
                    tri.Filled = true
                    tri.PointA = Vector2.new(s1.X, s1.Y)
                    tri.PointB = Vector2.new(s2.X, s2.Y)
                    tri.PointC = Vector2.new(s3.X, s3.Y)
                    tri.Color = hatCol
                    tri.Transparency = 0.35
                end)
            else
                if lines then
                    pcall(function()
                        lines.Line.Visible = false
                        lines.BaseLine.Visible = false
                    end)
                end
                if tri then pcall(function() tri.Visible = false end) end
            end
        end
      end
      end
    else
        HideHatDrawing()
        ChinaHatMesh_Destroy()
    end

    
    pcall(function()
        if Scope_UpdateFOV then Scope_UpdateFOV() end
        if Scope_UpdateDraw then Scope_UpdateDraw() end
    end)

    if TargetLine_Update then pcall(TargetLine_Update) end

    if Config.CrosshairEnabled or Config.SpinCrosshairEnabled then
        if UserInputService.MouseIconEnabled then
            pcall(function() UserInputService.MouseIconEnabled = false end)
        end
        local mousePos = UserInputService:GetMouseLocation()
        local mx, my = mousePos.X, mousePos.Y
        local col = Config.Color_Crosshair or Theme.Accent
        local size = math.clamp(tonumber(Config.CrosshairSize) or 10, 2, 60)
        local gap = math.clamp(tonumber(Config.CrosshairGap) or 4, 0, 40)
        local thick = math.clamp(tonumber(Config.CrosshairThickness) or 1.4, 0.5, 8)
        local tr = 1 - math.clamp(tonumber(Config.CrosshairTransparency) or 0, 0, 0.95)
        if Config.SpinCrosshairEnabled and Cache.CrosshairSpinLines then
            CrosshairX.Visible = false
            CrosshairY.Visible = false
            local speed = tonumber(Config.SpinCrosshairSpeed) or 180
            Cache.CrosshairSpinAngle = (Cache.CrosshairSpinAngle or 0) + math.rad(speed) * (1/60)
            local ang = Cache.CrosshairSpinAngle
            local len = size
            for i = 1, 4 do
                local a = ang + (i - 1) * (math.pi * 0.5)
                local c, s = math.cos(a), math.sin(a)
                local ln = Cache.CrosshairSpinLines[i]
                if ln then
                    ln.Visible = true
                    ln.Color = col
                    ln.Thickness = thick
                    ln.Transparency = tr
                    ln.From = Vector2.new(mx + c * gap, my + s * gap)
                    ln.To = Vector2.new(mx + c * (gap + len), my + s * (gap + len))
                end
            end
        else
            if Cache.CrosshairSpinLines then
                for i = 1, 4 do
                    if Cache.CrosshairSpinLines[i] then Cache.CrosshairSpinLines[i].Visible = false end
                end
            end
            CrosshairX.Visible = true
            CrosshairY.Visible = true
            CrosshairX.Color = col
            CrosshairY.Color = col
            CrosshairX.Thickness = thick
            CrosshairY.Thickness = thick
            CrosshairX.Transparency = tr
            CrosshairY.Transparency = tr
            CrosshairX.From = Vector2.new(mx - (gap + size), my)
            CrosshairX.To = Vector2.new(mx - gap, my)
            CrosshairY.From = Vector2.new(mx, my - (gap + size))
            CrosshairY.To = Vector2.new(mx, my - gap)
            if not Cache._CrosshairX2 then
                local okL, lx = pcall(function() return Drawing.new("Line") end)
                local okR, ly = pcall(function() return Drawing.new("Line") end)
                if okL and lx and okR and ly then
                    Cache._CrosshairX2 = lx
                    Cache._CrosshairY2 = ly
                end
            end
            if Cache._CrosshairX2 and Cache._CrosshairY2 then
                Cache._CrosshairX2.Visible = true
                Cache._CrosshairY2.Visible = true
                Cache._CrosshairX2.Color = col
                Cache._CrosshairY2.Color = col
                Cache._CrosshairX2.Thickness = thick
                Cache._CrosshairY2.Thickness = thick
                Cache._CrosshairX2.Transparency = tr
                Cache._CrosshairY2.Transparency = tr
                Cache._CrosshairX2.From = Vector2.new(mx + gap, my)
                Cache._CrosshairX2.To = Vector2.new(mx + gap + size, my)
                Cache._CrosshairY2.From = Vector2.new(mx, my + gap)
                Cache._CrosshairY2.To = Vector2.new(mx, my + gap + size)
            else
                CrosshairX.From = Vector2.new(mx - size, my)
                CrosshairX.To = Vector2.new(mx + size, my)
                CrosshairY.From = Vector2.new(mx, my - size)
                CrosshairY.To = Vector2.new(mx, my + size)
            end
        end
        if Config.CrosshairDotEnabled then
            if not Cache.CrosshairDot then
                local okD, d = pcall(function() return Drawing.new("Circle") end)
                if okD and d then
                    d.Filled = true
                    d.NumSides = 24
                    Cache.CrosshairDot = d
                end
            end
            local dot = Cache.CrosshairDot
            if dot then
                dot.Visible = true
                dot.Color = col
                dot.Radius = math.clamp(tonumber(Config.CrosshairDotSize) or 3, 1, 16)
                dot.Transparency = 1 - math.clamp(tonumber(Config.CrosshairDotTransparency) or 0, 0, 0.95)
                dot.Position = Vector2.new(mx, my)
                dot.Thickness = 1
            end
        elseif Cache.CrosshairDot then
            Cache.CrosshairDot.Visible = false
        end
    else
        if CrosshairX.Visible then
            CrosshairX.Visible = false
            CrosshairY.Visible = false
        end
        if Cache._CrosshairX2 then Cache._CrosshairX2.Visible = false end
        if Cache._CrosshairY2 then Cache._CrosshairY2.Visible = false end
        if Cache.CrosshairDot then Cache.CrosshairDot.Visible = false end
        if Cache.CrosshairSpinLines then
            for i = 1, 4 do
                if Cache.CrosshairSpinLines[i] then Cache.CrosshairSpinLines[i].Visible = false end
            end
        end
    end

    
if Config.NameEspEnabled or Config.DistanceEspEnabled then
        local cam = Workspace.CurrentCamera or Camera
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local seen = {}
        if cam then
            for _, player in ipairs(CachedPlayerList or Players:GetPlayers()) do
                if player == LocalPlayer then continue end
                pcall(function()
                    if ShouldSkipEspPlayer(player) then
                        NameEsp_DestroyBill(player)
                        return
                    end
                    local showName = Config.NameEspEnabled == true
                    local showDist = Config.DistanceEspEnabled == true
                    if not showName and not showDist then
                        NameEsp_DestroyBill(player)
                        return
                    end
                    local char = (GetPlayerCharacter and GetPlayerCharacter(player)) or player.Character
                    if not char then NameEsp_DestroyBill(player) return end
                    local head = (GetCharHead and GetCharHead(char)) or char:FindFirstChild("Head")
                    local hum = (GetCharHumanoid and GetCharHumanoid(char)) or char:FindFirstChildOfClass("Humanoid")
                    if not head or (hum and hum.Health <= 0) then
                        NameEsp_DestroyBill(player)
                        return
                    end

                    local data = NameEsp_EnsureBill(player, head)
                    if not data or not data.label then return end
                    seen[player] = true
                    local lbl = data.label
                    lbl.Font = SelectedFont or Enum.Font.GothamBold
                    lbl.TextSize = 15

                    local text
                    if showName and showDist and myHrp then
                        local dist = (head.Position - myHrp.Position).Magnitude
                        text = (player.DisplayName or player.Name) .. " [" .. math.floor(dist * 0.28) .. "m]"
                    elseif showName then
                        text = player.DisplayName or player.Name
                    elseif showDist and myHrp then
                        local dist = (head.Position - myHrp.Position).Magnitude
                        text = "[" .. math.floor(dist * 0.28) .. "m]"
                    else
                        text = ""
                    end
                    if text == "" then
                        lbl.Visible = false
                        return
                    end
                    lbl.Text = text

                    local posX, posY
                    local usedBox = false
                    local boxData = Cache.Boxes[player]
                    if boxData and boxData.Box and boxData.Box.Visible and boxData.Box.Position then
                        local bp = boxData.Box.Position
                        local bs = boxData.Box.Size
                        if bp and bs and bs.X > 1 and bs.Y > 1 then
                            posX = bp.X + bs.X * 0.5
                            posY = bp.Y - 2
                            usedBox = true
                        end
                    end
                    if not usedBox then
                        local rect = Cache.EspScreenRect and Cache.EspScreenRect[player]
                        if rect and rect.cx and rect.top then
                            posX = rect.cx
                            posY = rect.top - 2
                            usedBox = true
                        end
                    end
                    if not usedBox then
                        local sp, vis = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 1.35, 0))
                        if not vis or sp.Z < 0.5 then
                            lbl.Visible = false
                            return
                        end
                        posX, posY = sp.X, sp.Y - 2
                    end

                    NameEsp_ApplyGradient(data)
                    lbl.Position = UDim2.fromOffset(math.floor(posX + 0.5), math.floor(posY + 0.5))
                    lbl.Visible = true
                end)
            end
        end
        for plr in pairs(Cache.EspNameBills or {}) do
            if not seen[plr] then
                pcall(NameEsp_DestroyBill, plr)
            end
        end
        for _, nameText in pairs(Cache.EspLabels or {}) do
            if nameText then pcall(function() nameText.Visible = false end) end
        end
    else
        for plr in pairs(Cache.EspNameBills or {}) do
            pcall(NameEsp_DestroyBill, plr)
        end
        for _, nameText in pairs(Cache.EspLabels or {}) do
            if nameText then pcall(function() nameText.Visible = false end) end
        end
    end


    if Config.SkeletonEnabled then
        Cache._skelFrame = (Cache._skelFrame or 0) + 1
        if Cache._skelFrame % 2 == 0 then
            for player, parts in pairs(Cache.Skeletons) do
                pcall(function()
                    if ShouldSkipEspPlayer(player) then
                        for _, line in pairs(parts) do if line then line.Visible = false end end
                        return
                    end
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local isR15 = char:FindFirstChild("UpperTorso") ~= nil
                        local head = GetPartPos(char, "Head")
                        local upperTorso = isR15 and GetPartPos(char, "UpperTorso") or GetPartPos(char, "Torso")
                        local lowerTorso = isR15 and GetPartPos(char, "LowerTorso") or upperTorso
                        local skCol = GetEspColorForPlayer(player, Config.Color_Skeleton or Theme.Accent)

                        local points = {
                            Head = head,
                            Neck = isR15 and upperTorso or upperTorso,
                            Spine = lowerTorso,
                            LeftUpperArm = isR15 and GetPartPos(char, "LeftUpperArm") or GetPartPos(char, "Left Arm"),
                            LeftLowerArm = isR15 and GetPartPos(char, "LeftLowerArm") or GetPartPos(char, "Left Arm"),
                            LeftHand = isR15 and GetPartPos(char, "LeftHand") or GetPartPos(char, "Left Arm"),
                            RightUpperArm = isR15 and GetPartPos(char, "RightUpperArm") or GetPartPos(char, "Right Arm"),
                            RightLowerArm = isR15 and GetPartPos(char, "RightLowerArm") or GetPartPos(char, "Right Arm"),
                            RightHand = isR15 and GetPartPos(char, "RightHand") or GetPartPos(char, "Right Arm"),
                            LeftUpperLeg = isR15 and GetPartPos(char, "LeftUpperLeg") or GetPartPos(char, "Left Leg"),
                            LeftLowerLeg = isR15 and GetPartPos(char, "LeftLowerLeg") or GetPartPos(char, "Left Leg"),
                            LeftFoot = isR15 and GetPartPos(char, "LeftFoot") or GetPartPos(char, "Left Leg"),
                            RightUpperLeg = isR15 and GetPartPos(char, "RightUpperLeg") or GetPartPos(char, "Right Leg"),
                            RightLowerLeg = isR15 and GetPartPos(char, "RightLowerLeg") or GetPartPos(char, "Right Leg"),
                            RightFoot = isR15 and GetPartPos(char, "RightFoot") or GetPartPos(char, "Right Leg"),
                        }

                        local function setSkel(name, a, b)
                            local line = parts[name]
                            if line and a and b then
                                line.Visible = true
                                line.From = a
                                line.To = b
                                line.Color = skCol
                            elseif line then
                                line.Visible = false
                            end
                        end

                        if points.Head and points.Neck then
                            setSkel("Head", points.Head, points.Neck)
                            local hc = parts.HeadCircle
                            if hc then
                                local headPart = char:FindFirstChild("Head")
                                local radius = 6
                                if headPart then
                                    local top = Workspace.CurrentCamera:WorldToViewportPoint(headPart.Position + Vector3.new(0, headPart.Size.Y * 0.5, 0))
                                    local bot = Workspace.CurrentCamera:WorldToViewportPoint(headPart.Position - Vector3.new(0, headPart.Size.Y * 0.5, 0))
                                    if top.Z > 0 and bot.Z > 0 then
                                        radius = math.clamp(math.abs(top.Y - bot.Y) * 0.55, 4, 48)
                                    end
                                end
                                hc.Visible = true
                                hc.Position = points.Head
                                hc.Radius = radius
                                hc.Color = skCol
                                hc.Thickness = 1.65
                                hc.Filled = false
                            end
                        else
                            for _, line in pairs(parts) do if line then line.Visible = false end end
                        end

                        if isR15 then
                            setSkel("Neck", points.Neck, points.Spine)
                            setSkel("Spine", points.Spine, points.LeftUpperLeg)
                            setSkel("LeftUpperArm", points.Spine, points.LeftUpperArm)
                            setSkel("LeftLowerArm", points.LeftUpperArm, points.LeftLowerArm)
                            setSkel("LeftHand", points.LeftLowerArm, points.LeftHand)
                            setSkel("RightUpperArm", points.Spine, points.RightUpperArm)
                            setSkel("RightLowerArm", points.RightUpperArm, points.RightLowerArm)
                            setSkel("RightHand", points.RightLowerArm, points.RightHand)
                            setSkel("LeftUpperLeg", points.Spine, points.LeftUpperLeg)
                            setSkel("LeftLowerLeg", points.LeftUpperLeg, points.LeftLowerLeg)
                            setSkel("LeftFoot", points.LeftLowerLeg, points.LeftFoot)
                            setSkel("RightUpperLeg", points.Spine, points.RightUpperLeg)
                            setSkel("RightLowerLeg", points.RightUpperLeg, points.RightLowerLeg)
                            setSkel("RightFoot", points.RightLowerLeg, points.RightFoot)
                        else
                            setSkel("Neck", points.Neck, points.Spine)
                            setSkel("Spine", points.Spine, points.Spine)
                            setSkel("LeftUpperArm", points.Spine, points.LeftUpperArm)
                            setSkel("RightUpperArm", points.Spine, points.RightUpperArm)
                            setSkel("LeftUpperLeg", points.Spine, points.LeftUpperLeg)
                            setSkel("RightUpperLeg", points.Spine, points.RightUpperLeg)
                            for _, name in ipairs({"LeftLowerArm","LeftHand","RightLowerArm","RightHand","LeftLowerLeg","LeftFoot","RightLowerLeg","RightFoot"}) do
                                if parts[name] then parts[name].Visible = false end
                            end
                        end
                    else
                        for _, line in pairs(parts) do if line then line.Visible = false end end
                    end
                end)
            end
        end
    else
        for _, parts in pairs(Cache.Skeletons) do
            for _, line in pairs(parts) do if line then line.Visible = false end end
        end
    end

    do
        local baseR = (Config.FovRadius or 150) + GetMovementDynamicExtra(Config.FovDynamicEnabled == true, Config.FovDynamicExpand, "FovDynamicExtra")
        local pulse = 1
        if Config.FovPulseEnabled then
            local spd = tonumber(Config.FovPulseSpeed) or 3
            local amt = tonumber(Config.FovPulseAmount) or 0.12
            pulse = 1 + math.sin(tick() * spd * 2) * amt
        end
        local r = baseR * pulse
        FovCircle.Position = screenCenter
        FovCircle.Radius = r
        FovCircle.Color = Config.Color_Fov or Theme.Accent
        FovCircle.Visible = Config.ShowFovEnabled
        if FovCircleFill then
            FovCircleFill.Position = screenCenter
            FovCircleFill.Radius = r
            FovCircleFill.Color = Config.Color_FovFill or Config.Color_Fov or Theme.Accent
            FovCircleFill.Transparency = Config.FovFillTransparency or 0.7
            FovCircleFill.Visible = Config.ShowFovEnabled == true and Config.FovFillEnabled == true
        end
    end

    if Config.TracersEnabled then
        local vp = Camera.ViewportSize
        local originMode = tostring(Config.TracerOrigin or "Bottom")
        local fromPos
        if originMode == "Top" then
            fromPos = Vector2.new(screenCenter.X, 0)
        elseif originMode == "Middle" or originMode == "Center" then
            fromPos = Vector2.new(screenCenter.X, screenCenter.Y)
        else
            fromPos = Vector2.new(screenCenter.X, vp.Y)
        end
        local useGrad = Config.TracerGradientEnabled == true
        local colA = Config.Color_Tracers or Theme.Accent
        local colB = Config.Color_TracerGradientB or Color3.fromRGB(255, 255, 255)
        for player, tr in pairs(Cache.TracerLines) do
            pcall(function()
                local function hideAll()
                    if typeof(tr) == "table" and tr.Segs then
                        for _, ln in ipairs(tr.Segs) do if ln then ln.Visible = false end end
                    elseif tr then tr.Visible = false end
                end
                if player and ShouldSkipEspPlayer(player) then
                    hideAll()
                    return
                end
                if not (player and tr and player.Character) then
                    hideAll()
                    return
                end
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then hideAll() return end
                local vector, onScreen = WorldToScreen(hrp.Position)
                if not (onScreen and vector.Z > 0) then hideAll() return end
                local toPos = Vector2.new(vector.X, vector.Y)
                local baseCol = GetEspColorForPlayer(player, colA)
                if typeof(tr) ~= "table" or not tr.Segs then
                    if tr then
                        tr.From = fromPos
                        tr.To = toPos
                        tr.Color = baseCol
                        tr.Visible = true
                    end
                    return
                end
                local n = tr.N or #tr.Segs
                if not useGrad then
                    local ln = tr.Segs[1]
                    if ln then
                        ln.From = fromPos
                        ln.To = toPos
                        ln.Color = baseCol
                        ln.Visible = true
                    end
                    for i = 2, n do
                        if tr.Segs[i] then tr.Segs[i].Visible = false end
                    end
                    return
                end
                for i = 1, n do
                    local ln = tr.Segs[i]
                    if ln then
                    local t0 = (i - 1) / n
                    local t1 = i / n
                    ln.From = fromPos:Lerp(toPos, t0)
                    ln.To = fromPos:Lerp(toPos, t1)
                    local tt = (t0 + t1) * 0.5
                    ln.Color = baseCol:Lerp(colB, tt)
                    ln.Visible = true
                    end
                end
            end)
        end
    else
        for _, tr in pairs(Cache.TracerLines) do
            if typeof(tr) == "table" and tr.Segs then
                for _, ln in ipairs(tr.Segs) do if ln then ln.Visible = false end end
            elseif tr then tr.Visible = false end
        end
    end

    if Config.SpeedHackEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Config.WalkSpeedValue
    end

    if Config.NoclipEnabled and LocalPlayer.Character then
        Cache._noclipFrame = (Cache._noclipFrame or 0) + 1
        if Cache._noclipFrame % 3 == 0 then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end

    
    if Config.FlyEnabled then
        pcall(FlyV3_Update)
    else
        pcall(FlyV3_Stop)
    end
end)


Cache.FlyV3Speed = 0
Cache.FlyV3Ctrl = { f = 0, b = 0, l = 0, r = 0 }

function FlyV3_GetTorso(char)
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.RigType == Enum.HumanoidRigType.R6 then
        return char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
end

function FlyV3_SetStates(hum, enableFly)
    if not hum then return end
    pcall(function()
        if enableFly then
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
            hum.PlatformStand = true
        else
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            hum.PlatformStand = false
        end
    end)
end

function FlyV3_Stop()
    if Cache.FlyBodyVelocity then
        pcall(function() Cache.FlyBodyVelocity:Destroy() end)
        Cache.FlyBodyVelocity = nil
    end
    if Cache.FlyBodyGyro then
        pcall(function() Cache.FlyBodyGyro:Destroy() end)
        Cache.FlyBodyGyro = nil
    end
    Cache.FlyV3Speed = 0
    Cache.FlyV3Ctrl = { f = 0, b = 0, l = 0, r = 0 }
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then FlyV3_SetStates(hum, false) end
end

function FlyV3_Update()
    local char = LocalPlayer.Character
    if not char then
        FlyV3_Stop()
        return
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local torso = FlyV3_GetTorso(char)
    local cam = Workspace.CurrentCamera or Camera
    if not torso or not cam or not hum or hum.Health <= 0 then
        FlyV3_Stop()
        return
    end

    FlyV3_SetStates(hum, true)

    if not Cache.FlyBodyGyro or not Cache.FlyBodyGyro.Parent then
        local bg = Instance.new("BodyGyro")
        bg.Name = "AnxiumFlyGyro"
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = torso.CFrame
        bg.Parent = torso
        Cache.FlyBodyGyro = bg
    end
    if not Cache.FlyBodyVelocity or not Cache.FlyBodyVelocity.Parent then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "AnxiumFlyVel"
        bv.Velocity = Vector3.new(0, 0.1, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = torso
        Cache.FlyBodyVelocity = bv
    end

    local ctrl = Cache.FlyV3Ctrl or { f = 0, b = 0, l = 0, r = 0 }
    ctrl.f = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
    ctrl.b = UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0
    ctrl.l = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
    ctrl.r = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
    Cache.FlyV3Ctrl = ctrl

    local maxspeed = math.clamp(tonumber(Config.FlySpeedValue) or 50, 1, 500)
    local speed = Cache.FlyV3Speed or 0
    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
        speed = speed + 0.5 + (speed / math.max(maxspeed, 1))
        if speed > maxspeed then speed = maxspeed end
    else
        speed = speed - 1
        if speed < 0 then speed = 0 end
    end
    Cache.FlyV3Speed = speed

    local cf = cam.CFrame
    local look = cf.LookVector
    local move = (look * (ctrl.f + ctrl.b))
        + ((cf * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0)).Position - cf.Position)
    move = move * speed

    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        move = move + Vector3.new(0, maxspeed * 0.85, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        move = move - Vector3.new(0, maxspeed * 0.85, 0)
    end

    if speed <= 0 and not UserInputService:IsKeyDown(Enum.KeyCode.Space)
        and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        Cache.FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    else
        Cache.FlyBodyVelocity.Velocity = move
    end

    Cache.FlyBodyGyro.CFrame = cf * CFrame.Angles(
        -math.rad((ctrl.f + ctrl.b) * 50 * speed / math.max(maxspeed, 1)),
        0,
        0
    )
end


function applySpin()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not Config.SpinEnabled then return end
    
    for _, v in pairs(hrp:GetChildren()) do
        if v.Name == "Spinning" then v:Destroy() end
    end
    local Spin = Instance.new("BodyAngularVelocity")
    Spin.Name = "Spinning"
    Spin.Parent = hrp
    Spin.MaxTorque = Vector3.new(0, math.huge, 0)
    Spin.AngularVelocity = Vector3.new(0, Config.SpinSpeed, 0)
end

function updateCharacterSpin()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if Config.SpinEnabled then
        hum.AutoRotate = false
        applySpin()
    else
        hum.AutoRotate = true
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then v:Destroy() end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    updateCharacterSpin()
end)

SpinBtn.MouseButton1Click:Connect(function()
    Config.SpinEnabled = not Config.SpinEnabled
    UpdateSwitch(Config.SpinEnabled, SpinBg, SpinKnob, "SpinBot")
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if Config.SpinEnabled then
        if hum then hum.AutoRotate = false end
        applySpin()
    else
        if hum then hum.AutoRotate = true end
        if hrp then
            for _, v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then v:Destroy() end
            end
        end
    end
end)
AntiAimBtn.MouseButton1Click:Connect(function()
    Config.AntiAimEnabled = not Config.AntiAimEnabled
    UpdateSwitch(Config.AntiAimEnabled, AntiAimBg, AntiAimKnob, "Anti-Aim")
    if not Config.AntiAimEnabled then
        pcall(AntiAim_RestoreMotors)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.AutoRotate = true end) end
    else
        Cache.AntiAimMotorBases = {}
        Cache.AntiAimSpinAngle = 0
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.AutoRotate = false end) end
    end
end)
AntiAimResolveBtn.MouseButton1Click:Connect(function()
    Config.AntiAimResolveEnabled = not Config.AntiAimResolveEnabled
    UpdateSwitch(Config.AntiAimResolveEnabled, AntiAimResolveBg, AntiAimResolveKnob, "AA Shoot Resolve")
end)


do
    if Cache.AutoJumpHB then pcall(function() Cache.AutoJumpHB:Disconnect() end) end
    Cache.AutoJumpHB = RunService.Heartbeat:Connect(function()
        if not Config or not Config.AutoJumpEnabled then return end
        if Config.BHopEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        if hum.FloorMaterial ~= Enum.Material.Air then
            pcall(function()
                hum.Jump = true
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end)
end


do
    local djJumps = 0
    local djMax = 2
    local djTick = 0
    local djStateConn = nil

    local function DoubleJump_HookHumanoid(hum)
        if djStateConn then pcall(function() djStateConn:Disconnect() end) end
        djStateConn = nil
        if not hum then return end
        djJumps = 0
        djStateConn = hum.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Landed then
                djJumps = 0
            end
        end)
    end

    local function DoubleJump_OnChar(char)
        task.defer(function()
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            DoubleJump_HookHumanoid(hum)
        end)
    end

    if LocalPlayer.Character then DoubleJump_OnChar(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(DoubleJump_OnChar)

    UserInputService.JumpRequest:Connect(function()
        if not Config or not Config.MultiJumpEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if djJumps < djMax and (tick() - djTick) > 0.2 then
            djTick = tick()
            djJumps = djJumps + 1
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

BoxEspBtn.MouseButton1Click:Connect(function()
    Config.BoxEspEnabled = not Config.BoxEspEnabled
    UpdateSwitch(Config.BoxEspEnabled, BoxEspBg, BoxEspKnob, "2D Box ESP")
end)
TeamEspBtn.MouseButton1Click:Connect(function()
    Config.TeamEspEnabled = not Config.TeamEspEnabled
    UpdateSwitch(Config.TeamEspEnabled, TeamEspBg, TeamEspKnob, "Team ESP")
    pcall(function()
        if RefreshTeamIgnoreVisuals then RefreshTeamIgnoreVisuals() end
    end)
end)
TeamNameEspBtn.MouseButton1Click:Connect(function()
    Config.TeamNameEspEnabled = not Config.TeamNameEspEnabled
    UpdateSwitch(Config.TeamNameEspEnabled, TeamNameEspBg, TeamNameEspKnob, "Team Name ESP")
end)
TeamDistEspBtn.MouseButton1Click:Connect(function()
    Config.TeamDistanceEspEnabled = not Config.TeamDistanceEspEnabled
    UpdateSwitch(Config.TeamDistanceEspEnabled, TeamDistEspBg, TeamDistEspKnob, "Team Distance ESP")
end)

BoxFillBtn.MouseButton1Click:Connect(function()
    Config.BoxFillGradientEnabled = not Config.BoxFillGradientEnabled
    UpdateSwitch(Config.BoxFillGradientEnabled, BoxFillBg, BoxFillKnob, "Box Fill Gradient")
end)
BoxOutlineGradBtn.MouseButton1Click:Connect(function()
    Config.BoxOutlineGradient = not Config.BoxOutlineGradient
    UpdateSwitch(Config.BoxOutlineGradient, BoxOutlineGradBg, BoxOutlineGradKnob, "Box Outline Gradient")
end)
BoxFillRotBtn.MouseButton1Click:Connect(function()
    Config.BoxFillRotation = not Config.BoxFillRotation
    UpdateSwitch(Config.BoxFillRotation, BoxFillRotBg, BoxFillRotKnob, "Fill Rotation")
end)

HealthbarEspBtn.MouseButton1Click:Connect(function()
    Config.HealthbarEspEnabled = not Config.HealthbarEspEnabled
    UpdateSwitch(Config.HealthbarEspEnabled, HealthbarEspBg, HealthbarEspKnob, "Healthbar ESP")
end)

ChamsVisBtn.MouseButton1Click:Connect(function()
    Config.ChamsVisCheckEnabled = not Config.ChamsVisCheckEnabled
    UpdateSwitch(Config.ChamsVisCheckEnabled, ChamsVisBg, ChamsVisKnob, "Enable Vis Colors")
end)
ChamsBtn.MouseButton1Click:Connect(function()
    Config.ChamsEnabled = not Config.ChamsEnabled
    UpdateSwitch(Config.ChamsEnabled, ChamsBg, ChamsKnob, "Chams Wallhack")
    Cache.ChamsPartFallback = Cache.ChamsPartFallback or {}
    Cache.ChamsForceRefresh = true

    for _, player in ipairs((CachedPlayerList or Players:GetPlayers())) do
        if player ~= LocalPlayer then
            pcall(function()
                if ApplyEspToPlayer then ApplyEspToPlayer(player) end
            end)
            local char = (GetPlayerCharacter and GetPlayerCharacter(player)) or player.Character
            local chams = Cache.Chams[player]
            if Config.ChamsEnabled and char then
                if not chams or not chams.Parent then
                    chams = Instance.new("Highlight")
                    chams.Name = "AnxiumChams_" .. tostring(player.UserId)
                    chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    chams.FillTransparency = 0.4
                    chams.OutlineTransparency = 0.2
                    pcall(function()
                        if gethui then chams.Parent = gethui()
                        else chams.Parent = ScreenGui end
                    end)
                    Cache.Chams[player] = chams
                end
                chams.Adornee = char
                chams.Enabled = true
                chams.FillColor = GetEspColorForPlayer(targetPlayer, Config.Color_Chams or Theme.Accent)
                chams.OutlineColor = Color3.fromRGB(255, 255, 255)
                
            else
                if chams then chams.Enabled = false end
                local map = Cache.ChamsPartFallback[player]
                if map then
                    for part, data in pairs(map) do
                        if part and part.Parent and data then
                            pcall(function()
                                part.Material = data.Material
                                part.Color = data.Color
                            end)
                        end
                    end
                    Cache.ChamsPartFallback[player] = {}
                end
            end
        end
    end
end)

ActiveListBtn.MouseButton1Click:Connect(function()
    Config.ActiveListEnabled = not Config.ActiveListEnabled
    UpdateSwitch(Config.ActiveListEnabled, ActiveListBg, ActiveListKnob, "Active Modules HUD")
end)
BindListBtn.MouseButton1Click:Connect(function()
    Config.BindListEnabled = not Config.BindListEnabled
    UpdateSwitch(Config.BindListEnabled, BindListBg, BindListKnob, "Binds HUD")
    if UpdateBindList then UpdateBindList() end
end)
FakeFpsBtn.MouseButton1Click:Connect(function()
    Config.FakeFpsEnabled = not Config.FakeFpsEnabled
    UpdateSwitch(Config.FakeFpsEnabled, FakeFpsBg, FakeFpsKnob, "Fake FPS")
    UpdateFakeFpsDisplay()
end)

NameEspBtn.MouseButton1Click:Connect(function() Config.NameEspEnabled = not Config.NameEspEnabled UpdateSwitch(Config.NameEspEnabled, NameEspBg, NameEspKnob, "Name ESP") end)
DistEspBtn.MouseButton1Click:Connect(function() Config.DistanceEspEnabled = not Config.DistanceEspEnabled UpdateSwitch(Config.DistanceEspEnabled, DistEspBg, DistEspKnob, "Distance ESP") end)

NameEspGradBtn.MouseButton1Click:Connect(function()
    Config.NameEspGradientEnabled = not Config.NameEspGradientEnabled
    UpdateSwitch(Config.NameEspGradientEnabled, NameEspGradBg, NameEspGradKnob, "Name/Dist Gradient")
    if NameEsp_RefreshGradients then pcall(NameEsp_RefreshGradients) end
end)
if TeamNameEspGradBtn then
    TeamNameEspGradBtn.MouseButton1Click:Connect(function()
        Config.TeamNameEspGradientEnabled = not Config.TeamNameEspGradientEnabled
        UpdateSwitch(Config.TeamNameEspGradientEnabled, TeamNameEspGradBg, TeamNameEspGradKnob, "Team Name Gradient")
        if NameEsp_RefreshGradients then pcall(NameEsp_RefreshGradients) end
    end)
end

SkelBtn.MouseButton1Click:Connect(function() Config.SkeletonEnabled = not Config.SkeletonEnabled UpdateSwitch(Config.SkeletonEnabled, SkelBg, SkelKnob, "Skeleton ESP") end)
TracerBtn.MouseButton1Click:Connect(function() Config.TracersEnabled = not Config.TracersEnabled UpdateSwitch(Config.TracersEnabled, TracerBg, TracerKnob, "Tracers") end)
TracerGradBtn.MouseButton1Click:Connect(function()
    Config.TracerGradientEnabled = not Config.TracerGradientEnabled
    UpdateSwitch(Config.TracerGradientEnabled, TracerGradBg, TracerGradKnob, "Tracer Gradient")
end)

ScopeBtn.MouseButton1Click:Connect(function()
    Config.ScopeEnabled = not Config.ScopeEnabled
    UpdateSwitch(Config.ScopeEnabled, ScopeBg, ScopeKnob, "Sniper Scope")
    if not Config.ScopeEnabled then
        pcall(function() if Scope_Hide then Scope_Hide() end end)
        Notify("Scope", "Disabled")
    else
        local k = Config.ScopeKey
        if not k or k == "" then
            Notify("Scope", "On - set Scope Key below, then hold/toggle it")
        else
            Notify("Scope", "On - press [" .. k .. "] to ADS")
        end
    end
end)
ScopeGradBtn.MouseButton1Click:Connect(function()
    Config.ScopeGradientEnabled = not Config.ScopeGradientEnabled
    UpdateSwitch(Config.ScopeGradientEnabled, ScopeGradBg, ScopeGradKnob, "Scope Gradient")
end)
ScopeDynBtn.MouseButton1Click:Connect(function()
    Config.ScopeDynamicEnabled = not Config.ScopeDynamicEnabled
    UpdateSwitch(Config.ScopeDynamicEnabled, ScopeDynBg, ScopeDynKnob, "Scope Dynamic")
end)
ScopeSoundBtn.MouseButton1Click:Connect(function()
    Config.ScopeSoundEnabled = not Config.ScopeSoundEnabled
    UpdateSwitch(Config.ScopeSoundEnabled, ScopeSoundBg, ScopeSoundKnob, "Scope Sound")
end)

CrossBtn.MouseButton1Click:Connect(function()
    Config.CrosshairEnabled = not Config.CrosshairEnabled
    UpdateSwitch(Config.CrosshairEnabled, CrossBg, CrossKnob, "Crosshair")
    pcall(function()
        UserInputService.MouseIconEnabled = not (Config.CrosshairEnabled or Config.SpinCrosshairEnabled)
    end)
end)


CrossDotBtn.MouseButton1Click:Connect(function()
    Config.CrosshairDotEnabled = not Config.CrosshairDotEnabled
    UpdateSwitch(Config.CrosshairDotEnabled, CrossDotBg, CrossDotKnob, "Crosshair Dot")
end)
SpinCrossBtn.MouseButton1Click:Connect(function()
    Config.SpinCrosshairEnabled = not Config.SpinCrosshairEnabled
    UpdateSwitch(Config.SpinCrosshairEnabled, SpinCrossBg, SpinCrossKnob, "Spin Crosshair")
    pcall(function()
        UserInputService.MouseIconEnabled = not (Config.CrosshairEnabled or Config.SpinCrosshairEnabled)
    end)
end)
DmgNumBtn.MouseButton1Click:Connect(function()
    Config.DamageNumbersEnabled = not Config.DamageNumbersEnabled
    UpdateSwitch(Config.DamageNumbersEnabled, DmgNumBg, DmgNumKnob, "Damage Numbers")
end)


SelfChamsBtn.MouseButton1Click:Connect(function()
    Config.SelfChamsEnabled = not Config.SelfChamsEnabled
    UpdateSwitch(Config.SelfChamsEnabled, SelfChamsBg, SelfChamsKnob, "Self Chams")
    if not Config.SelfChamsEnabled and SelfChams_Clear then SelfChams_Clear() end
end)
CloneChamsBtn.MouseButton1Click:Connect(function()
    Config.CloneChamsEnabled = not Config.CloneChamsEnabled
    UpdateSwitch(Config.CloneChamsEnabled, CloneChamsBg, CloneChamsKnob, "Clone player")
end)
OffscreenBtn.MouseButton1Click:Connect(function()
    Config.OffscreenArrowsEnabled = not Config.OffscreenArrowsEnabled
    UpdateSwitch(Config.OffscreenArrowsEnabled, OffscreenBg, OffscreenKnob, "Offscreen Arrows")
    if not Config.OffscreenArrowsEnabled and UV_ClearArrows then UV_ClearArrows() end
end)
ArrowPulseBtn.MouseButton1Click:Connect(function()
    Config.ArrowPulseEnabled = not Config.ArrowPulseEnabled
    UpdateSwitch(Config.ArrowPulseEnabled, ArrowPulseBg, ArrowPulseKnob, "Arrow Pulse")
end)
DeathChamsBtn.MouseButton1Click:Connect(function()
    Config.DeathChamsEnabled = not Config.DeathChamsEnabled
    UpdateSwitch(Config.DeathChamsEnabled, DeathChamsBg, DeathChamsKnob, "Death player")
end)
DeathBurstBtn.MouseButton1Click:Connect(function()
    Config.DeathBurstEnabled = not Config.DeathBurstEnabled
    UpdateSwitch(Config.DeathBurstEnabled, DeathBurstBg, DeathBurstKnob, "Death Burst")
end)
DeathXRayBtn.MouseButton1Click:Connect(function()
    Config.DeathEffectsXRay = not Config.DeathEffectsXRay
    UpdateSwitch(Config.DeathEffectsXRay, DeathXRayBg, DeathXRayKnob, "Death FX Through Walls")
end)
KillDissolveBtn.MouseButton1Click:Connect(function()
    Config.KillDissolveEnabled = not Config.KillDissolveEnabled
    UpdateSwitch(Config.KillDissolveEnabled, KillDissolveBg, KillDissolveKnob, "Kill Dissolve")
end)


CameraFovBtn.MouseButton1Click:Connect(function()
    Config.CameraFovEnabled = not Config.CameraFovEnabled
    UpdateSwitch(Config.CameraFovEnabled, CameraFovBg, CameraFovKnob, "Camera FOV")
    CameraFov_Apply()
end)

FpsBoostBtn.MouseButton1Click:Connect(function()
    Config.FpsBoostEnabled = not Config.FpsBoostEnabled
    UpdateSwitch(Config.FpsBoostEnabled, FpsBoostBg, FpsBoostKnob, "FPS Boost")
    FpsBoost_Apply()
end)

FullBtn.MouseButton1Click:Connect(function()
    Config.FullbrightEnabled = not Config.FullbrightEnabled
    UpdateSwitch(Config.FullbrightEnabled, FullBg, FullKnob, "Fullbright")
    if Config.FullbrightEnabled and Config.DarkModeEnabled then
        Config.DarkModeEnabled = false
        UpdateSwitch(false, DarkModeBg, DarkModeKnob)
    end
    if not Config.FullbrightEnabled and not Config.DarkModeEnabled then
        Lighting.Ambient = LightingDefaults.Ambient
        Lighting.ColorShift_Bottom = LightingDefaults.ColorShift_Bottom
        Lighting.ColorShift_Top = LightingDefaults.ColorShift_Top
        Lighting.Brightness = LightingDefaults.Brightness
        Lighting.OutdoorAmbient = LightingDefaults.OutdoorAmbient
    end
end)

DarkModeBtn.MouseButton1Click:Connect(function()
    Config.DarkModeEnabled = not Config.DarkModeEnabled
    UpdateSwitch(Config.DarkModeEnabled, DarkModeBg, DarkModeKnob, "Dark Mode")
    if Config.DarkModeEnabled and Config.FullbrightEnabled then
        Config.FullbrightEnabled = false
        UpdateSwitch(false, FullBg, FullKnob)
    end
    if Config.DarkModeEnabled and Config.WorldColorEnabled then
        Config.WorldColorEnabled = false
        UpdateSwitch(false, WorldColorBg, WorldColorKnob)
    end
    if not Config.DarkModeEnabled and not Config.FullbrightEnabled and not Config.WorldColorEnabled then
        Lighting.Ambient = LightingDefaults.Ambient
        Lighting.ColorShift_Bottom = LightingDefaults.ColorShift_Bottom
        Lighting.ColorShift_Top = LightingDefaults.ColorShift_Top
        Lighting.Brightness = LightingDefaults.Brightness
        Lighting.OutdoorAmbient = LightingDefaults.OutdoorAmbient
    end
end)
WorldColorBtn.MouseButton1Click:Connect(function()
    Config.WorldColorEnabled = not Config.WorldColorEnabled
    UpdateSwitch(Config.WorldColorEnabled, WorldColorBg, WorldColorKnob, "World Color")
    if Config.WorldColorEnabled then
        if Config.FullbrightEnabled then
            Config.FullbrightEnabled = false
            UpdateSwitch(false, FullBg, FullKnob)
        end
        if Config.DarkModeEnabled then
            Config.DarkModeEnabled = false
            UpdateSwitch(false, DarkModeBg, DarkModeKnob)
        end
    end
    pcall(ApplyWorldVisuals)
end)
NoShadowsBtn.MouseButton1Click:Connect(function()
    Config.NoShadowsEnabled = not Config.NoShadowsEnabled
    UpdateSwitch(Config.NoShadowsEnabled, NoShadowsBg, NoShadowsKnob, "No Shadows")
    pcall(ApplyWorldVisuals)
end)
HitMarkerBtn.MouseButton1Click:Connect(function()
    Config.HitMarkerEnabled = not Config.HitMarkerEnabled
    UpdateSwitch(Config.HitMarkerEnabled, HitMarkerBg, HitMarkerKnob, "Hit Marker")
end)

HatBtn.MouseButton1Click:Connect(function()
    Config.ChinaHatEnabled = not Config.ChinaHatEnabled
    UpdateSwitch(Config.ChinaHatEnabled, HatBg, HatKnob, "China Hat")
    ChinaHat_ApplyStyle()
end)
AngelHaloBtn.MouseButton1Click:Connect(function()
    Config.AngelHaloEnabled = not Config.AngelHaloEnabled
    UpdateSwitch(Config.AngelHaloEnabled, AngelHaloBg, AngelHaloKnob, "Angel Halo")
    if not Config.AngelHaloEnabled then
        pcall(AngelHalo_Hide)
    end
end)


OrbitOrbsBtn.MouseButton1Click:Connect(function() Config.OrbitOrbsEnabled = not Config.OrbitOrbsEnabled UpdateSwitch(Config.OrbitOrbsEnabled, OrbitOrbsBg, OrbitOrbsKnob, "Neon Orbit") end)
TargetMarkerBtn.MouseButton1Click:Connect(function()
    Config.TargetMarkerEnabled = not Config.TargetMarkerEnabled
    UpdateSwitch(Config.TargetMarkerEnabled, TargetMarkerBg, TargetMarkerKnob, "Target Marker")
    if not Config.TargetMarkerEnabled and TargetMarker_Hide then pcall(TargetMarker_Hide) end
end)

TargetDotBtn.MouseButton1Click:Connect(function()
    Config.TargetDotEnabled = not Config.TargetDotEnabled
    UpdateSwitch(Config.TargetDotEnabled, TargetDotBg, TargetDotKnob, "Target Dot")
    if not Config.TargetDotEnabled and TargetDot_Hide then pcall(TargetDot_Hide) end
end)
TargetMarkerRotBtn.MouseButton1Click:Connect(function()
    Config.TargetMarkerRotate = not Config.TargetMarkerRotate
    UpdateSwitch(Config.TargetMarkerRotate, TargetMarkerRotBg, TargetMarkerRotKnob, "Marker Rotate")
end)
TargetRingBtn.MouseButton1Click:Connect(function()
    Config.TargetRingEnabled = not Config.TargetRingEnabled
    UpdateSwitch(Config.TargetRingEnabled, TargetRingBg, TargetRingKnob, "Target Scan Ring")
    if not Config.TargetRingEnabled and TargetRing_Hide then pcall(TargetRing_Hide) end
end)

TrailBtn.MouseButton1Click:Connect(function()
    Config.TrailEnabled = not Config.TrailEnabled
    UpdateSwitch(Config.TrailEnabled, TrailBg, TrailKnob, "Motion Trail")
    if Cache.PlayerTrail then Cache.PlayerTrail.Enabled = Config.TrailEnabled; Cache.PlayerTrail.Color = ColorSequence.new(Config.Color_Trail or Theme.Accent) end
end)

AspectBtn.MouseButton1Click:Connect(function()
    Config.AspectRatioEnabled = not Config.AspectRatioEnabled
    UpdateSwitch(Config.AspectRatioEnabled, AspectBg, AspectKnob, "Aspect Ratio")
end)

ThirdPersonBtn.MouseButton1Click:Connect(function()
    Config.ThirdPersonEnabled = not Config.ThirdPersonEnabled
    UpdateSwitch(Config.ThirdPersonEnabled, ThirdPersonBg, ThirdPersonKnob, "Third Person")
    if Config.ThirdPersonEnabled then
        ThirdPerson_Enable()
    else
        ThirdPerson_Disable()
    end
end)

DayCycleBtn.MouseButton1Click:Connect(function()
    Config.DayCycleEnabled = not Config.DayCycleEnabled
    UpdateSwitch(Config.DayCycleEnabled, DayCycleBg, DayCycleKnob, "Day Cycle")
    if Config.DayCycleEnabled then
        if DayCycle_Apply then DayCycle_Apply(true) end
    else
        if DayCycle_Restore then DayCycle_Restore() end
    end
end)

NoFogBtn.MouseButton1Click:Connect(function()
    Config.NoFogEnabled = not Config.NoFogEnabled
    UpdateSwitch(Config.NoFogEnabled, NoFogBg, NoFogKnob, "No Fog")
    if Config.NoFogEnabled and Config.FogEnabled then
        Config.FogEnabled = false
        UpdateSwitch(false, FogBg, FogKnob)
    end
end)
SelfTransBtn.MouseButton1Click:Connect(function()
    Config.SelfTransparencyEnabled = not Config.SelfTransparencyEnabled
    UpdateSwitch(Config.SelfTransparencyEnabled, SelfTransBg, SelfTransKnob, "Self Transparency")
    pcall(SelfTransparency_Bind)
    pcall(ApplySelfTransparency)
end)
FogBtn.MouseButton1Click:Connect(function()
    Config.FogEnabled = not Config.FogEnabled
    UpdateSwitch(Config.FogEnabled, FogBg, FogKnob, "Custom Fog")
    if Config.FogEnabled and Config.NoFogEnabled then
        Config.NoFogEnabled = false
        UpdateSwitch(false, NoFogBg, NoFogKnob)
    end
    if not Config.FogEnabled then
        local fogAtm = Lighting:FindFirstChild("AnxiumFogAtmosphere")
        if fogAtm then fogAtm:Destroy() end
        Lighting.FogStart = LightingDefaults.FogStart
        Lighting.FogEnd = LightingDefaults.FogEnd
        Lighting.FogColor = LightingDefaults.FogColor
    end
end)

FallingStarsBtn.MouseButton1Click:Connect(function()
    Config.FallingStarsEnabled = not Config.FallingStarsEnabled
    UpdateSwitch(Config.FallingStarsEnabled, FallingStarsBg, FallingStarsKnob, "Falling Stars")
    if Cache.FallingStarsSetEnabled then pcall(Cache.FallingStarsSetEnabled, Config.FallingStarsEnabled) end
end)
FootstepsBtn.MouseButton1Click:Connect(function() Config.FootstepsEnabled = not Config.FootstepsEnabled UpdateSwitch(Config.FootstepsEnabled, FootstepsBg, FootstepsKnob, "Jump Circles") end)

AimBtn.MouseButton1Click:Connect(function()
    Config.AimEnabled = not Config.AimEnabled
    UpdateSwitch(Config.AimEnabled, AimBg, AimKnob, "Aimbot")
    if not Config.AimEnabled then Cache.AimLockTarget = nil end
end)
AimWallBtn.MouseButton1Click:Connect(function()
    Config.AimWallCheck = not Config.AimWallCheck
    UpdateSwitch(Config.AimWallCheck, AimWallBg, AimWallKnob, "Aim Wall Check")
    if not Config.AimWallCheck then
        Notify("Aimbot", "Wall check OFF - can lock through walls")
    else
        Notify("Aimbot", "Wall check ON - only visible targets")
    end
end)
ShowFovBtn.MouseButton1Click:Connect(function() Config.ShowFovEnabled = not Config.ShowFovEnabled UpdateSwitch(Config.ShowFovEnabled, ShowFovBg, ShowFovKnob, "Show FOV") end)
FovFillBtn.MouseButton1Click:Connect(function()
    Config.FovFillEnabled = not Config.FovFillEnabled
    UpdateSwitch(Config.FovFillEnabled, FovFillBg, FovFillKnob, "FOV Fill")
end)
FovPulseBtn.MouseButton1Click:Connect(function()
    Config.FovPulseEnabled = not Config.FovPulseEnabled
    UpdateSwitch(Config.FovPulseEnabled, FovPulseBg, FovPulseKnob, "FOV Pulse")
end)


TargetLineBtn.MouseButton1Click:Connect(function()
    Config.TargetLineEnabled = not Config.TargetLineEnabled
    UpdateSwitch(Config.TargetLineEnabled, TargetLineBg, TargetLineKnob, "Target Line")
    if not Config.TargetLineEnabled then TargetLine_Hide() end
end)
TargetLineVisBtn.MouseButton1Click:Connect(function()
    Config.TargetLineVisibleCheck = not Config.TargetLineVisibleCheck
    UpdateSwitch(Config.TargetLineVisibleCheck, TargetLineVisBg, TargetLineVisKnob, "TL Visible Check")
end)
TargetHudBtn.MouseButton1Click:Connect(function()
    Config.TargetHudEnabled = not Config.TargetHudEnabled
    UpdateSwitch(Config.TargetHudEnabled, TargetHudBg, TargetHudKnob, "Target HUD")
    if not Config.TargetHudEnabled then HideTargetHud() end
end)

TriggerbotBtn.MouseButton1Click:Connect(function()
    Config.TriggerbotEnabled = not Config.TriggerbotEnabled
    UpdateSwitch(Config.TriggerbotEnabled, TriggerbotBg, TriggerbotKnob, "Triggerbot")
end)

TriggerbotAWBtn.MouseButton1Click:Connect(function()
    Config.TriggerbotAutowall = not Config.TriggerbotAutowall
    UpdateSwitch(Config.TriggerbotAutowall, TriggerbotAWBg, TriggerbotAWKnob, "Trigger Autowall")
end)

WeaponAutoSwapBtn.MouseButton1Click:Connect(function()
    Config.WeaponAutoSwapEnabled = not Config.WeaponAutoSwapEnabled
    UpdateSwitch(Config.WeaponAutoSwapEnabled, WeaponAutoSwapBg, WeaponAutoSwapKnob, "Weapon Auto Swap")
    WeaponAutoSwap_Apply()
end)

SilentV2Btn.MouseButton1Click:Connect(function()
    Config.SilentAimV2Enabled = not Config.SilentAimV2Enabled
    UpdateSwitch(Config.SilentAimV2Enabled, SilentV2Bg, SilentV2Knob, "Silent Aim")
    if not Config.SilentAimV2Enabled then
        Cache.SilentV2Target = nil
        Cache.SilentV2Part = nil
        Cache.SilentV2Pos = nil
    end
end)
SilentV2FovBtn.MouseButton1Click:Connect(function()
    Config.SilentV2ShowFov = not Config.SilentV2ShowFov
    UpdateSwitch(Config.SilentV2ShowFov, SilentV2FovBg, SilentV2FovKnob, "Show Silent FOV")
end)
SilentV2FovFillBtn.MouseButton1Click:Connect(function()
    Config.SilentV2FovFillEnabled = not Config.SilentV2FovFillEnabled
    UpdateSwitch(Config.SilentV2FovFillEnabled, SilentV2FovFillBg, SilentV2FovFillKnob, "Silent FOV Fill")
end)
SilentV2FovPulseBtn.MouseButton1Click:Connect(function()
    Config.SilentV2FovPulseEnabled = not Config.SilentV2FovPulseEnabled
    UpdateSwitch(Config.SilentV2FovPulseEnabled, SilentV2FovPulseBg, SilentV2FovPulseKnob, "Silent FOV Pulse")
end)
FovDynBtn.MouseButton1Click:Connect(function()
    Config.FovDynamicEnabled = not Config.FovDynamicEnabled
    UpdateSwitch(Config.FovDynamicEnabled, FovDynBg, FovDynKnob, "FOV Dynamic")
end)
SilentFovDynBtn.MouseButton1Click:Connect(function()
    Config.SilentV2FovDynamicEnabled = not Config.SilentV2FovDynamicEnabled
    UpdateSwitch(Config.SilentV2FovDynamicEnabled, SilentFovDynBg, SilentFovDynKnob, "Silent FOV Dynamic")
end)

SilentV2TeamBtn.MouseButton1Click:Connect(function()
    Config.SilentV2TeamCheck = not Config.SilentV2TeamCheck
    UpdateSwitch(Config.SilentV2TeamCheck, SilentV2TeamBg, SilentV2TeamKnob, "Silent Team Check")
end)
SilentV2VisBtn.MouseButton1Click:Connect(function()
    Config.SilentV2VisibleCheck = not Config.SilentV2VisibleCheck
    UpdateSwitch(Config.SilentV2VisibleCheck, SilentV2VisBg, SilentV2VisKnob, "Silent Visible Check")
end)
SilentV2PredBtn.MouseButton1Click:Connect(function()
    Config.SilentV2Prediction = not Config.SilentV2Prediction
    UpdateSwitch(Config.SilentV2Prediction, SilentV2PredBg, SilentV2PredKnob, "Silent Prediction")
end)
if SilentV2MultiBtn then
    SilentV2MultiBtn.MouseButton1Click:Connect(function()
        Config.SilentV2MultipointEnabled = not Config.SilentV2MultipointEnabled
        UpdateSwitch(Config.SilentV2MultipointEnabled, SilentV2MultiBg, SilentV2MultiKnob, "Silent Multipoint")
    end)
end
SilentV2StickyBtn.MouseButton1Click:Connect(function()
    Config.SilentV2Sticky = not Config.SilentV2Sticky
    UpdateSwitch(Config.SilentV2Sticky, SilentV2StickyBg, SilentV2StickyKnob, "Silent Sticky")
end)
TeamCheckerBtn.MouseButton1Click:Connect(function()
    Config.TeamCheckerEnabled = not Config.TeamCheckerEnabled
    UpdateSwitch(Config.TeamCheckerEnabled, TeamCheckerBg, TeamCheckerKnob, "Team Checker")
    Cache.TeamCache = {}
    pcall(function()
        if RefreshTeamIgnoreVisuals then RefreshTeamIgnoreVisuals() end
    end)
    if Config.TeamCheckerEnabled then
        Notify("Team Checker", "Allies ignored (ESP / aim)")
    else
        Notify("Team Checker", "Disabled - all players targetable")
    end
end)

JumpBtn.MouseButton1Click:Connect(function() Config.MultiJumpEnabled = not Config.MultiJumpEnabled UpdateSwitch(Config.MultiJumpEnabled, JumpBg, JumpKnob, "Double Jump") end)
AutoJumpBtn.MouseButton1Click:Connect(function() Config.AutoJumpEnabled = not Config.AutoJumpEnabled UpdateSwitch(Config.AutoJumpEnabled, AutoJumpBg, AutoJumpKnob, "Auto Jump") end)
SpeedBtn.MouseButton1Click:Connect(function()
    Config.SpeedHackEnabled = not Config.SpeedHackEnabled
    UpdateSwitch(Config.SpeedHackEnabled, SpeedBg, SpeedKnob, "Speed Hack")
    if not Config.SpeedHackEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
NoclipBtn.MouseButton1Click:Connect(function() Config.NoclipEnabled = not Config.NoclipEnabled UpdateSwitch(Config.NoclipEnabled, NoclipBg, NoclipKnob, "Noclip") end)
FlyBtn.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    UpdateSwitch(Config.FlyEnabled, FlyBg, FlyKnob, "Fly")
    if not Config.FlyEnabled and FlyV3_Stop then pcall(FlyV3_Stop) end
end)
AutoShiftBtn.MouseButton1Click:Connect(function()
    Config.AutoShiftEnabled = not Config.AutoShiftEnabled
    UpdateSwitch(Config.AutoShiftEnabled, AutoShiftBg, AutoShiftKnob, "Auto Shift")
    AutoShift_Apply()
end)

PeekAssistFillBtn.MouseButton1Click:Connect(function()
    Config.PeekAssistFillEnabled = not Config.PeekAssistFillEnabled
    UpdateSwitch(Config.PeekAssistFillEnabled, PeekAssistFillBg, PeekAssistFillKnob, "Peek Assist Fill")
end)

FakeLagBtn.MouseButton1Click:Connect(function()
    Config.FakeLagEnabled = not Config.FakeLagEnabled
    UpdateSwitch(Config.FakeLagEnabled, FakeLagBg, FakeLagKnob, "Fake Lag")
    if Config.FakeLagEnabled then FakeLag_Start() else FakeLag_Stop() end
end)
FakeLagRandBtn.MouseButton1Click:Connect(function()
    Config.FakeLagRandomize = not Config.FakeLagRandomize
    UpdateSwitch(Config.FakeLagRandomize, FakeLagRandBg, FakeLagRandKnob, "FL Randomize")
end)
BHopBtn.MouseButton1Click:Connect(function() Config.BHopEnabled = not Config.BHopEnabled UpdateSwitch(Config.BHopEnabled, BHopBg, BHopKnob, "Bunny Hop") end)
StrafeBtn.MouseButton1Click:Connect(function()
    Config.StrafeEnabled = not Config.StrafeEnabled
    UpdateSwitch(Config.StrafeEnabled, StrafeBg, StrafeKnob, "Strafe")
end)


FFBtn.MouseButton1Click:Connect(function()
    local newState = not Config.ForceFieldEnabled
    ForceField_Toggle(newState)
    UpdateSwitch(newState, FFBg, FFKnob, "Self ForceField")
end)

WeaponFFBtn.MouseButton1Click:Connect(function()
    local newState = not Config.WeaponForceFieldEnabled
    WeaponFF_Toggle(newState)
    UpdateSwitch(newState, WeaponFFBg, WeaponFFKnob, "Weapon Material")
end)
KillLogsBtn.MouseButton1Click:Connect(function()
    Config.KillLogsEnabled = not Config.KillLogsEnabled
    UpdateSwitch(Config.KillLogsEnabled, KillLogsBg, KillLogsKnob, "Kill Logs")
end)
HitLogsBtn.MouseButton1Click:Connect(function()
    Config.HitLogsEnabled = not Config.HitLogsEnabled
    UpdateSwitch(Config.HitLogsEnabled, HitLogsBg, HitLogsKnob, "Hit Logs")
end)
KillFlashBtn.MouseButton1Click:Connect(function()
    Config.KillFlashEnabled = not Config.KillFlashEnabled
    UpdateSwitch(Config.KillFlashEnabled, KillFlashBg, KillFlashKnob, "Kill Flash (Screen)")
end)
KillLightningBtn.MouseButton1Click:Connect(function()
    Config.KillLightningEnabled = not Config.KillLightningEnabled
    UpdateSwitch(Config.KillLightningEnabled, KillLightningBg, KillLightningKnob, "Kill Lightning")
end)
HitboxShowBtn.MouseButton1Click:Connect(function()
    Config.HitboxShow = not Config.HitboxShow
    UpdateSwitch(Config.HitboxShow, HitboxShowBg, HitboxShowKnob, "Show Hitboxes")
    if not Config.HitboxShow and Hitbox_ClearAll then Hitbox_ClearAll() end
end)
pcall(function()
    
    UpdateSwitch(Config.AutowallEnabled == true, AutowallBg, AutowallKnob, nil)
    UpdateSwitch(Config.AutowallShowInfo == true, AutowallInfoBg, AutowallInfoKnob, nil)
end)
AutowallBtn.MouseButton1Click:Connect(function()
    Config.AutowallEnabled = not Config.AutowallEnabled
    UpdateSwitch(Config.AutowallEnabled, AutowallBg, AutowallKnob, "Autowall")
    if Cache.AutowallSetEnabled then Cache.AutowallSetEnabled(Config.AutowallEnabled) end
end)
AutowallInfoBtn.MouseButton1Click:Connect(function()
    Config.AutowallShowInfo = not Config.AutowallShowInfo
    UpdateSwitch(Config.AutowallShowInfo, AutowallInfoBg, AutowallInfoKnob, "Autowall Info")
    if Cache.AutowallApply then Cache.AutowallApply() end
end)

BulletTracerBtn.MouseButton1Click:Connect(function()
    Config.BulletTracersEnabled = not Config.BulletTracersEnabled
    UpdateSwitch(Config.BulletTracersEnabled, BulletTracerBg, BulletTracerKnob, "Bullet Tracers")
end)

AuraBtn.MouseButton1Click:Connect(function()
    Config.AuraEnabled = not Config.AuraEnabled
    UpdateSwitch(Config.AuraEnabled, AuraBg, AuraKnob, "Aura")
    ClassicAura_RefreshAll()
end)

ClassicPinkBtn.MouseButton1Click:Connect(function()
    Config.ClassicPinkEnabled = not Config.ClassicPinkEnabled
    UpdateSwitch(Config.ClassicPinkEnabled, ClassicPinkBg, ClassicPinkKnob, "Pink Aura")
    ClassicAura_RefreshAll()
end)

ClassicAngelBtn.MouseButton1Click:Connect(function()
    Config.ClassicAngelEnabled = not Config.ClassicAngelEnabled
    UpdateSwitch(Config.ClassicAngelEnabled, ClassicAngelBg, ClassicAngelKnob, "Angel Wing")
    ClassicAura_RefreshAll()
end)

ParticleStarBtn.MouseButton1Click:Connect(function()
    Config.ParticleStarlightEnabled = not Config.ParticleStarlightEnabled
    UpdateSwitch(Config.ParticleStarlightEnabled, ParticleStarBg, ParticleStarKnob, "Starlight")
    ParticleAura_RefreshAll()
end)

ParticleAngelBtn.MouseButton1Click:Connect(function()
    Config.ParticleAngelEnabled = not Config.ParticleAngelEnabled
    UpdateSwitch(Config.ParticleAngelEnabled, ParticleAngelBg, ParticleAngelKnob, "Angel")
    ParticleAura_RefreshAll()
end)

FireSoundBtn.MouseButton1Click:Connect(function()
    Config.CustomFireSoundEnabled = not Config.CustomFireSoundEnabled
    UpdateSwitch(Config.CustomFireSoundEnabled, FireSoundBg, FireSoundKnob, "Kill Sounds")
    if Config.CustomFireSoundEnabled then
        task.spawn(function()
            for name, _ in pairs(FIRE_SOUND_FILES or {}) do
                pcall(HitSound_EnsureAsset, name)
            end
            if Cache.FireSoundsReady then
                Notify("Kill Sounds", "Ready")
            else
                Notify("Kill Sounds", "Loading sounds...")
            end
        end)
    end
end)

FIRE_SOUND_FILES = {
    ["Gun Fire"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/wp_gun_fire-02.ogg",
        file = "Anxium_wp_gun_fire-02.ogg"
    },
    ["Hammer Hit"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/wp_hammer_hit-01.ogg",
        file = "Anxium_wp_hammer_hit-01.ogg"
    },
    ["Bow Ding"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/bow%20ding.wav",
        file = "Anxium_bow_ding.wav"
    },
    ["Cod Hit"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/cod_hit.ogg",
        file = "Anxium_cod_hit.ogg"
    },
    ["Uwu"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/uwu.mp3",
        file = "Anxium_uwu.mp3"
    },
    ["Button"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/button.wav",
        file = "Anxium_button.wav"
    },
    ["Click"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/click.wav",
        file = "Anxium_click.wav"
    },
    ["Neverlose"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/neverlose.mp3",
        file = "Anxium_neverlose.mp3"
    },
    ["Fatality"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/fatality.ogg",
        file = "Anxium_fatality.ogg"
    },
    ["Headshot"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/headshot-soundfx.ogg",
        file = "Anxium_headshot-soundfx.ogg"
    },
    ["Standart"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/standart.wav",
        file = "Anxium_standart.wav"
    },
    ["Click1"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/click1.wav",
        file = "Anxium_click1.wav"
    },
    ["Agpa1"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/agpa1.wav",
        file = "Anxium_agpa1.wav"
    },
    ["Agpa2"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/agpa2.wav",
        file = "Anxium_agpa2.wav"
    },
    ["Camera1"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/camera1.wav",
        file = "Anxium_camera1.wav"
    },
    ["Bonk5"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/bonk5.wav",
        file = "Anxium_bonk5.wav"
    },
    ["Bubble3"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/bubble3.wav",
        file = "Anxium_bubble3.wav"
    },
    ["Hentai1"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/hentai1.wav",
        file = "Anxium_hentai1.wav"
    },
    ["Hentai2"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/hentai2.wav",
        file = "Anxium_hentai2.wav"
    },
    ["Hentai3"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/hentai3.wav",
        file = "Anxium_hentai3.wav"
    },
    ["Hentai4"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/hentai4.wav",
        file = "Anxium_hentai4.wav"
    },
    ["Odin Svinia"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/odin-svinia.mp3",
        file = "Anxium_odin-svinia.mp3"
    },
    ["Skeet"] = {
        url = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/skeet.ogg",
        file = "Anxium_skeet.ogg"
    },
}


function EnsureGitSoundAsset(key, url, fileName)
    Cache.FireSoundAssets = Cache.FireSoundAssets or {}
    if Cache.FireSoundAssets[key] then
        return Cache.FireSoundAssets[key]
    end
    if not url or not fileName then return nil end
    local asset = nil
    pcall(function()
        if typeof(getcustomasset) ~= "function" then return end
        local onDisk = false
        if typeof(isfile) == "function" then
            pcall(function() onDisk = isfile(fileName) == true end)
        end
        if not onDisk and typeof(writefile) == "function" then
            local ok, body = pcall(function() return game:HttpGet(url) end)
            if ok and type(body) == "string" and #body > 100 then
                pcall(writefile, fileName, body)
                onDisk = true
            end
        end
        if onDisk or typeof(isfile) ~= "function" then
            local okA, a = pcall(function() return getcustomasset(fileName) end)
            if okA and a and a ~= "" then asset = a end
        end
    end)
    if asset then
        Cache.FireSoundAssets[key] = asset
    end
    return asset
end

function HitSound_EnsureAsset(key)
    key = key or (Config and Config.CustomFireSoundName) or "Gun Fire"
    if Cache.FireSoundAssets and Cache.FireSoundAssets[key] then
        return Cache.FireSoundAssets[key]
    end
    local data = FIRE_SOUND_FILES and FIRE_SOUND_FILES[key]
    if not data then return nil end
    local asset = EnsureGitSoundAsset(key, data.url, data.file)
    if asset then Cache.FireSoundsReady = true end
    return asset
end

SCOPE_SOUND_URL = "https://raw.githubusercontent.com/AnxiumClient/sounnds/main/awp-csgo-awp-scope-csgo-soundxpro.com.mp3"
SCOPE_SOUND_FILE = "Anxium_awp_scope.mp3"

function PlayScopeSound()
    if Config and Config.ScopeSoundEnabled == false then return end
    local assetId = EnsureGitSoundAsset("ScopeADS", SCOPE_SOUND_URL, SCOPE_SOUND_FILE)
    if not assetId then return end
    if Cache.ScopeSoundInstance then
        pcall(function()
            Cache.ScopeSoundInstance:Stop()
            Cache.ScopeSoundInstance:Destroy()
        end)
        Cache.ScopeSoundInstance = nil
    end
    local sound = Instance.new("Sound")
    sound.Name = "AnxiumScopeSound"
    sound.SoundId = assetId
    sound.Volume = 1
    sound.PlaybackSpeed = 1
    sound.Looped = false
    local parent = LocalPlayer:FindFirstChild("PlayerGui")
        or LocalPlayer:FindFirstChild("PlayerScripts")
        or game:GetService("SoundService")
        or Workspace
    sound.Parent = parent
    Cache.ScopeSoundInstance = sound
    pcall(function() sound:Play() end)
    sound.Ended:Connect(function()
        if Cache.ScopeSoundInstance == sound then Cache.ScopeSoundInstance = nil end
        pcall(function() sound:Destroy() end)
    end)
    task.delay(5, function()
        if sound and sound.Parent then pcall(function() sound:Destroy() end) end
        if Cache.ScopeSoundInstance == sound then Cache.ScopeSoundInstance = nil end
    end)
end


function PlayHitSounds()
    if not Config or not Config.CustomFireSoundEnabled then return end
    local key = Config.CustomFireSoundName or "Gun Fire"
    local assetId = (Cache.FireSoundAssets and Cache.FireSoundAssets[key]) or HitSound_EnsureAsset(key)
    if not assetId then
        
        for name, _ in pairs(FIRE_SOUND_FILES or {}) do
            HitSound_EnsureAsset(name)
        end
        assetId = Cache.FireSoundAssets and Cache.FireSoundAssets[key]
    end
    if not assetId then return end
    Cache.FireSoundsReady = true

    if Cache.FireSoundInstance then
        pcall(function()
            Cache.FireSoundInstance:Stop()
            Cache.FireSoundInstance:Destroy()
        end)
        Cache.FireSoundInstance = nil
    end

    local sound = Instance.new("Sound")
    sound.Name = "AnxiumHitSound"
    sound.SoundId = assetId
    sound.Volume = Config.CustomFireSoundVolume or 1
    sound.PlaybackSpeed = 1
    sound.Looped = false
    local parent = LocalPlayer:FindFirstChild("PlayerGui")
        or LocalPlayer:FindFirstChild("PlayerScripts")
        or game:GetService("SoundService")
        or Workspace
    sound.Parent = parent
    Cache.FireSoundInstance = sound
    pcall(function() sound:Play() end)

    sound.Ended:Connect(function()
        if Cache.FireSoundInstance == sound then Cache.FireSoundInstance = nil end
        pcall(function() sound:Destroy() end)
    end)
    task.delay(6, function()
        if sound and sound.Parent then pcall(function() sound:Destroy() end) end
    end)
end

Cache.BulletTracers = Cache.BulletTracers or {}

function SpawnBulletTracer(fromPos, toPos)
    if not Config.BulletTracersEnabled then return end
    if not fromPos or not toPos then return end
    local col = Config.Color_BulletTracer or Theme.Accent
    local duration = 2
    local dist = (toPos - fromPos).Magnitude
    if dist < 0.5 then return end

    
    local a0 = Instance.new("Part")
    a0.Name = "AnxiumTracerA"
    a0.Size = Vector3.new(0.05, 0.05, 0.05)
    a0.Transparency = 1
    a0.Anchored = true
    a0.CanCollide = false
    a0.CanQuery = false
    a0.CanTouch = false
    a0.CastShadow = false
    a0.CFrame = CFrame.new(fromPos)
    a0.Parent = Workspace

    local a1 = Instance.new("Part")
    a1.Name = "AnxiumTracerB"
    a1.Size = Vector3.new(0.05, 0.05, 0.05)
    a1.Transparency = 1
    a1.Anchored = true
    a1.CanCollide = false
    a1.CanQuery = false
    a1.CanTouch = false
    a1.CastShadow = false
    a1.CFrame = CFrame.new(toPos)
    a1.Parent = Workspace

    local att0 = Instance.new("Attachment")
    att0.Parent = a0
    local att1 = Instance.new("Attachment")
    att1.Parent = a1

    local beam = Instance.new("Beam")
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new(col)
    beam.FaceCamera = true
    beam.LightInfluence = 0
    beam.TextureSpeed = 0
            
        beam.Width0 = 0.42
        beam.Width1 = 0.16
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Texture = ""
        beam.TextureSpeed = 0
        local bt = math.clamp(tonumber(Config.BulletTracerTransparency) or 0.15, 0, 0.95)
        beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, bt),
            NumberSequenceKeypoint.new(0.7, bt),
            NumberSequenceKeypoint.new(1, math.clamp(bt + 0.12, 0, 1)),
        })
        beam.Segments = 20
        
        local neonCol = Color3.new(
            math.clamp(col.R * 1.15 + 0.15, 0, 1),
            math.clamp(col.G * 1.15 + 0.15, 0, 1),
            math.clamp(col.B * 1.15 + 0.15, 0, 1)
        )
        beam.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, neonCol),
            ColorSequenceKeypoint.new(0.5, col),
            ColorSequenceKeypoint.new(1, neonCol),
        })
        beam.Parent = a0

    table.insert(Cache.BulletTracers, {
        A0 = a0, A1 = a1, Beam = beam,
        From = fromPos, To = toPos,
        Start = tick(), Duration = duration, Color = col,
    })
    while #Cache.BulletTracers > 35 do
        local old = table.remove(Cache.BulletTracers, 1)
        if old then
            pcall(function() if old.Beam then old.Beam:Destroy() end end)
            pcall(function() if old.A0 then old.A0:Destroy() end end)
            pcall(function() if old.A1 then old.A1:Destroy() end end)
        end
    end
end

function GetTracerOrigin()
    local cam = Workspace.CurrentCamera or Camera
    local myChar = LocalPlayer.Character
    if myChar then
        local tool = myChar:FindFirstChildOfClass("Tool")
        if tool then
            local handle = tool:FindFirstChild("Handle") or tool:FindFirstChild("Barrel") or tool:FindFirstChildWhichIsA("BasePart")
            if handle and handle:IsA("BasePart") then
                return handle.Position + handle.CFrame.LookVector * 0.5
            end
        end
        if cam then
            for _, d in ipairs(cam:GetChildren()) do
                if d:IsA("Model") or d:IsA("Folder") then
                    local h = d:FindFirstChild("Handle", true) or d:FindFirstChildWhichIsA("BasePart", true)
                    if h and h:IsA("BasePart") then
                        return h.Position
                    end
                end
            end
        end
        local head = myChar:FindFirstChild("Head")
        if head then
            return head.Position + (cam and cam.CFrame.LookVector or head.CFrame.LookVector) * 1
        end
    end
    if cam then
        return cam.CFrame.Position + cam.CFrame.LookVector * 2
    end
    return nil
end

function FireBulletTracer()
    if not Config.BulletTracersEnabled then return end
    local cam = Workspace.CurrentCamera or Camera
    if not cam then return end
    local now = tick()
    local cd = math.clamp((tonumber(Config.BulletTracerCooldown) or 120) / 1000, 0, 5)
    if now - (Cache.LastTracerTime or 0) < cd then return end
    Cache.LastTracerTime = now

    local origin = GetTracerOrigin() or (cam.CFrame.Position + cam.CFrame.LookVector * 1.5)
    
    local dir = cam.CFrame.LookVector * 1000
    local myChar = LocalPlayer.Character
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {}
    if myChar then table.insert(filter, myChar) end
    params.FilterDescendantsInstances = filter
    params.IgnoreWater = true
    local result = Workspace:Raycast(origin, dir, params)
    local hitPos = result and result.Position or (origin + cam.CFrame.LookVector * 400)
    SpawnBulletTracer(origin, hitPos)
end

function UpdateBulletTracers()
    if not Config.BulletTracersEnabled then
        if Cache.BulletTracers and #Cache.BulletTracers > 0 then
            for i = #Cache.BulletTracers, 1, -1 do
                local e = Cache.BulletTracers[i]
                if e then
                    pcall(function() if e.Beam then e.Beam:Destroy() end end)
                    pcall(function() if e.A0 then e.A0:Destroy() end end)
                    pcall(function() if e.A1 then e.A1:Destroy() end end)
                end
                table.remove(Cache.BulletTracers, i)
            end
        end
        return
    end
    if not Cache.BulletTracers or #Cache.BulletTracers == 0 then return end
    if not Cache.BulletTracers or #Cache.BulletTracers == 0 then return end
    local now = tick()
    local i = 1
    while i <= #Cache.BulletTracers do
        local e = Cache.BulletTracers[i]
        local age = now - (e.Start or now)
        local dur = e.Duration or math.clamp(tonumber(Config.BulletTracerDuration) or 2, 0.2, 8)
        if age >= dur then
            pcall(function() if e.Beam then e.Beam:Destroy() end end)
            pcall(function() if e.A0 then e.A0:Destroy() end end)
            pcall(function() if e.A1 then e.A1:Destroy() end end)
            table.remove(Cache.BulletTracers, i)
        else
            
            local t = math.clamp(age / dur, 0, 1)
            local fade = t * t * (3 - 2 * t) 
            if e.Beam and e.Beam.Parent then
                local t0 = 0.05 + fade * 0.95
                local t1 = 0.25 + fade * 0.75
                e.Beam.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, t0),
                    NumberSequenceKeypoint.new(1, t1),
                })
                e.Beam.Width0 = 0.18 * (1 - fade * 0.85)
                e.Beam.Width1 = 0.06 * (1 - fade * 0.85)
            end
            i = i + 1
        end
    end
end
Cache.UpdateBulletTracers = UpdateBulletTracers

if not Cache._fxHeartbeat then
    Cache._fxHeartbeat = true
    RunService.Heartbeat:Connect(function()
        pcall(function()
            if Cache and Cache.UpdateBulletTracers then Cache.UpdateBulletTracers() end
            if Cache and Cache.UpdateKillFX then Cache.UpdateKillFX() end
        end)
    end)
end


Cache.TracerMouseDown = false
UserInputService.InputBegan:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Cache.TracerMouseDown = true
        if Config.BulletTracersEnabled then
            FireBulletTracer()
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Cache.TracerMouseDown = false
    end
end)
RunService.Heartbeat:Connect(function()
    if Config.BulletTracersEnabled and Cache.TracerMouseDown then
        FireBulletTracer()
    end
end)


Cache.KillHooked = Cache.KillHooked or {}
Cache.KillHumConnections = Cache.KillHumConnections or {}
Cache.LastKillSoundTime = 0
Cache.KillSoundPlayedFor = {} 
Cache.KillHandledHum = {} 
Cache.RecentDamageTargets = {} 

function MarkRecentTarget(player)
    if player and player ~= LocalPlayer then
        Cache.RecentDamageTargets[player] = tick()
        Cache.LastShotTarget = player
        Cache.LastShotTime = tick()
    end
end

function SpawnImmediateHitMarkerFromTarget(target)
    if not target or target == LocalPlayer then return false end
    local cfg = GetCfg() or Config
    if not cfg or not cfg.HitMarkerEnabled or not SpawnHitMarker then return false end

    local char = target.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return false end

    local cam = Workspace.CurrentCamera or Camera
    if not cam then return false end

    local origin = cam.CFrame.Position
    local mouse = UserInputService:GetMouseLocation()
    local ray = cam:ViewportPointToRay(mouse.X, mouse.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LocalPlayer.Character }
    params.IgnoreWater = true

    local hit = Workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
    if hit and hit.Instance and hit.Instance:IsDescendantOf(char) then
        pcall(SpawnHitMarker, hit.Position)
        return true
    end

    -- Fallback for aim systems whose final hit part is not exactly under the mouse ray.
    local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    if part then
        local to = part.Position - origin
        if to.Magnitude > 0.1 then
            local check = Workspace:Raycast(origin, to.Unit * (to.Magnitude + 12), params)
            if check and check.Instance and check.Instance:IsDescendantOf(char) then
                pcall(SpawnHitMarker, check.Position)
                return true
            end
        end
    end
    return false
end

function NormalizeHitPartName(inst)
    if not inst then return "Body" end
    local n = tostring(inst.Name or "")
    local map = {
        Head = "Head",
        UpperTorso = "Torso",
        LowerTorso = "Torso",
        Torso = "Torso",
        HumanoidRootPart = "Torso",
        LeftUpperArm = "Left Arm",
        LeftLowerArm = "Left Arm",
        LeftHand = "Left Hand",
        RightUpperArm = "Right Arm",
        RightLowerArm = "Right Arm",
        RightHand = "Right Hand",
        LeftUpperLeg = "Left Leg",
        LeftLowerLeg = "Left Leg",
        LeftFoot = "Left Foot",
        RightUpperLeg = "Right Leg",
        RightLowerLeg = "Right Leg",
        RightFoot = "Right Foot",
        ["Left Arm"] = "Left Arm",
        ["Right Arm"] = "Right Arm",
        ["Left Leg"] = "Left Leg",
        ["Right Leg"] = "Right Leg",
    }
    if map[n] then return map[n] end
    local low = string.lower(n)
    if low:find("head", 1, true) then return "Head" end
    if low:find("torso", 1, true) or low:find("root", 1, true) then return "Torso" end
    if low:find("left", 1, true) and (low:find("arm", 1, true) or low:find("hand", 1, true)) then return "Left Arm" end
    if low:find("right", 1, true) and (low:find("arm", 1, true) or low:find("hand", 1, true)) then return "Right Arm" end
    if low:find("left", 1, true) and (low:find("leg", 1, true) or low:find("foot", 1, true)) then return "Left Leg" end
    if low:find("right", 1, true) and (low:find("leg", 1, true) or low:find("foot", 1, true)) then return "Right Leg" end
    if low:find("arm", 1, true) or low:find("hand", 1, true) then return "Arm" end
    if low:find("leg", 1, true) or low:find("foot", 1, true) then return "Leg" end
    return n ~= "" and n or "Body"
end

function CaptureCrosshairHitPart(player)
    if not player or not player.Character or not Camera then return nil end
    local myChar = LocalPlayer.Character
    local partName = nil
    pcall(function()
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { myChar }
        params.IgnoreWater = true
        local result = Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 1200, params)
        if result and result.Instance and result.Instance:IsDescendantOf(player.Character) then
            partName = NormalizeHitPartName(result.Instance)
            return
        end
        local mouse = UserInputService:GetMouseLocation()
        local ray = Camera:ViewportPointToRay(mouse.X, mouse.Y)
        result = Workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
        if result and result.Instance and result.Instance:IsDescendantOf(player.Character) then
            partName = NormalizeHitPartName(result.Instance)
        end
    end)
    return partName
end

function CaptureCrosshairTarget()
    local t = Cache.AimLockTarget
    local hitPart = nil
    if not t and typeof(Triggerbot_GetTargetUnderCrosshair) == "function" then
        pcall(function() t = Triggerbot_GetTargetUnderCrosshair() end)
    end
    if Camera then
        local myChar = LocalPlayer.Character
        if myChar then
            pcall(function()
                RaycastParamsTriggerbot.FilterDescendantsInstances = { myChar }
                local result = Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 1200, RaycastParamsTriggerbot)
                if result and result.Instance then
                    for _, player in ipairs(CachedPlayerList) do
                        if player ~= LocalPlayer and player.Character and result.Instance:IsDescendantOf(player.Character) then
                            if not t then t = player end
                            if player == t or not hitPart then
                                hitPart = NormalizeHitPartName(result.Instance)
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
    if t then
        MarkRecentTarget(t)
        if not hitPart then
            hitPart = CaptureCrosshairHitPart(t)
        end
        if hitPart then
            Cache.LastHitPartName = hitPart
            Cache.LastHitPartPlayer = t
            Cache.LastHitPartTime = tick()
        end
    end
    return t
end

function IsLocalPlayerKiller(humanoid)
    if not humanoid then return false, false end
    local tagNames = { "creator", "Creator", "killer", "Killer", "LastHit", "Attacker", "attacker", "DamageTag", "creatorTag" }
    local hadEnemyTag = false
    local hadAnyTag = false
    for _, name in ipairs(tagNames) do
        local tag = humanoid:FindFirstChild(name)
        if not tag then
            
            for _, ch in ipairs(humanoid:GetChildren()) do
                if string.lower(ch.Name) == string.lower(name) then
                    tag = ch
                    break
                end
            end
        end
        if tag then
            hadAnyTag = true
            local val = nil
            if tag:IsA("ObjectValue") then
                val = tag.Value
            elseif tag:IsA("StringValue") then
                val = tag.Value
            elseif tag:IsA("IntValue") or tag:IsA("NumberValue") then
                val = tag.Value
            end
            
            if val == LocalPlayer or val == LocalPlayer.Name or val == LocalPlayer.UserId then
                return true, false
            end
            if typeof(val) == "Instance" then
                if val:IsA("Player") then
                    if val == LocalPlayer then return true, false end
                    hadEnemyTag = true
                elseif val:IsA("Model") then
                    
                    if val == LocalPlayer.Character then return true, false end
                    local plr = Players:GetPlayerFromCharacter(val)
                    if plr == LocalPlayer then return true, false end
                    if plr and plr ~= LocalPlayer then hadEnemyTag = true end
                end
            end
        end
    end
    return false, hadEnemyTag
end

function TryPlayKillSound(victimPlayer)
    if not Config.CustomFireSoundEnabled then return end
    if not victimPlayer or victimPlayer == LocalPlayer then return end
    local now = tick()
    if now - (Cache.LastKillSoundTime or 0) < 0.25 then return end
    local lastFor = Cache.KillSoundPlayedFor[victimPlayer]
    if lastFor and (now - lastFor) < 2.0 then return end
    Cache.LastKillSoundTime = now
    Cache.KillSoundPlayedFor[victimPlayer] = now
    pcall(PlayHitSounds)
end


Cache.SelfChamsHL = nil
Cache.SelfChamsOriginals = nil
Cache.LastKnownHP = Cache.LastKnownHP or {}
Cache.ExtraVisFolder = nil

function GetCfg()
    local c = rawget(_G, "Config")
    if type(c) == "table" then return c end
    if type(Config) == "table" then return Config end
    return nil
end

function GetCache()
    local c = rawget(_G, "Cache")
    if type(c) == "table" then return c end
    if type(Cache) == "table" then return Cache end
    return nil
end

function EnsureVisFolder()
    local cache = GetCache()
    if not cache then return Workspace end
    if cache.ExtraVisFolder and cache.ExtraVisFolder.Parent then
        return cache.ExtraVisFolder
    end
    local f = Instance.new("Folder")
    f.Name = "AnxiumExtraVisuals"
    f.Parent = Workspace
    cache.ExtraVisFolder = f
    return f
end

function SelfChams_Clear()
    local cache = GetCache()
    if not cache then return end
    if cache.SelfChamsOriginals then
        for part, data in pairs(cache.SelfChamsOriginals) do
            pcall(function()
                if part and part.Parent then
                    part.Material = data.mat
                    part.Color = data.color
                    part.Transparency = data.trans
                end
            end)
        end
        cache.SelfChamsOriginals = nil
    end
    if cache.SelfChamsHL then
        pcall(function() cache.SelfChamsHL:Destroy() end)
        cache.SelfChamsHL = nil
    end
end

function SelfChams_Update()
    
    local cfg = GetCfg()
    local cache = GetCache()
    if not cfg or not cache then return end
    if not cfg.SelfChamsEnabled then
        SelfChams_Clear()
        return
    end
    local char = LocalPlayer.Character
    if not char then SelfChams_Clear() return end
    local col = cfg.Color_SelfChams or Color3.fromRGB(180, 140, 255)

    
    if cache.SelfChamsOriginals then
        for part, data in pairs(cache.SelfChamsOriginals) do
            pcall(function()
                if part and part.Parent then
                    part.Material = data.mat
                    part.Color = data.color
                    part.Transparency = data.trans
                end
            end)
        end
        cache.SelfChamsOriginals = nil
    end

    if not cache.SelfChamsHL or cache.SelfChamsHL.Parent == nil then
        pcall(function() if cache.SelfChamsHL then cache.SelfChamsHL:Destroy() end end)
        local hl = Instance.new("Highlight")
        hl.Name = "AnxiumSelfChams"
        hl.Adornee = char
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0.15
        hl.FillColor = col
        hl.OutlineColor = col
        hl.Parent = char
        cache.SelfChamsHL = hl
    else
        cache.SelfChamsHL.Adornee = char
        cache.SelfChamsHL.FillColor = col
        cache.SelfChamsHL.OutlineColor = col
    end
end

Cache._HitMarkers = Cache._HitMarkers or {}
Cache._HitMarkerMax = 12
Cache._HitMarkerRenderBound = Cache._HitMarkerRenderBound or false

function SpawnHitMarker(adorneeOrPos)
    local cfg = GetCfg() or Config
    if not cfg or not cfg.HitMarkerEnabled then return end
    if not Drawing then return end

    local worldPos
    if typeof(adorneeOrPos) == "Vector3" then
        worldPos = adorneeOrPos
    elseif typeof(adorneeOrPos) == "Instance" then
        if adorneeOrPos:IsA("BasePart") then
            worldPos = adorneeOrPos.Position
        else
            local h = adorneeOrPos:FindFirstChild("Head") or adorneeOrPos:FindFirstChild("HumanoidRootPart")
            worldPos = h and h.Position
        end
    end
    if not worldPos then return end

    local list = Cache._HitMarkers
    for i = #list, 1, -1 do
        local d = list[i]
        if not d or (d.expireTick and tick() > d.expireTick + 0.2) then
            if d then
                if d.outlines then for _, ln in ipairs(d.outlines) do pcall(function() ln:Remove() end) end end
                if d.lines then for _, ln in ipairs(d.lines) do pcall(function() ln:Remove() end) end end
            end
            table.remove(list, i)
        end
    end
    while #list >= (Cache._HitMarkerMax or 12) do
        local old = table.remove(list, 1)
        if old then
            if old.outlines then for _, ln in ipairs(old.outlines) do pcall(function() ln:Remove() end) end end
            if old.lines then for _, ln in ipairs(old.lines) do pcall(function() ln:Remove() end) end end
        end
    end

    local thick = math.clamp(tonumber(cfg.HitMarkerThickness) or 2, 1, 8)
    local dur = math.clamp(tonumber(cfg.HitMarkerDuration) or 1.2, 0.15, 5)
    local col = cfg.Color_HitMarker or Color3.fromRGB(255, 255, 255)
    local outlines, lines = {}, {}
    for i = 1, 4 do
        local ol = Drawing.new("Line")
        ol.Thickness = thick + 2.2
        ol.Color = Color3.fromRGB(0, 0, 0)
        ol.Transparency = 0
        ol.Visible = true
        outlines[i] = ol
        local ln = Drawing.new("Line")
        ln.Thickness = thick
        ln.Color = col
        ln.Transparency = 0
        ln.Visible = true
        lines[i] = ln
    end
    local now = tick()
    list[#list + 1] = {
        outlines = outlines,
        lines = lines,
        worldPos = worldPos,
        spawnTick = now,
        expireTick = now + dur,
    }

    
    local cam = Workspace.CurrentCamera or Camera
    if cam then
        local screenPos, onScreen = cam:WorldToViewportPoint(worldPos)
        if onScreen and screenPos.Z > 0 then
            local center = Vector2.new(screenPos.X, screenPos.Y)
            local baseSize = math.clamp(tonumber(cfg.HitMarkerSize) or 22, 5, 60)
            local baseGap = math.clamp(tonumber(cfg.HitMarkerGap) or 6, 2, 24)
            local fixedRot = math.rad(tonumber(cfg.HitMarkerRotation) or 0)
            local baseAngles = {0, 90, 180, 270}
            for j = 1, 4 do
                local totalAngle = fixedRot + math.rad(baseAngles[j])
                local cosA, sinA = math.cos(totalAngle), math.sin(totalAngle)
                local from = center + Vector2.new(cosA * baseGap, sinA * baseGap)
                local to = center + Vector2.new(cosA * (baseGap + baseSize), sinA * (baseGap + baseSize))
                local ol, ln = outlines[j], lines[j]
                ol.From, ol.To = from, to
                ol.Visible = true
                ln.From, ln.To = from, to
                ln.Visible = true
            end
        end
    end

    if not Cache._HitMarkerRenderBound then
        Cache._HitMarkerRenderBound = true
        RunService.RenderStepped:Connect(function()
            pcall(function()
                local cfg2 = GetCfg() or Config
                local currentTick = tick()
                local enabled = cfg2 and cfg2.HitMarkerEnabled
                local col2 = (cfg2 and cfg2.Color_HitMarker) or Color3.fromRGB(255, 255, 255)
                local baseSize = math.clamp(tonumber(cfg2 and cfg2.HitMarkerSize) or 22, 5, 60)
                local spinSpeed = 0
                local fixedRot = math.rad(tonumber(cfg2 and cfg2.HitMarkerRotation) or 0)
                local baseGap = math.clamp(tonumber(cfg2 and cfg2.HitMarkerGap) or 6, 2, 24)
                local thick2 = math.clamp(tonumber(cfg2 and cfg2.HitMarkerThickness) or 2, 1, 8)
                local cam = Workspace.CurrentCamera or Camera
                if not cam then return end
                local markers = Cache._HitMarkers or {}
                for i = #markers, 1, -1 do
                    local data = markers[i]
                    if not data or not enabled or currentTick > data.expireTick then
                        if data then
                            if data.outlines then for _, line in ipairs(data.outlines) do pcall(function() line:Remove() end) end end
                            if data.lines then for _, line in ipairs(data.lines) do pcall(function() line:Remove() end) end end
                        end
                        table.remove(markers, i)
                    else
                        local screenPos, onScreen = cam:WorldToViewportPoint(data.worldPos)
                        if onScreen and screenPos.Z > 0 then
                            local center = Vector2.new(screenPos.X, screenPos.Y)
                            local currentAngle = fixedRot
                            local baseAngles = {0, 90, 180, 270}
                            local lifeRatio = math.clamp((data.expireTick - currentTick) / math.max(data.expireTick - data.spawnTick, 0.01), 0, 1)
                            local alpha = (lifeRatio > 0.4) and 1 or (lifeRatio / 0.4)
                            local gap, sz = baseGap, baseSize
                            for j = 1, 4 do
                                local totalAngle = currentAngle + math.rad(baseAngles[j])
                                local cosA, sinA = math.cos(totalAngle), math.sin(totalAngle)
                                local from = center + Vector2.new(cosA * gap, sinA * gap)
                                local to = center + Vector2.new(cosA * (gap + sz), sinA * (gap + sz))
                                local ol = data.outlines and data.outlines[j]
                                local ln = data.lines and data.lines[j]
                                if ol then
                                    ol.Color = Color3.fromRGB(0, 0, 0)
                                    ol.Thickness = thick2 + 2.2
                                    ol.Transparency = 1 - alpha
                                    ol.From, ol.To = from, to
                                    ol.Visible = true
                                end
                                if ln then
                                    ln.Color = col2
                                    ln.Thickness = thick2
                                    ln.Transparency = 1 - alpha
                                    ln.From, ln.To = from, to
                                    ln.Visible = true
                                end
                            end
                        else
                            if data.outlines then for _, line in ipairs(data.outlines) do line.Visible = false end end
                            if data.lines then for _, line in ipairs(data.lines) do line.Visible = false end end
                        end
                    end
                end
            end)
        end)
    end
end

function ApplyWorldVisuals()
    local wantShadow = Config.NoShadowsEnabled == true
    if Cache._LastNoShadow ~= wantShadow then
        Lighting.GlobalShadows = not wantShadow
        Cache._LastNoShadow = wantShadow
        Cache.NoShadowsWasOn = wantShadow
    end

    local wcOn = Config.WorldColorEnabled and not Config.FullbrightEnabled
    if wcOn then
        local col = Config.Color_World or Theme.Accent or Color3.fromRGB(180, 140, 255)
        local k = math.clamp((tonumber(Config.WorldColorIntensity) or 55) / 100, 0, 1)
        local sig = string.format("%.3f_%.3f_%.3f_%.2f", col.R, col.G, col.B, k)
        if Cache._WorldColorSig == sig and Cache.WorldColorWasOn then
            return
        end
        Cache._WorldColorSig = sig
        local base = 0.35 + (1 - k) * 0.45
        local mul = 0.55 + k * 0.55
        Lighting.Ambient = Color3.new(
            math.clamp(col.R * mul + base * 0.25, 0, 1),
            math.clamp(col.G * mul + base * 0.25, 0, 1),
            math.clamp(col.B * mul + base * 0.25, 0, 1)
        )
        Lighting.OutdoorAmbient = Color3.new(
            math.clamp(col.R * 0.7 + 0.15, 0, 1),
            math.clamp(col.G * 0.7 + 0.15, 0, 1),
            math.clamp(col.B * 0.7 + 0.2, 0, 1)
        )
        Lighting.ColorShift_Top = col
        Lighting.ColorShift_Bottom = Color3.new(col.R * 0.55, col.G * 0.55, col.B * 0.65)
        Cache.WorldColorWasOn = true
    elseif Cache.WorldColorWasOn and not Config.FullbrightEnabled and not Config.DarkModeEnabled then
        Lighting.Ambient = LightingDefaults.Ambient
        Lighting.OutdoorAmbient = LightingDefaults.OutdoorAmbient
        Lighting.ColorShift_Top = LightingDefaults.ColorShift_Top
        Lighting.ColorShift_Bottom = LightingDefaults.ColorShift_Bottom
        Cache.WorldColorWasOn = false
        Cache._WorldColorSig = nil
    end
end

function SpawnDamageNumber(worldPos, amount)
    local cfg = GetCfg()
    if not cfg or not cfg.DamageNumbersEnabled or not worldPos then return end
    local col = cfg.Color_DamageNumber or Color3.fromRGB(255, 80, 80)
    local holder = Instance.new("Part")
    holder.Anchored = true
    holder.CanCollide = false
    holder.Transparency = 1
    holder.Size = Vector3.new(0.1, 0.1, 0.1)
    holder.CFrame = CFrame.new(worldPos + Vector3.new(0, 1.2, 0))
    holder.Parent = EnsureVisFolder()
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 80, 0, 40)
    bill.AlwaysOnTop = true
    bill.Adornee = holder
    bill.Parent = holder
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Font = SelectedFont or Enum.Font.GothamBold
    lbl.TextSize = 18
    lbl.TextColor3 = col
    lbl.TextStrokeTransparency = 0.4
    lbl.Text = tostring(math.floor(amount + 0.5))
    lbl.Parent = bill
    local startT, base = tick(), holder.Position
    task.spawn(function()
        while tick() - startT < 0.75 do
            local t = (tick() - startT) / 0.75
            holder.CFrame = CFrame.new(base + Vector3.new(0, t * 2, 0))
            lbl.TextTransparency = t * 0.9
            task.wait()
        end
        pcall(function() holder:Destroy() end)
    end)
end

function ResolvePlayerHealth(char, hum)
    if not char then return 0, 100, true end
    if char:GetAttribute("Dead") == true then
        return 0, tonumber(char:GetAttribute("MaxHealth")) or 100, true
    end
    local aHp = char:GetAttribute("Health")
    local aMax = char:GetAttribute("MaxHealth")
    if aHp ~= nil then
        local hp = tonumber(aHp) or 0
        local maxHp = tonumber(aMax) or 100
        if maxHp <= 0 then maxHp = 100 end
        return hp, maxHp, hp <= 0
    end
    if hum then
        local hp = tonumber(hum.Health) or 0
        local maxHp = tonumber(hum.MaxHealth) or 100
        if maxHp <= 0 then maxHp = 100 end
        return hp, maxHp, hp <= 0 or hum.Health <= 0
    end
    return 0, 100, true
end

function OnPlayerTookDamage(player, char, prevHp, newHp, maxHp)
    if not player or player == LocalPlayer then return end
    local cfg = GetCfg() or Config
    local cache = GetCache() or Cache
    if not cfg or not cache then return end
    local dmg = (prevHp or 0) - (newHp or 0)
    if dmg < 0.4 then return end
    local now = tick()
    
    cache.RecentDamageTargets = cache.RecentDamageTargets or {}
    cache.RecentDamageTargets[player] = now
    cache.LastShotTarget = player
    cache.LastShotTime = now

    local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
    local worldPos = head and head.Position or nil
    
    pcall(function()
        local cam = Workspace.CurrentCamera or Camera
        if not cam or not char then return end
        local origin = cam.CFrame.Position
        local mouse = UserInputService:GetMouseLocation()
        local ray = cam:ViewportPointToRay(mouse.X, mouse.Y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { LocalPlayer.Character }
        params.IgnoreWater = true
        local hit = Workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
        if hit and hit.Instance and hit.Instance:IsDescendantOf(char) then
            worldPos = hit.Position
            return
        end
        
        if head then
            local dir = (head.Position - origin)
            hit = Workspace:Raycast(origin, dir.Unit * (dir.Magnitude + 12), params)
            if hit and hit.Instance and hit.Instance:IsDescendantOf(char) then
                worldPos = hit.Position
                return
            end
        end
        local best, bestD
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") then
                local d = (p.Position - origin).Magnitude
                if not bestD or d < bestD then bestD = d; best = p end
            end
        end
        if best then worldPos = best.Position end
    end)

    if cfg.HitMarkerEnabled and worldPos and SpawnHitMarker then
        pcall(SpawnHitMarker, worldPos)
    end

    if cfg.DamageNumbersEnabled and worldPos then
        pcall(SpawnDamageNumber, worldPos, dmg)
    end
end

function OnPlayerMaybeKilled(player, char, hum)
    if not player or player == LocalPlayer then return end
    local cache = GetCache() or Cache
    local key = hum or char
    if not key then return end
    cache.KillHandledHum = cache.KillHandledHum or {}
    if cache.KillHandledHum[key] then return end
    cache.KillHandledHum[key] = true
    if OnVictimDied then
        pcall(OnVictimDied, player, hum or char)
    else
        
        local now = tick()
        local recent = cache.RecentDamageTargets and cache.RecentDamageTargets[player]
        local isMine = recent and (now - recent) < 3.5
            or cache.LastShotTarget == player and (now - (cache.LastShotTime or 0)) < 3.5
            or cache.AimLockTarget == player
            or cache.SilentV2Target == player
        if isMine then
            if Config.KillLogsEnabled and ShowKillLog then
                pcall(ShowKillLog, LocalPlayer.DisplayName or LocalPlayer.Name, player.DisplayName or player.Name)
            end
            if Config.CustomFireSoundEnabled and TryPlayKillSound then
                pcall(TryPlayKillSound, player)
            end
            if Config.KillFlashEnabled and TriggerKillFlash then
                pcall(TriggerKillFlash, Config.Color_KillFlash)
            end
        end
    end
end

function HookPlayerDamageVisuals(player)
    if player == LocalPlayer then return end
    local function hook(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChild("Humanoid")
        local cache = GetCache() or Cache
        local hp, maxHp = ResolvePlayerHealth(char, hum)
        cache.LastKnownHP[player] = hp

        if hum then
            pcall(function()
                hum.HealthChanged:Connect(function(newHp)
                    local prev = cache.LastKnownHP[player]
                    if prev == nil then prev = newHp end
                    cache.LastKnownHP[player] = newHp
                    if newHp < prev then
                        OnPlayerTookDamage(player, char, prev, newHp, hum.MaxHealth)
                    end
                    if newHp <= 0 then
                        OnPlayerMaybeKilled(player, char, hum)
                    end
                end)
                hum.Died:Connect(function()
                    OnPlayerMaybeKilled(player, char, hum)
                end)
            end)
        end
        
        pcall(function()
            char:GetAttributeChangedSignal("Health"):Connect(function()
                local nhp, nmax = ResolvePlayerHealth(char, hum)
                local prev = cache.LastKnownHP[player]
                if prev == nil then prev = nhp end
                cache.LastKnownHP[player] = nhp
                if nhp < prev then
                    OnPlayerTookDamage(player, char, prev, nhp, nmax)
                end
                if nhp <= 0 then
                    OnPlayerMaybeKilled(player, char, hum)
                end
            end)
            char:GetAttributeChangedSignal("Dead"):Connect(function()
                if char:GetAttribute("Dead") == true then
                    OnPlayerMaybeKilled(player, char, hum)
                end
            end)
        end)
    end
    if player.Character then task.spawn(hook, player.Character) end
    player.CharacterAdded:Connect(function(c)
        task.delay(0.15, function() if player.Character == c then hook(c) end end)
    end)
end

for _, p in ipairs((CachedPlayerList or Players:GetPlayers())) do task.spawn(HookPlayerDamageVisuals, p) end
Players.PlayerAdded:Connect(HookPlayerDamageVisuals)
Players.PlayerRemoving:Connect(function(p)
    local cache = GetCache()
    if cache then cache.LastKnownHP[p] = nil end
end)


if not Cache._UniversalCombatPoll then
    Cache._UniversalCombatPoll = true
    task.spawn(function()
        while true do
            task.wait(0.08)
            pcall(function()
                local cfg = GetCfg() or Config
                local cache = GetCache() or Cache
                if not cfg or not cache then return end
                if not (cfg.HitMarkerEnabled or cfg.CustomFireSoundEnabled or cfg.KillLogsEnabled or cfg.DamageNumbersEnabled or cfg.KillFlashEnabled) then
                    return
                end
                for _, player in ipairs(CachedPlayerList or Players:GetPlayers()) do
                    if player == LocalPlayer then continue end
                    local char = player.Character
                    if not char then continue end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local hp, maxHp, dead = ResolvePlayerHealth(char, hum)
                    local prev = cache.LastKnownHP[player]
                    if prev == nil then
                        cache.LastKnownHP[player] = hp
                        continue
                    end
                    if hp < prev - 0.35 then
                        cache.LastKnownHP[player] = hp
                        OnPlayerTookDamage(player, char, prev, hp, maxHp)
                    else
                        cache.LastKnownHP[player] = hp
                    end
                    if dead or hp <= 0 then
                        OnPlayerMaybeKilled(player, char, hum)
                    end
                end
            end)
        end
    end)
end


Cache.ExtraVisAccum = 0
pcall(function()
    rawset(_G, "Config", Config)
    rawset(_G, "Cache", Cache)
end)
pcall(function() RunService:UnbindFromRenderStep("AnxiumExtraVisuals") end)
RunService:BindToRenderStep("AnxiumExtraVisuals", Enum.RenderPriority.Camera.Value + 5, function(dt)
    local cfg = GetCfg()
    local cache = GetCache()
    if not cfg or not cache then return end
    if not cfg.SelfChamsEnabled then
        if cache.SelfChamsOriginals or cache.SelfChamsHL then
            pcall(SelfChams_Clear)
        end
        return
    end
    cache.ExtraVisAccum = (cache.ExtraVisAccum or 0) + (dt or 0.016)
    if cache.ExtraVisAccum < 0.1 then return end
    cache.ExtraVisAccum = 0
    pcall(SelfChams_Update)
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.delay(0.4, function() SelfChams_Clear() end)
end)


Debris = game:GetService("Debris")

Cache.UV_Arrows = Cache.UV_Arrows or {}
Cache.UV_DeathConns = Cache.UV_DeathConns or {}

function UV_GetColor(key, fallback)
    local cfg = rawget(_G, "Config") or Config
    if type(cfg) == "table" and cfg[key] then return cfg[key] end
    return fallback
end


function UV_CreateChamsClone(character, color, fadeDelay, fadeTime, transparency, style)
    
    if not character or not character.Parent then return end

    local materialMode = style or "Chams"
    if materialMode == "ForceField" then materialMode = "FF" end

    local fillT = 0.35
    if materialMode == "Chams" then
        fillT = math.clamp(tonumber(transparency) or 0.35, 0, 0.9)
    elseif materialMode == "FF" then
        fillT = 0.5
    end

    local oldArchivable = character.Archivable
    character.Archivable = true
    local success, clone = pcall(function()
        return character:Clone()
    end)
    character.Archivable = oldArchivable
    if not success or not clone then return end
    clone.Name = "AnxiumVisualPlayerClone"

    
    pcall(function()
        local hum = clone:FindFirstChildOfClass("Humanoid")
        if hum then
            local anim = hum:FindFirstChildOfClass("Animator")
            if anim then anim:Destroy() end
            hum:Destroy()
        end
    end)
    for _, object in ipairs(clone:GetDescendants()) do
        local cn = object.ClassName
        if cn == "Script" or cn == "LocalScript" or cn == "Shirt" or cn == "Pants"
            or cn == "ShirtGraphic" or cn == "BodyColors" or cn == "CharacterMesh"
            or cn == "SurfaceAppearance" or cn == "WrapLayer" or cn == "WrapTarget"
            or cn == "ParticleEmitter" or cn == "Trail" or cn == "Beam"
            or cn == "Smoke" or cn == "Fire" or cn == "Sparkles" then
            pcall(function() object:Destroy() end)
        end
    end

    local function lockVisual()
        if not clone or not clone.Parent then return end
        for _, object in ipairs(clone:GetDescendants()) do
            if object:IsA("BasePart") then
                pcall(function()
                    object.Anchored = true
                    object.CanCollide = false
                    object.CanTouch = false
                    object.CanQuery = false
                    object.CastShadow = false
                    object.Massless = true
                    if object:IsA("MeshPart") then object.TextureID = "" end
                    for _, ch in ipairs(object:GetChildren()) do
                        if ch:IsA("SpecialMesh") then
                            ch.TextureId = ""
                        elseif ch:IsA("Decal") or ch:IsA("Texture") then
                            ch.Transparency = 1
                        elseif ch:IsA("SurfaceAppearance") then
                            ch:Destroy()
                        end
                    end
                    if object.Name == "HumanoidRootPart" then
                        object.Transparency = 1
                    else
                        if materialMode == "FF" then
                            object.Material = Enum.Material.ForceField
                            object.Color = color
                            object.Transparency = 0
                            object.Reflectance = 0
                        else
                            
                            object.Transparency = 0
                        end
                    end
                end)
            elseif object:IsA("Decal") or object:IsA("Texture") then
                pcall(function() object.Transparency = 1 end)
            end
        end
    end

    lockVisual()
    clone.Parent = Workspace
    lockVisual()

    
    for _, h in ipairs(clone:GetChildren()) do
        if h:IsA("Highlight") then pcall(function() h:Destroy() end) end
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "AnxiumCloneChams"
    highlight.Adornee = clone
    highlight.DepthMode = (Config.DeathEffectsXRay and Enum.HighlightDepthMode.AlwaysOnTop) or Enum.HighlightDepthMode.Occluded
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = fillT
    highlight.OutlineTransparency = 0
    highlight.Enabled = true
    highlight.Parent = clone

    
    local alive = true
    local lockConn
    local accum = 0
    lockConn = RunService.Heartbeat:Connect(function(dt)
        if not alive or not clone or not clone.Parent then
            alive = false
            if lockConn then pcall(function() lockConn:Disconnect() end) end
            return
        end
        accum = accum + (dt or 0.016)
        if accum < 0.2 then return end
        accum = 0
        if highlight and highlight.Parent then
            highlight.Adornee = clone
            highlight.Enabled = true
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.FillTransparency = fillT
        elseif clone.Parent then
            highlight = Instance.new("Highlight")
            highlight.Name = "AnxiumCloneChams"
            highlight.Adornee = clone
            highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.FillTransparency = fillT
            highlight.OutlineTransparency = 0
            highlight.Enabled = true
            highlight.Parent = clone
            lockVisual()
        end
    end)

    
    
    local lifetime = math.max(0.15, (tonumber(fadeDelay) or 1.5) + (tonumber(fadeTime) or 1.2))
    task.delay(lifetime, function()
        alive = false
        if lockConn then pcall(function() lockConn:Disconnect() end) end
        if clone and clone.Parent then
            pcall(function() clone:Destroy() end)
        end
    end)
end


task.spawn(function()
    while true do
        local cfg = rawget(_G, "Config") or Config
        if type(cfg) ~= "table" or not cfg.CloneChamsEnabled then
            task.wait(0.75)
        else
            local interval = tonumber(cfg.CloneInterval) or 1
            task.wait(math.clamp(interval, 0.25, 5))
            cfg = rawget(_G, "Config") or Config
            if type(cfg) == "table" and cfg.CloneChamsEnabled then
                local col = cfg.Color_CloneChams or Color3.fromRGB(255, 60, 60)
                local fadeD = cfg.CloneFadeDelay or 1.5
                local fadeT = cfg.CloneFadeTime or 1.2
                local trans = cfg.CloneTransparency or 0.35
                local style = cfg.CloneChamsStyle or "Chams"
                if style == "ForceField" then style = "FF" end
                local list = CachedPlayerList
                if not list or #list == 0 then list = Players:GetPlayers() end
                local activeClones = 0
                pcall(function()
                    for _, c in ipairs(Workspace:GetChildren()) do
                        if c.Name == "AnxiumVisualPlayerClone" then
                            activeClones = activeClones + 1
                        end
                    end
                end)
                if activeClones < 10 then
                    for i = 1, #list do
                        if activeClones >= 10 then break end
                        local player = list[i]
                        if player and player ~= LocalPlayer then
                            if not (ShouldSkipEspPlayer(player)) then
                                local character = player.Character
                                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                                local root = character and character:FindFirstChild("HumanoidRootPart")
                                if humanoid and root and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0.05 then
                                    local ok = pcall(UV_CreateChamsClone, character, col, fadeD, fadeT, trans, style)
                                    if ok then activeClones = activeClones + 1 end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)


function UV_ClearArrows()
    for plr, data in pairs(Cache.UV_Arrows or {}) do
        pcall(function() if data.Holder then data.Holder:Destroy() end end)
    end
    Cache.UV_Arrows = {}
    if Cache.UV_RadiusRing then
        Cache.UV_RadiusRing.Visible = false
    end
end

function UV_BuildArrowGradient(colorA, colorB)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    colorA = colorA or Color3.fromRGB(255, 70, 70)
    colorB = colorB or Color3.fromRGB(255, 150, 80)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, colorA),
        ColorSequenceKeypoint.new(0.35, colorA:Lerp(Color3.new(1, 1, 1), 0.45)),
        ColorSequenceKeypoint.new(0.60, Color3.new(1, 1, 1):Lerp(colorB, 0.35)),
        ColorSequenceKeypoint.new(1.00, colorB),
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 0.15),
        NumberSequenceKeypoint.new(0.50, 0.00),
        NumberSequenceKeypoint.new(1.00, 0.25),
    })
    gradient.Enabled = true
    return gradient
end

function UV_RefreshArrowGradients()
    local cfg = rawget(_G, "Config") or Config
    local colorA = (cfg and cfg.Color_OffscreenArrow) or Color3.fromRGB(255, 70, 70)
    local colorB = (cfg and cfg.Color_OffscreenArrowB) or Color3.fromRGB(255, 150, 80)
    local seq = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, colorA),
        ColorSequenceKeypoint.new(0.35, colorA:Lerp(Color3.new(1, 1, 1), 0.45)),
        ColorSequenceKeypoint.new(0.60, Color3.new(1, 1, 1):Lerp(colorB, 0.35)),
        ColorSequenceKeypoint.new(1.00, colorB),
    })
    local seq2 = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, colorB),
        ColorSequenceKeypoint.new(1.00, colorA),
    })
    for _, data in pairs(Cache.UV_Arrows or {}) do
        if data.ArrowGradient then data.ArrowGradient.Color = seq end
        if data.GlowGradient then data.GlowGradient.Color = seq end
        if data.Glow2Gradient then data.Glow2Gradient.Color = seq2 end
    end
end

function UV_CreateArrow(player)
    if Cache.UV_Arrows[player] then return Cache.UV_Arrows[player] end
    local cfg = rawget(_G, "Config") or Config
    local size = math.clamp(math.floor(tonumber(cfg and cfg.ArrowSize) or 34), 10, 100)
    local colorA = (cfg and cfg.Color_OffscreenArrow) or Color3.fromRGB(255, 70, 70)
    local colorB = (cfg and cfg.Color_OffscreenArrowB) or Color3.fromRGB(255, 150, 80)
    local arrowTrans = tonumber(cfg and cfg.ArrowTransparency) or 0.05

    local holder = Instance.new("Frame")
    holder.Name = "AnxiumArrow_" .. player.Name
    holder.BackgroundTransparency = 1
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Size = UDim2.fromOffset(size, size)
    holder.Visible = false
    holder.ZIndex = 100
    holder.Parent = ScreenGui

    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.BackgroundTransparency = 1
    arrow.Size = UDim2.fromScale(1, 1)
    arrow.Text = "▶"
    arrow.TextScaled = true
    arrow.Font = Enum.Font.GothamBold
    pcall(function() arrow:SetAttribute("AnxiumLockFont", true) end)
    arrow.TextColor3 = Color3.new(1, 1, 1)
    arrow.TextTransparency = arrowTrans
    arrow.ZIndex = 101
    arrow.Parent = holder

    local arrowGradient = UV_BuildArrowGradient(colorA, colorB)
    arrowGradient.Parent = arrow

    local glow = Instance.new("TextLabel")
    glow.Name = "SoftGlow"
    glow.BackgroundTransparency = 1
    glow.Size = UDim2.fromScale(1.18, 1.18)
    glow.Position = UDim2.fromScale(-0.09, -0.09)
    glow.Text = "▶"
    glow.TextScaled = true
    glow.Font = Enum.Font.GothamBold
    pcall(function() glow:SetAttribute("AnxiumLockFont", true) end)
    glow.TextColor3 = Color3.new(1, 1, 1)
    glow.TextTransparency = 0.82
    glow.ZIndex = 100
    glow.Parent = holder

    local glowGradient = UV_BuildArrowGradient(colorA, colorB)
    glowGradient.Parent = glow

    local glow2 = Instance.new("TextLabel")
    glow2.Name = "SoftGlow2"
    glow2.BackgroundTransparency = 1
    glow2.Size = UDim2.fromScale(1.45, 1.45)
    glow2.Position = UDim2.fromScale(-0.225, -0.225)
    glow2.Text = "▶"
    glow2.TextScaled = true
    glow2.Font = Enum.Font.GothamBold
    pcall(function() glow2:SetAttribute("AnxiumLockFont", true) end)
    glow2.TextColor3 = Color3.new(1, 1, 1)
    glow2.TextTransparency = 0.94
    glow2.ZIndex = 99
    glow2.Parent = holder

    local glow2Gradient = UV_BuildArrowGradient(colorB, colorA)
    glow2Gradient.Parent = glow2

    local data = {
        Holder = holder,
        Arrow = arrow,
        Glow = glow,
        Glow2 = glow2,
        ArrowGradient = arrowGradient,
        GlowGradient = glowGradient,
        Glow2Gradient = glow2Gradient,
        CurrentPosition = Vector2.zero,
        CurrentRotation = 0,
    }
    Cache.UV_Arrows[player] = data
    return data
end

Players.PlayerRemoving:Connect(function(player)
    if Cache.UV_Arrows and Cache.UV_Arrows[player] then
        pcall(function() Cache.UV_Arrows[player].Holder:Destroy() end)
        Cache.UV_Arrows[player] = nil
    end
end)

function UV_SmoothAngle(current, target, speed)
    local difference = math.atan2(math.sin(target - current), math.cos(target - current))
    return current + difference * speed
end

function UV_CalculateArrowPosition(worldPosition, viewportSize, screenRadius, edgePadding)
    local cam = Workspace.CurrentCamera
    if not cam then return nil end
    local screenPosition, onScreen = cam:WorldToViewportPoint(worldPosition)
    if onScreen and screenPosition.Z > 0 then
        local margin = 4
        if screenPosition.X >= margin and screenPosition.X <= viewportSize.X - margin
            and screenPosition.Y >= margin and screenPosition.Y <= viewportSize.Y - margin then
            return nil
        end
    end

    local cameraPosition = cam.CFrame.Position
    local direction = worldPosition - cameraPosition
    if direction.Magnitude <= 0.01 then return nil end

    local x = direction:Dot(cam.CFrame.RightVector)
    local y = direction:Dot(cam.CFrame.UpVector)
    local direction2D = Vector2.new(x, y)
    if direction2D.Magnitude <= 0.001 then return nil end
    direction2D = direction2D.Unit

    local center = Vector2.new(viewportSize.X * 0.5, viewportSize.Y * 0.5)
    local radius = math.min(viewportSize.X, viewportSize.Y) * screenRadius
    local position = center + direction2D * radius
    local padding = edgePadding or 55
    position = Vector2.new(
        math.clamp(position.X, padding, viewportSize.X - padding),
        math.clamp(position.Y, padding, viewportSize.Y - padding)
    )
    return position, direction2D
end

Cache._blurGradientTime = 0
RunService.RenderStepped:Connect(function(deltaTime)
    local cfg = rawget(_G, "Config") or Config
    if type(cfg) ~= "table" or not cfg.BlurGradientEnabled then return end
    if not BlurGradientOverlayGradient or not BlurGradientOverlay.Visible then return end
    local colorA = cfg.Color_BlurGradientA or Color3.fromRGB(130, 70, 255)
    local colorB = cfg.Color_BlurGradientB or Color3.fromRGB(180, 140, 255)
    if cfg.BlurGradientAnimate then
        local spd = math.clamp(tonumber(cfg.BlurGradientSpeed) or 1, 0.1, 3)
        Cache._blurGradientTime = (Cache._blurGradientTime or 0) + (deltaTime or 0.016) * (0.65 * spd)
        local alpha = (math.sin(Cache._blurGradientTime) + 1) * 0.5
        local first = colorA:Lerp(colorB, alpha)
        local second = colorB:Lerp(colorA, alpha)
        BlurGradientOverlayGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, first),
            ColorSequenceKeypoint.new(1, second),
        })
    else
        BlurGradientOverlayGradient.Color = ColorSequence.new(colorA, colorB)
    end
end)

Cache._arrowGradTime = 0
RunService.RenderStepped:Connect(function(deltaTime)
    local cfg = rawget(_G, "Config") or Config
    if type(cfg) ~= "table" then return end

    if not cfg.OffscreenArrowsEnabled then
        if Cache._arrowsWereOn then
            for _, data in pairs(Cache.UV_Arrows or {}) do
                if data.Holder then data.Holder.Visible = false end
            end
            Cache._arrowsWereOn = false
        end
        return
    end
    Cache._arrowsWereOn = true

    local camera = Workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local screenRadius = math.clamp(tonumber(cfg.ArrowDistance) or 0.42, 0.1, 0.48)
    local arrowSize = math.clamp(math.floor(tonumber(cfg.ArrowSize) or 34), 10, 100)
    local edgePadding = tonumber(cfg.ArrowEdgePadding) or 55
    local posSmooth = tonumber(cfg.ArrowPosSmooth) or 0.16
    local rotSmooth = tonumber(cfg.ArrowRotSmooth) or 0.18
    local gradSpeed = tonumber(cfg.ArrowGradientSpeed) or 0.35
    local arrowTrans = tonumber(cfg.ArrowTransparency) or 0.05

    Cache._arrowGradTime = (Cache._arrowGradTime or 0) + (deltaTime or 0.016) * gradSpeed
    local gradOffset = (math.sin(Cache._arrowGradTime) + 1) * 0.5

    local list = CachedPlayerList
    if not list or #list == 0 then list = Players:GetPlayers() end

    for i = 1, #list do
        local player = list[i]
        if player and player ~= LocalPlayer then
            local data = UV_CreateArrow(player)
            if not data or not data.Holder then
                
            elseif ShouldSkipEspPlayer(player) then
                data.Holder.Visible = false
            else
                local character = player.Character
                local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character.PrimaryPart)
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if not root or not humanoid or humanoid.Health <= 0 then
                    data.Holder.Visible = false
                else
                    local position, direction = UV_CalculateArrowPosition(root.Position, viewport, screenRadius, edgePadding)
                    if not position then
                        data.Holder.Visible = false
                    else
                        data.Holder.Visible = true
                        local dt = deltaTime or 0.016
                        if data.CurrentPosition == Vector2.zero then
                            data.CurrentPosition = position
                        else
                            data.CurrentPosition = data.CurrentPosition:Lerp(
                                position,
                                1 - math.pow(1 - posSmooth, dt * 60)
                            )
                        end
                        data.Holder.Position = UDim2.fromOffset(data.CurrentPosition.X, data.CurrentPosition.Y)
                        data.Holder.Size = UDim2.fromOffset(arrowSize, arrowSize)

                        local targetAngle = math.atan2(direction.Y, direction.X)
                        local targetRotation = math.deg(targetAngle)
                        data.CurrentRotation = math.deg(UV_SmoothAngle(
                            math.rad(data.CurrentRotation or 0),
                            math.rad(targetRotation),
                            1 - math.pow(1 - rotSmooth, dt * 60)
                        ))
                        data.Holder.Rotation = data.CurrentRotation

                        local pulseTrans = arrowTrans
                        local glowTrans = 0.82
                        local glow2Trans = 0.94
                        if cfg.ArrowPulseEnabled then
                            local spd = math.max(0.01, tonumber(cfg.ArrowPulseSpeed) or 3)
                            local phase = tick() * spd * math.pi * 2 - math.pi * 0.5
                            local wave = (math.sin(phase) + 1) * 0.5
                            pulseTrans = arrowTrans + (1 - arrowTrans) * wave
                            glowTrans = 0.82 + (1 - 0.82) * wave
                            glow2Trans = 0.94 + (1 - 0.94) * wave
                        end
                        if data.Arrow then
                            data.Arrow.Text = "▶"
                            data.Arrow.Font = Enum.Font.GothamBold
                            data.Arrow.TextTransparency = pulseTrans
                            data.Arrow.Visible = true
                        end
                        if data.Glow then
                            data.Glow.Font = Enum.Font.GothamBold
                            data.Glow.TextTransparency = glowTrans
                            data.Glow.Visible = true
                        end
                        if data.Glow2 then
                            data.Glow2.Font = Enum.Font.GothamBold
                            data.Glow2.TextTransparency = glow2Trans
                            data.Glow2.Visible = true
                        end

                        if data.ArrowGradient then
                            data.ArrowGradient.Enabled = true
                            data.ArrowGradient.Offset = Vector2.new(0, gradOffset * 0.35)
                        end
                        if data.GlowGradient then
                            data.GlowGradient.Enabled = true
                            data.GlowGradient.Offset = Vector2.new(0, gradOffset * 0.35)
                        end
                        if data.Glow2Gradient then
                            data.Glow2Gradient.Enabled = true
                            data.Glow2Gradient.Offset = Vector2.new(0, -gradOffset * 0.45)
                        end
                    end
                end
            end
        end
    end
end)


function UV_CreateKillDissolve(character)
    local cfg = rawget(_G, "Config") or Config
    if type(cfg) ~= "table" or not cfg.KillDissolveEnabled then return end
    if not character or not character.Parent then return end

    Cache.KillDissolveActive = Cache.KillDissolveActive or 0
    if Cache.KillDissolveActive >= 3 then return end

    local glowCol = cfg.Color_KillDissolve or Color3.fromRGB(180, 100, 255)
    local poseLife = 0.4
    local dissolveTime = 1.0
    local maxParts = 18
    local particlesPer = 2
    local pSize = 0.3

    if not Cache.KillDissolveFolder or not Cache.KillDissolveFolder.Parent then
        local f = Instance.new("Folder")
        f.Name = "AnxiumKillDissolve"
        f.Parent = Workspace
        Cache.KillDissolveFolder = f
    end
    local folder = Cache.KillDissolveFolder

    local srcParts = {}
    for _, d in ipairs(character:GetDescendants()) do
        if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
            srcParts[#srcParts + 1] = d
        end
    end
    if #srcParts == 0 then return end
    if #srcParts > maxParts then
        table.sort(srcParts, function(a, b) return a.Size.Magnitude > b.Size.Magnitude end)
        local t = {}
        for i = 1, maxParts do t[i] = srcParts[i] end
        srcParts = t
    end

    local centerPos
    local root = character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("UpperTorso")
    centerPos = root and root.Position or srcParts[1].Position

    Cache.KillDissolveActive = Cache.KillDissolveActive + 1

    local clone = Instance.new("Model")
    clone.Name = "KillDissolvePose"
    clone.Parent = folder

    local glow = Instance.new("Highlight")
    glow.FillColor = glowCol
    glow.OutlineColor = glowCol
    glow.FillTransparency = 0.3
    glow.OutlineTransparency = 0.05
    glow.DepthMode = (Config.DeathEffectsXRay and Enum.HighlightDepthMode.AlwaysOnTop) or Enum.HighlightDepthMode.Occluded
    glow.Parent = clone

    local function strip(part)
        for _, ch in ipairs(part:GetChildren()) do
            if ch:IsA("JointInstance") or ch:IsA("WeldConstraint") or ch:IsA("Motor6D")
                or ch:IsA("Sound") or ch:IsA("ParticleEmitter") or ch:IsA("Fire")
                or ch:IsA("Smoke") or ch:IsA("Attachment") or ch:IsA("TouchTransmitter") then
                ch:Destroy()
            end
        end
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.CastShadow = false
        part.Massless = true
    end

    local entries = {}
    for _, src in ipairs(srcParts) do
        local ok, cp = pcall(function() return src:Clone() end)
        if ok and cp then
            strip(cp)
            cp.CFrame = src.CFrame
            cp.Color = glowCol
            cp.Material = Enum.Material.Neon
            cp.Transparency = 0.1
            if cp:IsA("MeshPart") then pcall(function() cp.TextureID = "" end) end
            for _, ch in ipairs(cp:GetChildren()) do
                if ch:IsA("SpecialMesh") then pcall(function() ch.TextureId = "" end)
                elseif ch:IsA("Decal") or ch:IsA("Texture") then ch:Destroy() end
            end
            cp.Parent = clone
            local outward = src.Position - centerPos
            if outward.Magnitude < 0.08 then
                outward = Vector3.new((math.random() - 0.5) * 0.4, 0.35, (math.random() - 0.5) * 0.4)
            end
            entries[#entries + 1] = {
                part = cp,
                originCF = src.CFrame,
                dir = outward.Unit,
                spin = Vector3.new((math.random() - 0.5) * 2, (math.random() - 0.5) * 2, (math.random() - 0.5) * 2),
            }
        end
    end

    if #entries == 0 then
        clone:Destroy()
        Cache.KillDissolveActive = math.max(0, Cache.KillDissolveActive - 1)
        return
    end

    local function makeParticle(pos)
        local p = Instance.new("Part")
        p.Shape = Enum.PartType.Ball
        p.Size = Vector3.new(pSize, pSize, pSize)
        p.Color = glowCol
        p.Material = Enum.Material.Neon
        p.Anchored = true
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.CastShadow = false
        p.CFrame = CFrame.new(pos)
        p.Parent = folder
        local dir = Vector3.new((math.random() - 0.5) * 2, math.random() * 1.1 + 0.25, (math.random() - 0.5) * 2).Unit
        local speed = 3.5 + math.random() * 5
        local life = dissolveTime * (0.65 + math.random() * 0.45)
        local t0 = tick()
        local start = pos
        local conn
        conn = RunService.Heartbeat:Connect(function()
            local a = (tick() - t0) / life
            if a >= 1 or not p.Parent then
                conn:Disconnect()
                p:Destroy()
                return
            end
            p.CFrame = CFrame.new(start + dir * (speed * a) + Vector3.new(0, a * 2.2, 0))
            p.Transparency = a
            local s = pSize * (1 - a * 0.75)
            p.Size = Vector3.new(s, s, s)
        end)
        Debris:AddItem(p, life + 0.15)
    end

    task.delay(poseLife, function()
        if not clone.Parent then
            Cache.KillDissolveActive = math.max(0, Cache.KillDissolveActive - 1)
            return
        end
        local step = math.max(1, math.floor(#entries / 5))
        for i = 1, #entries, step do
            local e = entries[i]
            if e then
                for _ = 1, particlesPer do
                    makeParticle(e.originCF.Position)
                end
            end
        end
        local t0 = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            local a = (tick() - t0) / dissolveTime
            if a >= 1 then
                conn:Disconnect()
                if clone.Parent then clone:Destroy() end
                Cache.KillDissolveActive = math.max(0, Cache.KillDissolveActive - 1)
                return
            end
            local ease = a * a
            glow.FillTransparency = 0.3 + ease * 0.7
            glow.OutlineTransparency = 0.05 + ease * 0.95
            for _, e in ipairs(entries) do
                local p = e.part
                if p and p.Parent then
                    local offset = e.dir * (ease * 3.2) + Vector3.new(0, ease * 2.0, 0)
                    local rot = CFrame.Angles(e.spin.X * ease * 1.8, e.spin.Y * ease * 1.8, e.spin.Z * ease * 1.8)
                    p.CFrame = e.originCF * rot + offset
                    p.Transparency = 0.15 + ease * 0.85
                end
            end
        end)
    end)

    Debris:AddItem(clone, poseLife + dissolveTime + 0.4)
end

function UV_CreateDeathBurst(position)
    local cfg = rawget(_G, "Config") or Config
    if type(cfg) ~= "table" or not cfg.DeathBurstEnabled then return end
    if not position then return end

    local part = Instance.new("Part")
    part.Name = "AnxiumDeathBurst"
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Transparency = 1
    part.Parent = Workspace

    local attachment = Instance.new("Attachment")
    attachment.Parent = part

    local burstCol = cfg.Color_DeathBurst or Color3.fromRGB(255, 90, 35)

    local function makeEmitter(count, speed, size, lifetime)
        local emitter = Instance.new("ParticleEmitter")
        emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        emitter.Color = ColorSequence.new(burstCol, Color3.new(1, 1, 1))
        emitter.LightEmission = 1
        emitter.Brightness = 5
        emitter.Lifetime = NumberRange.new(lifetime * 0.7, lifetime)
        emitter.Speed = NumberRange.new(speed * 0.7, speed)
        emitter.SpreadAngle = Vector2.new(360, 360)
        emitter.Rate = 0
        emitter.Drag = 2
        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, size),
            NumberSequenceKeypoint.new(0.35, size * 0.8),
            NumberSequenceKeypoint.new(1, 0),
        })
        emitter.Parent = attachment
        emitter:Emit(count)
        task.delay(lifetime + 0.2, function()
            if emitter then pcall(function() emitter:Destroy() end) end
        end)
    end

    makeEmitter(80, 22, 0.55, 0.8)
    makeEmitter(110, 35, 0.28, 0.55)
    makeEmitter(35, 12, 0.8, 1.2)
    task.delay(0.12, function()
        if part and part.Parent then
            makeEmitter(45, 25, 0.4, 0.7)
        end
    end)
    Debris:AddItem(part, 2)
end


function UV_SetupDeath(player)
    if player == LocalPlayer then return end
    local function setupCharacter(character)
        local humanoid = character:WaitForChild("Humanoid", 10)
        if not humanoid then return end
        
        local function doDeathFX()
            local cfg = rawget(_G, "Config") or Config
            if type(cfg) ~= "table" then return end
            if ShouldSkipEspPlayer(player) then return end
            local root = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
            local position = root and root.Position or character:GetPivot().Position
            if cfg.DeathChamsEnabled then
                local dStyle = cfg.DeathChamsStyle or "Chams"
                if dStyle == "ForceField" then dStyle = "FF" end
                pcall(UV_CreateChamsClone,
                    character,
                    cfg.Color_DeathChams or Color3.fromRGB(255, 170, 40),
                    cfg.DeathFadeDelay or 1.5,
                    cfg.DeathFadeTime or 1.5,
                    cfg.CloneTransparency or 0.3,
                    dStyle
                )
            end
            if cfg.DeathBurstEnabled then
                pcall(UV_CreateDeathBurst, position)
            end
            if cfg.KillDissolveEnabled then
                pcall(UV_CreateKillDissolve, character)
            end
        end
        local fired = false
        local function fireOnce()
            if fired then return end
            fired = true
            doDeathFX()
        end
        local connHealth = humanoid.HealthChanged:Connect(function(hp)
            if hp <= 0 then fireOnce() end
        end)
        local conn = humanoid.Died:Connect(function()
            fireOnce()
        end)
        Cache.UV_DeathConns[player] = Cache.UV_DeathConns[player] or {}
        table.insert(Cache.UV_DeathConns[player], connHealth)
        table.insert(Cache.UV_DeathConns[player], conn)
    end
    if player.Character then task.spawn(setupCharacter, player.Character) end
    player.CharacterAdded:Connect(function(char)
        task.defer(function() setupCharacter(char) end)
    end)
end

for _, player in ipairs((CachedPlayerList or Players:GetPlayers())) do
    task.spawn(UV_SetupDeath, player)
end
Players.PlayerAdded:Connect(UV_SetupDeath)
Players.PlayerRemoving:Connect(function(player)
    if Cache.UV_DeathConns and Cache.UV_DeathConns[player] then
        for _, c in ipairs(Cache.UV_DeathConns[player]) do
            pcall(function() c:Disconnect() end)
        end
        Cache.UV_DeathConns[player] = nil
    end
end)


Cache.KillFlashFrame = nil
Cache.KillFlashToken = 0

function EnsureKillFlashFrame()
    if Cache.KillFlashFrame and Cache.KillFlashFrame.Parent then
        return Cache.KillFlashFrame
    end
    local f = Instance.new("Frame")
    f.Name = "AnxiumKillFlash"
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundColor3 = Config.Color_KillFlash or Color3.fromRGB(255, 255, 255)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.ZIndex = 1000
    f.Visible = false
    f.Parent = ScreenGui
    Cache.KillFlashFrame = f
    return f
end

function TriggerKillFlash(color)
    if not Config or not Config.KillFlashEnabled then return end
    local f = EnsureKillFlashFrame()
    local col = color or Config.Color_KillFlash or Color3.fromRGB(255, 255, 255)
    local dur = math.clamp(tonumber(Config.KillFlashDuration) or 0.85, 0.15, 3)
    Cache.KillFlashToken = (Cache.KillFlashToken or 0) + 1
    local token = Cache.KillFlashToken
    f.BackgroundColor3 = col
    f.BackgroundTransparency = 0.15
    f.Visible = true
    task.spawn(function()
        task.wait(0.06)
        if token ~= Cache.KillFlashToken then return end
        local tw = TweenService:Create(f, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
        tw:Play()
        tw.Completed:Wait()
        if token == Cache.KillFlashToken then
            f.Visible = false
            f.BackgroundTransparency = 1
        end
    end)
end


Cache.HitboxData = Cache.HitboxData or {}


HITBOX_PART_NAMES = {
    "Head", "Torso", "HumanoidRootPart",
    "UpperTorso", "LowerTorso",
    "Left Arm", "Right Arm", "Left Leg", "Right Leg",
    "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "RightUpperLeg", "RightLowerLeg", "RightFoot",
}

function Hitbox_IsBodyPart(part)
    if not part or not part:IsA("BasePart") then return false end
    local n = part.Name
    for _, name in ipairs(HITBOX_PART_NAMES) do
        if n == name then return true end
    end
    return false
end

function Hitbox_ClearPlayer(player)
    local data = Cache.HitboxData[player]
    if not data then return end
    if data.boxes then
        for _, box in pairs(data.boxes) do
            pcall(function()
                if box then box:Destroy() end
            end)
        end
    end
    Cache.HitboxData[player] = nil
end

function Hitbox_ClearAll()
    for plr in pairs(Cache.HitboxData or {}) do
        Hitbox_ClearPlayer(plr)
    end
    Cache.HitboxData = {}
end

function Hitbox_ShouldSkip(player)
    if not player or player == LocalPlayer then return true end
    if ShouldSkipEspPlayer(player) then return true end
    return false
end

function Hitbox_ApplyPlayer(player)
    if not Config.HitboxShow then
        Hitbox_ClearPlayer(player)
        return
    end
    if Hitbox_ShouldSkip(player) then
        Hitbox_ClearPlayer(player)
        return
    end
    local char = player.Character
    if not char then
        Hitbox_ClearPlayer(player)
        return
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then
        Hitbox_ClearPlayer(player)
        return
    end

    local col = Config.Color_Hitbox or Color3.fromRGB(255, 80, 80)
    local data = Cache.HitboxData[player]
    if not data then
        data = { boxes = {}, char = char }
        Cache.HitboxData[player] = data
    end
    if data.char ~= char then
        Hitbox_ClearPlayer(player)
        data = { boxes = {}, char = char }
        Cache.HitboxData[player] = data
    end

    local seen = {}
    for _, part in ipairs(char:GetChildren()) do
        if Hitbox_IsBodyPart(part) then
            seen[part] = true
            local box = data.boxes[part]
            if not box or not box.Parent then
                box = Instance.new("SelectionBox")
                box.Name = "AnxiumHitbox"
                box.Adornee = part
                box.LineThickness = 0.025
                box.SurfaceTransparency = 0.85
                box.Parent = part
                data.boxes[part] = box
            end
            box.Color3 = col
            box.SurfaceColor3 = col
            box.Visible = true
            box.Adornee = part
        end
    end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and Hitbox_IsBodyPart(part) and not seen[part] then
            seen[part] = true
            local box = data.boxes[part]
            if not box or not box.Parent then
                box = Instance.new("SelectionBox")
                box.Name = "AnxiumHitbox"
                box.Adornee = part
                box.LineThickness = 0.025
                box.SurfaceTransparency = 0.85
                box.Parent = part
                data.boxes[part] = box
            end
            box.Color3 = col
            box.SurfaceColor3 = col
            box.Visible = true
            box.Adornee = part
        end
    end
    for part, box in pairs(data.boxes) do
        if not part or not part.Parent or not seen[part] then
            pcall(function() if box then box:Destroy() end end)
            data.boxes[part] = nil
        end
    end
end

Cache.HitboxLastTick = 0
RunService.Heartbeat:Connect(function()
    if not Config.HitboxShow then
        if next(Cache.HitboxData or {}) then
            Hitbox_ClearAll()
        end
        return
    end
    local now = tick()
    if now - (Cache.HitboxLastTick or 0) < 0.08 then return end
    Cache.HitboxLastTick = now
    for _, player in ipairs(CachedPlayerList or Players:GetPlayers()) do
        if player ~= LocalPlayer then
            pcall(Hitbox_ApplyPlayer, player)
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    Hitbox_ClearPlayer(p)
end)


function GetKillerFromHumanoid(humanoid)
    if not humanoid then return nil, nil end
    local tagNames = { "creator", "Creator", "killer", "Killer", "LastHit", "Attacker", "attacker", "DamageTag", "creatorTag" }
    for _, name in ipairs(tagNames) do
        local tag = humanoid:FindFirstChild(name)
        if not tag then
            for _, ch in ipairs(humanoid:GetChildren()) do
                if string.lower(ch.Name) == string.lower(name) then
                    tag = ch
                    break
                end
            end
        end
        if tag then
            local val = nil
            if tag:IsA("ObjectValue") then
                val = tag.Value
            elseif tag:IsA("StringValue") then
                val = tag.Value
            elseif tag:IsA("IntValue") or tag:IsA("NumberValue") then
                val = tag.Value
            end
            if typeof(val) == "Instance" then
                if val:IsA("Player") then
                    return val, val.DisplayName or val.Name
                elseif val:IsA("Model") then
                    local plr = Players:GetPlayerFromCharacter(val)
                    if plr then return plr, plr.DisplayName or plr.Name end
                end
            elseif typeof(val) == "string" and val ~= "" then
                local plr = Players:FindFirstChild(val)
                if plr and plr:IsA("Player") then
                    return plr, plr.DisplayName or plr.Name
                end
                return nil, val
            elseif typeof(val) == "number" then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr.UserId == val then
                        return plr, plr.DisplayName or plr.Name
                    end
                end
            end
        end
    end
    return nil, nil
end

function EnsureKillLogContainer()
    if Cache.KillLogContainer and Cache.KillLogContainer.Parent then
        return Cache.KillLogContainer
    end
    local parent = ScreenGui
    if not parent then
        pcall(function()
            if gethui then parent = gethui() end
        end)
    end
    if not parent then return nil end
    local box = Instance.new("Frame")
    box.Name = "AnxiumKillLogs"
    box.AnchorPoint = Vector2.new(0.5, 1)
    box.Position = UDim2.new(0.5, 0, 1, -28)
    box.Size = UDim2.new(0, 420, 0, 220)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.ZIndex = 50
    box.Parent = parent
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Vertical
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 6)
    lay.Parent = box
    Cache.KillLogContainer = box
    Cache.KillLogOrder = 0
    return box
end

function ShowKillLog(killerName, victimName)
    if not Config or not Config.KillLogsEnabled then return end
    killerName = tostring(killerName or "Unknown")
    victimName = tostring(victimName or "?")
    local box = EnsureKillLogContainer()
    if not box then return end
    Cache.KillLogOrder = (Cache.KillLogOrder or 0) + 1
    local order = Cache.KillLogOrder
    local card = Instance.new("Frame")
    card.Name = "KillLog"
    card.Size = UDim2.new(0, 380, 0, 34)
    card.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
    card.BackgroundTransparency = 0.22
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.ZIndex = 51
    card.Parent = box
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card
    local st = Instance.new("UIStroke")
    st.Color = Theme.Accent or Color3.fromRGB(160, 120, 255)
    st.Thickness = 1
    st.Transparency = 0.45
    st.Parent = card
    pcall(function() TrackThemeAccent(st, "Color") end)
    local icon = Instance.new("ImageLabel")
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.fromOffset(20, 20)
    icon.Position = UDim2.new(0, 10, 0.5, -10)
    icon.Image = "rbxassetid://112102474509324"
    icon.ScaleType = Enum.ScaleType.Fit
    icon.ZIndex = 52
    icon.Parent = card
    local textHolder = Instance.new("Frame")
    textHolder.BackgroundTransparency = 1
    textHolder.Position = UDim2.fromOffset(36, 0)
    textHolder.Size = UDim2.new(1, -46, 1, 0)
    textHolder.ZIndex = 52
    textHolder.Parent = card
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Left
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 5)
    lay.Parent = textHolder
    local accent = Theme.Accent or Color3.fromRGB(160, 120, 255)
    local font = SelectedFont or Enum.Font.GothamBold
    local function makeLabel(txt, col, orderN)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.AutomaticSize = Enum.AutomaticSize.X
        l.Size = UDim2.new(0, 0, 1, 0)
        l.Font = font
        l.TextSize = 13
        l.TextColor3 = col
        l.Text = txt
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.LayoutOrder = orderN
        l.ZIndex = 53
        l.Parent = textHolder
        return l
    end
    local kLbl = makeLabel(killerName, accent, 1)
    pcall(function() TrackThemeAccent(kLbl, "TextColor3") end)
    makeLabel("killed", Color3.fromRGB(200, 200, 210), 2)
    local vLbl = makeLabel(victimName, accent, 3)
    pcall(function() TrackThemeAccent(vLbl, "TextColor3") end)
    card.BackgroundTransparency = 1
    for _, d in ipairs(card:GetDescendants()) do
        if d:IsA("TextLabel") then d.TextTransparency = 1 end
        if d:IsA("ImageLabel") then d.ImageTransparency = 1 end
        if d:IsA("UIStroke") then d.Transparency = 1 end
    end
    pcall(function()
        TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quint), { BackgroundTransparency = 0.22 }):Play()
        for _, d in ipairs(card:GetDescendants()) do
            if d:IsA("TextLabel") then
                TweenService:Create(d, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
            elseif d:IsA("ImageLabel") then
                TweenService:Create(d, TweenInfo.new(0.25), { ImageTransparency = 0 }):Play()
            elseif d:IsA("UIStroke") then
                TweenService:Create(d, TweenInfo.new(0.25), { Transparency = 0.45 }):Play()
            end
        end
    end)
    task.delay(3.2, function()
        if not card or not card.Parent then return end
        pcall(function()
            TweenService:Create(card, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
            for _, d in ipairs(card:GetDescendants()) do
                if d:IsA("TextLabel") then
                    TweenService:Create(d, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
                elseif d:IsA("ImageLabel") then
                    TweenService:Create(d, TweenInfo.new(0.35), { ImageTransparency = 1 }):Play()
                elseif d:IsA("UIStroke") then
                    TweenService:Create(d, TweenInfo.new(0.35), { Transparency = 1 }):Play()
                end
            end
        end)
        task.delay(0.4, function()
            pcall(function() card:Destroy() end)
        end)
    end)
    
    local kids = {}
    for _, ch in ipairs(box:GetChildren()) do
        if ch:IsA("Frame") and ch.Name == "KillLog" then
            kids[#kids + 1] = ch
        end
    end
    table.sort(kids, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
    while #kids > 5 do
        local old = table.remove(kids, 1)
        pcall(function() old:Destroy() end)
    end
end

function ShowHitLog(victimName, bodyPart)
    if not Config or not Config.HitLogsEnabled then return end
    victimName = tostring(victimName or "?")
    bodyPart = tostring(bodyPart or "Body")
    local box = EnsureKillLogContainer()
    if not box then return end
    Cache.KillLogOrder = (Cache.KillLogOrder or 0) + 1
    local order = Cache.KillLogOrder
    local card = Instance.new("Frame")
    card.Name = "HitLog"
    card.Size = UDim2.new(0, 380, 0, 34)
    card.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
    card.BackgroundTransparency = 0.22
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.ZIndex = 51
    card.Parent = box
    local icon = Instance.new("ImageLabel")
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.fromOffset(20, 20)
    icon.Position = UDim2.new(0, 10, 0.5, -10)
    icon.Image = "rbxassetid://112102474509324"
    icon.ScaleType = Enum.ScaleType.Fit
    icon.ZIndex = 52
    icon.Parent = card
    local textHolder = Instance.new("Frame")
    textHolder.BackgroundTransparency = 1
    textHolder.Position = UDim2.fromOffset(36, 0)
    textHolder.Size = UDim2.new(1, -46, 1, 0)
    textHolder.ZIndex = 52
    textHolder.Parent = card
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Left
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 5)
    lay.Parent = textHolder
    local accent = Theme.Accent or Color3.fromRGB(160, 120, 255)
    local font = SelectedFont or Enum.Font.GothamBold
    local function makeLabel(txt, col, orderN)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.AutomaticSize = Enum.AutomaticSize.X
        l.Size = UDim2.new(0, 0, 1, 0)
        l.Font = font
        l.TextSize = 13
        l.TextColor3 = col
        l.Text = txt
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.LayoutOrder = orderN
        l.ZIndex = 53
        l.Parent = textHolder
        return l
    end
    local vLbl = makeLabel(victimName, accent, 1)
    pcall(function() TrackThemeAccent(vLbl, "TextColor3") end)
    makeLabel("hit", Color3.fromRGB(200, 200, 210), 2)
    local pLbl = makeLabel(bodyPart, accent, 3)
    pcall(function() TrackThemeAccent(pLbl, "TextColor3") end)
    card.BackgroundTransparency = 1
    for _, d in ipairs(card:GetDescendants()) do
        if d:IsA("TextLabel") then d.TextTransparency = 1 end
        if d:IsA("ImageLabel") then d.ImageTransparency = 1 end
    end
    pcall(function()
        TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quint), { BackgroundTransparency = 0.22 }):Play()
        for _, d in ipairs(card:GetDescendants()) do
            if d:IsA("TextLabel") then
                TweenService:Create(d, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
            elseif d:IsA("ImageLabel") then
                TweenService:Create(d, TweenInfo.new(0.25), { ImageTransparency = 0 }):Play()
            end
        end
    end)
    task.delay(2.6, function()
        if not card or not card.Parent then return end
        pcall(function()
            TweenService:Create(card, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
            for _, d in ipairs(card:GetDescendants()) do
                if d:IsA("TextLabel") then
                    TweenService:Create(d, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
                elseif d:IsA("ImageLabel") then
                    TweenService:Create(d, TweenInfo.new(0.35), { ImageTransparency = 1 }):Play()
                end
            end
        end)
        task.delay(0.4, function()
            if card and card.Parent then
                card:Destroy()
            end
        end)
    end)
end



function SpawnKillLightning(atPos)
    if not atPos then return end
    local col = Config.Color_KillLightning or Color3.fromRGB(255, 255, 255)
    local scale = math.clamp(tonumber(Config.KillLightningSize) or 1.5, 0.4, 4)
    local life = math.clamp(tonumber(Config.KillLightningDuration) or 0.55, 0.1, 3)
    local folder = Workspace:FindFirstChild("AnxiumKillLightning")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "AnxiumKillLightning"
        folder.Parent = Workspace
    end
    local model = Instance.new("Model")
    model.Name = "Lightning"
    model.Parent = folder

    local segments = math.clamp(math.floor(8 + scale * 3), 8, 16)
    local height = (12 + scale * 8)
    local seed = tick() * 17
    local origin = Vector3.new(atPos.X, atPos.Y, atPos.Z)
    local points = table.create(segments + 1)
    for i = 0, segments do
        local t0 = i / segments
        local y = origin.Y + t0 * height
        local spread = (t0 * t0) * 1.35 * scale
        local ox, oz = 0, 0
        if i > 0 then
            ox = math.noise(seed, i * 0.55) * spread * 2.0
            oz = math.noise(seed + 3.1, i * 0.55) * spread * 2.0
            ox = ox + ((i % 2 == 0) and 0.55 or -0.55) * spread
            oz = oz + ((i % 3 == 0) and -0.4 or 0.4) * spread
        end
        points[i + 1] = Vector3.new(origin.X + ox, y, origin.Z + oz)
    end

    local parts = {}
    for i = 1, segments do
        local a, b = points[i], points[i + 1]
        local mid = (a + b) * 0.5
        local dist = (b - a).Magnitude
        local part = Instance.new("Part")
        part.Name = "Bolt"
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.CastShadow = false
        part.Material = Enum.Material.Neon
        part.Color = col
        local thick = (0.10 + (i % 2) * 0.04) * math.clamp(scale * 0.85, 0.5, 2.2)
        part.Size = Vector3.new(thick, thick, math.max(0.15, dist))
        part.CFrame = CFrame.lookAt(mid, b)
        part.Transparency = 0.05
        part.Parent = model
        parts[#parts + 1] = part

        if i % 3 == 0 and i < segments then
            local branchDir = Vector3.new(math.noise(seed, i + 9), 0.35, math.noise(seed, i + 14))
            if branchDir.Magnitude < 0.05 then branchDir = Vector3.new(1, 0.3, 0) end
            branchDir = branchDir.Unit
            local bEnd = mid + branchDir * ((0.9 + math.random() * 1.1) * scale) + Vector3.new(0, 0.5 * scale, 0)
            local bMid = (mid + bEnd) * 0.5
            local bDist = (bEnd - mid).Magnitude
            local branch = Instance.new("Part")
            branch.Anchored = true
            branch.CanCollide = false
            branch.CanQuery = false
            branch.CanTouch = false
            branch.CastShadow = false
            branch.Material = Enum.Material.Neon
            branch.Color = col
            local bt = 0.08 * math.clamp(scale * 0.85, 0.5, 2)
            branch.Size = Vector3.new(bt, bt, math.max(0.1, bDist))
            branch.CFrame = CFrame.lookAt(bMid, bEnd)
            branch.Transparency = 0.15
            branch.Parent = model
            parts[#parts + 1] = branch
        end
    end

    local ti = TweenInfo.new(life, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _, p in ipairs(parts) do
        TweenService:Create(p, ti, { Transparency = 1 }):Play()
    end
    task.delay(life + 0.1, function()
        if model and model.Parent then model:Destroy() end
    end)
end

function OnVictimDied(victimPlayer, humanoid)
    if not victimPlayer or victimPlayer == LocalPlayer then return end
    local key = humanoid or victimPlayer
    if Cache.KillHandledHum[key] then return end
    Cache.KillHandledHum[key] = true

    local function onMyKill()
        pcall(TryPlayKillSound, victimPlayer)
        pcall(function()
            if Config and Config.KillFlashEnabled and TriggerKillFlash then
                TriggerKillFlash(Config.Color_KillFlash)
            end
        end)
        pcall(function()
            if Config and Config.KillLightningEnabled and SpawnKillLightning then
                local char = victimPlayer.Character
                local head = char and char:FindFirstChild("Head")
                local pos = nil
                if head then
                    pos = head.Position + Vector3.new(0, head.Size.Y * 0.5, 0)
                else
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    pos = hrp and (hrp.Position + Vector3.new(0, 2.2, 0)) or nil
                end
                if not pos and humanoid and typeof(humanoid) == "Instance" then
                    local root = humanoid.RootPart or (humanoid.Parent and humanoid.Parent:FindFirstChild("HumanoidRootPart"))
                    pos = root and (root.Position + Vector3.new(0, 2.2, 0)) or nil
                end
                if pos then SpawnKillLightning(pos) end
            end
        end)
    end

    task.delay(0.1, function()
        local killerName = nil
        if humanoid and typeof(humanoid) == "Instance" and humanoid:IsA("Humanoid") then
            local _, kn = GetKillerFromHumanoid(humanoid)
            killerName = kn
            if not killerName then
                local isK = IsLocalPlayerKiller(humanoid)
                if isK then
                    killerName = LocalPlayer.DisplayName or LocalPlayer.Name
                end
            end
        end
        local now = tick()
        local recentShot = (now - (Cache.LastShotTime or 0)) < 3.5
        local recentHit = Cache.RecentDamageTargets
            and Cache.RecentDamageTargets[victimPlayer]
            and (now - Cache.RecentDamageTargets[victimPlayer]) < 3.5
        local aimed = Cache.LastShotTarget == victimPlayer
            or Cache.AimLockTarget == victimPlayer
            or Cache.SilentV2Target == victimPlayer
        if not killerName and (recentHit or (recentShot and aimed)) then
            killerName = LocalPlayer.DisplayName or LocalPlayer.Name
        end

        if Config.KillLogsEnabled and killerName then
            local vName = victimPlayer.DisplayName or victimPlayer.Name
            pcall(ShowKillLog, killerName, vName)
        end

        local isKiller = false
        local enemyTag = false
        if humanoid and typeof(humanoid) == "Instance" and humanoid:IsA("Humanoid") then
            isKiller, enemyTag = IsLocalPlayerKiller(humanoid)
        end
        if isKiller then
            onMyKill()
            return
        end
        if enemyTag then return end
        if recentHit or (recentShot and aimed) then
            onMyKill()
        end
    end)
end

function UnhookHumanoid(hum)
    local list = Cache.KillHumConnections[hum]
    if list then
        for _, c in ipairs(list) do
            pcall(function() c:Disconnect() end)
        end
        Cache.KillHumConnections[hum] = nil
    end
end

function HookPlayerForKillSound(player)
    if player == LocalPlayer then return end
    if Cache.KillHooked[player] then return end
    Cache.KillHooked[player] = true

    local function hookChar(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
        if not hum then return end

        UnhookHumanoid(hum)
        Cache.KillHandledHum[hum] = nil

        local conns = {}
        conns[#conns + 1] = hum.Died:Connect(function()
            OnVictimDied(player, hum)
        end)

        local lastHp = hum.Health
        conns[#conns + 1] = hum.HealthChanged:Connect(function(hp)
            if lastHp > 0 and hp < lastHp then
                local now = tick()
                local recentT = Cache.RecentDamageTargets and Cache.RecentDamageTargets[player]
                local shotOk = (Cache.LastShotTime and (now - Cache.LastShotTime) < 1.25) or (recentT and (now - recentT) < 1.5)
                if shotOk and Config and Config.HitLogsEnabled then
                    local part = "Body"
                    local hitPartFresh = Cache.LastHitPartPlayer == player
                        and Cache.LastHitPartName and Cache.LastHitPartTime
                        and (now - Cache.LastHitPartTime) < 1.5
                    if hitPartFresh then
                        part = Cache.LastHitPartName
                    elseif Cache.SilentV2Target == player and Cache.SilentV2Part
                        and Cache.LastShotTime and (now - Cache.LastShotTime) < 1.25 then
                        part = NormalizeHitPartName(Cache.SilentV2Part)
                    else
                        local p = CaptureCrosshairHitPart and CaptureCrosshairHitPart(player)
                        if p then part = p end
                    end
                    local cdKey = tostring(player.UserId) .. ":" .. tostring(part)
                    Cache.HitLogCooldown = Cache.HitLogCooldown or {}
                    if (Cache.HitLogCooldown[cdKey] or 0) + 0.12 < now then
                        Cache.HitLogCooldown[cdKey] = now
                        pcall(ShowHitLog, player.DisplayName or player.Name, part)
                    end
                end
            end
            if lastHp > 0 and hp <= 0 then
                OnVictimDied(player, hum)
            end
            lastHp = hp
        end)

        conns[#conns + 1] = char.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                UnhookHumanoid(hum)
            end
        end)

        Cache.KillHumConnections[hum] = conns
    end

    if player.Character then
        task.spawn(hookChar, player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        task.delay(0.25, function()
            if player.Character == char then
                hookChar(char)
            end
        end)
    end)
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Cache.LastShotTime = tick()
        local target = CaptureCrosshairTarget()
        if target then
            pcall(SpawnImmediateHitMarkerFromTarget, target)
        end
    end
end)


function HookLocalTools(char)
    if not char then return end
    local function onTool(tool)
        if not tool:IsA("Tool") then return end
        tool.Activated:Connect(function()
            Cache.LastShotTime = tick()
            local target = CaptureCrosshairTarget()
            if target then
                pcall(SpawnImmediateHitMarkerFromTarget, target)
            end
            FireBulletTracer()
        end)
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") then onTool(ch) end
    end
    char.ChildAdded:Connect(function(ch)
        if ch:IsA("Tool") then
            task.defer(function() onTool(ch) end)
        end
    end)
end
if LocalPlayer.Character then task.spawn(HookLocalTools, LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char)
    task.defer(function() HookLocalTools(char) end)
end)

for _, p in ipairs((CachedPlayerList or Players:GetPlayers())) do
    task.spawn(HookPlayerForKillSound, p)
end
Players.PlayerAdded:Connect(HookPlayerForKillSound)
Players.PlayerRemoving:Connect(function(p)
    Cache.KillHooked[p] = nil
    Cache.KillSoundPlayedFor[p] = nil
    Cache.RecentDamageTargets[p] = nil
    if Cache.LastShotTarget == p then Cache.LastShotTarget = nil end
end)

task.spawn(function()
    local hasWrite = typeof(writefile) == "function"
    local hasGetCustom = typeof(getcustomasset) == "function"

    if not hasWrite or not hasGetCustom then return end

    local hasIsfile = typeof(isfile) == "function"
    local loaded = 0
    local downloaded = 0

    for name, data in pairs(FIRE_SOUND_FILES) do
        local alreadyOnDisk = false
        if hasIsfile then
            pcall(function() alreadyOnDisk = isfile(data.file) end)
        end

        if alreadyOnDisk then
            local okAsset, asset = pcall(function() return getcustomasset(data.file) end)
            if okAsset and asset then
                Cache.FireSoundAssets[name] = asset
                loaded = loaded + 1
            end
        else
            local okHttp, body = pcall(function() return game:HttpGet(data.url) end)
            if okHttp and body and #body > 0 then
                if pcall(writefile, data.file, body) then
                    local okAsset, asset = pcall(function() return getcustomasset(data.file) end)
                    if okAsset and asset then
                        Cache.FireSoundAssets[name] = asset
                        loaded = loaded + 1
                        downloaded = downloaded + 1
                    end
                end
            end
        end
    end

    if loaded > 0 then
        Cache.FireSoundsReady = true
    end
end)


function _reg(key, fn)
    if Cache and Cache.BindToggles then Cache.BindToggles[key] = fn end
end

pcall(function()
    Cache.FeatureUI = Cache.FeatureUI or {}
    local map = {
        AimEnabled = { AimBg, AimKnob },
        AimWallCheck = { AimWallBg, AimWallKnob },
        TriggerbotEnabled = { TriggerbotBg, TriggerbotKnob },
        BoxEspEnabled = { BoxEspBg, BoxEspKnob },
        BoxFillGradientEnabled = { BoxFillBg, BoxFillKnob },
        ChamsEnabled = { ChamsBg, ChamsKnob },
        NameEspEnabled = { NameEspBg, NameEspKnob },
        HealthbarEspEnabled = { HealthbarEspBg, HealthbarEspKnob },
        CameraFovEnabled = { CameraFovBg, CameraFovKnob },
        FpsBoostEnabled = { FpsBoostBg, FpsBoostKnob },
        FullbrightEnabled = { FullBg, FullKnob },

        TeamCheckerEnabled = { TeamCheckerBg, TeamCheckerKnob },
        TeamEspEnabled = { TeamEspBg, TeamEspKnob },
        ThirdPersonEnabled = { ThirdPersonBg, ThirdPersonKnob },
        ForceFieldEnabled = { FFBg, FFKnob },
        BulletTracersEnabled = { BulletTracerBg, BulletTracerKnob },
        AutowallEnabled = { AutowallBg, AutowallKnob },
        AutowallShowInfo = { AutowallInfoBg, AutowallInfoKnob },
        HitboxShow = { HitboxShowBg, HitboxShowKnob },
        SpeedHackEnabled = { SpeedBg, SpeedKnob },
        FlyEnabled = { FlyBg, FlyKnob },
        NoclipEnabled = { NoclipBg, NoclipKnob },
        BHopEnabled = { BHopBg, BHopKnob },
        CrosshairEnabled = { CrossBg, CrossKnob },
        ScopeEnabled = { ScopeBg, ScopeKnob },
        ScopeGradientEnabled = { ScopeGradBg, ScopeGradKnob },
        ScopeDynamicEnabled = { ScopeDynBg, ScopeDynKnob },
        FovDynamicEnabled = { FovDynBg, FovDynKnob },
        SilentV2FovDynamicEnabled = { SilentFovDynBg, SilentFovDynKnob },
        ShowFovEnabled = { ShowFovBg, ShowFovKnob },
        FovFillEnabled = { FovFillBg, FovFillKnob },
        SpinEnabled = { SpinBg, SpinKnob },
        AntiAimEnabled = { AntiAimBg, AntiAimKnob },
        AntiAimResolveEnabled = { AntiAimResolveBg, AntiAimResolveKnob },
        TargetHudEnabled = { TargetHudBg, TargetHudKnob },
        TargetLineEnabled = { TargetLineBg, TargetLineKnob },
        TargetLineVisibleCheck = { TargetLineVisBg, TargetLineVisKnob },
        FogEnabled = { FogBg, FogKnob },
        NoFogEnabled = { NoFogBg, NoFogKnob },
        SelfTransparencyEnabled = { SelfTransBg, SelfTransKnob },
        DayCycleEnabled = { DayCycleBg, DayCycleKnob },
        TrailEnabled = { TrailBg, TrailKnob },
        ChinaHatEnabled = { HatBg, HatKnob },
        AngelHaloEnabled = { AngelHaloBg, AngelHaloKnob },
        FakeLagEnabled = { FakeLagBg, FakeLagKnob },
        WeaponAutoSwapEnabled = { WeaponAutoSwapBg, WeaponAutoSwapKnob },
        AutoShiftEnabled = { AutoShiftBg, AutoShiftKnob },
        PeekAssistFillEnabled = { PeekAssistFillBg, PeekAssistFillKnob },
        FakeLagRandomize = { FakeLagRandBg, FakeLagRandKnob },
        OrbitOrbsEnabled = { OrbitOrbsBg, OrbitOrbsKnob },
        SkeletonEnabled = { SkelBg, SkelKnob },
        TracersEnabled = { TracerBg, TracerKnob },
        TracerGradientEnabled = { TracerGradBg, TracerGradKnob },
        DistanceEspEnabled = { DistEspBg, DistEspKnob },
        MultiJumpEnabled = { JumpBg, JumpKnob },
        AutoJumpEnabled = { AutoJumpBg, AutoJumpKnob },
        WeaponForceFieldEnabled = { WeaponFFBg, WeaponFFKnob },
        ActiveListEnabled = { ActiveListBg, ActiveListKnob },
        BindListEnabled = { BindListBg, BindListKnob },
        FakeFpsEnabled = { FakeFpsBg, FakeFpsKnob },
        CustomFireSoundEnabled = { FireSoundBg, FireSoundKnob },
        AspectRatioEnabled = { AspectBg, AspectKnob },
        FootstepsEnabled = { FootstepsBg, FootstepsKnob },
        DarkModeEnabled = { DarkModeBg, DarkModeKnob },
        AuraEnabled = { AuraBg, AuraKnob },
    }
    for k, v in pairs(map) do
        if v[1] and v[2] then
            Cache.FeatureUI[k] = { bg = v[1], knob = v[2] }
        end
    end
end)
pcall(function()
    _reg("TeamCheckerEnabled", function()
        Config.TeamCheckerEnabled = not Config.TeamCheckerEnabled
        UpdateSwitch(Config.TeamCheckerEnabled, TeamCheckerBg, TeamCheckerKnob, "Team Checker")
        Cache.TeamCache = {}
        pcall(function()
            if RefreshTeamIgnoreVisuals then RefreshTeamIgnoreVisuals() end
        end)
    end)
    _reg("AimEnabled", function()
        Config.AimEnabled = not Config.AimEnabled
        UpdateSwitch(Config.AimEnabled, AimBg, AimKnob, "Aimbot")
    end)
    _reg("AimWallCheck", function()
        Config.AimWallCheck = not Config.AimWallCheck
        if AimWallBg then UpdateSwitch(Config.AimWallCheck, AimWallBg, AimWallKnob, "Aim Wall Check") end
    end)
    _reg("ShowFovEnabled", function()
        Config.ShowFovEnabled = not Config.ShowFovEnabled
        UpdateSwitch(Config.ShowFovEnabled, ShowFovBg, ShowFovKnob, "Show FOV")
    end)
    _reg("WeaponAutoSwapEnabled", function()
        Config.WeaponAutoSwapEnabled = not Config.WeaponAutoSwapEnabled
        if WeaponAutoSwapBg then UpdateSwitch(Config.WeaponAutoSwapEnabled, WeaponAutoSwapBg, WeaponAutoSwapKnob, "Weapon Auto Swap") end
        WeaponAutoSwap_Apply()
    end)
    _reg("TriggerbotEnabled", function()
        Config.TriggerbotEnabled = not Config.TriggerbotEnabled
        UpdateSwitch(Config.TriggerbotEnabled, TriggerbotBg, TriggerbotKnob, "Triggerbot")
    end)
    _reg("TargetLineEnabled", function()
        Config.TargetLineEnabled = not Config.TargetLineEnabled
        if TargetLineBg then UpdateSwitch(Config.TargetLineEnabled, TargetLineBg, TargetLineKnob, "Target Line") end
        if not Config.TargetLineEnabled then TargetLine_Hide() end
    end)
    _reg("TargetHudEnabled", function()
        Config.TargetHudEnabled = not Config.TargetHudEnabled
        UpdateSwitch(Config.TargetHudEnabled, TargetHudBg, TargetHudKnob, "Target HUD")
    end)
    _reg("SpinEnabled", function()
        Config.SpinEnabled = not Config.SpinEnabled
        UpdateSwitch(Config.SpinEnabled, SpinBg, SpinKnob, "SpinBot")
    end)
    _reg("AntiAimEnabled", function()
        Config.AntiAimEnabled = not Config.AntiAimEnabled
        UpdateSwitch(Config.AntiAimEnabled, AntiAimBg, AntiAimKnob, "Anti-Aim")
        if not Config.AntiAimEnabled then
            pcall(AntiAim_RestoreMotors)
        else
            Cache.AntiAimMotorBases = {}
            Cache.AntiAimSpinAngle = 0
        end
    end)
    _reg("BoxEspEnabled", function()
        Config.BoxEspEnabled = not Config.BoxEspEnabled
        UpdateSwitch(Config.BoxEspEnabled, BoxEspBg, BoxEspKnob, "2D Box ESP")
    end)
    _reg("BoxFillGradientEnabled", function()
        Config.BoxFillGradientEnabled = not Config.BoxFillGradientEnabled
        UpdateSwitch(Config.BoxFillGradientEnabled, BoxFillBg, BoxFillKnob, "Box Fill Gradient")
    end)
    _reg("HealthbarEspEnabled", function()
        Config.HealthbarEspEnabled = not Config.HealthbarEspEnabled
        UpdateSwitch(Config.HealthbarEspEnabled, HealthbarEspBg, HealthbarEspKnob, "Healthbar ESP")
    end)
    _reg("ChamsEnabled", function()
        Config.ChamsEnabled = not Config.ChamsEnabled
        UpdateSwitch(Config.ChamsEnabled, ChamsBg, ChamsKnob, "Chams")
    end)
    _reg("NameEspEnabled", function()
        Config.NameEspEnabled = not Config.NameEspEnabled
        UpdateSwitch(Config.NameEspEnabled, NameEspBg, NameEspKnob, "Name ESP")
    end)
    _reg("DistanceEspEnabled", function()
        Config.DistanceEspEnabled = not Config.DistanceEspEnabled
        UpdateSwitch(Config.DistanceEspEnabled, DistEspBg, DistEspKnob, "Distance ESP")
    end)
    _reg("SkeletonEnabled", function()
        Config.SkeletonEnabled = not Config.SkeletonEnabled
        UpdateSwitch(Config.SkeletonEnabled, SkelBg, SkelKnob, "Skeleton ESP")
    end)
    _reg("TracersEnabled", function()
        Config.TracersEnabled = not Config.TracersEnabled
        UpdateSwitch(Config.TracersEnabled, TracerBg, TracerKnob, "Tracers")
    end)
    _reg("PeekAssistFillEnabled", function()
        Config.PeekAssistFillEnabled = not Config.PeekAssistFillEnabled
        UpdateSwitch(Config.PeekAssistFillEnabled, PeekAssistFillBg, PeekAssistFillKnob, "Peek Assist Fill")
    end)
    _reg(function()
        Config.ScopeEnabled = not Config.ScopeEnabled
        UpdateSwitch(Config.ScopeEnabled, ScopeBg, ScopeKnob, "Sniper Scope")
        if not Config.ScopeEnabled then
            pcall(function() if Scope_Hide then Scope_Hide() end end)
        end
    end)
    _reg("CrosshairEnabled", function()
        Config.CrosshairEnabled = not Config.CrosshairEnabled
        UpdateSwitch(Config.CrosshairEnabled, CrossBg, CrossKnob, "Crosshair")
        pcall(function()
            UserInputService.MouseIconEnabled = not (Config.CrosshairEnabled or Config.SpinCrosshairEnabled)
        end)
    end)
    _reg("SpinCrosshairEnabled", function()
        Config.SpinCrosshairEnabled = not Config.SpinCrosshairEnabled
        UpdateSwitch(Config.SpinCrosshairEnabled, SpinCrossBg, SpinCrossKnob, "Spin Crosshair")
        pcall(function()
            UserInputService.MouseIconEnabled = not (Config.CrosshairEnabled or Config.SpinCrosshairEnabled)
        end)
    end)
    _reg("DamageNumbersEnabled", function()
        Config.DamageNumbersEnabled = not Config.DamageNumbersEnabled
        UpdateSwitch(Config.DamageNumbersEnabled, DmgNumBg, DmgNumKnob, "Damage Numbers")
    end)
    _reg("SelfChamsEnabled", function()
        Config.SelfChamsEnabled = not Config.SelfChamsEnabled
        UpdateSwitch(Config.SelfChamsEnabled, SelfChamsBg, SelfChamsKnob, "Self Chams")
    end)
    _reg("CloneChamsEnabled", function()
        Config.CloneChamsEnabled = not Config.CloneChamsEnabled
        UpdateSwitch(Config.CloneChamsEnabled, CloneChamsBg, CloneChamsKnob, "Clone player")
    end)
    _reg("OffscreenArrowsEnabled", function()
        Config.OffscreenArrowsEnabled = not Config.OffscreenArrowsEnabled
        UpdateSwitch(Config.OffscreenArrowsEnabled, OffscreenBg, OffscreenKnob, "Offscreen Arrows")
        if not Config.OffscreenArrowsEnabled and UV_ClearArrows then UV_ClearArrows() end
    end)
    _reg("DeathChamsEnabled", function()
        Config.DeathChamsEnabled = not Config.DeathChamsEnabled
        UpdateSwitch(Config.DeathChamsEnabled, DeathChamsBg, DeathChamsKnob, "Death player")
    end)
    _reg("DeathBurstEnabled", function()
        Config.DeathBurstEnabled = not Config.DeathBurstEnabled
        UpdateSwitch(Config.DeathBurstEnabled, DeathBurstBg, DeathBurstKnob, "Death Burst")
    end)
    _reg("KillDissolveEnabled", function()
        Config.KillDissolveEnabled = not Config.KillDissolveEnabled
        UpdateSwitch(Config.KillDissolveEnabled, KillDissolveBg, KillDissolveKnob, "Kill Dissolve")
    end)
    _reg("CameraFovEnabled", function()
        Config.CameraFovEnabled = not Config.CameraFovEnabled
        if CameraFovBg then UpdateSwitch(Config.CameraFovEnabled, CameraFovBg, CameraFovKnob, "Camera FOV") end
        CameraFov_Apply()
    end)
    _reg("FpsBoostEnabled", function()
        Config.FpsBoostEnabled = not Config.FpsBoostEnabled
        if FpsBoostBg then UpdateSwitch(Config.FpsBoostEnabled, FpsBoostBg, FpsBoostKnob, "FPS Boost") end
        FpsBoost_Apply()
    end)
    _reg("FullbrightEnabled", function()
        Config.FullbrightEnabled = not Config.FullbrightEnabled
        UpdateSwitch(Config.FullbrightEnabled, FullBg, FullKnob, "Fullbright")
    end)
    _reg("DarkModeEnabled", function()
        Config.DarkModeEnabled = not Config.DarkModeEnabled
        UpdateSwitch(Config.DarkModeEnabled, DarkModeBg, DarkModeKnob, "Dark Mode")
    end)
    _reg("AngelHaloEnabled", function()
        Config.AngelHaloEnabled = not Config.AngelHaloEnabled
        UpdateSwitch(Config.AngelHaloEnabled, AngelHaloBg, AngelHaloKnob, "Angel Halo")
        if not Config.AngelHaloEnabled then pcall(AngelHalo_Hide) end
    end)
    _reg("ChinaHatEnabled", function()
        Config.ChinaHatEnabled = not Config.ChinaHatEnabled
        UpdateSwitch(Config.ChinaHatEnabled, HatBg, HatKnob, "China Hat")
        ChinaHat_ApplyStyle()
    end)
    _reg("TargetMarkerEnabled", function()
        Config.TargetMarkerEnabled = not Config.TargetMarkerEnabled
        UpdateSwitch(Config.TargetMarkerEnabled, TargetMarkerBg, TargetMarkerKnob, "Target Marker")
        if not Config.TargetMarkerEnabled and TargetMarker_Hide then pcall(TargetMarker_Hide) end
    end)
    _reg("OrbitOrbsEnabled", function()
        Config.OrbitOrbsEnabled = not Config.OrbitOrbsEnabled
        UpdateSwitch(Config.OrbitOrbsEnabled, OrbitOrbsBg, OrbitOrbsKnob, "Neon Orbit")
    end)
    _reg("TrailEnabled", function()
        Config.TrailEnabled = not Config.TrailEnabled
        UpdateSwitch(Config.TrailEnabled, TrailBg, TrailKnob, "Motion Trail")
    end)
    _reg("FogEnabled", function()
        Config.FogEnabled = not Config.FogEnabled
        UpdateSwitch(Config.FogEnabled, FogBg, FogKnob, "Custom Fog")
    end)
    _reg("FootstepsEnabled", function()
        Config.FootstepsEnabled = not Config.FootstepsEnabled
        UpdateSwitch(Config.FootstepsEnabled, FootstepsBg, FootstepsKnob, "Jump Circles")
    end)
    _reg("AspectRatioEnabled", function()
        Config.AspectRatioEnabled = not Config.AspectRatioEnabled
        UpdateSwitch(Config.AspectRatioEnabled, AspectBg, AspectKnob, "Aspect Ratio")
    end)
    _reg("ThirdPersonEnabled", function()
        Config.ThirdPersonEnabled = not Config.ThirdPersonEnabled
        UpdateSwitch(Config.ThirdPersonEnabled, ThirdPersonBg, ThirdPersonKnob, "Third Person")
        pcall(function()
            if Config.ThirdPersonEnabled then
                if ThirdPerson_Enable then ThirdPerson_Enable() end
            else
                if ThirdPerson_Disable then ThirdPerson_Disable() end
            end
        end)
    end)
    _reg("ForceFieldEnabled", function()
        Config.ForceFieldEnabled = not Config.ForceFieldEnabled
        UpdateSwitch(Config.ForceFieldEnabled, FFBg, FFKnob, "Self ForceField")
        pcall(function()
            if SetForceFieldEnabled then SetForceFieldEnabled(Config.ForceFieldEnabled)
            elseif ApplyForceField then ApplyForceField(Config.ForceFieldEnabled) end
        end)
    end)
    _reg("WeaponForceFieldEnabled", function()
        Config.WeaponForceFieldEnabled = not Config.WeaponForceFieldEnabled
        UpdateSwitch(Config.WeaponForceFieldEnabled, WeaponFFBg, WeaponFFKnob, "Weapon ForceField")
    end)
    _reg("KillLogsEnabled", function()
        Config.KillLogsEnabled = not Config.KillLogsEnabled
        UpdateSwitch(Config.KillLogsEnabled, KillLogsBg, KillLogsKnob, "Kill Logs")
    end)
    _reg("KillFlashEnabled", function()
        Config.KillFlashEnabled = not Config.KillFlashEnabled
        UpdateSwitch(Config.KillFlashEnabled, KillFlashBg, KillFlashKnob, "Kill Flash")
    end)
    _reg("KillLightningEnabled", function()
        Config.KillLightningEnabled = not Config.KillLightningEnabled
        UpdateSwitch(Config.KillLightningEnabled, KillLightningBg, KillLightningKnob, "Kill Lightning")
    end)
    _reg("HitboxShow", function()
        Config.HitboxShow = not Config.HitboxShow
        UpdateSwitch(Config.HitboxShow, HitboxShowBg, HitboxShowKnob, "Show Hitboxes")
        if not Config.HitboxShow and Hitbox_ClearAll then Hitbox_ClearAll() end
    end)
    _reg("AutowallEnabled", function()
        Config.AutowallEnabled = not Config.AutowallEnabled
        if AutowallBg then UpdateSwitch(Config.AutowallEnabled, AutowallBg, AutowallKnob, "Autowall") end
        if Cache.AutowallSetEnabled then Cache.AutowallSetEnabled(Config.AutowallEnabled) end
    end)
    _reg("BulletTracersEnabled", function()
        Config.BulletTracersEnabled = not Config.BulletTracersEnabled
        UpdateSwitch(Config.BulletTracersEnabled, BulletTracerBg, BulletTracerKnob, "Bullet Tracers")
    end)
    _reg("AuraEnabled", function()
        Config.AuraEnabled = not Config.AuraEnabled
        UpdateSwitch(Config.AuraEnabled, AuraBg, AuraKnob, "Aura")
    end)
    _reg("ClassicPinkEnabled", function()
        Config.ClassicPinkEnabled = not Config.ClassicPinkEnabled
        UpdateSwitch(Config.ClassicPinkEnabled, ClassicPinkBg, ClassicPinkKnob, "Pink Aura")
    end)
    _reg("ClassicAngelEnabled", function()
        Config.ClassicAngelEnabled = not Config.ClassicAngelEnabled
        UpdateSwitch(Config.ClassicAngelEnabled, ClassicAngelBg, ClassicAngelKnob, "Angel Wing")
    end)
    _reg("SpeedHackEnabled", function()
        Config.SpeedHackEnabled = not Config.SpeedHackEnabled
        UpdateSwitch(Config.SpeedHackEnabled, SpeedBg, SpeedKnob, "Speed Hack")
    end)
    _reg("AutoJumpEnabled", function()
        Config.AutoJumpEnabled = not Config.AutoJumpEnabled
        UpdateSwitch(Config.AutoJumpEnabled, AutoJumpBg, AutoJumpKnob, "Auto Jump")
    end)
    _reg("MultiJumpEnabled", function()
        Config.MultiJumpEnabled = not Config.MultiJumpEnabled
        UpdateSwitch(Config.MultiJumpEnabled, JumpBg, JumpKnob, "Double Jump")
    end)
    _reg("NoclipEnabled", function()
        Config.NoclipEnabled = not Config.NoclipEnabled
        UpdateSwitch(Config.NoclipEnabled, NoclipBg, NoclipKnob, "Noclip")
    end)
    _reg("FakeLagEnabled", function()
        Config.FakeLagEnabled = not Config.FakeLagEnabled
        if FakeLagBg then UpdateSwitch(Config.FakeLagEnabled, FakeLagBg, FakeLagKnob, "Fake Lag") end
        if Config.FakeLagEnabled then FakeLag_Start() else FakeLag_Stop() end
    end)
    _reg("FlyEnabled", function()
        Config.FlyEnabled = not Config.FlyEnabled
        UpdateSwitch(Config.FlyEnabled, FlyBg, FlyKnob, "Fly")
        if not Config.FlyEnabled and FlyV3_Stop then pcall(FlyV3_Stop) end
    end)
    _reg("BHopEnabled", function()
        Config.BHopEnabled = not Config.BHopEnabled
        UpdateSwitch(Config.BHopEnabled, BHopBg, BHopKnob, "Bunny Hop")
    end)
        _reg("AutoShiftEnabled", function()
        Config.AutoShiftEnabled = not Config.AutoShiftEnabled
        if AutoShiftBg then UpdateSwitch(Config.AutoShiftEnabled, AutoShiftBg, AutoShiftKnob, "Auto Shift") end
        AutoShift_Apply()
    end)
    _reg("StrafeEnabled", function()
        Config.StrafeEnabled = not Config.StrafeEnabled
        if StrafeBg then UpdateSwitch(Config.StrafeEnabled, StrafeBg, StrafeKnob, "Strafe") end
    end)
_reg("CustomFireSoundEnabled", function()
        Config.CustomFireSoundEnabled = not Config.CustomFireSoundEnabled
        UpdateSwitch(Config.CustomFireSoundEnabled, FireSoundBg, FireSoundKnob, "Kill Sounds")
    end)
    _reg("ActiveListEnabled", function()
        Config.ActiveListEnabled = not Config.ActiveListEnabled
        UpdateSwitch(Config.ActiveListEnabled, ActiveListBg, ActiveListKnob, "Active Modules HUD")
    end)
    _reg("BindListEnabled", function()
        Config.BindListEnabled = not Config.BindListEnabled
        if BindListBg then UpdateSwitch(Config.BindListEnabled, BindListBg, BindListKnob, "Binds HUD") end
        if UpdateBindList then UpdateBindList() end
    end)
    _reg("FakeFpsEnabled", function()
        Config.FakeFpsEnabled = not Config.FakeFpsEnabled
        UpdateSwitch(Config.FakeFpsEnabled, FakeFpsBg, FakeFpsKnob, "Fake FPS")
        if UpdateFakeFpsDisplay then UpdateFakeFpsDisplay() end
    end)
end)
if UpdateBindList then UpdateBindList() end




task.defer(function()
    task.wait(0.5)
    pcall(function()
        if Config.TeamCheckerEnabled and RefreshTeamIgnoreVisuals then
            RefreshTeamIgnoreVisuals()
        end
    end)
end)


;(function()
    local DrawingLib = Drawing
    Cache.SilentV2Target = nil
    Cache.SilentV2Part = nil
    Cache.SilentV2Pos = nil

    if DrawingLib then
        local c = DrawingLib.new("Circle")
        c.Thickness = 1
        c.NumSides = 96
        c.Radius = Config.SilentV2Fov or 140
        c.Filled = false
        c.Color = Config.Color_SilentV2Fov or Color3.fromRGB(120, 200, 255)
        c.Visible = false
        c.ZIndex = 3
        Cache.SilentV2FovCircle = c
        local cf = DrawingLib.new("Circle")
        cf.Thickness = 0
        cf.NumSides = 96
        cf.Radius = Config.SilentV2Fov or 140
        cf.Filled = true
        cf.Color = Config.Color_SilentV2FovFill or Color3.fromRGB(120, 200, 255)
        cf.Transparency = Config.SilentV2FovFillTransparency or 0.7
        cf.Visible = false
        cf.ZIndex = 2
        Cache.SilentV2FovCircleFill = cf
    end

    local function Chance(pct)
        pct = tonumber(pct) or 100
        if pct >= 100 then return true end
        if pct <= 0 then return false end
        return math.random(1, 100) <= pct
    end

    local function GetRoot(char)
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    end

    local function GetTargetPart(char)
        if not char then return nil end
        local mode = Config.SilentV2TargetPart or "Head"
        if typeof(ResolveAimPart) == "function" then
            local p = ResolveAimPart(char, mode)
            if p then return p end
        end
        if mode == "HumanoidRootPart" then
            return GetRoot(char)
        elseif mode == "Torso" then
            return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or GetRoot(char)
        elseif mode == "LowerTorso" then
            return char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") or GetRoot(char)
        end
        return char:FindFirstChild("Head") or GetRoot(char)
    end

    local _mpOrder = { "Head", "UpperTorso", "Torso", "HumanoidRootPart", "LowerTorso" }
    local function ResolveNamedPart(char, name)
        if not char or not name then return nil end
        if name == "Torso" then
            return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or GetRoot(char)
        elseif name == "LowerTorso" then
            return char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") or GetRoot(char)
        elseif name == "HumanoidRootPart" then
            return GetRoot(char)
        end
        local p = char:FindFirstChild(name)
        if p and p:IsA("BasePart") then return p end
        return nil
    end

    local function CollectSilentParts(char)
        if not char then return nil end
        if Config.SilentV2MultipointEnabled == true then
            local mp = Config.SilentV2Multipoint
            if type(mp) ~= "table" then mp = {} end
            local out = {}
            for i = 1, #_mpOrder do
                local n = _mpOrder[i]
                if mp[n] == true then
                    local p = ResolveNamedPart(char, n)
                    if p then out[#out + 1] = p end
                end
            end
            if #out > 0 then return out end
        end
        local one = GetTargetPart(char)
        if one then return { one } end
        return nil
    end

    local function IsAlive(plr)
        local char = plr and plr.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then return false end
        return GetRoot(char) ~= nil
    end

    local function IsTeammateV2(plr)
        if not plr or plr == LocalPlayer then return true end
        if IsTeammate then
            local ok, r = pcall(IsTeammate, plr)
            if ok and r then return true end
        end
        if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then return true end
        return false
    end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true

    local function VisibleCheck(part, cam)
        if not part then return false end
        if not Config.SilentV2VisibleCheck then return true end
        cam = cam or Workspace.CurrentCamera
        if not cam then return false end
        rayParams.FilterDescendantsInstances = { LocalPlayer.Character, cam }
        local origin = cam.CFrame.Position
        local result = Workspace:Raycast(origin, part.Position - origin, rayParams)
        if not result then return true end
        local model = part.Parent and part:FindFirstAncestorOfClass("Model")
        return model ~= nil and result.Instance:IsDescendantOf(model)
    end

    local function GetAimPosition(part)
        if not part then return nil end
        local pos = part.Position
        local n = part.Name
        if n == "Head" then
            pos = pos - Vector3.new(0, math.clamp(part.Size.Y * 0.12, 0.05, 0.35), 0)
        elseif n == "UpperTorso" or n == "Torso" then
            pos = pos + Vector3.new(0, math.clamp(part.Size.Y * 0.08, 0, 0.25), 0)
        end
        if Config.SilentV2Prediction then
            local model = part:FindFirstAncestorOfClass("Model")
            local root = model and GetRoot(model)
            if root then
                local vel = root.AssemblyLinearVelocity
                if not vel or vel.Magnitude < 0.05 then
                    pcall(function() vel = root.Velocity end)
                end
                if vel and vel.Magnitude > 0.05 then
                    local amt = tonumber(Config.SilentV2PredictionAmount) or 0.12
                    local myRoot = LocalPlayer.Character and GetRoot(LocalPlayer.Character)
                    local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 50
                    local scale = math.clamp(dist / 80, 0.55, 1.6)
                    pos = pos + vel * (amt * scale)
                end
            end
        end
        return pos
    end

        local function GetSilentTarget()
        if not Config.SilentAimV2Enabled then
            Cache.SilentV2Target, Cache.SilentV2Part, Cache.SilentV2Pos = nil, nil, nil
            return
        end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local mousePos = UserInputService:GetMouseLocation()
        local cx, cy = mousePos.X, mousePos.Y
        local maxFov = (Config.SilentV2Fov or 140) + GetMovementDynamicExtra(Config.SilentV2FovDynamicEnabled == true, Config.SilentV2FovDynamicExpand, "SilentFovDynamicExtra")
        local fovSq = maxFov * maxFov
        local teamCheck = Config.SilentV2TeamCheck
        local visCheck = Config.SilentV2VisibleCheck

        local function scorePart(part)
            if not part then return nil end
            if visCheck and not VisibleCheck(part, cam) then return nil end
            local aimPos = GetAimPosition(part)
            if not aimPos then return nil end
            local sp, onScreen = cam:WorldToViewportPoint(aimPos)
            if not onScreen or sp.Z <= 0 then return nil end
            local dx, dy = sp.X - cx, sp.Y - cy
            local dsq = dx * dx + dy * dy
            if dsq > fovSq then return nil end
            return dsq, aimPos
        end

        if Config.SilentV2Sticky and Cache.SilentV2Target and IsAlive(Cache.SilentV2Target) then
            local sticky = Cache.SilentV2Target
            if not (teamCheck and IsTeammateV2(sticky)) then
                local parts = CollectSilentParts(sticky.Character)
                if parts then
                    local bestD, bestP, bestPos = fovSq * 1.25, nil, nil
                    for i = 1, #parts do
                        local dsq, apos = scorePart(parts[i])
                        if dsq and dsq <= bestD then
                            bestD, bestP, bestPos = dsq, parts[i], apos
                        end
                    end
                    if bestP and bestPos then
                        Cache.SilentV2Target = sticky
                        Cache.SilentV2Part = bestP
                        Cache.SilentV2Pos = bestPos
                        return
                    end
                end
            end
        end

        local best, bestPart, bestPos, bestDistSq = nil, nil, nil, fovSq
        local list = CachedPlayerList or Players:GetPlayers()
        for i = 1, #list do
            local plr = list[i]
            if plr ~= LocalPlayer and IsAlive(plr) and not (teamCheck and IsTeammateV2(plr)) then
                local parts = CollectSilentParts(plr.Character)
                if parts then
                    for j = 1, #parts do
                        local dsq, apos = scorePart(parts[j])
                        if dsq and dsq <= bestDistSq then
                            bestDistSq = dsq
                            best = plr
                            bestPart = parts[j]
                            bestPos = apos
                        end
                    end
                end
            end
        end
        Cache.SilentV2Target = best
        Cache.SilentV2Part = bestPart
        Cache.SilentV2Pos = bestPos
    end

    local function ShouldSilent()
        if not Config.SilentAimV2Enabled then return false end
        if not Cache.SilentV2Pos or not Cache.SilentV2Part then return false end
        if not Chance(Config.SilentV2HitChance) then return false end
        return true
    end

    local v2Acc = 0
    local V2_SCAN_INTERVAL = 0.012
    RunService.Heartbeat:Connect(function(dt)
        if not Config.SilentAimV2Enabled then
            if Cache.SilentV2Target then
                Cache.SilentV2Target, Cache.SilentV2Part, Cache.SilentV2Pos = nil, nil, nil
            end
            local circle = Cache.SilentV2FovCircle
            if circle and circle.Visible then circle.Visible = false end
            local fill = Cache.SilentV2FovCircleFill
            if fill and fill.Visible then fill.Visible = false end
            return
        end

        local circle = Cache.SilentV2FovCircle
        local fill = Cache.SilentV2FovCircleFill
        if circle then
            if Config.SilentV2ShowFov then
                local mousePos = UserInputService:GetMouseLocation()
                local baseR = (Config.SilentV2Fov or 140) + GetMovementDynamicExtra(Config.SilentV2FovDynamicEnabled == true, Config.SilentV2FovDynamicExpand, "SilentFovDynamicExtra")
                local pulse = 1
                if Config.SilentV2FovPulseEnabled or Config.FovPulseEnabled then
                    local spd = tonumber(Config.FovPulseSpeed) or 3
                    local amt = tonumber(Config.FovPulseAmount) or 0.12
                    pulse = 1 + math.sin(tick() * spd * 2) * amt
                end
                local r = baseR * pulse
                circle.Position = Vector2.new(mousePos.X, mousePos.Y)
                circle.Radius = r
                circle.Color = Config.Color_SilentV2Fov or Color3.fromRGB(120, 200, 255)
                if not circle.Visible then circle.Visible = true end
                if fill then
                    fill.Position = Vector2.new(mousePos.X, mousePos.Y)
                    fill.Radius = r
                    fill.Color = Config.Color_SilentV2FovFill or Color3.fromRGB(120, 200, 255)
                    fill.Transparency = Config.SilentV2FovFillTransparency or 0.7
                    fill.Visible = Config.SilentV2FovFillEnabled == true
                end
            else
                if circle.Visible then circle.Visible = false end
                if fill and fill.Visible then fill.Visible = false end
            end
        end

        v2Acc = v2Acc + (dt or 0.016)
        if v2Acc >= V2_SCAN_INTERVAL then
            v2Acc = 0
            GetSilentTarget()
        end
    end)

    pcall(function()
        local mouse = LocalPlayer:GetMouse()
        local mt = getrawmetatable(mouse)
        if not mt then return end
        local oldIndex = mt.__index
        if isreadonly and isreadonly(mt) and setreadonly then setreadonly(mt, false) end
        local wrap = newcclosure or function(f) return f end
        mt.__index = wrap(function(self, key)
            if ShouldSilent() then
                if key == "Hit" or key == "hit" then
                    return CFrame.new(Cache.SilentV2Pos)
                end
                if key == "Target" or key == "target" then
                    return Cache.SilentV2Part
                end
                if key == "UnitRay" then
                    local origin = Workspace.CurrentCamera.CFrame.Position
                    return Ray.new(origin, (Cache.SilentV2Pos - origin).Unit)
                end
            end
            return oldIndex(self, key)
        end)
    end)

    pcall(function()
        local mt = getrawmetatable(Workspace)
        if not mt then return end
        local oldNamecall = mt.__namecall
        if isreadonly and isreadonly(mt) and setreadonly then setreadonly(mt, false) end
        local wrap = newcclosure or function(f) return f end
        mt.__namecall = wrap(function(self, ...)
            local method = (getnamecallmethod and getnamecallmethod()) or ""
            local args = { ... }
            if ShouldSilent() and self == Workspace then
                if method == "Raycast" then
                    local origin, direction = args[1], args[2]
                    if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
                        local dir = Cache.SilentV2Pos - origin
                        if dir.Magnitude > 0.05 then
                            local maxLen = direction.Magnitude
                            if maxLen > 1 then dir = dir.Unit * maxLen end
                            args[2] = dir
                            return oldNamecall(self, unpack(args))
                        end
                    end
                elseif method == "FindPartOnRay"
                    or method == "FindPartOnRayWithIgnoreList"
                    or method == "FindPartOnRayWithWhitelist"
                    or method == "findPartOnRay"
                    or method == "findPartOnRayWithIgnoreList" then
                    local ray = args[1]
                    if typeof(ray) == "Ray" then
                        local origin = ray.Origin
                        local len = ray.Direction.Magnitude
                        if len < 1 then len = 1000 end
                        args[1] = Ray.new(origin, (Cache.SilentV2Pos - origin).Unit * len)
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end)

    pcall(function()
        if not hookfunction then return end
        local old = Workspace.Raycast
        local wrap = newcclosure or function(f) return f end
        hookfunction(old, wrap(function(self, origin, direction, params)
            if ShouldSilent() and typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
                local dir = Cache.SilentV2Pos - origin
                if dir.Magnitude > 0.05 then
                    local maxLen = direction.Magnitude
                    if maxLen > 1 then dir = dir.Unit * maxLen end
                    return old(self, origin, dir, params)
                end
            end
            return old(self, origin, direction, params)
        end))
    end)
end)()


;(function()
    RunService.RenderStepped:Connect(function()
        if true then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local x = Config.HandsX or 0.2
        local y = Config.HandsY or -0.155
        local z = Config.HandsZ or 0.075
        for _, child in ipairs(cam:GetChildren()) do
            if child:IsA("Model") then
                local statsFolder = child:FindFirstChild("Stats")
                if statsFolder then
                    local defaultVal = statsFolder:FindFirstChild("Default")
                    if defaultVal and defaultVal:IsA("Vector3Value") then
                        defaultVal.Value = Vector3.new(x, y, z)
                    end
                end
            end
        end
    end)
end)()


;(function()
    local lastT = os.clock()
    local wasStrafeOn = false
    local savedWalkSpeed = nil
    local savedChar = nil

    local function Strafe_RestoreSpeed()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            local restore = 16
            if savedWalkSpeed and typeof(savedWalkSpeed) == "number" and savedWalkSpeed > 0 then
                restore = savedWalkSpeed
            end
            
            if Config.SpeedHackEnabled and Config.WalkSpeedValue then
                restore = Config.WalkSpeedValue
            end
            pcall(function() hum.WalkSpeed = restore end)
        end
        
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                local v = hrp.AssemblyLinearVelocity
                hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
            end)
        end
        savedWalkSpeed = nil
        savedChar = nil
    end

    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        local dt = math.clamp(now - lastT, 0, 0.05)
        lastT = now

        if not Config.StrafeEnabled then
            if wasStrafeOn then
                wasStrafeOn = false
                Strafe_RestoreSpeed()
            end
            return
        end

        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        if Config.FlyEnabled then return end

        
        if not wasStrafeOn or savedChar ~= char then
            if not Config.SpeedHackEnabled then
                savedWalkSpeed = hum.WalkSpeed
                if not savedWalkSpeed or savedWalkSpeed <= 0 then savedWalkSpeed = 16 end
            else
                savedWalkSpeed = Config.WalkSpeedValue or 16
            end
            savedChar = char
            wasStrafeOn = true
        end

        local move = hum.MoveDirection
        if move.Magnitude < 0.05 then
            local cam = Workspace.CurrentCamera
            if cam then
                local f = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
                local r = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
                if f.Magnitude > 0 then f = f.Unit end
                if r.Magnitude > 0 then r = r.Unit end
                local d = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then d = d + f end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then d = d - f end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then d = d - r end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then d = d + r end
                if d.Magnitude > 0.05 then move = d.Unit end
            end
        end
        if move.Magnitude < 0.05 then return end
        move = Vector3.new(move.X, 0, move.Z)
        if move.Magnitude < 0.05 then return end
        move = move.Unit

        local speed = tonumber(Config.StrafeSpeed) or 22
        local mode = Config.StrafeMode or "Hybrid"
        local vy = 0
        pcall(function() vy = hrp.AssemblyLinearVelocity.Y end)

        if mode == "CFrame" then
            pcall(function()
                hrp.CFrame = hrp.CFrame + move * speed * dt
            end)
        elseif mode == "Velocity" then
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.new(move.X * speed, vy, move.Z * speed)
            end)
        else 
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.new(move.X * speed, vy, move.Z * speed)
            end)
            pcall(function()
                hrp.CFrame = hrp.CFrame + move * (speed * 0.35) * dt
            end)
        end
        
        if not Config.SpeedHackEnabled then
            pcall(function()
                local targetWS = math.clamp(speed, 16, 28)
                if hum.WalkSpeed < targetWS then
                    hum.WalkSpeed = targetWS
                end
            end)
        end
    end)
end)()


;(function()
    local function AWColors()
        return {
            Pen = Config.Color_AutowallPen or Color3.fromRGB(60, 255, 90),
            Block = Config.Color_AutowallBlock or Color3.fromRGB(255, 55, 55),
            Mid = Config.Color_AutowallMid or Color3.fromRGB(255, 200, 60),
            None = Color3.fromRGB(120, 120, 130),
        }
    end
    local MaterialPen = {}
    local function addMat(name, weight)
        local ok, mat = pcall(function() return Enum.Material[name] end)
        if ok and mat then MaterialPen[mat] = weight end
    end
    addMat("Wood", 0.35) addMat("WoodPlanks", 0.4) addMat("LeafyGrass", 0.25)
    addMat("Grass", 0.45) addMat("Fabric", 0.3) addMat("Carpet", 0.3)
    addMat("Plastic", 0.55) addMat("SmoothPlastic", 0.55) addMat("Glass", 0.25)
    addMat("ForceField", 0.15) addMat("Neon", 0.4) addMat("Cardboard", 0.2)
    addMat("Ice", 0.6) addMat("Snow", 0.4) addMat("Sand", 0.7) addMat("Foil", 0.7)
    addMat("Rubber", 0.5) addMat("Concrete", 1.4) addMat("Brick", 1.35)
    addMat("Cobblestone", 1.4) addMat("Rock", 1.5) addMat("Slate", 1.45)
    addMat("Marble", 1.3) addMat("Granite", 1.5) addMat("Asphalt", 1.3)
    addMat("Basalt", 1.5) addMat("CrackedLava", 1.4) addMat("Limestone", 1.35)
    addMat("Pavement", 1.3) addMat("Salt", 0.9) addMat("Sandstone", 1.1)
    addMat("Metal", 1.8) addMat("DiamondPlate", 1.9) addMat("CorrodedMetal", 1.6)

    local folder = Instance.new("Folder")
    folder.Name = "AnxiumAutowallWorld"
    folder.Parent = Workspace

    local marker = Instance.new("Part")
    marker.Name = "AutowallMarker"
    marker.Anchored = true
    marker.CanCollide = false
    marker.CanQuery = false
    marker.CanTouch = false
    marker.CastShadow = false
    marker.Material = Enum.Material.Neon
    marker.Color = AWColors().None
    marker.Transparency = 1
    marker.Size = Vector3.new(0.9, 0.9, 0.04)
    marker.CFrame = CFrame.new(0, -500, 0)
    marker.Parent = folder

    local cornerMesh = Instance.new("BlockMesh")
    cornerMesh.Parent = marker

    local surf = Instance.new("SurfaceGui")
    surf.Name = "AutowallSurface"
    surf.Face = Enum.NormalId.Front
    surf.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    surf.PixelsPerStud = 64
    surf.AlwaysOnTop = true
    surf.LightInfluence = 0
    surf.ZOffset = 0.1
    surf.Enabled = false
    surf.Parent = marker
    local sqFrame = Instance.new("Frame")
    sqFrame.Name = "Square"
    sqFrame.Size = UDim2.fromScale(1, 1)
    sqFrame.BackgroundColor3 = AWColors().None
    sqFrame.BackgroundTransparency = 0.15
    sqFrame.BorderSizePixel = 0
    sqFrame.Parent = surf
    local sqCorner = Instance.new("UICorner")
    sqCorner.Name = "SquareCorner"
    sqCorner.CornerRadius = UDim.new(0, 3)
    sqCorner.Parent = sqFrame

    local bill = Instance.new("BillboardGui")
    bill.Name = "AutowallInfo"
    bill.AlwaysOnTop = true
    bill.Size = UDim2.fromOffset(220, 28)
    bill.StudsOffset = Vector3.new(0, 0.55, 0)
    bill.MaxDistance = 400
    bill.Enabled = false
    bill.Adornee = marker
    bill.Parent = marker
    local infoLbl = Instance.new("TextLabel")
    infoLbl.BackgroundTransparency = 1
    infoLbl.Size = UDim2.fromScale(1, 1)
    infoLbl.Font = SelectedFont
    infoLbl.TextSize = 12
    infoLbl.TextStrokeTransparency = 0.45
    infoLbl.TextColor3 = AWColors().None
    infoLbl.Text = ""
    infoLbl.Parent = bill

    local lastCF = nil
    local lastColor = AWColors().None
    local lastLabel = ""
    local holdFrames = 0
    local MAX_HOLD = 6

    local function isCharacterPart(inst)
        if not inst then return false end
        local model = inst:FindFirstAncestorOfClass("Model")
        if not model then return false end
        if model:FindFirstChildOfClass("Humanoid") then return true end
        local plr = Players:GetPlayerFromCharacter(model)
        return plr ~= nil
    end

    local function buildIgnore()
        local ignore = { folder, marker }
        if LocalPlayer.Character then
            ignore[#ignore + 1] = LocalPlayer.Character
        end
        for _, plr in ipairs(CachedPlayerList or Players:GetPlayers()) do
            if plr.Character then
                ignore[#ignore + 1] = plr.Character
            end
        end
        local cam = Workspace.CurrentCamera
        if cam then ignore[#ignore + 1] = cam end
        return ignore
    end

    local function orientOnSurface(pos, normal)
        local n = normal
        if typeof(n) ~= "Vector3" or n.Magnitude < 1e-4 then
            n = Vector3.new(0, 1, 0)
        else
            n = n.Unit
        end
        local up = Vector3.new(0, 1, 0)
        local right = n:Cross(up)
        if right.Magnitude < 0.08 then
            right = n:Cross(Vector3.new(1, 0, 0))
        end
        right = right.Unit
        local up2 = right:Cross(n).Unit
        return CFrame.fromMatrix(pos + n * 0.035, right, up2, -n)
    end

    local function applyVisuals()
        local sizePx = math.floor(tonumber(Config.AutowallSize) or 18)
        local stud = math.clamp(sizePx / 22, 0.35, 2.2)
        marker.Size = Vector3.new(stud, stud, 0.045)
        marker.Transparency = 1
        local trans = tonumber(Config.AutowallTransparency)
        if trans == nil then trans = 0.15 end
        trans = math.clamp(trans, 0, 0.9)
        sqFrame.BackgroundTransparency = trans
        local cornerPx = math.clamp(math.floor(tonumber(Config.AutowallCorner) or 0), 0, 20)
        local facePx = math.max(1, math.floor(stud * 64))
        if cornerPx <= 0 then
            sqCorner.CornerRadius = UDim.new(0, 0)
        else
            sqCorner.CornerRadius = UDim.new(0, math.clamp(math.floor(cornerPx * (facePx / 18)), 0, math.floor(facePx * 0.5)))
        end
        if not Config.AutowallEnabled then
            marker.CFrame = CFrame.new(0, -500, 0)
            marker.Transparency = 1
            surf.Enabled = false
            bill.Enabled = false
            infoLbl.Text = ""
            lastCF = nil
            holdFrames = 0
        end
    end
    Cache.AutowallApply = applyVisuals

    Cache.AutowallSetEnabled = function(on)
        Config.AutowallEnabled = on and true or false
        applyVisuals()
        if not on then
            marker.CFrame = CFrame.new(0, -500, 0)
            marker.Transparency = 1
            surf.Enabled = false
            bill.Enabled = false
            infoLbl.Text = ""
            lastCF = nil
            holdFrames = 0
        end
    end

    local function measureThickness(hitPart, entryPos, dir)
        local diag = hitPart.Size.Magnitude + 2
        local includeParams = RaycastParams.new()
        includeParams.FilterType = Enum.RaycastFilterType.Include
        includeParams.FilterDescendantsInstances = { hitPart }
        includeParams.IgnoreWater = true
        local far = entryPos + dir.Unit * diag
        local back = Workspace:Raycast(far, entryPos - far, includeParams)
        if back then return (back.Position - entryPos).Magnitude end
        local forward = entryPos + dir.Unit * 0.05
        local back2 = Workspace:Raycast(forward + dir.Unit * diag, -dir.Unit * diag, includeParams)
        if back2 then return (back2.Position - entryPos).Magnitude end
        local n, s = dir.Unit, hitPart.Size
        return math.clamp(math.abs(s.X * n.X) + math.abs(s.Y * n.Y) + math.abs(s.Z * n.Z) * 0.5, 0.05, diag)
    end

    local function evaluate(result, cam)
        if not result or not result.Instance then
            return AWColors().None, "no hit", false
        end
        local part = result.Instance
        if isCharacterPart(part) then
            return AWColors().None, "player", false
        end
        if not part:IsA("BasePart") then
            return Colors.Block, tostring(part.ClassName), true
        end
        local dir = result.Position - cam.CFrame.Position
        if dir.Magnitude < 1e-4 then dir = cam.CFrame.LookVector else dir = dir.Unit end
        local thickness = measureThickness(part, result.Position, dir)
        local mat = part.Material
        local weight = MaterialPen[mat] or 1.0
        local effective = thickness * weight
        local softMax = tonumber(Config.AutowallSoftMax) or 2.2
        local hardMax = tonumber(Config.AutowallHardMax) or 0.55
        local limit = (weight >= 1.2) and hardMax or softMax
        local label = string.format("%s  %.2f st", mat.Name, thickness)
        if effective <= limit then
            local C = AWColors(); return C.Pen, label .. "  PEN", true
        elseif effective <= limit * 1.35 then
            local C = AWColors(); return C.Mid, label .. "  MID", true
        end
        local C = AWColors(); return C.Block, label .. "  BLOCK", true
    end

    Config.AutowallEnabled = Config.AutowallEnabled == true
    applyVisuals()
    if Config.AutowallEnabled then
        Cache.AutowallSetEnabled(true)
    else
        marker.Transparency = 1
        surf.Enabled = false
        bill.Enabled = false
        infoLbl.Text = ""
    end

    RunService.RenderStepped:Connect(function(dt)
        if not Config.AutowallEnabled then return end
        local cam = Workspace.CurrentCamera or Camera
        if not cam then return end
        dt = math.clamp(dt or 0.016, 0.001, 0.05)

        local vp = cam.ViewportSize
        local ray = cam:ViewportPointToRay(vp.X * 0.5, vp.Y * 0.5)
        Cache._AWRayParams = Cache._AWRayParams or RaycastParams.new()
        local params = Cache._AWRayParams
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = buildIgnore()
        params.IgnoreWater = true

        local result = Workspace:Raycast(ray.Origin, ray.Direction * 900, params)
        if result and isCharacterPart(result.Instance) then
            result = nil
        end

        local color, label, valid = evaluate(result, cam)
        local sizePx = math.floor(tonumber(Config.AutowallSize) or 18)
        local stud = math.clamp(sizePx / 22, 0.35, 2.2)
        local trans = tonumber(Config.AutowallTransparency)
        if trans == nil then trans = 0.15 end
        trans = math.clamp(trans, 0, 0.9)
        local cornerPx = math.clamp(math.floor(tonumber(Config.AutowallCorner) or 0), 0, 20)
        local facePx = math.max(1, math.floor(stud * 64))
        if cornerPx <= 0 then
            sqCorner.CornerRadius = UDim.new(0, 0)
        else
            sqCorner.CornerRadius = UDim.new(0, math.clamp(math.floor(cornerPx * (facePx / 18)), 0, math.floor(facePx * 0.5)))
        end

        if valid and result then
            local targetCF = orientOnSurface(result.Position, result.Normal)
            marker.CFrame = targetCF
            lastCF = targetCF
            lastColor = color
            lastLabel = label or ""
            holdFrames = MAX_HOLD
            marker.Size = Vector3.new(stud, stud, 0.045)
            marker.Color = color
            marker.Transparency = 1
            surf.Enabled = true
            sqFrame.BackgroundColor3 = color
            sqFrame.BackgroundTransparency = trans
            if Config.AutowallShowInfo then
                bill.Enabled = true
                infoLbl.Text = lastLabel
                infoLbl.TextColor3 = color
                infoLbl.Font = SelectedFont
            else
                bill.Enabled = false
                infoLbl.Text = ""
            end
        else
            if holdFrames > 0 and lastCF then
                holdFrames = holdFrames - 1
                marker.CFrame = lastCF
                marker.Color = lastColor
                marker.Transparency = 1
                marker.Size = Vector3.new(stud, stud, 0.045)
                surf.Enabled = true
                sqFrame.BackgroundColor3 = lastColor
                sqFrame.BackgroundTransparency = trans
                if Config.AutowallShowInfo and lastLabel ~= "" then
                    bill.Enabled = true
                    infoLbl.Text = lastLabel
                    infoLbl.TextColor3 = lastColor
                else
                    bill.Enabled = false
                end
            else
                marker.Transparency = 1
                surf.Enabled = false
                bill.Enabled = false
                infoLbl.Text = ""
                lastCF = nil
                holdFrames = 0
            end
        end
    end)
end)()


;(function()
    local STAR_URL = "https://raw.githubusercontent.com/AnxiumClient/png/main/white-star-1280-788-Photoroom.png"
    local STAR_FILE = "Anxium_white_star_1280.png"
    local starAsset, folder, particles, idx = nil, nil, {}, 1
    local groundCache, groundCacheT = {}, 0
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    local AREA, SPAWN_H, BATCH = 280, 55, 35

    local function loadAsset()
        if starAsset then return starAsset end
        if typeof(EnsureGitSoundAsset) == "function" then
            local a = EnsureGitSoundAsset("FallingStarTex", STAR_URL, STAR_FILE)
            if a then starAsset = a return a end
        end
        pcall(function()
            if typeof(getcustomasset) ~= "function" then return end
            local onDisk = false
            if typeof(isfile) == "function" then pcall(function() onDisk = isfile(STAR_FILE) == true end) end
            if not onDisk and typeof(writefile) == "function" then
                local ok, body = pcall(function() return game:HttpGet(STAR_URL) end)
                if ok and type(body) == "string" and #body > 500 then
                    pcall(writefile, STAR_FILE, body)
                    onDisk = true
                end
            end
            if onDisk or typeof(isfile) ~= "function" then
                local okA, a = pcall(function() return getcustomasset(STAR_FILE) end)
                if okA and type(a) == "string" and a ~= "" then starAsset = a end
            end
        end)
        return starAsset
    end

    local function getCenter()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then return hrp.Position end
        local cam = Workspace.CurrentCamera or Camera
        if cam then return cam.CFrame.Position end
        return Vector3.new(0, 5, 0)
    end

    local function spawnPos(center)
        local ang = math.random() * math.pi * 2
        local r = math.sqrt(math.random()) * AREA
        return Vector3.new(center.X + math.cos(ang) * r, center.Y + SPAWN_H * (0.55 + math.random() * 0.55), center.Z + math.sin(ang) * r)
    end

    local function starColor()
        return Config.Color_FallingStars or Color3.fromRGB(255, 255, 255)
    end
    local function starSize()
        return math.clamp(math.floor(tonumber(Config.FallingStarsSize) or 28), 8, 90)
    end

    local function setAlpha(p, a)
        a = math.clamp(a, 0, 1)
        p.alpha = a
        if p.img then
            p.img.BackgroundTransparency = 1
            p.img.ImageColor3 = starColor()
            p.img.ImageTransparency = 1 - (a * 0.95)
        end
    end

    local function clearAll()
        for _, p in ipairs(particles) do pcall(function() if p.part then p.part:Destroy() end end) end
        particles = {}
        if folder then pcall(function() folder:Destroy() end) folder = nil end
        groundCache = {}
    end

    local function ensureFolder()
        if folder and folder.Parent then return folder end
        local old = Workspace:FindFirstChild("AnxiumFallingStars")
        if old then old:Destroy() end
        folder = Instance.new("Folder")
        folder.Name = "AnxiumFallingStars"
        folder.Parent = Workspace
        return folder
    end

    local function createOne(parent, center)
        local part = Instance.new("Part")
        part.Name = "Star"
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.CastShadow = false
        part.Transparency = 1
        part.Size = Vector3.new(0.1, 0.1, 0.1)
        part.Parent = parent
        local bill = Instance.new("BillboardGui")
        bill.AlwaysOnTop = true
        bill.LightInfluence = 0
        bill.MaxDistance = 700
        bill.Size = UDim2.fromOffset(starSize(), starSize())
        bill.Adornee = part
        bill.Parent = part
        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.BorderSizePixel = 0
        img.Size = UDim2.fromScale(1, 1)
        img.ScaleType = Enum.ScaleType.Fit
        img.ImageTransparency = 1
        img.ImageColor3 = starColor()
        if starAsset then img.Image = starAsset end
        img.Parent = bill
        part.CFrame = CFrame.new(spawnPos(center))
        local fall = 8 + math.random() * 8
        return { part = part, img = img, bill = bill, vel = Vector3.new((math.random()-0.5)*1.2, -fall, (math.random()-0.5)*1.2), alpha = 0, phase = "in" }
    end

    local function rebuild()
        clearAll()
        if not Config.FallingStarsEnabled then return end
        loadAsset()
        local parent = ensureFolder()
        local c = getCenter()
        local n = math.clamp(math.floor(tonumber(Config.FallingStarsCount) or 70), 20, 150)
        for i = 1, n do particles[i] = createOne(parent, c) end
        idx = 1
    end

    local function applyVisuals()
        local px, col = starSize(), starColor()
        for _, p in ipairs(particles) do
            if p.bill then p.bill.Size = UDim2.fromOffset(px, px) end
            if p.img then
                p.img.ImageColor3 = col
                if starAsset and (not p.img.Image or p.img.Image == "") then p.img.Image = starAsset end
            end
            setAlpha(p, p.alpha or 1)
        end
    end

    local function groundY(pos, center)
        rayParams.FilterDescendantsInstances = { folder, LocalPlayer.Character }
        local hit = Workspace:Raycast(pos + Vector3.new(0, 2, 0), Vector3.new(0, -120, 0), rayParams)
        if hit then return hit.Position.Y end
        return center.Y - 4
    end

    local function respawn(p, center)
        if not p.part then return end
        p.part.CFrame = CFrame.new(spawnPos(center))
        local fall = 8 + math.random() * 8
        p.vel = Vector3.new((math.random()-0.5)*1.2, -fall, (math.random()-0.5)*1.2)
        p.phase = "in"
        setAlpha(p, 0)
    end

    local function tickStars(dt)
        if not Config.FallingStarsEnabled or #particles == 0 then return end
        if dt <= 0 or dt > 0.1 then dt = 0.016 end
        local center = getCenter()
        local n = #particles
        local step = dt * (n / BATCH) * 0.9
        groundCacheT = groundCacheT - dt
        for _ = 1, math.min(BATCH, n) do
            local p = particles[idx]
            idx = idx % n + 1
            if not p or not p.part or not p.part.Parent then continue end
            local newPos = p.part.Position + p.vel * step
            local key = string.format("%d_%d", math.floor(newPos.X / 14), math.floor(newPos.Z / 14))
            local gy = groundCache[key]
            if not gy or groundCacheT <= 0 then
                gy = groundY(newPos, center)
                groundCache[key] = gy
                if groundCacheT <= 0 then groundCacheT = 0.28 end
            end
            local dist = newPos.Y - gy
            if p.phase == "in" then
                setAlpha(p, (p.alpha or 0) + dt / 0.55)
                if (p.alpha or 0) >= 1 then p.alpha = 1; p.phase = "fall" end
            elseif p.phase == "fall" then
                if dist <= 4.5 then p.phase = "out" else setAlpha(p, 1) end
            end
            if p.phase == "out" then
                local a = dist / 4.5
                if a < (p.alpha or 1) then setAlpha(p, a) else setAlpha(p, (p.alpha or 1) - dt / 0.7) end
                if (p.alpha or 0) <= 0.02 or dist <= 0.2 then respawn(p, center); continue end
            end
            local flat = Vector3.new(newPos.X - center.X, 0, newPos.Z - center.Z)
            if flat.Magnitude > AREA * 1.2 or newPos.Y < center.Y - 90 then respawn(p, center); continue end
            p.part.CFrame = CFrame.new(newPos)
        end
    end

    Cache.FallingStarsApply = applyVisuals
    Cache.FallingStarsRebuild = rebuild
    Cache.FallingStarsSetEnabled = function(on)
        Config.FallingStarsEnabled = on and true or false
        if on then rebuild() else clearAll() end
    end

    task.spawn(function()
        local last = nil
        while true do
            task.wait(0.4)
            if Config.FallingStarsEnabled then
                local c = starColor()
                local k = string.format("%.3f%.3f%.3f", c.R, c.G, c.B)
                if k ~= last then last = k; applyVisuals() end
            end
        end
    end)

    if not Cache._starsHeartbeat then
        Cache._starsHeartbeat = true
        RunService.Heartbeat:Connect(function(dt) pcall(tickStars, dt) end)
    end
end)()


Cache.PeekAssistArmed = false
Cache.PeekAssistOrigin = nil
Cache.PeekAssistOriginCF = nil
Cache.PeekAssistToken = 0

local function PeekAssist_GetGroundPosition(position, character, folder)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    params.FilterDescendantsInstances = { character, folder }
    local result = Workspace:Raycast(position + Vector3.new(0, 2, 0), Vector3.new(0, -15, 0), params)
    return (result and result.Position or (position - Vector3.new(0, 3, 0))) + Vector3.new(0, 0.1, 0)
end

function PeekAssist_CreateEffect(position, color, fillEnabled)
    if not position then return end
    local folder = Workspace:FindFirstChild("AnxiumPeekAssistEffects")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "AnxiumPeekAssistEffects"
        folder.Parent = Workspace
    end

    local model = Instance.new("Model")
    model.Name = "PeekAssistEffect"
    model.Parent = folder

    local segs = math.clamp(math.floor(tonumber(Config.PeekAssistSegments) or 48), 16, 80)
    local endR = math.clamp(tonumber(Config.PeekAssistRadius) or 5, 0.5, 20)
    local startR = math.max(0.25, endR * 0.18)
    local thick = math.clamp(tonumber(Config.PeekAssistThickness) or 0.18, 0.04, 1)
    local duration = math.clamp((tonumber(Config.PeekAssistDurationMs) or 700) / 1000, 0.1, 3)
    local trans = math.clamp(tonumber(Config.PeekAssistTransparency) or 0.28, 0, 1)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    if fillEnabled then
        local disk = Instance.new("Part")
        disk.Name = "Fill"
        disk.Shape = Enum.PartType.Cylinder
        disk.Anchored = true
        disk.CanCollide = false
        disk.CanQuery = false
        disk.CanTouch = false
        disk.CastShadow = false
        disk.Material = Enum.Material.Neon
        disk.Color = color
        disk.Transparency = trans
        disk.Size = Vector3.new(0.04, startR * 2, startR * 2)
        disk.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
        disk.Parent = model
        TweenService:Create(disk, tweenInfo, {
            Size = Vector3.new(0.04, endR * 2, endR * 2),
            Transparency = 1,
        }):Play()
    end

    local startCirc = 2 * math.pi * startR
    local startSegLen = (startCirc / segs) * 1.5
    local endCirc = 2 * math.pi * endR
    local endSegLen = (endCirc / segs) * 1.5

    for i = 1, segs do
        local angle = (i / segs) * math.pi * 2
        local part = Instance.new("Part")
        part.Name = "RingSeg"
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.CastShadow = false
        part.Material = Enum.Material.Neon
        part.Color = color
        part.Transparency = trans
        part.Size = Vector3.new(startSegLen, 0.02, thick)
        part.Parent = model

        local p0 = CFrame.new(position + Vector3.new(math.cos(angle) * startR, 0, math.sin(angle) * startR))
        local tangent = angle + math.pi / 2
        part.CFrame = p0 * CFrame.Angles(0, -tangent, 0)

        local p1 = CFrame.new(position + Vector3.new(math.cos(angle) * endR, 0, math.sin(angle) * endR))
        TweenService:Create(part, tweenInfo, {
            CFrame = p1 * CFrame.Angles(0, -tangent, 0),
            Size = Vector3.new(endSegLen, 0.02, thick),
            Transparency = 1,
        }):Play()
    end

    task.delay(duration + 0.35, function()
        if model and model.Parent then model:Destroy() end
    end)
end

function PeekAssist_Deactivate()
    Cache.PeekAssistToken = (Cache.PeekAssistToken or 0) + 1
    Cache.PeekAssistArmed = false
    Cache.PeekAssistOrigin = nil
    Cache.PeekAssistOriginCF = nil
end

function PeekAssist_Activate()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    Cache.PeekAssistToken = (Cache.PeekAssistToken or 0) + 1
    Cache.PeekAssistArmed = true
    Cache.PeekAssistOrigin = hrp.Position
    Cache.PeekAssistOriginCF = hrp.CFrame

    local floorPos = PeekAssist_GetGroundPosition(hrp.Position, char)
    PeekAssist_CreateEffect(floorPos, Config.Color_PeekAssist or Theme.Accent, Config.PeekAssistFillEnabled == true)
    Notify("Peek Assist", "Position armed")
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not Cache.PeekAssistArmed or not Cache.PeekAssistOrigin then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local origin = Cache.PeekAssistOrigin
    local originCF = Cache.PeekAssistOriginCF
    if not hrp or not hum or hum.Health <= 0 or not originCF then
        PeekAssist_Deactivate()
        return
    end

    if (hrp.Position - origin).Magnitude < 0.35 then return end

    local shotPos = PeekAssist_GetGroundPosition(hrp.Position, char)
    PeekAssist_CreateEffect(shotPos, Config.Color_PeekAssistShot or Color3.fromRGB(255, 100, 160), Config.PeekAssistFillEnabled == true)

    local returnDelay = math.clamp((tonumber(Config.PeekAssistReturnDelayMs) or 0) / 1000, 0, 2)
    local returnToken = (Cache.PeekAssistToken or 0) + 1
    Cache.PeekAssistToken = returnToken
    Cache.PeekAssistArmed = false
    Cache.PeekAssistOrigin = nil
    Cache.PeekAssistOriginCF = nil

    task.delay(returnDelay, function()
        if Cache.PeekAssistToken ~= returnToken then return end
        local currentChar = LocalPlayer.Character
        local currentHrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
        if not currentHrp or not currentHum or currentHum.Health <= 0 then return end
        pcall(function()
            currentHrp.AssemblyLinearVelocity = Vector3.zero
            currentHrp.AssemblyAngularVelocity = Vector3.zero
            currentHrp.CFrame = originCF
        end)
        if Cache.PeekAssistToken == returnToken then
            Cache.PeekAssistToken = returnToken + 1
        end
    end)
end)

Cache.TargetRingPhase = 0
Cache.TargetRingSegs = Cache.TargetRingSegs or {}


Cache.TargetMarkerRot = 0
local TARGET_MARKER_ASSET = "rbxassetid://125367266780285"

function TargetMarker_Hide()
    pcall(function()
        if Cache.TargetMarkerBill then Cache.TargetMarkerBill:Destroy() end
    end)
    Cache.TargetMarkerBill = nil
    Cache.TargetMarkerImg = nil
    Cache.TargetMarkerAdornee = nil
end

function TargetMarker_Ensure(adornee)
    if Cache.TargetMarkerBill and Cache.TargetMarkerBill.Parent and Cache.TargetMarkerAdornee == adornee then
        return Cache.TargetMarkerImg
    end
    TargetMarker_Hide()
    if not adornee then return nil end
    local bill = Instance.new("BillboardGui")
    bill.Name = "AnxiumTargetMarker"
    bill.AlwaysOnTop = true
    bill.LightInfluence = 0
    bill.MaxDistance = 800
    bill.Size = UDim2.fromOffset(90, 90)
    bill.StudsOffset = Vector3.new(0, 0.35, 0)
    bill.Adornee = adornee
    bill.Parent = adornee
    local img = Instance.new("ImageLabel")
    img.Name = "Icon"
    img.BackgroundTransparency = 1
    img.BorderSizePixel = 0
    img.Size = UDim2.fromScale(1, 1)
    img.Position = UDim2.fromScale(0.5, 0.5)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.Image = TARGET_MARKER_ASSET
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = bill
    Cache.TargetMarkerBill = bill
    Cache.TargetMarkerImg = img
    Cache.TargetMarkerAdornee = adornee
    return img
end

function TargetMarker_Update(targetHrp, dt)
    if not Config.TargetMarkerEnabled or not targetHrp then
        TargetMarker_Hide()
        return
    end
    local img = TargetMarker_Ensure(targetHrp)
    if not img or not Cache.TargetMarkerBill then return end
    local size = math.clamp(math.floor(tonumber(Config.TargetMarkerSize) or 90), 30, 260)
    Cache.TargetMarkerBill.Size = UDim2.fromOffset(size, size)
    local col = Config.Color_TargetMarker or Color3.fromRGB(255, 80, 200)
    img.ImageColor3 = col
    img.ImageTransparency = math.clamp(tonumber(Config.TargetMarkerTransparency) or 0.15, 0, 1)
    if Config.TargetMarkerRotate then
        local spd = tonumber(Config.TargetMarkerRotateSpeed) or 90
        Cache.TargetMarkerRot = (Cache.TargetMarkerRot or 0) + (dt or 0.016) * spd
        img.Rotation = Cache.TargetMarkerRot % 360
    end
end


function TargetDot_Hide()
    pcall(function()
        if Cache.TargetDotBill then Cache.TargetDotBill:Destroy() end
    end)
    Cache.TargetDotBill = nil
    Cache.TargetDotFrame = nil
    Cache.TargetDotAdornee = nil
end

function TargetDot_GetClosestHrp()
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end
    local best, bestDist = nil, 1e9
    for _, plr in ipairs(CachedPlayerList or Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if Config.TeamCheckerEnabled and IsTeammate and IsTeammate(plr) then continue end
        local char = plr.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then continue end
        if char:GetAttribute("Dead") == true then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
        if not hrp then continue end
        local d = (hrp.Position - myHrp.Position).Magnitude
        if d < bestDist then
            bestDist = d
            best = hrp
        end
    end
    return best
end

function TargetDot_Ensure(adornee)
    if Cache.TargetDotBill and Cache.TargetDotBill.Parent and Cache.TargetDotAdornee == adornee then
        return Cache.TargetDotFrame
    end
    TargetDot_Hide()
    if not adornee then return nil end
    local bill = Instance.new("BillboardGui")
    bill.Name = "AnxiumTargetDot"
    bill.AlwaysOnTop = true
    bill.LightInfluence = 0
    bill.MaxDistance = 900
    bill.Size = UDim2.fromOffset(28, 28)
    bill.StudsOffset = Vector3.new(0, 0.25, 0)
    bill.Adornee = adornee
    bill.Parent = adornee
    
    local f = Instance.new("Frame")
    f.Name = "Ring"
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.fromScale(0.5, 0.5)
    f.Size = UDim2.fromScale(1, 1)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.Parent = bill
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = f
    local st = Instance.new("UIStroke")
    st.Name = "RingStroke"
    st.Color = Config.Color_TargetDot or Color3.fromRGB(120, 220, 255)
    st.Thickness = 2.2
    st.Transparency = math.clamp(tonumber(Config.TargetDotTransparency) or 0.1, 0, 0.9)
    st.Parent = f
    Cache.TargetDotBill = bill
    Cache.TargetDotFrame = f
    Cache.TargetDotAdornee = adornee
    return f
end

function TargetDot_Update()
    if not Config.TargetDotEnabled then
        TargetDot_Hide()
        return
    end
    local targetHrp = TargetDot_GetClosestHrp()
    if not targetHrp then
        TargetDot_Hide()
        return
    end
    local f = TargetDot_Ensure(targetHrp)
    if not f or not Cache.TargetDotBill then return end
    local size = math.clamp(math.floor(tonumber(Config.TargetDotSize) or 28), 10, 120)
    Cache.TargetDotBill.Size = UDim2.fromOffset(size, size)
    local col = Config.Color_TargetDot or Color3.fromRGB(120, 220, 255)
    local st = f:FindFirstChild("RingStroke")
    if st then
        st.Color = col
        st.Transparency = math.clamp(tonumber(Config.TargetDotTransparency) or 0.1, 0, 0.9)
        st.Thickness = math.clamp(size / 14, 1.5, 4)
    end
    f.BackgroundTransparency = 1
end


function TargetRing_Hide()
    pcall(function()
        if Cache.TargetRingModel then
            Cache.TargetRingModel:Destroy()
        end
    end)
    Cache.TargetRingModel = nil
    Cache.TargetRingSegs = {}
end

function TargetRing_Ensure(segments)
    segments = math.clamp(math.floor(tonumber(segments) or 40), 16, 64)
    if Cache.TargetRingModel and Cache.TargetRingModel.Parent and #Cache.TargetRingSegs == segments then
        return Cache.TargetRingModel, Cache.TargetRingSegs
    end
    TargetRing_Hide()
    local model = Instance.new("Model")
    model.Name = "AnxiumTargetScanRing"
    model.Parent = Workspace
    local segs = {}
    local col = Config.Color_TargetRing or Color3.fromRGB(120, 220, 255)
    local thick = math.clamp(tonumber(Config.TargetRingThickness) or 0.16, 0.05, 0.5)
    for i = 1, segments do
        local p = Instance.new("Part")
        p.Name = "Seg"
        p.Anchored = true
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.CastShadow = false
        p.Material = Enum.Material.Neon
        p.Color = col
        p.Transparency = 0.12
        p.Size = Vector3.new(0.4, 0.03, thick)
        p.Parent = model
        segs[i] = p
    end
    Cache.TargetRingModel = model
    Cache.TargetRingSegs = segs
    return model, segs
end

function TargetRing_Update(targetHrp, dt)
    if not Config.TargetRingEnabled or not targetHrp then
        TargetRing_Hide()
        return
    end
    local char = targetHrp.Parent
    if not char then TargetRing_Hide() return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then TargetRing_Hide() return end

    local segsN = math.clamp(math.floor(tonumber(Config.TargetRingSegments) or 40), 16, 64)
    local _, segs = TargetRing_Ensure(segsN)
    local radius = math.clamp(tonumber(Config.TargetRingRadius) or 2.2, 0.5, 8)
    local thick = math.clamp(tonumber(Config.TargetRingThickness) or 0.16, 0.05, 0.5)
    local speed = math.clamp(tonumber(Config.TargetRingSpeed) or 1.2, 0.05, 8)
    local col = Config.Color_TargetRing or Color3.fromRGB(120, 220, 255)

    local topY = (head and head.Position.Y or (targetHrp.Position.Y + 1.5)) + 0.35
    local botY = targetHrp.Position.Y - 3.0
    if char:FindFirstChild("UpperTorso") then
        botY = targetHrp.Position.Y - 3.15
    else
        botY = targetHrp.Position.Y - 2.95
    end
    if topY < botY then topY, botY = botY, topY end

    
    Cache.TargetRingPhase = (Cache.TargetRingPhase or 0) + (dt or 0.016) * speed
    Cache._trFrame = (Cache._trFrame or 0) + 1
    if Cache._trFrame % 2 == 1 then return end
    local cycle = Cache.TargetRingPhase % 2
    local t = (cycle <= 1) and cycle or (2 - cycle)
    local y = topY + (botY - topY) * t
    local cx, cz = targetHrp.Position.X, targetHrp.Position.Z
    local segLen = (2 * math.pi * radius / segsN) * 1.45
    local size = Vector3.new(segLen, 0.03, thick)
    local parts, cfs = table.create(segsN), table.create(segsN)
    local n = 0
    local pi2 = math.pi * 2
    for i = 1, segsN do
        local part = segs[i]
        if part then
            local angle = (i / segsN) * pi2
            n = n + 1
            parts[n] = part
            cfs[n] = CFrame.new(cx + math.cos(angle) * radius, y, cz + math.sin(angle) * radius)
                * CFrame.Angles(0, -(angle + math.pi * 0.5), 0)
            if Cache._trLastCol ~= col then part.Color = col end
            if Cache._trLastSize ~= size then part.Size = size end
            if Cache._trLastTrans ~= 0.1 then part.Transparency = 0.1 end
        end
    end
    Cache._trLastCol = col
    Cache._trLastSize = size
    Cache._trLastTrans = 0.1
    if n > 0 then
        local ok = pcall(function()
            Workspace:BulkMoveTo(parts, cfs, Enum.BulkMoveMode.FireCFrameChanged)
        end)
        if not ok then
            for i = 1, n do parts[i].CFrame = cfs[i] end
        end
    end
end


task.spawn(function()
    while true do
        task.wait(12)
        pcall(function()
            if Cache.KillHandledHum then
                for hum in pairs(Cache.KillHandledHum) do
                    if not hum or not hum.Parent then
                        Cache.KillHandledHum[hum] = nil
                    end
                end
            end
            if Cache.ChamsVisCache then
                for plr in pairs(Cache.ChamsVisCache) do
                    if typeof(plr) == "Instance" and not plr.Parent then
                        Cache.ChamsVisCache[plr] = nil
                    end
                end
            end
            if Cache.RecentDamageTargets then
                local now = tick()
                for plr, t in pairs(Cache.RecentDamageTargets) do
                    if (now - (t or 0)) > 8 then
                        Cache.RecentDamageTargets[plr] = nil
                    end
                end
            end
            if Cache.BulletTracers and #Cache.BulletTracers > 12 then
                while #Cache.BulletTracers > 12 do
                    local e = table.remove(Cache.BulletTracers, 1)
                    if e then
                        pcall(function() if e.Beam then e.Beam:Destroy() end end)
                        pcall(function() if e.A0 then e.A0:Destroy() end end)
                        pcall(function() if e.A1 then e.A1:Destroy() end end)
                    end
                end
            end
            local jc = Workspace:FindFirstChild("AnxiumJumpCircles")
            if jc then
                local kids = jc:GetChildren()
                while #kids > 4 do
                    pcall(function() kids[1]:Destroy() end)
                    table.remove(kids, 1)
                end
            end
            if Cache.KillLogContainer then
                local logs = {}
                for _, ch in ipairs(Cache.KillLogContainer:GetChildren()) do
                    if ch.Name == "KillLog" or ch.Name == "HitLog" then logs[#logs + 1] = ch end
                end
                while #logs > 6 do
                    pcall(function() logs[1]:Destroy() end)
                    table.remove(logs, 1)
                end
            end
        end)
    end
end)


do
    local bannerUrl = "https://raw.githubusercontent.com/yyaaggaa773-pixel/yuuytuytffuytftyu/main/banner.txt"
    local body = nil
    pcall(function()
        body = game:HttpGet(bannerUrl)
    end)
    if type(body) ~= "string" or body == "" then
        pcall(function()
            if syn and syn.request then
                local r = syn.request({ Url = bannerUrl, Method = "GET" })
                if r and r.Body then body = r.Body end
            elseif http_request then
                local r = http_request({ Url = bannerUrl, Method = "GET" })
                if r and r.Body then body = r.Body end
            elseif request then
                local r = request({ Url = bannerUrl, Method = "GET" })
                if r and r.Body then body = r.Body end
            end
        end)
    end
    if type(body) == "string" and #body > 0 then
        for line in string.gmatch(body, "[^\r\n]+") do
            print(line)
        end
    end
end
