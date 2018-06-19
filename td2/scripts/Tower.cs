using Godot;
using System;

public class Tower : Sprite
{
	private PackedScene bullet;
	private PackedScene laser;
	private int lastFired;
	
	private const int rateOfFire = 350;
	
	[Export]
	public int Type = 1;
	
	[Export]
	public int Level = 1;
		
	public int X;
	public int Y;
	
	public Tower()
	{
		lastFired = 0;
	}
	
    public override void _Ready()
    {
		bullet = (PackedScene)ResourceLoader.Load("res://scenes/Bullet.tscn");
		laser = (PackedScene)ResourceLoader.Load("res://scenes/LaserBeam.tscn");
    }

	public void FireAtAlien(Vector2 vector)
	{
		var now = OS.GetTicksMsec();
		if (now - lastFired > rateOfFire)
		{
			lastFired = now;
			switch(Type)
			{
				case 1:
					{
						var bulletInst = (Bullet)bullet.Instance();
						bulletInst.Position = GlobalPosition;
						bulletInst.Direction = vector;
						GetParent().AddChild(bulletInst);
					}
					break;
					
				case 2:
					{
						var laserInst = (Bullet)laser.Instance();
						laserInst.Position = GlobalPosition;
						laserInst.Direction = vector;
						laserInst.Rotation = vector.Angle();
						GetParent().AddChild(laserInst);
					}
					break;
			}
		}
	}
}
