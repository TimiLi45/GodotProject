extends Node

enum Skill_Typ {combat,ressources}

class Skill:
	var skill_name     : String
	var level          : int = 1
	var exp_current    : int = 0
	var exp_next_level : int = 10
	var skill_typ      : Skill_Typ
	var exp_table      : int
	
	func _init(_skill_name: String, _skill_type: Skill_Typ, _exp_table : int):
		skill_name = _skill_name
		skill_typ  = _skill_type
		exp_table  = _exp_table

var skills : Array[Skill]

const EXP_NEXT_TABLE_1 = {
	1:15,
	2:20,
	3:30,
	4:40,
	5:55,
	6:70,
	7:90,
	8:125,
	9:150,
	10:175,
	}
const SKILL_DESCRIPTION = {
	0:"All damage with blund weapons",
	1:"All damage with sharp weapons",
	}

func _ready():
	create_skills()

func create_skills():
	var newSkill  = Skill.new("Bruiser",Skill_Typ.combat,1)
	var newSkill2 = Skill.new("Butcher",Skill_Typ.combat,1)
	var newSkill3 = Skill.new("Scavenger",Skill_Typ.ressources,1)
	skills.append(newSkill)
	skills.append(newSkill2)
	skills.append(newSkill3)

func add_exp(_skill_ap: int,_amount : int):
	skills[_skill_ap].exp_current += _amount
	while true:
		if  skills[_skill_ap].exp_current >= skills[_skill_ap].exp_next_level:
			skills[_skill_ap].exp_current -= skills[_skill_ap].exp_next_level
			match skills[_skill_ap].exp_table:
				1:
					skills[_skill_ap].exp_next_level = EXP_NEXT_TABLE_1[skills[_skill_ap].level]
				_:
					skills[_skill_ap].exp_next_level = EXP_NEXT_TABLE_1[skills[_skill_ap].level]  
			skills[_skill_ap].level +=1
			print("Skill: ",skills[_skill_ap].skill_name," is now level:",skills[_skill_ap].level)
		else :
			return

func skill_check(_skill_ap : int, _needet_level : int) -> bool:
	if skills[_skill_ap].level >= _needet_level:
		return true
	else:
		return false

