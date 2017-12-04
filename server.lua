local log = function(message, plr) outputChatBox( message, plr ) end

local codes = {
    ["10-4"] = "Affirmative",
    ["10-5"] = "Negative",
    ["10-20"] = "Current location: $loc",
    ["BB"] = "Blueberry"
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
addCommandHandler( "codes", listCodes)