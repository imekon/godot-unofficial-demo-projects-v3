using Godot;
using System;
using System.Collections.Generic;

public class TowerCost
{
	public int Type;
	public int Level;
	public int Cost;
	public int Range;
	public int Upgrade;
	public int Sell;
}

public static class TowerCosts
{
	private static List<TowerCost> costs;
	
	static TowerCosts()
	{
		costs = new List<TowerCost>
		{
			new TowerCost() { Type = 1, Level = 1, Cost = 15, Range = 100, Upgrade = 20, Sell = 5 }
		};
	}
	
	public static TowerCost GetTowerCost(int type, int level)
	{
		foreach(var cost in costs)
		{
			if (cost.Type == type && cost.Level == level)
				return cost;
		}
		
		return null;
	}
}
