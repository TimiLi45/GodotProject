extends CanvasLayer


func _ready():
	AlGameData.playerPawn.ui_open()


func _on_button_pressed():
	AlWorldManager.new_level()
	self.queue_free()

func _on_b_leave_pressed():
	AlGameData.playerPawn.ui_close()
	self.queue_free()
