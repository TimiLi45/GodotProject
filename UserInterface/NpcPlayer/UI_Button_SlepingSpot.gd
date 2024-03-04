extends Control


var ssAP : int 
var mothernode

func get_data(_ssAP : int ,_mothernode):
	ssAP = _ssAP
	mothernode = _mothernode
	$Button.text = AlPlayerFraction.sleepingSpots[ssAP].ssName+" ["+str(AlPlayerFraction.sleepingSpots[ssAP].sLevel)+"]"
	if AlPlayerFraction.sleepingSpots[ssAP].npcAP != -1:
		$Button.text = $Button.text+" ["+AlPlayerFraction.npcsPlayer[AlPlayerFraction.sleepingSpots[ssAP].npcAP].npcName+"]"

func _on_button_pressed():
	mothernode.set_sleepingSpot(ssAP)
