extends Node

class Cargo:
	var _food: int
	var _luxuries: int
	var _minerals: int
	
	func _init():
		_food = 0
		_luxuries = 0
		_minerals = 0
		
func create_cargo():
	var cargo = Cargo.new()
	return cargo