local isMining
local targetList = {}
local number = 0
local drawMarker = false
local markerCoords = nil
local currentlyActive

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if drawMarker then 
			DrawMarker(20, markerCoords.x, markerCoords.y, markerCoords.z + 1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.4, 0.4, 0.4, 235, 64, 52, 100, true, false, 2, true, false, false, false)
		else 
			Wait(500)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Wait(1000)
	CreateTargets()
	CreateBlips()
end)

CreateBlips = function()
	local pitMine = AddBlipForCoord(vector3(2935.752, 2797.623, 40.88382))
	SetBlipSprite(pitMine, 85)
	SetBlipScale(pitMine, 0.8)
	SetBlipColour(pitMine,17)
	SetBlipAsShortRange(pitMine, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Pit Mine")
	EndTextCommandSetBlipName(pitMine)

	local MinersOffice = AddBlipForCoord(vector3(2832.58, 2799.736, 57.47121))
	SetBlipSprite(MinersOffice, 47)
	SetBlipScale(MinersOffice, 0.8)
	SetBlipColour(MinersOffice,17)
	SetBlipAsShortRange(MinersOffice, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Miners Office")
	EndTextCommandSetBlipName(MinersOffice)

	local rockWash = AddBlipForCoord(vector3(1960.145, 487.4953, 160.7001))
	SetBlipSprite(rockWash, 280)
	SetBlipScale(rockWash, 0.8)
	SetBlipColour(rockWash,17)
	SetBlipAsShortRange(rockWash, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Washing Station")
	EndTextCommandSetBlipName(rockWash)

	local smeltStation = AddBlipForCoord(vector3(1086.25, -2003.75, 31.0))
	SetBlipSprite(smeltStation, 366)
	SetBlipScale(smeltStation, 0.8)
	SetBlipColour(smeltStation,17)
	SetBlipAsShortRange(smeltStation, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Smelting Station")
	EndTextCommandSetBlipName(smeltStation)

	local constructionStore = AddBlipForCoord(vector3(-514.1, -1039.15, 23.5))
	SetBlipSprite(constructionStore, 205)
	SetBlipScale(constructionStore, 0.8)
	SetBlipColour(constructionStore,17)
	SetBlipAsShortRange(constructionStore, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Construction Store")
	EndTextCommandSetBlipName(constructionStore)

	local gemDealer = AddBlipForCoord(vector3(1240.5, -3178.8, 7.108715))
	SetBlipSprite(gemDealer, 408)
	SetBlipScale(gemDealer, 0.8)
	SetBlipColour(gemDealer,38)
	SetBlipAsShortRange(gemDealer, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Gem Dealer")
	EndTextCommandSetBlipName(gemDealer)
end

createMiningPed = function()
	lib.requestModel('s_m_y_construct_01', 100)
	local miningPed = CreatePed('CIVMALE', 's_m_y_construct_01', 2832.705, 2795.488, 56.47633, 122.1001)
	FreezeEntityPosition(miningPed, true)
	TaskSetBlockingOfNonTemporaryEvents(miningPed, true)
	SetEntityInvincible(miningPed, true)
	TaskStartScenarioInPlace(miningPed, 'WORLD_HUMAN_SMOKING', 0, false)

	local options =	{
		{
			name = 'clock_in',
			onSelect = targetInteract,
			icon = 'fa-solid fa-helmet-safety',
			label = 'Clock In To Start Mining',
			canInteract = function(entity, distance, coords, name)
				return true
			end
		},
		{
			name = 'clock_out',
			onSelect = targetInteract,
			icon = 'fa-regular fa-clipboard',
			label = 'Clock Out To Stop Mining',
			canInteract = function(entity, distance, coords, name)
				return true
			end
		}
	}
	exports.ox_target:addLocalEntity(miningPed, options)
end 

createSmelterPed = function()
	lib.requestModel('s_m_y_construct_02', 100)
	local smelterPed = CreatePed('CIVMALE', 's_m_y_construct_02', 1087.964, -2001.379, 29.87953, 330.8158)
	FreezeEntityPosition(smelterPed, true)
	TaskSetBlockingOfNonTemporaryEvents(smelterPed, true)
	SetEntityInvincible(smelterPed, true)
	TaskStartScenarioInPlace(smelterPed, 'WORLD_HUMAN_SMOKING', 0, false)

	local options =	{
		{
			name = 'smelter_ped',
			onSelect = targetInteract,
			icon = 'fa-solid fa-helmet-safety',
			label = 'Speak To Smelting Works Foreman',
			canInteract = function(entity, distance, coords, name)
				return true
			end
		}
	}
	exports.ox_target:addLocalEntity(smelterPed, options)
end 

createGemDealer = function()
	lib.requestModel('u_m_y_ushi', 100)
	local GemDealer = CreatePed('CIVMALE', 'u_m_y_ushi', 1240.046, -3179.636, 6.105969, 358.6515)
	FreezeEntityPosition(GemDealer, true)
	TaskSetBlockingOfNonTemporaryEvents(GemDealer, true)
	SetEntityInvincible(GemDealer, true)
	TaskStartScenarioInPlace(GemDealer, 'WORLD_HUMAN_SMOKING', 0, false)

	local options =	{
		{
			name = 'jewellery_sell',
			onSelect = targetInteract,
			icon = 'fa-solid fa-helmet-safety',
			label = 'Speak To Gem Dealer?',
			canInteract = function(entity, distance, coords, name)
				return true
			end
		}
	}
	exports.ox_target:addLocalEntity(GemDealer, options)
end 

CreateTargets = function()
	createMiningPed()
	createSmelterPed()
	createGemDealer()

	exports.ox_target:addBoxZone({
		coords = Config.WashStation.coords,
		size = Config.WashStation.size,
		rotation = Config.WashStation.rotation,
		options = {
			{
				name = 'wash_rocks',
				onSelect = targetInteract,
				icon = 'fa-solid fa-hands-bubbles',
				label = 'Start Washing Rocks',
				canInteract = function(entity, distance, coords, name)
					return true
				end
			}
		}
	})
	exports.ox_target:addSphereZone({
		coords = vector3(1086.25, -2003.75, 31.0),
		radius = 2.75,
		options = {
			{
				name = 'smelt_ore',
				onSelect = targetInteract,
				icon = 'fa-solid fa-fire',
				label = 'Start Smelting Ore',
				canInteract = function(entity, distance, coords, name)
					return true
				end
			}
		}
	})
	exports.ox_target:addSphereZone({
		coords = vec3(-514.1, -1039.15, 23.5),
		radius = 1,
		options = {
			{
				name = 'construction_store',
				onSelect = targetInteract,
				icon = 'fa-solid fa-helmet-safety',
				label = 'Open Construction Store',
				canInteract = function(entity, distance, coords, name)
					return true
				end
			}
		}
	})
end

targetInteract = function(data)
	if data.name == 'clock_in' then 
		if not isMining then 
			isMining = true
			rockSpawn()
			ESX.ShowNotification('Youve Clocked In Head To The Lower Pit Mine To Start Breaking Rocks! Dont Forget To Clock Out Before Leaving!')
		else 
			ESX.ShowNotification('Youre Already Clocked In!')
		end
	elseif data.name == 'clock_out' then
		if isMining then 
			isMining = false
			removeTargets()
			ESX.ShowNotification('Youve Clocked Out Go To The Wash Station With The Broken Rocks!')
		else 
			ESX.ShowNotification('Youre Not Clocked In!')
		end
	elseif data.name == 'break_rock' then
		if not currentlyActive then 
			breakRock()
		else
			ESX.ShowNotification('Dont spam nerd!', flash, saveToBrief, hudColorIndex)
		end
	elseif data.name == 'smelt_ore' then
		if not currentlyActive then 
			smeltOre()
		else
			ESX.ShowNotification('Dont spam nerd!', flash, saveToBrief, hudColorIndex)
		end
	elseif data.name == 'wash_rocks' then
		if not currentlyActive then 
			washRocks()
		else
			ESX.ShowNotification('Dont spam nerd!', flash, saveToBrief, hudColorIndex)
		end
	elseif data.name == 'construction_store' then
		construction_store()
	elseif data.name == 'jewellery_sell' then
		jewellery_sell()
	elseif data.name == 'smelter_ped' then
		ESX.ShowNotification('What you looking at fool... Unless you got some ore for me youve no business here, If you do though throw it in with the rest behind me!')
	end
end

rockSpawn = function()
	number = math.random(1,#Config.MiningZones)
	for k,v in pairs(Config.MiningZones) do
		if k == number then
			drawMarker = true
			markerCoords = v.coords
			local target = exports.ox_target:addSphereZone({
				coords = v.coords,
				radius = v.radius,
				options = {
					{
						name = 'break_rock',
						onSelect = targetInteract,
						icon = 'fa-solid fa-location-crosshairs',
						label = 'Break Rock',
						canInteract = function(entity, distance, coords, name)
							return true
						end
					}
				}
			})
			table.insert(targetList, target)
		end
	end
end

removeTargets = function()
	for k,v in pairs(targetList) do 
		exports.ox_target:removeZone(v)
		targetList[k] = nil
	end
	drawMarker = false
	markerCoords = nil
end

breakRock = function()
	ESX.TriggerServerCallback('JD_Mining:getPickaxe', function(haspickaxe)
		if haspickaxe then
			currentlyActive = true 
			local anim = "melee@hatchet@streamed_core_fps"
			local action = "plyr_front_takedown"
			lib.requestAnimDict(anim, 100)
		
			local pickaxe = GetHashKey("prop_tool_pickaxe")
			local object = CreateObject(pickaxe, GetEntityCoords(playerPed), true, false, false)
			AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, 0.0, 0.0, -90.0, 25.0, 35.0, true, true, false, true, 1, true)
			
			FreezeEntityPosition(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'))
		
			TriggerEvent('bliss_progressbar:Start', 10000)
			TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
			Citizen.Wait(2000)
			TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
			Citizen.Wait(2000)
			TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
			Citizen.Wait(2000)
			TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
			Citizen.Wait(2000)
			TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
			Citizen.Wait(2000)
			
			ClearPedTasks(PlayerPedId())
			FreezeEntityPosition(playerPed, false)
			DeleteObject(object)
		
			removeTargets()
			Wait(1000)
			TriggerServerEvent('JD_Mining:rewardBrokenRocks')
			rockSpawn()
			currentlyActive = false
			TriggerServerEvent('JD_Mining:reducePickaxeDurability')
		else
			ESX.ShowNotification('You have no pickaxe!')
		end
	end)
end

washRocks = function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	ESX.TriggerServerCallback('JD_Mining:getRockCount', function(hasBrokenRocks)
		if hasBrokenRocks then 
			currentlyActive = true
			FreezeEntityPosition(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'))
			TriggerEvent('bliss_progressbar:Start', 10000)
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			Citizen.Wait(10000)
			ClearPedTasks(playerPed)
			FreezeEntityPosition(playerPed, false)
			TriggerServerEvent('JD_Mining:randomMiningRewards')
			currentlyActive = false
		else
			ESX.ShowNotification('You need at least 10 Broken Rocks before washnig, Head back to the pit mine to collect more!')
		end
	end)
end

smeltOre = function()
	local playerPed = PlayerPedId()

	ESX.TriggerServerCallback('JD_Mining:getOre', function(hasOre)
		if hasOre then 
			currentlyActive = true
			FreezeEntityPosition(playerPed, true)
			TriggerEvent('bliss_progressbar:Start', 10000)
			Citizen.Wait(10000)
			FreezeEntityPosition(playerPed, false)
			TriggerServerEvent('JD_Mining:smelterRewards')
			currentlyActive = false
		else
			ESX.ShowNotification('You need at least 2 Ore before smelting, Head back to the pit mine to collect more!')
		end
	end)
end

construction_store = function()
	lib.registerContext({
		id = 'construction_store',
		title = 'Construction Store',
		onExit = function()
			print('Hello there')
		end,
		options = {
			{
				title = 'Sell Construction Items?',
				serverEvent = 'JD_Mining:sellItems'
			}
		},
	})

	lib.showContext('construction_store')
end

jewellery_sell = function()
	lib.registerContext({
		id = 'jewellery_sell',
		title = 'Gemstone Store',
		options = {
			{
				title = 'Sell Gemstones?',
				serverEvent = 'JD_Mining:sellGems'
			}
		},
	})

	lib.showContext('jewellery_sell')
end

function onExit(self)
    if isMining then 
		isMining = false
		removeTargets()
		ESX.ShowNotification('Youve Clocked Out Go To The Wash Station With The Broken Rocks!')
	end
end

local poly = lib.zones.poly({
	points = {
		vec3(2490.0, 2812.0, 48.0),
		vec3(2698.0, 3027.0, 48.0),
		vec3(2917.0, 2945.0, 48.0),
		vec3(3023.0, 3073.0, 48.0),
		vec3(3120.0, 2970.0, 48.0),
		vec3(3093.0, 2714.0, 48.0),
		vec3(2954.0, 2622.0, 48.0),
		vec3(2831.0, 2742.0, 48.0),
		vec3(2687.0, 2688.0, 48.0),
		vec3(2561.0, 2691.0, 48.0),
	},
	thickness = 229.0,
    debug = false,
    onExit = onExit
})