--Track_Fished is meant to register events of anything that is Fished and log its info

local ItemPushedFrame = CreateFrame("Frame")

local function LogLoot()
    if( IsFishingLoot() ) then
        local itemLink = GetLootSlotLink(1)
        local itemName = GetItemInfo(itemLink)
        SendChatMessage("Jai trouvé un " .. itemName ,"GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);
     end
end

ItemPushedFrame:SetScript("OnEvent", LogLoot)
ItemPushedFrame:RegisterEvent("LOOT_OPENED")
