-- -- BEGIN CONVOY ATTACK FUNCTIONS
-- --  ( Central, West ) 
-- function SpawnConvoy ( _args ) -- ConvoyTemplates, SpawnHost {conv, dest, destzone, strikecoords, is_open}, ConvoyType, ConvoyThreats

	-- local TemplateTable = _args[1]
	-- local SpawnHostTable = _args[2]
	-- local ConvoyType = _args[3]
	-- local ConvoyThreats = _args[4]
	
	
	-- local SpawnIndex = math.random ( 1, #SpawnHostTable )
	-- local SpawnHost = SpawnHostTable[SpawnIndex].conv
	-- local DestZone = SpawnHostTable[SpawnIndex].destzone

  -- --------------------------------------
  -- --- Create Mission Mark on F10 map ---
  -- --------------------------------------
  
  -- --MissionMapMark(CampTableIndex)
  -- local StrikeMarkZone = SpawnHost -- ZONE object for zone named in strikezone 
  -- local StrikeMarkZoneCoord = StrikeMarkZone:GetCoordinate() -- get coordinates of strikezone

  -- local StrikeMarkType = "Convoy"
  -- local StrikeMarkCoordsLLDMS = StrikeMarkZoneCoord:ToStringLLDMS(_SETTINGS:SetLL_Accuracy(0)) --TableStrikeAttack[StrikeIndex].strikecoords
  -- local StrikeMarkCoordsLLDDM = StrikeMarkZoneCoord:ToStringLLDDM(_SETTINGS:SetLL_Accuracy(3)) --TableStrikeAttack[StrikeIndex].strikecoords

  -- local StrikeMarkLabel = StrikeMarkType 
    -- .. " Strike\n" 
    -- .. StrikeMarkCoordsLLDMS
	-- .. "\n"
	-- .. StrikeMarkCoordsLLDDM

  -- local StrikeMark = StrikeMarkZoneCoord:MarkToAll(StrikeMarkLabel, true) -- add mark to map

  -- --SpawnCampsTable[ CampTableIndex ].strikemarkid = StrikeMark -- add mark ID to table 

	
	-- SpawnHost:InitRandomizeTemplate( TemplateTable )
		-- :OnSpawnGroup(
			-- function ( SpawnGroup )
				-- CheckConvoy = SCHEDULER:New( nil, 
					-- function()
						-- if SpawnGroup:IsPartlyInZone( DestZone ) then
							-- SpawnGroup:Destroy( false )
						-- end
					-- end,
					-- {}, 0, 60 
				-- )
			-- end
		-- )
		-- :Spawn()


	-- local ConvoyAttackBrief = "++++++++++++++++++++++++++++++++++++" 
		-- .."\n\nIntelligence is reporting an enemy "
		-- .. ConvoyType
		-- .. " convoy\nbelieved to be routing to "
		-- .. SpawnHostTable[SpawnIndex].dest .. "."
		-- .. "\n\nMission:  LOCATE AND DESTROY THE CONVOY."
		-- .. "\n\nLast Known Position:\n"
		-- .. StrikeMarkCoordsLLDMS
		-- .. "\n"
		-- .. StrikeMarkCoordsLLDDM
		-- .. "\n"
		-- .. ConvoyThreats
		-- .. "\n\n++++++++++++++++++++++++++++++++++++"
		
	-- MESSAGE:New( ConvoyAttackBrief, 30, "" ):ToAll()
	
		
-- end --function  


---------------------------------
--- On-demand convoy missions ---
---------------------------------

-- SpawnConvoys = { -- map portion, { spawn host, nearest town, Lat Long, destination zone, spawned status } ...
	-- west = {
		-- { 
			-- conv = SPAWN:New( "CONVOY_01" ), 
			-- dest = "Gudauta Airfield", 
			-- destzone = ZONE:New("ConvoyObjective_01"), 
			-- coords = "43  21  58 N | 040  06  31 E", 
			-- is_open = true
		-- },
		-- { 
			-- conv = SPAWN:New( "CONVOY_02" ), 
			-- dest = "Gudauta Airfield", 
			-- destzone = ZONE:New("ConvoyObjective_01"), 
			-- coords = "43  27  58 N | 040  32  34 E", 
			-- is_open = true
		-- },
		-- { 
			-- conv = SPAWN:New( "CONVOY_03" ), 
			-- dest = "Sukhumi Airfield", 
			-- destzone = ZONE:New("ConvoyObjective_02"), 
			-- coords = "43  02  07 N | 041  27  14 E", 
			-- is_open = true
		-- },
		-- { 
			-- conv = SPAWN:New( "CONVOY_04" ), 
			-- dest = "Sukhumi Airfield", 
			-- destzone = ZONE:New("ConvoyObjective_02"), 
			-- coords = "42  51  35 N | 041  46  39 E", 
			-- is_open = true
		-- },
	-- },
	-- central = {
		-- { 
			-- conv = SPAWN:New( "CONVOY_05" ), 
			-- dest = "Kutaisi Airfield", 
			-- destzone = ZONE:New("ConvoyObjective_03"), 
			-- coords = "42  33  39 N | 042  51  17 E", 
			-- is_open = true
		-- },
		-- { 
			-- conv = SPAWN:New( "CONVOY_06" ), 
			-- dest = "Kutaisi Airfield", 
			-- destzone = ZONE:New("ConvoyObjective_03"), 
			-- coords = "42  23  52 N | 043  02  27 E", 
			-- pen = true
		-- },
		-- { 
			-- conv = SPAWN:New( "CONVOY_07" ), 
			-- dest = "Khashuri", 
			-- destzone = ZONE:New("ConvoyObjective_04"), 
			-- coords = "42  19  59 N | 043  23  08 E", 
			-- is_open = true
		-- },
		-- { 
			-- conv = SPAWN:New( "CONVOY_08" ), 
			-- dest = "Khashuri", 
			-- destzone = ZONE:New("ConvoyObjective_04"), 
			-- coords = "42  19  05 N | 043  56  01 E", 
			-- is_open = true
		-- },
	-- }
-- }

-- ConvoyAttackSpawn = SPAWN:New( "CONVOY_Default" )

-- ConvoyHardTemplates = {
	-- "CONVOY_Hard_01",
	-- "CONVOY_Hard_02",
-- }
-- ConvoySoftTemplates = {
	-- "CONVOY_Soft_01",
	-- "CONVOY_Soft_02",
-- }

-- HardType = "Armoured"
-- SoftType = "Supply"
-- HardThreats = "\n\nThreats:  MBT, Radar SAM, I/R SAM, LIGHT ARMOR, AAA"
-- SoftThreats = "\n\nThreats:  LIGHT ARMOR, Radar SAM, I/R SAM, AAA"

-- -- ## Central Zones
-- _hard_central_args = {
	-- ConvoyHardTemplates,
	-- SpawnConvoys.central,
	-- HardType,
	-- HardThreats
-- }
-- --cmdConvoyAttackHardCentral = MENU_COALITION_COMMAND:New( coalition.side.BLUE,"Armoured Convoy",MenuConvoyAttackCentral, SpawnConvoy, _hard_central_args )

-- _soft_central_args = {
	-- ConvoySoftTemplates,
	-- SpawnConvoys.central,
	-- SoftType,
	-- SoftThreats
-- }
-- --cmdConvoyAttackSoftCentral = MENU_COALITION_COMMAND:New( coalition.side.BLUE,"Supply Convoy",MenuConvoyAttackCentral, SpawnConvoy, _soft_central_args )

-- -- ## West Zones
-- _hard_west_args = {
	-- ConvoyHardTemplates,
	-- SpawnConvoys.west,
	-- HardType,
	-- HardThreats
-- }
-- --cmdConvoyAttackHardWest = MENU_COALITION_COMMAND:New( coalition.side.BLUE,"Armoured Convoy",MenuConvoyAttackWest, SpawnConvoy, _hard_west_args )

-- _soft_west_args = {
	-- ConvoySoftTemplates,
	-- SpawnConvoys.west,
	-- SoftType,
	-- SoftThreats
-- }
-- --cmdConvoyAttackSoftWest = MENU_COALITION_COMMAND:New( coalition.side.BLUE,"Supply Convoy",MenuConvoyAttackWest, SpawnConvoy, _soft_west_args )



	
-- -- END CONVOY ATTACK SECTION


-- END CONVOY ATTACK FUNCTIONS



