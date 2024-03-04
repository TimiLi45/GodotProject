extends Node2D

@onready var camera : Camera2D = $PlayerCamera
@onready var playerMouse = $PlayerMouseFollower
@onready var player_controller = $"."



const speed : float = 500
var canMove : bool = true
var blockInput : bool = false

var buildingMode : bool = false


func _ready():
	AlGameData.settlementManagementController =  self
	print("PlayerController ------------------------ READY")

func _physics_process(delta):
	# Movement
	if (canMove):
		if blockInput:
			return
		if Input.is_action_pressed("RIGHT"):
			position.x += speed * delta
		if Input.is_action_pressed("LEFT"):
			position.x -= speed * delta
		if Input.is_action_pressed("UP"):
			position.y -= speed * delta
		if Input.is_action_pressed("DOWN"):
			position.y += speed * delta	

func _input(event):
	if blockInput:
		return
	if Input.is_action_just_pressed("CAM_IN") and canMove:
		if camera.zoom.x < 3 :
			camera.zoom.x += 0.1
			camera.zoom.y += 0.1
	if Input.is_action_just_pressed("CAM_OUT")and canMove:
		if camera.zoom.x > .5 :
			camera.zoom.x -= 0.1
			camera.zoom.y -= 0.1
	if event.is_action_released("OPEN_UI_BuildingMode"):
		open_building_mode()
	if event.is_action_released("CLICK_LEFT"):
		if (buildingMode):
			playerMouse.place_building()
	if event.is_action_released("CLICK_RIGHT"):
		if (buildingMode):
			buildingMode = false
			playerMouse.leave_building_mode()

func open_ui():
	buildingMode = false
	canMove= false
	playerMouse.visible = false

func close_ui():
	canMove= true
	playerMouse.visible = true

func extern_UI_open():
	blockInput = true
	AlGameData.settlementManagementUI.visible = false

func extern_UI_close():
	blockInput = false
	AlGameData.settlementManagementUI.visible = true

func set_building_ghost(_buildingID:String):
	canMove= true
	playerMouse.visible = true
	playerMouse.get_data_building_ghost(_buildingID)
	buildingMode = true

func open_building_mode():
	open_ui()
	var newUI = load("res://UserInterface/BuildingUI/UI_Building_Mode.tscn").instantiate()
	self.add_child(newUI)
