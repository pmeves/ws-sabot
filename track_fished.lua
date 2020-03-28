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
            item = WSabotDB.Museum[itemId]

            --STORE IN MUSEUM
            if item == nil then
                item = {}
                item.Id = itemId
                item.ItemLink = itemLink
                item.ItemName = itemName
                item.TotalCount = 1
                item.SessionCount = 1
                item.FirstFishedDate = date()
                item.LastFishedDate = date()
                item.FishingSkill = 0 --GetPlayerCurrentSkillValue(356)
                WSabotDB.Museum[itemId] = item
                
                print("Jai trouvé un " .. item.ItemName .." pour la premiere fois!")

            else 
                item.TotalCount = item.TotalCount + 1
                item.SessionCount = 1 --TODO Detect session to increment
                item.LastFishedDate = date()
                WSabotDB.Museum[itemId] = item
                print("Encore un " .. item.ItemName ..". Ca m'en fait "..item.TotalCount..".")
            end

            --STORE IN SESSIONS

            local curr_utc = time()
            local lastActivity = WSabotDB.Player.LastActivityTime
            local is_new_session = true
            local session_id = WSabotDB.Player.SessionID or 0
            local position = UnitPosition("player");
            local fishing_zone = "Home"

            --GetMinimapZoneText() - Returns the zone text, that is displayed over the minimap.
            --GetRealZoneText() - Returns either instance name or zone name
            --GetSubZoneText() - Returns the subzone text, e.g. "The Canals".
            --GetZonePVPInfo() - Returns PVP info for the current zone.
            --GetZoneText() - Returns the zone text, e.g. "Stormwind City".

            if( lastActivity ~= nil ) then -- Returning player
                if( tonumber(curr_utc) - tonumber(lastActivity) < WSabotDB.Config.SessionTimeoutInSeconds ) then
                    is_new_session = false
                end
            end

            local session_item = { ItemId = item.Id, Position = position, Zone = GetRealZoneText(), SubZone = GetSubZoneText() }


            if( is_new_session ) then
                session_id = session_id + 1
                WSabotDB.Player.SessionID = session_id
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
