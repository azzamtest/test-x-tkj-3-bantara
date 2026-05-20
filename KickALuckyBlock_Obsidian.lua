local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local KickRE = RS:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("rev_KickEvent")
local CollectRE = RS:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("rev_KickCollect")
local UpgradeLvRE = RS:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("rev_B_Upgrade")
local CollectCashRE = RS:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("rev_B_Collect")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- // MODULES
local CashVFX = require(RS.Modules.ServicesLoader.VFXService.CashVFX)

--// LOAD UI — Obsidian
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Toggles = Library.Toggles
local Options = Library.Options

--// MOBILE SUPPORT (built-in Obsidian)
Library.ShowToggleFrameInKeybinds = true

--// WINDOW
local Window = Library:CreateWindow({
    Title = "KEY | K A L B",
    Footer = "Majek Hub",
    ToggleKeybind = Enum.KeyCode.LeftControl,
    Center = true,
    AutoShow = true,
    ShowCustomCursor = false,
    MobileButtonsSide = "Left",
    NotifySide = "Right",
})

--// TABS
local MainTab     = Window:AddTab("Main",     "zap")
local TeleportTab = Window:AddTab("Teleport", "navigation")
local MiscTab     = Window:AddTab("Misc",     "dollar-sign")
local SettingsTab = Window:AddTab("Settings", "settings")

--// GROUPBOXES — Main Tab
local MainLeft  = MainTab:AddLeftGroupbox("Auto Features")
local MainRight = MainTab:AddRightGroupbox("Settings")

--// GROUPBOXES — Teleport Tab
local TpLeft = TeleportTab:AddLeftGroupbox("Teleport Locations")

--// GROUPBOXES — Misc Tab
local MiscLeft  = MiscTab:AddLeftGroupbox("Cash")
local MiscRight = MiscTab:AddRightGroupbox("Actions")

--// Settings Tab — groupbox dibuat otomatis oleh ThemeManager & SaveManager

