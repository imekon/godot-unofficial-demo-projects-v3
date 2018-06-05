using Godot;
using System;

public class Alien : Area2D
{
	[Export]
	public int Health = 100;
	
	[Export]
	public int Score = 5;
	
	[Export]
	public float Shield = 1;
	
	public delegate void DiedDelegate(int score);
	public delegate void ReachedHomeDelegate();
	
	public event DiedDelegate Died;
	public event ReachedHomeDelegate ReachedHome;
	
	private CollisionShape2D collision;
	private bool reachedHome;
	
	public Alien()
	{
		reachedHome = false;
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
	
	private void OnAlienAreaEntered(Godot.Object area)
	{
	    if (area is Alien)
			return;
			
		if (area is Bullet)
		{
			var bullet = area as Bullet;
			
			Health -= (int)(bullet.Damage / Shield);
			Update();
			bullet.QueueFree();
			if (Health <= 0)
			{
				Died?.Invoke(Score);
				QueueFree();
			}
		}
		
		if (area is Home)
		{
			if (!reachedHome)
			{
				ReachedHome?.Invoke();
				reachedHome = true;
			}
		}
	}
}
