using Godot;
using System;

public class Cube : Area2D
{
	private const float SPEED = 75.0f;
	
	private float x;
	private float y;
	
    public override void _Ready()
    {
		x = Position.x;
		y = Position.y;
    }
	
    public override void _Process(float delta)
    {
		y = y + delta * SPEED;
		
		Position = new Vector2(x, y);
		
		if (y > 900.0f)
			QueueFree();
    }
}
