return {
	Ship_Crew_Requirement = 110,
	Fighters = {
		["LIGHT_FIGHTERBOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 1, HeroOverride = {{"PANAKA_THEED"}, {"N1_SQUADRON"}}}
		},
		["BOMBER2_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		}
	},
	Native = "IMPERIAL",
	FighterFlags = {"PROTEUS_OVERRIDE"},
	Scripts = {"multilayer", "fighter-spawn"}
}
