export function getInitScript(sessionId, sessionKey, domain) {
  return `
local sessionId = "${sessionId}"
local sessionKey = "${sessionKey}"
local tempHwid = "temp_" .. tostring(math.random(100000, 999999))
local requestFunc = request or http_request or syn_request
local getHwidFunc = gethwid

getgenv().SecureAccess_Active = true

local function checkEnvironment()
    if not game or not workspace or not game.Players then
        return false
    end
    if not getHwidFunc or not requestFunc then
        return false
    end
    return true
end

local function startLatencyTest()
    if not checkEnvironment() then 
        return 
    end
    
    local startTime = tick()
    
    local requestData = {
        hwid = tempHwid,
        sessionId = sessionId,
        sessionKey = sessionKey,
        placeId = tostring(game.PlaceId),
        jobId = game.JobId,
        userId = tostring(game.Players.LocalPlayer.UserId),
        timestamp = tostring(os.time()),
        latencyTest = true
    }
    
    local success, response = pcall(function()
        return requestFunc({
            Url = "https://${domain}/api/latency",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Session-ID"] = sessionId,
                ["X-Session-Key"] = sessionKey
            },
            Body = game:GetService("HttpService"):JSONEncode(requestData)
        })
    end)
    
    if success and response and response.StatusCode == 200 then
        local latency = math.floor((tick() - startTime) * 1000)
        
        local responseData = game:GetService("HttpService"):JSONDecode(response.Body)
        if responseData.success and responseData.nextStage then
            loadstring(responseData.nextStage)()
        end
    end
end

spawn(function()
    wait(math.random(100, 300) / 1000)
    startLatencyTest()
end)
`
}

export function getStage1Script(sessionId, sessionKey, hwid, domain) {
  return `
local sessionId = "${sessionId}"
local sessionKey = "${sessionKey}"
local tempHwid = "${hwid}"
local getHwidFunc = gethwid
local requestFunc = request or http_request or syn_request

local function executeStage1()
    local realHwid = tostring(getHwidFunc())
    
    local requestData = {
        hwid = tempHwid,
        realHwid = realHwid,
        sessionId = sessionId,
        sessionKey = sessionKey,
        placeId = tostring(game.PlaceId),
        jobId = game.JobId,
        userId = tostring(game.Players.LocalPlayer.UserId),
        timestamp = tostring(os.time()),
        stage1Complete = true
    }
    
    local success, response = pcall(function()
        return requestFunc({
            Url = "https://${domain}/api/stage1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Session-ID"] = sessionId,
                ["X-Session-Key"] = sessionKey
            },
            Body = game:GetService("HttpService"):JSONEncode(requestData)
        })
    end)
    
    if success and response and response.StatusCode == 200 then
        local responseData = game:GetService("HttpService"):JSONDecode(response.Body)
        if responseData.success and responseData.nextStage then
            loadstring(responseData.nextStage)()
        end
    end
end

spawn(function()
    wait(0.3)
    executeStage1()
end)
`
}

export function getStage2Script(sessionId, sessionKey, hwid, realHwid, token, domain) {
  return `
local sessionId = "${sessionId}"
local sessionKey = "${sessionKey}"
local tempHwid = "${hwid}"
local realHwid = "${realHwid}"
local token = "${token}"
local getHwidFunc = gethwid
local requestFunc = request or http_request or syn_request

local function executeStage2()
    local currentHwid = tostring(getHwidFunc())
    
    local requestData = {
        hwid = tempHwid,
        realHwid = currentHwid,
        sessionId = sessionId,
        sessionKey = sessionKey,
        token = token,
        stage = 2,
        stage2Complete = true
    }
    
    local success, response = pcall(function()
        return requestFunc({
            Url = "https://${domain}/api/stage2",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Session-ID"] = sessionId,
                ["X-Session-Key"] = sessionKey
            },
            Body = game:GetService("HttpService"):JSONEncode(requestData)
        })
    end)
    
    if success and response and response.StatusCode == 200 then
        local responseData = game:GetService("HttpService"):JSONDecode(response.Body)
        if responseData.success and responseData.nextStage then
            loadstring(responseData.nextStage)()
        end
    end
end

spawn(function()
    wait(0.2)
    executeStage2()
end)
`
}

