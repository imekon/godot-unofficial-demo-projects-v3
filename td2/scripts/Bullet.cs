using Godot;
using System;

public class Bullet : Sprite
{
	public Vector2 Direction = new Vector2(0, 0);
	
	private const int speed = 5;
	
    public override void _Ready()
    {
    }

    public override void _Process(float delta)
    {
		Position = new Vector2(Position.x + Direction.x * delta / speed, Position.y - Direction.y * delta / speed);
    }
}
