--Track_Fished is meant to register events of anything that is Fished and log its info

local ItemPushedFrame = CreateFrame("Frame")

local function LogLoot(bagSlot, iconFileID)
    local _,_,_,_,_,_,_,_,_,itemID = GetContainerItemInfo(bagSlot, iconFileID)
    local itemID = GetItemInfo(item)
    SendChatMessage("Jai trouvé un " .. itemName ,"GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);
end

ItemPushedFrame:SetScript("OnEvent", LogLoot)
ItemPushedFrame:RegisterEvent("ITEM_PUSH")
