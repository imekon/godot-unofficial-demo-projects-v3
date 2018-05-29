using Godot;
using RoyT.AStar;
using System;
using System.Collections.Generic;

public class main : Node2D
{
	private Path2D path2d;
	private PathFollow2D pathFollow;
	private Tween tween;
	
	private PackedScene ground;
	private PackedScene wall;
	private PackedScene home;
	private PackedScene enemy;
	private PackedScene alien1;
	
	private const int SPRITE_WIDTH = 64;
	private const int SPRITE_HEIGHT = 64;
	private const int SPRITE_WIDTH2 = 32;
	private const int SPRITE_HEIGHT2 = 32;
	private const int LEFT_MARGIN = 80;
	private const int TOP_MARGIN = 80;
	private const int CONTAINER_MARGIN = 10;
	private const int SPRITE_MARGIN = 20;
	
	public main()
	{
	}
	
    public override void _Ready()
    {
		var level = new List<List<int>>
		{
			new List<int> { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
			new List<int> { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1 },
			new List<int> { 2, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 3 },
			new List<int> { 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1 },
			new List<int> { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
		};
		
		path2d = (Path2D)GetNode("Path2D");
		pathFollow = (PathFollow2D)GetNode("Path2D/PathFollow2D");
		tween = (Tween)GetNode("Tween");
		
		ground = (PackedScene)ResourceLoader.Load("res://scenes/ground.tscn");
		wall = (PackedScene)ResourceLoader.Load("res://scenes/wall.tscn");
		home = (PackedScene)ResourceLoader.Load("res://scenes/home.tscn");
		enemy = (PackedScene)ResourceLoader.Load("res://scenes/enemy.tscn");
		alien1 = (PackedScene)ResourceLoader.Load("res://scenes/Alien1.tscn");

		var rows = level.Count;
		var columns = level[0].Count;
		
		Position enemyPos = new Position(0, 0);
		Position homePos = new Position(0, 0);
				
		var grid = new Grid(columns, rows, 1.0f);

		for(int y = 0; y < rows; y++)
		{
			for(int x = 0; x < columns; x++)
			{
				var index = level[y][x];
				var pos = GetPosition(x, y);
				
				Sprite instance = null;
				switch(index)
				{
					case 0:
						instance = (Sprite)ground.Instance();
						break;
						
					case 1:
						instance = (Sprite)wall.Instance();
						grid.BlockCell(new Position(x, y));
						break;
						
					case 2:
						instance = (Sprite)enemy.Instance();
						enemyPos = new Position(x, y);
						break;
						
					case 3:
						instance = (Sprite)home.Instance();
						homePos = new Position(x, y);
						break;
						
					//case 4:
					//	instance = (Sprite)ground.Instance();
					//	grid.SetCellCost(new Position(x, y), 4.0f);
					//	break;
				}
				
				instance.Position = new Vector2(pos.X, pos.Y);
				AddChild(instance);
			}
		}
		
		var movement = new[] 
		{
			new Offset(-1, 0), 
			new Offset(0, -1),
			new Offset(1, 0),
			new Offset(0, 1)
		};
		var path = grid.GetPath(enemyPos, homePos, movement);
		
		foreach(var point in path)
		{
			var pos = GetPosition(point.X, point.Y);
			path2d.Curve.AddPoint(new Vector2(pos.X, pos.Y));
		}

		pathFollow.AddChild(alien1.Instance());
		
		tween.InterpolateMethod(this, "MoveAlienAlongPath", 0.0, 1.0, 20, Tween.TransitionType.Linear, Tween.EaseType.Out);
		tween.Start();
    }
	
	private void MoveAlienAlongPath(float val)
	{
		pathFollow.UnitOffset = val;
	}

	private Position GetPosition(int x, int y)
	{
		var pos = new Position(x * SPRITE_WIDTH + LEFT_MARGIN, y * SPRITE_HEIGHT + TOP_MARGIN);
		return pos;
	}

	private void _onTweenCompleted(Godot.Object obj, NodePath key)
	{
	    // Replace with function body
	}
}
