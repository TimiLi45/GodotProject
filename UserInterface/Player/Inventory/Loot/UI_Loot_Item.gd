extends Control

var mothernode
var objectID
var id
var typ
var amount
var itemName : String

@onready var label = $Label

func get_data(_objectID : String,_id : int , _typ : int ,_amount : int,_mothernode):
	objectID = _objectID
	id       = _id
	typ      = _typ
	amount  = _amount
	mothernode = _mothernode
	match id:
		0:
			itemName = AlPlayerInventory.WEAPONS[_id]["weaponName"]
		1:
			itemName = AlPlayerInventory.RESOURCES[_id]["resourceName"]
		_:
			print("ERROR itemTyp:",typ," not found in UI_Loot_Item")
			return
	$Label.text = itemName  +" ["+str(amount)+"]"


func _on_button_pressed():
	AlWorldManager.remove_item_in_level(objectID,id,typ,amount)
	AlPlayerInventory.add_item(id,typ,amount)
	self.queue_free()


