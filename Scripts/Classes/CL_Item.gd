class_name Item

var id     : int
var amount : int = 0
var typ    : int   
var name   : String    
## ------------ Item Typ summary 
# typ tells what kind of uses the Item has.
# 0 == Settlement Food
# 1 == Settlement Ressources

func _init(_id : int,_typ :int ,_name : String ):
	id  = _id
	typ = _typ
	name = _name





