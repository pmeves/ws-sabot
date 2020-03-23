--Track_Fished is meant to register events of anything that is Fished and log its info

local function CreateWSabotDB()
    print("You must be new to ws-sabot... Welcome.")
    WSabotDB = {
        Config = {
            SessionTimeoutInMiliseconds = 300000
        },
        Player = {},
        Museum = {}
    }
    print("WSabotDB was created to track your fishing activities, have fun now!")
    return WSabotDB
end

local f = CreateFrame ("frame", nil, UIParent)
f:Hide()
f:RegisterEvent ("ADDON_LOADED")

f:SetScript ("OnEvent", function (self, event, addonName)

	if (addonName == "ws-sabot") then
	
		WSabotDB = WSabotDB or CreateWSabotDB()
	
	end
end)
