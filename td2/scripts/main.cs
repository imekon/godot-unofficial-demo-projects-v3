using Godot;
using System;
using System.Collections.Generic;
using ClipperLibrary;

public class main : Node2D
{
	public main()
	{
		var level = new List<List<int>>
		{
			new List<int> { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
			new List<int> { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 2, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 3 },
			new List<int> { 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
		};
	}

    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
        
		var clipper = new Clipper();
    }

//    public override void _Process(float delta)
//    {
//        // Called every frame. Delta is time since last frame.
//        // Update game logic here.
//        
//    }
}
