return {
	Ship_Crew_Requirement = 680,
	Fighters = {
		["FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["INTERCEPTOR"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		},
	},
	FighterFlags = {"PROTEUS_OVERRIDE_RENDILI"},
	Scripts = {"multilayer", "fighter-spawn"}
}