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
@onready var progress_bar = $ProgressBar

var progres : bool = false
var progressDone : float = 0

func _ready():
	if AlWorldManager.dismountableObjects.has(boxID):
		self.queue_free()
	boxSprite1.texture = load(boxPath1)
	if boxPath2 != "":
		boxSprite2.texture = load(boxPath2)
		boxSprite2.position.y  -= boxOffset
	if boxPath3 != "":
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

func _process(delta):
	if Input.is_key_pressed(KEY_E) and !AlGameData.playerPawn.uiOpen :
		if AlWorldManager.has_item_in_level(boxID):
			AlGameData.playerPawn.ui_open()
			var newUI = load("res://UserInterface/Player/Inventory/Loot/UI_Loot.tscn").instantiate()
			newUI.get_data(boxID)
			add_child(newUI)
	if dismantle and !AlWorldManager.has_item_in_level(boxID):
		label.text = "Dismantle \"E\""
		if Input.is_key_pressed(KEY_E):
			AlGameData.playerPawn.ui_open()
			progres = true
			progress_bar.visible = true
			label.visible = false
			### Here comes animation
	if progres:
		progressDone += delta + 2 
		progress_bar.value = progressDone
		if progressDone >= 100:
			AlGameData.playerPawn.ui_close()
			add_items_to_player()
			AlWorldManager.dismountableObjects.append(boxID)
			self.queue_free()

func add_items_to_player():
	AlPlayerInventory.add_item(0,1,2)
