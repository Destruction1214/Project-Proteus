require("PGStateMachine")
require("SetFighterResearch")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Galactic" then
            ScriptExit()
        end

        local owner = Object.Get_Owner()
        local rosters = {
            ["SELLASAS_LOADOUT_SWAP1"] = {
                lock = {"Sellasas_Loadout_Swap1", "Imperial_DHC", "Neutron_Star_Mercenary", "Carrack_Cruiser", "Victory_I_Fleet_Star_Destroyer", "Victory_II_Star_Destroyer", "Imperial_I_Star_Destroyer"},
                unlock = {"Sellasas_Loadout_Swap2", "Rep_DHC", "Neutron_Star", "Carrack_Cruiser_Laser", "Victory_I_Star_Destroyer", "Victory_II_Carrier", "Imperial_I_Star_Destroyer_Patrol"}
                },
            ["SELLASAS_LOADOUT_SWAP2"] = {
                lock = {"Sellasas_Loadout_Swap2", "Rep_DHC", "Neutron_Star", "Carrack_Cruiser_Laser", "Victory_I_Star_Destroyer", "Victory_II_Carrier", "Imperial_I_Star_Destroyer_Patrol"},
                unlock = {"Sellasas_Loadout_Swap1", "Imperial_DHC", "Neutron_Star_Mercenary", "Carrack_Cruiser", "Victory_I_Fleet_Star_Destroyer", "Victory_II_Star_Destroyer", "Imperial_I_Star_Destroyer"}},
        }
		local swap = rosters[Object.Get_Type().Get_Name()]
        
        for _, unit in pairs(swap.lock) do
            owner.Lock_Tech(Find_Object_Type(unit))
        end
        for _, unit in pairs(swap.unlock) do
            owner.Unlock_Tech(Find_Object_Type(unit))
        end

        Object.Despawn()
        ScriptExit()
    end
end