--// BRAINROTS DATA
local Brainrots = {
    ["Noobini Pizzanini"]          = { Rarity = "Common",    CPS = "2" },
    ["Lirili Larila"]              = { Rarity = "Common",    CPS = "3" },
    ["Tim Cheese"]                 = { Rarity = "Common",    CPS = "3" },
    ["Talpa Di Fero"]              = { Rarity = "Common",    CPS = "4" },
    ["Svinina Bombardino"]         = { Rarity = "Common",    CPS = "5" },
    ["Pipi Kiwi"]                  = { Rarity = "Common",    CPS = "6" },
    ["Fruli Frula"]                = { Rarity = "Common",    CPS = "7" },
    ["Trippi Troppi"]              = { Rarity = "Common",    CPS = "7" },
    ["Gangster Footera"]           = { Rarity = "Rare",      CPS = "15" },
    ["Bobrito Bandito"]            = { Rarity = "Rare",      CPS = "17" },
    ["Boneca Ambalabu"]            = { Rarity = "Rare",      CPS = "17" },
    ["Ta Ta Ta Ta Sahur"]          = { Rarity = "Rare",      CPS = "18" },
    ["Ballerina Cappuccina"]       = { Rarity = "Rare",      CPS = "19" },
    ["Cappuccino Assassino"]       = { Rarity = "Rare",      CPS = "22" },
    ["Brr Brr Patapim"]            = { Rarity = "Rare",      CPS = "22" },
    ["Cacto Hipopotamo"]           = { Rarity = "Rare",      CPS = "26" },
    ["Garamararam"]                = { Rarity = "Epic",      CPS = "40" },
    ["Madung"]                     = { Rarity = "Epic",      CPS = "44" },
    ["Waterdino"]                  = { Rarity = "Epic",      CPS = "50" },
    ["Pesto Mortioni"]             = { Rarity = "Epic",      CPS = "52" },
    ["Pannaburro"]                 = { Rarity = "Epic",      CPS = "62" },
    ["Orcalero"]                   = { Rarity = "Epic",      CPS = "64" },
    ["Mangolini Parrocini"]        = { Rarity = "Epic",      CPS = "64" },
    ["John Pork"]                  = { Rarity = "Epic",      CPS = "72" },
    ["Gattatino Nyanino"]          = { Rarity = "Epic",      CPS = "76" },
    ["Chimpanzini Bananini"]       = { Rarity = "Legendary", CPS = "100" },
    ["Plan Red"]                   = { Rarity = "Legendary", CPS = "130" },
    ["Plan Blue"]                  = { Rarity = "Legendary", CPS = "140" },
    ["Capi Taco"]                  = { Rarity = "Legendary", CPS = "150" },
    ["Trulimero Trulicina"]        = { Rarity = "Legendary", CPS = "160" },
    ["Bambini Crostini"]           = { Rarity = "Legendary", CPS = "160" },
    ["Elefantucci Bananucci"]      = { Rarity = "Legendary", CPS = "170" },
    ["Bananita Dolphinita"]        = { Rarity = "Legendary", CPS = "210" },
    ["Salamino Pinguino"]          = { Rarity = "Legendary", CPS = "230" },
    ["Penguino Cocosino"]          = { Rarity = "Mythic",    CPS = "450" },
    ["67"]                         = { Rarity = "Mythic",    CPS = "500" },
    ["Burbaloni Luliloli"]         = { Rarity = "Mythic",    CPS = "550" },
    ["Chef Crabracadabra"]         = { Rarity = "Mythic",    CPS = "600" },
    ["Capybara Eggplant"]          = { Rarity = "Mythic",    CPS = "650" },
    ["Bangello"]                   = { Rarity = "Mythic",    CPS = "725" },
    ["Elefanto Frigo"]             = { Rarity = "Mythic",    CPS = "775" },
    ["Rinooccio Verdini"]          = { Rarity = "Mythic",    CPS = "880" },
    ["Glorbo Fruttodrillo"]        = { Rarity = "Mythic",    CPS = "920" },
    ["Udin Din Din Dun"]           = { Rarity = "Godly",     CPS = "1850" },
    ["Pandaccini Bananini"]        = { Rarity = "Godly",     CPS = "2000" },
    ["Octopusini Bluberini"]       = { Rarity = "Godly",     CPS = "2150" },
    ["Strawberelli Flamingelli"]   = { Rarity = "Godly",     CPS = "2300" },
    ["Sigma Boy"]                  = { Rarity = "Godly",     CPS = "2450" },
    ["Frigo Camelo"]               = { Rarity = "Godly",     CPS = "2600" },
    ["Orangutini Ananasini"]       = { Rarity = "Godly",     CPS = "2700" },
    ["Rhino Toasterino"]           = { Rarity = "Godly",     CPS = "2950" },
    ["Bombardiro Crocodilo"]       = { Rarity = "Godly",     CPS = "3100" },
    ["Bombini Gusini"]             = { Rarity = "Secret",    CPS = "4750" },
    ["Tuff Toucan"]                = { Rarity = "Secret",    CPS = "5300" },
    ["Fryuro"]                     = { Rarity = "Secret",    CPS = "5850" },
    ["Burguro"]                    = { Rarity = "Secret",    CPS = "6250" },
    ["Guest666"]                   = { Rarity = "Secret",    CPS = "7000" },
    ["Zibra Zubra Zibralini"]      = { Rarity = "Secret",    CPS = "7750" },
    ["Cavallo Virtuso"]            = { Rarity = "Secret",    CPS = "8500" },
    ["Gorillo Watermelondrillo"]   = { Rarity = "Secret",    CPS = "9500" },
    ["Cocofanto Elefanto"]         = { Rarity = "Secret",    CPS = "10000" },
    ["Girafa Celeste"]             = { Rarity = "Divine",    CPS = "16500" },
    ["Tralalero Tralala"]          = { Rarity = "Divine",    CPS = "17500" },
    ["Tralalerita Tralala"]        = { Rarity = "Divine",    CPS = "18000" },
    ["Peant Jarro"]                = { Rarity = "Divine",    CPS = "19500" },
    ["Dipperi Chiperini"]          = { Rarity = "Divine",    CPS = "20000" },
    ["Rexosaurus"]                 = { Rarity = "Divine",    CPS = "22500" },
    ["1x1x1x1"]                    = { Rarity = "Divine",    CPS = "23000" },
    ["Matteo"]                     = { Rarity = "Divine",    CPS = "25000" },
    ["Espresso Signora"]           = { Rarity = "Divine",    CPS = "27500" },
    ["Alessio"]                    = { Rarity = "Hacked",    CPS = "27500" },
    ["Tripi Tropi Tropa Tripa"]    = { Rarity = "Hacked",    CPS = "28000" },
    ["SWAG SODA"]                  = { Rarity = "Hacked",    CPS = "29000" },
    ["Stoppo Luminino"]            = { Rarity = "Hacked",    CPS = "30000" },
    ["Torrtuginni Dragonfrutini"]  = { Rarity = "Hacked",    CPS = "32000" },
    ["Tictac Sahur"]               = { Rarity = "Hacked",    CPS = "38000" },
    ["Los Primos Blue"]            = { Rarity = "Hacked",    CPS = "44500" },
    ["Cactus Pingu"]               = { Rarity = "Hacked",    CPS = "44500" },
    ["La Vacca Saturno Saturnita"] = { Rarity = "Hacked",    CPS = "49500" },
    ["Agarrini La Palini"]         = { Rarity = "Hacked",    CPS = "53500" },
    ["Karkerkar Kurkur"]           = { Rarity = "OG",        CPS = "120000" },
    ["Blackhole Goat"]             = { Rarity = "OG",        CPS = "125000" },
    ["Cappuccino Clownino"]        = { Rarity = "OG",        CPS = "135000" },
    ["Compactoroni Diskaloni"]     = { Rarity = "OG",        CPS = "135000" },
    ["Nuclearo Dinossauro"]        = { Rarity = "OG",        CPS = "190000" },
    ["Chillin Chilli"]             = { Rarity = "OG",        CPS = "220000" },
    ["Crazylone Pizaione"]         = { Rarity = "OG",        CPS = "225000" },
    ["Corn Sahur"]                 = { Rarity = "OG",        CPS = "225000" },
    ["Meowl"]                      = { Rarity = "OG",        CPS = "275000" },
    ["Strawberry Elephant"]        = { Rarity = "OG",        CPS = "420000" },
    ["Dragon Cannelloni"]          = { Rarity = "Exclusive", CPS = "0" },
    ["W"]                          = { Rarity = "Exclusive", CPS = "0" },
    ["Spaghetti Tualetti"]         = { Rarity = "Exclusive", CPS = "0" },
    ["Esok Sekolah"]               = { Rarity = "Exclusive", CPS = "0" },
    ["Bambu Sahur"]                = { Rarity = "Exclusive", CPS = "12500" },
    ["Bottellini"]                 = { Rarity = "Exclusive", CPS = "75000" },
    ["Castlino Fortini"]           = { Rarity = "Exclusive", CPS = "5000" },
    ["Ketchuru Matsuru"]           = { Rarity = "Exclusive", CPS = "800000" },
    ["Los Nooo My Hotspotsitos"]   = { Rarity = "Exclusive", CPS = "200000" },
    ["W or L"]                     = { Rarity = "Exclusive", CPS = "15000" },
    ["Dragonfrutina Dolphinita"]   = { Rarity = "Celestial", CPS = "475000" },
    ["Guerriro Digitale"]          = { Rarity = "Celestial", CPS = "490000" },
    ["Chicleteira Bicicleteira"]   = { Rarity = "Celestial", CPS = "500000" },
    ["Pot Hotspot"]                = { Rarity = "Celestial", CPS = "525000" },
    ["Krupuk Pagi Pagi"]           = { Rarity = "Celestial", CPS = "540000" },
    ["Beluga Beluga"]              = { Rarity = "Celestial", CPS = "575000" },
    ["Tralaledon"]                 = { Rarity = "Celestial", CPS = "625000" },
    ["Anpali Babel"]               = { Rarity = "Celestial", CPS = "750000" },
    ["Mastodontico Telepiedone"]   = { Rarity = "Celestial", CPS = "850000" },
    ["Ketupat Kepat"]              = { Rarity = "Celestial", CPS = "1000000" },
}

