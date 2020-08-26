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
