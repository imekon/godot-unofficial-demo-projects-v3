using Godot;
using System;

public class Main : Node2D
{
	private const float GENERATION_TIME = 1.0f;
	private const float PLAYER_MOVEMENT_SPEED = 100.0f;
	private Random random;
	private PackedScene cube;
	private Area2D player;
	
	private float now = 0.0f;
	private float last = 0.0f;

	public Main()
	{
		random = new Random();
	}
	
    public override void _Ready()
    {
		cube = (PackedScene)ResourceLoader.Load("res://scenes/Cube.tscn");
		player = (Area2D)GetNode("Ship");
		GenerateCube();
    }

    public override void _Process(float delta)
    {
		if (now > last + GENERATION_TIME)
		{
			GenerateCube();
			last = now;
		}
		
		now += delta;
		
		var x = player.Position.x;
		var y = player.Position.y;
		
		if (Input.IsActionPressed("ui_left"))
		{
			var pos = new Vector2(x - delta * PLAYER_MOVEMENT_SPEED, y);
			player.Position = pos;
		}
		else if (Input.IsActionPressed("ui_right"))
		{
			var pos = new Vector2(x + delta * PLAYER_MOVEMENT_SPEED, y);
			player.Position = pos;
		}
    }
	
	private void GenerateCube()
	{
		var cubeInst = (Area2D)cube.Instance();
		cubeInst.Position = new Vector2(100 + random.Next(400), 50);
		AddChild(cubeInst);		
	}
}
