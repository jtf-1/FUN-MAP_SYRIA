--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Name: Operation Blackpool
-- Author: Surrexen    à¼¼ ã�¤ â—•_â—• à¼½ã�¤    (ã�¥ï½¡â—•â€¿â—•ï½¡)ã�¥ 
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////MISSION LOGIC FUNCTIONS

function SEF_MissionSelector()	
	
	if ( NumberOfCompletedMissions >= TotalScenarios ) then
			
		OperationComplete = true
		trigger.action.outText("Operation Blackpool Has Been Successful", 15)
		--WRITE PROGRESS TABLES TO EMPTY AND SAVE WITH NO ARGUMENTS
		BlackpoolUnitInterment = {}
		SEF_SaveUnitIntermentTableNoArgs()
		BlackpoolStaticInterment = {}
		SEF_SaveStaticIntermentTableNoArgs()			
	else
		Randomiser = math.random(1,TotalScenarios)
		if ( trigger.misc.getUserFlag(Randomiser) > 0 ) then
			--SELECTED MISSION [Randomiser] ALREADY DONE, FLAG VALUE >=1, SELECT ANOTHER ONE
			SEF_MissionSelector()
		elseif ( trigger.misc.getUserFlag(Randomiser) == 0 ) then
			--SELECTED MISSION [Randomiser] IS AVAILABLE TO START, SET TO STARTED AND VALIDATE
			trigger.action.setUserFlag(Randomiser,1)
			SEF_RetrieveMissionInformation(Randomiser)
			--trigger.action.outText("Validating Mission Number "..Randomiser.." For Targeting", 15)
			SEF_ValidateMission()										
		else
			trigger.action.outText("Mission Selection Error", 15)
		end
	end		
end

function SEF_RetrieveMissionInformation ( MissionNumber )
	
	--SET GLOBAL VARIABLES TO THE SELECTED MISSION
	ScenarioNumber = MissionNumber
	AGMissionTarget = OperationBlackpool_AG[MissionNumber].TargetName
	AGTargetTypeStatic = OperationBlackpool_AG[MissionNumber].TargetStatic
	AGMissionBriefingText = OperationBlackpool_AG[MissionNumber].TargetBriefing		
end

