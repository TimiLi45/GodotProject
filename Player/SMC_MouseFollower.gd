extends Node2D

@onready var sprite : Sprite2D = $Sprite
@onready var collisionArea = $CollisionArea

var cellSize : int = 32
var buildingID : String

var deletionMode : bool = false

func _process(_delta):
	var x  = floor(get_global_mouse_position().x / cellSize) * cellSize
	var y  = floor(get_global_mouse_position().y / cellSize) * cellSize

	self.global_position = Vector2(x,y)

func get_data_building_ghost(_buildingID:String):
	if _buildingID == "delete":
		activate_deletion_mode()
		return
	var sizeX = AlGameData.buildings[_buildingID]["sizeX"]
	var sizeY = AlGameData.buildings[_buildingID]["sizeY"]
	match  sizeX:
		32:
			sprite.position.x = 16
			collisionArea.scale.x = 1
		64:
			sprite.position.x = 32
			collisionArea.scale.x = 2
	
	match  sizeY:
		32:
			sprite.position.y = 16
			collisionArea.scale.y = 1
		64:
			sprite.position.y = 32
			collisionArea.scale.y = 2
	buildingID = _buildingID
	sprite.texture = load(AlGameData.buildings[_buildingID]["spritePath"])

func place_building():
	if deletionMode:
		delete_building()
		return
	if !collisionArea.has_overlapping_areas():
		var newBuilding : Node2D   = load(AlGameData.buildings[buildingID]["buildingpath"]).instantiate()
		var clBuilding  : Building = AlPlayerFraction.settlements[AlPlayerFraction.currentSettlementAP].add_building_to_settlement(
			self.global_position,buildingID  )
		newBuilding.global_position = self.global_position
		newBuilding.constructed(clBuilding)
		AlPlayerFraction.settlements[AlPlayerFraction.currentSettlementAP].settlementNode.add_child(newBuilding)
	else:
		print("overlapping")


func activate_deletion_mode():
	sprite.position.x = 16
	collisionArea.scale.x = 1
	deletionMode = true

func delete_building():
	for oa in collisionArea.get_overlapping_areas():
		if oa.get_parent().has_method("delete_building"):
			oa.get_parent().delete_building()

func leave_building_mode():
	sprite.texture = load("res://Assets_Sprites/Marker.png")
	sprite.position.x = 16
	sprite.position.y = 16
	collisionArea.scale.x = 1
	collisionArea.scale.y = 1
