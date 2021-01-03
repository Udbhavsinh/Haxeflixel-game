package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxGame;

class PlayState extends FlxState
{
	static inline var BAT_SPEED:Int = 350;
	var _game:FlxGame;
	var player:FlxSprite;
	var ball:FlxSprite;
	var scoreText:FlxText;
	var resetballText:FlxText;
	var healthText:FlxText;
	var incomingText:FlxText;
	var bulletText:FlxText;
	var ballsText:FlxText;
	var bullet:FlxSprite;
	var _shotClock:Float;
	var canshoot:Bool;
	var wallgroup:FlxGroup;
	var bulletsign:FlxSprite;
	var leftWall:FlxSprite;
	var rightWall:FlxSprite;
	var topWall:FlxSprite;
	var bottomWall:FlxSprite;
	var background:FlxSprite;
	var bricks:FlxGroup;
	var multipointbricks:FlxGroup;
	var healthbricks:FlxGroup;
	var ballbricks:FlxGroup;
	var score:Int;
	var health:Int;
	var balls:Int;
	var count:Int;
	var bullets:Int;
	var tileCount:Int;
	var incomingBullets:FlxTypedGroup<FlxSprite>;
	var blackscreen:FlxSprite;
	var resetText:FlxText;
	var gameoverText:FlxText;
	var gamewinText:FlxText;
	var tileCountText:FlxText;
	//var playing:Bool;
	
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		canshoot = true;
		score = 0;
		count = 0;
		health = 100;
		balls = 5;
		bullets = 0;
		tileCount = 186;
		_shotClock = 1.0;
		//playing = true;
		
		FlxG.sound.play("assets/sounds/bgm.wav",0.15,true);
		
		background =new FlxSprite();
		background.loadGraphic(AssetPaths.background__jpg);
		
		scoreText=new FlxText(0,20, FlxG.width, "Score: "+ score);
		scoreText.setFormat(null,15, FlxColor.RED,"left");
		
		
		resetballText=new FlxText(0,FlxG.height/2, FlxG.width, "Ready");
		resetballText.setFormat(null, 25, FlxColor.BLACK, "center");
		resetballText.visible = false;
		
		healthText=new FlxText(0,0, FlxG.width, "HEALTHBAR: "+ health);
		healthText.setFormat(null,15, FlxColor.RED,"left");
		
		incomingText=new FlxText(0,20, FlxG.width, "BOMBS COMING!!!");
		incomingText.setFormat(null, 15, FlxColor.RED, "center");
		incomingText.visible = false;
		
		tileCountText=new FlxText(0,0, FlxG.width, "TILES PENDING: "+tileCount);
		tileCountText.setFormat(null, 15, FlxColor.BLACK, "center");
		
		
		resetText=new FlxText(0,FlxG.height/2-50, FlxG.width, "RESTARTING...");
		resetText.setFormat(null,50, FlxColor.BLACK,"center");
		resetText.visible = false;
		
		gameoverText=new FlxText(0,FlxG.height/2-50, FlxG.width, "YOU LOSE!!!");
		gameoverText.setFormat(null,50, FlxColor.RED,"center");
		gameoverText.visible = false;
		
		gamewinText=new FlxText(0,FlxG.height/2-50, FlxG.width, "YOU WON!!!");
		gamewinText.setFormat(null, 50, FlxColor.BLACK,"center");
		gamewinText.visible = false;
		
		bulletText=new FlxText(0,0, FlxG.width, "Bullets Available: 0");
		bulletText.setFormat(null,15, FlxColor.RED,"right");
		
		ballsText=new FlxText(0,20, FlxG.width, "Balls Remaining: 5");
		ballsText.setFormat(null,15, FlxColor.BLACK,"right");
		
		
		player = new FlxSprite(FlxG.width/2-50, FlxG.height-30);
		player.makeGraphic(100, 10, FlxColor.BLACK);
		player.immovable = true;
		
		ball = new FlxSprite(FlxG.width/2-5, FlxG.height/2);
		//ball.makeGraphic(10, 10, FlxColor.MAGENTA);
		ball.loadGraphic(AssetPaths.ballsprite__png);
		
		blackscreen = new FlxSprite(0,0);
		blackscreen.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackscreen.visible = false;
		