export function getStage3Script(sessionId, sessionKey, hwid, realHwid, token, domain) {
  return `
local sessionId = "${sessionId}"
local sessionKey = "${sessionKey}"
local tempHwid = "${hwid}"
local realHwid = "${realHwid}"
local token = "${token}"
local getHwidFunc = gethwid
local requestFunc = request or http_request or syn_request

local function executeStage3()
    local currentHwid = tostring(getHwidFunc())
    
    local requestData = {
        hwid = tempHwid,
        realHwid = currentHwid,
        sessionId = sessionId,
        sessionKey = sessionKey,
        token = token,
        stage = 3,
        stage3Complete = true
    }
    
    local success, response = pcall(function()
        return requestFunc({
            Url = "https://${domain}/api/stage3",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Session-ID"] = sessionId,
                ["X-Session-Key"] = sessionKey
            },
            Body = game:GetService("HttpService"):JSONEncode(requestData)
        })
    end)
    
    if success and response and response.StatusCode == 200 then
        local responseData = game:GetService("HttpService"):JSONDecode(response.Body)
        if responseData.success and responseData.nextStage then
            loadstring(responseData.nextStage)()
        end
    end
end

spawn(function()
    wait(0.2)
    executeStage3()
end)
`
}

export function getStage4Script(sessionId, sessionKey, hwid, realHwid, token, domain) {
  return `
local sessionId = "${sessionId}"
local sessionKey = "${sessionKey}"
local tempHwid = "${hwid}"
local realHwid = "${realHwid}"
local token = "${token}"
local getHwidFunc = gethwid
local requestFunc = request or http_request or syn_request

local function executeStage4()
    local currentHwid = tostring(getHwidFunc())
    
    local requestData = {
        hwid = tempHwid,
        realHwid = currentHwid,
        sessionId = sessionId,
        sessionKey = sessionKey,
        token = token,
        stage = 4,
        registerUser = true
    }
    
    local success, response = pcall(function()
        return requestFunc({
            Url = "https://${domain}/api/stage4",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Session-ID"] = sessionId,
                ["X-Session-Key"] = sessionKey
            },
            Body = game:GetService("HttpService"):JSONEncode(requestData)
        })
    end)
    
    if success and response and response.StatusCode == 200 then
        local responseData = game:GetService("HttpService"):JSONDecode(response.Body)
        if responseData.success then
            if responseData.hasAccess then
                loadstring(responseData.finalScript)()
            else
                loadstring(responseData.nextStage)()
            end
        end
    end
end

spawn(function()
    wait(0.2)
    executeStage4()
end)
`
}

export function getFinalScript(defScript) {
  return `
getgenv().SecureAccess_Active = nil

spawn(function()
    wait(1)
    
    local scriptUrl = getgenv()._frost or "${defScript}"
    loadstring(game:HttpGet(scriptUrl))()
end)
`
}

