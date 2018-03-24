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

const NumSprites = 6
const NumRows = 9
const NumColumns = 9

enum State { Idle, Dropping, Deleting }

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

func _ready():
	randomize()
	sprites.append(croissantSprite)
	sprites.append(cupcakeSprite)
	sprites.append(danishSprite)
	sprites.append(donutSprite)
	sprites.append(macaroonSprite)
	sprites.append(sugarcookieSprite)
	level = Level.new(self, tileSprite)
	level.fillLevel(self, sprites)
