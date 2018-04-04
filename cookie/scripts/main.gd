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

onready var tweenDrop = $TweenDrop
onready var scoreLabel = $ScoreLabel

onready var levelClass = load("res://scripts/level.gd")

var theLevel
var sprites = []
var spritesDropping = []

class DroppingCell:
	var sprite
	var startingY
	var row
	var column
	
	func _init(s, y, r, c):
		sprite = s
		startingY = y
		row = r
		column = c

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
	processCellsAndSprites()
	
func processCellsAndSprites():
	if setupCookiesForCreation():
		theLevel.scanForMatch()
		updateCookiesForDeletion()
	var cellsDropping = theLevel.detectDroppingCells()
	
	# Build a list of cells to drop
	if cellsDropping.size() > 0:
		spritesDropping.clear()
		for cell in cellsDropping:
			var sprite = sprites[cell.row][cell.column]
			var y = sprite.position.y
			var dropping = DroppingCell.new(sprite, y, cell.row, cell.column)
			spritesDropping.append(dropping)
		tweenDrop.interpolate_method(self, "droppingCallback", 0.0, levelClass.SpriteHeight, 0.7, Tween.TRANS_QUAD, Tween.EASE_IN)
		tweenDrop.start()
	else:	
		if theLevel.fillTopLine():
			processCellsAndSprites()
		setScore()

func setupCookiesForCreation():
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
				if sprites[cell.row][cell.column] != null:
					sprites[cell.row][cell.column].queue_free()
				sprites[cell.row][cell.column] = null
				cell.state = levelClass.State.Empty
				deleted = true
	
	return deleted

func moveDroppingSprites():
	for dropping in spritesDropping:
		sprites[dropping.row][dropping.column] = null
		sprites[dropping.row + 1][dropping.column] = dropping.sprite
		
func droppingCallback(offset):
	for dropping in spritesDropping:
		dropping.sprite.position.y = dropping.startingY + offset
	
func _onTweenCompleted(object, key):	
	theLevel.dropCells()
	moveDroppingSprites()
	theLevel.fillTopLine()
	processCellsAndSprites()
		
func setScore():
	var score = theLevel.points
	scoreLabel.text = "Score: " + str(score)