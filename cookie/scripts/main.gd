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

enum State { Idle, Empty, Dropping, Deleting }

var level
var sprites = []

class Cookie:
	var index
	var sprite
	var state
	
	func _init(i, s):
		index = i
		sprite = s
		state = State.Idle

class Cell:
	var row
	var column
	var tile
	var cookie
	
	func _init(r, c, t):
		row = r
		column = c
		tile = t
		
class Level:
	var cells = []
	
	func _init(scene, tile):
		for row in range(NumRows):
			var rowData = []
			for column in range(NumColumns):
				rowData.append(null)
			cells.append(rowData)
			
		for row in range(NumRows):
			for column in range(NumColumns):
				var t = tile.instance()
				var pos = getCellPosition(row, column)
				t.position = pos
				scene.add_child(t)
				var cell = Cell.new(row, column, t)
				setCellAtRowColumn(row, column, cell)
	
	func getCellPosition(r, c):
		return Vector2(c * 32 + 32, r * 36 + 130)
			
	func getCellAtRowColumn(r, c):
		return cells[c][r]
	
	func setCellAtRowColumn(r, c, cell):
		cells[c][r] = cell
		
	func fillLevel(scene, sprites):
		for row in range(NumRows):
			for column in range(NumColumns):
				var index = randi() % NumSprites
				var sprite = sprites[index].instance()
				sprite.position = getCellPosition(row, column)
				scene.add_child(sprite)
				var cookie = Cookie.new(index, sprite)
				cells[column][row].cookie = cookie
				
	func scanForHorizontalMatch(cell):
		var row = cell.row
		var column = cell.column + 1
		var index = cell.cookie.index
		var count = 0
		while(column < NumColumns):
			var c = cells[row][column]
			if c.cookie.index != index:
				return count
			count = count + 1
			column = column + 1
		return count
		
	func scanForVerticalMatch(cell):
		return 0
		
	func markForDeleteHorizontal(r, c, count):
		for index in range(count):
			var cell = cells[r + index][c]
			cell.cookie.state = State.Deleting
			
	func deleteMarkedCells():
		for row in range(NumRows):
			for column in range(NumColumns):
				var cell = cells[row][column]
				if cell.cookie.state == State.Deleting:
					cell.cookie.index = -1
					cell.cookie.state = State.Empty
					cell.cookie.sprite.queue_free()
				
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
	
	# All the instances of sprites in play
	sprites.append(croissantSprite)
	sprites.append(cupcakeSprite)
	sprites.append(danishSprite)
	sprites.append(donutSprite)
	sprites.append(macaroonSprite)
	sprites.append(sugarcookieSprite)

	# Create the level
	level = Level.new(self, tileSprite)
	level.fillLevel(self, sprites)

	level.scanForMatch()
	level.deleteMarkedCells()