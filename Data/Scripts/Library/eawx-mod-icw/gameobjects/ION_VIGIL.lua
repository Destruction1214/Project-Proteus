return {
	Ship_Crew_Requirement = 31,
	Fighters = {
		["INTERCEPTOR_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1, HeroOverride = {{"PANAKA_THEED"}, {"N1_SQUADRON_HALF"}}}
		}
	},
	Native = "IMPERIAL",
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"},
	Flags = {HANGAR = true}
}