using Godot;
using System;

public class Main : Node2D
{
	private Sprite player;
	private Vector2 thrust;
	
    public override void _Ready()
    {
		player = (Sprite)GetNode("Player");
		thrust = new Vector2(0, 0);
    }

    public override void _Process(float delta)
    {
		if (Input.IsActionPressed("ui_up"))
			Thrust();
		else if (Input.IsActionPressed("ui_left"))
			RotateShip(delta, -1);
		else if (Input.IsActionPressed("ui_right"))
			RotateShip(delta, 1);
			
		player.Position = player.Position + thrust;
    }
	
	private void Thrust()
	{
	}
	
	private void RotateShip(float delta, float offset)
	{
		player.Rotation += offset * 0.1f;
	}
}
