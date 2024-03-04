extends CanvasLayer

@onready var gcBuildings = $ScrollContainer/GC_Building
@onready var l_building_info = $L_BuildingInfo


func _ready():
	for s in AlGameData.researchedBuildings:
		var newUI = load("res://UserInterface/BuildingUI/UI_Building.tscn").instantiate()
		gcBuildings.add_child(newUI)
		newUI.get_data(s,self)

func select_building(_bID :String):
	AlGameData.settlementManagementController.set_building_ghost(_bID)
	self.queue_free()

func show_building_info(_bID :String):
	l_building_info.text = AlGameData.buildings[_bID]["buildingDescription"]

#### ---------------- Buttons --------------------------------------------------

func _on_b_back_pressed():
	AlGameData.settlementManagementController.close_ui()
	self.queue_free()

func _on_b_delete_pressed():
	AlGameData.settlementManagementController.set_building_ghost("delete")
	self.queue_free()
