package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.*;
import flixel.text.FlxText;
import flash.system.System; 
import flixel.FlxSprite;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var gameTitle:flixel.text.FlxText;
	var btnPlay:flixel.ui.FlxButton;
	var btnExit:flixel.ui.FlxButton;
	var developer:FlxText;
	var background:FlxSprite;

	function clickPlay()
	{
		
			FlxG.switchState(new PlayState());
		
	}
	
	function clickExit()
	{
		
		System.exit(0);
	}

	override public function create():Void
	{
		background =new FlxSprite();
		background.loadGraphic(AssetPaths.background__jpg);
		add(background);
		FlxG.sound.play("assets/sounds/theme.wav",1,true);
		
		FlxG.mouse.visible = true;
		FlxG.cameras.flash(FlxColor.BLACK, 3);
		gameTitle = new FlxText(0, 50, FlxG.width, "GILLI \n DANDA");
	
		gameTitle.setFormat(null,50,FlxColor.ORANGE, "center");
		add(gameTitle);

		btnPlay= new FlxButton (FlxG.width/2-50, FlxG.height/2, "START GAME", clickPlay);
		add(btnPlay);
		
		btnExit= new FlxButton (FlxG.width/2-50, FlxG.height/2+30, "LEAVE GAME", clickExit);
		add(btnExit);

		developer = new FlxText(0, FlxG.height-100, FlxG.width, "");
		developer.setFormat(null, 16, FlxColor.WHITE, "center");
		add(developer);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}