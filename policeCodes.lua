local orderedCodes = {
	{"10-0", "Negative"},
	{"10-1", "Affirmative"},
	{"10-2", "Responding to"},
	{"10-3", "Cancel"},
	{"10-4", "Roger"},
	{"10-5", "Copy that, confirm"},
	{"10-9", "Repeat last transmission, statement"},

	{"10-11", "Current Location: $loc"},
	{"10-00", "Officer Down at $loc $nwc criminal(s) spotted nearby"},
	{"10-01", "Soldier Down"},
	{"10-20", "Status"},
	{"10-21", "In Position"},
	{"10-22", "Return To Your Vehicles"},
	{"10-23", "Hide Your Vehicles"},
	{"10-24", "Cover"},
	{"10-25", "Covering Fire"},
	{"10-26", "Clear"},
	{"10-27", "Proceed with caution"},
	{"10-28", "In Pursuit"},
	{"10-29", "Aborting Pursuit"},
	{"10-30", "Suspect Down, in Custody"},
	"",
	"Requests",
	{"10-32A", "Requesting Transport (4 door vehicle) at $loc"},
	{"10-32B", "Requesting Light Backup at $loc"},
	{"10-32C", "Requesting Heavy Backup at $loc"},
	{"10-32S", "Requesting Airstrike at $loc"},
	{"10-43", "Requesting medical assistance at $loc"},
	"",
	{"10-90", "Report to base"},
	{"10-97", "Arrived On Scene"},
	{"11-55", "On Duty"},
	{"11-56", "Off Duty"},
	{"11-57", "Patrolling / Dispatch for Patrolling"},
	"",
	"Airstrike",
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
	{"Code1", "Non-urgent situation at $loc"},
	{"Code2", "Urgent, Proceed immediately at $loc"},
	{"Code3", "Emergency, Proceed immediately with siren at $loc"},
	{"Code4", "No further assistance required at $loc"},
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
	{"TB", "Temple Burger"}
}

local DYNAMIC_CODE_PREFIX = "$"
local STATIC_CODE_PREFIX = "#"

function getCurrentLocation()
	-- TODO: Interior considerations (possibly dim too)
	local x, y, z = getElementPosition(localPlayer)
	return exports.CITmapMisc:getZoneName2(x, y, z) or getZoneName(x, y, z)
end

function getCurrentHealth()
	return getElementHealth(localPlayer)
end

function getCurrentVehicleName()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) then
	--getVehicleNameFromModel: (getElementData(root, "VehNameFromModel")[ID] or getVehicleNameFromModel(ID))
	--getVehicleModelFromName: (getElementData(root, "VehModelFromName")[carName] or getVehicleModelFromName(carName))
		local modelId = getElementModel(veh)
		return (getElementData(root, "VehNameFromModel")[modelId] or getVehicleNameFromModel(modelId))
	else
		return "On foot";
	end
end

function getAmountOfNearbyCriminals()
	local myX, myY, myZ = getElementPosition(localPlayer)
	local players = getElementsByType("player", root, true)
	local count = 0
	for i,plr in ipairs(players) do
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

orderedDynamicCodes = {
	{"loc", "Player's current location", getCurrentLocation},
	{"hp", "Player's current health", getCurrentHealth},
	{"veh", "Player's current vehicle name or 'On foot' if not in a vehicle", getCurrentVehicleName},
	{"nwc", "Amount of nearby wanted criminals", getAmountOfNearbyCriminals},
	{"vt", "Vehicle type name or 'On foot'", getVehichleTypeName},
	{"occ", "Player's current occupation name", getCurrentOccupationName},
	{"pri", "Amount of players currently under arrest", getAmountOfPlayersUnderArrest}
}

local screenW, screenH = guiGetScreenSize()
local guiWindow, guiTabPanel, guiTabDynamic, guiTabStatic, guiButtonClose, guiLabelDynamic, guiLabelStatic, guiGridListDynamic, guiGridListStatic

