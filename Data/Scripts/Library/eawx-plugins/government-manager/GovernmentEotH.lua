require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("SetFighterResearch")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")

---@class GovernmentEotH
GovernmentEotH = class()

function GovernmentEotH:new(gc, favour_tables)
	self.EotHPlayer = Find_Player("EmpireoftheHand")
	self.EotHPlayerHuman = self.EotHPlayer.Is_Human()
	self.CurrentTarget = "NONE"
	self.CloningCost = 6000

	self.Active_Planets = StoryUtil.GetSafePlanetTable()
	self.HeroDetails = require("HeroLibrary")
	self.MenuOpen = false
	self.AllTanksUnlocked = false
	self.EraStart = GlobalValue.Get("CURRENT_ERA")

	self.SubGroupInfo = favour_tables
	self.GroupIndex = {
		["CHISS"] = 1,
		["IMPERIALS"] = 2,
		["PACCIAN"] = 3,
		["PAATAATUS"] = 4,
		["GARWIAN"] = 5,
	}

	self.AdditionalSubGroupInfo = {
		["PAATAATUS"] = {
			active_missions = 0,
			difficulty_tiers = {1, 1, 2, 2, 3, 3}
		},
		["PACCIAN"] = {
			active_missions = 0,
			difficulty_tiers = {1, 1, 2, 2, 3}
		},
		["GARWIAN"] = {
			active_missions = 0,
			difficulty_tiers = {1, 1, 2, 3, 3}
		},
		["IMPERIALS"] = {
			active_missions = 0,
			difficulty_tiers = {3, 3, 0, 0, 0}
		},
		["CHISS"] = {
			active_missions = 0,
			difficulty_tiers = {3, 3, 3}
		}
	}

	self.CloningTanks = {
		{contents = nil, sample_locked = false, clone_gestating = false, end_year = 0, end_month = 0, unlocked = false},
		{contents = nil, sample_locked = false, clone_gestating = false, end_year = 0, end_month = 0, unlocked = false},
		{contents = nil, sample_locked = false, clone_gestating = false, end_year = 0, end_month = 0, unlocked = false},
		{contents = nil, sample_locked = false, clone_gestating = false, end_year = 0, end_month = 0, unlocked = false},
		{contents = "THRAWN_CLONE_EVISCERATOR", sample_locked = true, clone_gestating = false, end_year = 0, end_month = 0, unlocked = false}
	}

	if self.EraStart >= 3 and GlobalValue.Get("STORYLINE") ~= "CAAMAS_CRISIS" then
		self.CloningTanks[5].unlocked = true
	end

	-- Remember to do all-caps
	self.AlreadyCloned = {
		"BOBA_FETT", "BOBA_FETT_TEAM",
		"JORUUS_CBAOTH", "JORUUS_CBAOTH_TEAM",
		"TH313", "TH313_TEAM",
		"DARK_APPRENTICE", "DARK_APPRENTICE_TEAM",
		"CODY", "CODY_TEAM",
		"BLY", "BLY_TEAM",
		"KLICK", "KLICK_TEAM",
		"EMPEROR_PALPATINE", "EMPEROR_PALPATINE_TEAM",
		"CARNOR_JAX", "CARNOR_JAX_TEAM",
		"GRODIN_TIERCE", "GRODIN_TIERCE_TEAM",
		"THRAWN_CLONE_EVISCERATOR"
		}

	self.ImperialHeroConverts = {
		["ROGRISS_AGONIZER"] = {unit_name = nil, joined = false},
		["THANAS_DOMINANT"] = {unit_name = nil, joined = false},
		["IILLOR_CORUSCA_RAINBOW"] = {unit_name = nil, joined = false},
		["DARRON_DIREPTION"] = {unit_name = nil, joined = false},
		["JOHANS_TEAM"] = {unit_name = "JOHANS_FIREHAWK", joined = false},
		["COVELL_AT_AT_TEAM"] = {unit_name = "COVELL_AT_AT_WALKER", joined = false},
	}

	gc.Events.GalacticHeroKilled:attach_listener(self.on_galactic_hero_killed, self)

	self.Events = {}
	self.Events.HeroJoined = Observable()
	self.Events.HeroCloned = Observable()
	self.Events.TankFilled = Observable()

	crossplot:subscribe("REWARD_GROUP_MISSION_COUNT", self.adjust_active_missions, self)
	crossplot:subscribe("EOTH_GOVT_FACTION_SELECTED", self.change_target_group, self)

	crossplot:subscribe("TANK_1_TIMER", self.cloning_finished, self)
	crossplot:subscribe("TANK_2_TIMER", self.cloning_finished, self)
	crossplot:subscribe("TANK_3_TIMER", self.cloning_finished, self)
	crossplot:subscribe("TANK_4_TIMER", self.cloning_finished, self)
	crossplot:subscribe("TANK_5_TIMER", self.cloning_finished, self)

	crossplot:subscribe("EOTH_SAVE_TISSUE", self.save_tissues, self)
	crossplot:subscribe("EOTH_CLONE_START", self.begin_cloning_check, self)

	crossplot:subscribe("THRAWN_CLONE_START", self.clone_thrawn, self)

	crossplot:subscribe("CLOSE_EOTH_MENU", self.OpenDisplay, self)

	crossplot:subscribe("UNLOCK_FEL_FAMILY", self.start_imperial_heroes, self)

	for i, tank in pairs(self.CloningTanks) do
		self:set_tank_button_state(i)
	end
	self:unlock_tanks()
