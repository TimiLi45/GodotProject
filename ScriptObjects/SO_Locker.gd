extends Node2D

@export var boxID     : String
@export var dismantle : bool = false 

@onready var label = $Label
@onready var progress_bar = $ProgressBar

var progres : bool = false
var progressDone : float = 0

func _ready():
	if AlWorldManager.dismountableObjects.has(boxID):
		self.queue_free()

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
	if dismantle and !AlWorldManager.has_item_in_level(boxID) and !AlGameData.playerPawn.uiOpen:
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
			add_to_player()
			AlWorldManager.dismountableObjects.append(boxID)
			self.queue_free()

func add_to_player(): ## EXP and Items
	AlPlayerInventory.add_item(0,1,2)
	AlPlayerSkills.add_exp(2,3)
