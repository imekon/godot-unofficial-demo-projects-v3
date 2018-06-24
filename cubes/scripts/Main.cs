using Godot;
using System;

public class Main : Node2D
{
	private PackedScene cube;
	private RigidBody2D player;
	
    public override void _Ready()
    {
		cube = (PackedScene)ResourceLoader.Load("res://scenes/Cube.tscn");
		player = (RigidBody2D)GetNode("RigidBody2D");
		
		var random = new Random();
		
		for(int i = 0; i < 10; i++)
		{
			var x = random.Next(-600, 600);
			var y = random.Next(-500, 500);
			var alien = (RigidBody2D)cube.Instance();
			alien.Position = new Vector2(x, y);
			AddChild(alien);
		}
    }

//    public override void _Process(float delta)
//    {
//    }
}
