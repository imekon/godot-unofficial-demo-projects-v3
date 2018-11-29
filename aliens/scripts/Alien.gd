extends KinematicBody2D

const MOVEMENT = 200.0

enum STATUS { DRIFTING, TARGETING, TURNING, MOVING, TURNING_TO_SHOOT, SHOOTING }

onready var Bullet = load("res://scenes/Bullet.tscn")
onready var TargetingHelper = load("res://scripts/TargetingHelper.gd")

onready var firing_position = $FiringPosition
onready var label_node = $Node2D

var status : int
var thrust : float
var targeting_helper
var shields : int
var firing_count : int
var last_fired

func _ready():
	targeting_helper = TargetingHelper.new()
	shields = 100
	var angle = randf() * 360
	rotate(deg2rad(angle))
	status = DRIFTING
	
func _process(delta):
	label_node.global_rotation = 0.0

func _physics_process(delta):
	match status:
		DRIFTING:
			process_drifting(delta)
		TARGETING:
			process_targeting(delta)
		TURNING:
			process_turning(delta)
		MOVING:
			process_moving(delta)
		TURNING_TO_SHOOT:
			process_turning_to_shoot(delta)
		SHOOTING:
			process_shooting(delta)
			
func damage(amount):
	shields -= amount
	if shields < 0:
		queue_free()
		
	status = TARGETING
			
func process_drifting(delta):
	thrust = MOVEMENT * delta
	var rot = rotation_degrees
	var direction = Vector2(thrust, 0).rotated(deg2rad(rot))
	var collide = move_and_collide(direction)
	if shields < 100:
		shields += 1
		
func process_targeting(delta):
	var ships = get_tree().get_nodes_in_group("player")
	var closest_distance = 999999
	var closest_ship = null
	for ship in ships:
		var distance = global_position.distance_to(ship.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_ship = ship
			
	if closest_distance > 10000:
		status = DRIFTING
		return
	
	if closest_ship != null:
		targeting_helper.set_target(closest_ship)
		targeting_helper.plot_course_to_target(global_position)
		status = TURNING
	else:
		status = DRIFTING

func process_turning(delta):
	if !targeting_helper.plot_course_to_target(global_position):
		return
		
	var angle_delta
	
	if targeting_helper.target_angle > rotation_degrees:
		angle_delta = 1
	else:
		angle_delta = -1
		
	if abs(rotation_degrees - targeting_helper.target_angle) > 1:
		rotate(deg2rad(angle_delta))
	else:
		status = MOVING

func process_moving(delta):
	if !targeting_helper.target.get_ref():
		status = DRIFTING
		return
		
	thrust = MOVEMENT * delta
	var rot = rotation_degrees
	var direction = Vector2(thrust, 0).rotated(deg2rad(rot))
	var collide = move_and_collide(direction)
	if shields < 100:
		shields += 1

	var target_position = targeting_helper.target.get_ref().global_position
	var distance = global_position.distance_to(target_position)
	if distance < 500:
		status = TURNING_TO_SHOOT
		firing_count = 0
		
func process_turning_to_shoot(delta):
	if !targeting_helper.plot_course_to_target(global_position):
		return
		
	var angle_delta
	
	if targeting_helper.target_angle > rotation_degrees:
		angle_delta = 1
	else:
		angle_delta = -1
		
	if abs(rotation_degrees - targeting_helper.target_angle) > 1:
		rotate(deg2rad(angle_delta))
	else:
		last_fired = OS.get_ticks_msec()
		status = SHOOTING

func process_shooting(delta):
	var now = OS.get_ticks_msec()
	if now - last_fired > 100:
		var bullet = Bullet.instance()
		bullet.position = firing_position.global_position
		bullet.rotate(rotation)
		get_parent().add_child(bullet)
		last_fired = now
		firing_count += 1

	if firing_count > 5:
		status = TARGETING
		targeting_helper.clear()