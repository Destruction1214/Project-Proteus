require("StandardFighterFunctions")

-- Project Proteus standard fighter edit
-- proteustypes table is layed out in the following format
-- group name = { [1], [2],
--         { [3],[4],[5] }, --research table 1
--         { [6],[7],[8] }, --research table 2
-- }
-- 
-- [1] *required* = string, standard fighter to use in slot
-- [2] *required* = false or string, replaces [1] fighter with fighter type when proteus override found
-- { [3],[4],[5] } *optional* = table, research layout 1
-- [3] *required* = string, research name to lookup completion status
-- [4] *required* = string, unit to replace if research found complete, replaces [1]
-- [5] *required* = false or string, similar setup to [2] 
-- later order research priotised, research table Y replaces research X if research complete where Y > X

return {
	Evaluate_Fighters = function(native,suffix,owner,alias,techLevel,regime,flags,is_main_empire)		
		local double = false
		local fighter = "PREYBIRD_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = native
		end
		
		local simpletypes = {
			IMPERIAL = "TIE_AVENGER_SQUADRON",
			GREATER_MALDROOD = "TIE_V1_SQUADRON",
			ERIADU_AUTHORITY = "TIE_X1_SQUADRON",
			PENTASTAR = "TIE_X2_SQUADRON",
			ZSINJ_EMPIRE = "TIE_AGGRESSOR_SQUADRON",
			EMPIREOFTHEHAND = "SCARSSIS_SQUADRON",
			HAPES_CONSORTIUM = "HOUSE_MIYTIL_FIGHTER_SQUADRON",
			CORPORATE_SECTOR = "DREXL_SQUADRON",
			HUTT_CARTELS = "CLOAKSHAPE_NEW_SQUADRON",
			MANDALORIANS = "FIRESPRAY_SQUADRON",
			CORELLIA = "HLAF_SQUADRON"
		}
		
		local proteustypes = {
			-- TR entries
			ARDA = {"TIE_AGGRESSOR_SQUADRON", false},
			BAKURA = {"ARMORED_INTERCEPTOR_SQUADRON", false},
			BRAK = {"CLOAKSHAPE_NEW_SQUADRON", false,
					{"BrakFighters", "ARC_170_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"TIE_X1_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"TIE_AVENGER_TORPS_SQUADRON", false},
			DASTA = {"T_WING_SQUADRON", false},
			ELROOD = {"PREYBIRD_SQUADRON", false},
			GAROS = {"TIE_X2_SQUADRON", false},
			HAMMERS = {"TIE_AVENGER_SQUADRON", false},
			IMPERIAL_LIANNA = {"TIE_AVENGER_SQUADRON", false},
			ISECTOR = {"TIE_GT_SQUADRON", false},
			JARDEEN = {"STARWING_FIGHTER_SQUADRON", false},
			KAARENTH_DISSENSION = {"TIE_AVENGER_SQUADRON", false},
			KAMINO = {"TIE_X1_SQUADRON", false},
			KASHYYYK = {"BELBULLAB22_SQUADRON", false},
			KUAT = {"DEFENSIVE_ETA2_ACTIS_SQUADRON", false},
			LAMBDA = {"TIE_AVENGER_SQUADRON", false},
			LUMIYA = {"TIE_SENTINEL_SQUADRON", false},
			MAELSTROM = {"CLOAKSHAPE_NEW_SQUADRON", false},
			NABOO = {"TIE_X2_SQUADRON", false},
			PRAKITH = {"TIE_V1_SQUADRON", false},
			PRENTIOCH = {"TIE_AGGRESSOR_SQUADRON", false},
			PROPHETS = {"ARMORED_INTERCEPTOR_SQUADRON", false},
			PROTECTORATE = {"TOSCAN_GUNSHIP_SQUADRON", false},
			QUINTAD = {"R42_STARCHASER_SQUADRON", false},
			RADAMA = {"TIE_DEFENDER_SQUADRON", false},
			RAYTER = {"RIHKXYRK_SQUADRON", false},
			RESTORED_EMPIRE = {"CLOAKSHAPE_SQUADRON", false},
			SECTOR_5 = {"TIE_SENTINEL_SQUADRON", false},
			SELLASAS = {"ELITE_SHIELDED_ARMORED_INTERCEPTOR_SQUADRON", false},
			SHADOWSPAWN = {"TIE_DEFENDER_SQUADRON", false},
			TAGGE = {"TIE_GT_TORPS_SQUADRON", false},
			TAMARIN = {"TOSCAN_GUNSHIP_SQUADRON", false},
			TAPANI = {"TIE_AVENGER_SQUADRON", false},
			TIERFON = {"ARMORED_INTERCEPTOR_SQUADRON", false},
			VOGEL = {"TIE_AGGRESSOR_SQUADRON", false},
			WESSEX = {"TIE_X1_SQUADRON", false},
			WILD_SPACE = {"CLOAKSHAPE_NEW_SQUADRON", false},
			ZAARIN_REMNANTS = {"TIE_AVENGER_TORPS_SQUADRON", false},
			ZERO_COMMAND = {"TIE_SENTINEL_SQUADRON", false},
			ZSINJ_REMNANTS = {"", false},
			--Project Proteus
			GRUNGER = {"TIE_AVENGER_SQUADRON", false},
			THORN = {"TIE_AVENGER_SQUADRON", false},
			X1 = {"", false},
			PRAJI = {"STARWING_SQUADRON", false},
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		if owner == "EMPIRE" and Check_Flags(flags,"EMPIRE_X1") then
			fighter = "TIE_X1_SQUADRON"
		end
		
		if owner == "IMPERIAL_PROTEUS" then
            local group_name = GlobalValue.Get("PROTEUS_GROUP_NAME")
            if proteustypes[group_name] then
                fighter = proteustypes[group_name][1]
                if proteustypes[group_name][2] ~= false then
                    if Check_Flags(flags, "PROTEUS_OVERRIDE") then
                        fighter = proteustypes[group_name][2]
                    end
                end
                 if table.getn(proteustypes[group_name]) > 2 then
                    for i = 3, table.getn(proteustypes[group_name]), 1 do
                        local research = proteustypes[group_name][i][1]
                        if Get_Fighter_Research(research) then
                            fighter = proteustypes[group_name][i][2]
                            if proteustypes[group_name][i][3] ~= false then
                                if Check_Flags(flags, "PROTEUS_OVERRIDE") then
                                    fighter = proteustypes[group_name][i][3]
                                end
                            end
                        end
                    end    
                end
            end
        end 
		
		if is_main_empire then
			if regime == 4 then
				fighter = "SHADOW_DROID_LIGHT_SQUADRON"
			end
		end
		
		if owner == "REBEL" or alias == "REBEL" then
			if Check_Flags(flags,"DREXLX") and Get_Fighter_Research("CoS_Tevv") then
				fighter = "DREXL_SQUADRON"
			else
				if techLevel >= 4 then
					if Get_Fighter_Research("Ewing") then
						fighter = "E_WING_SQUADRON"
					else
						fighter = "E_WING_PROTOTYPE_SQUADRON"
					end
				else
					fighter = "X_WING_SQUADRON"
				end
			end
		end
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}
