extends Area2D



func get_damage(_weapon_exp_type: int):
	AlPlayerSkills.add_exp(_weapon_exp_type,1)
	get_parent().dead()
