ModContentLoader = {}
ModContentLoader.mods = {
	"rev",
	"fotr",
	"icw"
}

ModContentLoader.mod_id = nil

function ModContentLoader.get_mod_id()
	if ModContentLoader.mod_id then
		return ModContentLoader.mod_id
	end

	local mod_id_dummy
	for _, mod_id in ipairs(ModContentLoader.mods) do
		mod_id_dummy = Find_Object_Type(mod_id)
		if mod_id_dummy then
			ModContentLoader.mod_id = mod_id
			break
		end
	end

	return ModContentLoader.mod_id
end

function ModContentLoader.get(script)
	return require(ModContentLoader.get_mod_specific_path() .. "/" .. script)
end

function ModContentLoader.get_space_object_script(game_object_type_name, company)
	local folder_string = "/gameobjects/"

	local Units = require("GameObjectList")
	local is_patron = false
	local object = nil
	if string.find(string.upper(game_object_type_name), "PATRON")  then
		is_patron = true
	end
	if Units[game_object_type_name] == true or is_patron then
		object = require(ModContentLoader.get_mod_specific_path() .. folder_string .. game_object_type_name)
		object.Source_Unit_Name = game_object_type_name
		if object.Flags then
			if object.Flags.FULLINHERIT ~= nil then
				if Units[object.Flags.FULLINHERIT] == true then
					local parent_name = object.Flags.FULLINHERIT
					object = ModContentLoader.get_space_object_script(object.Flags.FULLINHERIT, company)
					object.Source_Unit_Name = parent_name
				end
			elseif object.Flags.FIGHTERLESSINHERIT ~= nil then
				local storage = object.Spawn_Units
				local storage2 = object.FighterFlags
				local storage3 = object.Native
				local storage4 = object.Fighters
				if Units[object.Flags.FIGHTERLESSINHERIT] == true then
					object = ModContentLoader.get_space_object_script(object.Flags.FIGHTERLESSINHERIT, company)
				end
				object.Spawn_Units = storage
				object.FighterFlags = storage2
				object.Native = storage3
				object.Fighters = storage4
			end
		end
		return object
	else
		return nil
	end
end

function ModContentLoader.get_ground_company_object_script(game_object_type_name)
	local folder_string = "/gameobjects/ground/company-objects/"

    local GroundCompanies = require("GroundCompanyList")
	local object = nil
	if GroundCompanies[game_object_type_name] == true then
		object = require(ModContentLoader.get_mod_specific_path() .. folder_string .. game_object_type_name)
		if object.Flags then
			if object.Flags.FULLINHERIT ~= nil then
				if GroundCompanies[object.Flags.FULLINHERIT] == true then
					object = ModContentLoader.get_ground_company_object_script(object.Flags.FULLINHERIT)
				end
			end
		end
		return object
	else
		return nil
	end
end

function ModContentLoader.get_ground_war_object_script(game_object_type_name)
	local folder_string = "/gameobjects/ground/gw/"

	GroundWarObjectList = require("GroundWarList")
	local object = nil
	if GroundWarObjectList[game_object_type_name] == true then
		object = require(ModContentLoader.get_mod_specific_path() .. folder_string .. game_object_type_name)
		if object.Flags then
			if object.Flags.FULLINHERIT ~= nil then
				if GroundWarObjectList[object.Flags.FULLINHERIT] == true then
					object = ModContentLoader.get_ground_war_object_script(object.Flags.FULLINHERIT)
				end
			end
		end
		return object
	else
		return nil
	end
end

function ModContentLoader.get_ground_unit_object_script(game_object_type_name)
	local folder_string = "/gameobjects/ground/"

	local IndividualGroundUnits = require("GroundUnitList")
	local object = nil
	if IndividualGroundUnits[game_object_type_name] == true then
		object = require(ModContentLoader.get_mod_specific_path() .. folder_string .. game_object_type_name)
		if object.Flags then
			if object.Flags.FULLINHERIT ~= nil then
				if IndividualGroundUnits[object.Flags.FULLINHERIT] == true then
					object = ModContentLoader.get_ground_unit_object_script(object.Flags.FULLINHERIT)
				end
			end
		end
		return object
	else
		return nil
	end
end

function ModContentLoader.get_ground_structure_object_script(game_object_type_name)
	local folder_string = "/gameobjects/building-objects/"

 	local GroundStructures = require("GroundStructureList")
	local object = nil
	if GroundStructures[game_object_type_name] == true then
		object = require(ModContentLoader.get_mod_specific_path() .. folder_string .. game_object_type_name)
		if object.Flags then
			if object.Flags.FULLINHERIT ~= nil then
				if GroundStructures[object.Flags.FULLINHERIT] == true then
					object = ModContentLoader.get_ground_structure_object_script(object.Flags.FULLINHERIT)
				end
			end
		end
		return object
	else
		return nil
	end
end

function ModContentLoader.get_mod_specific_path()
	if not ModContentLoader.mod_id then
		ModContentLoader.mod_id = GlobalValue.Get("MOD_ID")
	end

	local lower_mod_id = string.lower(ModContentLoader.mod_id)
	return "eawx-mod-" .. lower_mod_id
end

return ModContentLoader
