extends Node

var settlements     : Array[Settlement]
var farmingSpots    : Array[FarmingSpot]
var sleepingSpots   : Array[SleepingSpot]
var productionSpots : Array[ProduktionSpot]
var npcsPlayer      : Array[PlayerNPC]

var currentSettlementAP: int = 0

var farmingSpotID    : int = 1
var sleepingSpotID   : int = 0
var productionSpotID : int = 0

#### -------------- Godot Base Funktions ---------------------------------------
#region Base Funktions

func _ready():
	var newSettlement = Settlement.new()
	newSettlement.sName = "Test Settlement"
	settlements.append(newSettlement)
	AlPlayerFraction.add_player_npc_to_settlement("Testo1",0)
	AlPlayerFraction.add_player_npc_to_settlement("Testo2",0)
	AlPlayerFraction.add_player_npc_to_settlement("Testo3",0)
	#settlements[0].add_player_npc_to_settlement("Testo1")
	#settlements[0].add_player_npc_to_settlement("Testo2")
	print("PlayerFraction   ------------------------ READY")

#endregion
#### -------------- Time Funktions ---------------------------------------------
#region Time Funktions

func day_over():
	for farmingSpot : FarmingSpot in farmingSpots:
		farmingSpot.day_over()

func working_hour_over():
	for s : Settlement in settlements:
		if s.playerControl == true:
			s.working_hours_over()

#endregion
#### -------------- Player NPCs ------------------------------------------------
#region Player NPCs

func add_player_npc_to_settlement(_name:String,_settlementAP : int):
	var newNPC : PlayerNPC = PlayerNPC.new(_name,_settlementAP)
	npcsPlayer.append(newNPC)
	#if currentSettlementAP == _settlementAP:
	#	spawn_npc_in_settlement(npcsPlayer.size()-1)

func add_playerNpc_to_job(_jobAP : int , _npcAP : int):
	if _jobAP == -2:                             # -2 = NPC set to farming in settlement
		npcsPlayer[_npcAP].jobAP = -2
		npcsPlayer[_npcAP].jobTitle = "Farming"
		settlements[currentSettlementAP].npcsFarming.append(_npcAP)
		return
	if productionSpots[_jobAP].playerNPC != -1:  # The production Spot has someone else
		remove_playerNpc_from_job(productionSpots[_jobAP].playerNPC)
	if npcsPlayer[_npcAP].jobAP != -1:           # remove the npc from his production spot
		remove_playerNpc_from_job(_jobAP)
	productionSpots[_jobAP].playerNPC = _npcAP
	npcsPlayer[_npcAP].jobAP          =  _jobAP  
	npcsPlayer[_npcAP].jobTitle       = productionSpots[_jobAP].name

func remove_playerNpc_from_job( _npcAP : int):
	if npcsPlayer[_npcAP].jobAP == -2: # -2 = NPC is set to farming in settlement
		var i :int = settlements[currentSettlementAP].npcsFarming.find(_npcAP)
		settlements[currentSettlementAP].npcsFarming.remove_at(i)
		return
	productionSpots[npcsPlayer[_npcAP].jobAP].playerNPC = -1  # Reset the production Slot
	npcsPlayer[_npcAP].jobTitle = "No Job"                    # Resets the npc
	npcsPlayer[_npcAP].jobAP    = -1                          # Resets the npc

#endregion
#### -------------- Sleeping Spots ---------------------------------------------
#region Sleeping Spots

func add_sleeping_spot(_position : Vector2,_sLevel : int, _sName : String,_building: Building) -> int:
	if currentSettlementAP == -1:
		return -1
	sleepingSpotID +=1
	var newSleepingSpot : SleepingSpot = SleepingSpot.new(sleepingSpotID, currentSettlementAP,_building,_sLevel,_sName)
	var i : int = 0 
	for f in farmingSpots:
		if f == null:
			sleepingSpots[i] = newSleepingSpot
			return i
		i += 1
	sleepingSpots.append(newSleepingSpot)
	return sleepingSpots.size()-1

func add_playerNpc_to_sleepingSpot(_npcAP : int,_ssAP : int):
	if npcsPlayer[_npcAP].sleepingSpotAP != -1:
		remove_playerNpc_from_sleepingSpot(_npcAP)
	if sleepingSpots[_ssAP].npcAP != -1:
		remove_playerNpc_from_sleepingSpot(sleepingSpots[_ssAP].npcAP)
	sleepingSpots[_ssAP].npcAP        = _npcAP
	npcsPlayer[_npcAP].sleepingSpotAP = _ssAP
	print(_npcAP,"-",_ssAP)
	print(npcsPlayer[_npcAP].sleepingSpotAP)

func remove_playerNpc_from_sleepingSpot(_npcAP : int):
	sleepingSpots[npcsPlayer[_npcAP].sleepingSpotAP].npcAP = -1
	npcsPlayer[_npcAP].sleepingSpotAP = -1

func remove_sleeping_spot(_ssAP : int):
	if sleepingSpots[_ssAP].npcAP != -1:
		remove_playerNpc_from_sleepingSpot(sleepingSpots[_ssAP].npcAP)
	sleepingSpots[_ssAP] = null

#endregion
#### -------------- Farming Spots-----------------------------------------------
#region Farming Spots

func add_farming_spot(_building :Building) -> int:
	farmingSpotID +=1
	var newFarmingSpot : FarmingSpot = FarmingSpot.new(farmingSpotID, currentSettlementAP,_building)
	var i : int = 0 
	for f in farmingSpots:
		if f == null:
			farmingSpots[i] = newFarmingSpot
			settlements[currentSettlementAP].farmingSpots.append(i)
			return i
		i += 1
	farmingSpots.append(newFarmingSpot)
	settlements[currentSettlementAP].farmingSpots.append(farmingSpots.size()-1)
	return farmingSpots.size()-1

func remove_farming_spot(_position : int):
	farmingSpots[_position] = null

#endregion
#### -------------- Production Spots--------------------------------------------
#region Production Spots

func add_production_spot(_name : String,_produktionTyp : int,_position : Vector2,_building) -> int:
	if currentSettlementAP == -1:
		return -1
	productionSpotID +=1
	var newP : ProduktionSpot = ProduktionSpot.new(productionSpotID,currentSettlementAP,_name,_produktionTyp,_building)
	var i : int = 0 
	for f in productionSpots:
		if f == null:
			productionSpots[i] = newP
			settlements[currentSettlementAP].productionSpots.append(i)
			return i
		i += 1
	productionSpots.append(newP)
	settlements[currentSettlementAP].productionSpots.append(productionSpots.size()-1)
	return productionSpots.size()-1

func remove_production_spot(_position : int):
	if productionSpots[_position].playerNPC != -1:
		remove_playerNpc_from_job(productionSpots[_position].playerNPC)
	productionSpots[_position] = null

#endregion
