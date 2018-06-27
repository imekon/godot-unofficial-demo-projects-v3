using Godot;
using System;

public class Cube : RigidBody2D
{
	public Behaviour Behaviour { get; set; }
	
    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
        
    }

//    public override void _Process(float delta)
//    {
//        // Called every frame. Delta is time since last frame.
//        // Update game logic here.
//        
//    }
}
