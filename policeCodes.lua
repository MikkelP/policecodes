local staticCodePrefix = "!"
local dynamicCodePrefix = "$"

local orderedCodes = {
	{"10-0", "Negative"},
	{"10-1", "Affirmative"},
	{"10-2", "Responding"},
	{"10-3", "Cancel"},
	{"10-4", "Roger"},
	{"10-5", "Copy that"},
	{"10-9", "Repeat last transmission, statement"},
	"",
	{"10-11", "Current Location: " .. dynamicCodePrefix .. "loc"},
	{"10-00", "Officer Down at " .. dynamicCodePrefix .. "loc " .. dynamicCodePrefix .. "nwc criminal(s) spotted nearby"},
	{"10-01", "Soldier Down at " .. dynamicCodePrefix .. "loc"},
	{"10-20", "Status"},
	{"10-21", "In Position"},
	{"10-22", "Return To Your Vehicles"},
	{"10-23", "Hide Your Vehicles"},
	{"10-24", "Cover"},
	{"10-25", "Covering Fire"},
	{"10-26", "Clear"},
	{"10-27", "Proceed with caution"},
	{"10-28", "In Pursuit, " .. dynamicCodePrefix .. "vao at " .. dynamicCodePrefix .. "loc going " .. dynamicCodePrefix .. "dir"},
	{"10-29", "Aborting Pursuit at " .. dynamicCodePrefix .. "loc"},
	{"10-30", "Suspect Down, in Custody"},
	"",
	"Requests",
	{"10-32A", "Requesting Transport (4 door vehicle) at " .. dynamicCodePrefix .. "loc"},
	{"10-32B", "Requesting Light Backup"},
	{"10-32C", "Requesting Heavy Backup"},
	{"10-32S", "Requesting Airstrike"},
	{"10-43", "Requesting medical assistance at " .. dynamicCodePrefix .. "loc"},
	"",
	{"10-90", "Report to base"},
	{"10-97", "Arrived On Scene"},
	{"11-55", "On Duty"},
	{"11-56", "Off Duty"},
	{"11-57", "Patrolling / Dispatch for Patrolling"},
	"",
	"Airstrike Status",
	{"12-0", "Performing Airstrike"},
	{"12-1", "Airstrike Successful"},
	{"12-2", "Airstrike Unsuccessful"},
	{"12-5", "Airstrike Cancelled"},
	"",
	{"13-12", "Assignment Complete"},
	{"13-13", "Cancel Paramedic Dispatch"},
	{"13-51", "Caution! Fire on site"},
	{"13-60", "Life Threatening"},
	{"13-61", "Heavy Causality but not Life Threatening"},
	{"13-62", "Not Life Threatening"},
	{"13-63", "Heavy Causality but not Life Threatening, dispatch medics with armed SWAT ground escort"},
	{"13-64", "Life Threatening, dispatch medics with armed SWAT helicopter escort"},
	"",
	{"2000", "Robbery"},
	{"3000", "Roadblock"},
	{"1000", "Riot"},
	{"2000", "Robbery"},
	{"3000", "Roadblock"},
	"",
	"Situation Codes",
	{"Code1", "Code 1 - Non-urgent situation"},
	{"Code2", "Code 2 - Urgent, proceed immediately"},
	{"Code3", "Code 3 - Emergency, proceed immediately with siren"},
	{"Code4", "Code 4 - No further assistance required"},
	"",
	{"Purple", "Code Purple - Riot Activity"},
	{"Yellow", "Code Yellow - Chasing the target"},
	{"Blue", "Code Blue - Training taking place"},
	{"Red", "Code Red - Criminal Event"},
	{"Black", "Code Black - Crisis is in effect"},
	{"Green", "Code Green - Armed Robbery on-progress"},
	"",
	"Armed Robberies",
	{"DTY", "Docks Train Yard"},
	{"LSO", "LS Oil Rig"},
	{"CS", "Construction Site"},
	{"GY", "LS Graveyard"},
	{"MY", "Movie Yard"},
	{"NRH", "North Rock Hut"},
	{"RB", "Rodeo Bank"},
	{"PCB", "Palomino Creek Bank"},
	{"BB", "Blueberry"},
	{"CC", "LS County Club"},
	{"LSA", "LS Airport Storage"},
	"",
	"Stores",
	{"69C", "Idlewood 69"},
	{"IB", "Idlewood Barber"},
	{"GBC", "Ganton's Binco Clothing"},
	{"JSU", "Jefferson Sub Urban's"},
	{"DZC", "Downtown's Zip Clothing"},
	{"MB", "Marina Barber"},
	{"RV", "Rodeo Victims Clothing"},
	{"RPC", "Rodeo Pro Laps Clothing"},
	{"M24/7", "Mulholland 24/7"},
	{"T24/7", "Temple 24/7"},
	{"IP", "Idlewood Pizza"},
	{"MAB", "Marina Burger"},
	{"SMP", "Santa Maria Pizza"},
	{"MTB", "Market Burger"},
	{"MTP", "Market Pizza"},
	{"ELSC", "East LS Chicken"},
	{"TB", "Temple Burger"},
	"",
	"Duplicates",
	{"10-32a", "Requesting Transport (4 door vehicle) at " .. dynamicCodePrefix .. "loc"},
	{"10-32b", "Requesting Light Backup"},
	{"10-32c", "Requesting Heavy Backup"},
	{"10-32s", "Requesting Airstrike"},
	{"code1", "Code 1 - Non-urgent situation"},
	{"code2", "Code 2 - Urgent, proceed immediately"},
	{"code3", "Code 3 - Emergency, proceed immediately with siren"},
	{"code4", "Code 4 - No further assistance required"},
	{"purple", "Code Purple - Riot Activity"},
	{"yellow", "Code Yellow - Chasing the target"},
	{"blue", "Code Blue - Training taking place"},
	{"red", "Code Red - Criminal Event"},
	{"black", "Code Black - Crisis is in effect"},
	{"green", "Code Green - Armed Robbery on-progress"},
}

