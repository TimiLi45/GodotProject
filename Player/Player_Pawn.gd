extends CharacterBody2D

enum AnimationMode {standart, melle}
const SPEED = 300.0

var canMove    : bool = true 
var blockInput : bool = false
var uiOpen     : bool = false
var walking    : bool = false

var animationMode : AnimationMode = AnimationMode.standart
var currentAnimation : String = "idle"


@onready var a_damage_box = $A_DamageBox
@onready var s_player     = $S_Player

@onready var animation_player = $AnimationPlayer


func _ready():
	AlGameData.playerPawn = self

func _physics_process(delta):
	walking = false
	if (uiOpen):
		animation_player.play("idle")
		return
	if (canMove):
		if blockInput:
			return
		if Input.is_action_pressed("RIGHT"):
			position.x += SPEED * delta
			s_player.flip_h = false
			animation_player.play("walk_side")
			walking = true
		if Input.is_action_pressed("LEFT"):
			position.x -= SPEED * delta
			s_player.flip_h = true
			animation_player.play("walk_side")
			walking = true
		if Input.is_action_pressed("UP"):
			position.y -= SPEED * delta
			animation_player.play("walk_side")
			walking = true
		if Input.is_action_pressed("DOWN"):
			position.y += SPEED * delta
			animation_player.play("walk_side")
			walking = true
		if walking == false:
			animation_player.play("idle")
		move_and_slide()
		
	else:
		if blockInput:
			pass
		else:
			animation_player.play("idle")
	
	if animationMode == AnimationMode.standart:
		a_damage_box.look_at(get_global_mouse_position())

func _input(_event):
	if blockInput or uiOpen:
		return
	if Input.is_action_just_pressed("ENTER_BUILDING_MODE") and canMove:
		var newSMC = load("res://Player/SettlementManagementController.tscn").instantiate()
		get_tree().get_root().add_child(newSMC)
		newSMC.position = AlGameData.settlementCenter
		self.queue_free()
		AlGameData.playerPawn = null
	if Input.is_action_just_released("INVENTORY"):
		ui_open()
		var  newUI = load("res://UserInterface/Player/Inventory/UI_Player_Inventory.tscn").instantiate()
		self.add_child(newUI)
	if Input.is_action_just_pressed("CLICK_LEFT"):
		attack_melle()

func ui_open():
	uiOpen     = true
	blockInput = true

func ui_close():
	uiOpen     = false
	blockInput = false

func attack_melle():
	blockInput = true
	for area in a_damage_box.get_overlapping_areas():
		if area.is_in_group("enemy"):
			area.get_damage(AlPlayerInventory.weapon_exp_type)
	animation_player.play("melle_attack1")
	currentAnimation = "melle_attack1"

func _on_animation_player_animation_finished(_currentAnimation):
	blockInput = false
