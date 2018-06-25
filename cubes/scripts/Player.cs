using Godot;
using System;

public class Player : RigidBody2D
{
	private const float ACCELERATION = 3.0f;
	private const float ROTATION = 2.0f;
	
	private const float FIRING_ACCELERATION = 300.0f;
	
	private PackedScene bullet;
	
	private Position2D firingPosition;
	
    public override void _Ready()
    {
		bullet = (PackedScene)ResourceLoader.Load("res://scenes/Bullet.tscn");
		
		firingPosition = (Position2D)GetNode("Position2D");
    }

    public override void _Process(float delta)
    {
		if (Input.IsActionJustPressed("ui_fire"))
			Fire();
		
		if (Input.IsActionPressed("ui_up"))
			Thrust();
			
		if (Input.IsActionPressed("ui_left"))
			RotateShip(-1);
			
		if (Input.IsActionPressed("ui_right"))
			RotateShip(1);
    }
	
	private void Fire()
	{
		var projectile = (RigidBody2D)bullet.Instance();
		projectile.Position = firingPosition.GlobalPosition;
		projectile.ApplyImpulse(new Vector2(), new Vector2(FIRING_ACCELERATION, 0).Rotated(Rotation));
		GetParent().AddChild(projectile);
	}
	
	private void Thrust()
	{
		ApplyImpulse(new Vector2(), new Vector2(ACCELERATION, 0).Rotated(Rotation));
	}
	
	private void RotateShip(float offset)
	{
		SetAngularVelocity(ROTATION * offset);
	}
}
