return {
	Ship_Crew_Requirement = 84,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 1, HeroOverride = {{"PANAKA_THEED"}, {"N1_SQUADRON"}}}
		},
		["HEAVY_FIGHTER_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		},
		["BOMBER2"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		}
	},
	FighterFlags = {"PROTEUS_OVERRIDE_RENDILI"},
	Native = "IMPERIAL",
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}
