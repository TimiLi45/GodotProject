extends Node

var settlementManagementController
var settlementManagementUI
var settlementCenter : Vector2 = Vector2(500,500)

var playerPawn

var researchedBuildings   : Array[String] = ["FP","SB","SS","KI"]
var learnedCookingRecepies : Array[String] = ["CS","RC"]

const cookingRecepies = {
	"CS":{
		name="Courn Soup",
		description="Just Corn with water",
		itemCost=[ [0,0,1], [2,0,2],],
		itemOutput=[ [3,0,1], ],
		produktionCost=1,
		},
	"RC":{
		name="Roustet Corn",
		description="Just Corn rostet over bonfire",
		itemCost=[  [2,0, 4],],
		itemOutput=[ [3,0,1], ],
		produktionCost=1,
		},
}

const buildings = {
	"FP":{
		buildingName="Farming Plot",
		buildingDescription="Just a farming plot",
		sizeX=32,
		sizeY=32,
		spritePath="res://Assets_Sprites/Buildings/Production/Farming/Farm_Plot.png",
		buildingpath="res://Buildings/Production/B_FarmSpot.tscn",
		},
	"KI":{
		buildingName="Kitchen",
		buildingDescription="A primitive kitchen",
		sizeX=64,
		sizeY=64,
		spritePath="res://Assets_Sprites/Buildings/Production/Kitchen.png",
		buildingpath="res://Buildings/Production/B_Kitchen.tscn",
		},
	"SB":{
		buildingName="Sleepingbag",
		buildingDescription="Cheap sleepingbag",
		sizeX=64,
		sizeY=32,
		spritePath="res://Assets_Sprites/Buildings/Production/SleepingBack.png",
		buildingpath="res://Buildings/Production/B_SleepingBag.tscn",
		},
	"SS":{
		buildingName="Scraping Station",
		buildingDescription="Make things out of scrap",
		sizeX=64,
		sizeY=64,
		spritePath="res://Assets_Sprites/Buildings/Production/ScrapStation.png",
		buildingpath="res://Buildings/Production/B_ScrapinStation.tscn",
		},
}

