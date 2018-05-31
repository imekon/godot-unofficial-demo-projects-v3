using Godot;
using System;

public class Tower1 : Sprite
{
	private int range;
	private PackedScene bullet;
	
	public int Range
	{
		get { return range; }
		set
		{
			range = value;
		}
	}
	
	public Tower1()
	{
		range = 200;
	}
	
    public override void _Ready()
    {
		bullet = (PackedScene)ResourceLoader.Load("res://scenes/bullet.tscn");
    }

	public void FireAtAlien(Vector2 vector)
	{
		GD.Print("Fire at alien");
	}
}
