using Godot;
using System;

public class Tower1 : Sprite
{
	private PackedScene bullet;
	private int lastFired;
	
	private const int rateOfFire = 250;
	
	[Export]
	public int Range = 100;
	
	public Tower1()
	{
		lastFired = 0;
	}
	
    public override void _Ready()
    {
		bullet = (PackedScene)ResourceLoader.Load("res://scenes/bullet.tscn");
    }

	public void FireAtAlien(Vector2 vector)
	{
		var now = OS.GetTicksMsec();
		if (now - lastFired > rateOfFire)
		{
			lastFired = now;
			var bulletInst = (Bullet)bullet.Instance();
			bulletInst.Position = GlobalPosition;
			bulletInst.Direction = vector;
			GetParent().AddChild(bulletInst);
		}
	}
}