--// RARITY COLORS
local RarityColors = {
    Common    = Color3.fromRGB(156, 163, 175),
    Rare      = Color3.fromRGB(59,  130, 246),
    Epic      = Color3.fromRGB(168,  85, 247),
    Legendary = Color3.fromRGB(245, 158,  11),
    Mythic    = Color3.fromRGB(239,  68,  68),
    Godly     = Color3.fromRGB(6,   182, 212),
    Secret    = Color3.fromRGB(220,  38,  38),
    Divine    = Color3.fromRGB(147, 197, 253),
    Hacked    = Color3.fromRGB(16,  185, 129),
    OG        = Color3.fromRGB(249, 115,  22),
    Exclusive = Color3.fromRGB(236,  72, 153),
    Celestial = Color3.fromRGB(255, 255, 255),
}

--// STATE
local autoClickBonus = false
local bonusConnections = {}
local autoKick = false
local kickConnections = {}
local autoFarmBlock = false
local farmConnection = nil
local autoCollectCash = false
local collectCashConnection = nil
local customSpeed = 50  -- selalu aktif, auto apply langsung
local currentTween = nil
local isWalking = false
local selectedMutation = {["Any"] = true}  -- format dictionary sesuai Obsidian OnChanged
local selectedRarity   = {["Any"] = true}  -- "Any" = loloskan semua rarity
local infoPanelActive = false
local infoPanelConn = nil
local currentPet = nil  -- Model pet yang sedang di-weld ke HumanoidRootPart karakter

--// PREDICTED PET — dari attribute InGame di LocalPlayer setelah kick
local predictedPetName = nil     -- string: nama pet, e.g. "67"
local predictedMutation = nil    -- string: mutasi, e.g. "Plasma"
local inGameAttrConn = nil       -- koneksi listener attribute InGame

local KickArea = workspace.Areas.KickReady
local MutationsList = {"Any","None","Golden","Diamond","Plasma","Molten","Radioactive","Shadow","Electrified","Rainbow","Virus"}
local RarityList    = {"Any","Common","Rare","Epic","Legendary","Mythic","Godly","Secret","Divine","Hacked","OG","Exclusive","Celestial"}

local kickCF = CFrame.new(
    699.768311, 3.00000691, 231.199585,
    5.44999337e-15, -1.24774999e-08, 1,
    2.27413449e-10, 1, 1.24774999e-08,
    -1, 2.27413449e-10, 5.45283093e-15
)
local WeightShop = CFrame.new(
    730.311829, 3.10000825, 193.675735,
    0.222229362, -9.29465216e-08, 0.974994421,
    9.4676281e-08, 1, 7.37508543e-08,
    -0.974994421, 7.59192389e-08, 0.222229362
)
local SpeedUpgrade = CFrame.new(
    730.760864, 3.00000691, 268.084991,
    -0.20107615, -4.26971773e-08, 0.979575634,
    -1.04490127e-07, 1, 2.21388774e-08,
    -0.979575634, -9.79043762e-08, -0.20107615
)
local SellStand = CFrame.new(
    731.449951, 3.1000061, 328.038605,
    -0.737040341, 2.73796763e-09, 0.675848722,
    1.44397394e-09, 1, -2.47644261e-09,
    -0.675848722, -8.49330106e-10, -0.737040341
)

--// ================= UI ELEMENTS =================

-- Main Left — Auto Features
MainLeft:AddToggle("Auto", {
    Text    = "Auto Bonus",
    Default = false,
    Tooltip = "Auto 2x (Bonus) while training",
})

MainLeft:AddToggle("AutoKick", {
    Text    = "Auto Kick",
    Default = false,
    Tooltip = "Auto kick when bar is full",
})

MainLeft:AddToggle("AutoFarm", {
    Text    = "Auto Farm",
    Default = false,
    Tooltip = "Auto farm block (Auto Kick harus ON)",
})

--// CUSTOM SPEED — input saja, langsung apply tanpa toggle
MainLeft:AddInput("CustomSpeedInput", {
    Text        = "Move Speed",
    Default     = "50",
    Placeholder = "Enter speed (default: 50)",
    Numeric     = true,
    Tooltip     = "Langsung terapkan ke karakter saat diubah",
})

MainLeft:AddButton({
    Text = "Teleport to Kick Zone",
    Func = function()
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(699.971252, 3.00000715, 307.285217,
            0.0240840334, -2.75321117e-08, 0.999709964,
            -2.08743902e-08, 1, 2.80429848e-08,
            -0.999709964, -2.15437232e-08, 0.0240840334)
    end,
})

-- Main Right — Mutation Filter
MainRight:AddDropdown("Mut", {
    Text    = "Mutation Filter",
    Values  = MutationsList,
    Multi   = true,
    Default = {"Any"},
    Tooltip = "Pilih 'Any' = loloskan semua mutation | Pilih spesifik = hanya mutation itu yang diproses",
})

MainRight:AddDropdown("Rar", {
    Text    = "Rarity Filter",
    Values  = RarityList,
    Multi   = true,
    Default = {"Any"},
    Tooltip = "Pilih 'Any' = loloskan semua rarity | Pilih spesifik = hanya rarity itu yang diproses",
})

MainRight:AddDivider()

MainRight:AddToggle("InfoPanel", {
    Text    = "Info Panel",
    Default = false,
    Tooltip = "Tampilkan panel info pet (Nama, Rarity, CPS) — draggable & support mobile",
})

-- Teleport Left
TpLeft:AddButton({
    Text = "Weight Shop",
    Func = function()
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = WeightShop
    end,
})

TpLeft:AddButton({
    Text = "Run Upgrades (Speed)",
    Func = function()
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = SpeedUpgrade
    end,
})

TpLeft:AddButton({
    Text = "Sell Stand",
    Func = function()
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = SellStand
    end,
})

-- Misc Left
MiscLeft:AddToggle("AutoCollect", {
    Text    = "Auto Collect Cash",
    Default = false,
    Tooltip = "Collect cash setiap 3 menit otomatis",
})

