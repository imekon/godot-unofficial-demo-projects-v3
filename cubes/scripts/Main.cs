using Godot;
using System;

public class Main : Node2D
{
	private PackedScene red;
	private PackedScene orange;
	private PackedScene yellow;
	private PackedScene green;
	private PackedScene blue;
	private PackedScene indigo;
	private PackedScene violet;
	
    public override void _Ready()
    {
		red = (PackedScene)ResourceLoader.Load("res://scenes/Red.tscn");
		orange = (PackedScene)ResourceLoader.Load("res://scenes/Orange.tscn");
		yellow = (PackedScene)ResourceLoader.Load("res://scenes/Yellow.tscn");
		green = (PackedScene)ResourceLoader.Load("res://scenes/Green.tscn");
		blue = (PackedScene)ResourceLoader.Load("res://scenes/Blue.tscn");
		indigo = (PackedScene)ResourceLoader.Load("res://scenes/Indigo.tscn");
		violet = (PackedScene)ResourceLoader.Load("res://scenes/Violet.tscn");
		
		var random = new Random();
		
		var colours = new PackedScene[7];
		colours[0] = red;
		colours[1] = orange;
		colours[2] = yellow;
		colours[3] = green;
		colours[4] = blue;
		colours[5] = indigo;
		colours[6] = violet;
		
		for(int i = 0; i < 10; i++)
		{
			var x = random.Next(-300, 300);
			var y = random.Next(-300, 300);
			var colour = random.Next(0, 7);
			var scene = colours[colour];
			var cube = (Cube)scene.Instance();
			
			cube.Position = new Vector2(x, y);
			cube.Behaviour = new ProximityBehaviour(cube, 500, 100, 300);
			
			AddChild(cube);
		}
    }

//    public override void _Process(float delta)
//    {
//        // Called every frame. Delta is time since last frame.
//        // Update game logic here.
//        
//    }
}
