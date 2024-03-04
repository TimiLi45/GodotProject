extends Node2D

var farmingSpotAP : int
var farmingSpot   : FarmingSpot

func constructed(_building : Building):
	farmingSpotAP = AlPlayerFraction.add_farming_spot(_building)
	farmingSpot  = AlPlayerFraction.farmingSpots[farmingSpotAP]
	_building.objectID = farmingSpotAP
	AlPlayerFraction.farmingSpots[farmingSpotAP].node = self
	update()

func delete_building():
	var settlementAP : int = farmingSpot.settlementAP
	var buildingID   : int = farmingSpot.building.buildingID
	AlPlayerFraction.settlements[settlementAP].remove_building_from_settlement(buildingID)
	var fsP : int = AlPlayerFraction.settlements[settlementAP].farmingSpots.find(farmingSpotAP)
	AlPlayerFraction.settlements[settlementAP].farmingSpots.remove_at(fsP)
	AlPlayerFraction.remove_farming_spot(farmingSpotAP)
	self.queue_free()

func spawn(_fsAP :int):
	farmingSpotAP = _fsAP
	farmingSpot = AlPlayerFraction.farmingSpots[farmingSpotAP]
	update()

func update():
	if AlPlayerFraction.farmingSpots[farmingSpotAP].hasWater:
		$S_Floor.texture = load("res://Assets_Sprites/Buildings/Production/Farming/Farm_Plot_Watert.png")
	else:
		$S_Floor.texture = load("res://Assets_Sprites/Buildings/Production/Farming/Farm_Plot.png")
	if AlPlayerFraction.farmingSpots[farmingSpotAP].hasPlant == false:
		$Label.text = "E"
		return
	if AlPlayerFraction.farmingSpots[farmingSpotAP].readyToHarvest == true:
		$Label.text = "R"
		return
	$Label.text = str(AlPlayerFraction.farmingSpots[farmingSpotAP].grown)

#### ------------------- Buttons -----------------------------------------------

func _on_button_pressed():
	if AlPlayerFraction.farmingSpots[farmingSpotAP].hasPlant == false:
		AlPlayerFraction.farmingSpots[farmingSpotAP].hasPlant = true
		AlPlayerFraction.farmingSpots[farmingSpotAP].plantID = 1
		update()