function getCurrentLocation()
	local x, y, z = getElementPosition(localPlayer)
	local int = getElementInterior(localPlayer)
	local result = ""
	if (int ~= 0) then
		result = "interior in "
		x, y, z = exports.CITutil:getLastPosition(localPlayer) --Returns x, y, z of where they were last when outside (so you can see what interior they entered)
	end
	result = result .. (exports.CITmapMisc:getZoneName2(x, y, z) or getZoneName(x, y, z))
	return result
end

function getCurrentHealth()
	return math.floor(getElementHealth(localPlayer))
end

function getCITVehicleName(modelId)
	local vehNames = getElementData(root, "VehNameFromModel")
	local vehName = "N/A"
	if (vehNames) then
		vehName = vehNames[modelId]
	else
		vehName = getVehicleNameFromModel(modelId)
	end
	return vehName
end

function getCurrentVehicleName()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) then
	--getVehicleNameFromModel: (getElementData(root, "VehNameFromModel")[ID] or getVehicleNameFromModel(ID))
	--getVehicleModelFromName: (getElementData(root, "VehModelFromName")[carName] or getVehicleModelFromName(carName))
		local modelId = getElementModel(veh)
		return getCITVehicleName(modelId)
	else
		return "on foot";
	end
end

function getAmountOfNearbyCriminals()
	local myX, myY, myZ = getElementPosition(localPlayer)
	local players = getElementsByType("player", root, true)
	local count = 0
	for i, plr in ipairs(players) do
		local x, y, z = getElementPosition(plr)
		if (plr ~= localPlayer and getDistanceBetweenPoints3D(x, y, z, myX, myY, myZ) < 50 and (getElementData(plr, "w") or 0) > 0) then
			count = count + 1
		end
	end
	return count
end

function getVehichleTypeName()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) then
		return getVehicleType(veh)
	else
		return "On foot"
	end
end

function getCurrentOccupationName()
	return getElementData(localPlayer, "o") or "N/A"
end

function getAmountOfPlayersUnderArrest()
	return exports.CITpoliceArrest:getPlayerPrisonerCount(localPlayer) or 0
end

function getVehicleOccupantsCount(veh)
	local occupants = getVehicleOccupants(veh)
	local count = 0
	for k, v in pairs(occupants) do
		count = count + 1
	end
	return count
end

function getAmountOfOccupants()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) then
		return getVehicleOccupantsCount(veh)
	else
		return 0
	end
end

function getVehicleNameAndOccupants()
	local vehName = getCurrentVehicleName()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) then
		local occupants = getVehicleOccupantsCount(veh)
		local sinPlu = "occupant"
		if (occupants ~= 1) then sinPlu = sinPlu .. "s" end
		vehName = vehName .. " (" .. occupants .. " " .. sinPlu .. ")"
	end
	return vehName
end

local directionNames = {
	{"NW", "W", "SW", "S", "SE", "E", "NE", "N"},
	{"North West", "West", "South West", "South", "South East", "East", "North East", "North"}
}