		bulletsign = new FlxSprite(FlxG.width/2-5, FlxG.height-30);
		bulletsign.makeGraphic(2, 10, FlxColor.YELLOW);
		bulletsign.visible = false;
		
		bullet = new FlxSprite(FlxG.width/2-5, FlxG.height-30);
		//bullet.makeGraphic(10, 10, FlxColor.WHITE);
		bullet.loadGraphic(AssetPaths.bullet__png);
		bullet.visible = false;
		
		ball.elasticity = 1;
		ball.maxVelocity.set(250, 250);
		ball.velocity.y = 250;
		
		wallgroup = new FlxGroup();
		
		leftWall = new FlxSprite(0, 40);
		leftWall.makeGraphic(10, FlxG.height-20, FlxColor.BLACK);
		leftWall.immovable = true;
		wallgroup.add(leftWall);
		
		rightWall = new FlxSprite(FlxG.width-10, 40);
		rightWall.makeGraphic(10, FlxG.height-20, FlxColor.BLACK);
		rightWall.immovable = true;
		wallgroup.add(rightWall);
		
		topWall = new FlxSprite(0, 40);
		topWall.makeGraphic(FlxG.width, 10, FlxColor.BLACK);
		topWall.immovable = true;
		wallgroup.add(topWall);
		
		bottomWall = new FlxSprite(0, FlxG.height-10);
		bottomWall.makeGraphic(FlxG.width, 10, FlxColor.YELLOW);
		bottomWall.immovable = true;
		
		
		// Some bricks
		bricks = new FlxGroup();
		
		var bx:Int = 10;
		var by:Int = 50;
		
		var brickColours:Array<Int> = [0xff00ff00, 0xffff00ff, 0xff00ff00, 0xffff00ff, 0xff00ff00, 0xffff00ff];
		
		for (y in 0...6)
		{
			for (x in 0...31)
			{
				var tempBrick:FlxSprite = new FlxSprite(bx, by);
				tempBrick.makeGraphic(20, 20, brickColours[y]);
				tempBrick.immovable = true;
				bricks.add(tempBrick);
				bx += 20;
			}
			
			bx = 10;
			by += 20;
		}
		
		// Some multi points bricks
		multipointbricks = new FlxGroup();
		
		var mbx:Int = 50;
		var mby:Int = 70;
		
		
			for (x in 0...4)
			{
				var tempBrick:FlxSprite = new FlxSprite(mbx, mby);
				//tempBrick.makeGraphic(20, 20, FlxColor.WHITE);
				tempBrick.loadGraphic(AssetPaths.bulletbricksprite__png);
				
				tempBrick.immovable = true;
				multipointbricks.add(tempBrick);
				mbx += 160;
			}
			
			
			mbx = 70;
			mby = 130;
			for (x in 0...3)
			{
				var tempBrick:FlxSprite = new FlxSprite(mbx, mby);
				//tempBrick.makeGraphic(20, 20, FlxColor.WHITE);
				tempBrick.loadGraphic(AssetPaths.bulletbricksprite__png);
				tempBrick.immovable = true;
				multipointbricks.add(tempBrick);
				mbx += 220;
			}
		
			// Some health points bricks
		healthbricks = new FlxGroup();
		
		var mbx:Int = 150;
		var mby:Int = 90;
		
		
			for (x in 0...2)
			{
				var tempBrick:FlxSprite = new FlxSprite(mbx, mby);
				//tempBrick.makeGraphic(20, 20, FlxColor.LIME);
				
				tempBrick.loadGraphic(AssetPaths.healthbrick__png);
				tempBrick.immovable = true;
				healthbricks.add(tempBrick);
				mbx += 260;
			}
			
			// Some ball points bricks
		ballbricks = new FlxGroup();
		
		var mbx:Int = 30;
		var mby:Int = 110;
		
		
			for (x in 0...5)
			{
				var tempBrick:FlxSprite = new FlxSprite(mbx, mby);
				//tempBrick.makeGraphic(20, 20, FlxColor.MAGENTA);
				tempBrick.loadGraphic(AssetPaths.ballbrick__png);
				tempBrick.immovable = true;
				ballbricks.add(tempBrick);
				mbx += 160;
			}
			
