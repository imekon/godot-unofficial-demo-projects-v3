using Godot;
using System;

public class Tower : Sprite
{
	private PackedScene bullet;
	private int lastFired;
	
	private const int rateOfFire = 350;
	
	[Export]
	public int Range = 100;
	
	[Export]
	public int Cost = 10;
	
	public int X;
	public int Y;
	
	public Tower()
	{
		lastFired = 0;
	}
	
    public override void _Ready()
    {
		bullet = (PackedScene)ResourceLoader.Load("res://scenes/Bullet.tscn");
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