function SEF_ValidateMission()
	
	--CHECK TARGET TO SEE IF IT IS ALIVE OR NOT
	if ( AGTargetTypeStatic == false and AGMissionTarget ~= nil ) then
		--TARGET IS NOT STATIC					
		if ( GROUP:FindByName(AGMissionTarget):IsAlive() == true ) then
			--GROUP VALID
			trigger.action.outSound('That Is Our Target.ogg')
			trigger.action.outText(AGMissionBriefingText,15)			
		elseif ( GROUP:FindByName(AGMissionTarget):IsAlive() == false or GROUP:FindByName(AGMissionTarget):IsAlive() == nil ) then
			--GROUP NOT VALID
			trigger.action.setUserFlag(ScenarioNumber,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			AGMissionTarget = nil
			AGMissionBriefingText = nil
			SEF_MissionSelector()						
		else			
			trigger.action.outText("Mission Validation Error - Unexpected Result In Group Size", 15)						
		end		
	elseif ( AGTargetTypeStatic == true and AGMissionTarget ~= nil ) then		
		--TARGET IS STATIC		
		if ( StaticObject.getByName(AGMissionTarget) ~= nil and StaticObject.getByName(AGMissionTarget):isExist() == true ) then
			--STATIC IS VALID
			trigger.action.outSound('That Is Our Target.ogg')
			trigger.action.outText(AGMissionBriefingText,15)								
		elseif ( StaticObject.getByName(AGMissionTarget) == nil or StaticObject.getByName(AGMissionTarget):isExist() == false ) then
			--STATIC TARGET NOT VALID, ASSUME TARGET ALREADY DESTROYED			
			trigger.action.setUserFlag(ScenarioNumber,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1	
			AGMissionTarget = nil
			AGMissionBriefingText = nil
			SEF_MissionSelector()
		else
			trigger.action.outText("Mission Validation Error - Unexpected Result In Static Test", 15)	
		end		
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Is Complete - No Further Targets To Validate For Mission Assignment", 15)
	else		
		trigger.action.outText("Mission Validation Error - Mission Validation Unavailable, No Valid Targets", 15)
	end
end

function SEF_SkipScenario()	
	--CHECK MISSION IS NOT SUDDENLY FLAGGED AS STATE 4 (COMPLETED)
	if ( trigger.misc.getUserFlag(ScenarioNumber) >= 1 and trigger.misc.getUserFlag(ScenarioNumber) <= 3 ) then
		--RESET MISSION TO STATE 0 (NOT STARTED), CLEAR TARGET INFORMATION AND REROLL A NEW MISSION
		trigger.action.setUserFlag(ScenarioNumber,0) 
		AGMissionTarget = nil
		AGMissionBriefingText = nil
		SEF_MissionSelector()
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Has Been Completed, All Objectives Have Been Met", 15)
	else		
		trigger.action.outText("Unable To Skip As Current Mission Is In A Completion State", 15)
	end
end

function MissionSuccess()
	
	--SET GLOBALS TO NIL
	AGMissionTarget = nil
	AGMissionBriefingText = nil
	
	local RandomMissionSuccessSound = math.random(1,5)
	trigger.action.outSound('AG Kill ' .. RandomMissionSuccessSound .. '.ogg')	
end

function SEF_MissionTargetStatus(TimeLoop, time)

	if (AGTargetTypeStatic == false and AGMissionTarget ~= nil) then
		--TARGET IS NOT STATIC
					
		if (GROUP:FindByName(AGMissionTarget):IsAlive() == true) then
			--GROUP STILL ALIVE
						
			return time + 10			
		elseif (GROUP:FindByName(AGMissionTarget):IsAlive() == false or GROUP:FindByName(AGMissionTarget):IsAlive() == nil) then 
			--GROUP DEAD
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(ScenarioNumber,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess()
			timer.scheduleFunction(SEF_MissionSelector, {}, timer.getTime() + 20)
			
			return time + 30			
		else			
			trigger.action.outText("Mission Target Status - Unexpected Result, Monitor Has Stopped", 15)						
		end		
	elseif (AGTargetTypeStatic == true and AGMissionTarget ~= nil) then
		--TARGET IS STATIC
		if ( StaticObject.getByName(AGMissionTarget) ~= nil and StaticObject.getByName(AGMissionTarget):isExist() == true ) then 
			--STATIC ALIVE
			
			return time + 10				
		else				
			--STATIC DESTROYED
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(ScenarioNumber,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess()
			timer.scheduleFunction(SEF_MissionSelector, {}, timer.getTime() + 20)
			
			return time + 30				
		end		
	else		
		return time + 10
	end	
end

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////MISSION TARGET TABLE

function SEF_InitializeMissionTable()
	
	OperationBlackpool_AG = {}	
	
	--ABU MUSA ISLAND
	OperationBlackpool_AG[1] = {				
		TargetName = "Ja'Din_Aircraft",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy Su-17 located near Tabqa Airfield  \nGrid DV65",
	}				
	OperationBlackpool_AG[2] = {
		TargetName = "Deir_ez_Zor_3",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy troop barraks/housing on south side of runway \nEast of Grid EV ",
	}	
	OperationBlackpool_AG[3] = {
		TargetName = "Al_Tanf_Armor",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy insurgent forces \nGrid DT11",
	}						
	OperationBlackpool_AG[4] = {
		TargetName = "Barzah_SciCtr_1",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy the Barzah Science Center \nNorthwest Damascus - Grid BT41",
	}					
	OperationBlackpool_AG[5] = {
		TargetName = "Him_Shanshar_1",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy chemical weapons bunkers in HimShanshar  \nGrid BU64",
  }
	
	--Debug Code
	--[[
	trigger.action.outText("Target 1 Name: "..OperationBlackpool_AG[1].TargetName, 15)
	trigger.action.outText("Target 1 Type: "..OperationBlackpool_AG[1].TargetType, 15)
	trigger.action.outText(OperationBlackpool_AG[1].TargetBriefing, 15)
	
	OperationBlackpool_AG[1] = {}
	OperationBlackpool_AG[1][1] = "Test Sector - Supply 1"
	OperationBlackpool_AG[1][2] = "Unit"
	trigger.action.outText("Target 1 Name: "..OperationBlackpool_AG[1][1], 15)
	trigger.action.outText("Target 1 Type: "..OperationBlackpool_AG[1][2], 15)
	]]--
end

--////End Mission Target Table
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////ON DEMAND MISSION INFORMATION

local function CheckObjectiveRequest()
	
	if ( AGMissionBriefingText ~= nil ) then
		trigger.action.outText(AGMissionBriefingText, 15)
		trigger.action.outSound('That Is Our Target.ogg')
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Has Been Completed, There Are No Further Objectives", 15)
	elseif ( AGMissionBriefingText == nil and OperationComplete == false ) then
		trigger.action.outText("Check Objective Request Error - No Briefing Available And Operation Is Not Completed", 15)
	else
		trigger.action.outText("Check Objective Request Error - Unexpected Result Occured", 15)
	end	
end

function TargetReport()
			
	if (AGTargetTypeStatic == false and AGMissionTarget ~=nil) then
		TargetGroup = GROUP:FindByName(AGMissionTarget)	
		
		if (GROUP:FindByName(AGMissionTarget):IsAlive() == true) then
		
			TargetRemainingUnits = Group.getByName(AGMissionTarget):getSize()	
			
			MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
			
			MissionPlayersBlue:ForEachClient(
				function(Client)
					if Client:IsAlive() == true then
						ClientPlayerName = Client:GetPlayerName()	  
						ClientUnitName = Client:GetName()			  
						ClientGroupName = Client:GetClientGroupName() 			
						ClientGroupID = Client:GetClientGroupID()	   	
				
						PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
						PlayerCoord = PlayerUnit:GetCoordinate()
						TargetCoord = TargetGroup:GetCoordinate()
						TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
						TargetHeightFt = math.floor(TargetHeight * 3.28084)
						PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)

						TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
						TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
					
						PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())
					
						--List the amount of units remaining in the group
						if (TargetRemainingUnits > 1) then
							SZMessage = "There are "..TargetRemainingUnits.." targets remaining for this mission" 
						elseif (TargetRemainingUnits == 1) then
							SZMessage = "There is "..TargetRemainingUnits.." target remaining for this mission" 
						elseif (TargetRemainingUnits == nil) then					
							SZMessage = "Unable To Determine Group Size"
						else			
							SZMessage = "Nothing to report"		
						end		
					
						BRMessage = "Target bearing "..PlayerBR
						ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
						_SETTINGS:SetLL_Accuracy(0)
						CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(3)
						CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(2)
						CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())
						
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText.."\n"..BRMessage.."\n"..SZMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage, 30)							
					else						
					end				
				end
			)
		else
			trigger.action.outText("Target Report Unavailable", 15)
		end
		
	elseif (AGTargetTypeStatic == true and AGMissionTarget ~=nil) then
		TargetGroup = STATIC:FindByName(AGMissionTarget, false)
		
		MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()

		MissionPlayersBlue:ForEachClient(
			function(Client)
				if Client:IsAlive() == true then
					ClientPlayerName = Client:GetPlayerName()	
					ClientUnitName = Client:GetName()			
					ClientGroupName = Client:GetClientGroupName()				
					ClientGroupID = Client:GetClientGroupID()
				
					PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
					PlayerCoord = PlayerUnit:GetCoordinate()
					TargetCoord = TargetGroup:GetCoordinate()
					TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
					TargetHeightFt = math.floor(TargetHeight * 3.28084)
					PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)
					
					TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
					TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
										
					PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())

					BRMessage = "Target bearing "..PlayerBR
					ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
					_SETTINGS:SetLL_Accuracy(0)
					CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(3)
					CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(2)
					CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())
					
					trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText.."\n"..BRMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage, 30)							
				else
				end				
			end
		)		
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Has Been Completed, There Are No Further Targets", 15)	
	else
		trigger.action.outText("No Target Information Available", 15)
	end
