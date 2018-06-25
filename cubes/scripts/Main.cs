using Godot;
using System;

public class Main : Node2D
{
	private PackedScene cube;
	
    public override void _Ready()
    {
		cube = (PackedScene)ResourceLoader.Load("res://scenes/Cube.tscn");
		
		var random = new Random();
		
		for(int i = 0; i < 10; i++)
		{
			var x = random.Next(-300, 300);
			var y = random.Next(-300, 300);
			
			var alien = (Node2D)cube.Instance();
			
			alien.Position = new Vector2(x, y);
			
			AddChild(alien);
		}
    }

//    public override void _Process(float delta)
//    {
//        // Called every frame. Delta is time since last frame.
//        // Update game logic here.
//        
//    }
}
