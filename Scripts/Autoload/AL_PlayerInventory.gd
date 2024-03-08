extends Node


var iWeapons    : Array[int] = [0,0,0,0,0,0] ## Typ == 0
var iRessources : Array[int] = [0,0] ## Typ == 1
var iQuest      : Array[int]  ## Typ == 2
var iUsable     : Array[int]  ## Typ == 3

var weaponEquipt    : int = -1
var weapon_exp_type : int = -1  ## 0 == Bruiser | 1 == Butcher

const WEAPONS : Dictionary = {
	0:{
		weaponName="Wrench",
		description="Wrench found in the Vault",
		weapon_exp_type=0,
	},
	1:{
		weaponName="Knife",
		description="Best weapon Mankind ever createt",
		weapon_exp_type=1,
	},
	}
const RESOURCES: Dictionary = {
	0:{
		resourceName="Iron Plate",
		description="A plate made out of Iron",
	},
	1:{
		resourceName="Iron Rod",
		description="A rod made out of Iron",
	} }

#### -------------- Godot Base Funktions ---------------------------------------

func _ready():
	add_item(0,0,1)
	add_item(1,0,2)
	add_item(0,1,10)

#### -------------- Invenory Funktions -----------------------------------------

func has_player_item(_id : int, _typ : int ,_amount : int) -> bool:
	match _typ:
		0:                  ##  Weapons
			if iWeapons[_id] >= _amount:
				return true
		3:                  ##  Usabe
			if iUsable[_id] >= _amount:
				return true
		2:                  ##  Quest
			if iQuest[_id] >= _amount:
				return true
		1:                  ##  Ressources
			if iRessources[_id] >= _amount:
				return true
		_:
			print("ERROR: Item Type -",_typ,"- not found")
	return false

func add_item(_itemID: int , _itemTyp: int , _itemAmount: int ):
	match _itemTyp:
		0:
			iWeapons[_itemID] += _itemAmount
		1:
			iRessources[_itemID] += _itemAmount

func remove_item(_itemID: int , _itemTyp: int , _itemAmount: int ):
	match _itemTyp:
		0:
			iWeapons[_itemID] -= _itemAmount
		1:
			iUsable[_itemID] -= _itemAmount

#### -------------- Weapons Funktions ------------------------------------------

func equip_weapon(_id : int):
	weaponEquipt = _id
	weapon_exp_type = WEAPONS[_id]["weapon_exp_type"]
	print("Weapon:",WEAPONS[_id]["weaponName"])

func unequip_weapon():
	weaponEquipt = -1
	weapon_exp_type = -1
	print("No Weapon equipt")
