require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Galactic" then
            ScriptExit()
        end

        GlobalValue.Set("SHIELDED_WALKERS", true)

        local era = GlobalValue.Get("CURRENT_ERA")
        local owner = Object.Get_Owner()

        owner.Lock_Tech(Find_Object_Type("AT_ST_A_Company"))
        owner.Lock_Tech(Find_Object_Type("Imperial_AT_AP_Walker_Company"))
        owner.Lock_Tech(Find_Object_Type("Imperial_AT_AT_Walker_Company"))
        owner.Lock_Tech(Find_Object_Type("Imperial_AT_AT_Walker_Turbolaser_Refit_Company"))
        owner.Unlock_Tech(Find_Object_Type("Shielded_AT_ST_A_Company"))
        owner.Unlock_Tech(Find_Object_Type("Shielded_AT_AP_Walker_Company"))

        if era >= 4 then
            owner.Unlock_Tech(Find_Object_Type("Shielded_Imperial_AT_AT_Walker_Turbolaser_Refit_Company"))
        else
            owner.Unlock_Tech(Find_Object_Type("Shielded_Imperial_AT_AT_Walker_Company"))
        end
        
        Object.Despawn()
        ScriptExit()
    end
end