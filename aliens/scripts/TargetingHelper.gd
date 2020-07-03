extends Node

class_name TargetingHelper

var target
var target_position
var target_angle
var last_fired

func _init():
	target = null
	target_position = Vector2(0, 0)
	target_angle = 0
	last_fired = OS.get_ticks_msec()
	
func clear():
	target = null

func set_target(what):
	last_fired = OS.get_ticks_msec()
	target = weakref(what)

func plot_course_to_target(ship_position):
	if target == null:
		last_fired = OS.get_ticks_msec()
		return false
	
	if !target.get_ref():
		last_fired = OS.get_ticks_msec()
		target = null
		return false
		
	target_position = target.get_ref().global_position
	target_angle = rad2deg(target_position.angle_to_point(ship_position))
	return true

