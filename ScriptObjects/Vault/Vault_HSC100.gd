extends Node2D

@onready var s_computer = $S_Computer
@onready var s_screen = $S_Screen
@onready var timer = $Timer

var is_in_dialog : bool = false

func new_sprite_frame():
	if is_in_dialog:
		pass
	else:
		s_screen.frame +=1
		if s_screen.frame >2 :
			s_screen.frame = 0

func _on_timer_timeout():
	new_sprite_frame()
	timer.start()
