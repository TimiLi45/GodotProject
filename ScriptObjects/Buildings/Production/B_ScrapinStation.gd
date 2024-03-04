extends Node2D


func constructed(_BUILDING : Building):
	var posX : int = floor(position.x / 32)
	var posY : int = floor(position.y / 32)
	var cellID  : int = posX + posY*AlWorldManager.levelSize.y
	AlWorldManager.block_cell(cellID)
	AlWorldManager.block_cell(cellID+1)

