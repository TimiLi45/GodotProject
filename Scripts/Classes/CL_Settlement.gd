class_name  Settlement

var playerControl : bool = true
var sName : String
var sArrayPosition : int = 0
var npcSpawnLocation : Vector2 = Vector2(2,2)
var settlementNode: Node
var settlementActiv : bool = true
var zLevel : int 


var buildings : Array[Building]
var buildingID : int

#### Ressources
var productionRessources : Array[Item]
var foodRessources       : Array[Item] 

#### Farming / Produktion 
var canFarm      : bool = true
var npcsFarming  : Array[int] 
var farmingSpots : Array[int]
var productionSpots : Array[int]

#### -------------- Godot Base Funktions ---------------------------------------

func _init():
	var newItem : Item = Item.new(0,0,"Water")
	newItem.amount = 1000
	foodRessources.append(newItem)
	var newItem2 : Item = Item.new(1,0,"Dirty Water")
	newItem2.amount = 33
	foodRessources.append(newItem2)
	var newItem3 : Item = Item.new(2,0,"Corn")
	newItem3.amount = 44
	foodRessources.append(newItem3)
	var newItem5 : Item = Item.new(3,0,"Meal[0]")
	newItem5.amount = 55
	foodRessources.append(newItem5)
	var newItem4 : Item = Item.new(0,1,"Wood")
	newItem4.amount = 363
	productionRessources.append(newItem4) 

#### -------------- Funktions --------------------------------------------------

func active():
	print("SETTLEMENT: TEST 1 READY")
	spawn_building_in_settlement()
	var i : int  = 0
	if settlementActiv:
		for npc : PlayerNPC in AlPlayerFraction.npcsPlayer:
			if AlPlayerFraction.settlements[npc.settlementAP].sName == sName:
				spawn_npc_in_settlement(i)
			i += 1

func spawn_building_in_settlement():
	for b :Building in buildings:
		var newBuilding = load(AlGameData.buildings[b.buildingTyp]["buildingpath"]).instantiate()
		settlementNode.add_child(newBuilding)
		newBuilding.position = b.position
		if newBuilding.has_method("spawn"):
			newBuilding.spawn(b.objectID)
			print("OID ",b.objectID)

func spawn_npc_in_settlement(npcAP):
	var newNPC = load("res://NPCs/PlayerNPC.tscn").instantiate()
	settlementNode.add_child.call_deferred(newNPC)
	var offsetX : int = 0
	while true:
		var cellID = (npcSpawnLocation.x + offsetX) + (npcSpawnLocation.y* AlWorldManager.levelSize.y)
		if AlWorldManager.is_cell_free(cellID):
			newNPC.position = Vector2((npcSpawnLocation.x + offsetX) * 32,npcSpawnLocation.y *32 )
			newNPC.get_data(npcAP,Vector2i(int(npcSpawnLocation.x + offsetX),int(npcSpawnLocation.y)))
			break
		else:
			offsetX += 1

func has_items(_itemID: int , _itemTyp: int , _itemAmount: int )-> bool:
	match _itemTyp:
		0:
			return foodRessources[_itemID].amount > _itemAmount
		1:
			return productionRessources[_itemID].amount > _itemAmount
	return false

func add_item(_itemID: int , _itemTyp: int , _itemAmount: int ):
	match _itemTyp:
		0:
			foodRessources[_itemID].amount += _itemAmount
		1:
			productionRessources[_itemID].amount += _itemAmount
	if settlementActiv:
		AlGameData.settlementManagementUI.update_ressources()

func remove_item(_itemID: int , _itemTyp: int , _itemAmount: int ):
	match _itemTyp:
		0:
			foodRessources[_itemID].amount = foodRessources[_itemID].amount - _itemAmount
		1:
			productionRessources[_itemID].amount = productionRessources[_itemID].amount - _itemAmount
	if settlementActiv:
		AlGameData.settlementManagementUI.update_ressources()

func add_building_to_settlement(_position: Vector2i,_buildingTyp : String) -> Building:
	var newBuilding : Building  = Building.new(_position, _buildingTyp,zLevel,buildingID)
	buildings.append(newBuilding)
	buildingID += 1
	return newBuilding

func remove_building_from_settlement(_buildingID):
	var i : int = 0
	for bu : Building in buildings:
		if bu.buildingID == _buildingID:
			buildings.remove_at(i)
			return
		i +=1

#### -------------- Time Events ------------------------------------------------

func working_hours_over():
	farming_progress()
	produktion_progress()

func farming_progress():
	var farmingActions : int = npcsFarming.size() *2
	if farmingActions == 0:
		return
	for f : FarmingSpot in AlPlayerFraction.farmingSpots:
		if f.readyToHarvest == true:
			f.harvest()
			farmingActions -= 1
		if f.hasPlant and !f.hasWater and foodRessources[0].amount > 1:
			farmingActions -= 1
			foodRessources[0].amount -= 1
			f.water_spot()
		if farmingActions < 1:
			return

func produktion_progress():
	for prSpot in productionSpots:
		AlPlayerFraction.productionSpots[prSpot].production_progress()
