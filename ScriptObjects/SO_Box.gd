extends Node2D

@export var boxID     : String
@export var dismantle : bool = false 
@export var boxOffset : int 
@export var boxPath1  : String
@export var boxPath2  : String
@export var boxPath3  : String


@onready var boxSprite1 = $Node2D/S_Box1
@onready var boxSprite2 = $Node2D/S_Box2
@onready var boxSprite3 = $Node2D/S_Box3

@onready var label = $Label


func _ready():
	#
	boxSprite1.texture = load(boxPath1)
	boxSprite2.texture = load(boxPath2)
	boxSprite2.position.y  -= boxOffset
	boxSprite3.texture = load(boxPath3)
	boxSprite3.position.y  -= (boxOffset*2)

func _on_area_2d_body_entered(body):
	if body != AlGameData.playerPawn:
		return
	label.visible = true

func _on_area_2d_body_exited(body):
	if body != AlGameData.playerPawn:
		return
	label.visible = false


func _process(_delta):
	if Input.is_key_pressed(KEY_E) and !AlGameData.playerPawn.uiOpen :
		if AlWorldManager.has_item_in_level(boxID):
			AlGameData.playerPawn.ui_open()
			var newUI = load("res://UserInterface/Player/Inventory/Loot/UI_Loot.tscn").instantiate()
			newUI.get_data(boxID)
			add_child(newUI)



