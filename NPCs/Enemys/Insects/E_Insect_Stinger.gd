extends CharacterBody2D

const SPEED = 300.0
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")