end

function GovernmentEotH:update_favour(favour_tables)
	--Logger:trace("entering GovernmentEotH:Update")
	self.SubGroupInfo = favour_tables

	if self.AllTanksUnlocked == false then
		self:unlock_tanks()
	end

	if self.EotHPlayerHuman then
		self:change_target_difficulty()
	end
end

function GovernmentEotH:unlock_tanks()
	local unlocked_tanks = self.SubGroupInfo["IMPERIALS"].favour - 1

	if unlocked_tanks < 0 then
		unlocked_tanks = 0
	end

	if unlocked_tanks >= 4 then
		self.AllTanksUnlocked = true
		unlocked_tanks = 4
	end
	local i = 1
	while i <= unlocked_tanks  do
		self.CloningTanks[i].unlocked = true
		i = i + 1
	end
end

function GovernmentEotH:change_target_group(subgroup)
	self.CurrentTarget = subgroup
	self:change_target_difficulty()
end

function GovernmentEotH:adjust_active_missions(reward_group, change)
	if not self.AdditionalSubGroupInfo[reward_group] then
		return
	end

	self.AdditionalSubGroupInfo[reward_group].active_missions = self.AdditionalSubGroupInfo[reward_group].active_missions + change
	self:change_target_difficulty()
end

function GovernmentEotH:change_target_difficulty()
	local target_difficulty = 0
	if self.CurrentTarget == "NONE" then
		GlobalValue.Set("MISSION_NEXT_REWARD_GROUP", "NONE")
		GlobalValue.Set("MISSION_NEXT_DIFFICULTY", target_difficulty)
	else
		local next_level = self.SubGroupInfo[self.CurrentTarget].favour + 1 + self.AdditionalSubGroupInfo[self.CurrentTarget].active_missions

		if next_level <= self.SubGroupInfo[self.CurrentTarget].max_value then
			target_difficulty = self.AdditionalSubGroupInfo[self.CurrentTarget].difficulty_tiers[next_level]
		end
		GlobalValue.Set("MISSION_NEXT_REWARD_GROUP", self.CurrentTarget)
		GlobalValue.Set("MISSION_NEXT_DIFFICULTY", target_difficulty)
	end
end

function GovernmentEotH:start_imperial_heroes()
	--Logger:trace("entering GovernmentEotH:check_eligibility")

	if GlobalValue.Get("PROTEUS_GROUP_NAME") ~= "FEL" then
		UnitUtil.SetLockList("EMPIRE", {
        	"Soontir_Fel_181st_Location_Set",
    	}, false)
		Upgrade_Fighter_Hero("SOONTIR_FEL_181ST_SQUADRON","TURR_PHENNIR_TIE_INTERCEPTOR_181ST_SQUADRON")

    	UnitUtil.SetLockList("EMPIREOFTHEHAND", {
	        "Soontir_Fel_Gray_Location_Set"
    	})
    	Set_To_First_Extant_Host("SOONTIR_FEL_GRAY_LOCATION_SET", Find_Player("Empireofthehand"))
	end

	crossplot:publish("CHECK_ELIGIBILITY_FEL_CHILDREN")
end

