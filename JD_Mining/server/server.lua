local spawnedObjects = {}
local miningRewards = {
    { Item = 'uncut_diamond', MaxAmount = 2, MinAmount = 1, Label =  "Uncut Diamonds", SmeltedItem = 'diamond', canSmelt = false},
    { Item = 'uncut_rubbies', MaxAmount = 2, MinAmount = 1, Label =  "Uncut Rubbies", SmeltedItem = 'ruby', canSmelt = false},
    { Item = 'aluminum_ore', MaxAmount = 3, MinAmount = 1, Label =  "Aluminium Ore", SmeltedItem = 'aluminum', canSmelt = true},
    { Item = 'iron_ore', MaxAmount = 6, MinAmount = 1, Label =  "Iron Ore", SmeltedItem = 'iron', canSmelt = true},
    { Item = 'copper_ore', MaxAmount = 8, MinAmount = 1, Label =  "Copper Ore" , SmeltedItem = 'copper', canSmelt = true},
}

local storeSell = {
    { Item = 'aluminum', price = 20},
    { Item = 'iron', price = 10},
    { Item = 'copper', price = 10},
}

local gemList = {
    { Item = 'diamond', price = 100},
    { Item = 'ruby', price = 150},
}

local brokenRockRewards = {Min =2, Max = 6}

RegisterNetEvent('JD_Mining:randomMiningRewards')
AddEventHandler('JD_Mining:randomMiningRewards', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomNumber = math.random(1, #miningRewards)
    for k,v in pairs(miningRewards) do
        if k == randomNumber then 
            local randomCount = math.random(v.MinAmount,v.MaxAmount)
            if randomCount > 0 then 
                if xPlayer.canCarryItem(v.Item,randomCount) then
                    xPlayer.addInventoryItem(v.Item,randomCount)
                    xPlayer.removeInventoryItem('broken_rock', 5)
                else
                    xPlayer.showNotification("No Space For "..randomCount.. " ".. v.Label.."")
                end 
            end
        end
    end
end)

RegisterNetEvent('JD_Mining:rewardBrokenRocks')
AddEventHandler('JD_Mining:rewardBrokenRocks', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomNumber = math.random(brokenRockRewards.Min, brokenRockRewards.Max)

    if xPlayer.canCarryItem('broken_rock',randomNumber) then
        xPlayer.addInventoryItem('broken_rock',randomNumber)
    else
        xPlayer.showNotification("No Space For "..randomNumber.. " ".. 'Broken Rocks'.."")
    end 
end)

RegisterNetEvent('JD_Mining:smelterRewards')
AddEventHandler('JD_Mining:smelterRewards', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomNumber = math.random(1,3)

    for k,v in pairs(miningRewards) do
        if xPlayer.getInventoryItem(v.Item).count >= 2 then
            if xPlayer.canCarryItem(v.SmeltedItem,randomNumber) then
                xPlayer.addInventoryItem(v.SmeltedItem,randomNumber)
                xPlayer.removeInventoryItem(v.Item, 2)
            else
                xPlayer.showNotification("No Inventory Space!")
            end 
        end
    end
end)

RegisterNetEvent('JD_Mining:sellItems')
AddEventHandler('JD_Mining:sellItems', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    for k,v in pairs(storeSell) do
        local count = xPlayer.getInventoryItem(v.Item).count
        if count then 
            if count >= 1 then
                xPlayer.removeInventoryItem(v.Item, count)
                xPlayer.addMoney(count * v.price)
            end
        end
    end
end)

RegisterNetEvent('JD_Mining:sellGems')
AddEventHandler('JD_Mining:sellGems', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    for k,v in pairs(gemList) do
        local count = xPlayer.getInventoryItem(v.Item).count
        if count then 
            if count >= 1 then
                xPlayer.removeInventoryItem(v.Item, count)
                xPlayer.addMoney(count * v.price)
            end
        end
    end
end)

RegisterNetEvent('JD_Mining:reducePickaxeDurability')
AddEventHandler('JD_Mining:reducePickaxeDurability', function()
    local ox_inventory = exports.ox_inventory
    local xPlayer = ESX.GetPlayerFromId(source)

    local items = ox_inventory:Search(source, 'slots', 'pickaxe')
    if #items > 0 then
        local item = items[1]
        if item then
            ox_inventory:SetDurability(source, item.slot, (item.metadata?.durability or 100) - 1)
            if tonumber(item.metadata?.durability) <= 1 then 
                ox_inventory:RemoveItem(source, 'pickaxe', 1, false, item.slot)
                xPlayer.showNotification('Your pickaxe broke due to over use!')
            end
        end
    end
end)

ESX.RegisterServerCallback("JD_Mining:getPickaxe",function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem('pickaxe').count >= 1 then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("JD_Mining:getRockCount",function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem('broken_rock').count >= 5 then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("JD_Mining:getOre",function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local count = 0
    for k,v in pairs(miningRewards) do
        if v.canSmelt then
            if xPlayer.getInventoryItem(v.Item).count >= 2 then
                count = count + 1
            end
        end
    end
    if count >= 1 then 
        cb(true)
    else
        cb(false)
    end
end)