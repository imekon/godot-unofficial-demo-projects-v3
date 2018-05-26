using Godot;
using System;
using System.Collections.Generic;
using ClipperLibrary;

public class main : Node2D
{
	private Navigation2D nav2d;
	private Path2D path2d;
	private PathFollow2D pathFollow;
	
	private PackedScene ground;
	private PackedScene wall;
	private PackedScene home;
	private PackedScene enemy;
	private PackedScene alien1;
	
	private const int SPRITE_WIDTH = 64;
	private const int SPRITE_HEIGHT = 64;
	private const int LEFT_MARGIN = 40;
	private const int TOP_MARGIN = 40;
	
	private List<List<IntPoint>> solution;
	
	public main()
	{
		solution = new List<List<IntPoint>>();
	}
	
    public override void _Ready()
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
		
		ground = (PackedScene)ResourceLoader.Load("res://scenes/ground.tscn");
		wall = (PackedScene)ResourceLoader.Load("res://scenes/wall.tscn");
		home = (PackedScene)ResourceLoader.Load("res://scenes/home.tscn");
		enemy = (PackedScene)ResourceLoader.Load("res://scenes/enemy.tscn");
		alien1 = (PackedScene)ResourceLoader.Load("res://scenes/Alien1.tscn");

		var rows = level.Count;
		var columns = level[0].Count;
		
		var clipper = new Clipper();

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
						var path = new List<IntPoint>()
						{
							new IntPoint(pos.x - 32, pos.y - 32),
							new IntPoint(pos.x + 32, pos.y - 32),
							new IntPoint(pos.x + 32, pos.y + 32),
							new IntPoint(pos.x - 32, pos.y + 32)
						};
						clipper.AddPath(path, PolyType.ptSubject, true);
						break;
						
					case 2:
						instance = (Sprite)enemy.Instance();
						break;
						
					case 3:
						instance = (Sprite)home.Instance();
						break;
				}
				
				instance.Position = pos;
				AddChild(instance);
			}
		}
        
		clipper.Execute(ClipType.ctUnion, solution);
    }

	private Vector2 GetPosition(int x, int y)
	{
		var pos = new Vector2(x * SPRITE_WIDTH + LEFT_MARGIN, y * SPRITE_HEIGHT + TOP_MARGIN);
		return pos;
	}
	
	public override void _Draw()
	{
		foreach(var path in solution)
		{
			for(int i = 0; i < path.Count - 1; i++)
			{
				DrawLine(new Vector2(path[i].X, path[i].Y), new Vector2(path[i + 1].X, path[i + 1].Y), new Color(1, 0, 0));
			}
			
			DrawLine(new Vector2(path[path.Count - 1].X, path[path.Count - 1].Y), new Vector2(path[0].X, path[0].Y), new Color(1, 0, 0));
		}
	}
}
