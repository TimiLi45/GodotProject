extends Node2D

func _ready():
	AlPlayerFraction.settlements[0].settlementNode = $Settlement
	AlPlayerFraction.settlements[0].active()