		// Then we kind of do the same thing for the enemy invaders; first we make their bullets.
		var numincomingBullets:Int = 10;
		incomingBullets = new FlxTypedGroup(numincomingBullets);
		
		for (i in 0...numincomingBullets)
		{
			var sprite = new FlxSprite( -100, -100);
			sprite.loadGraphic(AssetPaths.bomb2__png);
			//sprite.makeGraphic(20, 20, FlxColor.RED);
			sprite.exists = false;
			incomingBullets.add(sprite);
		}
			
		
		
		tileCount = healthbricks.length + multipointbricks.length + bricks.length + ballbricks.length - 1;
		
		add(background);
		add(player);
		add(ball);
		add(bricks);
		add(multipointbricks);
		add(healthbricks);
		add(ballbricks);
		add(bottomWall);
		add(wallgroup);
		add(bullet);
		add(ballsText);
		add(bulletsign);
		add(bulletText);
		add(healthText);
		add(incomingText);
		add(scoreText);
		add(resetballText);
		add(incomingBullets);
		add(tileCountText);
		add(blackscreen);
		add(resetText);
		add(gameoverText);
		add(gamewinText);
		
		
		
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
		bullets = Math.floor(count / 5);
		//tileCount = healthbricks.length + multipointbricks.length + bricks.length + ballbricks.length;
		//trace(tileCount);
		
		if (score < 0)
		{
			score = 0;
		}
			
		if (health < 0)
		{
			health = 0;
		}
		
		if (count < 0)
		{
			count = 0;
		}
		
		player.velocity.x = 0;
		if (count >= 5){
		
		bulletText.visible = true;
		bulletsign.x = player.x + 49;
		bulletsign.visible = true;
		
		}
		else
		{
			bulletsign.visible = false;
		}
		
		
		if (FlxG.keys.anyPressed([LEFT, A]) && player.x > 10)
		{
			player.velocity.x = - BAT_SPEED;
		}
		else if (FlxG.keys.anyPressed([RIGHT, D]) && player.x < FlxG.width-10)
		{
			player.velocity.x = BAT_SPEED;
			
		}
		
		if (FlxG.keys.justReleased.R)
		{
			blackscreen.visible = true;
			resetText.visible = true;
			ball.velocity.x = 0;
			ball.velocity.y = 0;
			player.exists = false;
			//playing = false;
			new FlxTimer().start(2, function (timer)
			{
			FlxG.resetState();
			FlxG.sound.play("assets/sounds/ballreset.wav");
			});
		}
		
		if (health<=0 || balls<=0)
		{
			blackscreen.visible = true;
			gameoverText.visible = true;
			ball.velocity.x = 0;
			ball.velocity.y = 0;
			player.exists = false;
			health = 100;
			balls = 5;
			FlxG.sound.play("assets/sounds/gameover.wav",0.6,false );
				new FlxTimer().start(4, function (timer)
				{
					FlxG.switchState(new MenuState());
				});
			
			
		}
		//trace(healthbricks.length);
		if (tileCount<=0)
		{
			blackscreen.visible = true;
			gamewinText.visible = true;
			ball.velocity.x = 0;
			ball.velocity.y = 0;
			player.exists = false;
			tileCount = 186;
			FlxG.sound.play("assets/sounds/gamewin.wav",0.6,false);
		
				new FlxTimer().start(5, function (timer)
				{
					FlxG.switchState(new MenuState());
				});
		}
	
		
		if (FlxG.keys.justReleased.SPACE && count>=5 && canshoot ==true)
		{
			var xpos = player.x + 40;
			canshoot = false;
			FlxG.sound.play("assets/sounds/pew.wav");
		
			
			bullet.exists = true;
			bullet.x = xpos;
			bullet.y = FlxG.height - 30;
			bullet.visible = true;
			bullet.velocity.y =-500;
			bullet.velocity.x = 0;
			
			bulletText.text = "Bullets Available: " +bullets;
			count -= 5;
			
			
		}
		if (score>5)
		{
			
			_shotClock -= elapsed;
			
			incomingText.visible = true;
			
		}
		else if (score <= 5	)
		{
			incomingText.visible = false;
		}
		
