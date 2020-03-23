--Track_Fished is meant to register events of anything that is Fished and log its info

local ItemPushedFrame = CreateFrame("Frame")
local peche = {}
local function LogLoot()
    if( IsFishingLoot() ) then
        local itemLink = GetLootSlotLink(1)
        local itemName = GetItemInfo(itemLink)
        local fish = peche[itemLink] 
        if fish == nil then
            peche[itemLink] = 1
        else 
            fish = fish + 1
            peche[itemLink] = fish
        end
        SendChatMessage("Jai trouvé un " .. itemName .." c'est le "..fish .." de la journée!","GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);
    end
end

ItemPushedFrame:SetScript("OnEvent", LogLoot)
ItemPushedFrame:RegisterEvent("LOOT_OPENED")
