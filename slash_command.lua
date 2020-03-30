
-- /command arg file management

--TODO Remove from here and move to ws_sabot_helpers
function WSabotIsSessionOver()
    local curr_utc = time()
    local lastActivity = WSabotDB.Player.LastActivityTime
    local isOver = true
    if( lastActivity ~= nil ) then -- Returning player
        if( tonumber(curr_utc) - tonumber(lastActivity) < WSabotDB.Config.SessionTimeoutInSeconds ) then
            is_new_session = false
        end
    end
    return isOver
end


function WSabotGetFishingSkill()
    local FishSkill = -1
    local numSkills = GetNumSkillLines();
    for i = 1, numSkills do 
        local skillName, _ , _ , skillRank, _ , skillModifier, _ , _ , _ , _ , _ , _ , _  = GetSkillLineInfo(i) 
        if skillName ==	PROFESSIONS_FISHING then
            FishSkill = skillRank + skillModifier
            break 
        end   
    end
    return FishSkill
end

function WSabotStartNewSession()
    local currSession = WSabotDB.Player.SessionID
    local fishySession = WSabotDB.Sessions[currSession]
    local sessionFishCount = 0

    if(fishySession) then
        for _ in pairs(fishySession) do sessionFishCount = sessionFishCount + 1 end
    end

    if sessionFishCount == 0 then
        print("WS-SABOT: A new session (#"..currSession..") is empty and ready to rock paper fishers!")
    else
        currSession = currSession + 1
        WSabotDB.Player.SessionID = currSession
        WSabotDB.Sessions[currSession] = {}
        local previousSession = currSession-1
        print("WS-SABOT: Closed Session #"..previousSession..". You did well, master.")
    end

end

local function ClearCurrentSession()
    if( WSabotIsSessionOver() ) then
        WSabotStartNewSession()
    else
        local currSession = WSabotDB.Player.SessionID
        local session = WSabotDB.Sessions[currSession]
        if( session ) then
            wipe(WSabotDB.Sessions[currSession])
            print("WS-SABOT: Cleared current session #"..currSession..".")
        else
            print("WS-SABOT: Current session (#"..currSession..") is already empty bro.") 
        end
    end 
end

local function ReportSession()
    
    local currSession = WSabotDB.Player.SessionID
    local fishySession = WSabotDB.Sessions[currSession]
    local itemCount = 0
    local totalFish = 0
    local sessionOver = WSabotIsSessionOver()

    if( fishySession and not sessionOver ) then 
        --Determine Total
        for key, value in pairs(fishySession) do
            totalFish = totalFish +  #fishySession[key]
        end

         --Report each line
        for key, value in pairs(fishySession) do
            local fishCount = #fishySession[key]
            local fishPerCent = ( fishCount / totalFish ) * 100
            if itemCount == 0 then
                SendChatMessage(GetUnitName("player")..", Grand Maitre pêcheur, a péché cette dernière session :","GUILD", DEFAULT_CHAT_FRAME.editBox.languageID);
            end
            itemCount = itemCount + 1

            --We started storing ItemName later so we have to get the name again...
            --Bug when first called?
            local itemName = fishySession[key][ItemName] or GetItemInfo(key) 
            
            local itemLine = itemCount..". "..itemName .. " "
            local lineLength = #itemLine
            local maxLineLength = 40
            local missingDots = maxLineLength - lineLength
            for i=1, missingDots do
                itemLine = itemLine.."."
            end
            SendChatMessage(itemLine.." "..fishCount.." ".."("..fishPerCent.."%"..")","GUILD", DEFAULT_CHAT_FRAME.editBox.languageID);
        end
    end

    --If session is empty
    if itemCount == 0 then
        SendChatMessage(GetUnitName("player")..", Grand Maitre pêcheur, n'a pas péché récemment.","GUILD", DEFAULT_CHAT_FRAME.editBox.languageID);
    end

end

local function ReportMuseum()
    -- TODO call the DB for overall data
    SendChatMessage(GetUnitName("player")..", Grand Maitre pêcheur, a péché jusqu'à ce jour :","GUILD", DEFAULT_CHAT_FRAME.editBox.languageID);
    --SendChatMessage("Poueeeette, c'est pas encore implémenté!","GUILD", DEFAULT_CHAT_FRAME.editBox.languageID);
    local museum = WSabotDB.Museum
    local itemCount = 0
    local orderMap = {}

    --order museum by Total fish count
    --table.sort(museum, function(a,b) return a.TotalCount > b.TotalCount end)
    
    --Order Mapping
    for key,value in pairs(museum) do 
        table.insert(orderMap, { Name = value.ItemName, Count = value.TotalCount })
    end
    
    table.sort(orderMap, function(a,b) return a.Count > b.Count end)

    --Report each museum line
    for i=1, #orderMap do 
        local itemLine = i..". ".. orderMap[i].Name .. " "
        local lineLength = #itemLine
        local maxLineLength = 40
        local missingDots = maxLineLength - lineLength
        for i=1, missingDots do
            itemLine = itemLine.."."
        end
        SendChatMessage(itemLine.." ".. orderMap[i].Count,"GUILD", DEFAULT_CHAT_FRAME.editBox.languageID);
    end
end

SLASH_SABOT1 = '/sabot'
local function Sabotcommand(msg, editBox)
    local msg = string.lower(msg)
    if (not msg or msg == "" or msg == "help" or msg == "h") then
        print("Bienvenue dans l'aide du meilleur addon possible ;)")    
        print("Les commandes possible sont :")
        print("     /sabot session pour afficher les résultats de la dernière session")
        print("     /sabot museum pour afficher tout ton butin de pèche")
        print("     /sabot clear pour effacer la session en cours sans en garder son registre")
        print("     /sabot next pour sauvegarder la session en cours et passer a la suivante")
        print("     /sabot clearallnow pour tout reset")
    elseif ( msg == "session" or msg == "s" ) then
        ReportSession()
    elseif ( msg == "museum" or msg == "m") then
        ReportMuseum()
    elseif ( msg == "clear" or msg == "c") then
        ClearCurrentSession()
    elseif ( msg == "next" or msg == "n") then
        WSabotStartNewSession()
    elseif ( msg == "clearallnow") then
        ClearWSabotDB()
    end
end
SlashCmdList["SABOT"] = Sabotcommand
