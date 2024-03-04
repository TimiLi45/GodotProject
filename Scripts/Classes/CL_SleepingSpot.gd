class_name SleepingSpot

var id : int
var settlementAP : int
var building : Building

var ssName : String
var sLevel : int 
var npcAP : int = -1

func _init(_id : int,_settlementAP : int,_building : Building, _sLevel : int, _ssName : String):
	id = _id
	settlementAP = _settlementAP
	sLevel   = _sLevel
	ssName   = _ssName
	building = _building
