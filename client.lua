local screenW, screenH = guiGetScreenSize()
local guiWindow, guiTabPanel, guiTabDynamic, guiTabStatic, guiButtonClose, guiLabelDynamic, guiLabelStatic, guiGridListDynamic, guiGridListStatic

function openCodesWindow()
    if (not guiWindow) then
        guiWindow = guiCreateWindow((screenW - 640) / 2, (screenH - 525) / 2, 640, 525, "Codes", false)
        guiWindowSetSizable(guiWindow, false)
        guiTabPanel = guiCreateTabPanel(10, 27, 620, 443, false, guiWindow)
        guiTabStatic = guiCreateTab("Static", guiTabPanel)
        guiLabelStatic = guiCreateLabel(10, 10, 601, 59, "To write a static code you must add # in front.\nExample: If you write: #10-4\nOutput is: Roger (10-4)", false, guiTabStatic)
        guiGridListStatic = guiCreateGridList(10, 79, 601, 333, false, guiTabStatic)
        guiGridListAddColumn(guiGridListStatic, "Code", 0.5)
        guiGridListAddColumn(guiGridListStatic, "Translation", 0.5)
        guiGridListAddRow(guiGridListStatic)
        guiGridListSetItemText(guiGridListStatic, 0, 1, "10-4", false, false)
        guiGridListSetItemText(guiGridListStatic, 0, 2, "Roger", false, false)
        guiTabDynamic = guiCreateTab("Dynamic", guiTabPanel)
        guiLabelDynamic = guiCreateLabel(10, 10, 601, 59, "To write a dynamic code you must add $.in front.\nExample: You are in Idlewood and write: $loc\nOutput is: Idlewood", false, guiTabDynamic)
        guiGridListDynamic = guiCreateGridList(10, 79, 601, 333, false, guiTabDynamic)
        guiGridListAddColumn(guiGridListDynamic, "Code", 0.5)
        guiGridListAddColumn(guiGridListDynamic, "Description", 0.5)
        guiGridListAddRow(guiGridListDynamic)
        guiGridListSetItemText(guiGridListDynamic, 0, 1, "loc", false, false)
        guiGridListSetItemText(guiGridListDynamic, 0, 2, "Your current location", false, false)
        guiButtonClose = guiCreateButton(10, 476, 620, 39, "Close", false, guiWindow)
        addEventHandler("onClientGUIClick", guiButtonClose, closeCodesWindow, false)
    end
    guiSetVisible(guiWindow, true)
    showCursor(true)
end

function closeCodesWindow()
    guiSetVisible(guiWindow, false)
    showCursor(false)
end

addCommandHandler("codes", openCodesWindow)