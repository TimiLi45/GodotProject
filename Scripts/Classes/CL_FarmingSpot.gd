class_name FarmingSpot

#### ------- Building Properties -----------------------------------------------

var id : int                           ## uniquie ID for this spot
var settlementAP : int
var node: Node2D
var building : Building

#### ------- Plant Properties --------------------------------------------------

var hasPlant : bool = false
var plantID  : int 
var hasWater : bool = false
var grown    : int  = 0
var toGrow   : int  = 5
var readyToHarvest : bool = false

func _init(_id : int,_settlementAP : int, _building :Building):
	id = _id
	settlementAP = _settlementAP
	building = _building

func day_over():
	if hasPlant and !readyToHarvest and hasWater:
		grown +=1
		if grown == toGrow:
			readyToHarvest = true
	if hasWater:
		hasWater = false
	if settlementAP == AlPlayerFraction.currentSettlementAP:
		node.update()

func water_spot():
	hasWater = true
	if settlementAP == AlPlayerFraction.currentSettlementAP:
		node.update()

func harvest():
	if !readyToHarvest:
		return
	grown    = 0
	hasPlant = false
	hasWater = false
	readyToHarvest = false
	match plantID:
		1:
			AlPlayerFraction.settlements[settlementAP].foodRessources[3].amount +=1
	if settlementAP == AlPlayerFraction.currentSettlementAP:
		node.update()
