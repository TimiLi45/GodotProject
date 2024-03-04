extends Node2D

var spotAP : int
var spot : ProduktionSpot

func constructed(_building : Building):
	var posX : int = floor(position.x / 32)
	var posY : int = floor(position.y / 32)
	var cellID  : int = posX + posY*AlWorldManager.levelSize.y
	AlWorldManager.block_cell(cellID)
	AlWorldManager.block_cell(cellID+1)
	spotAP = AlPlayerFraction.add_production_spot("primitiv Kitchen",0,Vector2(posX,posY),_building) # 0== ProduktionType cooking
	spot   = AlPlayerFraction.productionSpots[spotAP]
	AlPlayerFraction.productionSpots[spotAP].fuelTyp = ProduktionSpot.FuelType.Fire
	AlPlayerFraction.productionSpots[spotAP].fuelMax = 100

func delete_building():
	var settlementAP : int = spot.settlementAP
	print(AlPlayerFraction.settlements[settlementAP].productionSpots)
	var buildingID   : int = spot.building.buildingID
	#var spotID       : int = spot.id
	AlPlayerFraction.settlements[settlementAP].remove_building_from_settlement(buildingID)
	var fsP : int = AlPlayerFraction.settlements[settlementAP].productionSpots.find(spotAP)
	AlPlayerFraction.settlements[settlementAP].productionSpots.remove_at(fsP)
	AlPlayerFraction.remove_production_spot(spotAP)
	print(AlPlayerFraction.settlements[settlementAP].productionSpots)
	self.queue_free()


func _on_button_pressed():
	if AlGameData.playerController.blockInput == true:
		return
	if AlGameData.playerController.buildingMode == true:
		return
	var newUI = load("res://UserInterface/Produktion/UI_Produktion.tscn").instantiate()
	get_tree().get_root().add_child(newUI)
	newUI.get_data("Cooking Fire",0,spotAP)
	AlGameData.playerController.extern_UI_open()
