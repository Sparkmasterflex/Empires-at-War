package stage {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import com.greensock.*;
    import com.greensock.easing.*;
	import stage.stageElements.stageLand;
	import stage.stageElements.sectionGrid;
	import common.setPath;
	import common.selectedUnit;
	import gameSetup.startsWith;
	import gameSetup.Constants;
	import staticReturn.grabPiece;
	import staticReturn.CalculateDistance;
	import stage.stageElements.CreatePath;
	
	public class gameStage extends MovieClip {
		/*-- Classes Added --*/
		public var userContr:userControlled;
		public var sGrid:sectionGrid;
		public var myLine:setPath;
		private var destination:selectedUnit;
		public var invisibleLine:Sprite;
		public var path:CreatePath;
		
		/*-- Arrays and Objects --*/
		public var enemies:Array;
		public var piecePos:Array;
		public var sGridArr:Array = new Array();
		private var startArr:Array;
		public var userObj:Object = new Object();
		public var enemyObj:Object = new Object();
		
		/*-- Numbers --*/
		public var randomPos:Number;
		public var randomNum:Number;
		private var j:uint = 0;
		private var k:uint = 0;
		public var curX:Number;
		public var curY:Number;
		public var pathSq:Number;
		
		/*-- MovieClips and Strings --*/
		public var empire;
		public var difficulty;
		public var curSelected;
		public var walkDirection;
		public var targetBox;
		public var startPathFrom;
		
		/*-- Boolean --*/
		public var lineAdded:Boolean = false;
		public var pathLaid:Boolean = false;
		
		
		public function gameStage(e:String, d:uint, arr:Array)
		{
			empire = e;
			difficulty = d;
			enemies = arr;
			startArr = startsWith.ret(difficulty, empire);
			userObj = startArr[0];
			enemyObj = startArr[1];
			
			for(var i:uint = 0; i < 6; i++) {
				randomPos = Math.round(Math.random() * 899);
				sGrid = new sectionGrid(i);
				sGrid.x = (3000 * j);
				sGrid.y = (3000 * k);
				j++;
				if(j == 3) {
					j = 0;
					k++;
				}
				addChild(sGrid);
				sGridArr.push(sGrid);
				if(sGridArr.length < 2) {
					sGrid.createLand(randomPos);
				}
			}
			getPos();
		}
		
		public function getPos() {
			var r:Number = Math.round(Math.random() * (sGridArr[0].sqWlandArr.length)),
			    startPos = sGridArr[0].sqWlandArr[r];
			
			userContr = new userControlled(empire, difficulty, 0, startPos, userObj);
			addChild(userContr);
			userContr.getParent(this);
		}
		
		public function beginLayingPath(mc, listen) {
		  curSelected = mc;
		  if(listen) {
		  	addEventListener(Event.ENTER_FRAME, lineToMouse);
		  	startPathFrom = grabPiece.ret(curSelected).thisPieceInfo.square;
		  	for(var i:uint = 0; i < sGridArr.length; i++) {
  	  		  for(var j:uint = 0; j < sGridArr[i].sqWlandArr.length; j++) {
   		  	    sGridArr[i].sqWlandArr[j].addEventListener(Event.ENTER_FRAME, touchedSquare);
	   	  	    sGridArr[i].sqWlandArr[j].addEventListener(MouseEvent.CLICK, selectSquare);
	   	  	  }
		  	}
		  } else {
		  	removeEventListener(Event.ENTER_FRAME, lineToMouse);
		  }
		}
		
		private function lineToMouse(event:Event) {
		  var stX = (grabPiece.ret(curSelected).thisPieceInfo['square'].x + 50),
		      stY = (grabPiece.ret(curSelected).thisPieceInfo['square'].y + 50),
		      mX = (stX > mouseX) ? mouseX + 5 : mouseX - 5,
		      mY = (stY > mouseY) ? mouseY + 5 : mouseY - 5;

		  removeLine();
		  lineAdded = true;
		  invisibleLine = new Sprite();
		  invisibleLine.graphics.lineStyle(1, 0x000000);
		  invisibleLine.graphics.moveTo(stX, stY);
		  invisibleLine.graphics.lineTo(mX, mY);
		  addChild(invisibleLine);
		}
		
		private function removeLine() {
		  if(lineAdded)
            removeChild(invisibleLine);
          lineAdded = false;
		}
		
		private function selectSquare(event:MouseEvent) {
		  var square = event.target,
		      dist = CalculateDistance.ret(curSelected, square),
		      speed = dist/500;
		  
		  TweenLite.to(curSelected, speed, { x:(square.x + 50), y:(square.y + 50),
		                onComplete: curSelected.stopWalk, onCompleteParams: [curSelected, square]});
		  grabPiece.ret(curSelected).walk(false);
		  for(var i:uint = 0; i < sGridArr.length; i++) {
            for(var j:uint = 0; j < sGridArr[i].sqWlandArr.length; j++) {
              sGridArr[i].sqWlandArr[j].removeEventListener(Event.ENTER_FRAME, touchedSquare);
              sGridArr[i].sqWlandArr[j].removeEventListener(MouseEvent.CLICK, selectSquare);
            }
          }
		}
		
		private function touchedSquare(event:Event) {
		  var square = event.target;
		  if(square.hitTestObject(invisibleLine)) {
		  	path = new CreatePath(startPathFrom, square);
		  	addChild(path);
		  	square.removeEventListener(Event.ENTER_FRAME, touchedSquare);
		  	startPathFrom = square;
		  }
		}
	}
}