using Godot;
using System;
using System.Collections.Generic;

public class Levels
{
	private List<List<int>> level1;
	
	public Levels()
	{
		level1 = new List<List<int>>
		{
			new List<int> { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
			new List<int> { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1 },
			new List<int> { 2, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 3 },
			new List<int> { 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1 },
			new List<int> { 1, 0, 1, 0, 0, 4, 0, 0, 1, 0, 0, 1 },
			new List<int> { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
		};
	}
	
	public List<List<int>> GetLevel(int level)
	{
		return level1;
	}
}