end
--////End On Demand Mission Information
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////AI SUPPORT FLIGHT FUNCTIONS

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////Radio Menu 

function SEF_RadioMenuSetup()
	--////Set Up Menu
	-- table missionCommands.addSubMenuForCoalition(enum coalition.side, string name , table path)
	-- table missionCommands.addCommand(string name, table/nil path, function functionToRun , any anyArguement)
	-- table missionCommands.addCommandForCoalition(enum coalition.side, string name, table/nil path, function functionToRun , any anyArguement)

	--////Setup Submenu For Support Requests
	--SupportMenuMain = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Support", nil)
	--SupportMenuAbort = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Abort Directives", nil)
	--SupportMenuCAP  = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Fighter Support", SupportMenuMain)
	--SupportMenuCAS  = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Close Air Support", SupportMenuMain)
	--SupportMenuSEAD = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request SEAD Support", SupportMenuMain)
	--SupportMenuASS = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Anti-Shipping Support", SupportMenuMain)
	--SupportMenuPIN = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Pinpoint Strike", SupportMenuMain)
	--SupportMenuDrone = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request MQ-9 Reaper Drone", SupportMenuMain)
	
	--////Setup Menu Option To Get The Current Objective
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Check Current Objective", nil, function() CheckObjectiveRequest() end, nil)
	--////Target Report to get target numbers and coordinates 
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Target Report", nil, function() TargetReport() end, nil)
	--////Drop Smoke On The Target
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Smoke Current Objective", nil, function() SEF_TargetSmoke() end, nil)
	
	--////AI Support Flights Mission Abort Codes
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Fighter Screen", SupportMenuAbort, function() AbortCAPMission() end, nil)	
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Close Air Support", SupportMenuAbort, function() AbortCASMission() end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Anti-Shipping", SupportMenuAbort, function() AbortASSMission() end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission SEAD", SupportMenuAbort, function() AbortSEADMission() end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Pinpoint Strike", SupportMenuAbort, function() AbortPINMission() end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission MQ-9 Reaper Drone", SupportMenuAbort, function() AbortDroneMission() end, nil)	
	
	--////Blackpool Mission Options
	BlackpoolOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Blackpool Options", nil)
	--BlackpoolCAPOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Blackpool CAP Options", BlackpoolOptions)
	--BlackpoolSNDOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Blackpool Sound Options", BlackpoolOptions)
	--BlackpoolCAPKhasab = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Enable Khasab Vipers", BlackpoolCAPOptions, function() SEF_KhasabCAP() end, nil)
	--BlackpoolFleetCats = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Enable Fleet Tomcats", BlackpoolCAPOptions, function() SEF_FleetTomcats() end, nil)
	--BlackpoolFleetBugs = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Enable Fleet Hornets", BlackpoolCAPOptions, function() SEF_FleetHornets() end, nil)
	--BlackpoolToggleFiringSounds = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Toggle Firing Sounds", BlackpoolSNDOptions, function() SEF_ToggleFiringSounds() end, nil)
	--BlackpoolDisableShips  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Naval Ships AI Off", BlackpoolOptions, function() SEF_DisableShips() end, nil)
	--BlackpoolDefenceCheck  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Check Defence Networks", BlackpoolOptions, function() SEF_CheckDefenceNetwork() end, nil)
	BlackpoolSkipScenario  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Skip This Mission", BlackpoolOptions, function() SEF_SkipScenario() end, nil)	
	
	--////CAP Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu Musa Island", SupportMenuCAP, function() RequestFighterSupport('Abu Musa') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sirri Island", SupportMenuCAP, function() RequestFighterSupport('Sirri') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tunb Islands", SupportMenuCAP, function() RequestFighterSupport('Tunb') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Lengeh", SupportMenuCAP, function() RequestFighterSupport('Bandar Lengeh') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Larak Island", SupportMenuCAP, function() RequestFighterSupport('Larak') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qeshm Island", SupportMenuCAP, function() RequestFighterSupport('Qeshm') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Havadarya", SupportMenuCAP, function() RequestFighterSupport('Havadarya') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Abbas", SupportMenuCAP, function() RequestFighterSupport('Bandar Abbas') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minab", SupportMenuCAP, function() RequestFighterSupport('Minab') end, nil)
	
	--SupportMenuCAP2 = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Other Sectors", SupportMenuCAP)
	
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Seerik", SupportMenuCAP2, function() RequestFighterSupport('Seerik') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar-e-Jask", SupportMenuCAP2, function() RequestFighterSupport('Bandar-e-Jask') end, nil)
	
	--////CAS Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu Musa Island", SupportMenuCAS, function() RequestCASSupport('Abu Musa') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sirri Island", SupportMenuCAS, function() RequestCASSupport('Sirri') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tunb Islands", SupportMenuCAS, function() RequestCASSupport('Tunb') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Lengeh", SupportMenuCAS, function() RequestCASSupport('Bandar Lengeh') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Larak Island", SupportMenuCAS, function() RequestCASSupport('Larak') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qeshm Island", SupportMenuCAS, function() RequestCASSupport('Qeshm') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Havadarya", SupportMenuCAS, function() RequestCASSupport('Havadarya') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Abbas", SupportMenuCAS, function() RequestCASSupport('Bandar Abbas') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minab", SupportMenuCAS, function() RequestCASSupport('Minab') end, nil)
	
	--SupportMenuCAS2 = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Other Sectors", SupportMenuCAS)
	
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Seerik", SupportMenuCAS2, function() RequestCASSupport('Seerik') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar-e-Jask", SupportMenuCAS2, function() RequestCASSupport('Bandar-e-Jask') end, nil)
	
	--////SEAD Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu Musa Island", SupportMenuSEAD, function() RequestSEADSupport('Abu Musa') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sirri Island", SupportMenuSEAD, function() RequestSEADSupport('Sirri') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tunb Islands", SupportMenuSEAD, function() RequestSEADSupport('Tunb') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Lengeh", SupportMenuSEAD, function() RequestSEADSupport('Bandar Lengeh') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Larak Island", SupportMenuSEAD, function() RequestSEADSupport('Larak') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qeshm Island", SupportMenuSEAD, function() RequestSEADSupport('Qeshm') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Havadarya", SupportMenuSEAD, function() RequestSEADSupport('Havadarya') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Abbas", SupportMenuSEAD, function() RequestSEADSupport('Bandar Abbas') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minab", SupportMenuSEAD, function() RequestSEADSupport('Minab') end, nil)
	
	--SupportMenuSEAD2 = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Other Sectors", SupportMenuSEAD)
	
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Seerik", SupportMenuSEAD2, function() RequestSEADSupport('Seerik') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar-e-Jask", SupportMenuSEAD2, function() RequestSEADSupport('Bandar-e-Jask') end, nil)
	
	--////ANTI-SHIP Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu Musa Island", SupportMenuASS, function() RequestASSSupport('Abu Musa') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sirri Island", SupportMenuASS, function() RequestASSSupport('Sirri') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Lengeh", SupportMenuASS, function() RequestASSSupport('Bandar Lengeh') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qeshm Island", SupportMenuASS, function() RequestASSSupport('Qeshm') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Havadarya", SupportMenuASS, function() RequestASSSupport('Havadarya') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Seerik", SupportMenuASS, function() RequestASSSupport('Seerik') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar-e-Jask", SupportMenuASS, function() RequestASSSupport('Bandar-e-Jask') end, nil)
	
	--////PIN Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu Musa Island", SupportMenuPIN, function() RequestPINSupport('Abu Musa') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sirri Island", SupportMenuPIN, function() RequestPINSupport('Sirri') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tunb Islands", SupportMenuPIN, function() RequestPINSupport('Tunb') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Lengeh", SupportMenuPIN, function() RequestPINSupport('Bandar Lengeh') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Larak Island", SupportMenuPIN, function() RequestPINSupport('Larak') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qeshm Island", SupportMenuPIN, function() RequestPINSupport('Qeshm') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Havadarya", SupportMenuPIN, function() RequestPINSupport('Havadarya') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Abbas", SupportMenuPIN, function() RequestPINSupport('Bandar Abbas') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minab", SupportMenuPIN, function() RequestPINSupport('Minab') end, nil)
	
	--SupportMenuPIN2 = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Other Sectors", SupportMenuPIN)
	
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Seerik", SupportMenuPIN2, function() RequestPINSupport('Seerik') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar-e-Jask", SupportMenuPIN2, function() RequestPINSupport('Bandar-e-Jask') end, nil)

	--////Drone Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu Musa Island", SupportMenuDrone, function() RequestDroneSupport('Abu Musa') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sirri Island", SupportMenuDrone, function() RequestDroneSupport('Sirri') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tunb Islands", SupportMenuDrone, function() RequestDroneSupport('Tunb') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Lengeh", SupportMenuDrone, function() RequestDroneSupport('Bandar Lengeh') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Larak Island", SupportMenuDrone, function() RequestDroneSupport('Larak') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qeshm Island", SupportMenuDrone, function() RequestDroneSupport('Qeshm') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Havadarya", SupportMenuDrone, function() RequestDroneSupport('Havadarya') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar Abbas", SupportMenuDrone, function() RequestDroneSupport('Bandar Abbas') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minab", SupportMenuDrone, function() RequestDroneSupport('Minab') end, nil)
	
	--SupportMenuDrone2 = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Other Sectors", SupportMenuDrone)
	
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Seerik", SupportMenuDrone2, function() RequestDroneSupport('Seerik') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bandar-e-Jask", SupportMenuDrone2, function() RequestDroneSupport('Bandar-e-Jask') end, nil)	
end	


