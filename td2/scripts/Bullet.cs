using Godot;
using System;

public class Bullet : Sprite
{
	private Vector2 direction;
	
	private const int speed = 5;
	
	public Vector2 Direction
	{
		get { return direction; }
		set { direction = value; }
	}

    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
        
    }

    public override void _Process(float delta)
    {
		Position = new Vector2(Position.x + direction.x * delta / speed, Position.y - direction.y * delta / speed);
    }
}
