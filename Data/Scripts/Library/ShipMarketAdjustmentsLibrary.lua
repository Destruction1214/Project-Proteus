return {
		--["EVEN_NAME"] = {
		--	lock_lists = {
		--		{"IMPERIAL_PROTEUS", "SHIP_MARKET", "UNIT_NAME", state}, -- state: false to unlock, true to lock 
		--	},
		--	requirement_lists = {
		--		{"IMPERIAL_PROTEUS", "SHIP_MARKET", "UNIT_NAME", ""}, -- Description; "" = None
		--	},
		--	adjustment_lists = {
		--		{"IMPERIAL_PROTEUS", "SHIP_MARKET", "UNIT_NAME", X}, -- X can be positive and negative integer; adding optional ', true' after X sets X as new chance
		--	}
		--},
		["DRAGON"] = {
			lock_lists = {
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "DRAGON_HEAVY_CRUISER", false},
			},
			requirement_lists = {
				{"IMPERIAL_PROTEUS", "SHIP_MARKET", "DRAGON_HEAVY_CRUISER", ""},
			},
		},
}