--////End Radio Menu Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////NAVAL FUNCTIONS

function SEF_ROEWeaponFreeRoosevelt()	
	Group.getByName("CVN71"):getController():setOption(0, 2)
	--trigger.action.outText("Roosevelt ROE Set To Weapons Free", 15)
end

function SEF_ROEWeaponFreeTarawa()	
	Group.getByName("LHA-1"):getController():setOption(0, 2)
	--trigger.action.outText("Tarawa ROE Set To Weapons Free", 15)
end
						
function SEF_ROEHoldRoosevelt()	
	Group.getByName("CVN71"):getController():setOption(0, 4)
	--trigger.action.outText("Roosevelt ROE Set Back To Weapons Hold", 15)
end

function SEF_ROEHoldTarawa()	
	Group.getByName("LHA-1"):getController():setOption(0, 4)
	--trigger.action.outText("Tarawa ROE Set Back To Weapons Hold", 15)
end

function SEF_RooseveltShipTargeting()		
	SEF_ROEWeaponFreeRoosevelt()	
	timer.scheduleFunction(SEF_ROEHoldRoosevelt, {}, timer.getTime() + 5) 	
end

function SEF_TarawaShipTargeting()		
	SEF_ROEWeaponFreeTarawa()	
	timer.scheduleFunction(SEF_ROEHoldTarawa, {}, timer.getTime() + 5) 	
