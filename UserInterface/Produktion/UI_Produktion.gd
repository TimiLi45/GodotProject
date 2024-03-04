extends CanvasLayer

@onready var vbc = $SC/VBC

func get_data(_wsName: String,_produktionTyp:int,_producttionSlotAp: int ):
	$L_Name.text= _wsName
	match _produktionTyp:
		0:                ##cooking 
			for recepieID in AlGameData.learnedCookingRecepies:
				var newUI = load("res://UserInterface/Produktion/UI_Recepie.tscn").instantiate()
				vbc.add_child(newUI)
				newUI.get_data(_produktionTyp, recepieID,_producttionSlotAp, self)

func _on_b_back_pressed():
	self.queue_free()
	AlGameData.playerController.extern_UI_close()
