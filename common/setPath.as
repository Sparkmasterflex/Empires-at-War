package common {
  import flash.display.Sprite;
  import flash.display.MovieClip;
  import flash.events.Event;
  import com.greensock.*;
  import com.greensock.easing.*;
  import com.greensock.motionPaths.*;
  import common.addTriangle;
	
	public class setPath extends Sprite {
		private var fromX:Number;
		private var fromY:Number;
		public var toX:Number;
		public var toY:Number;
		private var finY:Number;
		private var finX:Number;
		private var xSpeed:Number;
		private var ySpeed:Number;
		public var myfinishX:Number;
		public var myfinishY:Number;
		public var angle:Number;
		public var triangle:addTriangle;
		public var walkDirection;
		public var thisMC;
		
		public function setPath(fromX:Number, fromY:Number, finX, finY, endPoint):void {
			toY = fromY;
			toX = fromX;
			thisMC = endPoint;
			myfinishX = finX;
			myfinishY = finY;
			angle = Math.atan2((finY - fromY), (finX - fromX));
			angle = angle*(180/Math.PI);
			if(fromY < finY) {
				ySpeed = (finY - fromY) / 20;
				walkDirection = 'south';
			} else {
				ySpeed = (finY - fromY) / 20;
				walkDirection = 'north';
			}
			if(fromX < finX) {
				xSpeed = (finX - fromX) / 20;
				walkDirection += 'East';
			} else {
				xSpeed = (finX - fromX) / 20;
				walkDirection += 'West';
			}
			triangle = new addTriangle(0x990000, 0x990000, 30, angle);
			triangle.x = fromX - 10;
			triangle.y = fromY - 20;
			graphics.lineStyle(8, 0x990000);
			graphics.moveTo(fromX, fromY);
			addEventListener(Event.ENTER_FRAME, animateLine);
			addChild(triangle);
		}
		
		public function animateLine(event:Event):void
		{
			//trace(walkDirection);
			toY += ySpeed;
			toX += xSpeed;
			graphics.lineTo(toX, toY);
			switch(walkDirection) {
				case 'northEast':
					triangle.x = toX - 10;
				  triangle.y = toY - 12;
					/*if(toX > myfinishX && toY < myfinishY) {
						removeEventListener(Event.ENTER_FRAME, animateLine);
					}*/
					break;
				case 'northWest':
					triangle.x = toX - 10;
					triangle.y = toY + 10;
					/*if(toX < myfinishX && toY < myfinishY) {
						removeEventListener(Event.ENTER_FRAME, animateLine);
					}*/
					break;
				case 'southEast':
					triangle.x = toX + 10;
					triangle.y = toY - 12;
					/*if(toX > myfinishX && toY > myfinishY) {
						removeEventListener(Event.ENTER_FRAME, animateLine);
					}*/
					break;
				case 'southWest':
					triangle.x = toX + 10;
					triangle.y = toY + 12;
					/*if(toX < myfinishX && toY > myfinishY) {
						removeEventListener(Event.ENTER_FRAME, animateLine);
					}*/
					break;
			}
			if(triangle.hitTestObject(thisMC)) {
				removeEventListener(Event.ENTER_FRAME, animateLine);
			}
		}
	}
}