-- Misc Right
MiscRight:AddButton({
    Text = "Collect Cash Now",
    Func = function()
        collectCash()
    end,
})

--// ================= SETTINGS TAB =================
local MenuGroup = Tabs.Settings:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Text    = "Open Keybind Menu",
    Default = Library.KeybindFrame and Library.KeybindFrame.Visible or false,
    Callback = function(value)
        if Library.KeybindFrame then
            Library.KeybindFrame.Visible = value
        end
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text    = "Custom Cursor",
    Default = true,
    Callback = function(value)
        Library.ShowCustomCursor = value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Text     = "Notification Side",
    Values   = {"Left", "Right"},
    Default  = "Right",
    Callback = function(value)
        Library:SetNotifySide(value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Text     = "DPI Scale",
    Values   = {"50%", "75%", "100%", "125%", "150%", "175%", "200%"},
    Default  = "100%",
    Callback = function(value)
        Library:SetDPIScale(tonumber(value:gsub("%%", "")))
    end,
})

MenuGroup:AddDivider()

MenuGroup:AddButton({
    Text    = "Unload Script",
    Func    = function() Library:Unload() end,
    Tooltip = "Remove script from game",
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(SettingsTab)

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("MajekHub/KickLuckyBlock")
SaveManager:BuildConfigSection(SettingsTab)

--// ================= FUNCTIONS =================

--// CLEAR BONUS CONNECTIONS
local function clearConnections()
    for _, conn in ipairs(bonusConnections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    table.clear(bonusConnections)
end

--// CLICK SCREEN
local function clickScreen()
    local x = 12.5
    local y = 20
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

--// GET MY PLOT
local function getMyPlots()
    for i, v in pairs(workspace.Plots:GetChildren()) do
        if v:IsA("Model") and v:GetAttribute("Owner") == player.Name then
            return v
        end
    end
    return nil
end

--// AUTO COLLECT CASH
function collectCash()
    local MyPlotModel = getMyPlots()
    if not MyPlotModel then return false end

    local Buttons = MyPlotModel:FindFirstChild("Buttons")
    if not Buttons then return false end

    local totalButtons = #Buttons:GetChildren()
    local collected = 0

    for numberIndex = 1, totalButtons do
        local buttonPart = Buttons:FindFirstChild("Slot" .. numberIndex)
        if buttonPart then
            CollectCashRE:FireServer(numberIndex)
            CashVFX(player.Character, buttonPart)
            collected = collected + 1
        end
        task.wait(0.5)
    end

    return collected > 0
end

local function startAutoCollectCash()
    if collectCashConnection then return end
    collectCashConnection = task.spawn(function()
        while autoCollectCash do
            task.wait(180)
            if autoCollectCash then
                collectCash()
            end
        end
    end)
end

local function stopAutoCollectCash()
    autoCollectCash = false
    collectCashConnection = nil
end

--// AUTO CLICK BONUS
local function setupBonusAutoClick()
    clearConnections()

    local kickGui = playerGui:WaitForChild("KickUpgrades")

    local function clickBonus(button)
        task.spawn(function()
            task.wait(0.2)
            local imgLabel = button:FindFirstChild("ImageLabel")
            local targets = {button}
            if imgLabel then table.insert(targets, imgLabel) end

            if getconnections then
                for _, target in pairs(targets) do
                    pcall(function()
                        for _, conn in pairs(getconnections(target.InputBegan)) do
                            conn:Fire({UserInputType = Enum.UserInputType.MouseButton1, UserInputState = Enum.UserInputState.Begin})
                            conn:Fire({UserInputType = Enum.UserInputType.Touch, UserInputState = Enum.UserInputState.Begin})
                        end
                    end)
                    pcall(function() for _, conn in pairs(getconnections(target.MouseButton1Down)) do conn:Fire() end end)
                    pcall(function() for _, conn in pairs(getconnections(target.MouseButton1Up)) do conn:Fire() end end)
                    pcall(function() for _, conn in pairs(getconnections(target.MouseButton1Click)) do conn:Fire() end end)
                    pcall(function() for _, conn in pairs(getconnections(target.Activated)) do conn:Fire() end end)
                end
            end
        end)
    end

    local function hookBonus(button)
        if button.Name ~= "Bonus" and button.Name ~= "PopBonus" then return end
        if button.Visible then
            if not button:GetAttribute("AutoClicked") then
                button:SetAttribute("AutoClicked", true)
                clickBonus(button)
            end
        else
            button:SetAttribute("AutoClicked", nil)
        end
    end

    for _, v in ipairs(kickGui:GetDescendants()) do
        hookBonus(v)
    end

    local addedConn = kickGui.DescendantAdded:Connect(function(v)
        task.wait()
        hookBonus(v)
    end)

    table.insert(bonusConnections, addedConn)
end

--// AUTO KICK
local function clearKickConnections()
    for _, conn in ipairs(kickConnections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    table.clear(kickConnections)
end

local function startAutoKick()
    clearKickConnections()

    pcall(function()
        local kickMinigame = playerGui:WaitForChild("KickMinigame")
        local bar = kickMinigame:WaitForChild("Bar")
        local movingBar = bar:WaitForChild("MovingBar")
        kickMinigame.Charging.Visible = false
        kickMinigame.Charging.UIStroke.Transparency = 0.9
        bar.BackgroundTransparency = 1
        bar.UIStroke.Transparency = 0.9
        movingBar.UIStroke.Transparency=0.9
        for _, v in ipairs(bar:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("TextLabel") then
                pcall(function() v.BackgroundTransparency = 1 end)
                pcall(function() v.ImageTransparency = 1 end)
                pcall(function() v.TextTransparency = 1 end)
            end
        end
        local conn = movingBar:GetPropertyChangedSignal("Size"):Connect(function()
            if not autoKick then return end
            local size = movingBar.Size
            if size.X.Scale >= 1 and size.Y.Scale >= 1 then
                clickScreen()
            end
        end)
        table.insert(kickConnections, conn)
    end)

    pcall(function()
        local stadiumEvent = playerGui:WaitForChild("StadiumEvent")
        local bar = stadiumEvent:WaitForChild("Bar")
        local movingBar = bar:WaitForChild("MovingBar")
        stadiumEvent.Charging.Visible=false
        stadiumEvent.Charging.UIStroke.Transparency=0.9
        bar.BackgroundTransparency=1
        bar.UIStroke.Transparency=0.9
        movingBar.UIStroke.Transparency=0.9
        for _, v in ipairs(bar:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("TextLabel") then
                pcall(function() v.BackgroundTransparency = 1 end)
                pcall(function() v.ImageTransparency = 1 end)
                pcall(function() v.TextTransparency = 1 end)
            end
        end
        local conn = movingBar:GetPropertyChangedSignal("Size"):Connect(function()
            if not autoKick then return end
            local size = movingBar.Size
            if size.X.Scale >= 1 and size.Y.Scale >= 1 then
                clickScreen()
            end
        end)
        table.insert(kickConnections, conn)
    end)
end

local function stopAutoKick()
    clearKickConnections()
end

local function getModelMutation(Model)
    return Model:GetAttribute("Mutation")
end

local yOffset = 3

--// MOVE TO POSITION — langsung pakai customSpeed tanpa toggle
local function moveToPosition(targetPos, timeoutDuration)
    timeoutDuration = timeoutDuration or 10

    local char = player.Character
    if not char then return false end

    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return false end

    humanoid.WalkSpeed = customSpeed

    hrp.Anchored = true
    print("start moveTo with speed: " .. customSpeed)
    while hrp and hrp.Parent and humanoid and humanoid.Health > 0 do
        task.wait()
        local pos = hrp.Position
        local targetVec = Vector3.new(targetPos.X, yOffset, targetPos.Z)
        local diff = targetVec - pos
        if diff.Magnitude < 2 then
            hrp.CFrame = CFrame.new(targetVec)
            break
        end
        local dt = task.wait()
        local step = customSpeed * dt
        if step > diff.Magnitude then step = diff.Magnitude end
        hrp.CFrame = CFrame.new(pos + diff.Unit * step)
    end

    if hrp and hrp.Parent then
        hrp.Anchored = false
    end

    return (hrp.Position - Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)).Magnitude < 5
end

--// WAVEBLOCKER
local function createWaveblocker(root)
    if not root or not root.Parent then return nil end

    local rootSize = root.Size
    local waveblocker = Instance.new("Part")
    waveblocker.Name = "Waveblocker"
    waveblocker.Size = Vector3.new(rootSize.X + 30, rootSize.Y + 50, rootSize.Z + 100)
    waveblocker.CanCollide = true
    waveblocker.Transparency = 1
    waveblocker.CFrame = root.CFrame
    waveblocker.Parent = workspace

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = root
    weld.Part1 = waveblocker
    weld.Parent = waveblocker

    return waveblocker
end

local function removePlatform(platform)
    if platform and platform.Parent then
        platform:Destroy()
    end
end

--// AUTO FARM
local wavePlatform = nil

local function startAutoFarm()
    if farmConnection then return end

    farmConnection = task.spawn(function()
        local waves = workspace:WaitForChild("Waves")

        while autoFarmBlock do
            pcall(function()
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum  = char and char:FindFirstChild("Humanoid")
                if not (root and hum and hum.Health > 0) then return end

                -- Pastikan berada di kick zone
                if (root.Position - kickCF.Position).Magnitude > 5 then
                    root.CFrame = kickCF + Vector3.new(0, 5, 0)
                    task.wait(0.1)
                end

                local kickBtn = playerGui:WaitForChild("HUD"):WaitForChild("KickButton")
                local newWave = nil

                -- Dengarkan ChildAdded sebelum mulai loop kick
                local waveConn = waves.ChildAdded:Connect(function(child)
                    newWave = child
                end)

                -- Loop terus tekan KickButton sampai wave muncul
                while autoFarmBlock and not newWave do
                    if kickBtn and getconnections then
                        pcall(function()
                            for _, c in pairs(getconnections(kickBtn.Activated)) do
                                c:Fire()
                            end
                        end)
                    end
                    task.wait(0.15)
                end
                waveConn:Disconnect()

                if not autoFarmBlock or not newWave then return end
                task.wait(0.05)

                -- Gunakan pet yang sudah terdeteksi via Weld di HumanoidRootPart
                local MyPet = currentPet

                -- Ambil root part dari wave
                local root_wave
                if newWave:IsA("Model") then
                    root_wave = newWave:FindFirstChild("Root") or newWave.PrimaryPart
                elseif newWave:IsA("BasePart") then
                    root_wave = newWave
                end

                if root_wave then
                    if wavePlatform then
                        removePlatform(wavePlatform)
                        wavePlatform = nil
                    end

                    if MyPet then
                        local mutation = getModelMutation(MyPet)

                        -- Cek rarity dari tabel Brainrots (bukan attribute game)
                        local petData   = Brainrots[MyPet.Name]
                        local petRarity = petData and petData.Rarity or nil

                        -- Kedua filter harus lolos (AND)
                        local mutPass = selectedMutation["Any"] or selectedMutation[mutation]
                        local rarPass = selectedRarity["Any"]   or (petRarity and selectedRarity[petRarity])
                        local isSelected = mutPass and rarPass

                        if isSelected then
                            print("[AutoFarm] Match: " .. tostring(mutation) .. " / " .. tostring(petRarity) .. " — completing wave")
                            wavePlatform = createWaveblocker(root_wave)
                            moveToPosition(KickArea.Position, 18)
                        else
                            print("[AutoFarm] Skip: " .. tostring(mutation) .. " / " .. tostring(petRarity) .. " — resetting wave")
                            moveToPosition(root_wave.Position, 18)
                        end
                    end

                    repeat task.wait() until #waves:GetChildren() == 0
                    if not autoFarmBlock then return end

                    if wavePlatform then
                        removePlatform(wavePlatform)
                        wavePlatform = nil
                    end
                end
            end)

            task.wait(0.1)
        end
    end)
end


local function stopAutoFarm()
    autoFarmBlock = false
    farmConnection = nil
    isWalking = false
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end

--// ================= TOGGLE / OPTION HANDLERS =================

Toggles["Auto"]:OnChanged(function(v)
    autoClickBonus = v
    if v then
        setupBonusAutoClick()
    else
        clearConnections()
    end
end)

Toggles["AutoKick"]:OnChanged(function(v)
    autoKick = v
    if v then
        startAutoKick()
    else
        stopAutoKick()
    end
end)

Toggles["AutoFarm"]:OnChanged(function(v)
    autoFarmBlock = v
    if v then
        startAutoFarm()
    else
        stopAutoFarm()
    end
end)

--// WALK SPEED — auto apply ke Humanoid saat input berubah, tanpa toggle
Options["CustomSpeedInput"]:OnChanged(function(v)
    local numValue = tonumber(v)
    if numValue and numValue > 0 then
        customSpeed = numValue
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = customSpeed
        end
        print("Speed applied: " .. customSpeed)
    end
end)

Options["Mut"]:OnChanged(function(v)
    selectedMutation = v

    if v["Any"] then
        local hasOther = false
        for _, name in ipairs(MutationsList) do
            if name ~= "Any" and v[name] then
                hasOther = true
                break
            end
        end
        if hasOther then
            Options["Mut"]:SetValue({ ["Any"] = true })
        end
    end
end)

Options["Rar"]:OnChanged(function(v)
    -- "Any" bukan rarity sungguhan — jika dipilih, loloskan semua rarity
    selectedRarity = v
end)

Toggles["AutoCollect"]:OnChanged(function(v)
    autoCollectCash = v
    if v then
        startAutoCollectCash()
    else
        stopAutoCollectCash()
    end
end)

--// ================= INFO PANEL =================

--// Format angka: 1000000 → "1,000,000"
local function formatCPS(raw)
    local n = tonumber(raw) or 0
    local s = tostring(math.floor(n))
    return s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

--// ================= PET PREDICTION VIA InGame ATTRIBUTE =================
-- Format attribute InGame: "NamaPet,Mutasi" contoh: "67,Plasma" atau "Chimpanzini Bananini,None"

local function parseInGameAttr(raw)
    if not raw or raw == "" then return nil, nil end
    local comma = raw:find(",")
    if comma then
        local name = raw:sub(1, comma - 1)
        local mut  = raw:sub(comma + 1)
        return name, mut
    end
    return raw, nil
end

local function onInGameAttrChanged()
    local raw = player:GetAttribute("InGame")
    if raw and raw ~= "" then
        local name, mut = parseInGameAttr(raw)
        predictedPetName = name
        predictedMutation = mut or "None"
        updateInfoPanel()
    else
        predictedPetName = nil
        predictedMutation = nil
        updateInfoPanel()
    end
end

local function startPredictionListener()
    if inGameAttrConn then inGameAttrConn:Disconnect() end
    -- Baca nilai awal
    onInGameAttrChanged()
    -- Dengarkan perubahan attribute InGame
    inGameAttrConn = player:GetAttributeChangedSignal("InGame"):Connect(onInGameAttrChanged)
end

local function stopPredictionListener()
    if inGameAttrConn then
        inGameAttrConn:Disconnect()
        inGameAttrConn = nil
    end
    predictedPetName = nil
    predictedMutation = nil
end

--// Ambil nama pet — prioritas: predictedPetName (dari InGame attr) → currentPet (via Weld)
local function findMyPetName()
    -- Prioritas 1: prediksi dari attribute InGame LocalPlayer (real-time setelah kick)
    if predictedPetName and predictedPetName ~= "" and Brainrots[predictedPetName] then
        return predictedPetName
    end
    -- Fallback: pet yang terdeteksi via Weld di HumanoidRootPart
    if currentPet and currentPet.Parent and Brainrots[currentPet.Name] then
        return currentPet.Name
    end
    return nil
end

--// Buat Info Panel GUI
local infoPanelGui = nil

local MutationColors = {
    None         = Color3.fromRGB(160, 160, 160),
    Golden       = Color3.fromRGB(255, 200,  50),
    Diamond      = Color3.fromRGB(100, 210, 255),
    Plasma       = Color3.fromRGB(180,  80, 255),
    Molten       = Color3.fromRGB(255, 100,  30),
    Radioactive  = Color3.fromRGB(90,  220,  60),
    Shadow       = Color3.fromRGB(100,  60, 180),
    Electrified  = Color3.fromRGB(255, 230,  50),
    Rainbow      = Color3.fromRGB(255, 140, 200),
    Virus        = Color3.fromRGB(60,  200,  80),
}

local function makeBadge(parent, xOffset, badgeWidth)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, badgeWidth, 0, 24)
    frame.Position = UDim2.new(0, xOffset, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 100)
    stroke.Thickness = 1
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 1, 0)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "—"
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = frame

    return frame, stroke, label
end

local function makeRow(parent, yOffset, headerText, headerColor)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 13)
    header.Position = UDim2.new(0, 0, 0, yOffset)
    header.BackgroundTransparency = 1
    header.Text = headerText
    header.TextColor3 = headerColor or Color3.fromRGB(110, 105, 140)
    header.TextSize = 9
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = parent
    return header
end

local function buildInfoPanel()
    if infoPanelGui then infoPanelGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "MajekInfoPanel"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999
    gui.Parent = CoreGui
    infoPanelGui = gui

    -- Shadow
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(0, 288, 0, 218)
    shadow.Position = UDim2.new(1, -302, 0, 26)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.65
    shadow.BorderSizePixel = 0
    shadow.Parent = gui
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

    -- Main frame (lebih tinggi untuk tampung semua baris)
    local frame = Instance.new("Frame")
    frame.Name = "Panel"
    frame.Size = UDim2.new(0, 284, 0, 214)
    frame.Position = UDim2.new(1, -306, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 55, 75)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.25
    stroke.Parent = frame

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 38)
    titleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 28, 100)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(28, 22, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28)),
    })
    grad.Rotation = 90
    grad.Parent = titleBar

    -- Title bar bottom border
    local titleBorder = Instance.new("Frame")
    titleBorder.Size = UDim2.new(1, 0, 0, 1)
    titleBorder.Position = UDim2.new(0, 0, 1, -1)
    titleBorder.BackgroundColor3 = Color3.fromRGB(90, 50, 160)
    titleBorder.BackgroundTransparency = 0.4
    titleBorder.BorderSizePixel = 0
    titleBorder.Parent = titleBar

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 13, 0.5, -4)
    dot.BackgroundColor3 = Color3.fromRGB(160, 100, 255)
    dot.BorderSizePixel = 0
    dot.Parent = titleBar
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.new(0, 28, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "MY BRAINROT PANEL"
    titleLabel.TextColor3 = Color3.fromRGB(215, 200, 255)
    titleLabel.TextSize = 12
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Content area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -24, 1, -50)
    content.Position = UDim2.new(0, 12, 0, 46)
    content.BackgroundTransparency = 1
    content.Parent = frame

    -- ── Pet Name ─────────────────────────────────
    makeRow(content, 0, "BRAINROT NAME", Color3.fromRGB(110, 105, 140))

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PetName"
    nameLabel.Size = UDim2.new(1, 0, 0, 22)
    nameLabel.Position = UDim2.new(0, 0, 0, 14)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "Scanning..."
    nameLabel.TextColor3 = Color3.fromRGB(235, 228, 255)
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = content

    -- ── Predicted badge (kecil, pojok kanan atas nama) ──
    local predictedBadge = Instance.new("Frame")
    predictedBadge.Name = "PredictedBadge"
    predictedBadge.Size = UDim2.new(0, 72, 0, 16)
    predictedBadge.Position = UDim2.new(1, -72, 0, 16)
    predictedBadge.BackgroundColor3 = Color3.fromRGB(80, 40, 160)
    predictedBadge.BorderSizePixel = 0
    predictedBadge.Visible = false
    predictedBadge.Parent = content
    Instance.new("UICorner", predictedBadge).CornerRadius = UDim.new(0, 5)

    local predictedLabel = Instance.new("TextLabel")
    predictedLabel.Size = UDim2.new(1, 0, 1, 0)
    predictedLabel.BackgroundTransparency = 1
    predictedLabel.Text = "⚡ PREDICTED"
    predictedLabel.TextColor3 = Color3.fromRGB(200, 170, 255)
    predictedLabel.TextSize = 8
    predictedLabel.Font = Enum.Font.GothamBold
    predictedLabel.TextXAlignment = Enum.TextXAlignment.Center
    predictedLabel.Parent = predictedBadge

    -- ── Rarity & Mutation badges (side by side) ──
    -- header kecil di atas badge
    local badgeHeaderL = makeRow(content, 42, "RARITY", Color3.fromRGB(110, 105, 140))
    local badgeHeaderR = makeRow(content, 42, "MUTATION", Color3.fromRGB(110, 105, 140))
    badgeHeaderR.Position = UDim2.new(0, 140, 0, 42)
    badgeHeaderR.Size = UDim2.new(0.5, 0, 0, 13)

    local rarityFrame, rarityStroke, rarityLabel = makeBadge(content, 0, 128)
    rarityFrame.Position = UDim2.new(0, 0, 0, 56)

    local mutFrame, mutStroke, mutLabel = makeBadge(content, 140, 116)
    mutFrame.Name = "MutationBadge"
    mutFrame.Position = UDim2.new(0, 140, 0, 56)

    -- ── Divider ──────────────────────────────────
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 0, 90)
    divider.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    divider.BackgroundTransparency = 0.3
    divider.BorderSizePixel = 0
    divider.Parent = content

    -- ── CPS ──────────────────────────────────────
    makeRow(content, 98, "CASH PER SECOND", Color3.fromRGB(110, 105, 140))

    local cpsValue = Instance.new("TextLabel")
    cpsValue.Name = "CPSValue"
    cpsValue.Size = UDim2.new(1, 0, 0, 30)
    cpsValue.Position = UDim2.new(0, 0, 0, 112)
    cpsValue.BackgroundTransparency = 1
    cpsValue.Text = "—"
    cpsValue.TextColor3 = Color3.fromRGB(90, 210, 120)
    cpsValue.TextSize = 22
    cpsValue.Font = Enum.Font.GothamBold
    cpsValue.TextXAlignment = Enum.TextXAlignment.Left
    cpsValue.Parent = content

    -- "No pet detected" — center di content
    local noPetLabel = Instance.new("TextLabel")
    noPetLabel.Name = "NoPet"
    noPetLabel.Size = UDim2.new(1, 0, 1, 0)
    noPetLabel.Position = UDim2.new(0, 0, 0, 0)
    noPetLabel.BackgroundTransparency = 1
    noPetLabel.Text = "WAITING BRAINROT"
    noPetLabel.TextColor3 = Color3.fromRGB(90, 88, 110)
    noPetLabel.TextSize = 13
    noPetLabel.Font = Enum.Font.GothamBold
    noPetLabel.TextXAlignment = Enum.TextXAlignment.Center
    noPetLabel.TextYAlignment = Enum.TextYAlignment.Center
    noPetLabel.Visible = false
    noPetLabel.Parent = content

    --// DRAGGABLE — mouse & touch
    local dragging = false
    local dragStartInput, dragStartPos

    local function onDragStart(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartInput = input.Position
            dragStartPos   = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    local function onDragMove(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStartInput
        local newX  = dragStartPos.X.Offset + delta.X
        local newY  = dragStartPos.Y.Offset + delta.Y
        frame.Position  = UDim2.new(dragStartPos.X.Scale, newX, dragStartPos.Y.Scale, newY)
        shadow.Position = UDim2.new(dragStartPos.X.Scale, newX + 6, dragStartPos.Y.Scale, newY + 6)
    end

    titleBar.InputBegan:Connect(onDragStart)
    UserInputService.InputChanged:Connect(onDragMove)

    return {
        gui             = gui,
        nameLabel       = nameLabel,
        rarityLabel     = rarityLabel,
        rarityStroke    = rarityStroke,
        rarityFrame     = rarityFrame,
        mutLabel        = mutLabel,
        mutStroke       = mutStroke,
        mutFrame        = mutFrame,
        cpsValue        = cpsValue,
        noPetLabel      = noPetLabel,
        content         = content,
        predictedBadge  = predictedBadge,
    }
end

local panelRefs = nil

local function updateInfoPanel()
    if not panelRefs then return end

    local petName = findMyPetName()
    local data    = petName and Brainrots[petName]

    if data then
        -- Rarity
        local rColor = RarityColors[data.Rarity] or Color3.fromRGB(200, 200, 200)
        panelRefs.rarityLabel.Text           = data.Rarity:upper()
        panelRefs.rarityLabel.TextColor3     = rColor
        panelRefs.rarityStroke.Color         = rColor
        panelRefs.rarityFrame.BackgroundColor3 = Color3.new(rColor.R * 0.13, rColor.G * 0.13, rColor.B * 0.13)

        -- Mutation — prioritas: predictedMutation (dari InGame attr) → attribute dari model pet
        local mutText
        if predictedMutation and predictedMutation ~= "" then
            mutText = predictedMutation
        else
            local mutAttr = currentPet and currentPet:GetAttribute("Mutation")
            mutText = (mutAttr and mutAttr ~= "") and tostring(mutAttr) or "None"
        end
        local mColor  = MutationColors[mutText] or Color3.fromRGB(160, 160, 160)
        panelRefs.mutLabel.Text             = mutText:upper()
        panelRefs.mutLabel.TextColor3       = mColor
        panelRefs.mutStroke.Color           = mColor
        panelRefs.mutFrame.BackgroundColor3 = Color3.new(mColor.R * 0.13, mColor.G * 0.13, mColor.B * 0.13)

        -- Pet name
        panelRefs.nameLabel.Text = petName

        -- Tampilkan badge "PREDICTED" jika data berasal dari attribute InGame
        if panelRefs.predictedBadge then
            panelRefs.predictedBadge.Visible = (predictedPetName ~= nil and Brainrots[predictedPetName] ~= nil)
        end

        -- CPS
        local cpsNum = tonumber(data.CPS) or 0
        if cpsNum == 0 then
            panelRefs.cpsValue.Text      = "Multiplier Based"
            panelRefs.cpsValue.TextColor3 = Color3.fromRGB(220, 175, 55)
            panelRefs.cpsValue.TextSize  = 16
        else
            panelRefs.cpsValue.Text      = "$" .. formatCPS(data.CPS) .. " / sec"
            panelRefs.cpsValue.TextColor3 = Color3.fromRGB(90, 210, 120)
            panelRefs.cpsValue.TextSize  = 22
        end

        panelRefs.noPetLabel.Visible  = false
        panelRefs.nameLabel.Visible   = true
        panelRefs.rarityFrame.Visible = true
        panelRefs.mutFrame.Visible    = true
        panelRefs.cpsValue.Visible    = true
    else
        panelRefs.noPetLabel.Visible  = true
        panelRefs.nameLabel.Visible   = false
        panelRefs.rarityFrame.Visible = false
        panelRefs.mutFrame.Visible    = false
        panelRefs.cpsValue.Visible    = false
        if panelRefs.predictedBadge then
            panelRefs.predictedBadge.Visible = false
        end
    end
end

local function startInfoPanel()
    panelRefs = buildInfoPanel()
    startPredictionListener()  -- mulai dengarkan attribute InGame
    updateInfoPanel()
    infoPanelConn = RunService.Heartbeat:Connect(function()
        -- Update tiap ~0.5 detik untuk efisiensi
    end)
    -- Update periodik setiap 0.5s
    task.spawn(function()
        while infoPanelActive and panelRefs do
            updateInfoPanel()
            task.wait(0.5)
        end
    end)
end

local function stopInfoPanel()
    stopPredictionListener()  -- hentikan listener attribute InGame
    if infoPanelConn then
        infoPanelConn:Disconnect()
        infoPanelConn = nil
    end
    if infoPanelGui then
        infoPanelGui:Destroy()
        infoPanelGui = nil
    end
    panelRefs = nil
end

Toggles["InfoPanel"]:OnChanged(function(v)
    infoPanelActive = v
    if v then
        startInfoPanel()
    else
        stopInfoPanel()
    end
end)

--// ================= PET DETECTION VIA WELD =================
-- Saat Weld ditambahkan ke HumanoidRootPart karakter → itu pet yang sedang dipakai

local function setupPetDetection(char)
    local hrp = char:WaitForChild("HumanoidRootPart")

    local function resolveWeld(child)
        if not (child:IsA("Weld") or child:IsA("WeldConstraint")) then return end

        local p0 = child.Part0
        local p1 = child.Part1
        local otherPart = (p0 and p0 ~= hrp) and p0
                       or (p1 and p1 ~= hrp) and p1
                       or nil

        if otherPart then
            local model = otherPart:FindFirstAncestorOfClass("Model")
            if model and model ~= char then
                currentPet = model
                print("[PetDetect] Pet terdeteksi: " .. model.Name)
            end
        end
    end

    -- Cek Weld yang sudah ada saat setup (pet sudah terpasang)
    for _, child in pairs(hrp:GetChildren()) do
        resolveWeld(child)
    end

    -- Dengarkan penambahan Weld baru
    hrp.ChildAdded:Connect(resolveWeld)

    -- Reset currentPet saat Weld dilepas
    hrp.ChildRemoved:Connect(function(child)
        if child:IsA("Weld") or child:IsA("WeldConstraint") then
            -- Cek apakah masih ada Weld lain (multi-pet?)
            local stillHasWeld = false
            for _, c in pairs(hrp:GetChildren()) do
                if c:IsA("Weld") or c:IsA("WeldConstraint") then
                    stillHasWeld = true
                    break
                end
            end
            if not stillHasWeld then
                currentPet = nil
                print("[PetDetect] Pet dilepas")
            end
        end
    end)
end

--// Reset WalkSpeed ke customSpeed saat karakter respawn + setup deteksi pet
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = customSpeed
    setupPetDetection(char)
end)

--// Setup untuk karakter yang sudah ada saat script dijalankan
if player.Character then
    setupPetDetection(player.Character)
end

--// ================= NOTIF =================

Library:Notify({
    Title = "Loaded",
    Description = "Majek Hub | Script loaded 🚀",
    Time = 4,
})
