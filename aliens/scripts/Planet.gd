extends Sprite

signal player_in_orbit

func on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_in_orbit")
