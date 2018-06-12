using Godot;
using RoyT.AStar;
using System;
using System.Collections.Generic;

public class main : Node2D
{
	private Path2D path2d;
	private PathFollow2D[] pathFollowers;
	private Label creditsLabel;
	private Label healthLabel;
	private Sprite cursor;
	private Timer timer;
	private AnimationPlayer animationNextWave;
	
	private Button deleteButton;
	private Button upgradeButton;
	private Button tower1Button;
	
	private PackedScene ground;
	private PackedScene wall;
	private PackedScene home;
	private PackedScene enemy;
	private PackedScene cursorScene;
	private PackedScene alien1;
	private PackedScene alien2;
	private PackedScene alien3;
	private PackedScene tower1;
	
	private Levels levels;
	private List<List<int>> level;
	private float now;
	private float alienSpeed;
	private int columns;
	private int rows;
	private int credits;
	private int health;
	private Vector2 cursorGrid;
	
	private const int SPRITE_WIDTH = 64;
	private const int SPRITE_HEIGHT = 64;
	private const int SPRITE_WIDTH2 = 32;
	private const int SPRITE_HEIGHT2 = 32;
	private const int LEFT_MARGIN = 100;
	private const int TOP_MARGIN = 90;
	private const int CONTAINER_MARGIN = 10;
	private const int SPRITE_MARGIN = 20;
	private const int NUM_FOLLOWERS = 10;
	
	private enum GridStatus
	{
		Empty,
		Wall,
		Tower,
		Alien
	};
	
	public main()
	{
		now = 0.0f;
		alienSpeed = 20.0f;
		credits = 30;
		health = 10;
		
		levels = new Levels();
	}
	
    public override void _Ready()
    {
		level = levels.GetLevel(0);
		
		path2d = (Path2D)GetNode("Path2D");
		creditsLabel = (Label)GetNode("Credits");
		healthLabel = (Label)GetNode("Health");
		timer = (Timer)GetNode("Timer");
		animationNextWave = (AnimationPlayer)GetNode("AnimationPlayer");
		
		deleteButton = (Button)GetNode("DeleteButton");
		upgradeButton = (Button)GetNode("UpgradeButton");
		tower1Button = (Button)GetNode("Tower1Button");
		
		deleteButton.Disabled = true;
		upgradeButton.Disabled = true;
		tower1Button.Disabled = true;
		
		ground = (PackedScene)ResourceLoader.Load("res://scenes/ground.tscn");
		wall = (PackedScene)ResourceLoader.Load("res://scenes/wall.tscn");
		home = (PackedScene)ResourceLoader.Load("res://scenes/home.tscn");
		enemy = (PackedScene)ResourceLoader.Load("res://scenes/enemy.tscn");
		cursorScene = (PackedScene)ResourceLoader.Load("res://scenes/Cursor.tscn");
		alien1 = (PackedScene)ResourceLoader.Load("res://scenes/Alien1.tscn");
		alien2 = (PackedScene)ResourceLoader.Load("res://scenes/Alien2.tscn");
		alien3 = (PackedScene)ResourceLoader.Load("res://scenes/Alien3.tscn");
		tower1 = (PackedScene)ResourceLoader.Load("res://scenes/Tower1.tscn");
		
		cursor = (Sprite)cursorScene.Instance();
		cursor.Position = GetPosition(0, 0);
		AddChild(cursor);
		
		cursorGrid = new Vector2(0, 0);

		rows = level.Count;
		columns = level[0].Count;
		
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
				
				instance.Position = pos;
				AddChild(instance);
				if (tower != null)
				{
					tower.Position = pos;
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
			path2d.Curve.AddPoint(pos);
		}

		pathFollowers = new PathFollow2D[NUM_FOLLOWERS];
		
		GenerateAliens();
	}
	
	private async void GenerateAliens()
	{
		GenerateAlien1();
		
		timer.Start();
		await ToSignal(timer, "timeout");
		
		DisplayNextWaveMessage();
		GenerateAlien2();

		timer.Start();
		await ToSignal(timer, "timeout");
		
		DisplayNextWaveMessage();
		GenerateAlien3();
	}
	