end

function SEF_CarrierRooseveltDefenceZone()
	CarrierRooseveltDefenceZone = ZONE_GROUP:New("Carrier Roosevelt", GROUP:FindByName( "CVN71" ), 40233) --Approx 25nm		
end

function SEF_CarrierTarawaDefenceZone()
	CarrierTarawaDefenceZone = ZONE_GROUP:New("Carrier Tarawa", GROUP:FindByName( "LHA-1" ), 24140)	--Approx 15nm	
end

function SEF_NavalDefenceZoneScanner(Timeloop, time)
	--trigger.action.outText("Carrier Roosevelt Is Scanning For Targets", 15)
	RooseveltScanResult = CarrierRooseveltDefenceZone:Scan( { Unit.Category.AIRPLANE, Unit.Category.HELICOPTER } )
	RooseveltRedPresense = CarrierRooseveltDefenceZone:IsSomeInZoneOfCoalition(coalition.side.RED)
	RooseveltDefenceZoneCount = 0
			
	if ( RooseveltRedPresense == true ) then				
		SET_CARRIERROOSEVELTDEFENCE = SET_UNIT:New():FilterCoalitions( "red" ):FilterCategories({"helicopter","plane"}):FilterOnce()		
		SET_CARRIERROOSEVELTDEFENCE:ForEachUnitCompletelyInZone( CarrierRooseveltDefenceZone, function ( GroupObject )
			RooseveltDefenceZoneCount = RooseveltDefenceZoneCount + 1
			end
		)		
		if ( RooseveltDefenceZoneCount > 1 ) then
			--trigger.action.outText("Carrier Roosevelt Has Detected "..RooseveltDefenceZoneCount.." Targets In Their Airspace", 15)			
			SEF_RooseveltShipTargeting()						
		elseif ( RooseveltDefenceZoneCount == 1 ) then
			--trigger.action.outText("Carrier Roosevelt Has Detected "..RooseveltDefenceZoneCount.." Target In Their Airspace", 15)			
			SEF_RooseveltShipTargeting()			
		else			
		end		
	else	
	end
	
	--trigger.action.outText("Carrier Tarawa Is Scanning For Targets", 15)
	TarawaScanResult = CarrierTarawaDefenceZone:Scan( { Unit.Category.AIRPLANE, Unit.Category.HELICOPTER } )
	TarawaRedPresense = CarrierTarawaDefenceZone:IsSomeInZoneOfCoalition(coalition.side.RED)
	TarawaDefenceZoneCount = 0
			
	if ( TarawaRedPresense == true ) then				
		SET_CARRIERTARAWADEFENCE = SET_UNIT:New():FilterCoalitions( "red" ):FilterCategories({"helicopter","plane"}):FilterOnce()		
		SET_CARRIERTARAWADEFENCE:ForEachUnitCompletelyInZone( CarrierTarawaDefenceZone, function ( GroupObject )
			TarawaDefenceZoneCount = TarawaDefenceZoneCount + 1
			end
		)		
		if ( TarawaDefenceZoneCount > 1 ) then
			--trigger.action.outText("Carrier Tarawa Has Detected "..TarawaDefenceZoneCount.." Targets In Their Airspace", 15)			
			SEF_TarawaShipTargeting()						
		elseif ( TarawaDefenceZoneCount == 1 ) then
			--trigger.action.outText("Carrier Tarawa Has Detected "..TarawaDefenceZoneCount.." Target In Their Airspace", 15)			
			SEF_TarawaShipTargeting()			
		else
		end		
	else
	end	
	
	return time + 20	
