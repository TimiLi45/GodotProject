extends Control

var mothernode
var npcPlayerAP : int

func get_data(_npcPlayerAP : int,_name : String,_mothernode):
	mothernode = _mothernode
	npcPlayerAP =_npcPlayerAP
	$Button.text = _name

func _on_button_pressed():
	mothernode.show_playerNPC_info(npcPlayerAP)
