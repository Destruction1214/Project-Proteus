require("deepcore/std/class")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")

---@class DummyBuildExtras
DummyBuildExtras = class()

function DummyBuildExtras:new(gc)
	self.p_newrep = Find_Player("Rebel")
	self.p_eriadu = Find_Player("Eriadu_Authority")
	self.p_pentastar = Find_Player("Pentastar")
	self.p_proteus = Find_Player("Imperial_Proteus")
	self.p_human = Find_Player("local")

	crossplot:subscribe("ERRANT_VENTURE_UPGRADE", self.prompt_errant_venture_upgrade, self)

	self.production_finished_event = gc.Events.GalacticProductionFinished
	self.production_finished_event:attach_listener(self.on_production_finished, self)
end

function DummyBuildExtras:prompt_errant_venture_upgrade()
	--Logger:trace("entering DummyBuildExtras:prompt_errant_venture_upgrade")
	if not TestValid(Find_First_Object("Booster_Errant_Venture")) then
		crossplot:unsubscribe("ERRANT_VENTURE_UPGRADE", self.prompt_errant_venture_upgrade, self)
		return
	end

	if self.p_newrep == self.p_human then
		StoryUtil.Multimedia("TEXT_EVENT_ERRANT_VENTURE_UPGRADE", 15, nil, "Karrde_Loop", 0)
		Story_Event("ERRANT_VENTURE_STARTED")
	end

	self.p_newrep.Unlock_Tech(Find_Object_Type("Booster_Errant_Venture_Red_Upgrade"))
end

function DummyBuildExtras:on_production_finished(planet, object_type_name)
	--Logger:trace("entering DummyBuildExtras:on_production_finished")
	if object_type_name == "Booster_Errant_Venture_Red_Upgrade" then
		Story_Event("ERRANT_VENTURE_COMPLETED")
		crossplot:unsubscribe("ERRANT_VENTURE_UPGRADE", self.prompt_errant_venture_upgrade, self)
	--Lock the other options for leader SSDs when one is taken
	elseif object_type_name == "KAINE_REAPER_DUMMY" then
		self.p_pentastar.Lock_Tech(Find_Object_Type("PELLAEON_REAPER_DUMMY"))
	elseif object_type_name == "PELLAEON_REAPER_DUMMY" then 
		--Technically we only need to do this if the builder is PA; if they're not, PA is dead and it doesn't hurt.
		self.p_pentastar.Lock_Tech(Find_Object_Type("KAINE_REAPER_DUMMY"))
	elseif object_type_name == "DAALA_KNIGHT_HAMMER_DUMMY" then
		self.p_eriadu.Lock_Tech(Find_Object_Type("DELVARDUS_THALASSA_NIGHT_HAMMER_DUMMY"))
		self.p_eriadu.Lock_Tech(Find_Object_Type("DELVARDUS_BRILLIANT_NIGHT_HAMMER_DUMMY"))
	elseif object_type_name == "DELVARDUS_THALASSA_NIGHT_HAMMER_DUMMY" or object_type_name == "DELVARDUS_BRILLIANT_NIGHT_HAMMER_DUMMY" then
		self.p_eriadu.Lock_Tech(Find_Object_Type("DAALA_KNIGHT_HAMMER_DUMMY"))
	elseif object_type_name == "HARRSK_MEGADOR_DUMMY_1" or object_type_name == "HARRSK_MEGADOR_DUMMY_2" then
		self.p_proteus.Lock_Tech(Find_Object_Type("PELLAEON_MEGADOR_DUMMY"))
	elseif object_type_name == "PELLAEON_MEGADOR_DUMMY" then
		self.p_proteus.Lock_Tech(Find_Object_Type("HARRSK_MEGADOR_DUMMY_1"))
		self.p_proteus.Lock_Tech(Find_Object_Type("HARRSK_MEGADOR_DUMMY_2"))
	elseif object_type_name == "ROGRISS_DOMINION_DUMMY" or object_type_name == "ROGRISS_DOMINION_DUMMY2" then
		self.p_proteus.Lock_Tech(Find_Object_Type("DESANNE_DOMINION_DUMMY"))
	elseif object_type_name == "DESANNE_DOMINION_DUMMY" then
		self.p_proteus.Lock_Tech(Find_Object_Type("ROGRISS_DOMINION_DUMMY"))
		self.p_proteus.Lock_Tech(Find_Object_Type("ROGRISS_DOMINION_DUMMY2"))
	end
end

return DummyBuildExtras
