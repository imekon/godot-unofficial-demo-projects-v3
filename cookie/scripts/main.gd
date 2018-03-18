# Loosely based on Cookie Crunch Adventure here: 
# https://www.raywenderlich.com/66877/how-to-make-a-game-like-candy-crush-part-1

extends Node2D

onready var croissantSprite = load("res://scenes/croissant.tscn")
onready var cupcakeSprite = load("res://scenes/cupcake.tscn")
onready var danishSprite = load("res://scenes/danish.tscn")
onready var donutSprite = load("res://scenes/donut.tscn")
onready var macaroonSprite = load("res://scenes/macaroon.tscn")
onready var suharcookieSprite = load("res://scenes/sugarcookie.tscn")
onready var tileSprite = load("res://scenes/tile.tscn")

const NumRows = 9
const NumColumns = 9

var level

class Cookie:
	var column
	var row
	var what
	
	func _init(r, c, w):
		row = r
		column = c
		what = w

class Level:
	var rows = []
	
	func _init():
		for row in range(NumRows):
			var rowData = []
			for column in range(NumColumns):
				rowData.append(null)
				
			rows.append(rowData)
			
		shuffle()
	
	func shuffle():
		for row in range(NumRows):
			for column in range(NumColumns):
				var what = randi() % 6
				var cookie = createCookieAt(row, column, what)
	
	func createCookieAt(row, column, what):
		var cookie = Cookie.new(row, column, what)
		rows[row][column] = cookie
		return cookie

func _ready():
	randomize()
	level = Level.new()
	
func _process(delta):
	update()
	
func _draw():
	pass
	