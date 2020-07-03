extends KinematicBody2D

const EDGE_UNIVERSE = 65536
const MOVEMENT = 200.0

enum STATUS { STOP, DRIFTING, TARGETING, TURNING, MOVING, TURNING_TO_SHOOT, SHOOTING }

onready var Bullet = load("res://scenes/Bullet.tscn")

onready var firing_position = $FiringPosition
onready var proximity_position = $ProximityPosition
onready var label_node = $Node2D

var status : int
var thrust : float
var targeting_helper
var shields : int
var firing_count : int
var last_fired
var last_stop = 0
var limit_stop = 0

func _ready():
	targeting_helper = TargetingHelper.new()
	shields = 100
	var angle = randf() * 360
	rotate(deg2rad(angle))
	status = STATUS.DRIFTING
	
func _process(delta):
	label_node.global_rotation = 0.0

func _physics_process(delta):
	# process_proximity()
	match status:
		STATUS.STOP:
			process_stop(delta)
		STATUS.DRIFTING:
			if !process_proximity():
				process_drifting(delta)
		STATUS.TARGETING:
			process_targeting(delta)
		STATUS.TURNING:
			process_turning(delta)
		STATUS.MOVING:
			process_moving(delta)
		STATUS.TURNING_TO_SHOOT:
			process_turning_to_shoot(delta)
		STATUS.SHOOTING:
			process_shooting(delta)
			
#func _draw():
#	draw_line(Vector2(0, 0), Vector2(500, 0), Color(1.0, 0.0, 0.0))
			
func damage(amount):
	shields -= amount
	if shields < 0:
		queue_free()
		
	status = STATUS.TARGETING

func process_proximity():
	var space = get_world_2d().direct_space_state
	var result = space.intersect_ray(global_position, proximity_position.global_position, [self])
	if result:
		last_stop = OS.get_ticks_msec()
		limit_stop = Globals.random_range2(1000, 3000)
		status = STATUS.STOP
		return true
		
	return false
		
func process_stop(delta):
	var now = OS.get_ticks_msec()
	if now - last_stop > limit_stop:
		status = STATUS.DRIFTING
	
func process_drifting(delta):
	checking_edge_universe()
	thrust = MOVEMENT * delta
	var rot = rotation_degrees
	var direction = Vector2(thrust, 0).rotated(deg2rad(rot))
	var collide = move_and_collide(direction)
	if shields < 100:
		shields += 1
		
func checking_edge_universe():
	var x = position.x
	var y = position.y
	
	# we're nowhere near the edge
	if x > -EDGE_UNIVERSE and x < EDGE_UNIVERSE and y > -EDGE_UNIVERSE and y < EDGE_UNIVERSE:
		return
		
	var offset = Globals.random_range(30)
	rotation_degrees -= 180 + offset	
		
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
		status = STATUS.DRIFTING
		return
	
	if closest_ship != null:
		targeting_helper.set_target(closest_ship)
		targeting_helper.plot_course_to_target(global_position)
		status = STATUS.TURNING
	else:
		status = STATUS.DRIFTING

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
		status = STATUS.MOVING

func process_moving(delta):
	if !targeting_helper.target.get_ref():
		status = STATUS.DRIFTING
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
		status = STATUS.TURNING_TO_SHOOT
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
		status = STATUS.SHOOTING

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
		status = STATUS.TARGETING
		targeting_helper.clear()