end

--////End Naval Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////OVERRIDE FUNCTIONS


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////RED BOMBER ATTACK FUNCTIONS

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////BLUE AWACS/TANKER SPAWN

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////TARGET SMOKE FUNCTIONS

function SEF_TargetSmokeLock()
	TargetSmokeLockout = 1
end

function SEF_TargetSmokeUnlock()
	TargetSmokeLockout = 0
end

function SEF_TargetSmoke()
	
	if ( TargetSmokeLockout == 0 ) then
		if ( AGTargetTypeStatic == false and AGMissionTarget ~= nil ) then
			--TARGET IS NOT STATIC					
			if ( GROUP:FindByName(AGMissionTarget):IsAlive() == true ) then
				--GROUP VALID
				SEFTargetSmokeGroupCoord = GROUP:FindByName(AGMissionTarget):GetCoordinate()
				SEFTargetSmokeGroupCoord:SmokeRed()
				--SEFTargetSmokeGroupCoord:SmokeBlue()
				--SEFTargetSmokeGroupCoord:SmokeGreen()
				--SEFTargetSmokeGroupCoord:SmokeOrange()
				--SEFTargetSmokeGroupCoord:SmokeWhite()
				trigger.action.outSound('Target Smoke.ogg')
				trigger.action.outText("Target Has Been Marked With Red Smoke", 15)
				SEF_TargetSmokeLock()
				timer.scheduleFunction(SEF_TargetSmokeUnlock, 53, timer.getTime() + 300)				
			else			
				trigger.action.outText("Target Smoke Currently Unavailable - Unable To Acquire Target Group", 15)						
			end		
		elseif ( AGTargetTypeStatic == true and AGMissionTarget ~= nil ) then		
			--TARGET IS STATIC		
			if ( StaticObject.getByName(AGMissionTarget) ~= nil and StaticObject.getByName(AGMissionTarget):isExist() == true ) then
				--STATIC IS VALID
				SEFTargetSmokeStaticCoord = STATIC:FindByName(AGMissionTarget):GetCoordinate()
				SEFTargetSmokeStaticCoord:SmokeRed()
				--SEFTargetSmokeStaticCoord:SmokeBlue()
				--SEFTargetSmokeStaticCoord:SmokeGreen()
				--SEFTargetSmokeStaticCoord:SmokeOrange()
				--SEFTargetSmokeStaticCoord:SmokeWhite()
				trigger.action.outSound('Target Smoke.ogg')		
				trigger.action.outText("Target Has Been Marked With Red Smoke", 15)
				SEF_TargetSmokeLock()
				timer.scheduleFunction(SEF_TargetSmokeUnlock, 53, timer.getTime() + 300)				
			else
				trigger.action.outText("Target Smoke Currently Unavailable - Unable To Acquire Target Building", 15)	
			end			
		else		
			trigger.action.outText("Target Smoke Currently Unavailable - No Valid Targets", 15)
		end
	else
		trigger.action.outText("Target Smoke Currently Unavailable - Smoke Shells Are Being Reloaded", 15)
	end	
