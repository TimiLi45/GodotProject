extends CanvasLayer

var objectID : String

func get_data(_objectID : String):
	objectID = _objectID
	for i in AlWorldManager.itemsInLevel:
		if i[0] == objectID:
			print(i)

func _on_button_pressed():
	AlGameData.playerPawn.ui_close()
	self.queue_free()
