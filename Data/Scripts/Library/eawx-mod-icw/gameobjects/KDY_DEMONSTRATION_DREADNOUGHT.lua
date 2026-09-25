return {
	Ship_Crew_Requirement = 5400,
	Fighters = {
		["ELITE_INTERCEPTOR"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["ELITE_FIGHTERBOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["HEAVY_BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Native = "IMPERIAL",
	Scripts = {"multilayer", "fighter-spawn",  "persistent-damage-tactical"}
}
