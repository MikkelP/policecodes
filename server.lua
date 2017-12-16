local log = function(message, plr) outputChatBox( message, plr ) end

local codes = {
    ["10-0"] = "Negative",
    ["10-1"] = "Affirmative",
    ["10-2"] = "Responding",
    ["10-3"] = "Cancel",
    ["10-4"] = "Roger",
    ["10-5"] = "Copy that, confirm",
    ["10-9"] = "Repeat last transmission, statement",

    ["10-11"] = "Current Location: $loc",
    ["10-00"] = "Officer Down",
    ["10-01"] = "Soldier Down",
    ["10-20"] = "Status",
    ["10-21"] = "In Position",
    ["10-22"] = "Return To Your Vehicles",
    ["10-23"] = "Hide Your Vehicles",
    ["10-24"] = "Cover",
    ["10-25"] = "Covering Fire",
    ["10-26"] = "Clear",
    ["10-27"] = "Proceed with caution",
    ["10-28"] = "In Pursuit",
    ["10-29"] = "Aborting Pursuit",
    ["10-30"] = "Suspect Down, in Custody",
    ["10-32A"] = "Request Transport (4 door vehicle.)",
    ["10-32B"] = "Request Light Backup (Closest units Respond.)",
    ["10-32C"] = "Request Heavy Backup (Respond as soon as possible. All Units need to Respond.)",
    ["10-32S"] = "Request Airstrike (Wanted criminal with more than 3 stars in a vehicle)",

    ["10-43"] = "Request medical assistance",
    ["10-90"] = "Report to base",
    ["10-97"] = "Arrived On Scene",
    ["11-55"] = "On Duty",
    ["11-56"] = "Off Duty",
    ["11-57"] = "Patrolling / Despatch for Patrolling",

    ["12-0"] = "Performing Airstrike",
    ["12-1"] = "Airstrike Successful",
    ["12-2"] = "Airstrike Unsuccessful",
    ["12-5"] = "Airstrike Canceled",
    ["13-12"] = " Assignment Complete",
    ["13-13"] = "Cancel Paramedic Dispatch",
    ["13-38"] = "Rape/Sex offense – Medics to be dispatched on site with rape kit.",
    ["13-42"] = "Suicidal Victim – Medics to be dispatched with fall net.",
    ["13-45"] = "Psychotic Breakdown",
    ["13-46"] = "Hostage takeover",
    ["13-51"] = "Caution Fire on site",
    ["13-60"] = "Life Threatening",
    ["13-61"] = "Heavy Causality but not Life Threatening",
    ["13-62"] = "Not Life Threatening",
    ["13-63"] = "Heavy Causality but not Life Threatening, dispatch medics with armed SWAT ground escort",
    ["13-64"] = "Life Threatening, dispatch medics with armed SWAT helicopter escort",

    -- ["10-4"] = "Affirmative",
    -- ["10-5"] = "Negative",
    -- ["10-20"] = "Current location: $loc",
    -- ["BB"] = "Blueberry"
}

local DYNAMIC_CODE_PREFIX = "$"
local STATIC_CODE_PREFIX = "#"

function getCurrentLocation(plr)
    return getElementZoneName( plr )
end

function getCurrentHealth(plr)
    return getElementHealth( plr )
end

function getCurrentVehicleName(plr)
    local veh = getPedOccupiedVehicle( plr )
    if (veh) then
        return getVehicleName( veh )
    else
        return "On foot";
    end
end

local dynamicCodes = {
    ["loc"] = { "Player's current location", getCurrentLocation},
    ["hp"] = { "Player's current health", getCurrentHealth},
    ["veh"] = { "Player's current vehicle name or 'On foot' if not in a vehicle", getCurrentVehicleName}
}

outputChatBox( "Started policecodes")

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

function convertDynamicCodes(message, plr)
    local temp = split( message, " " )
    for i,v in ipairs(temp) do
        if (string.sub(v,1,1) == DYNAMIC_CODE_PREFIX) then
            local key = string.sub(v, 2)
            if (dynamicCodes[key]) then
                -- Example for $loc: key = loc, v = $loc. Key used to lookup in table. v is with the prefix added ($)
                local convertedMessage = dynamicCodes[key][2](plr) --.. " (" .. key .. ")"
                temp[i] = convertedMessage
            end
        end
    end
    message = table.concat(temp, " ")
    return message
end

function emergencyChat(plr, cmdName, ...)
    local message = table.concat({...}, " ")
    local result = convertStaticCodes(message)
    outputChatBox( "[INPUT]#AAAAAA " .. message, plr, 100, 255, 100, true )
    -- outputChatBox( "[Static Codes]#FFFFFF " .. result, plr, 100, 100, 255, true)
    result = convertDynamicCodes(result, plr)
    outputChatBox( "[OUTPUT]#FFFFFF " .. result, plr, 100, 100, 255, true)
    
end
addCommandHandler( "e", emergencyChat)

-- function listCodes(plr, cmd, params)
--     log("Static codes: (Prefix: " .. STATIC_CODE_PREFIX .. ")", plr)
--     for k,v in pairs(codes) do
--         log(k .. ": " .. v, plr)
--     end
--     log("", plr)

--     log("Dynamic codes: (Prefix: " .. DYNAMIC_CODE_PREFIX .. ")", plr)
--     for k,v in pairs(dynamicCodes) do
--         log(k .. ": " .. v[1] .. " Current result: " .. v[2](plr), plr)
--     end
-- end
-- addCommandHandler( "codes", listCodes)