function getDirectionNameFromAngle(angle, resultType)
	if(resultType ~= 1 and resultType ~= 2) then
		resultType = 1
	end
	if (angle > 360 or angle < 0) then
		return "N/A"
	end
	if(angle >= 22.5 and angle < 67.5) then
		return directionNames[resultType][1]
	end
	if(angle >= 67.5 and angle < 112.5) then
		return directionNames[resultType][2]
	end
	if(angle >= 112.5 and angle < 157.5) then
		return directionNames[resultType][3]
	end
	if(angle >= 157.5 and angle < 202.5) then
		return directionNames[resultType][4]
	end
	if(angle >= 202.5 and angle < 247.5) then
		return directionNames[resultType][5]
	end
	if(angle >= 247.5 and angle < 292.5) then
		return directionNames[resultType][6]
	end
	if(angle >= 292.5 and angle < 337.5) then
		return directionNames[resultType][7]
	end
	if(angle >= 337.5 or angle < 22.5) then
		return directionNames[resultType][8]
	end
	return "N/A"
end

function getCurrentCardinalDirection()
	local elem = getPedOccupiedVehicle(localPlayer) or localPlayer
	local a, a, z = getElementRotation(elem, "ZYX")
	return getDirectionNameFromAngle(z, 2)
end

orderedDynamicCodes = {
	{"loc", "Player's current location", getCurrentLocation},
	{"hp", "Player's current health", getCurrentHealth},
	{"veh", "Player's current vehicle name or 'On foot' if not in a vehicle", getCurrentVehicleName},
	{"nwc", "Amount of nearby wanted criminals", getAmountOfNearbyCriminals},
	{"vt", "Vehicle type name or 'On foot'", getVehichleTypeName},
	{"job", "Player's current occupation name", getCurrentOccupationName},
	{"arr", "Amount of players currently under arrest", getAmountOfPlayersUnderArrest},
	{"occ", "Amount of people in player's vehicle", getAmountOfOccupants},
	{"vao", "Vehicle name and occupants in vehicle OR 'on foot'", getVehicleNameAndOccupants},
	{"dir", "Name of direction player's vehicle or character is facing", getCurrentCardinalDirection}
}

local screenW, screenH = guiGetScreenSize()
local guiWindow, guiTabPanel, guiTabDynamic, guiTabStatic, guiButtonClose, guiLabelDynamic, guiLabelStatic, guiGridListDynamic, guiGridListStatic

function createRelativeCodesWindow()
	if (not guiWindow) then
		local dimH = screenH * 0.95 --525
		guiWindow = guiCreateWindow((screenW - 660) / 2, (screenH - dimH) / 2, 660, dimH, "Codes", false)

		guiTabPanel = guiCreateTabPanel(0.02, 0.05, 0.97, 0.84, true, guiWindow)

		guiTabStatic = guiCreateTab("Static", guiTabPanel)

		guiLabelStatic = guiCreateLabel(0.02, 0.02, 0.97, 0.14, "To write a static code you must add " .. staticCodePrefix .. " in front of every code.\nExample: If you write: " .. staticCodePrefix .. "10-4\nOutput is: Roger (10-4)", true, guiTabStatic)
		guiGridListStatic = guiCreateGridList(0.02, 0.19, 0.97, 0.79, true, guiTabStatic)
		guiGridListAddColumn(guiGridListStatic, "Code", 0.5)
		guiGridListAddColumn(guiGridListStatic, "Translation", 0.5)

		guiGridListSetColumnWidth(guiGridListStatic, 1, 0.177, true)
		guiGridListSetColumnWidth(guiGridListStatic, 2, 1, true)

		local number = 0
		for i,v in ipairs(orderedCodes) do
			guiGridListAddRow(guiGridListStatic)
			if (type(v) == "string") then
				guiGridListSetItemText(guiGridListStatic, number, 1, "", true, false)
				guiGridListSetItemText(guiGridListStatic, number, 2, v, true, false)
			else
				guiGridListSetItemText(guiGridListStatic, number, 1, v[1], false, false)
				guiGridListSetItemText(guiGridListStatic, number, 2, v[2], false, false)
			end
			number = number + 1
		end

		guiTabDynamic = guiCreateTab("Dynamic", guiTabPanel)

		guiLabelDynamic = guiCreateLabel(0.02, 0.02, 0.97, 0.14, "To write a dynamic code you must add " .. dynamicCodePrefix .. " in front of every code.\nExample: You are in Idlewood and write: " .. dynamicCodePrefix .. "loc\nOutput is: Idlewood", true, guiTabDynamic)
		guiGridListDynamic = guiCreateGridList(0.02, 0.19, 0.97, 0.79, true, guiTabDynamic)
		guiGridListAddColumn(guiGridListDynamic, "Code", 0.5)
		guiGridListAddColumn(guiGridListDynamic, "Description", 0.5)

		guiGridListSetColumnWidth(guiGridListDynamic, 1, 110, false)
		guiGridListSetColumnWidth(guiGridListDynamic, 2, 450, false)

		number = 0
		for i,v in ipairs(orderedDynamicCodes) do
			guiGridListAddRow(guiGridListDynamic)
			guiGridListSetItemText(guiGridListDynamic, number, 1, v[1], false, false)
			guiGridListSetItemText(guiGridListDynamic, number, 2, v[2], false, false)
			number = number + 1
		end

		guiButtonClose = guiCreateButton(0.23, 0.91, 0.75, 0.07, "Close", true, guiWindow)
		guiButtonClipBoard = guiCreateButton(0.02, 0.91, 0.20, 0.07, "Copy To Clipboard", true, guiWindow)

		addEventHandler("onClientGUIClick", guiButtonClose, closeCodesWindow, false)
		addEventHandler("onClientGUIClick", guiButtonClipBoard, addToClipBoard, false)

		guiWindowSetSizable(guiWindow, false)
		guiGridListSetScrollBars(guiGridListDynamic, true, true)
		guiGridListSetScrollBars(guiGridListStatic, true, true)
	end
