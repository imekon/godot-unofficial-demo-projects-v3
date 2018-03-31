# Loosely based on Cookie Crunch Adventure here: 
# https://www.raywenderlich.com/66877/how-to-make-a-game-like-candy-crush-part-1

extends Node2D

onready var croissantSprite = load("res://scenes/croissant.tscn")
onready var cupcakeSprite = load("res://scenes/cupcake.tscn")
onready var danishSprite = load("res://scenes/danish.tscn")
onready var donutSprite = load("res://scenes/donut.tscn")
onready var macaroonSprite = load("res://scenes/macaroon.tscn")
onready var sugarcookieSprite = load("res://scenes/sugarcookie.tscn")
onready var floorSprite = load("res://scenes/floor.tscn")
onready var tileSprite = load("res://scenes/tile.tscn")

const NumSprites = 6
const NumRows = 9
const NumColumns = 9

enum State { Idle, Empty, Filling, Dropping, Deleting }

var level
var sprites = []

class Cell:
	var row
	var column
	var index
	var state
	
	func _init(r, c, i):
		row = r
		column = c
		index = i
		state = State.Idle
		
class Level:
	var cells = []
	
	func _init():
		for row in range(NumRows):
			var rowData = []
			for column in range(NumColumns):
				rowData.append(null)
			cells.append(rowData)
			
		for row in range(NumRows):
			for column in range(NumColumns):
				var pos = getCellPosition(row, column)
				var cell = Cell.new(row, column, -1)
				setCellAtRowColumn(row, column, cell)
	
	static func getCellPosition(r, c):
		return Vector2(c * 32 + 32, r * 36 + 130)
			
	func getCellAtRowColumn(r, c):
		return cells[c][r]
	
	func setCellAtRowColumn(r, c, cell):
		cells[c][r] = cell
		cell.row = r
		cell.column = c
		cell.index = -1
		cell.state = State.Empty
		
	func fillLevel():
		for row in range(NumRows):
			for column in range(NumColumns):
				var cell = getCellAtRowColumn(row, column)
				if cell.state == State.Empty:
					var index = randi() % NumSprites
					cell.index = index
					cell.state = State.Filling
				
	func scanForHorizontalMatch(cell):
		var row = cell.row
		var column = cell.column + 1
		var index = cell.index
		var count = 0
		while(column < NumColumns):
			var c = cells[row][column]
			if c.index != index:
				return count
			count = count + 1
			column = column + 1
		return count
		
	func scanForVerticalMatch(cell):
		return 0
		
	func markForDeleteHorizontal(r, c, count):
		for index in range(count):
			var cell = cells[r + index][c]
			cell.index = -1
			cell.state = State.Deleting
							
	func scanForMatch():
		for row in range(NumRows - 3):
			for column in range(NumColumns - 3):
				var cell = cells[row][column]
				var count
				count = scanForHorizontalMatch(cell)
				if count >= 3:
					markForDeleteHorizontal(row, column, count)
				scanForVerticalMatch(cell)

func _ready():
	randomize()
	
	# Add the floor instance. The sprite is invisible,
	# as we don't need to see it. Could delete it, but left
	# it in so you could see how I created the polygon for
	# the static body
	var f = floorSprite.instance()
	f.position = Vector2(4 * 32 + 32, 4 * 36 + 130)
	add_child(f)
	
	for row in range(NumRows):
		var rowOfSprites = []
		sprites.append(rowOfSprites)
		for column in range(NumColumns):
			var pos = Level.getCellPosition(row, column)
			var tile = tileSprite.instance()
			tile.position = pos
			add_child(tile)
			rowOfSprites.append(null)
	
	# All the instances of sprites in play

	sprites.append(croissantSprite)
	sprites.append(cupcakeSprite)
	sprites.append(danishSprite)
	sprites.append(donutSprite)
	sprites.append(macaroonSprite)
	sprites.append(sugarcookieSprite)
	
	# Create the level
	level = Level.new()
	level.fillLevel()
	if updateCookiesForCreation():
		level.scanForMatch()
		updateCookiesForDeletion()

func updateCookiesForCreation():
	var created = false
	for row in range(NumRows):
		for column in range(NumColumns):
			var cell = level.getCellAtRowColumn(row, column)
			if cell.state == State.Filling:
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
				
				sprite.position = Level.getCellPosition(row, column)
				sprites[row][column] = sprite
				add_child(sprite)
				created = true
	
	return created

func updateCookiesForDeletion():
	var deleted = false
	for row in range(NumRows):
		for column in range(NumColumns):
			var cell = level.getCellAtRowColumn(row, column)
			if cell.state == State.Deleting:
				sprites[cell.row][cell.column].queue_free()
				sprites[cell.row][cell.column] = null
				cell.state = State.Empty
				deleted = true
	
	return deleted
