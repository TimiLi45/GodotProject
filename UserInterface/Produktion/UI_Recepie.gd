extends Control

@onready var l_name = $L_Name
@onready var l_text = $L_Text
@onready var b_set_active = $B_SetActive

var mothernode
var typ : int 
var recipeID : String
var productionSpotAP : int



func get_data(_typ :int, _recipeID : String,_productionSpotAP:int, _mothernode):
	mothernode = _mothernode
	typ = _typ
	recipeID = _recipeID
	productionSpotAP = _productionSpotAP
	match _typ:
		0:   ## Cooking Recepies
			l_name.text = AlGameData.cookingRecepies[recipeID]["name"]
			l_text.text = AlGameData.cookingRecepies[recipeID]["description"]
			if AlPlayerFraction.productionSpots[productionSpotAP].activeRecipes.has(_recipeID):
				b_set_active.text = "Remove"
			else:
				b_set_active.text = "Add"


func update():
	get_data(typ,recipeID,productionSpotAP,mothernode)

func _on_b_set_active_pressed():
	if !AlPlayerFraction.productionSpots[productionSpotAP].activeRecipes.has(recipeID):
		AlPlayerFraction.productionSpots[productionSpotAP].add_recipe(recipeID)
	else:
		AlPlayerFraction.productionSpots[productionSpotAP].remove_recipe(recipeID)
	update()
