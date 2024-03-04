extends Node2D

@export var levleName : String


func _on_a_leve_level_body_entered(body):
	if body.is_in_group("player"):
		switch_level()


func switch_level():
	AlWorldManager.switch_level(levleName)

