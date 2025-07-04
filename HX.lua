local dir = "HeatherX"
if not isfolder(dir) then makefolder(dir) end

local autoExecDir = dir.."/AutoExec"
if not isfolder(autoExecDir) then makefolder(autoExecDir) end

local baseUrl = "https://raw.githubusercontent.com/OneCreatorX/X/refs/heads/main/Iconos/"
local saveDir = "assets/"
if not isfolder(saveDir) then makefolder(saveDir) end

local ReadyIcons = {
    LGO = "logo.png", CLS = "close.png", EXE = "execute.png", SAV = "save.png",
    CLR = "clear.png", REF = "refresh.png", CON = "console.png", SET = "settings.png",
    SCH = "search.png", FLD = "folder.png", DEL = "delete.png", PRT = "particle.png"
}

local function showLoadingScreen()
    local CG = cloneref(gethui())
    local loadingGui = Instance.new("ScreenGui", CG)
    loadingGui.Name = "HeatherXLoading"
    
    local background = Instance.new("Frame", loadingGui)
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
    background.Transparency = 1
    
    local container = Instance.new("Frame", background)
    container.Size = UDim2.new(0, 300, 0, 150)
    container.Position = UDim2.new(0.5, -150, 0.5, -75)
    container.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
    container.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 10)
    
    local title = Instance.new("TextLabel", container)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "HeatherX"
    title.TextColor3 = Color3.fromRGB(240, 150, 210)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    
    local status = Instance.new("TextLabel", container)
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0, 60)
    status.BackgroundTransparency = 1
    status.Text = "Downloading assets..."
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.TextSize = 16
    status.Font = Enum.Font.Gotham
    
    local progress = Instance.new("TextLabel", container)
    progress.Size = UDim2.new(1, 0, 0, 20)
    progress.Position = UDim2.new(0, 0, 0, 90)
    progress.BackgroundTransparency = 1
    progress.Text = "0/" .. #ReadyIcons
    progress.TextColor3 = Color3.fromRGB(255, 255, 255)
    progress.TextSize = 14
    progress.Font = Enum.Font.Gotham
    
    local bar = Instance.new("Frame", container)
    bar.Size = UDim2.new(0.8, 0, 0, 10)
    bar.Position = UDim2.new(0.1, 0, 0, 120)
    bar.BackgroundColor3 = Color3.fromRGB(50, 40, 65)
    bar.BorderSizePixel = 0
    
    local barCorner = Instance.new("UICorner", bar)
    barCorner.CornerRadius = UDim.new(0, 5)
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(240, 150, 210)
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(0, 5)
    
    return loadingGui, progress, fill
end

local function loadImageFromUrl(url, fullPath)
    if not isfile(fullPath) then
        local content = game:HttpGet(url)
        writefile(fullPath, content)
    end
    return getsynasset(fullPath)
end

local function loadAllIcons()
    local needsDownload = false
    for _, file in pairs(ReadyIcons) do
        if not isfile(saveDir .. file) then
            needsDownload = true
            break
        end
    end
    
    local LoadedImages = {}
    
    if needsDownload then
        local loadingGui, progress, fill = showLoadingScreen()
        local count, total = 0, 0
        
        for _ in pairs(ReadyIcons) do total = total + 1 end
        
        for key, file in pairs(ReadyIcons) do
            local fullUrl = baseUrl .. file
            local filePath = saveDir .. file
            
            local success, asset = pcall(function()
                return loadImageFromUrl(fullUrl, filePath)
            end)
            
            if success then LoadedImages[key] = asset end
            
            count = count + 1
            progress.Text = count .. "/" .. total
            fill.Size = UDim2.new(count/total, 0, 1, 0)
            task.wait(0.1)
        end
        
        task.wait(0.5)
        loadingGui:Destroy()
    else
        for key, file in pairs(ReadyIcons) do
            local filePath = saveDir .. file
            local success, asset = pcall(getsynasset, filePath)
            
            if success then
                LoadedImages[key] = asset
            else
                pcall(function()
                    LoadedImages[key] = loadImageFromUrl(baseUrl .. file, filePath)
                end)
            end
        end
    end
    
    return LoadedImages
end

local function runAutoExecuteScripts()
    local executed = 0
    for _, file in ipairs(listfiles(autoExecDir)) do
        if file:sub(-4) == ".lua" then
            local success, content = pcall(readfile, file)
            if success then
                pcall(function() loadstring(content)() end)
                executed = executed + 1
            end
        end
    end
    return executed
end

local autoExecutedCount = runAutoExecuteScripts()
local LoadedImages = loadAllIcons()

local CG, TS, UIS, HttpService = cloneref(gethui()), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("HttpService")

local C = {
    BG = Color3.fromRGB(20, 10, 30), SEC = Color3.fromRGB(35, 25, 50), 
    PANEL = Color3.fromRGB(50, 40, 65), ACC = Color3.fromRGB(240, 150, 210),
    ACCL = Color3.fromRGB(255, 170, 230), ACCD = Color3.fromRGB(220, 130, 190),
    TXT = Color3.fromRGB(255, 255, 255), TXT2 = Color3.fromRGB(230, 230, 240),
    SUC = Color3.fromRGB(150, 220, 170), WARN = Color3.fromRGB(250, 190, 150),
    ERR = Color3.fromRGB(255, 140, 160), LAVENDER = Color3.fromRGB(190, 170, 240),
    PINK = Color3.fromRGB(255, 170, 210), BORDER = Color3.fromRGB(80, 60, 100),
    CODE_BG = Color3.fromRGB(15, 5, 25), AUTO_EXEC = Color3.fromRGB(140, 190, 255), 
    SHADOW = Color3.fromRGB(0, 0, 0)
}

local function cEl(t, p, props)
    local el = Instance.new(t, p)
    for k, v in pairs(props or {}) do el[k] = v end
    
    if t:match("Text") then
        el.TextColor3 = props and props.TextColor3 or C.TXT
        el.Font = props and props.Font or Enum.Font.Gotham
        el.BackgroundColor3 = props and props.BackgroundColor3 or C.SEC
    elseif t:match("Frame") then
        el.BackgroundColor3 = props and props.BackgroundColor3 or C.SEC
    end
    
    if not t:match("UI") then
        Instance.new("UICorner", el).CornerRadius = UDim.new(0, 10)
        if not t:match("Image") then
            local s = Instance.new("UIStroke", el)
            s.Color, s.Thickness, s.ApplyStrokeMode, s.Transparency = C.BORDER, 1, Enum.ApplyStrokeMode.Border, 0.6
        end
    end
    return el
