extends Node2D

var sleepingSpot : SleepingSpot
var sleepingSpotAP
var sLevel : int = 2

func constructed(_building: Building):
	sleepingSpotAP = AlPlayerFraction.add_sleeping_spot(position,2,"Low Level S",_building)
	sleepingSpot = AlPlayerFraction.sleepingSpots[sleepingSpotAP]
	#var posX : int = floor(position.x / 32)
	#var posY : int = floor(position.y / 32)
	#var cellID  : int = posX + posY*AlWorldManager.levelSize.y
	#AlWorldManager.block_cell(cellID)
	#AlWorldManager.block_cell(cellID+1)

func delete_building():
	var settlementAP : int = sleepingSpot.settlementAP
	var buildingID   : int = sleepingSpot.building.buildingID
	AlPlayerFraction.settlements[settlementAP].remove_building_from_settlement(buildingID)
	AlPlayerFraction.remove_sleeping_spot(sleepingSpotAP)
	self.queue_free()
