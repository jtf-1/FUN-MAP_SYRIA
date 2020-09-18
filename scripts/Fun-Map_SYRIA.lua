env.info( '*** JTF-1 SYRIA Fun Map MOOSE script ***' )
env.info( '*** JTF-1 MOOSE MISSION SCRIPT START ***' )


local jtfAdmin = true --activate admin menu option in admin slots
local jtfDebugMenu = false -- activate debug menu options

_SETTINGS:SetPlayerMenuOff()

-- XXX BEGIN MENU DEFINITIONS

-- AI BFM/ACM

menuAcmBfmTop = MENU_COALITION:New( coalition.side.BLUE, "ACM/BFM" )

-- ## CAP CONTROL
MenuCapTop = MENU_COALITION:New( coalition.side.BLUE, "WiP ENEMY CAP CONTROL" )
	MenuCapNorth = MENU_COALITION:New( coalition.side.BLUE, "Syria North", MenuCapTop )
	MenuCapCentral = MENU_COALITION:New( coalition.side.BLUE, "Syria Central", MenuCapTop )
	MenuCapSouth = MENU_COALITION:New( coalition.side.BLUE, "Syria South", MenuCapTop )

-- ## GROUND ATTACK MISSIONS
MenuGroundTop = MENU_COALITION:New( coalition.side.BLUE, "WiP GROUND ATTACK MISSIONS" )
	
	MenuCampAttack = MENU_COALITION:New( coalition.side.BLUE, "Camp Strike", MenuGroundTop )
	
	MenuConvoyAttack = MENU_COALITION:New( coalition.side.BLUE, "Convoy Strike", MenuGroundTop )
		MenuConvoyAttackNorth = MENU_COALITION:New( coalition.side.BLUE, "Syriia North", MenuConvoyAttack )
		MenuConvoyAttackCentral = MENU_COALITION:New( coalition.side.BLUE, "Syria Central", MenuConvoyAttack )
		MenuConvoyAttackSouth = MENU_COALITION:New( coalition.side.BLUE, "Syria South", MenuConvoyAttack )
	
	MenuAirfieldAttack = MENU_COALITION:New(coalition.side.BLUE, "Airfield Strike", MenuGroundTop )
		MenuAirfieldAttackNorth = MENU_COALITION:New( coalition.side.BLUE, "Syria East", MenuAirfieldAttack )
		MenuAirfieldAttackCentral = MENU_COALITION:New( coalition.side.BLUE, "Syria Central", MenuAirfieldAttack )
		MenuAirfieldAttackSouth = MENU_COALITION:New( coalition.side.BLUE, "Syria North", MenuAirfieldAttack )
	
	MenuFactoryAttack = MENU_COALITION:New(coalition.side.BLUE, "Factory Strike", MenuGroundTop )
		MenuFactoryAttackNorth = MENU_COALITION:New( coalition.side.BLUE, "Syria North", MenuFactoryAttack )
		MenuFactoryAttackCentral = MENU_COALITION:New( coalition.side.BLUE, "Syria Central", MenuFactoryAttack )
		MenuFactoryAttackSouth = MENU_COALITION:New( coalition.side.BLUE, "Syria South", MenuFactoryAttack )
	
	MenuBridgeAttack = MENU_COALITION:New(coalition.side.BLUE, "Bridge Strike", MenuGroundTop )
		MenuBridgeAttackNorth = MENU_COALITION:New( coalition.side.BLUE, "Syria North", MenuBridgeAttack )
		MenuBridgeAttackCentral = MENU_COALITION:New( coalition.side.BLUE, "Syria Central", MenuBridgeAttack )
		MenuBridgeAttackSouth = MENU_COALITION:New( coalition.side.BLUE, "Syria South", MenuBridgeAttack )
	
	MenuCommunicationsAttack = MENU_COALITION:New(coalition.side.BLUE, "WiP Communications Strike", MenuGroundTop )
	
	MenuC2Attack = MENU_COALITION:New(coalition.side.BLUE, "WiP C2 Strike", MenuGroundTop )

-- ## ANTI-SHIP MISSIONS
	--MenuAntiShipTop = MENU_COALITION:New(coalition.side.BLUE, "WiP ANTI-SHIP MISSIONS" ) -- WiP

-- ## STRIKE PACKAGE MISSIONS
	--MenuStrikePackageTop = MENU_COALITION:New(coalition.side.BLUE, "WiP STRIKE PACKAGE MISSIONS" ) -- WiP

