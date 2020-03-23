--Track_Fished is meant to register events of anything that is Fished and log its info

local ItemPushedFrame = CreateFrame("Frame")
local peche = {}
local function LogLoot()
    if( IsFishingLoot() ) then
        local itemLink = GetLootSlotLink(1)
        local itemName = GetItemInfo(itemLink)
        local fish = peche[itemLink]

        if fish == nil then
            fish = {}
            fish.ItemLink = itemLink
            fish.ItemName = itemName
            fish.TotalFishedCount = 1
            fish.FirstFishedDate = date()
            fish.LastFishedDate = date()
            peche[itemLink] = fish
        else 
            fish.TotalFishedCount = fish.TotalFishedCount + 1
            fish.LastFishedDate = date()
            peche[itemLink] = fish
        end

        SendChatMessage("Jai trouvé un " .. itemName .." c'est le "..fish.TotalFishedCount .." de la journée!","GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);
        SendChatMessage("La premiere fois que jai trouvé ce poisson cetait en " .. tostring(fish.FirstFishedDate),"GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);

    end
end

ItemPushedFrame:SetScript("OnEvent", LogLoot)
ItemPushedFrame:RegisterEvent("LOOT_OPENED")
