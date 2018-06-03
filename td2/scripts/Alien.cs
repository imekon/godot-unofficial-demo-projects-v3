using Godot;
using System;

public class Alien : Area2D
{
	[Export]
	public int Health = 100;
	
	[Export]
	public int Score = 5;
	
	public delegate void DiedDelegate(int score);
	
	public event DiedDelegate Died;
	
	private CollisionShape2D collision;
	
	public Alien()
	{
	}
	
    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
        collision = (CollisionShape2D)GetNode("CollisionShape2D");
    }

	public override void _Draw()
	{
		DrawRect(new Rect2(-20, -30, 40 * Health / 100, 6), new Color(255, 0, 0), true);
	}

	private void _onAlien1Entered(Godot.Object area)
	{
	    if (area is Alien)
			return;
			
		if (area is Bullet)
		{
			Health -= 30;
			Update();
			((Bullet)area).QueueFree();
			if (Health <= 0)
			{
				Died?.Invoke(Score);
				QueueFree();
			}
		}
	}
}
