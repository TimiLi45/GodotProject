class_name ProduktionSpot

enum FuelType {None, Fire, Electric}

#### ------- Building Properties -----------------------------------------------

var id            : int                 # ID of the building Slot
var settlementAP  : int                 # Settlement of the building Slot
var name          : String              # Name of the Slot
var node          : Node2D              # If the settlement is active the InWorld node is here
var buildingPath  : String              # The path to the Building Asset 
var playerNPC     : int      = -1       # The NPC that works here
var produktionTyp : int                 # 0 == cooking | 1 == scavenging
var building      : Building

var activeRecipes : Array[String]       # All the active Recepies in order from higest to lowest
var recipeInFocus : String

#### ------- Produktion Properties ---------------------------------------------
# --- Station Fuel ----
var fuelTyp     : FuelType
var fuelCurrent : int 
var fuelMax     : int
var fuelNeedet  : int

# --- Ressources ----
var inputRessources  : Array[Item]
var outputRessources : Array[Item]
var ressourcesPaid   : bool

# --- Progress ----
var progressDone :int = 0
var progressToFinish: int 

func _init(_id : int,_settlementAP : int ,_name : String, _produktionTyp : int,_building : Building):
	id            = _id
	settlementAP  = _settlementAP
	name          = _name
	produktionTyp = _produktionTyp
	building      = _building

func add_recipe(_recipe):
	activeRecipes.append(_recipe)
	if activeRecipes.size() == 1:
		set_recipe_in_focus(_recipe)

func remove_recipe(_recipe):
	if activeRecipes.has(_recipe):
		var i : int = activeRecipes.find(_recipe)
		activeRecipes.remove_at(i)

func set_recipe_in_focus(_recipe):
	match produktionTyp:
		0:                                       ## produktionType == Cooking
			progressToFinish = AlGameData.cookingRecepies[_recipe]["produktionCost"]
			inputRessources.clear()
			outputRessources.clear()
			for item in AlGameData.cookingRecepies[_recipe]["itemCost"]:
				var newItem : Item = Item.new( item[0], item[1], "")
				newItem.amount = item[2]
				inputRessources.append(newItem)
			for item in AlGameData.cookingRecepies[_recipe]["itemOutput"]:
				var newItem : Item = Item.new( item[0], item[1], "")
				newItem.amount = item[2]
				outputRessources.append(newItem)

func production_progress():
	if fuelTyp != FuelType.None:                   ## Fuel Check
		if fuelCurrent < fuelNeedet:               ## Not enough fuel -> refill
			refill_fuel()
		if fuelCurrent < fuelNeedet:               ## Not enough fuel -> return
			return
		fuelCurrent = fuelCurrent - fuelNeedet
	
	if !ressourcesPaid:                            ## Ressources Check
		if !has_ressources():                      
			return
		start_produktion()     
	
	var produktionPorgress : int = 2  #   <------ Hier später erweitern
	
	while produktionPorgress > 0:                   ## Produktion Loopa
		progressDone += produktionPorgress
		if progressDone >= progressToFinish:
			produktionPorgress = produktionPorgress - progressToFinish
			finish_producktion()
			if has_ressources():
				start_produktion()
			else:
				return
		else:
			return

func start_produktion():
	for item :Item in inputRessources:
		AlPlayerFraction.settlements[settlementAP].remove_item(item.id,item.typ,item.amount)
	ressourcesPaid = true

func has_ressources() -> bool:
	var b : bool = true
	for i : Item in inputRessources:
		if !AlPlayerFraction.settlements[settlementAP].has_items(i.id,i.typ,i.amount):
			b = false
			break
	return b

func finish_producktion():
	if produktionTyp == 1:          ## scavenging
		finish_scavenging()
		return
	ressourcesPaid = false
	progressDone = 0
	for item :Item in outputRessources:
		AlPlayerFraction.settlements[settlementAP].add_item(item.id,item.typ,item.amount)

func finish_scavenging():
	pass

func refill_fuel():
	if AlPlayerFraction.settlements[settlementAP].has_items(0,1,1):
		AlPlayerFraction.settlements[settlementAP].remove_item(0,1,1)
		fuelCurrent = fuelMax
	else:
		return
