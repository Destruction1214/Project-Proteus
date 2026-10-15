return {
	Ship_Crew_Requirement = 680,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		},
		["FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 1},
		}
	},
	Native = "CORPORATE_SECTOR",
	FighterFlags = {"PROTEUS_OVERRIDE_RENDILI"},
	Scripts = {"multilayer", "fighter-spawn"}
}