end

local function cShadow(p, offset)
    local shadow = cEl("ImageLabel", p, {
        Size = UDim2.new(1, offset or 40, 1, offset or 40),
        Position = UDim2.new(0, -(offset or 40)/2, 0, -(offset or 40)/2),
        BackgroundTransparency = 1, Image = "rbxassetid://6014261993",
        ImageColor3 = C.SHADOW, ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = p.ZIndex - 1
    })
    return shadow
end

local function cBtn(p, txt, pos, size, color, cb)
    local btn = cEl("TextButton", p, {
        Size = size or UDim2.new(0, 120, 0, 35), Position = pos,
        BackgroundColor3 = color or C.ACC, Text = txt, TextSize = 14, AutoButtonColor = false
    })
    
    if btn:FindFirstChildOfClass("UIStroke") then btn:FindFirstChildOfClass("UIStroke"):Destroy() end
    
    cShadow(btn, 6)
    
    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = color and color:Lerp(Color3.new(1, 1, 1), 0.15) or C.ACCL
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = color or C.ACC
        }):Play()
    end)
    
    btn.MouseButton1Down:Connect(function()
        TS:Create(btn, TweenInfo.new(0.1), {
            Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset * 0.95, btn.Size.Y.Scale, btn.Size.Y.Offset * 0.95),
            Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset + btn.Size.X.Offset * 0.025, btn.Position.Y.Scale, btn.Position.Y.Offset + btn.Size.Y.Offset * 0.025)
        }):Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        TS:Create(btn, TweenInfo.new(0.1), {
            Size = size or UDim2.new(0, 120, 0, 35), Position = pos
        }):Play()
    end)
    
    if cb then btn.MouseButton1Click:Connect(cb) end
    return btn
end

local function cIBtn(p, icon, pos, size, color, cb)
    local btn = cEl("ImageButton", p, {
        Size = size or UDim2.new(0, 32, 0, 32), Position = pos,
        BackgroundColor3 = color or C.PANEL, Image = icon,
        ScaleType = Enum.ScaleType.Fit, ImageColor3 = C.TXT, AutoButtonColor = false,
        BackgroundTransparency = 1
    })
    
    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.2), {ImageColor3 = C.LAVENDER}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.2), {ImageColor3 = C.TXT}):Play()
    end)
    
    if cb then btn.MouseButton1Click:Connect(cb) end
    return btn
end

local function getScreenInfo()
    local w, h = workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y
    local sf = math.min(w, h) / 1080
    sf = math.max(0.75, math.min(1.5, sf))
    local m = UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled
    local l = w > h
    return w, h, sf, m or w < 650, l
end

local function showNotif(title, msg, type)
    local w, h, sf = getScreenInfo()
    local nw, nh = math.min(w * 0.35, 320), 75
    local color = type == "success" and C.SUC or type == "warning" and C.WARN or type == "error" and C.ERR or C.ACC
    
    local n = cEl("Frame", CG:FindFirstChild("HXEd"), {
        Size = UDim2.new(0, nw, 0, nh), Position = UDim2.new(1, 10, 0, 10),
        BackgroundColor3 = C.BG, ZIndex = 100
    })
    
    if n:FindFirstChildOfClass("UICorner") then n:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 15) end
    
    cShadow(n, 30)
    
    local tb = cEl("Frame", n, {
        Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = color, ZIndex = 101
    })
    
    if tb:FindFirstChildOfClass("UICorner") then tb:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 15) end
    
    cEl("TextLabel", n, {
        Size = UDim2.new(1, -50, 0, 25), Position = UDim2.new(0, 12, 0, 12),
        BackgroundTransparency = 1, Text = title, TextSize = 16,
        Font = Enum.Font.GothamBold, TextColor3 = C.TXT,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 101
    })
    
    cEl("TextLabel", n, {
        Size = UDim2.new(1, -50, 0, 25), Position = UDim2.new(0, 12, 0, 38),
        BackgroundTransparency = 1, Text = msg, TextSize = 14,
        Font = Enum.Font.Gotham, TextColor3 = C.TXT2,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 101
    })
    
    local iconImage
    if type == "success" and LoadedImages.EXE then
        iconImage = LoadedImages.LGO
    elseif type == "warning" and LoadedImages.REF then
        iconImage = LoadedImages.REF
    elseif type == "error" and LoadedImages.CLS then
        iconImage = LoadedImages.CLS
    elseif LoadedImages.LGO then
        iconImage = LoadedImages.LGO
    else
        iconImage = type == "success" and "rbxassetid://6031075931" or 
                   type == "warning" and "rbxassetid://6031071053" or 
                   type == "error" and "rbxassetid://6031071057" or "rbxassetid://116872248658338"
    end
    
    cEl("ImageLabel", n, {
        Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -36, 0, 25),
        BackgroundTransparency = 1, Image = iconImage, ImageColor3 = color, ZIndex = 101
    })
    
    TS:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -nw - 20, 0, 10)
    }):Play()
    
    task.delay(3, function()
        TS:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 0, 10),
            BackgroundTransparency = 0.2
        }):Play()
        task.delay(0.4, function() n:Destroy() end)
    end)
    
    return n
end

local function createFeather(p, size, pos)
    local f = cEl("ImageLabel", p, {
        Size = UDim2.new(0, size, 0, size * 2), Position = pos,
        BackgroundTransparency = 1, 
        Image = LoadedImages.PRT or "rbxassetid://138394208142945",
        ImageColor3 = math.random() > 0.5 and C.LAVENDER or C.PINK,
        ImageTransparency = 0.7, Rotation = math.random(-20, 20), ZIndex = 1
    })
    
    local endY = p.AbsoluteSize.Y + 50
    local dur = math.random(10, 18)
    local rot = math.random(-180, 180)
    
    TS:Create(f, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
        Position = UDim2.new(pos.X.Scale, pos.X.Offset + math.random(-120, 120), 0, endY),
        Rotation = f.Rotation + rot, ImageTransparency = 1
    }):Play()
    
    task.delay(dur, function() f:Destroy() end)
    return f
end

local function spawnFeathers(p)
    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
        if not p or not p.Parent then conn:Disconnect() return end
        if math.random() < 0.05 then
            local size = math.random(15, 35)
            createFeather(p, size, UDim2.new(math.random(), 0, 0, -size))
        end
    end)
    return conn
end

