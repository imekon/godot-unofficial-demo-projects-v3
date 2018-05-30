using Godot;
using System;

public class Alien : Sprite
{
	private int health;
	
	public int Health
	{
		get { return health; }
		set
		{
			health = value;
		}
	}
	
	public Alien()
	{
		health = 100;
	}
	
    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
        
    }

	public override void _Draw()
	{
		DrawRect(new Rect2(-20, -30, 40 * health / 100, 6), new Color(255, 0, 0), true);
	}
}
