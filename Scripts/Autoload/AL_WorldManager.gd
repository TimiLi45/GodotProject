extends Node

var day   : int  = 0
var hour  : int  = 6
var night : bool = false

var blockedCells : Array[int] 

var levelSize : Vector2i = Vector2i(100,100)

var newLevel

var itemsInLevel : Array = [["box1",0,1,1],["box1",1,1,3],["box2",1,1,3]]
var dismountableObjects :Array = []

func _ready():
	print("WorldManager     ------------------------ READY")

func switch_level(_path : String):
	newLevel = _path
	var newUI = load("res://UserInterface/UI_Leave_Level.tscn").instantiate()
	AlGameData.playerPawn.add_child(newUI)


func new_level():
	for i in get_tree().get_root().get_node("Main").get_children():
		if i != null:
			i.queue_free()
	AlGameData.playerPawn = null
	AlGameData.settlementManagementController = null
	AlGameData.settlementManagementUI = null
	AlPlayerFraction.currentSettlementAP = -1
	get_tree().change_scene_to_file(newLevel)

#### ---------------------- Cell Blocking --------------------------------------

func is_cell_free(cellID:int) -> bool:
	return !blockedCells.has(cellID)

func is_cell_free_vector(_position:Vector2i) -> bool:
	var cellID : int = _position.x + _position.y * levelSize.y
	return !blockedCells.has(cellID)

func block_cell(cellID : int ):
	if !cellID in blockedCells:
		blockedCells.append(cellID)
		print("WORLDMANAGER: CellBlocked:",cellID)
	else:
		print("ERROR: CellID ",cellID," already in blockedCells")

func unblock_cell(cellID):
	if blockedCells.has(cellID):
		var index : int =  blockedCells.find(cellID)
		blockedCells.remove_at(index)
	else:
		print("ERROR: CellID ",cellID," is not in blockedCells")

#### ---------------------- Items in Level  --------------------------------------

func add_item_in_level(_objectID : String,_id : int , _typ : int ,_amount : int):
	itemsInLevel.append_array([_objectID,_id,_typ,_amount])

func remove_item_in_level(_objectID : String,_id : int , _typ : int ,_amount : int):
	for i in itemsInLevel:
		if i[0] == _objectID and i[1] == _id and i[2] == _typ:
			i[3] -= _amount
			if 0 >= i[3] :
				itemsInLevel.remove_at(itemsInLevel.find(i))

func has_item_in_level(_objectID : String) -> bool:
	for i in itemsInLevel:
		if i[0] == _objectID:
			return true
	return false

#### ---------------------- Time -----------------------------------------------

#region Time Functions

func new_day():
	day += 1
	AlPlayerFraction.day_over()

func new_hour():
	hour +=1
	match hour:
		24:
			hour = 0
			new_day()
		6:
			night = false
			npc_update()
			settlement_update()
		9:
			AlPlayerFraction.working_hour_over()
		12:
			AlPlayerFraction.working_hour_over()
		15:
			AlPlayerFraction.working_hour_over()
		18:
			AlPlayerFraction.working_hour_over()
		21:
			AlPlayerFraction.working_hour_over()
			night = true
			npc_update()
			settlement_update()
	AlGameData.settlementManagementUI.update_ressources()

func npc_update():
	for npc : PlayerNPC in AlPlayerFraction.npcsPlayer:
		if npc.node != null:
			npc.eat()
			npc.update_behavior()

func settlement_update():
	pass

#endregion

####  ---------------------- Navigation ----------------------------------------

#region A* Pathfinding
func find_path(start: Vector2i, end: Vector2i) -> Array:
	# First check if target cell is free and in Gamefield
	if(is_cell_free_vector(end) && (end.x >= 0 && end.x < levelSize.x && end.y >= 0 && end.y < levelSize.y)):
		var open_set = []
		open_set.append(start)
		var came_from = {}
		var g_score = {start: 0}
		var f_score = {start: calculate_heuristic(start, end)}
		while open_set.size() > 0:
			var current = find_lowest_f_score(open_set, f_score)
			if current == end:
				return reconstruct_path(came_from, current)
			open_set.erase(current)
			for neighbor in get_neighbors(current):
				var tentative_g_score = g_score[current]# + calculate_cost(current, neighbor)
				if tentative_g_score < g_score.get(neighbor, 99999999):
					came_from[neighbor] = current
					g_score[neighbor] = tentative_g_score
					f_score[neighbor] = g_score[neighbor] + calculate_heuristic(neighbor, end)
					if !open_set.has(neighbor):
						open_set.append(neighbor)
	return []

func calculate_heuristic(position: Vector2i, goal: Vector2i) -> float:
	return sqrt(pow(goal.x - position.x, 2) + pow(goal.y - position.y, 2))

func find_lowest_f_score(open_set: Array, f_score: Dictionary) -> Vector2i:
	var min_score = 9999999999
	var min_node: Vector2i
	for node in open_set:
		if f_score[node] < min_score:
			min_score = f_score[node]
			min_node = node
	return min_node

func get_neighbors(position: Vector2i) -> Array:
	var neighbors = []
	var possible_offsets = [
		Vector2i(0, 1), Vector2i(0, -1),
		Vector2i(1, 0), Vector2i(-1, 0),
		Vector2i(1, 1), Vector2i(1, -1),
		Vector2i(-1, 1), Vector2i(-1, -1)
	]
	for offset in possible_offsets:
		var neighbor = position + offset
		if is_valid_cell(neighbor):
			neighbors.append(neighbor)
	return neighbors

func reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array:
	var path = []
	while came_from.has(current):
		path.push_front(current)
		current = came_from[current]
	path.push_front(current)  # Füge den Startpunkt hinzu
	return path

func is_valid_cell(position: Vector2i) -> bool:
	if position.x < 0 || position.x >= levelSize.x || position.y < 0 || position.y >= levelSize.y:
		return false
	var cellPosition : int = position.x + position.y * levelSize.y
	return is_cell_free(cellPosition)

#func calculate_cost(_current: Vector2i, _neighbor: Vector2i) -> float:
#	return 1  # Assuming uniform cost for simplicity
#endregion