function GovernmentEotH:on_galactic_hero_killed(hero_name, owner_name, killer_name)
	--Logger:trace("entering GovernmentEotH:on_galactic_hero_killed")

	if self.SubGroupInfo["IMPERIALS"].favour >= 1 then
		for hero, data in pairs(self.ImperialHeroConverts) do
			if hero_name == hero or hero_name == data.unit_name then
				if data.joined == false then

					StoryUtil.SpawnAtSafePlanet("NIRAUAN", self.EotHPlayer, self.Active_Planets, {hero})
					self.ImperialHeroConverts[hero].joined = true

					if self.EotHPlayerHuman then
						self.Events.HeroJoined:notify {
							collected_hero = hero_name
						}
					end

				end
			end
		end
	end

	if self.SubGroupInfo["IMPERIALS"].favour >= 0 then
		local already_cloned = false
		for _, cloned_hero_name in pairs(self.AlreadyCloned) do
			if cloned_hero_name == hero_name then
				already_cloned = true
			end
		end

		if already_cloned == false then
			if owner_name == "EMPIREOFTHEHAND" then
				if hero_name == "THRAWN_GREY_WOLF" then
					self:clone_thrawn()
				else
					local hero_to_store = hero_name
					for entry_name, details in pairs(self.HeroDetails) do
						if details.Type == "HeroCompany" then
							if entry_name == hero_name then
								break
							end
							if details.Company_Units then
								for _,company_unit in pairs(details.Company_Units) do
									if company_unit == hero_name then
										hero_to_store = entry_name
										break
									end
								end
							end
						end
					end

					self:check_tank_contents(hero_to_store)
				end
			elseif killer_name == "EMPIREOFTHEHAND" then
				for entry_name, details in pairs(self.HeroDetails) do
					if details.Type == "HeroCompany" then
						if entry_name == hero_name then
							self:check_hero_type_and_store(entry_name)
							break
						end
						if details.Company_Units then
							for _,company_unit in pairs(details.Company_Units) do
								if company_unit == hero_name then
									self:check_hero_type_and_store(entry_name)
									break
								end
							end
						end
					end
				end
			end
		end
	end

	if hero_name == "FEL_EVISCERATOR" then
		UnitUtil.SetLockList("EMPIREOFTHEHAND", {
	        "Soontir_Fel_Gray_Location_Set"
    	})
    	Set_To_First_Extant_Host("SOONTIR_FEL_GRAY_LOCATION_SET", Find_Player("Empireofthehand"))
	end
end

function GovernmentEotH:check_hero_type_and_store(hero_name)
	if not self.HeroDetails[hero_name] then
		return
	end

	if not self.HeroDetails[hero_name].Company_Units then
		return
	end

	for company_unit,params in pairs(self.HeroDetails[hero_name].Company_Units) do
		for _, category in pairs(params.CategoryMask) do
			if category == "INFANTRYHERO" then
				self:check_tank_contents(hero_name)
				break
			end
		end
	end
end

function GovernmentEotH:check_tank_contents(tank_contents)
	--Logger:trace("entering GovernmentEotH:check_tank_contents")
	for tank_number, tank in pairs(self.CloningTanks) do
		if tank.contents == tank_contents then
			return
		end
	end
	
	for tank_number, tank in pairs(self.CloningTanks) do
		if tank.contents == nil and tank.unlocked then
			self:fill_tank(tank_contents, tank_number)
			return
		end
	end
	-- Only replace unlocked samples if all are filled
	for tank_number, tank in pairs(self.CloningTanks) do
		if tank.sample_locked == false and tank.unlocked then
			self:fill_tank(tank_contents, tank_number)
			return
		end
	end
end

function GovernmentEotH:fill_tank(tank_contents, tank_number)
	self.CloningTanks[tank_number].contents = tank_contents
	table.insert(self.AlreadyCloned, tank_contents)

	if self.EotHPlayerHuman then
		self.Events.TankFilled:notify {
			tissue_saved = tank_contents
		}
	else
 		self:begin_cloning_check(tank_number)
	end

	self:set_tank_button_state(tank_number)
end

function GovernmentEotH:save_tissues(tank_number)
	if self.CloningTanks[tank_number].sample_locked == false then
		self.CloningTanks[tank_number].sample_locked = true
		self:set_tank_button_state(tank_number)
	end
end

function GovernmentEotH:clone_thrawn()
	if self.CloningTanks[5].contents == "THRAWN_CLONE_EVISCERATOR" and self.CloningTanks[1].clone_gestating == false then
		self.CloningTanks[5].unlocked = true
		self:cloning_function(5)
	end
end

