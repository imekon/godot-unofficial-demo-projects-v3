using Godot;
using System;

public class Main : Node
{
	private PackedScene redScene;
	private PackedScene greenScene;
	private PackedScene blueScene;
	
	private Sprite red;
	private Sprite green;
	private Sprite blue;
	
	private Tween tween;

    public override void _Ready()
    {
		redScene = (PackedScene)ResourceLoader.Load("res://scenes/Red.tscn");
		greenScene = (PackedScene)ResourceLoader.Load("res://scenes/Green.tscn");
		blueScene = (PackedScene)ResourceLoader.Load("res://scenes/Blue.tscn");
		
		red = (Sprite)redScene.Instance();
		green = (Sprite)greenScene.Instance();
		blue = (Sprite)blueScene.Instance();
		
		tween = (Tween)GetNode("Tween");
		
		red.Position = new Vector2(100, 100);
		green.Position = new Vector2(100, 200);
		blue.Position = new Vector2(100, 300);
		
		AddChild(red);
		AddChild(green);
		AddChild(blue);
		
		StartTweening();
    }

	private async void StartTweening()
	{
		tween.InterpolateMethod(this, "TweenMoveRed", 0, 1, 30, Tween.TransitionType.Quad, Tween.EaseType.Out);
		tween.Start();
		
		await ToSignal(tween, "tween_completed");
		
		tween.InterpolateMethod(this, "TweenMoveGreen", 0, 1, 30, Tween.TransitionType.Quad, Tween.EaseType.Out);
		tween.Start();
		
		await ToSignal(tween, "tween_completed");

		tween.InterpolateMethod(this, "TweenMoveBlue", 0, 1, 30, Tween.TransitionType.Quad, Tween.EaseType.Out);
		tween.Start();
	}
	
	private void TweenMoveRed(float val)
	{
		red.Position = new Vector2(100 + 800 * val, 100);
	}

	private void TweenMoveGreen(float val)
	{
		green.Position = new Vector2(100 + 800 * val, 200);
	}
	
	private void TweenMoveBlue(float val)
	{
		blue.Position = new Vector2(100 + 800 * val, 300);
	}

}
