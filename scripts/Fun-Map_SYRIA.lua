env.info( '*** JTF-1 SYRIA Fun Map MOOSE script ***' )
env.info( '*** JTF-1 MOOSE MISSION SCRIPT START ***' )


local JtfAdmin = true --activate admin menu option in admin slots

_SETTINGS:SetPlayerMenuOff()

-- XXX BEGIN MENU DEFINITIONS



-- ## CAP CONTROL
MenuCapTop = MENU_COALITION:New( coalition.side.BLUE, " ENEMY CAP CONTROL" )
	MenuCapNorth = MENU_COALITION:New( coalition.side.BLUE, "Syria North", MenuCapTop )
	MenuCapCentral = MENU_COALITION:New( coalition.side.BLUE, "Syria Central", MenuCapTop )
	MenuCapSouth = MENU_COALITION:New( coalition.side.BLUE, "Syria South", MenuCapTop )

-- ## GROUND ATTACK MISSIONS
MenuGroundTop = MENU_COALITION:New( coalition.side.BLUE, " GROUND ATTACK MISSIONS" )
	
	MenuCampAttack = MENU_COALITION:New( coalition.side.BLUE, " Camp Strike", MenuGroundTop )
	
	MenuConvoyAttack = MENU_COALITION:New( coalition.side.BLUE, " Convoy Strike", MenuGroundTop )
		MenuConvoyAttackNorth = MENU_COALITION:New( coalition.side.BLUE, " Syriia North", MenuConvoyAttack )
		MenuConvoyAttackCentral = MENU_COALITION:New( coalition.side.BLUE, " Syria Central", MenuConvoyAttack )
		MenuConvoyAttackSouth = MENU_COALITION:New( coalition.side.BLUE, " Syria South", MenuConvoyAttack )
	
	MenuAirfieldAttack = MENU_COALITION:New(coalition.side.BLUE, " Airfield Strike", MenuGroundTop )
		MenuAirfieldAttackNorth = MENU_COALITION:New( coalition.side.BLUE, " Syria East", MenuAirfieldAttack )
		MenuAirfieldAttackCentral = MENU_COALITION:New( coalition.side.BLUE, " Syria Central", MenuAirfieldAttack )
		MenuAirfieldAttackSouth = MENU_COALITION:New( coalition.side.BLUE, " Syria North", MenuAirfieldAttack )
	
	MenuFactoryAttack = MENU_COALITION:New(coalition.side.BLUE, " Factory Strike", MenuGroundTop )
		MenuFactoryAttackNorth = MENU_COALITION:New( coalition.side.BLUE, " Syria North", MenuFactoryAttack )
		MenuFactoryAttackCentral = MENU_COALITION:New( coalition.side.BLUE, " Syria Central", MenuFactoryAttack )
		MenuFactoryAttackSouth = MENU_COALITION:New( coalition.side.BLUE, " Syria South", MenuFactoryAttack )
	
	MenuBridgeAttack = MENU_COALITION:New(coalition.side.BLUE, " Bridge Strike", MenuGroundTop )
		MenuBridgeAttackNorth = MENU_COALITION:New( coalition.side.BLUE, " Syria North", MenuBridgeAttack )
		MenuBridgeAttackCentral = MENU_COALITION:New( coalition.side.BLUE, " Syria Central", MenuBridgeAttack )
		MenuBridgeAttackSouth = MENU_COALITION:New( coalition.side.BLUE, " Syria South", MenuBridgeAttack )
	
	MenuCommunicationsAttack = MENU_COALITION:New(coalition.side.BLUE, " WiP Communications Strike", MenuGroundTop )
	
	MenuC2Attack = MENU_COALITION:New(coalition.side.BLUE, " WiP C2 Strike", MenuGroundTop )

-- ## ANTI-SHIP MISSIONS
	--MenuAntiShipTop = MENU_COALITION:New(coalition.side.BLUE, " WiP ANTI-SHIP MISSIONS" ) -- WiP

-- ## STRIKE PACKAGE MISSIONS
	--MenuStrikePackageTop = MENU_COALITION:New(coalition.side.BLUE, " WiP STRIKE PACKAGE MISSIONS" ) -- WiP

-- ## FLEET DEFENCE MISSIONS
	--MenuFleetDefenceTop = MENU_COALITION:New(coalition.side.BLUE, " WiP FLEET DEFENCE MISSIONS" ) -- WiP
 

