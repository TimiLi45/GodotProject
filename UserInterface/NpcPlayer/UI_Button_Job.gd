extends Control

var jobAP : int 
var mothernode

func get_data(_taskAP : int ,_mothernode):
	jobAP = _taskAP
	mothernode = _mothernode
	if _taskAP == -2:
		$Button.text = "Farming in "+ AlPlayerFraction.settlements[AlPlayerFraction.currentSettlementAP].sName
		return
	$Button.text = AlPlayerFraction.productionSpots[jobAP].name+"("+str(AlPlayerFraction.productionSpots[jobAP].id) + ")"
	if AlPlayerFraction.productionSpots[jobAP].playerNPC != -1:
		var npcAP = AlPlayerFraction.productionSpots[jobAP].playerNPC
		$Button.text = $Button.text + " - [" + AlPlayerFraction.npcsPlayer[npcAP].npcName + "]"

func _on_button_pressed():
	mothernode.set_job(jobAP)

