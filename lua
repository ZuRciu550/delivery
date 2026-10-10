local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Auto Farm Script",
    LoadingTitle = "Yükleniyor...",
    LoadingSubtitle = "Senin için hazırlanıyor",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil,
       FileName = "AutoFarmHub"
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Ana Menü", 4483362458)
local Vim = game:GetService("VirtualInputManager")
local Player = game.Players.LocalPlayer

-- F tuşuna basılı tutma fonksiyonu
local function HoldF(duration)
    Vim:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(duration)
    Vim:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

_G.AutoFarm = false

local Toggle = Tab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle", 
    Callback = function(Value)
        _G.AutoFarm = Value
        
        while _G.AutoFarm do
            local Character = Player.Character
            local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            
            if RootPart then
                local JobsFolder = workspace:FindFirstChild("InteractiveJobThings")
                if JobsFolder and JobsFolder:FindFirstChild("Food Delivery") then
                    local FoodDelivery = JobsFolder["Food Delivery"]
                    
                    -- ==========================================
                    -- [ 1. TAG : TOPLAYAN ]
                    -- ==========================================
                    local PickupPoints = FoodDelivery:FindFirstChild("PickupPoints")
                    local Collected = false -- Toplama işleminin başarılı olup olmadığını kontrol etmek için
                    
                    if PickupPoints then
                        for _, part in ipairs(PickupPoints:GetChildren()) do
                            if part.Name == "Pickup" and part:IsA("BasePart") then
                                local Billboard = part:FindFirstChild("BillboardGui")
                                
                                if Billboard and Billboard.Enabled == true then
                                    RootPart.CFrame = part.CFrame
                                    task.wait(0.5) 
                                    
                                    HoldF(2) -- 2 saniye F'ye bas
                                    Collected = true -- İşlem yapıldı
                                    break -- Pickup partını bulduk, döngüden çık
                                end
                            end
                        end
                    end
                    
                    -- Eğer toplama işlemi yapıldıysa 10 saniye bekle
                    if Collected then
                        task.wait(10)
                    else
                        task.wait(1) -- Toplanacak bir şey yoksa oyunu dondurmamak için kısa bekleme
                    end
                    
                    if not _G.AutoFarm then break end 
                    
                    -- ==========================================
                    -- [ 2. TAG : DAĞITAN ]
                    -- ==========================================
                    local DeliveryPoints = FoodDelivery:FindFirstChild("DeliveryPoints")
                    
                    if DeliveryPoints then
                        for _, part in ipairs(DeliveryPoints:GetChildren()) do
                            if part.Name == "Delivery" and part:IsA("BasePart") then
                                local Billboard = part:FindFirstChild("BillboardGui")
                                
                                if Billboard and Billboard.Enabled == true then
                                    RootPart.CFrame = part.CFrame
                                    task.wait(0.5)
                                    
                                    HoldF(2) -- 2 saniye F'ye bas
                                    break -- Delivery partını bulduk, döngüden çık
                                end
                            end
                        end
                    end
                end
            end
            
            task.wait(1) -- Ana while döngüsünün crash vermemesi için bekleme
        end
    end,
})
