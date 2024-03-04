class_name  PlayerNPC

var npcName      : String
var settlementAP : int
var node         : Node2D = null

var jobTitle : String = "No Job"

var jobAP          : int = -1 : set = _set_jobAP
var sleepingSpotAP : int = -1 : set = _set_sleepingSpotAP

#### -------------- Base Funktions ---------------------------------------------

func _set_jobAP(value):
	jobAP = value
	update_behavior()

func _set_sleepingSpotAP(value):
	sleepingSpotAP = value
	update_behavior()

func _init(_npcName : String,_settlementAP : int):
	npcName = _npcName
	settlementAP = _settlementAP

####  -------------- AI Behavior -----------------------------------------------

func update_behavior():
	if node == null:
		return
		   # --> Here are special events
	if AlWorldManager.night:
		is_night()
	else:
		is_day()

func is_day():
	if jobAP== -1:      ## No Job
		node.idle()
		return
	if jobAP== -2:      ## Farming
		node.farming()
		return
	else:
		go_to_productionSpot()

func is_night():
	if sleepingSpotAP == -1:
		node.sleep()
	else:
		go_to_sleepingSpot()

func go_to_productionSpot():
	var targetlocation : Vector2i = AlPlayerFraction.productionSpots[jobAP].position
	var taskID : int  = AlPlayerFraction.productionSpots[jobAP].produktionTyp
	node.move_to_and_do(targetlocation,taskID)

func go_to_sleepingSpot():   ## npcs goes sleeping
	var targetlocation : Vector2i = AlPlayerFraction.sleepingSpots[sleepingSpotAP].building.position /32
	node.move_to_and_do(targetlocation,-3)

####  -------------- Divers ---------------------------------------------------

func eat():
	if AlPlayerFraction.settlements[settlementAP].has_items(3,0,1):
		AlPlayerFraction.settlements[settlementAP].remove_item(3,0,1)
	else:
		print(npcName," is starving")
