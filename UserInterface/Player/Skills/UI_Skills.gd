extends CanvasLayer

@onready var gc_skills = $ScrollContainer/GC_Skills

func _ready():
	create_skill_ui()

func create_skill_ui():
	for i : AlPlayerSkills.Skill in AlPlayerSkills.skills:
		var newUI = load("res://UserInterface/Player/Skills/UI_Skill.tscn").instantiate()
		gc_skills.add_child(newUI)
		newUI.get_data(i)

func _on_b_close_pressed():
	AlGameData.playerPawn.ui_close()
	self.queue_free()
