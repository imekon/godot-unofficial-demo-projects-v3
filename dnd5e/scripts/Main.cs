using Godot;
using System;

public class Main : PanelContainer
{
	private TextEdit characterName;
	private OptionButton classLevel;
	private OptionButton race;
	
	private string[] classes = new []
	{
		"Barbarian",
		"Bard",
		"Cleric",
		"Druid",
		"Fighter",
		"Monk",
		"Paladin",
		"Ranger",
		"Rogue",
		"Sorcerer",
		"Warlock",
		"Wizard"
	};
	
	private string[] raceTypes = new [] 
	{
		"Aarakocra", 
		"Aasimar",
		"Aetherborn",
		"Aven",
		"Bugbear",
		"Centaur",
		"Changeling",
		"Dragonborn",
		"Dwarf",
		"Elf",
		"Firbolg",
		"Genasi",
		"Gith",
		"Gnome",
		"Goblin",
		"Goliath",
		"Half-Elf",
		"Half-Orc",
		"Halfling",
		"Human",
		"Kenku",
		"Khenra",
		"Kobold",
		"Kor",
		"Lizardfolk",
		"Merfolk",
		"Minotaur",
		"Naga",
		"Orc",
		"Revenant",
		"Shifter",
		"Siren",
		"Tabaxi",
		"Tiefling",
		"Tortle",
		"Triton",
		"Vampire",
		"Vedalken",
		"Warforged",
		"Yuan-Ti Pureblood"
	};
	
    public override void _Ready()
    {
		characterName = (TextEdit)GetNode("Panel/CharacterName");
		classLevel = (OptionButton)GetNode("Panel/ClassLevel");
		AddClassLevels();
		race = (OptionButton)GetNode("Panel/Race");
		AddRaces();
		
    }
	
	private void AddClassLevels()
	{
		foreach(var name in classes)
		{
			classLevel.AddItem(name);
		}
	}

	private void AddRaces()
	{
		foreach(var name in raceTypes)
		{
			race.AddItem(name);
		}
	}
	
	private void OnSelectRace(int ID)
	{
	    // Replace with function body
	}
}

