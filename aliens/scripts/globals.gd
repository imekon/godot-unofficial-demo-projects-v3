extends Node

func random_range(value : int):
	return randi() % value - value / 2

func random_range2(low: int, high: int):
	return randi() % (high - low) + low