end

function openCodesWindow()
	createRelativeCodesWindow()
	guiSetVisible(guiWindow, true)
	showCursor(true)
end

function closeCodesWindow()
	guiSetVisible(guiWindow, false)
	showCursor(false)
end

addCommandHandler("codes", openCodesWindow)

function addToClipBoard()
	local str = "Static codes:"
	for i,v in pairs(orderedCodes) do
		if (type(v) == "string") then
			str = str .. "\n    " .. v
		else
			str = str .. "\n" .. v[1] .. " - " .. v[2]
		end
	end
	str = str .. "\n\nDynamic codes:"
	for i,v in pairs(orderedDynamicCodes) do
		str = str .. "\n" .. v[1] .. " - " .. v[2]
	end
	setClipboard(str)
	outputChatBox( "Copied codes to clipboard (/copycodes). Open a text editor and press CTRL+V to paste the text.", 0, 120, 0)
end
addCommandHandler("copycodes", addToClipBoard)

-- codes and dynamicCodes lookup tables being generated based on orderedCodes and orderedDynamicCodes
codes = {}
dynamicCodes = {}

for i, v in ipairs(orderedCodes) do
	-- Allow sections in orderedCodes but don't transfer to lookup table
	if (type(v) ~= "string") then
		codes[v[1]] = v[2]
	end
end

for i, v in ipairs(orderedDynamicCodes) do
	dynamicCodes[v[1]] = {v[2], v[3]}
end

function convertStaticCodes(message)
	local temp = split( message, " " )
	for i,v in ipairs(temp) do
		if (string.sub(v,1,1) == staticCodePrefix) then
			local key = string.sub(v, 2)
			key = string.gsub(key, "[,.!)(]", "")
			if (codes[key]) then
				local convertedMessage = codes[key] .. " (" .. key .. ")"
				temp[i] = convertedMessage
			end
		end
	end
	message = table.concat(temp, " ")
	return message
end

function convertDynamicCodes(message)
	local temp = split( message, " " )
	for i,v in ipairs(temp) do
		if (string.sub(v,1,1) == dynamicCodePrefix) then
			local key = string.sub(v, 2)
			key = string.gsub(key, "[,.!)(]", "")
			if (dynamicCodes[key]) then
				-- Example for $loc: key = loc, v = $loc. Key used to lookup in table. v is with the prefix added (dynamicCodePrefix)
				local convertedMessage = dynamicCodes[key][2]()
				temp[i] = convertedMessage
			end
		end
	end
	message = table.concat(temp, " ")
	return message
end

-- TODO: This turns into a pipe of static -> dynamic code conversion then returns result. Export function
function emergencyChat(cmdName, ...)
	local message = table.concat({...}, " ")
	local result = convertStaticCodes(message)
	outputChatBox( "[INPUT]#AAAAAA " .. message, 100, 255, 100, true )
	result = convertDynamicCodes(result)
	local output = "[OUTPUT] " .. getPlayerName(localPlayer) .. ":#FFFFFF " .. result
	outputChatBox( "[OUTPUT]#FFFFFF " .. result, 100, 100, 255, true)

	triggerServerEvent("messageToAll", localPlayer, output)
end
addCommandHandler("e", emergencyChat)