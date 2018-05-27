//#define USE_CLIPPER
#define USE_RECTS
//#define DRAW_CLIPPER

using Godot;
using System;
using System.Collections.Generic;
using ClipperLibrary;

public class main : Node2D
{
	private Navigation2D nav2d;
	private Path2D path2d;
	private PathFollow2D pathFollow;
	private Tween tween;
	
	private PackedScene ground;
	private PackedScene wall;
	private PackedScene home;
	private PackedScene enemy;
	private PackedScene alien1;
	
	private Vector2 homePos;
	private Vector2 enemyPos;
	
	private const int SPRITE_WIDTH = 64;
	private const int SPRITE_HEIGHT = 64;
	private const int SPRITE_WIDTH2 = 32;
	private const int SPRITE_HEIGHT2 = 32;
	private const int LEFT_MARGIN = 80;
	private const int TOP_MARGIN = 80;
	private const int CONTAINER_MARGIN = 5;
	private const int SPRITE_MARGIN = 20;
	
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
			new List<int> { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 3 },
			new List<int> { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
		};
		
		nav2d = (Navigation2D)GetNode("Navigation2D");
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

#if USE_CLIPPER		
		var clipper = new Clipper();
#endif

#if USE_RECTS
		var rects = new List<List<Vector2>>();
#endif

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
#if USE_CLIPPER
						var path = new List<IntPoint>()
						{
							new IntPoint(pos.x - SPRITE_WIDTH2, pos.y - SPRITE_HEIGHT2),
							new IntPoint(pos.x + SPRITE_WIDTH2, pos.y - SPRITE_HEIGHT2),
							new IntPoint(pos.x + SPRITE_WIDTH2, pos.y + SPRITE_HEIGHT2),
							new IntPoint(pos.x - SPRITE_WIDTH2, pos.y + SPRITE_HEIGHT2)
						};
						clipper.AddPath(path, PolyType.ptSubject, true);
#endif

#if USE_RECTS
						var path = new List<Vector2>
						{
							new Vector2(pos.x - SPRITE_WIDTH2 - SPRITE_MARGIN, pos.y - SPRITE_HEIGHT2 - SPRITE_MARGIN),
							new Vector2(pos.x + SPRITE_WIDTH2 + SPRITE_MARGIN, pos.y - SPRITE_HEIGHT2 - SPRITE_MARGIN),
							new Vector2(pos.x + SPRITE_WIDTH2 + SPRITE_MARGIN, pos.y + SPRITE_HEIGHT2 + SPRITE_MARGIN),
							new Vector2(pos.x - SPRITE_WIDTH2 - SPRITE_MARGIN, pos.y + SPRITE_HEIGHT2 + SPRITE_MARGIN)
						};
						rects.Add(path);
#endif
						break;
						
					case 2:
						instance = (Sprite)enemy.Instance();
						enemyPos = pos;
						break;
						
					case 3:
						instance = (Sprite)home.Instance();
						homePos = pos;
						break;
				}
				
				instance.Position = pos;
				AddChild(instance);
			}
		}

#if USE_CLIPPER
		clipper.Execute(ClipType.ctUnion, solution);
		SetupNavigationPolygonFromClipper(solution, rows, columns);
#endif

#if USE_RECTS
		SetupNavigationPolygonFromRects(rects, rows, columns);
