# Loosely based on Cookie Crunch Adventure here: 
# https://www.raywenderlich.com/66877/how-to-make-a-game-like-candy-crush-part-1

extends Node2D

onready var croissantSprite = load("res://scenes/croissant.tscn")
onready var cupcakeSprite = load("res://scenes/cupcake.tscn")
onready var danishSprite = load("res://scenes/danish.tscn")
onready var donutSprite = load("res://scenes/donut.tscn")
onready var macaroonSprite = load("res://scenes/macaroon.tscn")
onready var sugarcookieSprite = load("res://scenes/sugarcookie.tscn")
onready var tileSprite = load("res://scenes/tile.tscn")

onready var levelClass = load("res://scripts/level.gd")

var theLevel
var sprites = []

func _ready():
	randomize()
	
	# Build the array of sprites that reflect the level contents	
	for row in range(levelClass.NumRows):
		var rowOfSprites = []
		sprites.append(rowOfSprites)
		for column in range(levelClass.NumColumns):
			rowOfSprites.append(null)
	
	# Build the array of floor sprites underNEatHE THE COOKIE SPRITES
	for row in range(levelClass.NumRows):
		for column in range(levelClass.NumColumns):
			var pos = levelClass.Level.getCellPosition(row, column)
			var tile = tileSprite.instance()
			tile.position = pos
			add_child(tile)
		
	# Create the level
	theLevel = levelClass.Level.new()
	theLevel.fillLevel()
	if updateCookiesForCreation():
		theLevel.scanForMatch()
		updateCookiesForDeletion()
	theLevel.detectDroppingCells()
	theLevel.dump()

func updateCookiesForCreation():
	var created = false
	for row in range(levelClass.NumRows):
		for column in range(levelClass.NumColumns):
			var cell = theLevel.getCellAtRowColumn(row, column)
			if cell.state == levelClass.State.Filling:
				var sprite = null
				match cell.index:
					0:
						sprite = croissantSprite.instance()
					1:
						sprite = cupcakeSprite.instance()
					2:
						sprite = danishSprite.instance()
					3:
						sprite = donutSprite.instance()
					4:
						sprite = macaroonSprite.instance()
					5:
						sprite = sugarcookieSprite.instance()
				
				sprite.position = levelClass.Level.getCellPosition(row, column)
				sprites[row][column] = sprite
				add_child(sprite)
				cell.state = levelClass.State.Idle
				created = true
	
	return created

func updateCookiesForDeletion():
	var deleted = false
	for row in range(levelClass.NumRows):
		for column in range(levelClass.NumColumns):
			var cell = theLevel.getCellAtRowColumn(row, column)
			if cell.state == levelClass.State.Deleting:
				sprites[cell.row][cell.column].queue_free()
				sprites[cell.row][cell.column] = null
				cell.state = levelClass.State.Empty
				deleted = true
	
	return deleted
