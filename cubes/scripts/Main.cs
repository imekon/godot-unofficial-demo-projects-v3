using Godot;
using System;

public class Main : Node2D
{
	private const float ACCELERATION = 5;
	private const float ROTATION = 2;
	
	private PackedScene cube;
	private RigidBody2D player;
	
    public override void _Ready()
    {
		cube = (PackedScene)ResourceLoader.Load("res://scenes/Cube.tscn");
		player = (RigidBody2D)GetNode("RigidBody2D");
		
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
    }
	
	private void Thrust()
	{
		var velocity = player.GetLinearVelocity();
		player.ApplyImpulse(new Vector2(), new Vector2(ACCELERATION, 0).Rotated(player.Rotation));
	}
	
	private void RotateShip(float offset)
	{
		player.SetAngularVelocity(ROTATION * offset);
	}
}
