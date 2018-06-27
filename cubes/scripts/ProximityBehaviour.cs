using Godot;
using System;

public class ProximityBehaviour : Behaviour
{
	private int near;
	private int far;
	
	public ProximityBehaviour(RigidBody2D target, int ticks, int near, int far) : base(target, ticks)
	{
		this.near = near;
		this.far = far;
	}
}