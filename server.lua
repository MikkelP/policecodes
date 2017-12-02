local log = function(message, plr) outputChatBox( message, plr ) end

local codes = {
    ["10-4"] = "Affirmative",
    ["10-5"] = "Negative",
    ["BB"] = "Blueberry"
}

outputChatBox( "Started policecodes")

function convertCodes(message)
    local temp = split( message, " " )
    for i,v in ipairs(temp) do

        if (codes[v]) then
            -- outputChatBox( "Code found!: " .. v .. ": " .. codes[v], plr)
            local convertedMessage = codes[v] .. " (" .. v .. ")"
            temp[i] = convertedMessage
        end
        -- log(v)
    end
    message = table.concat(temp, " ")
    return message
end

function emergencyChat(plr, cmdName, ...)
    local message = table.concat({...}, " ")
    local result = convertCodes(message)
    outputChatBox( "[Origin Message]#AAAAAA " .. message, plr, 100, 255, 100, true )
    outputChatBox( "[Conver Message]#FFFFFF " .. result, plr, 100, 100, 255, true)
    
end
addCommandHandler( "e", emergencyChat)

function listCodes(plr, cmd, params)
    for k,v in pairs(codes) do
        log(k .. ": " .. v, plr)
    end
end
addCommandHandler( "codes", listCodes)