function GovernmentEotH:begin_cloning_check(tank_number)
	if self.CloningTanks[tank_number].clone_gestating ~= false or not self.CloningTanks[tank_number].contents then
		return
	end

	if self.EotHPlayerHuman == true then
		if self.EotHPlayer.Get_Credits() >= self.CloningCost then
			self.EotHPlayer.Give_Money(-1 * self.CloningCost)

			self:cloning_function(tank_number)

		else

			local plot = StoryUtil.GetButtonHandlerPlot()

			local force_click_button_event = plot.Get_Event("FORCE_CLICK_BUTTON")

			StoryUtil.ShowScreenText("Insufficient credits to start cloning. Requires $" .. tostring(self.CloningCost), 10)
			force_click_button_event.Set_Reward_Parameter(0, "EOTH_Clone_"..tostring(tank_number).."_3_Reset")
			Story_Event("FORCE_CLICK_BUTTON_EVENT")

		end
	else

		-- AI clone whether they can afford it or not, just take their money.
		self.EotHPlayer.Give_Money(-1 * self.CloningCost)
		self:cloning_function(tank_number)
	end
end

function GovernmentEotH:cloning_function(tank_number)
	local years = 0
	local months = 6
	local end_year = 0
	local end_month = 0

	local current_year = GlobalValue.Get("GALACTIC_YEAR")
	local current_month = GlobalValue.Get("GALACTIC_MONTH")

	end_year = current_year + years
	if current_month + months <= 12 then
		end_month = current_month + months
	else
		end_month = current_month + months - 12
		end_year = end_year + 1
	end

	self.CloningTanks[tank_number].sample_locked = true
	self.CloningTanks[tank_number].clone_gestating = true
	self.CloningTanks[tank_number].end_month = end_month
	self.CloningTanks[tank_number].end_year = end_year

	self:set_tank_button_state(tank_number)

	crossplot:publish("REGISTER_DATE_TIMER", "TANK_"..tostring(tank_number).."_TIMER", years, months, "The clone will be available in ", "EMPIREOFTHEHAND", {tank_number})

	if self.EotHPlayerHuman then
		self.Events.TankFilled:notify {
			tissue_saved = self.CloningTanks[tank_number].contents
		}
	end
end

