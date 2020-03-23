--Track_Fished is meant to register events of anything that is Fished and log its info

local TrackFishedFrame = CreateFrame("Frame")

local function WSFished(self, event)

    if (event == "LOOT_OPENED" ) then

        if( IsFishingLoot() ) then

            local itemLink = GetLootSlotLink(1)
            local _, _, Color, Ltype, itemId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink, 
            "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
            local itemName = GetItemInfo(itemId)
            item = WSabotDB.Museum[itemId]
            if item == nil then
                item = {}
                item.Id = itemId
                item.ItemLink = itemLink
                item.ItemName = itemName
                item.TotalCount = 1
                item.SessionCount = 1
                item.FirstFishedDate = date()
                item.LastFishedDate = date()
                WSabotDB.Museum[itemId] = item            
                
                SendChatMessage("Jai trouvé un " .. item.ItemName .." pour la premiere fois!","GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);

            else 
                item.TotalCount = item.TotalCount + 1
                item.SessionCount = 1 --TODO Detect session to increment
                item.LastFishedDate = date()
                WSabotDB.Museum[itemId] = item

                SendChatMessage("Encore pêché un " .. item.ItemName ..". Ca m'en fait "..item.TotalCount..".","GUILD" , DEFAULT_CHAT_FRAME.editBox.languageID);

            end

            WSabotDB.Player.LastActivityDateTS = date("!%c") --to use for session

        end

    end

end


TrackFishedFrame:SetScript("OnEvent", WSFished)
TrackFishedFrame:RegisterEvent("LOOT_OPENED")
