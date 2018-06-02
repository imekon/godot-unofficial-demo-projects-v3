using Godot;
using System;

public class Welcome : PanelContainer
{
    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
        
    }

	private void _onStartPressed()
	{
	    GetTree().ChangeScene("res://scenes/main.tscn");
	}
}
