extends CharacterBody2D

enum AnimationMode {idel,moving,farming,sleeping}

@onready var sprite_2d = $Sprite2D

var npcAP: int
var currentPosition :  Vector2i
var pathToTargetLocation : Array
var currentPathIndex : int
const speed : float = 50


var animationMode : AnimationMode = AnimationMode.idel

func get_data(_npcAP, _currentPosition : Vector2i):
	currentPosition = _currentPosition
	npcAP = _npcAP
	$Label.text = AlPlayerFraction.npcsPlayer[npcAP].npcName
	AlPlayerFraction.npcsPlayer[npcAP].node = self
	AlPlayerFraction.npcsPlayer[npcAP].update_behavior()

func _exit_tree():
	AlPlayerFraction.npcsPlayer[npcAP].node = null

func _physics_process(delta):
	if currentPathIndex < pathToTargetLocation.size():
		
		var t = load("res://Assets_Sprites/farmer.png")
		$Sprite2D.texture = t
	
		var nextPosition = pathToTargetLocation[currentPathIndex]
		var direction = (Vector2(nextPosition * 32) - global_position).normalized()
		var movement = direction * speed * delta
		position += movement
		currentPosition = floor(position / 32)
		
		# Überprüfe, ob die Node den nächsten Punkt im Pfad erreicht hat
		if global_position.distance_to(nextPosition * 32) < speed * delta:
			currentPathIndex += 1 
	else :
		match animationMode:
			AnimationMode.idel:
				var t = load("res://Assets_Sprites/Idle.png")
				$Sprite2D.texture =  t
			AnimationMode.farming:
				var t = load("res://Assets_Sprites/Farmergeduckt.png")
				$Sprite2D.texture = t
			AnimationMode.sleeping:
				var t = load("res://Assets_Sprites/sleep.png")
				$Sprite2D.texture = t

func move_to_and_do(_targetPosition : Vector2i,_targetAction : int):
	match _targetAction:
		-1:
			animationMode = AnimationMode.idel
		-2:
			animationMode = AnimationMode.farming
		-3:
			animationMode = AnimationMode.sleeping
	pathToTargetLocation = AlWorldManager.find_path(currentPosition, _targetPosition)
	currentPathIndex = 0

func farming():
	animationMode = AnimationMode.farming
	var setAP : int = AlPlayerFraction.npcsPlayer[npcAP].settlementAP
	if AlPlayerFraction.settlements[setAP].farmingSpots.size() == 0:
		idle()
		return
	var faAP : int = AlPlayerFraction.settlements[setAP].farmingSpots.pick_random()
	pathToTargetLocation = AlWorldManager.find_path(currentPosition, AlPlayerFraction.farmingSpots[faAP].building.position/32)
	currentPathIndex = 0


func idle():
	animationMode = AnimationMode.idel

func sleep():
	animationMode = AnimationMode.sleeping
	pathToTargetLocation.clear()
	currentPathIndex = 0

func _on_timer_timeout():
	AlPlayerFraction.npcsPlayer[npcAP].update_behavior()
