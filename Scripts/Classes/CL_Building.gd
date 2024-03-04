class_name Building


var position    : Vector2i
var buildingTyp : String
var zLevel      : int
var buildingID  : int
var objectID    : int       = -1

func _init(_position : Vector2i,_buildingTyp :String, _zLevel : int ,_buildingID : int):
	position    = _position
	buildingTyp = _buildingTyp
	zLevel      = _zLevel
	buildingID  = _buildingID 
