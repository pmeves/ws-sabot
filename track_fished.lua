--Track_Fished is meant to register events of anything that is Fished and log its info

local ItemPushedFrame = CreateFrame("Frame")
local peche = {}
local function LogLoot()
    if( IsFishingLoot() ) then
        local itemLink = GetLootSlotLink(1)
        local _, _, Color, Ltype, itemId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink, 
        "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
        local itemName = GetItemInfo(itemId)
        local fish = peche[itemId]

        if fish == nil then
            fish = {}
            fish.Id = itemId
            fish.ItemLink = itemLink
            fish.ItemName = itemName
            fish.TotalFishedCount = 1
            fish.FirstFishedDate = date()
            fish.LastFishedDate = date()
            peche[itemId] = fish
        else 
            fish.TotalFishedCount = fish.TotalFishedCount + 1
            fish.LastFishedDate = date()
            peche[itemId] = fish
        end

        SendChatMessage("Jai trouvé un " .. fish.ItemName .." c'est le "..fish.TotalFishedCount .." de la journée!","GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);
        SendChatMessage("La premiere fois que jai trouvé ce poisson cetait en " .. tostring(fish.FirstFishedDate),"GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);

    end
end

ItemPushedFrame:SetScript("OnEvent", LogLoot)
ItemPushedFrame:RegisterEvent("LOOT_OPENED")