#endif
		
		GD.Print($"enemy: {enemyPos.x}, {enemyPos.y}");
		GD.Print($"home: {homePos.x}, {homePos.y}");
		var follow = nav2d.GetSimplePath(enemyPos, homePos);
		
		foreach(var point in follow)
		{
			GD.Print($"follow {point.x}, {point.y}");
			path2d.Curve.AddPoint(point);
		}
			
		pathFollow.AddChild(alien1.Instance());
		
		tween.InterpolateMethod(this, "MoveAlienAlongPath", 0.0, 1.0, 30, Tween.TransitionType.Quad, Tween.EaseType.Out);
		tween.Start();
    }
	
	private void SetupNavigationPolygonFromRects(List<List<Vector2>> rects, int rows, int columns)
	{
		var poly = new NavigationPolygon();
		//List<Vector2> outline = null;
		//outline = new List<Vector2>();
		//outline.Add(new Vector2(-SPRITE_WIDTH2 + LEFT_MARGIN - CONTAINER_MARGIN, -SPRITE_HEIGHT2 + TOP_MARGIN - CONTAINER_MARGIN));
		//outline.Add(new Vector2(SPRITE_WIDTH * columns + SPRITE_WIDTH2 + LEFT_MARGIN + CONTAINER_MARGIN, -SPRITE_HEIGHT2 + TOP_MARGIN - CONTAINER_MARGIN));
		//outline.Add(new Vector2(SPRITE_WIDTH * columns + SPRITE_WIDTH2 + LEFT_MARGIN + CONTAINER_MARGIN, SPRITE_HEIGHT * rows + SPRITE_HEIGHT2 + TOP_MARGIN + CONTAINER_MARGIN));
		//outline.Add(new Vector2(-SPRITE_WIDTH2 + LEFT_MARGIN - CONTAINER_MARGIN, SPRITE_HEIGHT * rows + SPRITE_HEIGHT2 + TOP_MARGIN + CONTAINER_MARGIN));
		//poly.AddOutline(outline.ToArray());
		
		foreach(var rect in rects)
		{
			poly.AddOutline(rect.ToArray());
		}
		
		poly.MakePolygonsFromOutlines();
		nav2d.NavpolyAdd(poly, new Transform2D());
	}
	
	private void SetupNavigationPolygonFromClipper(List<List<IntPoint>> solution, int rows, int columns)
	{
		var poly = new NavigationPolygon();
		List<Vector2> outline = null;
		//outline = new List<Vector2>();
		//outline.Add(new Vector2(-SPRITE_WIDTH2 + LEFT_MARGIN - 2, -SPRITE_HEIGHT2 + TOP_MARGIN + 2));
		//outline.Add(new Vector2(SPRITE_WIDTH * columns + SPRITE_WIDTH2 + LEFT_MARGIN - 2, -SPRITE_HEIGHT2 + TOP_MARGIN + 2));
		//outline.Add(new Vector2(SPRITE_WIDTH * columns + SPRITE_WIDTH2 + LEFT_MARGIN - 2, SPRITE_HEIGHT * rows + SPRITE_HEIGHT2 + TOP_MARGIN + 2));
		//outline.Add(new Vector2(-SPRITE_WIDTH2 + LEFT_MARGIN - 2, SPRITE_HEIGHT * rows + SPRITE_HEIGHT2 + TOP_MARGIN + 2));
		//poly.AddOutline(outline.ToArray());
		
		foreach(var path in solution)
		{
			//GD.Print("outline");
			outline = new List<Vector2>();
			foreach(var point in path)
			{
				//GD.Print($"point {point.X}, {point.Y}");
				outline.Add(new Vector2(point.X, point.Y));
			}
			poly.AddOutline(outline.ToArray());
		}
		
		poly.MakePolygonsFromOutlines();
		
		for(int i = 0; i < poly.GetPolygonCount(); i++)
		{
			var polygon = poly.GetPolygon(i);
			//GD.Print($"polygon points {polygon.Length}");
		}
		
		nav2d.NavpolyAdd(poly, new Transform2D());
	}
	
	private void MoveAlienAlongPath(float val)
	{
		//GD.Print($"move {val}");
		pathFollow.UnitOffset = val;
	}

	private Vector2 GetPosition(int x, int y)
	{
		var pos = new Vector2(x * SPRITE_WIDTH + LEFT_MARGIN, y * SPRITE_HEIGHT + TOP_MARGIN);
		return pos;
	}

#if DRAW_CLIPPER
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
#endif

	private void _onTweenCompleted(Godot.Object obj, NodePath key)
	{
	    // Replace with function body
	}
}
