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
        guiWindowSetSizable(guiWindow, true)
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

        guiWindowSetSizable(guiWindow, true)
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

function emergencyChat(cmdName, ...)
    local plr = localPlayer
    local message = table.concat({...}, " ")
    local result = convertStaticCodes(message)
    outputChatBox( "[INPUT]#AAAAAA " .. message, 100, 255, 100, true )
    result = convertDynamicCodes(result, plr)
    outputChatBox( "[OUTPUT]#FFFFFF " .. result, 100, 100, 255, true)
    
end
addCommandHandler("e", emergencyChat)