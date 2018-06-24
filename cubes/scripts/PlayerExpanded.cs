using Godot;
using System;

public class PlayerExpanded : RigidBody2D
{
	private const float ACCELERATION = 5;
	private const float FIRING_ACCELERATION = 250;
	private const float ROTATION = 2;
	
	private PackedScene bullet;

	private Node2D firing;
	
    public override void _Ready()
    {
		bullet = (PackedScene)ResourceLoader.Load("res://scenes/Bullet.tscn");
		
		firing = (Node2D)GetNode("Firing");
    }

    public override void _Process(float delta)
    {
		if (Input.IsActionPressed("ui_up"))
			Thrust();
		else if (Input.IsActionPressed("ui_left"))
			RotateShip(-1);
		else if (Input.IsActionPressed("ui_right"))
			RotateShip(1);
		else if (Input.IsActionJustPressed("ui_fire"))
			Fire();
    }

	private void Fire()
	{
		var bulletInst = (RigidBody2D)bullet.Instance();
		bulletInst.Position = firing.Position;
		// bulletInst.ApplyImpulse(new Vector2(), new Vector2(FIRING_ACCELERATION, 0).Rotated(Rotation));
		GetParent().AddChild(bulletInst);
	}
	
	private void Thrust()
	{
		var velocity = GetLinearVelocity();
		ApplyImpulse(new Vector2(), new Vector2(ACCELERATION, 0).Rotated(Rotation));
	}
	
	private void RotateShip(float offset)
	{
		SetAngularVelocity(ROTATION * offset);
	}
}