		if (_shotClock <= 0)
		{
			resetShotClock();
			var incomingBullet = incomingBullets.recycle();
			incomingBullet.reset(10+ Math.floor(Math.random() * (FlxG.width-50)), 10);
			incomingBullet.velocity.y = 400;			
			incomingText.visible = true;
			
			
			
						
		}
		
		
		if (player.x < 10)
		{
			player.x = 10;
		}
		
		if (player.x > FlxG.width-110)
		{
			player.x = FlxG.width-110;
		}
		
		FlxG.collide(ball, wallgroup, ballwall);
		FlxG.overlap(bricks, multipointbricks, removebrick);
		FlxG.overlap(bricks, healthbricks, removebrick);
		FlxG.overlap(bricks, ballbricks, removebrick);
		FlxG.overlap(bricks, wallgroup, removebrick);
		FlxG.collide(player, ball, ping);
		FlxG.collide(player, incomingBullets, incominghit);
		FlxG.collide(ball, bricks, hit);
		FlxG.collide(ball, multipointbricks, mhit);
		FlxG.collide(bullet, multipointbricks, mbhit);
		
		FlxG.collide(ball, healthbricks, ballhithealth);
		FlxG.collide(bullet, healthbricks, bullethithealth);
		
		FlxG.collide(ball, ballbricks, ballhitballbricks);
		FlxG.collide(bullet, ballbricks, bullethitballbricks);
		
