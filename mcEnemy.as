package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lahiruka
	 */
	public class mcEnemy extends MovieClip 
	{
		public var	sDirection:String;
		private var nSpeed:Number;
		
		public function mcEnemy() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			init();
		}
		
		private function init():void 
		{
			var nEnemies:Number = 4;
			//pick a random number between 1 and nEnemies
			var nRandom:Number = randomNumber(1, nEnemies)
			//set playhead of this enemy clip to random number
			this.gotoAndStop(nRandom);
			//set start position
			setupStartPosition();
		}
		
		private function setupStartPosition():void 
		{
			//pick a random speed
			nSpeed = randomNumber(5, 10);
			//pick a random number for left or right starting position
			var nLeftOrRight:Number = randomNumber(1, 2)
			//if nLeftOrRight== 1 make enemy start from left side
			if (nLeftOrRight==1)  
			{
				//enemy starts from left 
				this.x = -(this.width / 2);
				sDirection = "R";
			} else 
			{
				//enemy starts from right
				this.x = stage.stageWidth + (this.width / 2) ;
				sDirection = "L";
			}
			//set an random altitude for enemy
			//setup min and max altitudes
			var minAlti:Number = stage.stageHeight / 2;
			var maxAlti:Number = (this.height / 2);
			
			//set enemy in random altitudes between minAlti & maxAlti
			this.y = randomNumber(minAlti, maxAlti);
			
			//move enemy
			startMoving();
			
		}
		
		private function startMoving():void 
		{
			addEventListener(Event.ENTER_FRAME, enemyLoop)
		}
		
		private function enemyLoop(e:Event):void 
		{
			//test the direction of enemy
			//if enemy moves to right
			if (sDirection== "R") 
			{
				//move enemy to roght
				this.x += nSpeed;
			} else 
			{
				this.x -= nSpeed;
			}
		}
		
		public function destroyEnemy():void 
		{
			//remove enemy from stage
			parent.removeChild(this);
			//remove any event listeners from the enemy object
			removeEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		function randomNumber(low:Number=0, high:Number=1):Number 
		{
			return Math.floor(Math.random() * (1 + high - low)) + low;
		}
	}

}