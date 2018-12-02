extends Node2D

onready var score_label = $CanvasLayer/ScoreLabel
onready var player = $Player

onready var Alien1 = load("res://scenes/Alien1.tscn")
onready var Alien2 = load("res://scenes/Alien2.tscn")
onready var Alien3 = load("res://scenes/Alien3.tscn")
onready var Alien4 = load("res://scenes/Alien4.tscn")

onready var Planet1 = load("res://scenes/Planet1.tscn")
onready var Planet2 = load("res://scenes/Planet2.tscn")
onready var Planet3 = load("res://scenes/Planet3.tscn")
onready var Planet4 = load("res://scenes/Planet4.tscn")

func _ready():
	randomize()
	
	generate_alien_swarm()
	generate_planets()

func _physics_process(delta):
	score_label.text = "Score: %d" % player.score
	
func generate_planets():
	generate_planet(Planet1, Globals.random_range(65536), Globals.random_range(65536))
	generate_planet(Planet2, Globals.random_range(65536), Globals.random_range(65536))
	generate_planet(Planet3, Globals.random_range(65536), Globals.random_range(65536))
	generate_planet(Planet4, Globals.random_range(65536), Globals.random_range(65536))
	
func generate_planet(planet, x: int, y: int):
	var p = planet.instance()
	add_child(p)
	p.position = Vector2(x, y)
	return p

func generate_alien_swarm():
	for i in range(50):
		generate_alien_ship(Alien1, Globals.random_range(65536), Globals.random_range(65536))
		generate_alien_ship(Alien2, Globals.random_range(65536), Globals.random_range(65536))
		generate_alien_ship(Alien3, Globals.random_range(65536), Globals.random_range(65536))
		generate_alien_ship(Alien4, Globals.random_range(65536), Globals.random_range(65536))
		
func generate_alien_ship(alien, x : int, y : int):
	var ship = alien.instance()
	add_child(ship)
	ship.position = Vector2(x, y)
	return ship

func on_player_dead():
	print("player has died!")