function listCodes(plr, cmd, params)
	log("Static codes: (Prefix: " .. STATIC_CODE_PREFIX .. ")", plr)
	for k,v in pairs(codes) do
		log(k .. ": " .. v, plr)
	end
	log("", plr)

	log("Dynamic codes: (Prefix: " .. DYNAMIC_CODE_PREFIX .. ")", plr)
	for k,v in pairs(dynamicCodes) do
		log(k .. ": " .. v[1] .. " Current result: " .. v[2](plr), plr)
	end
end

function createAbsoluteCodesWindow()
	if (not guiWindow) then
		guiWindow = guiCreateWindow((screenW - 640) / 2, (screenH - 525) / 2, 640, 525, "Codes", false)
		guiTabPanel = guiCreateTabPanel(10, 27, 620, 443, false, guiWindow)
		guiTabStatic = guiCreateTab("Static", guiTabPanel)
		guiLabelStatic = guiCreateLabel(10, 10, 601, 59, "To write a static code you must add # in front.\nExample: If you write: #10-4\nOutput is: Roger (10-4)", false, guiTabStatic)
		guiGridListStatic = guiCreateGridList(10, 79, 601, 333, false, guiTabStatic)
		guiGridListAddColumn(guiGridListStatic, "Code", 0.5)
		guiGridListAddColumn(guiGridListStatic, "Translation", 0.5)

		guiGridListSetColumnWidth(guiGridListStatic, 1, 110, false)
		guiGridListSetColumnWidth(guiGridListStatic, 2, 450, false)

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
		guiLabelDynamic = guiCreateLabel(10, 10, 601, 59, "To write a dynamic code you must add $.in front.\nExample: You are in Idlewood and write: $loc\nOutput is: Idlewood", false, guiTabDynamic)
		guiGridListDynamic = guiCreateGridList(10, 79, 601, 333, false, guiTabDynamic)
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

		guiButtonClose = guiCreateButton(148, 476, 482, 39, "Close", false, guiWindow)
		guiButtonClipBoard = guiCreateButton(10, 476, 128, 39, "Copy To Clipboard", false, guiWindow)    
		addEventHandler("onClientGUIClick", guiButtonClose, closeCodesWindow, false)
		addEventHandler("onClientGUIClick", guiButtonClipBoard, addToClipBoard, false)
		guiWindowSetSizable(guiWindow, false)

		guiGridListSetScrollBars(guiGridListDynamic, true, true)
		guiGridListSetScrollBars(guiGridListStatic, true, true)
	end
end

function createRelativeCodesWindow()
	if (not guiWindow) then
		local dimH = screenH * 0.95 --525
		guiWindow = guiCreateWindow((screenW - 660) / 2, (screenH - dimH) / 2, 660, dimH, "Codes", false)

		guiTabPanel = guiCreateTabPanel(0.02, 0.05, 0.97, 0.84, true, guiWindow)

		guiTabStatic = guiCreateTab("Static", guiTabPanel)

		guiLabelStatic = guiCreateLabel(0.02, 0.02, 0.97, 0.14, "To write a static code you must add # in front.\nExample: If you write: #10-4\nOutput is: Roger (10-4)", true, guiTabStatic)
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

		guiLabelDynamic = guiCreateLabel(0.02, 0.02, 0.97, 0.14, "To write a dynamic code you must add $.in front.\nExample: You are in Idlewood and write: $loc\nOutput is: Idlewood", true, guiTabDynamic)
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
		if (string.sub(v,1,1) == STATIC_CODE_PREFIX) then
			local key = string.sub(v, 2)
			if (codes[key]) then
				-- outputChatBox( "Code found!: " .. v .. ": " .. codes[v], plr)
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
		if (string.sub(v,1,1) == DYNAMIC_CODE_PREFIX) then
			local key = string.sub(v, 2)
			if (dynamicCodes[key]) then
				-- Example for $loc: key = loc, v = $loc. Key used to lookup in table. v is with the prefix added ($)
				local convertedMessage = dynamicCodes[key][2]() --.. " (" .. key .. ")"
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
	outputChatBox( "[OUTPUT]#FFFFFF " .. result, 100, 100, 255, true)
end
addCommandHandler("e", emergencyChat)