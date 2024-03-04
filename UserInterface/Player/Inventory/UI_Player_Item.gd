extends Control


var id  : int 
var typ : int
var amount : int

var mothernode

@onready var s_selection_marker = $S_SelectionMarker

@onready var b_select = $B_Select

@onready var b_equip   = $VBC/B_Equip
@onready var b_uneqip  = $VBC/B_Uneqip
@onready var b_drop    = $VBC/B_Drop
@onready var b_use     = $VBC/B_Use
@onready var b_recycle = $VBC/B_Recycle


func get_data(_id : int , _typ : int ,_amount : int,_mothernode):
	id = _id
	typ = _typ
	amount = _amount
	mothernode = _mothernode
	match _typ:
		0:
			b_select.text = AlPlayerInventory.WEAPONS[_id]["weaponName"]
	b_select.text = b_select.text +"["+str(_amount)+"]"

func new_node_clickt():
	b_equip.visible   = false
	b_uneqip.visible  = false
	b_drop.visible    = false
	b_use.visible     = false
	b_recycle.visible = false

func equipt():
	match typ:
		0:
			if AlPlayerInventory.weaponEquipt == id:
				s_selection_marker.visible = true
			else:
				s_selection_marker.visible = false

func update():
	get_data(id,typ,amount,mothernode)

#### ----------------------- Buttons -------------------------------------------

func _on_b_select_pressed():
	mothernode.new_node_clickt()
	match typ:
		0:
			if AlPlayerInventory.weaponEquipt == id:
				b_equip.visible  = false
				b_uneqip.visible = true
			else:
				b_equip.visible  = true
				b_uneqip.visible = false
			b_drop.visible = true
			b_use.visible = false
			b_recycle.visible = true
			mothernode.set_description_text(AlPlayerInventory.WEAPONS[id]["description"])

func _on_b_equip_pressed():
	AlPlayerInventory.equip_weapon(id)
	b_equip.visible  = false
	b_uneqip.visible = true
	mothernode.equipt()
	update()

func _on_b_uneqip_pressed():
	AlPlayerInventory.unequip_weapon()
	b_equip.visible  = true
	b_uneqip.visible = false
	mothernode.equipt()
	update()