-- END MENU DEFINITIONS

-- BEGIN FUNCTIONS SECTION

function SpawnSupport (SupportSpawn) -- spawnobject, spawnzone

  --local SupportSpawn = _args[1]
  local SupportSpawnObject = SPAWN:New( SupportSpawn.spawnobject )

  SupportSpawnObject:InitLimit( 1, 50 )
    :OnSpawnGroup(
      function ( SpawnGroup )
        local SpawnIndex = SupportSpawnObject:GetSpawnIndexFromGroup( SpawnGroup )
        local CheckTanker = SCHEDULER:New( nil, 
        function ()
			if SpawnGroup then
				if SpawnGroup:IsNotInZone( SupportSpawn.spawnzone ) then
					SupportSpawnObject:ReSpawn( SpawnIndex )
				end
			end
        end,
        {}, 0, 60 )
      end
    )
    :InitRepeatOnLanding()
    :Spawn()


end -- function

-- END FUNCTIONS SECTION

-- BEGIN SUPPORT AIRCRAFT SECTION

----------------------------------------------------
--- define table of respawning support aircraft ---
----------------------------------------------------

TableSpawnSupport = { -- {spawnobjectname, spawnzone}
	{spawnobject = "Tanker_KC135MPRS_Shell1", spawnzone = ZONE:New("AR-5950")},
	{spawnobject = "Tanker_KC135_Texaco1", spawnzone = ZONE:New("AR-5950")},
	{spawnobject = "Tanker_C130_Arco1", spawnzone = ZONE:New("AR-5950")},
	{spawnobject = "AWACS_DARKSTAR", spawnzone = ZONE:New("AWACS")},
}

------------------------------
--- spawn support aircraft ---
------------------------------

for i, v in ipairs( TableSpawnSupport ) do
	SpawnSupport ( v )
	
end

-- END SUPPORT AIRCRAFT SECTION


-- BEGIN RANGE SECTION


-- END RANGE SECTION


