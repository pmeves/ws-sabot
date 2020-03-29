--Track_Fished is meant to register events of anything that is Fished and log its info


function ClearWSabotDB()
    wipe( WSabotDB )
    WSabotDB = CreateWSabotDB()
    Print("WS-Sabot: Database clear and reset!")
end

local function CreateWSabotDB()
    print("You must be new to ws-sabot... Welcome.")
    WSabotDB = {
        Config = {
            SessionTimeoutInSeconds = 3600 -- 1 hour default
        },
        Player = {
            Name = UnitName("player"),
            SessionID = 0, --Did not start fishing yet, he's new...
            LastActivityTime = nil
        },
        Museum = {},
        Sessions = {}
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




