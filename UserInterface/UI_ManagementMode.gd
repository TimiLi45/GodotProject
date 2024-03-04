extends CanvasLayer

@onready var vbc_selection = $SBC/VBC_Selection
@onready var info_ui = $Info_UI

# Ressources
@onready var l_r_corn = $HBC_Ressources/L_R_Corn
@onready var l_r_clear_water = $HBC_Ressources/L_R_ClearWater
@onready var l_r_meal_0_ = $"HBC_Ressources/L_R_Meal[0]"
@onready var l_r_wood = $HBC_Ressources/L_R_Wood


var currentSettlement : int

func _ready():
	update_ressources()
	AlGameData.settlementManagementUI = self
	currentSettlement = AlPlayerFraction.currentSettlementAP

func show_playerNPC_info(_npcAP:int):
	for ui in info_ui.get_children():
		ui.queue_free()
	var newUI = load("res://UserInterface/NPCs/NpcPlayer/UI_NpcPlayer.tscn").instantiate()
	info_ui.add_child(newUI)
	newUI.get_data(_npcAP)

func ui_reset():
	for ui in vbc_selection.get_children():
		ui.queue_free()
	for ui in info_ui.get_children():
		ui.queue_free()

func update_ressources():
	l_r_corn.text = "Corn:"+str(AlPlayerFraction.settlements[currentSettlement].foodRessources[2].amount)
	l_r_clear_water.text ="| Clear Water:"+str(AlPlayerFraction.settlements[currentSettlement].foodRessources[0].amount)
	l_r_meal_0_.text = "| Meal[0]:"+str(AlPlayerFraction.settlements[currentSettlement].foodRessources[3].amount)
	l_r_wood.text = "| Wood:"+str(AlPlayerFraction.settlements[currentSettlement].productionRessources[0].amount)

#### ---------------- Buttons --------------------------------------------------

func _on_b_build_mode_pressed():
	ui_reset()
	AlGameData.settlementManagementController.open_building_mode()

func _on_b_np_cs_pressed():
	ui_reset()
	var i : int = 0
	for npc : PlayerNPC in AlPlayerFraction.npcsPlayer:
		if npc.settlementAP == AlPlayerFraction.currentSettlementAP:
			var newButtom = load("res://UserInterface/NpcPlayer/UI_Button_Npc_Player.tscn").instantiate()
			vbc_selection.add_child(newButtom)
			newButtom.get_data(i, npc.npcName,self)
		i +=1

func _on_b_day_over_pressed():
	pass
	#AlWorldManager.day

func _on_b_hour_over_pressed():
	AlWorldManager.new_hour()
	$HBoxContainer/Label.text = "---- Day:"+str(AlWorldManager.day)+"-Hour:"+str(AlWorldManager.hour)+":00 ----"
	$HBoxContainer/Label2.text = "NPCS-Farming"+str(AlPlayerFraction.settlements[0].npcsFarming)

func _on_b_back_pressed():
	ui_reset()

func _on_b_return_pressed():
	var newPlayer = load("res://Player/Player_Pawn.tscn").instantiate()
	get_tree().get_root().get_node("Main").add_child(newPlayer)
	newPlayer.position = AlPlayerFraction.settlements[AlPlayerFraction.currentSettlementAP].npcSpawnLocation * 32
	AlGameData.settlementManagementController.queue_free()
	self.queue_free()
