using Godot;
using System;

public class Main : Node2D
{
	private PackedScene cube;
	private Node2D player;
	private Vector2 thrust;
	private Vector2 inertia;
	private float decay;
	
    public override void _Ready()
    {
		cube = (PackedScene)ResourceLoader.Load("res://scenes/Cube.tscn");
		player = (Node2D)GetNode("Player");
		thrust = new Vector2(0, 0);
		inertia = new Vector2(0, 0);
		decay = 0.0f;
		
		var random = new Random();
		
		for(int i = 0; i < 10; i++)
		{
			var x = random.Next(-600, 600);
			var y = random.Next(-500, 500);
			var alien = (Node2D)cube.Instance();
			alien.Position = new Vector2(x, y);
			AddChild(alien);
		}
    }

    public override void _Process(float delta)
    {
		if (Input.IsActionPressed("ui_up"))
			Thrust();
		else if (Input.IsActionPressed("ui_left"))
			RotateShip(-1);
		else if (Input.IsActionPressed("ui_right"))
			RotateShip(1);
			
		player.Position = player.Position + thrust + inertia;
		
		var change = decay - delta;
		if (change > 0.0f && change < 1.0f)
			decay = decay - delta;
			
		inertia = inertia * decay;
    }
	
	private void Thrust()
	{
		inertia = thrust;
		
		thrust.x = 1.0f;
		thrust.y = 0.0f;
		thrust = thrust.Rotated(player.Rotation);
		decay = 1.0f;
	}
	
	private void RotateShip(float offset)
	{
		player.Rotation += offset * 0.1f;
	}
}
