--Track_Fished is meant to register events of anything that is Fished and log its info

local ItemPushedFrame = CreateFrame("Frame")

local function LogLoot(bagSlot, iconFileID)
    local texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bagSlot, iconFileID)
    local itemName = GetItemInfo(itemLink)
    SendChatMessage("Jai trouvé un " .. itemName ,"GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);
end

ItemPushedFrame:SetScript("OnEvent", LogLoot)
ItemPushedFrame:RegisterEvent("ITEM_PUSH")
