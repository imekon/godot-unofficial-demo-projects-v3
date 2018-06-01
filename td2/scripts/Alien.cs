using Godot;
using System;

public class Alien : Area2D
{
	[Export]
	public int Health = 100;
	
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

	private void OnAlienBodyEntered(Godot.Object body)
	{
	    GD.Print("collision!");
		
		collision.Disabled = true;
	}
}