function GovernmentEotH:set_tank_button_state(tank_number)
	if not self.EotHPlayerHuman then
		return
	end

	local tank = self.CloningTanks[tank_number]

	local plot = StoryUtil.GetButtonHandlerPlot()

	local force_click_button_event = plot.Get_Event("FORCE_CLICK_BUTTON")
	local disable_button_event = plot.Get_Event("DISABLE_BUTTON")
	local enable_button_event = plot.Get_Event("ENABLE_BUTTON")

	enable_button_event.Set_Reward_Parameter(1, "EOTH_Clone_"..tostring(tank_number).."_2")
	Story_Event("ENABLE_BUTTON_EVENT")
	enable_button_event.Set_Reward_Parameter(1, "EOTH_Clone_"..tostring(tank_number).."_3")
	Story_Event("ENABLE_BUTTON_EVENT")

		if tank.contents then
			local tag = self.HeroDetails[tank.contents].Text_ID
			GUI_Component_Text("special_button_".. tostring(tank_number+25), tag)
			GUI_Button_Icon("special_button_".. tostring(tank_number+25), self.HeroDetails[tank.contents].Icon_Name, 1, 1, 1, 1)
			if tank.sample_locked == true then

				force_click_button_event.Set_Reward_Parameter(0, "EOTH_Clone_"..tostring(tank_number).."_2")
				Story_Event("FORCE_CLICK_BUTTON_EVENT")
				disable_button_event.Set_Reward_Parameter(1, "EOTH_Clone_"..tostring(tank_number).."_2")
				Story_Event("DISABLE_BUTTON_EVENT")

				if tank.clone_gestating == true then
					tag = tag .. " : Ready " .. tostring(tank.end_year) ..":"  .. tostring(tank.end_month) .. " ABY"
					GUI_Component_Text("special_button_".. tostring(tank_number+25), tag)

					force_click_button_event.Set_Reward_Parameter(0, "EOTH_Clone_"..tostring(tank_number).."_3")
					Story_Event("FORCE_CLICK_BUTTON_EVENT")
					disable_button_event.Set_Reward_Parameter(1, "EOTH_Clone_"..tostring(tank_number).."_3")
					Story_Event("DISABLE_BUTTON_EVENT")

				elseif tank.contents == "THRAWN_CLONE_EVISCERATOR" and tank.unlocked == false then

					disable_button_event.Set_Reward_Parameter(1, "EOTH_Clone_"..tostring(tank_number).."_3")
					Story_Event("DISABLE_BUTTON_EVENT")

					tag = "Cloning begins after Thrawn leaves/dies."
					if GlobalValue.Get("STORYLINE") == "CAAMAS_CRISIS" then
						tag = "Ready 20:6 ABY"
					end
					GUI_Component_Text("special_button_".. tostring(tank_number+25), tag)

				end
			else

				force_click_button_event.Set_Reward_Parameter(0, "EOTH_Clone_"..tostring(tank_number).."_2_Reset")
				Story_Event("FORCE_CLICK_BUTTON_EVENT")
				force_click_button_event.Set_Reward_Parameter(0, "EOTH_Clone_"..tostring(tank_number).."_3_Reset")
				Story_Event("FORCE_CLICK_BUTTON_EVENT")

			end

		else

			if tank.unlocked then

				GUI_Component_Text("special_button_".. tostring(tank_number+25), "Empty Tank")
				GUI_Button_Icon("special_button_".. tostring(tank_number+25), "i_button_bacta_tank.tga", 1, 1, 1, 1)

			else
				GUI_Component_Text("special_button_".. tostring(tank_number+25), "Unlock with Imperial missions")
				GUI_Button_Icon("special_button_".. tostring(tank_number+25), "i_button_locked.tga", 1, 1, 1, 1)

			end

				force_click_button_event.Set_Reward_Parameter(0, "EOTH_Clone_"..tostring(tank_number).."_2_Reset")
				Story_Event("FORCE_CLICK_BUTTON_EVENT")
				force_click_button_event.Set_Reward_Parameter(0, "EOTH_Clone_"..tostring(tank_number).."_3_Reset")
				Story_Event("FORCE_CLICK_BUTTON_EVENT")

				disable_button_event.Set_Reward_Parameter(1, "EOTH_Clone_"..tostring(tank_number).."_2")
				Story_Event("DISABLE_BUTTON_EVENT")
				disable_button_event.Set_Reward_Parameter(1, "EOTH_Clone_"..tostring(tank_number).."_3")
				Story_Event("DISABLE_BUTTON_EVENT")
		end
end

function GovernmentEotH:cloning_finished(tank_number)
	--Logger:trace("entering GovernmentEotH:cloning_finished")

	StoryUtil.SpawnAtSafePlanet("NIRAUAN", self.EotHPlayer, self.Active_Planets, {self.CloningTanks[tank_number].contents})

	if self.EotHPlayerHuman then
		self.Events.HeroCloned:notify {
			cloned_hero = self.CloningTanks[tank_number].contents
		}
	end

	self.CloningTanks[tank_number] = {contents = nil, sample_locked = false, clone_gestating = false, end_year = 0, end_month = 0, unlocked = true}
end

function GovernmentEotH:OpenDisplay()
	--Logger:trace("entering GovernmentEotH:UpdateDisplay")

	if self.MenuOpen ~= false then
		self.MenuOpen = false
		StoryUtil.Disable_and_Hide_Button("special_button_25")
		return
	end

	self.MenuOpen = true

	local plot = StoryUtil.GetButtonHandlerPlot()

	StoryUtil.Enable_and_Visible_Button("special_button_25", 0, 0)
	local force_click_button_event = plot.Get_Event("FORCE_CLICK_BUTTON")
	local disable_button_event = plot.Get_Event("DISABLE_BUTTON")
	local enable_button_event = plot.Get_Event("ENABLE_BUTTON")


	for group, data in pairs(self.SubGroupInfo) do
		local i = 0
		while i <= data.favour do
			force_click_button_event.Set_Reward_Parameter(0, "Ally_Bubble_"..self.GroupIndex[group].."_"..tostring(i))
			Story_Event("FORCE_CLICK_BUTTON_EVENT")

			i = i + 1
		end
		while i <= data.max_value do

			force_click_button_event.Set_Reward_Parameter(0, "Ally_Bubble_"..self.GroupIndex[group].."_"..tostring(i).."_Off")
			Story_Event("FORCE_CLICK_BUTTON_EVENT")

			i = i + 1
		end

	end

	for i, tank in pairs(self.CloningTanks) do
		self:set_tank_button_state(i)
	end
end

return GovernmentEotH
