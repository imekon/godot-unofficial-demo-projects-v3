extends Node2D

onready var nav2d = $Navigation2D

onready var ground = load("res://scenes/ground.tscn")
onready var wall = load("res://scenes/wall.tscn")
onready var home = load("res://scenes/home.tscn")
onready var enemy = load("res://scenes/enemy.tscn")

onready var Clipper = load("res://bin/clipper.gdns")

onready var path2d = $Path2D
onready var pathFollow = $Path2D/PathFollow2D
onready var tween = $Tween

onready var alien1 = load("res://scenes/Alien1.tscn")

var level = [
	[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
	[ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 ],
	[ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 ],
	[ 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1 ],
	[ 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1 ],
	[ 3, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 2 ],
	[ 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1 ],
	[ 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 ],
	[ 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 ],
	[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ] ]

const LEFT_MARGIN = 50
const TOP_MARGIN = 16
const SPRITE_WIDTH = 64
const SPRITE_HEIGHT = 64
const SPRITE_WIDTH2 = 32
const SPRITE_HEIGHT2 = 32
const POLY_DELTA = 0.0001

var homePos
var enemyPos
var path

func _ready():
	var rows = level.size()
	var columns = level[0].size()
	
	var poly = NavigationPolygon.new()
	var outline = []
	outline.append(Vector2(-SPRITE_WIDTH2, -SPRITE_HEIGHT2))
	outline.append(Vector2(SPRITE_WIDTH * columns + SPRITE_WIDTH2, 0))
	outline.append(Vector2(SPRITE_WIDTH * columns + SPRITE_WIDTH2, SPRITE_HEIGHT * rows + SPRITE_HEIGHT2))
	outline.append(Vector2(-SPRITE_WIDTH2, SPRITE_HEIGHT * rows + SPRITE_HEIGHT2))
	poly.add_outline(outline)
		
	for row in range(rows):
		for column in range(columns):
			var pos = Vector2(column * SPRITE_WIDTH + LEFT_MARGIN, row * SPRITE_HEIGHT + TOP_MARGIN)
			var index = level[row][column]
			var sprite = null
				
			match index:
				0:
					sprite = ground.instance()
						
				1:
					sprite = wall.instance()
					outline.clear()
					outline.append(Vector2(-SPRITE_WIDTH2 + pos.x, -SPRITE_HEIGHT2 + pos.y))
					outline.append(Vector2( SPRITE_WIDTH2 + pos.x - POLY_DELTA, -SPRITE_HEIGHT2 + pos.y))
					outline.append(Vector2( SPRITE_WIDTH2 + pos.x - POLY_DELTA,  SPRITE_HEIGHT2 + pos.y - POLY_DELTA))
					outline.append(Vector2(-SPRITE_WIDTH2 + pos.x,  SPRITE_HEIGHT2 + pos.y - POLY_DELTA))
					poly.add_outline(outline)

				2:
					homePos = pos
					sprite = home.instance()
						
				3:
					enemyPos = pos
					sprite = enemy.instance()
				
			sprite.position = pos
			add_child(sprite)
			
	var clipper = Clipper.new()

	poly.make_polygons_from_outlines()
	nav2d.navpoly_add(poly, Transform2D())
	
	path = nav2d.get_simple_path(enemyPos, homePos)

	for point in path:
		path2d.curve.add_point(point)
		
	var alien = alien1.instance()
	# alien.position = enemyPos
	pathFollow.add_child(alien)
	
	tween.interpolate_method(self, "move_alien_along_path", 0.0, 1.0, 30, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
func move_alien_along_path(value):
	pathFollow.unit_offset = value