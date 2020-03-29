--Track_Fished is meant to register events of anything that is Fished and log its info
local TrackFishedFrame = CreateFrame("Frame")
local function WSFished(self, event)

    if (event == "LOOT_OPENED" ) then

        if( IsFishingLoot() ) then

            --IMPORTANT ITEM INFO
            local itemLink = GetLootSlotLink(1)
            local _, _, Color, Ltype, itemId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink, 
            "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
            local itemName = GetItemInfo(itemId)
            local currFishSkill = WSabotGetFishingSkill()
            local currDate = date()

            item = WSabotDB.Museum[itemId]

            --STORE IN MUSEUM
            if item == nil then
                item = {}
                item.Id = itemId
                item.ItemLink = itemLink
                item.ItemName = itemName
                item.TotalCount = 1
                item.FirstFishedDate = currDate
                item.LastFishedDate = currDate
                item.MinSkill = currFishSkill
                item.MaxSkill = currFishSkill
                WSabotDB.Museum[itemId] = item
                
                print("Jai trouvé un " .. item.ItemName .." pour la premiere fois!")

            else 
                item.TotalCount = item.TotalCount + 1
                item.LastFishedDate = currDate
                if item.Maxkill == nil or item.Maxkill < currFishSkill then
                    item.MaxSkill = currFishSkill
                end

                WSabotDB.Museum[itemId] = item
                print("Encore un " .. item.ItemName ..". Ca m'en fait "..item.TotalCount..".")
            end

            -- //STORE IN SESSIONS
            local is_new_session = true
            local session_id = WSabotDB.Player.SessionID or 0
            local position = UnitPosition("player");
            local fishing_zone = "Home"

            local session_item = { 
                ItemId = itemId, 
                ItemName = itemName,
                Position = position, 
                Zone = GetRealZoneText(), 
                SubZone = GetSubZoneText(),
                FishSkill = currFishSkill,
                Time = currDate
            }

            if( WSabotIsSessionOver() ) then
                WSabotStartNewSession()
            elseif( not WSabotDB.Sessions[session_id] ) then
                WSabotDB.Sessions[session_id] = {}
            end

            WSabotDB.Sessions[session_id][itemId] = WSabotDB.Sessions[session_id][itemId] or {}

            table.insert( WSabotDB.Sessions[session_id][itemId], session_item )

            WSabotDB.Player.LastActivityTime = time() --to use for session

        end

    end

end


TrackFishedFrame:SetScript("OnEvent", WSFished)
TrackFishedFrame:RegisterEvent("LOOT_OPENED")
