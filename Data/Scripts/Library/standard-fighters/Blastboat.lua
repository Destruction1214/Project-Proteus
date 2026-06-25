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
		local fighter = "EARLY_SKIPRAY_SQUADRON"
		
		if Is_Amalgam(owner) then
			alias = native
		end
		
		if owner == "EMPIREOFTHEHAND" and native == "IMPERIAL" then
			alias = "IMPERIAL"
		end
		
		local simpletypes = {
			IMPERIAL = "SKIPRAY_SQUADRON",
			PENTASTAR = "ADVANCED_SKIPRAY_SQUADRON",
			GREATER_MALDROOD = "EARLY_SKIPRAY_SQUADRON",
			ERIADU_AUTHORITY = "EARLY_SKIPRAY_SQUADRON",
			REBEL = "SKIPRAY_SQUADRON",
			MANDALORIANS = "FIRESPRAY_GUNSHIP_SQUADRON",
			HUTT_CARTELS = "KRAYT_GUNSHIP_SQUADRON",
			YEVETHA = "SKIPRAY_SQUADRON"
		}
		
		if simpletypes[owner] then
			fighter = simpletypes[owner]
		elseif simpletypes[alias] then
			fighter = simpletypes[alias]
		end
		
		local proteustypes = {
			-- TR entries
			ARDA = {"EARLY_SKIPRAY_SQUADRON", false},
			BAKURA = {"ADVANCED_SKIPRAY_SQUADRON", false},
			BRAK = {"EARLY_SKIPRAY_SQUADRON", false,
					{"BrakFighters", "ADVANCED_SKIPRAY_SQUADRON", false}}, --research 1
			CATO_NEIMOIDIA = {"SKIPRAY_SQUADRON", false},
			CIUTRIC_HEGEMONY = {"EARLY_SKIPRAY_SQUADRON", false},
			DASTA = {"YV_929_SQUADRON", false},
			ELROOD = {"SKIPRAY_SQUADRON", false},
			GAROS = {"VCX_820_SQUADRON", false},
			HAMMERS = {"SKIPRAY_SQUADRON", false},
			IMPERIAL_LIANNA = {"ADVANCED_SKIPRAY_SQUADRON", false},
			ISECTOR = {"EARLY_SKIPRAY_SQUADRON", false},
			JARDEEN = {"SKIPRAY_SQUADRON", false},
			KAARENTH_DISSENSION = {"SKIPRAY_SQUADRON", false,
					{"SkiprayZeta", "SKIPRAY_ION_SQUADRON", false}}, --research 1
			KAMINO = {"SKIPRAY_SQUADRON", false},
			KASHYYYK = {"SKIPRAY_INTERCEPTOR_SQUADRON", false},
			KUAT = {"FIRESPRAY_GUNSHIP_SQUADRON", false},
			LAMBDA = {"SKIPRAY_SQUADRON", false},
			LUMIYA = {"THETA_ASSAULT_SQUADRON", false},
			MAELSTROM = {"SKIPRAY_SQUADRON", false},
			NABOO = {"EARLY_SKIPRAY_SQUADRON", false},
			PRAKITH = {"THETA_ASSAULT_SQUADRON", false},
			PRENTIOCH = {"SKIPRAY_SQUADRON", false},
			PROPHETS = {"THETA_ASSAULT_SQUADRON", false},
			PROTECTORATE = {"FIRESPRAY_GUNSHIP_SQUADRON", false},
			QUINTAD = {"EARLY_SKIPRAY_SQUADRON", false},
			RADAMA = {"SKIPRAY_SQUADRON", false},
			RAYTER = {"SKIPRAY_SQUADRON", false},
			RESTORED_EMPIRE = {"EARLY_SKIPRAY_SQUADRON", false},
			SECTOR_5 = {"SKIPRAY_SQUADRON", false},
			SELLASAS = {"ADVANCED_SKIPRAY_SQUADRON", false},
			SHADOWSPAWN = {"SKIPRAY_SQUADRON", false},
			TAGGE = {"YV_929_SQUADRON", false},
			TAMARIN = {"EARLY_SKIPRAY_SQUADRON", false},
			TAPANI = {"EARLY_SKIPRAY_SQUADRON", false},
			TIERFON = {"ADVANCED_SKIPRAY_SQUADRON", false},
			VOGEL = {"SKIPRAY_INTERCEPTOR_SQUADRON", false},
			WESSEX = {"FIRESPRAY_GUNSHIP_SQUADRON", false},
			WILD_SPACE = {"EARLY_SKIPRAY_SQUADRON", false},
			ZAARIN_REMNANTS = {"ADVANCED_SKIPRAY_SQUADRON", false},
			ZERO_COMMAND = {"SKIPRAY_SQUADRON", false},
			ZSINJ_REMNANTS = {"FIRESPRAY_GUNSHIP_SQUADRON", false},
			--Project Proteus
			GRUNGER = {"ADVANCED_SKIPRAY_SQUADRON", false},
			THORN = {"THETA_ASSAULT_SQUADRON", false},
			X1 = {"THETA_ASSAULT_SQUADRON", false},
			PRAJI = {"VCX_820_SQUADRON", false},
			BALMORRA = {"SKIPRAY_SQUADRON", false},
			RENDILI = {"ADVANCED_SKIPRAY_SQUADRON", false},
			VEERS = {"ADVANCED_SKIPRAY_SQUADRON", false},
		}
		
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
		
		if suffix then
			fighter = fighter .. suffix
		end
		return fighter
	end
}