		FlxG.collide(bullet, bricks, bullethit);
		FlxG.collide(bullet, topWall, bullethittopwall);
		FlxG.collide(ball, bottomWall, pointsdeduct);
		FlxG.collide(bottomWall, incomingBullets, incominghit2);
		
		
		
	}
	function ballwall(Ball:FlxObject, Wall:FlxObject):Void
	{
		FlxG.sound.play("assets/sounds/wall.wav");
	}
	function hit(Ball:FlxObject, Brick:FlxObject):Void
	{
		Brick.exists = false;
		Brick.kill();
		tileCount -= 1;
		score+=1;
		count += 1;
		bullets = Math.floor(count / 5);
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text = "Tiles Remaining: " + tileCount;
		FlxG.sound.play("assets/sounds/tile.wav");
			
		//FlxG.camera.shake(0.01,0.01);
	}
	
	function removebrick(Brick:FlxObject, SpecialBrick:FlxObject):Void
	{
		Brick.kill();	
		tileCount -= 1;
		tileCountText.text="Tiles Remaining: "+tileCount;
		
	}
	function bullethittopwall(Bullet:FlxObject, TopWall:FlxObject):Void
	{
		Bullet.visible = false;
		canshoot = true;
		//FlxG.camera.shake(0.01,0.01);
	
	}
	
	function mhit(Ball:FlxObject, MultiPointBrick:FlxObject):Void
	{
		MultiPointBrick.exists = false;
		MultiPointBrick.kill();
		tileCount -= 1;
		score+=1;
		count += 10;
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text = "Tiles Remaining: " + tileCount;
		FlxG.sound.play("assets/sounds/tile.wav");
		
		FlxG.camera.shake(0.02,0.01);
		
	}
	
	function mbhit(Bullet:FlxObject, MultiPointBrick:FlxObject):Void
	{
		//MultiPointBrick.exists = false;
		MultiPointBrick.kill();
		tileCount -= 1;
		Bullet.exists = false;
		canshoot = true;
		score+=1;
		count += 10;
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text = "Tiles Remaining: " + tileCount;
		FlxG.sound.play("assets/sounds/bullet.wav");
		FlxG.camera.shake(0.02,0.01);
		
	}
	
	function ballhithealth(Ball:FlxObject, HealthBrick:FlxObject):Void
	{
		//HealthBrick.exists = false;
		HealthBrick.kill();
		tileCount -= 1;
		score+=1;
		health = 100;
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text = "Tiles Remaining: " + tileCount;
		FlxG.sound.play("assets/sounds/tile.wav");
		
		FlxG.camera.shake(0.02,0.01);
		
	}
	
	
	function bullethithealth(Bullet:FlxObject, HealthBrick:FlxObject):Void
	{
		//HealthBrick.exists = false;
		HealthBrick.kill();
		tileCount -= 1;
		Bullet.exists = false;
		score+= 1;
		canshoot = true;
		health = 100;
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text = "Tiles Remaining: " + tileCount;
		FlxG.sound.play("assets/sounds/bullet.wav");
		
		FlxG.camera.shake(0.02,0.01);
		
	}
	
	function ballhitballbricks(Ball:FlxObject, BallBrick:FlxObject):Void
	{
		//BallBrick.exists = false;
		BallBrick.kill();
		tileCount -= 1;
		score+=1;
		balls += 1;
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text = "Tiles Remaining: " + tileCount;
		FlxG.sound.play("assets/sounds/tile.wav");
		
		FlxG.camera.shake(0.02,0.01);
		
	}
	
	
	function bullethitballbricks(Bullet:FlxObject, BallBrick:FlxObject):Void
	{
		//BallBrick.exists = false;
		BallBrick.kill();
		tileCount -= 1;
		Bullet.exists = false;
		score+= 1;
		canshoot = true;
		balls += 1;
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text = "Tiles Remaining: " + tileCount;
		FlxG.sound.play("assets/sounds/bullet.wav");
		
		FlxG.camera.shake(0.02,0.01);
		
	}
	
	function bullethit(Bullet:FlxObject, Brick:FlxObject):Void
	{
		//Brick.exists = false;
		Brick.kill();
		tileCount -= 1;
		Bullet.exists = false;
		score+= 2;
		canshoot = true;
		count += 2;
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text = "Tiles Remaining: " + tileCount;
		FlxG.sound.play("assets/sounds/bullet.wav");
		
		//FlxG.camera.shake(0.01,0.01);
		
	}
	
	function incominghit(Player:FlxObject, incomingBullet:FlxObject):Void
	{
	
		incomingBullet.kill();
		FlxG.camera.shake(0.05, 0.05);
		FlxG.sound.play("assets/sounds/bomb.wav");
		
		score-= 2;
		if (score < 0)
		{
			score = 0;
		}
		
		health -= 20;
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text="Tiles Remaining: "+tileCount;
	}
	function incominghit2(Bottomwall:FlxObject, incomingBullet:FlxObject):Void
	{
		incomingBullet.kill();
		
	}
	
	function pointsdeduct(Ball:FlxObject, Bottomwall:FlxObject):Void
	{
		Ball.exists = false;
		score-= 5;
		FlxG.camera.shake(0.05,0.05);
		if (score < 0)
		{
			score = 0;
		}
		count = 0;
		bullets = 0;
		balls -= 1;
		scoreText.text = "Score: " + score;
		healthText.text = "Health: " + health;
		bulletText.text = "Bullets Available: " +bullets;
		ballsText.text = "Balls Remaining: " + balls;
		tileCountText.text = "Tiles Remaining: " + tileCount;
		resetballText.visible = true;
		FlxG.sound.play("assets/sounds/bottomwall.wav");
		new FlxTimer().start(2, function (timer)
			{
				
				FlxG.sound.play("assets/sounds/ballreset.wav");
				Ball.exists = true;
				Ball.x = FlxG.width / 2 - 5;
				Ball.y = FlxG.height / 2;
				Ball.velocity.y = 250;
				Ball.velocity.x = 0;
				resetballText.visible = false;
	
			});
	}
	
	function resetShotClock():Void
	{
		_shotClock = 1 + FlxG.random.float() * 2;
	}
	
	function ping(Bat:FlxObject, Ball:FlxObject):Void
	{
		var playermid:Int = Std.int(Bat.x) + 50;
		var ballmid:Int = Std.int(Ball.x) + 5;
		var diff:Int;
		
		FlxG.sound.play("assets/sounds/wall.wav");
		
		if (ballmid < playermid)
		{
			// Ball is on the left of the bat
			diff = playermid - ballmid;
			Ball.velocity.x = ( -10 * diff);
		}
		else if (ballmid > playermid)
		{
			// Ball on the right of the bat
			diff = ballmid - playermid;
			Ball.velocity.x = (10 * diff);
		}
		else
		{
			// Ball is perfectly in the middle
			// A little random X to stop it bouncing up!
			Ball.velocity.x = 2 + FlxG.random.int(0, 8);
		}
	}
	
	
}