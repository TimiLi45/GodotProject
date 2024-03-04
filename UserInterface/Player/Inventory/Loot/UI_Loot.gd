extends CanvasLayer

var objectID : String

func get_data(_objectID : String):
	objectID = _objectID
	for i in AlWorldManager.itemsInLevel:
		if i[0] == objectID:
			var newUI = load("res://UserInterface/Player/Inventory/Loot/UI_Loot_Item.tscn").instantiate()
			$ScrollContainer/VBoxContainer.add_child(newUI)
			newUI.get_data(objectID,i[1], i[2] ,i[3],self)

func _on_button_pressed():
	AlGameData.playerPawn.ui_close()
	self.queue_free()