-- ## FLEET DEFENCE MISSIONS
	--MenuFleetDefenceTop = MENU_COALITION:New(coalition.side.BLUE, "WiP FLEET DEFENCE MISSIONS" ) -- WiP
 

-- END MENU DEFINITIONS

-- BEGIN FUNCTIONS SECTION

function SpawnSupport (SupportSpawn) -- spawnobject, spawnzone

  --local SupportSpawn = _args[1]
  local SupportSpawnObject = SPAWN:New( SupportSpawn.spawnobject )
  local SupportSpawnZone = ZONE:FindByName( SupportSpawn.spawnzone )

  SupportSpawnObject:InitLimit( 1, 50 )
    :OnSpawnGroup(
      function ( SpawnGroup )
        local SpawnIndex = SupportSpawnObject:GetSpawnIndexFromGroup( SpawnGroup )
        local CheckTanker = SCHEDULER:New( nil, 
        function ()
			if SpawnGroup then
				if SpawnGroup:IsNotInZone( SupportSpawnZone ) then
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

local function clearGroupSpawns(groupPrefix) -- remove AI group spawns
	local activeGroupSpawns = SET_GROUP:New()
	activeGroupSpawns:FilterPrefixes(groupPrefix)
		:FilterStart()
	
	activeGroupSpawns:ForEachGroupAlive(function(group)
		group:Destroy()
	end)

end -- function

-- END FUNCTIONS SECTION

-- BEGIN SUPPORT AIRCRAFT SECTION

----------------------------------------------------
--- define table of respawning support aircraft ---
----------------------------------------------------

TableSpawnSupport = { -- {spawnobjectname, spawnzone}
	{spawnobject = "Tanker_KC135MPRS_Shell1", spawnzone = "AR-5950"},
	{spawnobject = "Tanker_KC135_Texaco1", spawnzone = "AR-5950"},
	{spawnobject = "Tanker_C130_Arco1", spawnzone = "AR-5950"},
	{spawnobject = "AWACS_DARKSTAR", spawnzone = "AWACS"},
}

------------------------------
--- spawn support aircraft ---
------------------------------

for i, v in ipairs( TableSpawnSupport ) do
	SpawnSupport ( v )
	
end

-- END SUPPORT AIRCRAFT SECTION




-- BEGIN RANGE SECTION

-- RANGE YG44 (CLASS A)
local bombtarget_YG44 = {
	"YG44 Class A Range-BombCircle_West",
	"YG44 Class A Range-BombCircle_West",
	"YG44 Class A Range-TacStrafe_01",
	"YG44 Class A Range-TacStrafe_02",
	"YG44 Class A Range-TacStrafe_03",
	"YG44 Class A Range-TacStrafe_04",
	"YG44 Class A Range-TacStrafe_05",
	"YG44 Class A Range-TacStrafe_06",
	"YG44 Class A Range-TacStrafe_07",
	"YG44 Class A Range-TacStrafe_08",
	}
	
local strafe_YG44_West = {
	"YG44 Class A Range-Strafepit_West_01",
	"YG44 Class A Range-Strafepit_West_02",
	"YG44 Class A Range-Strafepit_West_03"
	}
	
local strafe_YG44_East = {
	"YG44 Class A Range-Strafepit_East_01",
	"YG44 Class A Range-Strafepit_East_02",
	"YG44 Class A Range-Strafepit_East_03",
	}

Range_YG44 = RANGE:New("Range YG44")
Range_YG44:SetRangeZone(ZONE:FindByName("Zone_Range_YG44"))

Range_YG44:AddBombingTargets(bombtarget_YG44)

local FoulDist_YG44_Strafe = Range_YG44:GetFoullineDistance("YG44 Class A Range-Strafepit_West_02", "YG44 Class A Range-Fouline_West")
Range_YG44:AddStrafePit(strafe_YG44_West, 3000, 300, nil, true, 20, FoulDist_YG44_Strafe)
Range_YG44:AddStrafePit(strafe_YG44_East, 3000, 300, nil, true, 20, FoulDist_YG44_Strafe)

Range_YG44:SetSoundfilesPath("Range Soundfiles/")
Range_YG44:SetRangeControl(250.250)

Range_YG44:Start()

-- END RANGE YG44

-- END RANGE SECTION




-- BEGIN ACM/BFM SECTION

menuBfmAcmRemoveSpawns = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear all BFM/ACM spawns", menuAcmBfmTop, clearGroupSpawns, "ADVERSARY_" ) -- remove all BFM/ACM spawn groups


-- BFM/ACM Zones
BfmAcmZoneMenu = ZONE:FindByName("Zone_BfmAcmMenu")
BfmAcmZone = ZONE:FindByName("Zone_BfmAcmFox")

-- MISSILE TRAINER
-- Create a new missile trainer object.
fox=FOX:New()

-- Add training zones.
fox:AddSafeZone(Zone_BfmAcmFox)
fox:AddLaunchZone(Zone_BfmAcmFox)
fox:SetExplosionDistance(300)
fox:SetDisableF10Menu()

-- Start missile trainer.
fox:Start()
fox:SetDebugOnOff(false)


-- ACM
-- Spawn Objects
AdvA4 = SPAWN:New( "ADVERSARY_A4" )		
Adv28 = SPAWN:New( "ADVERSARY_MiG28" )	
Adv27 = SPAWN:New( "ADVERSARY_Su27" )
Adv23 = SPAWN:New( "ADVERSARY_MiG23" )
Adv16 = SPAWN:New( "ADVERSARY_F16" )
Adv18 = SPAWN:New( "ADVERSARY_F18" )

-- will need to pass function caller (from menu) to each of these spawn functions.  
-- Then calculate spawn position/velocity relative to caller
function SpawnAdvBfm(adv,qty,group,rng)
	range = rng * 1852
	hdg = group:GetHeading()
	pos = group:GetPointVec2()
	spawnPt = pos:Translate(range, hdg, true)
	spawnVec3 = spawnPt:GetVec3()
	adv:InitGrouping(qty):InitHeading(hdg + 180):SpawnFromVec3(spawnVec3)
	MESSAGE:New("BFM Adversary spawned."):ToGroup(group)
end

function SpawnAdvAcm(adv,qty,group)
	hdg = 80
	zoneAcm = ZONE:FindByName("Zone_AcmSpawn")
	adv:InitGrouping(qty):InitHeading(90):SpawnInZone( zoneAcm, false, 5000, 7500 )
	MESSAGE:New("ACM Adversary spawned."):ToGroup(group)
end


function BuildMenuCommandsBfmAcm (AdvMenu, MenuGroup, MenuName, ParentMenu, AdvType, EngType, AdvQty)

	if EngType == "ACM" then
		_G[AdvMenu] = MENU_GROUP:New( MenuGroup, MenuName, ParentMenu)
			_G[AdvMenu .. "_single"] = MENU_GROUP_COMMAND:New( MenuGroup, "Single", _G[AdvMenu], SpawnAdvAcm, AdvType, 1, MenuGroup )
			_G[AdvMenu .. "_pair"] = MENU_GROUP_COMMAND:New( MenuGroup, "Pair", _G[AdvMenu], SpawnAdvAcm, AdvType, 2, MenuGroup )
			_G[AdvMenu .. "_four"] = MENU_GROUP_COMMAND:New( MenuGroup, "Four", _G[AdvMenu], SpawnAdvAcm, AdvType, 4, MenuGroup )
	else
		_G[AdvMenu] = MENU_GROUP:New( MenuGroup, MenuName, ParentMenu)
			_G[AdvMenu .. "_rng5"] = MENU_GROUP_COMMAND:New( MenuGroup, "5 nmi", _G[AdvMenu], SpawnAdvBfm, AdvType, AdvQty, MenuGroup, 5)
			_G[AdvMenu .. "_rng10"] = MENU_GROUP_COMMAND:New( MenuGroup, "10 nmi", _G[AdvMenu], SpawnAdvBfm, AdvType, AdvQty, MenuGroup, 10)
			_G[AdvMenu .. "_rng20"] = MENU_GROUP_COMMAND:New( MenuGroup, "20 nmi", _G[AdvMenu], SpawnAdvBfm, AdvType, AdvQty, MenuGroup, 20)
	end
end

function BuildMenusBfmAcm(MenuGroup, MenuName, SpawnGroup, EngType, AdvQty)
	
	if EngType == "ACM" then
		AdvSuffix = "_ACM"
		BfmAcmMenu = SpawnGroup
	else
		AdvSuffix = "_BFM_" .. tostring(AdvQty)
		BfmAcmMenu = MENU_GROUP:New(MenuGroup, MenuName, SpawnGroup)
	end

	BuildMenuCommandsBfmAcm("SpawnA4menu" .. AdvSuffix, MenuGroup, "Adversary A-4", BfmAcmMenu, AdvA4, EngType, AdvQty)
	BuildMenuCommandsBfmAcm("Spawn28menu" .. AdvSuffix, MenuGroup, "Adversary MiG-28", BfmAcmMenu, Adv28, EngType, AdvQty)
	BuildMenuCommandsBfmAcm("Spawn23menu" .. AdvSuffix, MenuGroup, "Adversary MiG-23", BfmAcmMenu, Adv23, EngType, AdvQty)
	BuildMenuCommandsBfmAcm("Spawn27menu" .. AdvSuffix, MenuGroup, "Adversary Su-27", BfmAcmMenu, Adv27, EngType, AdvQty)
	BuildMenuCommandsBfmAcm("Spawn16menu" .. AdvSuffix, MenuGroup, "Adversary F-16", BfmAcmMenu, Adv16, EngType, AdvQty)
	BuildMenuCommandsBfmAcm("Spawn18menu" .. AdvSuffix, MenuGroup, "Adversary F-18", BfmAcmMenu, Adv18, EngType, AdvQty)		

end

function BuildMenuCommandsAcm ()

end
-- CLIENTS
BLUFOR = SET_GROUP:New():FilterCoalitions( "blue" ):FilterStart()

-- SPAWN AIR MENU
local SetClient = SET_CLIENT:New():FilterCoalitions("blue"):FilterStart() -- create a list of all clients

local function BFMACM_MENU()
	SetClient:ForEachClient(function(client)
		if (client ~= nil) and (client:IsAlive()) then 
 
			local group = client:GetGroup()
			local groupName = group:GetName()
			
			if group:IsPartlyOrCompletelyInZone(BfmAcmZoneMenu) then
				MenuGroup = group

				if _G["SpawnBfm" .. groupName] == nil then -- add BFM/ACM menus
					MenuGroup = group

					_G["SpawnBfm" .. groupName] = MENU_GROUP:New( MenuGroup, "BFM", menuAcmBfmTop ) -- BFM Menus
						BuildMenusBfmAcm(MenuGroup, "Single", _G["SpawnBfm" .. groupName], "BFM", 1)
						BuildMenusBfmAcm(MenuGroup, "Pair", _G["SpawnBfm" .. groupName], "BFM", 1)
					
					_G["SpawnAcm" .. groupName] = MENU_GROUP:New( MenuGroup, "ACM", menuAcmBfmTop ) -- BFM Menus
						BuildMenusBfmAcm(MenuGroup, "", _G["SpawnAcm" .. groupName], "ACM")

					--_G["ClearBfmAcm" .. groupName] = MENU_GROUP_COMMAND:New(MenuGroup, "Clear BFM/ACM spawns", menuAcmBfmTop, clearGroupSpawns, "ADVERSARY_" ) -- remove all BFM/ACM spawn groups


					MESSAGE:New("You have entered the BFM/ACM zone.\nUse F10 ACM/BFM menu to spawn adversaries."):ToGroup(group)
					env.info("BFM/ACM entry Player name: " ..client:GetPlayerName())
					env.info("BFM/ACM entry Group Name: " ..group:GetName())
				end
			elseif _G["SpawnBfm" .. groupName] ~= nil then
			
				if group:IsNotInZone(BfmAcmZone) then
					_G["SpawnBfm" .. groupName]:Remove()
					_G["SpawnBfm" .. groupName] = nil
					_G["SpawnAcm" .. groupName]:Remove()
					_G["SpawnAcm" .. groupName] = nil

					MESSAGE:New("You are outside the ACM/BFM zone."):ToGroup(group)
					env.info("BFM/ACM exit Group Name: " ..group:GetName())
				end
			end
		end
	end)
timer.scheduleFunction(BFMACM_MENU,nil,timer.getTime() + 5)
end

BFMACM_MENU()

-- END ACM/BFM SECTION




-- ADMIN SECTION

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

if jtfAdmin then
	env.info("JTF-1 ADMIN enabled")
	SetAdminClient = SET_CLIENT:New():FilterStart()
	BuildAdminMenu()
end

if jtfDebugMenu then
	debugMenu = MENU_COALITION:New( coalition.side.BLUE, " DEBUG" )
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Restart Mission", debugMenu, restartMission )	
end

--END ADMIN SECTION




env.info( '*** JTF-1 MOOSE MISSION SCRIPT END ***' )
