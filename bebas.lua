--[[
    ╔══════════════════════════════════════════════════════════════════════╗
    ║           KEI SELVIM — MANUAL TELEPORT PANEL v20.0                   ║
    ║           Clean UI • Safe Zone • Zona 1-10 • Tanpa Auto Steal        ║
    ╚══════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- =========================================================================
-- ⚙️ KONFIGURASI KOORDINAT
-- =========================================================================
local COORDS = {
    SafeZone = Vector3.new(-44.95, 4.37, 6.81),
    FarmZones = {
        { name = "Zona 1", pos = Vector3.new(76.11, 4.37, 69.31) },
        { name = "Zona 2", pos = Vector3.new(341.88, 4.37, -75.33) },
        { name = "Zona 3", pos = Vector3.new(627.66, 4.37, 79.85) },
        { name = "Zona 4", pos = Vector3.new(1605.16, 4.37, -72.00) },
        { name = "Zona 5", pos = Vector3.new(1995.34, 4.37, 68.48) },
        { name = "Zona 6", pos = Vector3.new(2496.97, 4.37, -58.09) },
        { name = "Zona 7", pos = Vector3.new(3136.20, 4.37, 63.97) },
        { name = "Zona 8", pos = Vector3.new(3824.98, 4.37, -70.62) },
        { name = "Zona 9", pos = Vector3.new(4583.95, 4.37, 58.67) },
        { name = "Zona 10", pos = Vector3.new(6337.60, 5.97, -0.74) }, 
    }
}

local State = {
    LastPos = Vector3.zero,
}

-- =========================================================================
-- HELPER UI
-- =========================================================================
local C = {
    BG = Color3.fromRGB(20, 20, 24), PANEL = Color3.fromRGB(28, 28, 34), BOX = Color3.fromRGB(18, 18, 20),
    TEXT = Color3.fromRGB(240, 240, 240), DIM = Color3.fromRGB(150, 150, 160),
    RED = Color3.fromRGB(240, 80, 80), BORDER = Color3.fromRGB(50, 50, 60),
}

local function create(cls, props)
    local obj = Instance.new(cls)
    for k, v in pairs(props) do if k ~= "Parent" then obj[k] = v end end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end
local function addCorner(parent, r) return create("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = parent }) end
local function addStroke(parent, col) return create("UIStroke", { Color = col or C.BORDER, Thickness = 1, Parent = parent }) end

-- =========================================================================
-- 🎨 BUILD GUI
-- =========================================================================
local function buildUI()
    local gui = create("ScreenGui", { Name = "ManualTeleportUI", ResetOnSpawn = false, Parent = CoreGui })
    
    -- Frame Utama (Ringkas: 320x300)
    local main = create("Frame", { Size = UDim2.new(0, 320, 0, 300), Position = UDim2.new(0.5, -160, 0.5, -150), BackgroundColor3 = C.BG, BorderSizePixel = 0, Parent = gui })
    addCorner(main, 10); addStroke(main, C.BORDER)

    -- Header
    local header = create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = C.PANEL, BorderSizePixel = 0, Parent = main })
    addCorner(header, 10)
    create("TextLabel", { Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = "KEI SELVIM (MANUAL)", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
    
    local closeBtn = create("TextButton", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -32, 0, 8), BackgroundColor3 = C.RED, Text = "✕", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0, Parent = header })
    addCorner(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- Coordinate Display
    local coordBox = create("Frame", { Size = UDim2.new(1, -20, 0, 45), Position = UDim2.new(0, 10, 0, 50), BackgroundColor3 = C.BOX, BorderSizePixel = 0, Parent = main })
    addCorner(coordBox, 6); addStroke(coordBox, C.BORDER)
    local coordLbl = create("TextLabel", { Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "📍 0.00, 0.00, 0.00", TextColor3 = C.DIM, Font = Enum.Code, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = coordBox })

    task.spawn(function()
        while gui.Parent do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                local status = (pos - State.LastPos).Magnitude > 2 and "🟢" or "🔴"
                coordLbl.Text = string.format("%s %.2f, %.2f, %.2f", status, pos.X, pos.Y, pos.Z)
                State.LastPos = pos
            end
            task.wait(0.2)
        end
    end)

    -- ═══════════ TOMBOL TELEPORT SAFE ZONE ═══════════
    local btnSafe = create("TextButton", { Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0, 10, 0, 105), BackgroundColor3 = C.RED, Text = "🛡️ Teleport ke Safe Zone", TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0, Parent = main })
    addCorner(btnSafe, 6)
    btnSafe.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(COORDS.SafeZone)
        end
    end)

    -- ═══════════ TOMBOL TELEPORT ZONA 1-10 ═══════════
    create("TextLabel", { Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 150), BackgroundTransparency = 1, Text = "Pilih Zona:", TextColor3 = C.DIM, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = main })

    local tpContainer = create("Frame", { Size = UDim2.new(1, -20, 0, 115), Position = UDim2.new(0, 10, 0, 175), BackgroundTransparency = 1, Parent = main })
    create("UIGridLayout", { CellSize = UDim2.new(0.33, -4, 0, 26), CellPadding = UDim2.new(0, 4, 0, 5), Parent = tpContainer })

    for i, zone in ipairs(COORDS.FarmZones) do
        local tpBtn = create("TextButton", { BackgroundColor3 = C.PANEL, Text = "📍 " .. zone.name, TextColor3 = C.TEXT, Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, Parent = tpContainer })
        addCorner(tpBtn, 4); addStroke(tpBtn, C.BORDER)
        
        tpBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(zone.pos)
            end
        end)
    end

    -- Drag Logic
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    header.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- JALANKAN
task.wait(1)
local success, err = pcall(buildUI)
if not success then warn("[UI Error] " .. tostring(err)) end
