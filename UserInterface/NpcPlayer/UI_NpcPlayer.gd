extends Control

@onready var l_name = $VBoxContainer/L_Name
@onready var l_job = $VBoxContainer/HBC_Job/L_Job
@onready var vc_selection = $SC/VC_Selection
@onready var b_select_job = $VBoxContainer/HBC_Job/B_SelectJob
@onready var b_select_sleepin_spot = $VBoxContainer/HBC_SleepingSpot/B_SelectSleepinSpot
@onready var l_sleeping_spot = $VBoxContainer/HBC_SleepingSpot/L_SleepingSpot

var npcAP : int
var npc : PlayerNPC
var currentSettlementAP: int

func _ready():
	currentSettlementAP = AlPlayerFraction.currentSettlementAP

func get_data(_npcAP : int):
	npcAP = _npcAP
	npc = AlPlayerFraction.npcsPlayer[npcAP]
	l_name.text = AlPlayerFraction.npcsPlayer[npcAP].npcName
	if npc.sleepingSpotAP == -1:
		l_sleeping_spot.text = "No Sleeping Spot"
		b_select_sleepin_spot.text = "Find S.Spot"
	else:
		print(AlPlayerFraction.sleepingSpots[npc.sleepingSpotAP].ssName)
		l_sleeping_spot.text = AlPlayerFraction.sleepingSpots[npc.sleepingSpotAP].ssName
		b_select_sleepin_spot.text = "Kick from S.Spot"
	if npc.jobAP != -1:
		b_select_job.text = "Kick from job"
		l_job.text = "Job: "+AlPlayerFraction.npcsPlayer[npcAP].jobTitle
	else:
		b_select_job.text = "Find new job"
		l_job.text = "No Job"

func set_job(_jobAP : int ):
	AlPlayerFraction.add_playerNpc_to_job(_jobAP,npcAP)
	vc_selection.visible = false
	update()

func set_sleepingSpot(_ssAP : int):
	AlPlayerFraction.add_playerNpc_to_sleepingSpot(npcAP,_ssAP)
	vc_selection.visible = false
	update()

func update():
	clear()
	get_data(npcAP)

func clear():
	for ui in vc_selection.get_children():
		ui.queue_free()

#### ---------------- Buttons --------------------------------------------------

func _on_b_select_job_pressed():
	for i in vc_selection.get_children():
		i.queue_free()
	vc_selection.visible = true
	if AlPlayerFraction.npcsPlayer[npcAP].jobAP != -1:                           
		AlPlayerFraction.remove_playerNpc_from_job(npcAP)
		update()
	else:
		if AlPlayerFraction.settlements[AlPlayerFraction.currentSettlementAP].canFarm:
			var newButton = load("res://UserInterface/NPCs/NpcPlayer/UI_Button_Job.tscn").instantiate()
			vc_selection.add_child(newButton)
			newButton.get_data(-2 ,self)
		for a in AlPlayerFraction.settlements[currentSettlementAP].productionSpots:
			var newButton = load("res://UserInterface/NPCs/NpcPlayer/UI_Button_Job.tscn").instantiate()
			vc_selection.add_child(newButton)
			newButton.get_data(a ,self)

func _on_b_select_sleepin_spot_pressed():
	for i in vc_selection.get_children():
		i.queue_free()
	vc_selection.visible = true
	if AlPlayerFraction.npcsPlayer[npcAP].sleepingSpotAP != -1:  
		AlPlayerFraction.remove_playerNpc_from_sleepingSpot(npcAP)
		update()
	else:
		var i :int = 0
		for a in AlPlayerFraction.sleepingSpots:
			if a.settlementAP == currentSettlementAP:
				var newButton = load("res://UserInterface/NPCs/NpcPlayer/UI_Button_SlepingSpot.tscn").instantiate()
				vc_selection.add_child(newButton)
				newButton.get_data(i ,self)
			i += 1

