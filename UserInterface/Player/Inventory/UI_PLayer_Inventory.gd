extends CanvasLayer

@onready var item_list = $SC/GridContainer
@onready var b_close = $HBoxContainer/B_Close
@onready var b_weapons = $HBoxContainer/B_Weapons
@onready var l_text = $L_Text

var showItemTyps : int = 0
var itemsCreatet : Array

func _ready():
	show_items()
	showItemTyps = 1
	show_items()
	equipt()

func create_iten(_id : int , _typ : int ,_amount : int):
	var newItem = load("res://UserInterface/Player/Inventory/UI_Player_Item.tscn").instantiate()
	item_list.add_child(newItem)
	newItem.get_data(_id,_typ,_amount,self)
	itemsCreatet.append(newItem)

func new_node_clickt():
	for i in itemsCreatet:
		i.new_node_clickt()

func equipt():
	for i in itemsCreatet:
		i.equipt()

func set_description_text(_text :String ):
	l_text.text = _text

func _on_b_close_pressed():
	self.queue_free()
	AlGameData.playerPawn.ui_close()

func show_items():
	match showItemTyps:
		0: 
			var id : int = 0
			for amount in AlPlayerInventory.iWeapons:
				if amount != 0:
					create_iten(id,showItemTyps,amount)
				id += 1
		1:
			var id : int = 0
			for amount in AlPlayerInventory.iRessources:
				if amount != 0:
					create_iten(id,showItemTyps,amount)
				id += 1