	private void GenerateAlien1()
	{
		now = 0;
		alienSpeed = 20.0f;
		
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
	
	private void GenerateAlien2()
	{
		now = 0;
		alienSpeed = 18.0f;
		
		for (int i = 0; i < NUM_FOLLOWERS; i++)
		{
			var pathFollower = new PathFollow2D { Loop = false, Rotate = false };
			var alien = (Alien)alien2.Instance();
			alien.Died += OnAlienDied;
			alien.ReachedHome += OnAlienReachedHome;
			pathFollower.AddChild(alien);
			path2d.AddChild(pathFollower);
			pathFollowers[i] = pathFollower;
		}
	}
	
	private void GenerateAlien3()
	{
		now = 0;
		alienSpeed = 13.0f;
		
		for (int i = 0; i < NUM_FOLLOWERS; i++)
		{
			var pathFollower = new PathFollow2D { Loop = false, Rotate = false };
			var alien = (Alien)alien3.Instance();
			alien.Died += OnAlienDied;
			alien.ReachedHome += OnAlienReachedHome;
			pathFollower.AddChild(alien);
			path2d.AddChild(pathFollower);
			pathFollowers[i] = pathFollower;
		}
	}
	
	private void DisplayNextWaveMessage()
	{
		animationNextWave.Play("Next Wave");
	}
	
	public override void _Process(float delta)
	{
		AlienMovement(delta);
		TowerTargetting();
		ChooseTower();
	}
	
	private void AlienMovement(float delta)
	{
		now += delta / alienSpeed;

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
	
	private void TowerTargetting()
	{
		foreach(Tower tower in GetTree().GetNodesInGroup("tower"))
		{
			var towerPos = tower.Position;
			
			foreach(Alien alien in GetTree().GetNodesInGroup("alien"))
			{
				var alienPos = alien.GlobalPosition;
				
				var distance = towerPos.DistanceTo(alienPos);
				var cost = TowerCosts.GetTowerCost(tower.Type, tower.Level);
				if (distance < cost.Range)
				{
					var vector = alienPos - towerPos;
					tower.FireAtAlien(vector);
					tower.LookAt(alienPos);
				}
			}
		}
	}

	private void ChooseTower()
	{
		if (Input.IsActionPressed("ui_choose"))
		{
			var position = GetViewport().GetMousePosition();
			var x = (int)(position.x + SPRITE_WIDTH2 - LEFT_MARGIN) / SPRITE_WIDTH;
			var y = (int)(position.y + SPRITE_HEIGHT2 - TOP_MARGIN) / SPRITE_HEIGHT;
						
			if (x < 0 || x >= columns || y < 0 || y >= rows)
				return;
			
			cursor.Position = GetPosition(x, y);
			var contents = GetGridContents(x, y);
			cursorGrid = new Vector2(x, y);
			
			switch(contents)
			{
				case GridStatus.Empty:
					deleteButton.Disabled = true;
					upgradeButton.Disabled = true;
					tower1Button.Disabled = credits < 15;
					break;
					
				case GridStatus.Wall:
					deleteButton.Disabled = true;
					upgradeButton.Disabled = true;
					tower1Button.Disabled = true;
					break;
					
				case GridStatus.Tower:
					deleteButton.Disabled = false;
					upgradeButton.Disabled = false;
					tower1Button.Disabled = true;
					break;
			}
		}
	}
	
	private GridStatus GetGridContents(int x, int y)
	{
		var status = GridStatus.Empty;
		var grid = level[y][x];
		
		switch(grid)
		{
			case 0:
				status = GridStatus.Empty;
				break;
				
			case 1:
			case 2:
			case 3:
			case 4:
				status = GridStatus.Wall;
				break;
		}
		
		var tower = GetTowerAtGrid(x, y);
		
		if (tower != null)
			status = GridStatus.Tower;
			
		return status;
	}
	
	private Tower GetTowerAtGrid(int x, int y)
	{
		foreach(Tower tower in GetTree().GetNodesInGroup("tower"))
		{
			if (tower.X == x && tower.Y == y)
			{
				return tower;
			}
		}
		
		return null;
	}
	
	private Vector2 GetPosition(int x, int y)
	{
		var pos = new Vector2(x * SPRITE_WIDTH + LEFT_MARGIN, y * SPRITE_HEIGHT + TOP_MARGIN);
		return pos;
	}
	
	private Vector2 GetGridPosition(int x, int y)
	{
		var X = (int)(x + SPRITE_WIDTH2 - LEFT_MARGIN) / SPRITE_WIDTH;
		var Y = (int)(y + SPRITE_HEIGHT2 - TOP_MARGIN) / SPRITE_HEIGHT;
		return new Vector2(X, Y);
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

	private void OnTower1Button()
	{
		var tower = (Tower)tower1.Instance();
		tower.X = (int)cursorGrid.x;
		tower.Y = (int)cursorGrid.y;
		var pos = GetPosition((int)cursorGrid.x, (int)cursorGrid.y);
		tower.Position = pos;
		AddChild(tower);
		var cost = TowerCosts.GetTowerCost(tower.Type, tower.Level);
		credits -= cost.Cost;
		SetCredits();
	}

	private void OnDeleteTower()
	{
		var tower = GetTowerAtGrid((int)cursorGrid.x, (int)cursorGrid.y);
		if (tower != null)
			tower.QueueFree();
	}
}






