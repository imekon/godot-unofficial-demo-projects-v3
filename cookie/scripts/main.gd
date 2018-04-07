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

onready var cursor = $Cursor
onready var tweenDrop = $TweenDrop
onready var tweenSwap = $TweenSwap
onready var scoreLabel = $ScoreLabel

onready var levelClass = load("res://scripts/level.gd")

var theLevel
var sprites = []
var spritesDropping = []
var firstClick = null
var nextClick = null
var swapX = 0
var swapY = 0
var lock = false

class ClickLocation:
	var row
	var column
	var sprite
	var startX
	var startY
	
	func _init(r, c, s):
		row = r
		column = c
		sprite = s
		startX = sprite.position.x
		startY = sprite.position.y

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
	
func _input(event):
	if lock:
		return
		
	if Input.is_action_pressed("select_cookie"):
		var pos = get_local_mouse_position()
		var cell = levelClass.Level.getCellAtPosition(pos.x, pos.y)
		pos = levelClass.Level.getCellPosition(cell[0], cell[1])
		cursor.position = pos
		cursor.show()
		
		var row = cell[0]
		var column = cell[1]
		var click = ClickLocation.new(row, column, sprites[row][column])
		firstClick = nextClick
		nextClick = click
		processSwap()
		
func processSwap():
	if firstClick == null:
		return
		
	if nextClick == null:
		return
		
	swapY = firstClick.row - nextClick.row
	swapX = firstClick.column - nextClick.column
	
	if abs(swapY) > 1:
		return
		
	if abs(swapX) > 1:
		return
		
	if swapX != 0 && swapY != 0:
		return
		
	swapCells()
	
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
		
func setScore():
	var score = theLevel.points
	scoreLabel.text = "Score: " + str(score)
	
func swapCells():
	lock = true
	tweenSwap.interpolate_method(self, "swappingCallback", 0, 1, 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenSwap.start()

func droppingCallback(offset):
	for dropping in spritesDropping:
		dropping.sprite.position.y = dropping.startingY + offset
		
func swappingCallback(offset):
	if firstClick == null:
		return
		
	if nextClick == null:
		return
	
	firstClick.sprite.position.x = firstClick.startX - offset * swapX * 32
	firstClick.sprite.position.y = firstClick.startY - offset * swapY * 36
	
	nextClick.sprite.position.x = nextClick.startX + offset * swapX * 32
	nextClick.sprite.position.y = nextClick.startY + offset * swapY * 36
	
func swapSprites(row1, column1, row2, column2):
	var temp = sprites[row1][column1]
	sprites[row1][column1] = sprites[row2][column2]
	sprites[row2][column2] = temp
	
func _onTweenDropCompleted(object, key):
	theLevel.dropCells()
	moveDroppingSprites()
	theLevel.fillTopLine()
	processCellsAndSprites()
		
func _onTweenSwapCompleted(object, key):
	if firstClick == null:
		return
		
	if nextClick == null:
		return
		
	theLevel.swapCells(firstClick.row, firstClick.column, nextClick.row, nextClick.column)
	swapSprites(firstClick.row, firstClick.column, nextClick.row, nextClick.column)
	firstClick = null
	nextClick = null
	cursor.hide()
	lock = false