local function searchScriptBlox(q, cb)
    local success, result = pcall(function()
        local r = game:HttpGet("https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(q))
        local d = HttpService:JSONDecode(r)
        return d.result.scripts
    end)
    
    if success then
        cb(true, result)
    else
        cb(false, "Failed to search")
    end
end

local function getScriptFromSlug(slug, cb)
    local success, result = pcall(function()
        local r = game:HttpGet("https://scriptblox.com/api/script/" .. slug)
        local d = HttpService:JSONDecode(r)
        if d and d.script then
            return d.script
        else
            error("Script content not found")
        end
    end)
    
    if success then
        cb(true, result)
    else
        cb(false, "Failed to load script")
    end
end

local function openConsole()
    game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
end

local function isAutoExecuteScript(scriptName)
    return isfile(autoExecDir.."/"..scriptName)
end

local function setAutoExecute(scriptName, content, enabled)
    local fullPath = autoExecDir.."/"..scriptName
    if enabled then
        writefile(fullPath, content)
    else
        if isfile(fullPath) then delfile(fullPath) end
    end
end

local function showEd()
    if CG:FindFirstChild("HXEd") then CG:FindFirstChild("HXEd"):Destroy() end
    
    local w, h, sf, m, l = getScreenInfo()
    
    local sg = cEl("ScreenGui", CG, {
        Name = "HXEd", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local mf = cEl("Frame", sg, {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = C.BG, BackgroundTransparency = 0.05
    })
    
    if mf:FindFirstChildOfClass("UICorner") then mf:FindFirstChildOfClass("UICorner"):Destroy() end
    
    local fc = spawnFeathers(mf)
    
    local hh = l and 30 * sf or 40 * sf
    local nh = l and 30 * sf or 35 * sf
    local fh = l and 30 * sf or 35 * sf
    
    local tb = cEl("Frame", mf, {
        Size = UDim2.new(1, 0, 0, hh), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = C.PANEL
    })
    
    if tb:FindFirstChildOfClass("UICorner") then tb:FindFirstChildOfClass("UICorner"):Destroy() end
    
    local tg = Instance.new("UIGradient", tb)
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.PANEL),
        ColorSequenceKeypoint.new(1, C.PANEL:Lerp(C.PINK, 0.4))
    })
    tg.Rotation = 90
    
    local ls = l and 22 * sf or 26 * sf
    
    local logoImage = LoadedImages.LGO or "rbxassetid://116872248658338"
    
    cEl("ImageLabel", tb, {
        Size = UDim2.new(0, ls, 0, ls), Position = UDim2.new(0, 10 * sf, 0.5, -ls/2),
        BackgroundTransparency = 1, Image = logoImage,
        ImageColor3 = C.PINK, ZIndex = 5
    })
    
    local en = "HeatherX"
    pcall(function()
        local i = {identifyexecutor()}
        if #i > 0 then en = table.concat(i, " ") end
    end)
    
    local ts = l and 15 * sf or 18 * sf
    
    local tl = cEl("TextLabel", tb, {
        Size = UDim2.new(1, -100 * sf, 1, 0), Position = UDim2.new(0, ls + 18 * sf, 0, 0),
        BackgroundTransparency = 1, Text = en, TextSize = ts,
        Font = Enum.Font.GothamBold, TextColor3 = C.PINK,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5
    })
    
    local tlg = Instance.new("UIGradient", tl)
    tlg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.PINK),
        ColorSequenceKeypoint.new(0.5, C.LAVENDER),
        ColorSequenceKeypoint.new(1, C.PINK)
    })
    
    local tls = Instance.new("UIStroke", tl)
    tls.Color, tls.Thickness, tls.Transparency = C.LAVENDER, 0.7, 0.6
    
    local cbs = l and 20 * sf or 24 * sf
    
    local closeIcon = LoadedImages.CLS or "rbxassetid://6035047391"
    
    cIBtn(tb, closeIcon, 
        UDim2.new(1, -cbs - 10 * sf, 0.5, -cbs/2), 
        UDim2.new(0, cbs, 0, cbs), C.PANEL, 
        function() sg:Destroy() end
    )
    
    local nb = cEl("Frame", mf, {
        Size = UDim2.new(1, 0, 0, nh), Position = UDim2.new(0, 0, 0, hh),
        BackgroundColor3 = C.PANEL
    })
    
    if nb:FindFirstChildOfClass("UICorner") then nb:FindFirstChildOfClass("UICorner"):Destroy() end
    
    local contentPanel = cEl("Frame", mf, {
        Size = UDim2.new(1, 0, 1, -(hh + nh + fh)), Position = UDim2.new(0, 0, 0, hh + nh),
        BackgroundColor3 = C.PANEL
    })
    
    if contentPanel:FindFirstChildOfClass("UICorner") then contentPanel:FindFirstChildOfClass("UICorner"):Destroy() end
    
    local ep = cEl("Frame", contentPanel, {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = C.CODE_BG, Visible = true
    })
    
    if ep:FindFirstChildOfClass("UICorner") then ep:FindFirstChildOfClass("UICorner"):Destroy() end
    
    local lc = cEl("Frame", ep, {
        Size = UDim2.new(0, 35, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = C.BG, ZIndex = 5
    })
    
    local ls = cEl("ScrollingFrame", lc, {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1, ScrollBarThickness = 0,
        ScrollingEnabled = false, CanvasSize = UDim2.new(0, 0, 0, 200), ZIndex = 5
    })
    
    local ce = cEl("ScrollingFrame", ep, {
        Size = UDim2.new(1, -35, 1, 0), Position = UDim2.new(0, 35, 0, 0),
        BackgroundColor3 = C.CODE_BG, ScrollBarThickness = 5,
        CanvasSize = UDim2.new(0, 0, 0, 200), BorderSizePixel = 0
    })
    
    if ce:FindFirstChildOfClass("UICorner") then ce:FindFirstChildOfClass("UICorner"):Destroy() end
    
    local codeTextSize = l and 15 * sf or 16 * sf
    local lineHeight = 16
    
    local ctb = cEl("TextBox", ce, {
        Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1, TextColor3 = C.TXT,
        TextSize = codeTextSize, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, Font = Enum.Font.Code,
        ClearTextOnFocus = false, TextWrapped = false, MultiLine = true,
        PlaceholderText = "-- Write your script here", Text = "-- HeatherX Script Editor v2.0\n-- Ready to execute",
        PlaceholderColor3 = Color3.fromRGB(120, 130, 140), LineHeight = 1
    })
    
    local pad = Instance.new("UIPadding", ctb)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 10)
    
    local keyboardVisible = false
    UIS.TextBoxFocused:Connect(function(textbox)
        if textbox == ctb and UIS.TouchEnabled and not UIS.KeyboardEnabled then
            keyboardVisible = true
            contentPanel.Size = UDim2.new(1, 0, 1, -(hh + nh + fh + 215))
        end
    end)
    
    UIS.TextBoxFocusReleased:Connect(function(textbox)
        if textbox == ctb and keyboardVisible then
            keyboardVisible = false
            contentPanel.Size = UDim2.new(1, 0, 1, -(hh + nh + fh))
        end
    end)
    
    local function updateLines()
        local lines = 1
        local text = ctb.Text
        
        for i = 1, #text do
            if text:sub(i, i) == "\n" then lines = lines + 1 end
        end
        
        ce.CanvasSize = UDim2.new(0, 0, 0, math.max(200, lines * lineHeight + 40))
        ls.CanvasSize = UDim2.new(0, 0, 0, lineHeight * lines)
        
        for _, child in ipairs(ls:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
        
        for i = 1, lines do
            cEl("TextLabel", ls, {
                Name = tostring(i),
                Size = UDim2.new(1, -8, 0, lineHeight), Position = UDim2.new(0, 0, 0, (i-1) * lineHeight),
                BackgroundTransparency = 1, Text = tostring(i), TextSize = codeTextSize - 1,
                Font = Enum.Font.Code, TextColor3 = C.PINK:Lerp(C.TXT, 0.6),
                TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5,
                TextYAlignment = Enum.TextYAlignment.Center
            })
        end
        
        ls.CanvasPosition = Vector2.new(0, ce.CanvasPosition.Y)
    end
    
    ctb:GetPropertyChangedSignal("Text"):Connect(updateLines)
    ce:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        ls.CanvasPosition = Vector2.new(0, ce.CanvasPosition.Y)
    end)
    
    updateLines()
    
    local sp = cEl("ScrollingFrame", contentPanel, {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = C.BG, ScrollBarThickness = 5,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, Visible = false
    })
    
    local up = cEl("ScrollingFrame", contentPanel, {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = C.BG, ScrollBarThickness = 5,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, Visible = false
    })
    
    local cp = cEl("Frame", contentPanel, {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = C.BG, Visible = false
    })
    
    local function setupScroll(p)
        local l = Instance.new("UIListLayout", p)
        l.Padding = UDim.new(0, 6 * sf)
        l.SortOrder = Enum.SortOrder.Name
        l.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local pd = Instance.new("UIPadding", p)
        pd.PaddingLeft = UDim.new(0, 6 * sf)
        pd.PaddingTop = UDim.new(0, 6 * sf)
        pd.PaddingRight = UDim.new(0, 6 * sf)
        pd.PaddingBottom = UDim.new(0, 6 * sf)
    end
    
    setupScroll(sp)
    setupScroll(up)
    
    local sbh = l and 32 * sf or 38 * sf
    
    local sb = cEl("Frame", cp, {
        Size = UDim2.new(1, 0, 0, sbh), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = C.SEC
    })
    
    if sb:FindFirstChildOfClass("UICorner") then sb:FindFirstChildOfClass("UICorner"):Destroy() end
    
    local si = cEl("TextBox", sb, {
        Size = UDim2.new(1, -90 * sf, 1, -8 * sf), Position = UDim2.new(0, 6 * sf, 0, 4 * sf),
        BackgroundColor3 = C.BG, PlaceholderText = "Search scripts...",
        Text = "", TextSize = l and 13 * sf or 15 * sf, ClearTextOnFocus = false
    })
    
    local searchBtnSize = UDim2.new(0, 95 * sf, 0, 100 * sf)
    local searchBtn = cIBtn(sb, LoadedImages.SCH or "rbxassetid://6031097225", 
        UDim2.new(1, -85 * sf, 0.5, -50 * sf), 
        searchBtnSize, C.ACC)
    
    local rf = cEl("ScrollingFrame", cp, {
        Size = UDim2.new(1, 0, 1, -sbh), Position = UDim2.new(0, 0, 0, sbh),
        BackgroundTransparency = 1, ScrollBarThickness = 5,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0
    })
    
    local rl = Instance.new("UIListLayout", rf)
    rl.Padding = UDim.new(0, 6 * sf)
    rl.SortOrder = Enum.SortOrder.LayoutOrder
    rl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local rp = Instance.new("UIPadding", rf)
    rp.PaddingLeft = UDim.new(0, 6 * sf)
    rp.PaddingTop = UDim.new(0, 6 * sf)
    rp.PaddingRight = UDim.new(0, 6 * sf)
    rp.PaddingBottom = UDim.new(0, 6 * sf)
    
    local lt = cEl("TextLabel", rf, {
        Size = UDim2.new(1, -10 * sf, 0, 35 * sf), Position = UDim2.new(0, 5 * sf, 0, 5 * sf),
        BackgroundTransparency = 1, Text = "Search for scripts using the bar above",
        TextSize = l and 13 * sf or 15 * sf, Font = Enum.Font.Gotham,
        TextColor3 = C.TXT2, TextWrapped = true
    })
    
    local function clearResults()
        for _, c in ipairs(rf:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        lt.Visible = true
    end
    
    local function createScriptItem(script, idx)
        lt.Visible = false
        
        local ih = l and 85 * sf or 95 * sf
        
        local si = cEl("Frame", rf, {
            Size = UDim2.new(1, -10 * sf, 0, ih), BackgroundColor3 = C.SEC, LayoutOrder = idx
        })
        
        if si:FindFirstChildOfClass("UICorner") then si:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 8) end
        
        local is = l and 65 * sf or 75 * sf
        
        local dir = "scriptblox_images"
        if not isfolder(dir) then makefolder(dir) end
        
        local imageUrl = ""
        if script.game and script.game.imageUrl and script.game.imageUrl ~= "" then
            imageUrl = script.game.imageUrl
        elseif script.image and script.image ~= "" then
            imageUrl = script.image
        end
        
        local gi = cEl("ImageLabel", si, {
            Size = UDim2.new(0, is, 0, is),
            Position = UDim2.new(0, 6 * sf, 0.5, -is/2),
            BackgroundColor3 = C.BG
        })
        
        pcall(function()
            if imageUrl ~= "" then
                local fileName = dir .. "/" .. imageUrl:match("[^/]+$")
        
                if not isfile(fileName) then
                    local ok, res = pcall(function() return game:HttpGet(imageUrl) end)
                    if ok and res then writefile(fileName, res)
                    else fileName = nil end
                end
        
                if fileName and isfile(fileName) then
                    gi.Image = getsynasset(fileName)
                else
                    gi.Image = LoadedImages.LGO or "rbxassetid://116872248658338"
                end
            else
                gi.Image = LoadedImages.LGO or "rbxassetid://116872248658338"
            end
        end)
        
        local ts = l and 13 * sf or 15 * sf
        local gs = l and 11 * sf or 13 * sf
        local tys = l and 10 * sf or 12 * sf
        
        cEl("TextLabel", si, {
            Size = UDim2.new(1, -(is + 95 * sf), 0, 22 * sf), Position = UDim2.new(0, is + 12 * sf, 0, 6 * sf),
            BackgroundTransparency = 1, Text = script.title or "Unknown Script",
            TextSize = ts, Font = Enum.Font.GothamBold, TextColor3 = C.TXT,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })
        
        cEl("TextLabel", si, {
            Size = UDim2.new(1, -(is + 95 * sf), 0, 16 * sf), Position = UDim2.new(0, is + 12 * sf, 0, 28 * sf),
            BackgroundTransparency = 1, Text = script.game and script.game.name or "Unknown Game",
            TextSize = gs, Font = Enum.Font.Gotham, TextColor3 = C.TXT2,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })
        
        cEl("TextLabel", si, {
            Size = UDim2.new(0, 85 * sf, 0, 22 * sf), Position = UDim2.new(0, is + 12 * sf, 0, ih - 28 * sf),
            BackgroundColor3 = C.PANEL, Text = script.scriptType or "Script",
            TextSize = tys, Font = Enum.Font.GothamBold
        })
        
        if script.verified then
            cEl("ImageLabel", si, {
                Size = UDim2.new(0, 18 * sf, 0, 18 * sf), Position = UDim2.new(1, -95 * sf, 0, 6 * sf),
                BackgroundTransparency = 1, Image = LoadedImages.EXE or "rbxassetid://6031075931", ImageColor3 = C.SUC
            })
        end
        
        cEl("TextLabel", si, {
            Size = UDim2.new(0, 75 * sf, 0, 16 * sf), Position = UDim2.new(1, -85 * sf, 0, 28 * sf),
            BackgroundTransparency = 1, Text = (script.views or 0) .. " views",
            TextSize = gs, Font = Enum.Font.Gotham, TextColor3 = C.TXT2,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        
        cBtn(si, "Execute", 
            UDim2.new(1, -85 * sf, 0, ih - 28 * sf), 
            UDim2.new(0, 75 * sf, 0, 22 * sf), C.ACC, 
            function()
                local source = script.script
                if source and source ~= "" then
                    loadstring(source)()
                    showNotif("Script Executed", script.title or "Unknown Script", "success")
                else
                    showNotif("Error", "Script is empty or invalid", "error")
                end
            end
        )
        
        return si
    end
    
    searchBtn.MouseButton1Click:Connect(function()
        local q = si.Text
        if q and q:len() > 0 then
            clearResults()
            lt.Text = "Searching..."
            lt.Visible = true
            
            searchScriptBlox(q, function(success, scripts)
                if success then
                    clearResults()
                    if #scripts == 0 then
                        lt.Text = "No scripts found"
                        lt.Visible = true
                    else
                        for i, s in ipairs(scripts) do
                            createScriptItem(s, i)
                        end
                    end
                else
                    lt.Text = "Error: " .. tostring(scripts)
                    lt.Visible = true
                end
            end)
        end
    end)
    
    si.FocusLost:Connect(function(ep)
        if ep then searchBtn.MouseButton1Click:Fire() end
    end)
    
    local function createUtilItem(name, desc, cb, icon)
        local ih = l and 65 * sf or 75 * sf
        
        local ui = cEl("Frame", up, {
            Size = UDim2.new(1, -10 * sf, 0, ih), BackgroundColor3 = C.SEC
        })
        
        if ui:FindFirstChildOfClass("UICorner") then ui:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 8) end
        
        local is = l and 25 * sf or 28 * sf
        
        cEl("ImageLabel", ui, {
            Size = UDim2.new(0, is, 0, is), Position = UDim2.new(0, 12 * sf, 0.5, -is/2),
            BackgroundTransparency = 1, Image = icon or LoadedImages.LGO or "rbxassetid://116872248658338", ImageColor3 = C.LAVENDER
        })
        
        local ns = l and 13 * sf or 15 * sf
        local ds = l and 11 * sf or 13 * sf
        
        cEl("TextLabel", ui, {
            Size = UDim2.new(1, -(is + 140 * sf), 0, 22 * sf), Position = UDim2.new(0, is + 22 * sf, 0, 12 * sf),
            BackgroundTransparency = 1, Text = name, TextSize = ns,
            Font = Enum.Font.GothamBold, TextColor3 = C.TXT, TextXAlignment = Enum.TextXAlignment.Left
        })
        
        cEl("TextLabel", ui, {
            Size = UDim2.new(1, -(is + 140 * sf), 0, 22 * sf), Position = UDim2.new(0, is + 22 * sf, 0, 34 * sf),
            BackgroundTransparency = 1, Text = desc, TextSize = ds,
            Font = Enum.Font.Gotham, TextColor3 = C.TXT2,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })
        
        cBtn(ui, "Execute", 
            UDim2.new(1, -120 * sf, 0.5, -16 * sf), 
            UDim2.new(0, 110 * sf, 0, 32 * sf), C.ACC, 
            function()
                cb()
                showNotif("Executed", name, "success")
            end
        )
        
        return ui
    end
    
    local utils = {
        {"Infinite Yield", "FE Admin Commands", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end, LoadedImages.SET or "rbxassetid://6034996695"},
        {"Dex Explorer", "Roblox Explorer", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end, LoadedImages.FLD or "rbxassetid://6022668883"}
    }
    
    for _, u in ipairs(utils) do
        createUtilItem(u[1], u[2], u[3], u[4])
    end
    
    local bb = cEl("Frame", mf, {
        Size = UDim2.new(1, 0, 0, fh), Position = UDim2.new(0, 0, 1, -fh),
        BackgroundColor3 = C.PANEL
    })
    
    if bb:FindFirstChildOfClass("UICorner") then bb:FindFirstChildOfClass("UICorner"):Destroy() end
    
    local function createScriptItem(p, scriptPath)
        local fn = scriptPath:match("[^/\\]+%.lua$")
        if fn then fn = fn:sub(1, -5) end
        
        local ih = l and 55 * sf or 65 * sf
        
        local si = cEl("Frame", p, {
            Size = UDim2.new(1, -10 * sf, 0, ih), BackgroundColor3 = C.SEC
        })
        
        if si:FindFirstChildOfClass("UICorner") then si:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 8) end
        
        local is = l and 25 * sf or 28 * sf
        
        local isAutoExec = isAutoExecuteScript(fn..".lua")
        
        local iconColor = isAutoExec and C.AUTO_EXEC or C.PINK
        
        local iconImg = cEl("ImageLabel", si, {
            Size = UDim2.new(0, is, 0, is), Position = UDim2.new(0, 12 * sf, 0.5, -is/2),
            BackgroundTransparency = 1, Image = LoadedImages.FLD or "rbxassetid://6026568198", ImageColor3 = iconColor
        })
        
        local ns = l and 13 * sf or 15 * sf
        
        local sb = cEl("TextButton", si, {
            Size = UDim2.new(1, -(is + 270 * sf), 1, 0), Position = UDim2.new(0, is + 22 * sf, 0, 0),
            BackgroundTransparency = 1, Text = fn, TextSize = ns,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
            Font = Enum.Font.Gotham
        })
        
        sb.MouseButton1Click:Connect(function()
            local success, content = pcall(readfile, scriptPath)
            if success then
                ctb.Text = content
                editorBtn.MouseButton1Click:Fire()
            end
        end)
        
        local bs = l and 26 * sf or 30 * sf
        
        cBtn(si, "Run", 
            UDim2.new(1, -(260 * sf), 0.5, -bs/2), 
            UDim2.new(0, 75 * sf, 0, bs), C.SUC, 
            function()
                local success, content = pcall(readfile, scriptPath)
                if success then
                    loadstring(content)()
                    showNotif("Executed", fn, "success")
                else
                    showNotif("Error", "Failed to load script", "error")
                end
            end
        )
        
        local autoExecBtn = cBtn(si, isAutoExec and "Auto ✓" or "Auto", 
            UDim2.new(1, -(175 * sf), 0.5, -bs/2), 
            UDim2.new(0, 75 * sf, 0, bs), 
            isAutoExec and C.AUTO_EXEC or C.SEC
        )
    
        local function refScr()
            for _, c in ipairs(sp:GetChildren()) do
                if c:IsA("Frame") then c:Destroy() end
            end
            
            local scripts = {}
            for _, f in ipairs(listfiles(dir)) do
                if f:sub(-4) == ".lua" then table.insert(scripts, f) end
            end
            
            for _, p in ipairs(scripts) do
                createScriptItem(sp, p)
            end
        end
    
        autoExecBtn.MouseButton1Click:Connect(function()
            local success, content = pcall(readfile, scriptPath)
            if success then
                isAutoExec = not isAutoExec
                setAutoExecute(fn..".lua", content, isAutoExec)
                
                showNotif(
                    isAutoExec and "Auto Execute Enabled" or "Auto Execute Disabled", 
                    fn, 
                    isAutoExec and "success" or "warning"
                )
                
                refScr()
            else
                showNotif("Error", "Failed to load script", "error")
            end
        end)

        local deleteBtn = cIBtn(si, LoadedImages.DEL or "rbxassetid://6035047391", 
            UDim2.new(1, -(90 * sf), 0.5, -15 * sf), 
            UDim2.new(0, 30 * sf, 0, 30 * sf), C.ERR, 
            function()
                if isAutoExecuteScript(fn..".lua") then
                    setAutoExecute(fn..".lua", "", false)
                end
                pcall(delfile, scriptPath)
                showNotif("Deleted", fn, "warning")
                si:Destroy()
            end
        )
        
        return si
    end
   
    local function showSave()
        local blur = cEl("Frame", sg, {
            Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.4, ZIndex = 10
        })
        
        local pw = l and 320 * sf or 380 * sf
        local ph = l and 200 * sf or 240 * sf
        
        local sp = cEl("Frame", blur, {
            Size = UDim2.new(0, pw, 0, ph), Position = UDim2.new(0.5, -pw/2, 0.5, -ph/2),
            BackgroundColor3 = C.BG, ZIndex = 11
        })
        
        if sp:FindFirstChildOfClass("UICorner") then sp:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 12) end
        
        cShadow(sp, 30)
        
        local hh = l and 38 * sf or 45 * sf
        
        local st = cEl("TextLabel", sp, {
            Size = UDim2.new(1, 0, 0, hh), Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = C.PANEL, Text = "Save Script",
            TextSize = l and 15 * sf or 18 * sf, Font = Enum.Font.GothamBold, ZIndex = 12
        })
        
        if st:FindFirstChildOfClass("UICorner") then st:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 12) end
        
        local stg = Instance.new("UIGradient", st)
        stg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.PANEL),
            ColorSequenceKeypoint.new(1, C.PANEL:Lerp(C.PINK, 0.2))
        })
        stg.Rotation = 90
        
        local is = l and 22 * sf or 24 * sf
        
        cEl("ImageLabel", st, {
            Size = UDim2.new(0, is, 0, is), Position = UDim2.new(0, 12 * sf, 0.5, -is/2),
            BackgroundTransparency = 1, Image = LoadedImages.SAV or "rbxassetid://6026568198",
            ImageColor3 = C.LAVENDER, ZIndex = 12
        })
        
        local ih = l and 32 * sf or 38 * sf
        
        local ni = cEl("TextBox", sp, {
            Size = UDim2.new(1, -24 * sf, 0, ih), Position = UDim2.new(0, 12 * sf, 0, hh + 15 * sf),
            BackgroundColor3 = C.SEC, Text = "", PlaceholderText = "Script name",
            TextSize = l and 13 * sf or 15 * sf, ZIndex = 12
        })
        
        if ni:FindFirstChildOfClass("UICorner") then ni:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 10) end
        
        local autoExecCheckbox = cEl("Frame", sp, {
            Size = UDim2.new(0, ih, 0, ih), Position = UDim2.new(0, 12 * sf, 0, hh + ih + 25 * sf),
            BackgroundColor3 = C.SEC, ZIndex = 12
        })
        
        local autoExecEnabled = false
        
        local checkmark = cEl("ImageLabel", autoExecCheckbox, {
            Size = UDim2.new(0.7, 0, 0.7, 0), Position = UDim2.new(0.15, 0, 0.15, 0),
            BackgroundTransparency = 1, Image = LoadedImages.EXE or "rbxassetid://6031094670",
            ImageColor3 = C.AUTO_EXEC, ZIndex = 13, Visible = autoExecEnabled
        })
        
        autoExecCheckbox.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                autoExecEnabled = not autoExecEnabled
                checkmark.Visible = autoExecEnabled
            end
        end)
        
        cEl("TextLabel", sp, {
            Size = UDim2.new(1, -(ih + 24 * sf), 0, ih), Position = UDim2.new(0, ih + 22 * sf, 0, hh + ih + 25 * sf),
            BackgroundTransparency = 1, Text = "Auto Execute on Startup",
            TextSize = l and 13 * sf or 15 * sf, Font = Enum.Font.Gotham,
            TextColor3 = C.TXT, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12
        })
        
        local bh = l and 32 * sf or 38 * sf
        
        local bb = cEl("Frame", sp, {
            Size = UDim2.new(1, -24 * sf, 0, bh), Position = UDim2.new(0, 12 * sf, 1, -(bh + 15 * sf)),
            BackgroundTransparency = 1, ZIndex = 12
        })
        
        cBtn(bb, "Cancel", UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), C.ERR, function()
            blur:Destroy()
        end)
        
        cBtn(bb, "Save", UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), C.SUC, function()
            local name = ni.Text
            if name == "" then name = "Script_" .. os.time() end
            if not name:match("%.lua$") then name = name .. ".lua" end
            
            writefile(dir .. "/" .. name, ctb.Text)
            
            if autoExecEnabled then
                setAutoExecute(name, ctb.Text, true)
            end
            
            showNotif("Saved", name:sub(1, -5) .. (autoExecEnabled and " (Auto Execute)" or ""), "success")
            blur:Destroy()
            refScr()
        end)
        
        local closeBtn = cIBtn(st, LoadedImages.CLS or "rbxassetid://6035047391", 
            UDim2.new(1, -is - 12 * sf, 0.5, -is/2), 
            UDim2.new(0, is, 0, is), C.PANEL, 
            function() blur:Destroy() end
        )
    end
    
    local bp = Instance.new("UIPadding", bb)
    bp.PaddingLeft = UDim.new(0, 6 * sf)
    bp.PaddingRight = UDim.new(0, 6 * sf)
    bp.PaddingTop = UDim.new(0, 3 * sf)
    bp.PaddingBottom = UDim.new(0, 3 * sf)
    
    local eb = cEl("Frame", bb, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = true})
    local sb = cEl("Frame", bb, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false})
    local ub = cEl("Frame", bb, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false})
    local cb = cEl("Frame", bb, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false})
    
    local function setupFlow(p)
        local f = Instance.new("UIListLayout", p)
        f.FillDirection = Enum.FillDirection.Horizontal
        f.HorizontalAlignment = Enum.HorizontalAlignment.Center
        f.VerticalAlignment = Enum.VerticalAlignment.Center
        f.Padding = UDim.new(0, 6 * sf)
        return f
    end
    
    setupFlow(eb)
    setupFlow(sb)
    setupFlow(ub)
    setupFlow(cb)
    
    local is = l and 15 * sf or 18 * sf
    
    local function executeScript()
        local success, result = pcall(function() 
            return loadstring(ctb.Text)() 
        end)
        
        if success then
            showNotif("Executed", "Script executed successfully", "success")
        else
            local errorMsg = tostring(result)
            local lineNum = tonumber(errorMsg:match(":(%d+):"))
            
            if lineNum then
                showNotif("Error", "Error on line " .. lineNum .. ": " .. errorMsg:match(":%d+:%s*(.+)"), "error")
            else
                showNotif("Error", "Execution failed: " .. errorMsg, "error")
            end
        end
    end
    
    local executeBtn = cIBtn(nil, LoadedImages.EXE or "rbxassetid://6026663699", 
        UDim2.new(0.5, -15 * sf, 0.5, -15 * sf), 
        UDim2.new(0, 30 * sf, 0, 30 * sf), C.ACC, executeScript)
    
    local executeContainer = cEl("Frame", eb, {
        Size = UDim2.new(0.33, -4 * sf, 1, -6 * sf),
        BackgroundTransparency = 1
    })
    executeBtn.Parent = executeContainer

    local saveBtn = cIBtn(nil, LoadedImages.SAV or "rbxassetid://6026568198", 
        UDim2.new(0.5, -15 * sf, 0.5, -15 * sf), 
        UDim2.new(0, 30 * sf, 0, 30 * sf), C.PINK, showSave)
    
    local saveContainer = cEl("Frame", eb, {
        Size = UDim2.new(0.33, -4 * sf, 1, -6 * sf),
        BackgroundTransparency = 1
    })
    saveBtn.Parent = saveContainer

    local clearBtn = cIBtn(nil, LoadedImages.CLR or "rbxassetid://6035047391", 
        UDim2.new(0.5, -50 * sf, 0.5, -15 * sf), 
        UDim2.new(0, 80 * sf, 0, 30 * sf), C.WARN, function()
            ctb.Text = ""
            showNotif("Cleared", "Editor cleared", "warning")
        end)
    
    local clearContainer = cEl("Frame", eb, {
        Size = UDim2.new(0.33, -4 * sf, 1, -6 * sf),
        BackgroundTransparency = 1
    })
    clearBtn.Parent = clearContainer

    local consoleBtn = cIBtn(nil, LoadedImages.CON or "rbxassetid://6031075931", 
        UDim2.new(0.5, -15 * sf, 0.5, -15 * sf), 
        UDim2.new(0, 30 * sf, 0, 30 * sf), C.LAVENDER, function()
            openConsole()
            showNotif("Console", "Developer console opened", "success")
        end)
    
    local consoleContainer = cEl("Frame", ub, {
        Size = UDim2.new(1, -10 * sf, 1, -6 * sf),
        BackgroundTransparency = 1
    })
    consoleBtn.Parent = consoleContainer
    
    local cloudExecuteBtn = cIBtn(nil, LoadedImages.EXE or "rbxassetid://6026663699", 
        UDim2.new(0.5, -15 * sf, 0.5, -15 * sf), 
        UDim2.new(0, 30 * sf, 0, 30 * sf), C.ACC, executeScript)
    
    local cloudExecuteContainer = cEl("Frame", cb, {
        Size = UDim2.new(0.5, -3 * sf, 1, -6 * sf),
        BackgroundTransparency = 1
    })
    cloudExecuteBtn.Parent = cloudExecuteContainer

    local cloudSaveBtn = cIBtn(nil, LoadedImages.SAV or "rbxassetid://6026568198", 
        UDim2.new(0.5, -15 * sf, 0.5, -15 * sf), 
        UDim2.new(0, 30 * sf, 0, 30 * sf), C.PINK, showSave)
    
    local cloudSaveContainer = cEl("Frame", cb, {
        Size = UDim2.new(0.5, -3 * sf, 1, -6 * sf),
        BackgroundTransparency = 1
    })
    cloudSaveBtn.Parent = cloudSaveContainer
    
    local editorBtn, scriptsBtn, utilsBtn, cloudBtn
    
    local function createTab(txt, pos, active, panel, btnPanel)
        local btn = cEl("TextButton", nb, {
            Size = UDim2.new(0.25, 0, 1, 0), Position = pos,
            BackgroundColor3 = active and C.ACC or C.SEC, Text = txt,
            TextSize = l and 13 * sf or 15 * sf
        })
        
        if btn:FindFirstChildOfClass("UICorner") then btn:FindFirstChildOfClass("UICorner"):Destroy() end
        local function refScr()
