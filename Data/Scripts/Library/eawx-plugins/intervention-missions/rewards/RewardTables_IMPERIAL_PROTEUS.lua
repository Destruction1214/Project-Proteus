function Get_RewardTable()
	local Proteus_RewardTables = require("eawx-plugins/intervention-missions/rewards/proteus-reward-tables/IMPERIAL_PROTEUS")
	if GlobalValue.Get("CUSTOM_PROTEUS_REWARDS") ~= nil then
		local ProteusGroup = GlobalValue.Get("PROTEUS_GROUP_NAME")
		Proteus_RewardTables = require("eawx-plugins/intervention-missions/rewards/proteus-reward-tables/"..ProteusGroup)
	end

	return Proteus_RewardTables
end

return Get_RewardTable()