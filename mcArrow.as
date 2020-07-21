package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Lahiruka
	 */
	public class mcArrow extends Sprite 
	{
		
		public function mcArrow() 
		{
			//set an eventlistener to see if arrow is added to stage
			addEventListener(Event.ADDED_TO_STAGE, addArrow);
		}
		
		private function addArrow(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addArrow);
			//now arrow is on the stage & run the custom code
			init();
		}
		
		private function init():void 
		{
			addEventListener(Event.ENTER_FRAME, arrowLoop)
		}
		
		private function arrowLoop(e:Event):void 
		{
			this.y -= 10;
		}
		
		public function destroyArrow():void 
		{
			//remove the object from the stage
			parent.removeChild(this);
			//remove any eventlisteners
			removeEventListener(Event.ENTER_FRAME, arrowLoop);
		}
	}

}