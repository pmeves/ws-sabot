
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


SLASH_SABOT1 = '/sabot'; 
SLASH_SABOTS1 = '/sabottest'; 
function macommande(msg, editbox)
            SendChatMessage("on fait un addon de ouf !", "WHISPER", DEFAULT_CHAT_FRAME.editBox.languageID, msg)
end
function montest(msg, editbox)

end

SlashCmdList.SABOT = macommande
SlashCmdList.SABOTS = montest