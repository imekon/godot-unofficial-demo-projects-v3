using Godot;
using System;

public class Main : PanelContainer
{
	private Label planetLabel;
	private ItemList cargoList;
	private ItemList goodsList;
	
	private Texture redTexture;
	private Texture greenTexture;
	private Texture blueTexture;

    public override void _Ready()
    {
		planetLabel = (Label)GetNode("Panel/PlanetLabel");
		cargoList = (ItemList)GetNode("Panel/CargoList");
		goodsList = (ItemList)GetNode("Panel/GoodsList2");
		
		redTexture = (Texture)ResourceLoader.Load("res://images/red.png");
		greenTexture = (Texture)ResourceLoader.Load("res://images/green.png");
		blueTexture = (Texture)ResourceLoader.Load("res://images/blue.png");
		
		cargoList.AddItem("Red         5       10", redTexture, true);
    }

	private void OnPlanet()
	{
	    // Replace with function body
	}
	
	
	private void OnSell()
	{
	    // Replace with function body
	}
	
	
	private void OnBuy()
	{
	    // Replace with function body
	}
}


