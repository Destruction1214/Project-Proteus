return {
	Ship_Crew_Requirement = 770,
	Fighters = {
		["INTERCEPTOR_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["HEAVY_BOMBER_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		},
		["BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BLASTBOAT_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}
	},
	Native = "IMPERIAL",
	FighterFlags = {"PUNISHERS"},
	Scripts = {"multilayer", "fighter-spawn"}
}