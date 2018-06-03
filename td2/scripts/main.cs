using Godot;
using RoyT.AStar;
using System;
using System.Collections.Generic;

public class main : Node2D
{
	private Levels levels;
	private Path2D path2d;
	private PathFollow2D[] pathFollowers;
	private Label creditsLabel;
	private Label healthLabel;
	
	private PackedScene ground;
	private PackedScene wall;
	private PackedScene home;
	private PackedScene enemy;
	private PackedScene alien1;
	private PackedScene tower1;
	
	private float now;
	private int credits;
	private int health;
	
	private const int SPRITE_WIDTH = 64;
	private const int SPRITE_HEIGHT = 64;
	private const int SPRITE_WIDTH2 = 32;
	private const int SPRITE_HEIGHT2 = 32;
	private const int LEFT_MARGIN = 100;
	private const int TOP_MARGIN = 90;
	private const int CONTAINER_MARGIN = 10;
	private const int SPRITE_MARGIN = 20;
	private const int NUM_FOLLOWERS = 10;
	
	public main()
	{
		now = 0.0f;
		credits = 30;
		health = 10;
		
		levels = new Levels();
	}
	
    public override void _Ready()
    {
		var level = levels.GetLevel(0);
		
		path2d = (Path2D)GetNode("Path2D");
		creditsLabel = (Label)GetNode("Credits");
		healthLabel = (Label)GetNode("Health");
		
		ground = (PackedScene)ResourceLoader.Load("res://scenes/ground.tscn");
		wall = (PackedScene)ResourceLoader.Load("res://scenes/wall.tscn");
		home = (PackedScene)ResourceLoader.Load("res://scenes/home.tscn");
		enemy = (PackedScene)ResourceLoader.Load("res://scenes/enemy.tscn");
		alien1 = (PackedScene)ResourceLoader.Load("res://scenes/Alien1.tscn");
		tower1 = (PackedScene)ResourceLoader.Load("res://scenes/Tower1.tscn");

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
				
				Node2D instance = null;
				Tower tower = null;
				
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
						instance = (Home)home.Instance();
						homePos = new Position(x, y);
						break;
						
					case 4:
						instance = (Sprite)ground.Instance();
						grid.BlockCell(new Position(x, y));
						
						tower = (Tower)tower1.Instance();
						tower.X = x;
						tower.Y = y;
						break;
				}
				
				instance.Position = new Vector2(pos.X, pos.Y);
				AddChild(instance);
				if (tower != null)
				{
					tower.Position = new Vector2(pos.X, pos.Y);
					AddChild(tower);
				}
			}
			
			SetCredits();
			SetHealth();
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

		pathFollowers = new PathFollow2D[NUM_FOLLOWERS];
		
		for (int i = 0; i < NUM_FOLLOWERS; i++)
		{
			var pathFollower = new PathFollow2D { Loop = false, Rotate = false };
			var alien = (Alien)alien1.Instance();
			alien.Died += OnAlienDied;
			alien.ReachedHome += OnAlienReachedHome;
			pathFollower.AddChild(alien);
			path2d.AddChild(pathFollower);
			pathFollowers[i] = pathFollower;
		}
	}
	
	public override void _Process(float delta)
	{
		AlienMovement(delta);
		TowerTargetting();
		ChooseTower();
	}
	
	private void ChooseTower()
	{
		if (Input.IsActionPressed("ui_choose"))
		{
			var position = GetViewport().GetMousePosition();
			var x = (int)(position.x + SPRITE_WIDTH2 - LEFT_MARGIN) / SPRITE_WIDTH;
			var y = (int)(position.y + SPRITE_HEIGHT2 - TOP_MARGIN) / SPRITE_HEIGHT;
			
			Tower found = null;
			
			foreach(var tower in GetTree().GetNodesInGroup("tower"))
			{
				if (tower.X == x && tower.Y == y)
				{
					found = tower;
					break;
				}
			}
		}
	}
	
	private void TowerTargetting()
	{
		foreach(Tower tower in GetTree().GetNodesInGroup("tower"))
		{
			var towerPos = tower.Position;
			
			foreach(Alien alien in GetTree().GetNodesInGroup("alien"))
			{
				var alienPos = alien.GlobalPosition;
				
				var distance = towerPos.DistanceTo(alienPos);
				if (distance < tower.Range)
				{
					var vector = alienPos - towerPos;
					tower.FireAtAlien(vector);
					tower.LookAt(alienPos);
				}
			}
		}
	}
	
	private void AlienMovement(float delta)
	{
		now += delta / 20.0f;

		for (int i = 0; i < NUM_FOLLOWERS; i++)
		{
			if (pathFollowers[i] == null)
				continue;
				
			pathFollowers[i].UnitOffset = now - i * 0.06f;
			if (pathFollowers[i].UnitOffset > 1.0f)
			{
				pathFollowers[i].QueueFree();
				pathFollowers[i] = null;
			}
		}
	}
	
	private Position GetPosition(int x, int y)
	{
		var pos = new Position(x * SPRITE_WIDTH + LEFT_MARGIN, y * SPRITE_HEIGHT + TOP_MARGIN);
		return pos;
	}
	
	private void OnAlienDied(int score)
	{
		credits += score;
		SetCredits();
	}
	
	private void OnAlienReachedHome()
	{
		health--;
		SetHealth();
	}
	
	private void SetCredits()
	{
		creditsLabel.Text = $"Credits: {credits}";
	}
	
	private void SetHealth()
	{
		healthLabel.Text = $"Health: {health}";
	}
}
