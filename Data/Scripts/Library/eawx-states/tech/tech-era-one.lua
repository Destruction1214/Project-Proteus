require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")
require("SetFighterResearch")

return {
    on_enter = function(self, state_context)

        self.entry_time = GetCurrentTime()

        if self.entry_time <= 5 then
            UnitUtil.SetLockList("REBEL", {
                "Bulwark_III",
                "Republic_Star_Destroyer",
                "MC90", "AckbarHO2GV", "NantzIn2FW", 
                "New_Republic_Defense_Trooper_Company",
                "V_Wing_Airspeeder_Company",
                "Jedi_Temple",
                "New_Republic_Jedi_Knight_Company"
            }, false)
            
            UnitUtil.SetLockList("EMPIRE", {
                "Praetor_II_Battlecruiser",
                "Strike_Cruiser",
                "TaggeCo_HQ",
                "PX10_Company",
                "Imperial_AT_AT_Walker_Turbolaser_Refit_Company",
                "AT_ST_A_Company",
                -- Historical-only units
                "Navy_Commando_Company",
				"Dark_Trooper_Phase_II_Company",
				"AT_XT_Company",
				"AT_AA_Missile_Walker_Company",
				"SPMAT_Company",
				"Imperial_Flashblind_Company",
				"Customs_Corvette",
				"Vigil",
				"Surveyor_Frigate",
				"Battle_Horn",
				"Gladiator_I",
				"Imperial_II_Frigate",
				"Immobilizer_418_Refit",
				"Acclamator_I_Carrier"
            }, false)
			
			UnitUtil.SetLockList("EMPIRE", {
                "Imperial_Stormtrooper_Company"
            })
            
			UnitUtil.SetLockList("GREATER_MALDROOD", {
                "Crimson_Victory_II_Star_Destroyer"
            })
			
            UnitUtil.SetLockList("PENTASTAR", {
                "Cygnus_HQ",
                "Merkuni_HQ"
            })

            UnitUtil.SetLockList("ERIADU_AUTHORITY", {
                "Tarkin_Estates"
            })

            UnitUtil.SetLockList("ERIADU_AUTHORITY", {
                "TaggeCo_HQ",
				"GormTalquist_HQ"
            }, false)

            UnitUtil.SetLockList("GREATER_MALDROOD", {
                "TaggeCo_HQ",
				"GormTalquist_HQ",
				-- Historical-only units
				"Victory_II_Star_Destroyer",
				"Secutor_Star_Destroyer"
            }, false)

            UnitUtil.SetLockList("PENTASTAR", {
                "TaggeCo_HQ",
				"GormTalquist_HQ"
            }, false)

            UnitUtil.SetLockList("ZSINJ_EMPIRE", {
                "TaggeCo_HQ",
				"GormTalquist_HQ",
				-- Historical-only units
				"Navy_Commando_Company",
				"Dark_Trooper_Phase_II_Company",
				"Imperial_Jumptrooper_Company",
				"AT_MP_Company",
				"AT_ST_Company",
				"Imperial_Missile_Artillery_Company",
				"B5_Juggernaut_Company",
				"Imperial_AT_TE_Walker_Company",
				"Raider_I_Corvette",
				"Raider_II_Corvette",
				"Alliance_Assault_Frigate_II",
				"Gladiator_II",
				"Acclamator_I_Carrier",
				"Acclamator_Battleship",
            }, false)

			UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
                "Imperial_Army_Guard_Company"
            })
			
			UnitUtil.SetLockList("IMPERIAL_PROTEUS", {
				"TIE_Crawler_Company",
				"Dragon_Heavy_Cruiser",
				"Marauder_Cruiser",
				"Customs_Corvette",
				"Raider_I_Corvette",
				"CR92A",
				"Eidolon",
				"Pursuit_Light_Cruiser",
				"Persuader_Company",
				"Imperial_AT_AP_Walker_Company",
				"AT_MP_Company",
				"Torpedo_Sphere",
				"Venator_Star_Destroyer",
				"Raptor_Trooper_Company",
                "TaggeCo_HQ",
				"CEC_HQ",
				"TransGalMeg_HQ",
				"Bulwark_I"
            }, false)
			
			--Lambda Sector faction unlocks
			--The tech-era scripts do their thing after the unlocks happen in the GC_MasterScript, so the propro unlocks have to be handled here --NightDragon
			if Get_Fighter_Research("IMPERIAL_NABOO") then
				UnitUtil.SetLockList("EMPIRE", {	--Direct copy of Imperial Naboo's ProteusWarlordLibrary entry for simplicity
					"Beta_ETR_3_Group", "Customs_Corvette", "Surveyor_Frigate", "Vigil", "Carrack_Cruiser", "Star_Galleon", "Battle_Horn", "Imperial_DHC",
					"Gladiator_I", "Acclamator_I_Carrier", "Acclamator_II", "Imperial_II_Frigate", "Immobilizer_418_Refit", "Victory_I_Fleet_Star_Destroyer",
					"Imperial_I_Star_Destroyer", "Imperial_II_Star_Destroyer", 
					"Impellor_Carrier", "Compellor_Battlecruiser", "Legator_Star_Dreadnought", "Executor_Star_Dreadnought", 
					"Imperial_Army_Trooper_Company", "Imperial_Galactic_Marine_Company", "Dark_Trooper_Phase_II_Company", "Imperial_74Z_Bike_Company",
					"AT_XT_Company", "Gian_Company", "AT_ST_Company",
					"AT_AA_Missile_Walker_Company", "Imperial_TX130S_Company", "SPMAT_Company", "Imperial_Flashblind_Company", "Imperial_Dropship_Transport_Company",
					"PX4_Company", "Imperial_A5_Juggernaut_Company", "Imperial_AT_AT_Walker_Company",
					"Silverline_Location_Set",
				})
				
				UnitUtil.SetLockList("ZSINJ_EMPIRE", {	--Direct copy of Imperial Kamino's ProteusWarlordLibrary entry for simplicity
					"YZ_775_Freighter_Group", "Raider_I_Corvette", "Raider_II_Corvette", "Lancer_Frigate", "Active_Frigate", "Imperial_Nebulon_B",
					"Alliance_Assault_Frigate_II", "Gladiator_II", "Acclamator_I_Support", "Acclamator_I_Carrier", "Immobilizer_Twin_Well", "Victory_II_Star_Destroyer",
					"Imperial_I_Star_Destroyer", "Acclamator_Battleship", "Aggressor_Star_Destroyer", 
					"Sorannan_Star_Destroyer", "Vengeance_Star_Dreadnought",
					"Navy_Commando_Company", "Incinerator_Stormtrooper_Company", "Imperial_Jumptrooper_Company", "EVO_Trooper_Company", "Dark_Trooper_Phase_II_Company", 
					"Imperial_ULAV_Company", "AT_MP_Company", "Chariot_LAV_Company", "AT_ST_Company", 
					"AT_AA_Flak_Walker_Company", "Imperial_APC_Company", "Imperial_Missile_Artillery_Company", "Imperial_Modified_LAAT_Company",
					"Imperial_AT_TE_Walker_Company", "B5_Juggernaut_Company",
				})
				
				UnitUtil.SetLockList("GREATER_MALDROOD", {	--4 changes, not worth the whole list
					"Victory_II_Star_Destroyer",
					"Imperial_I_Star_Destroyer_Carrier",
					"Secutor_Star_Destroyer",
					"Light_Mercenary_Company",
				})
				
				UnitUtil.SetLockList("GREATER_MALDROOD", {
					"Crimson_Victory_II_Star_Destroyer",	--Has to be re-locked after being unlocked above
				}, false)
			end
			
        end
    end,
    on_update = function(self, state_context)   
    end,
    on_exit = function(self, state_context)
    end
}