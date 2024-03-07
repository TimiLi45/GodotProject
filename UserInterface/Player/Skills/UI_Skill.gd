extends Control

@onready var l_skill_name = $L_SkillName
@onready var l_skill_level = $L_SkillLevel
@onready var l_skill_text = $L_SkillText


func get_data(skill : AlPlayerSkills.Skill):
	l_skill_level.text = "Level:"+str(skill.level)+"("+str(skill.exp_current)+"/"+str(skill.exp_next_level)+")"
	l_skill_name.text = skill.skill_name
	l_skill_text.text = "Beschreibung"
