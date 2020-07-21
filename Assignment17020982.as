package 
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
		
	/**
	 * ...
	 * @author Lahiruka
	 */
	public class Assignment17020982 extends MovieClip 
	{
		//public var mcPlayer:MovieClip;
		
		private var leftkeyIsDown:Boolean;
		private var rightkeyIsDown:Boolean;
		
		private var aArrowArray:Array;
		private var	aEnemyArray:Array;
		
		//public var scoreText:TextField;
		//public var missilesText:TextField;
		//public var menuEnd:mcEndGameScreen;
		
		private var tEnemyTimer:Timer;
		private var nscore:Number;
		private var nMissiles:Number;
		
		
		public function Assignment17020982() 
		{
			playGameAgain(null);
		}
			
		private function playGameAgain(e:Event):void 
		{
			//initialize variables
			aArrowArray = new Array();
			aEnemyArray = new Array();
			nscore = 0;
			nMissiles = 20;
			
			mcPlayer.visible = true;
			
			menuEnd.addEventListener("PLAY_AGAIN", playGameAgain);
			menuEnd.hideScreen();
			
			updateScoreText();
			updateMissilesText();
			
			//trace("Game Loaded");
			//setting up listeners to listen when a key is pressed and released
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keydown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyup);
			
			//setup a gameloop event listener
			stage.addEventListener(Event.ENTER_FRAME, gameLoop);
			
			//create a timer object
			tEnemyTimer = new Timer(1000)
			//listen for timer ticks
			tEnemyTimer.addEventListener(TimerEvent.TIMER, addEnemy)
			//start timer
			tEnemyTimer.start();
		}
		
		private function updateScoreText():void 
		{
			scoreText.text = "Score: " + nscore;
		}
		
		private function updateMissilesText():void 
		{
			missilesText.text = "Missiles: " + nMissiles;
		}
		
		private function addEnemy(e:TimerEvent):void 
		{
			//create a new enemy object
			var newEnemy:mcEnemy = new mcEnemy();
			//add it to stage
			stage.addChild(newEnemy);
			//add new enemy to enemy array collection
			aEnemyArray.push(newEnemy);
			trace(aEnemyArray.length);
		}
		
		private function gameLoop(e:Event):void 
		{
			playerControl();
			clampPlayertoStage();
			checkArrowsOffScreen();
			checkEnemiesOffScreen();
			checkCollision();
			checkEndGameCondition();
		}
		
		private function checkEndGameCondition():void 
		{
			//check if player dont have any missiles left and no missiles on screen
			if (nMissiles == 0 && aArrowArray.length == 0) 
			{
				//stop player movement and hide it
				mcPlayer.visible = false;
				//stop enemies and remove enemies in the stage
				tEnemyTimer.stop();
				for each (var enemy:mcEnemy in aEnemyArray) 
				{
					//destroy the enemy
					enemy.destroyEnemy();
					//remove it from enemy array
					aEnemyArray.splice(0, 1);
				}
				//stop the game loop
				if (aEnemyArray.length == 0) 
				{
					stage.removeEventListener(Event.ENTER_FRAME, gameLoop);
				}
				/////show end game screen
				menuEnd.showScreen();
			}
				
		}
		
		private function checkCollision():void 
		{
			//loop through current arrows
			for (var i:int = 0; i < aArrowArray.length; i++) 
			{
				//get current arrow in the i loop
				var currentArrow:mcArrow = aArrowArray[i];
				//loop through all enemies
				for (var j:int = 0; j < aEnemyArray.length; j++) 
				{
					//get the current enemy in the j loop
					var currenEnemy:mcEnemy = aEnemyArray[j];
					
					//test if current arrow hits current enemy
					if (currentArrow.hitTestObject(currenEnemy)) 
					{
						//create an explosion
						//create a new explosion instance/movieclip
						var newExplosion:mcExplosion = new mcExplosion()
						//add explosion to stage
						stage.addChild(newExplosion)
						//position explosion to enemy
						newExplosion.x = currenEnemy.x;
						newExplosion.y = currenEnemy.y;
						
						//remove arrow
						currentArrow.destroyArrow()
						aArrowArray.splice(i, 1);
						
						//remove enemy
						currenEnemy.destroyEnemy()
						aEnemyArray.splice(j, 1);
						
						//add one to score
						nscore++;
						updateScoreText();
					}
				}
			}
		}
		
		private function checkEnemiesOffScreen():void 
		{
			//loop throught all enemies
			for (var i:int = 0; i <aEnemyArray.length; i++) 
			{
				//get current enemy loop
				var currentEnemy:mcEnemy = aEnemyArray[i];
				//if current enemy is moving left AND has gone past the left side of the stage
				if (currentEnemy.sDirection == "L" && currentEnemy.x <-(currentEnemy.width/2)) 
				{
					//remove enemy from array
					aEnemyArray.splice(i, 1);
					//remove enemy from the stage
					currentEnemy.destroyEnemy();
				} else 
				{
					if (currentEnemy.sDirection == "R" && currentEnemy.x > (stage.stageWidth + currentEnemy.width/2)) 
					{
					//remove enemy from array
					aEnemyArray.splice(i, 1);
					//remove enemy from the stage
					currentEnemy.destroyEnemy();
					}
				}
				
			}
		}
		
		private function checkArrowsOffScreen():void 
		{
			//loop through all arrows in arrows array
			for (var i:int = 0; i < aArrowArray.length; i++) 
			{
				//get the current arrows in the loop
				var currentArrow:mcArrow = aArrowArray[i];
				//test is current arrow has passed the top of the screen
				if (currentArrow.y < 0) 
				{
					//remove current arrows from the array
					aArrowArray.splice(i, 1);
					//destroy arrow
					currentArrow.destroyArrow();
				}
					
			}
		}
		
		private function clampPlayertoStage():void 
		{
			//if player is in left of stage
			if (mcPlayer.x < mcPlayer.width/2) 
			{
				//set the player to the left side
				mcPlayer.x = mcPlayer.width/2;
			}
			//else if player is in right of the stage
			else if (mcPlayer.x > stage.stageWidth - (mcPlayer.width/2)) 
			{
				//set the player to the right side
				mcPlayer.x = (stage.stageWidth - (mcPlayer.width/2));
			}
		}
		
		private function playerControl():void 
		{
			//if left key is currently down
			if (leftkeyIsDown==true) 
			{
				//move player to the left
				mcPlayer.x -= 5;
			}
			//if right key is currently down
			if (rightkeyIsDown==true) 
			{
				//move player to right
				mcPlayer.x += 5;
			}
		}
		
		private function keyup(e:KeyboardEvent):void 
		{
			//trace(e.keyCode);
			//if our left key is released
			if (e.keyCode== 37) 
			{
				//left key is released
				leftkeyIsDown = false;
			}
			//if our right key is released
			if (e.keyCode== 39) 
			{
				//right key is released
				rightkeyIsDown = false;
			}
			//if space bar is released
			if (e.keyCode==32) 
			{
				
				//test if the player has a arrow to fire a missile
				if (nMissiles > 0) 
				{
					nMissiles--;
					updateMissilesText();
					//shoot an arrow
					shootArrow();
				}
				
			}
		}
		
		private function shootArrow():void 
		{
			//create a new arrow
			var newArrow:mcArrow = new mcArrow();
			//add that arrow to stage
			stage.addChild(newArrow);
			//position arrow on top of player
			newArrow.x = mcPlayer.x;
			newArrow.y = mcPlayer.y;
			//add new arrow to arrow array
			aArrowArray.push(newArrow);
			trace(aArrowArray.length);
		}
		
		private function keydown(e:KeyboardEvent):void 
		{
			//trace(e.keyCode);
			//if our left key is pressed
			if (e.keyCode== 37) 
			{
				//left key is pressed
				leftkeyIsDown = true;
			}
			//if our right key is pressed
			if (e.keyCode== 39) 
			{
				//right key is pressed
				rightkeyIsDown = true;
			}
		}
		
	}

}