using Godot;
using System;

public class Bullet : Area2D
{
	[Export]
	public int Damage = 20;
	
	public Vector2 Direction = new Vector2(0, 0);
	
	private const int speed = 5;
	
    public override void _Ready()
    {
    }

    public override void _Process(float delta)
    {
		var size = GetViewport().Size;
		
		Position = Position + Direction * delta * speed;
		
		if (Position.x < 0 || Position.x > size.x ||
			Position.y < 0 || Position.y > size.y)
			QueueFree();
    }
}
