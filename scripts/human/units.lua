--       _________ __                 __
--      /   _____//  |_____________ _/  |______     ____  __ __  ______
--      \_____  \\   __\_  __ \__  \\   __\__  \   / ___\|  |  \/  ___/
--      /        \|  |  |  | \// __ \|  |  / __ \_/ /_/  >  |  /\___ \ 
--     /_______  /|__|  |__|  (____  /__| (____  /\___  /|____//____  >
--             \/                  \/          \//_____/            \/ 
--  ______________________                           ______________________
--                        T H E   W A R   B E G I N S
--         Stratagus - A free fantasy real time strategy game engine
--
--      units.lua - Define the used human unit-types.
--
--      (c) Copyright 2001-2004 by Lutz Sammer and Jimmy Salmon
--
--      This program is free software; you can redistribute it and/or modify
--      it under the terms of the GNU General Public License as published by
--      the Free Software Foundation; either version 2 of the License, or
--      (at your option) any later version.
--  
--      This program is distributed in the hope that it will be useful,
--      but WITHOUT ANY WARRANTY; without even the implied warranty of
--      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--      GNU General Public License for more details.
--  
--      You should have received a copy of the GNU General Public License
--      along with this program; if not, write to the Free Software
--      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--
--      $Id$

--=============================================================================
--	Define unit-types.
--
--	NOTE: Save can generate this table.
--

DefineUnitType("unit-footman", { Name = "Footman",
  Files = {"tileset-forest", "human/units/footman.png"},
  Size = {96, 96},
  Animations = "animations-footman", Icon = "icon-footman",
  Costs = {"time", 60, "gold", 600},
  Speed = 10,
  HitPoints = 60,
  DrawLevel = 40,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 4, ComputerReactionRange = 6, PersonReactionRange = 4,
  Armor = 2, BasicDamage = 6, PiercingDamage = 3, Missile = "missile-none",
  MaxAttackRange = 1,
  Priority = 60,
  Points = 50,
  Demand = 1,
  Corpse = {"unit-dead-body", 6},
  Type = "land",
  RightMouseAction = "attack",
  CanAttack = true,
  CanTargetLand = true,
  LandUnit = true,
  organic = true,
  SelectableByRectangle = true,
  Sounds = {
    "selected", "human selected",
    "acknowledge", "human acknowledge",
    "ready", "human ready",
    "help", "human help 3",
    "dead", "human dead",
    "attack", "footman-attack"} } )

DefineUnitType("unit-peasant", { Name = "Peasant",
  Files = {"tileset-forest", "human/units/peasant.png"},
  Size = {64, 64},
  Animations = "animations-peasant", Icon = "icon-peasant",
  Costs = {"time", 45, "gold", 400},
  Speed = 10,
  HitPoints = 30,
  DrawLevel = 40,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 4, ComputerReactionRange = 6, PersonReactionRange = 4,
  BasicDamage = 3, PiercingDamage = 2, Missile = "missile-none",
  MaxAttackRange = 1,
  Priority = 50,
  Points = 30,
  Demand = 1,
  Corpse = {"unit-dead-body", 6},
  Type = "land",
  RightMouseAction = "harvest",
  RepairRange = 1,
  CanTargetLand = true,
  LandUnit = true,
  Coward = true,
  CanGatherResources = {
   {"file-when-loaded", "human/units/peasant_with_gold.png",
    "resource-id", "gold",
--    "harvest-from-outside",
    "resource-capacity", 100,
    "wait-at-resource", 150,
    "wait-at-depot", 150},
   {"file-when-loaded", "human/units/peasant_with_wood.png",
    "resource-id", "wood",
    "resource-capacity", 100,
    "resource-step", 2,
    "wait-at-resource", 24,
    "wait-at-depot", 150,
    "lose-resources",
    "terrain-harvester"}},
  organic = true,
  SelectableByRectangle = true,
  Sounds = {
    "selected", "human selected",
    "acknowledge", "human acknowledge",
    "ready", "human ready",
--    "repair", "peasant-attack",
    "harvest", "wood", "tree chopping",
    "help", "human help 3",
    "dead", "human dead",
    "attack", "peasant-attack"} } )

DefineUnitType("unit-human-catapult", { Name = "Human Catapult",
  Files = {"tileset-forest", "human/units/catapult.png"},
  Size = {64, 64},
  Animations = "animations-catapult", Icon = "icon-catapult",
  Costs = {"time", 250, "gold", 900, "wood", 300},
  Speed = 5,
  HitPoints = 110,
  DrawLevel = 40,
  TileSize = {1, 1}, BoxSize = {63, 63},
  SightRange = 9, ComputerReactionRange = 11, PersonReactionRange = 9,
  BasicDamage = 80, PiercingDamage = 0, Missile = "missile-catapult-projectile",
  MinAttackRange = 2, MaxAttackRange = 8,
  Priority = 70,
  Points = 100,
  Demand = 1,
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  RightMouseAction = "attack",
  CanGroundAttack = true,
  CanAttack = true,
  CanTargetLand = true, CanTargetSea = true,
  SelectableByRectangle = true,
  Sounds = {
    "selected", "human selected",
    "acknowledge", "human acknowledge",
    "ready", "human ready",
    "help", "human help 3",
    "dead", "explosion",
    "attack", "human-catapult-attack"} } )

DefineUnitType("unit-knight", { Name = "Knight",
  Files = {"tileset-forest", "human/units/knight.png"},
  Size = {64, 64},
  Animations = "animations-knight", Icon = "icon-knight",
  Costs = {"time", 90, "gold", 800, "wood", 100},
  Speed = 13,
  HitPoints = 90,
  DrawLevel = 40,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 4, ComputerReactionRange = 6, PersonReactionRange = 4,
  Armor = 4, BasicDamage = 8, PiercingDamage = 4, Missile = "missile-none",
  MaxAttackRange = 1,
  Priority = 63,
  Points = 100,
  Demand = 1,
  Corpse = {"unit-dead-body", 6},
  Type = "land",
  RightMouseAction = "attack",
  CanAttack = true,
  CanTargetLand = true,
  LandUnit = true,
  organic = true,
  SelectableByRectangle = true,
  Sounds = {
    "selected", "human selected",
    "acknowledge", "human acknowledge",
    "ready", "human ready",
    "help", "human help 3",
    "dead", "human dead",
    "attack", "knight-attack"} } )

DefineUnitType("unit-archer", { Name = "Archer",
  Files = {"tileset-forest", "human/units/archer.png"},
  Size = {64, 64},
  Animations = "animations-archer", Icon = "icon-archer",
  Costs = {"time", 70, "gold", 500, "wood", 50},
  Speed = 10,
  HitPoints = 40,
  DrawLevel = 40,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 5, ComputerReactionRange = 7, PersonReactionRange = 5,
  BasicDamage = 3, PiercingDamage = 6, Missile = "missile-arrow",
  MaxAttackRange = 4,
  Priority = 55,
  Points = 60,
  Demand = 1,
  Corpse = {"unit-dead-body", 6},
  Type = "land",
  RightMouseAction = "attack",
  CanAttack = true,
  CanTargetLand = true, CanTargetSea = true, CanTargetAir = true,
  LandUnit = true,
  organic = true,
  SelectableByRectangle = true,
  Sounds = {
    "selected", "human selected",
    "acknowledge", "human acknowledge",
    "ready", "human ready",
    "help", "human help 3",
    "dead", "human dead",
    "attack", "archer-attack"} } )

DefineUnitType("unit-cleric", { Name = "Cleric",
  Files = {"tileset-forest", "human/units/cleric.png"},
  Size = {64, 64},
  Animations = "animations-cleric", Icon = "icon-cleric",
  Costs = {"time", 90, "gold", 800, "wood", 100},
  Speed = 13,
  HitPoints = 90,
  DrawLevel = 40,
  MaxMana = 255,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 4, ComputerReactionRange = 6, PersonReactionRange = 4,
  BasicDamage = 4, PiercingDamage = 8, Missile = "missile-none",
  MaxAttackRange = 1,
  Priority = 63,
  Points = 100,
  Demand = 1,
  Corpse = {"unit-dead-body", 6},
  Type = "land",
  RightMouseAction = "attack",
  CanAttack = true,
  CanTargetLand = true,
  CanCastSpell = {
    "spell-fireball",
    "spell-slow",
    "spell-flame-shield",
    "spell-invisibility",
    "spell-polymorph",
    "spell-blizzard"},
  LandUnit = true,
  organic = true,
  SelectableByRectangle = true,
  Sounds = {
    "selected", "human selected",
    "acknowledge", "human acknowledge",
    "ready", "human ready",
    "help", "human help 3",
    "dead", "human dead",
    "attack", "cleric-attack"} } )

DefineUnitType("unit-conjurer", { Name = "Conjurer",
  Files = {"tileset-forest", "human/units/conjurer.png"},
  Size = {64, 64},
  Animations = "animations-conjurer", Icon = "icon-conjurer",
  Costs = {"time", 120, "gold", 1200},
  Speed = 8,
  HitPoints = 60,
  DrawLevel = 40,
  MaxMana = 255,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 9, ComputerReactionRange = 11, PersonReactionRange = 9,
  BasicDamage = 0, PiercingDamage = 9, Missile = "missile-lightning",
  MaxAttackRange = 2,
  Priority = 70,
  Points = 100,
  Demand = 1,
  Type = "land",
  RightMouseAction = "attack",
  CanAttack = true,
  CanTargetLand = true, CanTargetSea = true, CanTargetAir = true,
  CanCastSpell = {
    "spell-fireball",
    "spell-slow",
    "spell-flame-shield",
    "spell-invisibility",
    "spell-polymorph",
    "spell-blizzard"},
  LandUnit = true,
  Coward = true,
  organic = true,
  SelectableByRectangle = true,
  Sounds = {
    "selected", "human selected",
    "acknowledge", "human acknowledge",
    "ready", "human ready",
    "help", "human help 3",
    "dead", "human dead",
    "attack", "conjurer-attack"} } )

DefineUnitType("unit-midevh", { Name = "Midevh",
  Files = {"tileset-forest", "human/units/midevh.png"},
  Size = {64, 64},
  Animations = "animations-midevh", Icon = "icon-midevh",
  Costs = {"time", 90, "gold", 800, "wood", 100},
  Speed = 13,
  HitPoints = 90,
  DrawLevel = 40,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 4, ComputerReactionRange = 6, PersonReactionRange = 4,
  Armor = 4, BasicDamage = 8, PiercingDamage = 4, Missile = "missile-none",
  MaxAttackRange = 1,
  Priority = 63,
  Points = 100,
  Demand = 1,
  Corpse = {"unit-dead-body", 6},
  Type = "land",
  RightMouseAction = "attack",
  CanAttack = true,
  CanTargetLand = true,
  LandUnit = true,
  organic = true,
  SelectableByRectangle = true,
  Sounds = {
    "selected", "human selected",
    "acknowledge", "human acknowledge",
    "ready", "human ready",
    "help", "human help 3",
    "dead", "human dead",
    "attack", "midevh-attack"} } )

DefineUnitType("unit-human-farm", { Name = "Human Farm",
  Files = {"tileset-forest", "tilesets/summer/human/buildings/farm.png",
    "tileset-swamp", "tilesets/swamp/human/buildings/farm.png"},
  Size = {96, 96},
  Animations = "animations-building", Icon = "icon-human-farm",
  Costs = {"time", 100, "gold", 500, "wood", 250},
  RepairHp = 4,
  RepairCosts = {"gold", 1, "wood", 1},
  Construction = "construction-human-farm",
  Speed = 0,
  HitPoints = 400,
  DrawLevel = 20,
  TileSize = {2, 2}, BoxSize = {63, 63},
  SightRange = 3,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 20, AnnoyComputerFactor = 45,
  Points = 100,
  Supply = 4,
  Corpse = {"unit-destroyed-2x2-place", 0},
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  Building = true, VisibleUnderFog = true, 
  Sounds = {
    "selected", "human-farm-selected",
    "acknowledge", "human-farm-acknowledge",
    "ready", "human-farm-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-farm-attack"} } )

DefineUnitType("unit-human-barracks", { Name = "Human Barracks",
  Files = {"tileset-forest", "tilesets/summer/human/buildings/barracks.png",
    "tileset-swamp", "tilesets/swamp/human/buildings/barracks.png"},
  Size = {128, 128},
  Animations = "animations-building", Icon = "icon-human-barracks",
  Costs = {"time", 200, "gold", 700, "wood", 450},
  RepairHp = 4,
  RepairCosts = {"gold", 1, "wood", 1},
  Construction = "construction-human-barracks",
  Speed = 0,
  HitPoints = 800,
  DrawLevel = 20,
  TileSize = {3, 3}, BoxSize = {95, 95},
  SightRange = 3,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 30, AnnoyComputerFactor = 35,
  Points = 160,
  Corpse = {"unit-destroyed-3x3-place", 0},
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  Building = true, VisibleUnderFog = true, 
  Sounds = {
    "selected", "human-barracks-selected",
    "acknowledge", "human-barracks-acknowledge",
    "ready", "human-barracks-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-barracks-attack"} } )

DefineUnitType("unit-human-church", { Name = "Human Church",
  Files = {"tileset-forest", "tilesets/summer/human/buildings/church.png",
    "tileset-swamp", "tilesets/swamp/human/buildings/church.png"},
  Size = {128, 128},
  Animations = "animations-building", Icon = "icon-human-church",
  Costs = {"time", 175, "gold", 900, "wood", 500},
  RepairHp = 4,
  RepairCosts = {"gold", 1, "wood", 1},
  Construction = "construction-human-church",
  Speed = 0,
  HitPoints = 700,
  DrawLevel = 20,
  TileSize = {3, 3}, BoxSize = {95, 95},
  SightRange = 3,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 15, AnnoyComputerFactor = 35,
  Points = 240,
  Corpse = {"unit-destroyed-3x3-place", 0},
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  Building = true, VisibleUnderFog = true, 
  Sounds = {
    "selected", "human-church-selected",
    "acknowledge", "human-church-acknowledge",
    "ready", "human-church-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-church-attack"} } )

DefineUnitType("unit-human-stable", { Name = "Human Stable",
  Files = {"tileset-forest", "tilesets/summer/human/buildings/stable.png",
    "tileset-swamp", "tilesets/swamp/human/buildings/stable.png"},
  Size = {128, 128},
  Animations = "animations-building", Icon = "icon-human-stable",
  Costs = {"time", 150, "gold", 1000, "wood", 300},
  RepairHp = 4,
  RepairCosts = {"gold", 1, "wood", 1},
  Construction = "construction-human-stable",
  Speed = 0,
  HitPoints = 500,
  DrawLevel = 20,
  TileSize = {3, 3}, BoxSize = {95, 95},
  SightRange = 3,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 15, AnnoyComputerFactor = 15,
  Points = 210,
  Corpse = {"unit-destroyed-3x3-place", 0},
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  Building = true, VisibleUnderFog = true, 
  Sounds = {
    "selected", "human-stable-selected",
    "acknowledge", "human-stable-acknowledge",
    "ready", "human-stable-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-stable-attack"} } )

DefineUnitType("unit-human-lumber-mill", { Name = "Human Lumber Mill",
  Files = {"tileset-forest", "tilesets/summer/human/buildings/lumber_mill.png",
    "tileset-swamp", "tilesets/swamp/human/buildings/lumber_mill.png"},
  Size = {128, 128},
  Animations = "animations-building", Icon = "icon-human-lumber-mill",
  Costs = {"time", 150, "gold", 600, "wood", 450},
  RepairHp = 4,
  RepairCosts = {"gold", 1, "wood", 1},
  ImproveProduction = {"wood", 25},
  Construction = "construction-human-lumber-mill",
  Speed = 0,
  HitPoints = 600,
  DrawLevel = 20,
  TileSize = {3, 3}, BoxSize = {95, 95},
  SightRange = 3,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 25, AnnoyComputerFactor = 15,
  Points = 150,
  Corpse = {"unit-destroyed-3x3-place", 0},
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  Building = true, VisibleUnderFog = true, 
  CanStore = {"wood"},
  Sounds = {
    "selected", "human-lumber-mill-selected",
    "acknowledge", "human-lumber-mill-acknowledge",
    "ready", "human-lumber-mill-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-lumber-mill-attack"} } )

DefineUnitType("unit-human-town-hall", { Name = "Human Town Hall",
  Files = {"tileset-forest", "tilesets/summer/human/buildings/town_hall.png",
    "tileset-swamp", "tilesets/swamp/human/buildings/town_hall.png"},
  Size = {128, 128},
  Animations = "animations-building", Icon = "icon-human-town-hall",
  Costs = {"time", 255, "gold", 1200, "wood", 800},
  RepairHp = 4,
  RepairCosts = {"gold", 1, "wood", 1},
  Construction = "construction-human-town-hall",
  Speed = 0,
  HitPoints = 1200,
  DrawLevel = 20,
  TileSize = {4, 4}, BoxSize = {127, 127},
  SightRange = 4,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 35, AnnoyComputerFactor = 45,
  Points = 200,
  Supply = 1,
  Corpse = {"unit-destroyed-4x4-place", 0},
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  Building = true, VisibleUnderFog = true, 
  CanStore = {"wood", "gold"},
  Sounds = {
    "selected", "human-town-hall-selected",
    "acknowledge", "human-town-hall-acknowledge",
    "ready", "human-town-hall-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-town-hall-attack"} } )

DefineUnitType("unit-human-tower", { Name = "Human Tower",
  Files = {"tileset-forest", "tilesets/summer/human/buildings/tower.png",
    "tileset-swamp", "tilesets/swamp/human/buildings/tower.png"},
  Size = {96, 96},
  Animations = "animations-building", Icon = "icon-human-tower",
  Costs = {"time", 125, "gold", 1000, "wood", 200},
  RepairHp = 4,
  RepairCosts = {"gold", 1, "wood", 1},
  Construction = "construction-human-tower",
  Speed = 0,
  HitPoints = 500,
  DrawLevel = 20,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 3,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 35, AnnoyComputerFactor = 20,
  Points = 240,
  Corpse = {"unit-destroyed-3x3-place", 0},
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  Building = true, VisibleUnderFog = true, 
  Sounds = {
    "selected", "human-tower-selected",
    "acknowledge", "human-tower-acknowledge",
    "ready", "human-tower-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-tower-attack"} } )

DefineUnitType("unit-human-blacksmith", { Name = "Human Blacksmith",
  Files = {"tileset-forest", "tilesets/summer/human/buildings/blacksmith.png",
    "tileset-swamp", "tilesets/swamp/human/buildings/blacksmith.png"},
  Size = {96, 96},
  Animations = "animations-building", Icon = "icon-human-blacksmith",
  Costs = {"time", 200, "gold", 800, "wood", 450, "oil", 100},
  RepairHp = 4,
  RepairCosts = {"gold", 1, "wood", 1, "oil", 1},
  Construction = "construction-land",
  Speed = 0,
  HitPoints = 775,
  DrawLevel = 20,
  TileSize = {2, 2}, BoxSize = {63, 63},
  SightRange = 3,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 15, AnnoyComputerFactor = 20,
  Points = 170,
  Corpse = {"unit-destroyed-3x3-place", 0},
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  Building = true, VisibleUnderFog = true, 
  Sounds = {
    "selected", "human-blacksmith-selected",
    "acknowledge", "human-blacksmith-acknowledge",
    "ready", "human-blacksmith-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-blacksmith-attack"} } )

DefineUnitType("unit-human-start-location", { Name = "Human Start Location",
  Files = {"tileset-forest", "human/x_startpoint.png"},
  Size = {32, 32},
  Animations = "animations-building", Icon = "icon-cancel",
  NumDirections = 1,
  Speed = 0,
  HitPoints = 0,
  DrawLevel = 0,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 0,
  BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 0,
  Demand = 0,
  Type = "land",
  Sounds = {
    "selected", "human-start-location-selected",
    "acknowledge", "human-start-location-acknowledge",
    "ready", "human-start-location-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-start-location-attack"} } )

DefineUnitType("unit-human-wall", { Name = "Wall",
  Files = {"tileset-forest", "neutral/wall.png"},
  Size = {32, 32},
  Animations = "animations-building", Icon = "icon-human-wall",
  Costs = {"time", 30, "gold", 20, "wood", 10},
  Construction = "construction-wall",
  Speed = 0,
  HitPoints = 40,
  DrawLevel = 39,
  TileSize = {1, 1}, BoxSize = {31, 31},
  SightRange = 1,
  Armor = 20, BasicDamage = 0, PiercingDamage = 0, Missile = "missile-none",
  Priority = 0, AnnoyComputerFactor = 45,
  Points = 1,
  Corpse = {"unit-destroyed-1x1-place", 0},
  ExplodeWhenKilled = "missile-explosion",
  Type = "land",
  Building = true, VisibleUnderFog = true, 
  Sounds = {
    "selected", "human-wall-selected",
    "acknowledge", "human-wall-acknowledge",
    "ready", "human-wall-ready",
    "help", "basic human voices help 2",
    "dead", "building destroyed",
    "attack", "human-wall-attack"} } )