for _, c in ipairs(sp:GetChildren()) do
    if c:IsA("Frame") then c:Destroy() end
end

local scripts = {}
for _, f in ipairs(listfiles(dir)) do
    if f:sub(-4) == ".lua" then table.insert(scripts, f) end
end

for _, p in ipairs(scripts) do
    createScriptItem(sp, p)
end
end

        btn.MouseButton1Click:Connect(function()
            ep.Visible = panel == ep
            sp.Visible = panel == sp
            up.Visible = panel == up
            cp.Visible = panel == cp
            
            editorBtn.BackgroundColor3 = panel == ep and C.ACC or C.SEC
            scriptsBtn.BackgroundColor3 = panel == sp and C.ACC or C.SEC
            utilsBtn.BackgroundColor3 = panel == up and C.ACC or C.SEC
            cloudBtn.BackgroundColor3 = panel == cp and C.ACC or C.SEC
            
            eb.Visible = btnPanel == eb
            sb.Visible = btnPanel == sb
            ub.Visible = btnPanel == ub
            cb.Visible = btnPanel == cb
            
            if panel == sp then refScr() end
        end)
        
        return btn
    end
    
    editorBtn = createTab("Editor", UDim2.new(0, 0, 0, 0), true, ep, eb)
    scriptsBtn = createTab("Scripts", UDim2.new(0.25, 0, 0, 0), false, sp, sb)
    utilsBtn = createTab("Utils", UDim2.new(0.5, 0, 0, 0), false, up, ub)
    cloudBtn = createTab("Cloud", UDim2.new(0.75, 0, 0, 0), false, cp, cb)
    
    local isDrag, dragSt, stPos = false, nil, nil
    
    tb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDrag, dragSt, stPos = true, input.Position, mf.Position
        end
    end)
    
    tb.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDrag = false
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if isDrag and dragSt and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragSt
            mf.Position = UDim2.new(stPos.X.Scale, stPos.X.Offset + delta.X, stPos.Y.Scale, stPos.Y.Offset + delta.Y)
        end
    end)
    
    local function refScr()
        for _, c in ipairs(sp:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        
        local scripts = {}
        for _, f in ipairs(listfiles(dir)) do
            if f:sub(-4) == ".lua" then table.insert(scripts, f) end
        end
        
        for _, p in ipairs(scripts) do
            createScriptItem(sp, p)
        end
    end
    
    refScr()
    
    local shadow = mf:FindFirstChildOfClass("ImageLabel")
    if shadow then
        shadow.ImageTransparency = 1
        TS:Create(shadow, TweenInfo.new(0.8), {ImageTransparency = 0.5}):Play()
    end
    
    UIS.WindowFocusReleased:Connect(function() isDrag = false end)
    UIS.WindowFocused:Connect(function() isDrag = false end)
    
    local function updateLayout()
        local nw, nh, nsf, nm, nl = getScreenInfo()
        if nm ~= m or nl ~= l or nw ~= w or nh ~= h then showEd() end
    end
    
    local resizeConn
    resizeConn = game:GetService("RunService").RenderStepped:Connect(function()
        if not sg.Parent then
            resizeConn:Disconnect()
            if fc then fc:Disconnect() end
            return
        end
        
        local nw, nh = getScreenInfo()
        if nw ~= w or nh ~= h then
            w, h = nw, nh
            updateLayout()
        end
    end)
    
    if autoExecutedCount > 0 then
        showNotif("Auto Execute", "Executed " .. autoExecutedCount .. " scripts", "success")
    end
    
    showNotif("HeatherX", "Welcome to HeatherX", "success")
end

local function setupTBI()
    local tba = game:GetService("CoreGui"):WaitForChild("TopBarApp", 5)
    if not tba then return end
    
    local ulf = tba:WaitForChild("TopBarApp", 5):WaitForChild("UnibarLeftFrame", 5)
    if not ulf then return end
    
    local um = ulf:WaitForChild("UnibarMenu", 5)
    if not um then return end
    
    local smh = um:WaitForChild("SubMenuHost", 5)
    if not smh then return end
    
    smh.ChildAdded:Connect(function(child)
        if child.Name == "nine_dot" then
            task.delay(0.3, function()
                local btn = child:FindFirstChild("trust_and_safety", true)
                if btn and btn:IsA("ImageButton") then
                    local clone = btn:Clone()
                    clone.LayoutOrder = 1
                    
                    local label = clone:FindFirstChild("StyledTextLabel", true)
                    if label then 
                        label.Text = "HeatherX"
                        label.TextColor3 = C.PINK
                    end
                    
                    local icon = clone:FindFirstChild("IntegrationIcon", true)
                    if icon and icon:IsA("ImageLabel") then
                        icon.Image = LoadedImages.LGO or "rbxassetid://116872248658338"
                        icon.ScaleType = Enum.ScaleType.Fit
                        icon.ImageRectSize = Vector2.new(0, 0)
                        icon.ImageRectOffset = Vector2.new(0, 0)
                        icon.SliceScale = 1
                        icon.BackgroundTransparency = 1
                    end
                    
                    clone.MouseButton1Click:Connect(showEd)
                    clone.Parent = btn.Parent
                end
            end)
        end
    end)
end

setupTBI()
showEd()