export function getVerificationInterface(realHwid, sessionId, domain, defDiscord) {
  return `
local hw = "${realHwid}"
local sid = "${sessionId}"

local function ui()
    local sg = Instance.new("ScreenGui")
    sg.Name = "FrostWare_${sessionId.substring(0, 8)}"
    sg.Parent = cloneref(gethui())
    
    local fr = Instance.new("Frame")
    fr.Size = UDim2.new(0, 380, 0, 220)
    fr.Position = UDim2.new(0.5, -190, 0.5, -110)
    fr.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    fr.BorderSizePixel = 0
    fr.Parent = sg
    
    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0, 16)
    uc.Parent = fr
    
    local us = Instance.new("UIStroke")
    us.Color = Color3.fromRGB(59, 130, 246)
    us.Thickness = 1
    us.Transparency = 0.8
    us.Parent = fr
    
    local tt = Instance.new("TextLabel")
    tt.Size = UDim2.new(1, 0, 0, 35)
    tt.Position = UDim2.new(0, 0, 0, 5)
    tt.BackgroundTransparency = 1
    tt.Text = "❄️ FrostWare Access"
    tt.TextColor3 = Color3.fromRGB(96, 165, 250)
    tt.TextSize = 16
    tt.Font = Enum.Font.GothamBold
    tt.Parent = fr
    
    local st = Instance.new("TextLabel")
    st.Size = UDim2.new(1, -20, 0, 30)
    st.Position = UDim2.new(0, 10, 0, 40)
    st.BackgroundTransparency = 1
    st.Text = "❌ Access required. Copy URL and verify in browser."
    st.TextColor3 = Color3.fromRGB(147, 197, 253)
    st.TextSize = 12
    st.Font = Enum.Font.Gotham
    st.TextWrapped = true
    st.Parent = fr
    
    local db = Instance.new("TextButton")
    db.Size = UDim2.new(0, 110, 0, 30)
    db.Position = UDim2.new(0, 10, 0, 80)
    db.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
    db.Text = "💬 Discord"
    db.TextColor3 = Color3.fromRGB(240, 249, 255)
    db.TextSize = 11
    db.Font = Enum.Font.GothamBold
    db.Parent = fr
    
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(0, 8)
    dc.Parent = db
    
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 110, 0, 30)
    cb.Position = UDim2.new(0, 130, 0, 80)
    cb.BackgroundColor3 = Color3.fromRGB(30, 64, 175)
    cb.Text = "📋 Copy HWID"
    cb.TextColor3 = Color3.fromRGB(240, 249, 255)
    cb.TextSize = 11
    cb.Font = Enum.Font.GothamBold
    cb.Parent = fr
    
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = cb
    
    local ub = Instance.new("TextButton")
    ub.Size = UDim2.new(0, 110, 0, 30)
    ub.Position = UDim2.new(0, 250, 0, 80)
    ub.BackgroundColor3 = Color3.fromRGB(29, 78, 216)
    ub.Text = "🔗 Copy URL"
    ub.TextColor3 = Color3.fromRGB(240, 249, 255)
    ub.TextSize = 11
    ub.Font = Enum.Font.GothamBold
    ub.Parent = fr
    
    local ubc = Instance.new("UICorner")
    ubc.CornerRadius = UDim.new(0, 8)
    ubc.Parent = ub
    
    local it = Instance.new("TextLabel")
    it.Size = UDim2.new(1, -20, 0, 40)
    it.Position = UDim2.new(0, 10, 0, 120)
    it.BackgroundTransparency = 1
    it.Text = "1. Copy verification URL\\n2. Complete 2 steps in browser\\n3. Return to Roblox"
    it.TextColor3 = Color3.fromRGB(203, 213, 225)
    it.TextSize = 10
    it.Font = Enum.Font.Gotham
    it.TextWrapped = true
    it.Parent = fr
    
    local xb = Instance.new("TextButton")
    xb.Size = UDim2.new(0, 100, 0, 25)
    xb.Position = UDim2.new(0.5, -50, 0, 175)
    xb.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    xb.Text = "❌ Close"
    xb.TextColor3 = Color3.fromRGB(255, 255, 255)
    xb.TextSize = 11
    xb.Font = Enum.Font.Gotham
    xb.Parent = fr
    
    local xc = Instance.new("UICorner")
    xc.CornerRadius = UDim.new(0, 6)
    xc.Parent = xb
    
    db.MouseButton1Click:Connect(function()
        local du = getgenv()._d or "${defDiscord}"
        setclipboard(du)
        st.Text = "💬 Discord URL copied to clipboard!"
        st.TextColor3 = Color3.fromRGB(34, 197, 94)
    end)
    
    cb.MouseButton1Click:Connect(function()
        setclipboard(hw)
        st.Text = "📋 HWID copied to clipboard!"
        st.TextColor3 = Color3.fromRGB(34, 197, 94)
    end)
    
    ub.MouseButton1Click:Connect(function()
        local vu = "https://${domain}/verify?hwid=" .. hw
        setclipboard(vu)
        st.Text = "🔗 Verification URL copied! Open in browser and complete 2 steps."
        st.TextColor3 = Color3.fromRGB(34, 197, 94)
    end)
    
    xb.MouseButton1Click:Connect(function()
        sg:Destroy()
        getgenv().SecureAccess_Active = nil
    end)
end

ui()
`
}
