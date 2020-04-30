local looting = false

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0,1101824977) and not IsPedInAnyVehicle(player, true) and not looting then
			local shape = true
			while shape do
				Wait(0)
				local player = PlayerPedId()
				local coords = GetEntityCoords(player)
				local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 8, player)
				local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
				local isHuman = IsPedHuman(entityHit)
				local dead = IsEntityDead(entityHit)
				local PressTime = 0
				if isHuman and dead then
					local looted = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
					if not looted then
						shape = false
						looting = true
						PressTime = GetGameTimer()
						while looting do
							Wait(0)
							local looted = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
							if IsControlJustReleased(0,1101824977) and not looted then
								KeyHeldTime = GetGameTimer() - PressTime
								PressTime = 0
								if KeyHeldTime > 250 then
									looting = false
									TaskLootEntity(player, entityHit)
									local loot = math.random(1, 10)
									local lootpay = loot / 100
									TriggerServerEvent('cryptos_loot', lootpay)
								else
									looting = false
								end
							end
						end
					end
				end
			end
		end
    end
end)