-- BEGIN CONVOY ATTACK FUNCTIONS
--  ( Central, West ) 
function SpawnConvoy ( _args ) -- ConvoyTemplates, SpawnHost {conv, dest, destzone, strikecoords, is_open}, ConvoyType, ConvoyThreats

	local TemplateTable = _args[1]
	local SpawnHostTable = _args[2]
	local ConvoyType = _args[3]
	local ConvoyThreats = _args[4]
	
	
	local SpawnIndex = math.random ( 1, #SpawnHostTable )
	local SpawnHost = SpawnHostTable[SpawnIndex].conv
	local DestZone = SpawnHostTable[SpawnIndex].destzone

  --------------------------------------
  --- Create Mission Mark on F10 map ---
  --------------------------------------
  
  --MissionMapMark(CampTableIndex)
  local StrikeMarkZone = SpawnHost -- ZONE object for zone named in strikezone 
  local StrikeMarkZoneCoord = StrikeMarkZone:GetCoordinate() -- get coordinates of strikezone

  local StrikeMarkType = "Convoy"
  local StrikeMarkCoordsLLDMS = StrikeMarkZoneCoord:ToStringLLDMS(_SETTINGS:SetLL_Accuracy(0)) --TableStrikeAttack[StrikeIndex].strikecoords
  local StrikeMarkCoordsLLDDM = StrikeMarkZoneCoord:ToStringLLDDM(_SETTINGS:SetLL_Accuracy(3)) --TableStrikeAttack[StrikeIndex].strikecoords

  local StrikeMarkLabel = StrikeMarkType 
    .. " Strike\n" 
    .. StrikeMarkCoordsLLDMS
	.. "\n"
	.. StrikeMarkCoordsLLDDM

  local StrikeMark = StrikeMarkZoneCoord:MarkToAll(StrikeMarkLabel, true) -- add mark to map

  --SpawnCampsTable[ CampTableIndex ].strikemarkid = StrikeMark -- add mark ID to table 

	
	SpawnHost:InitRandomizeTemplate( TemplateTable )
		:OnSpawnGroup(
			function ( SpawnGroup )
				CheckConvoy = SCHEDULER:New( nil, 
					function()
						if SpawnGroup:IsPartlyInZone( DestZone ) then
							SpawnGroup:Destroy( false )
						end
					end,
					{}, 0, 60 
				)
			end
		)
		:Spawn()


	local ConvoyAttackBrief = "++++++++++++++++++++++++++++++++++++" 
		.."\n\nIntelligence is reporting an enemy "
		.. ConvoyType
		.. " convoy\nbelieved to be routing to "
		.. SpawnHostTable[SpawnIndex].dest .. "."
		.. "\n\nMission:  LOCATE AND DESTROY THE CONVOY."
		.. "\n\nLast Known Position:\n"
		.. StrikeMarkCoordsLLDMS
		.. "\n"
		.. StrikeMarkCoordsLLDDM
		.. "\n"
		.. ConvoyThreats
		.. "\n\n++++++++++++++++++++++++++++++++++++"
		
	MESSAGE:New( ConvoyAttackBrief, 30, "" ):ToAll()
	
		
end --function  


---------------------------------
--- On-demand convoy missions ---
---------------------------------

SpawnConvoys = { -- map portion, { spawn host, nearest town, Lat Long, destination zone, spawned status } ...
	west = {
		{ 
			conv = SPAWN:New( "CONVOY_01" ), 
			dest = "Gudauta Airfield", 
			destzone = ZONE:New("ConvoyObjective_01"), 
			coords = "43  21  58 N | 040  06  31 E", 
			is_open = true
		},
		{ 
			conv = SPAWN:New( "CONVOY_02" ), 
			dest = "Gudauta Airfield", 
			destzone = ZONE:New("ConvoyObjective_01"), 
			coords = "43  27  58 N | 040  32  34 E", 
			is_open = true
		},
		{ 
			conv = SPAWN:New( "CONVOY_03" ), 
			dest = "Sukhumi Airfield", 
			destzone = ZONE:New("ConvoyObjective_02"), 
			coords = "43  02  07 N | 041  27  14 E", 
			is_open = true
		},
		{ 
			conv = SPAWN:New( "CONVOY_04" ), 
			dest = "Sukhumi Airfield", 
			destzone = ZONE:New("ConvoyObjective_02"), 
			coords = "42  51  35 N | 041  46  39 E", 
			is_open = true
		},
	},
	central = {
		{ 
			conv = SPAWN:New( "CONVOY_05" ), 
			dest = "Kutaisi Airfield", 
			destzone = ZONE:New("ConvoyObjective_03"), 
			coords = "42  33  39 N | 042  51  17 E", 
			is_open = true
		},
		{ 
			conv = SPAWN:New( "CONVOY_06" ), 
			dest = "Kutaisi Airfield", 
			destzone = ZONE:New("ConvoyObjective_03"), 
			coords = "42  23  52 N | 043  02  27 E", 
			pen = true
		},
		{ 
			conv = SPAWN:New( "CONVOY_07" ), 
			dest = "Khashuri", 
			destzone = ZONE:New("ConvoyObjective_04"), 
			coords = "42  19  59 N | 043  23  08 E", 
			is_open = true
		},
		{ 
			conv = SPAWN:New( "CONVOY_08" ), 
			dest = "Khashuri", 
			destzone = ZONE:New("ConvoyObjective_04"), 
			coords = "42  19  05 N | 043  56  01 E", 
			is_open = true
		},
	}
}

ConvoyAttackSpawn = SPAWN:New( "CONVOY_Default" )

ConvoyHardTemplates = {
	"CONVOY_Hard_01",
	"CONVOY_Hard_02",
}
ConvoySoftTemplates = {
	"CONVOY_Soft_01",
	"CONVOY_Soft_02",
}

HardType = "Armoured"
SoftType = "Supply"
HardThreats = "\n\nThreats:  MBT, Radar SAM, I/R SAM, LIGHT ARMOR, AAA"
SoftThreats = "\n\nThreats:  LIGHT ARMOR, Radar SAM, I/R SAM, AAA"

-- ## Central Zones
_hard_central_args = {
	ConvoyHardTemplates,
	SpawnConvoys.central,
	HardType,
	HardThreats
}
--cmdConvoyAttackHardCentral = MENU_COALITION_COMMAND:New( coalition.side.BLUE," Armoured Convoy",MenuConvoyAttackCentral, SpawnConvoy, _hard_central_args )

_soft_central_args = {
	ConvoySoftTemplates,
	SpawnConvoys.central,
	SoftType,
	SoftThreats
}
--cmdConvoyAttackSoftCentral = MENU_COALITION_COMMAND:New( coalition.side.BLUE," Supply Convoy",MenuConvoyAttackCentral, SpawnConvoy, _soft_central_args )

-- ## West Zones
_hard_west_args = {
	ConvoyHardTemplates,
	SpawnConvoys.west,
	HardType,
	HardThreats
}
--cmdConvoyAttackHardWest = MENU_COALITION_COMMAND:New( coalition.side.BLUE," Armoured Convoy",MenuConvoyAttackWest, SpawnConvoy, _hard_west_args )

_soft_west_args = {
	ConvoySoftTemplates,
	SpawnConvoys.west,
	SoftType,
	SoftThreats
}
--cmdConvoyAttackSoftWest = MENU_COALITION_COMMAND:New( coalition.side.BLUE," Supply Convoy",MenuConvoyAttackWest, SpawnConvoy, _soft_west_args )



	
-- END CONVOY ATTACK SECTION


-- END CONVOY ATTACK FUNCTIONS






-- -- BEGIN ACM/BFM SECTION

-- --local SpawnBfm.groupName = nil

-- -- BFM/ACM Zones
-- BoxZone = ZONE_POLYGON:New( "Polygon_Box", GROUP:FindByName("zone_box") )
-- BfmAcmZoneMenu = ZONE_POLYGON:New( "Polygon_BFM_ACM", GROUP:FindByName("COYOTEABC") )
-- BfmAcmZone = ZONE:FindByName("Zone_BfmAcmFox")

-- -- MISSILE TRAINER

-- -- Create a new missile trainer object.
-- fox=FOX:New()

-- -- Add training zones.
-- fox:AddSafeZone(BfmAcmZoneFox)
-- fox:AddLaunchZone(BfmAcmZoneFox)
-- fox:SetExplosionDistance(300)
-- fox:SetDisableF10Menu()

-- -- Start missile trainer.
-- fox:Start()
-- fox:SetDebugOnOff(false)


-- -- Spawn Objects
-- AdvA4 = SPAWN:New( "ADV_A4" )		
-- Adv28 = SPAWN:New( "ADV_MiG28" )	
-- Adv27 = SPAWN:New( "ADV_Su27" )
-- Adv23 = SPAWN:New( "ADV_MiG23" )
-- Adv16 = SPAWN:New( "ADV_F16" )
-- Adv18 = SPAWN:New( "ADV_F18" )

-- -- will need to pass function caller (from menu) to each of these spawn functions.  
-- -- Then calculate spawn position/velocity relative to caller
-- function SpawnAdv(adv,qty,group,rng)
	-- range = rng * 1852
	-- hdg = group:GetHeading()
	-- pos = group:GetPointVec2()
	-- spawnPt = pos:Translate(range, hdg, true)
	-- spawnVec3 = spawnPt:GetVec3()
	-- if BoxZone:IsVec3InZone(spawnVec3) then
		-- MESSAGE:New("Cannot spawn adversary aircraft in The Box.\nChange course or increase your range from The Box, and try again."):ToGroup(group)
	-- else
		-- adv:InitGrouping(qty):InitHeading(hdg + 180):SpawnFromVec3(spawnVec3)
		-- MESSAGE:New("Adversary spawned."):ToGroup(group)
	-- end
-- end

-- function BuildMenuCommands (AdvMenu, MenuGroup, MenuName, BfmMenu, AdvType, AdvQty)

	-- _G[AdvMenu] = MENU_GROUP:New( MenuGroup, MenuName, BfmMenu)
		-- _G[AdvMenu .. "_rng5"] = MENU_GROUP_COMMAND:New( MenuGroup, "5 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 5)
		-- _G[AdvMenu .. "_rng10"] = MENU_GROUP_COMMAND:New( MenuGroup, "10 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 10)
		-- _G[AdvMenu .. "_rng20"] = MENU_GROUP_COMMAND:New( MenuGroup, "20 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 20)

-- end

-- function BuildMenus(AdvQty, MenuGroup, MenuName, SpawnBfmGroup)

	-- local AdvSuffix = "_" .. tostring(AdvQty)
	-- --local BfmMenu = "SpawnBfm" .. AdvSuffix

	-- BfmMenu = MENU_GROUP:New(MenuGroup, MenuName, SpawnBfmGroup)
	
		-- BuildMenuCommands("SpawnBfmA4menu" .. AdvSuffix, MenuGroup, "Adversary A-4", BfmMenu, AdvA4, AdvQty)
		-- BuildMenuCommands("SpawnBfm28menu" .. AdvSuffix, MenuGroup, "Adversary MiG-28", BfmMenu, Adv28, AdvQty)
		-- BuildMenuCommands("SpawnBfm23menu" .. AdvSuffix, MenuGroup, "Adversary MiG-23", BfmMenu, Adv23, AdvQty)
		-- BuildMenuCommands("SpawnBfm27menu" .. AdvSuffix, MenuGroup, "Adversary Su-27", BfmMenu, Adv27, AdvQty)
		-- BuildMenuCommands("SpawnBfm16menu" .. AdvSuffix, MenuGroup, "Adversary F-16", BfmMenu, Adv16, AdvQty)
		-- BuildMenuCommands("SpawnBfm18menu" .. AdvSuffix, MenuGroup, "Adversary F-18", BfmMenu, Adv18, AdvQty)		
			
-- end
-- -- CLIENTS
-- BLUFOR = SET_GROUP:New():FilterCoalitions( "blue" ):FilterStart()

-- -- SPAWN AIR MENU
-- local SetClient = SET_CLIENT:New():FilterCoalitions("blue"):FilterStart() -- create a list of all clients

-- local function MENU()
	-- SetClient:ForEachClient(function(client)
		-- if (client ~= nil) and (client:IsAlive()) then 
 
			-- local group = client:GetGroup()
			-- local groupName = group:GetName()
			
			-- if group:IsPartlyOrCompletelyInZone(BfmAcmZoneMenu) then
				-- if _G["SpawnBfm" .. groupName] == nil then
					-- MenuGroup = group
					-- --MenuGroupName = MenuGroup:GetName()

					-- _G["SpawnBfm" .. groupName] = MENU_GROUP:New( MenuGroup, "AI BFM/ACM" )
						-- BuildMenus(1, MenuGroup, "Single", _G["SpawnBfm" .. groupName])
						-- BuildMenus(2, MenuGroup, "Pair", _G["SpawnBfm" .. groupName])

					-- MESSAGE:New("You have entered the BFM/ACM zone.\nUse F10 menu to spawn adversaries."):ToGroup(group)
					-- env.info("BFM/ACM entry Player name: " ..client:GetPlayerName())
					-- env.info("BFM/ACM entry Group Name: " ..group:GetName())
					-- --SetClient:Remove(client:GetName(), true)
				-- end
			-- elseif _G["SpawnBfm" .. groupName] ~= nil then
				-- if group:IsNotInZone(BfmAcmZone) then
					-- _G["SpawnBfm" .. groupName]:Remove()
					-- _G["SpawnBfm" .. groupName] = nil
					-- MESSAGE:New("You are outside the ACM/BFM zone."):ToGroup(group)
					-- env.info("BFM/ACM exit Group Name: " ..group:GetName())
				-- end
			-- end
		-- end
	-- end)
-- timer.scheduleFunction(MENU,nil,timer.getTime() + 5)
-- end

-- MENU()

-- -- END ACM/BFM SECTION


-- ADMIN SECTION

SetAdminClient = SET_CLIENT:New():FilterStart()

local function restartMission()
	trigger.action.setUserFlag("999", true)
end

local function BuildAdminMenu()
	SetAdminClient:ForEachClient(function(client)
		
		if (client ~= nil) and (client:IsAlive()) then
			adminGroup = client:GetGroup()
			adminGroupName = adminGroup:GetName()

			env.info("ADMIN Player name: " ..client:GetPlayerName())
			env.info("ADMIN Group Name: " ..adminGroupName)

			
			if string.find(adminGroupName, "XX_ADMIN") then
				adminMenu = MENU_GROUP:New(adminGroup, "ADMIN")
				MENU_GROUP_COMMAND:New(adminGroup, "Restart Mission", adminMenu, restartMission )
			end
		SetAdminClient:Remove(client:GetName(), true)
		end
	end)
	timer.scheduleFunction(BuildAdminMenu, nil, timer.getTime() + 10)
end

if JtfAdmin then
	env.info("ADMIN enabled")
	BuildAdminMenu()
end

--END ADMIN SECTION

env.info( '*** JTF-1 MOOSE MISSION SCRIPT END ***' )