end

--////End Target Smoke Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////OTHER FUNCTIONS

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////MAIN

		--////GLOBAL VARIABLE INITIALISATION	
		NumberOfCompletedMissions = 0
		TotalScenarios = 5
		OperationComplete = false
		OnShotSoundsEnabled = 0
		SoundLockout = 0
		TargetSmokeLockout = 0	
		--////MOOSE ENVIRONMENT INITIALISATION
		_SETTINGS:SetPlayerMenuOff()
		_SETTINGS:SetImperial()
		
		--////ENABLE CAP/CAS/ASS/SEAD/PIN/DRONE
		--trigger.action.setUserFlag(5001,1)
		--trigger.action.setUserFlag(5002,1)
		--trigger.action.setUserFlag(5003,1)
		--trigger.action.setUserFlag(5004,1)
		--trigger.action.setUserFlag(5005,1)
		--trigger.action.setUserFlag(5891,1)
		--////ENABLE RED BOMBER ATTACKS
		--trigger.action.setUserFlag(5006,1)
		
		--////FUNCTIONS
		SEF_InitializeMissionTable()		
		SEF_MissionSelector()
		SEF_RadioMenuSetup()
		--SEF_BLUEAwacsSpawn()
		--SEF_BLUETexacoSpawn()
		--SEF_BLUEShellSpawn()
		--SEF_BLUE2TexacoSpawn()
		--SEF_BLUE2ShellSpawn()
		SEF_CarrierRooseveltDefenceZone()
		SEF_CarrierTarawaDefenceZone()
		
		--////SCHEDULERS
		--AI FLIGHT PUSH FLAGS
		timer.scheduleFunction(SEF_CheckAIPushFlags, 53, timer.getTime() + 1)
		--MISSION TARGET STATUS
		timer.scheduleFunction(SEF_MissionTargetStatus, 53, timer.getTime() + 10)
		--RED BOMBER ATTACKS - WAIT 10-15 MINUTES BEFORE STARTING
		--timer.scheduleFunction(SEF_RedBomberScheduler, 53, timer.getTime() + math.random(600, 900))
		--NAVAL DEFENCE ZONE SCANNER - WAIT 5 MINUTES BEFORE STARTING
		timer.scheduleFunction(SEF_NavalDefenceZoneScanner, 53, timer.getTime() + 300)				
	
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////