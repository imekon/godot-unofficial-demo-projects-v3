using Godot;
using System;

public class Behaviour
{
	protected RigidBody2D target;
	protected int ticks;
	
	public Behaviour(RigidBody2D target, int ticks)
	{
		this.target = target;
		this.ticks = ticks;
	}
}