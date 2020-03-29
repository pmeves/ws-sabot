
function GetFishingSkill()
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


SLASH_SABOT1 = '/sabot'
local function Sabotcommand(msg, editBox)
    if (not msg or msg == "" or msg == "help") then
    print("Bienvenue dans l'aide du meilleur addon possible ;)")    
    print("Les commandes possible sont :")
    print("     /sabot session pour afficher les résultats de la dernière session")
    print("     /sabot museum pour afficher tout ton butin de pèche")
    elseif (msg == "session") then
    -- TODO call the DB for session data
    SendChatMessage(GetUnitName("player")..", Grand Maitre pêcheur, a péché cette dernière session :","GUILD", DEFAULT_CHAT_FRAME.editBox.languageID);
    elseif ( msg == "museum") then
    -- TODO call the DB for overall data
    SendChatMessage(GetUnitName("player")..", Grand Maitre pêcheur, a péché jusqu'à ce jour :","GUILD", DEFAULT_CHAT_FRAME.editBox.languageID);
    end
end
SlashCmdList["SABOT"] = Sabotcommand
