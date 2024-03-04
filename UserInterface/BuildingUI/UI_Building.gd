extends Control

var mothernode
var bID

func get_data(_bID:String,_mothernode):
	bID = _bID
	mothernode =_mothernode
	$Button.text = AlGameData.buildings[bID]["buildingName"]

func _on_button_pressed():
	mothernode.select_building(bID)

func _on_mouse_entered():
	mothernode.show_building_info(bID)
