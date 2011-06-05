package stage.stageElements {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import stage.stageElements.mapGrid;
	import stage.stageElements.stageLand;
	import common.generateMapMath;
	
	public class sectionGrid extends MovieClip {
		/*-- Classes Added --*/
		private var left_gmm:generateMapMath;
        private var right_gmm:generateMapMath;
        public var mapSq:mapGrid;
        private var land:stageLand;
        private var myTestText:TextField; // Just for testing can come out
		
		/*-- Numbers --*/
		public var mSqAcross:Number = 30;
		private var landRandom:Number;
        public var maxNum:Number;
        public var minNum:Number;
        private var j:uint = 0;
        public var column:uint;
        private var k:uint = 1;
        public var row:uint;
        private var a:uint = 0;
        private var l:uint = 0;
        private var spaceRight:Number;
        private var spaceLeft:Number;
        private var leftRand:Number = 0;
        private var rightRand:Number = 0;
        private var leftPlus:Number = 0;
        private var rightPlus:Number = 0;
        public var curSection:uint = 0;
        public var centerSquare:Number = 25;
		
        /*-- Arrays and Objects --*/
        public var mapSqArr:Array = new Array();
        public var sqWlandArr:Array = new Array();
        public var mapSqObj:Object;
        
        /*-- Booleans --*/
        private var firstLand:Boolean = true;
        
        /*-- Strings and MovieClips --*/
		public var squareName:String;
		private var sGridLine:Sprite;
				
		public function sectionGrid(quadrant):void {
			curSection = quadrant;
			for(var i:uint = 0; i < Math.pow(mSqAcross , 2); i++) {
				mapSq = new mapGrid();
				mapSq.x = 100 * j;
				mapSq.y = 100 * (k - 1);
				column = j;
				row = k;
				j++;
				if(j == mSqAcross) {
					j = 0;
					k++;
				}
				squareName = row.toString() + "_" + column.toString() + "_" + quadrant;
				addChild(mapSq);
				mapSq.name = squareName;
				mapSq.addObject(curSection, row, column, (mapSq.x + 50), (mapSq.y + 60));
				//mapSq.addEventListener(MouseEvent.CLICK, mapSquare);
				mapSqArr.push(mapSq);
			    
			}
			//traceAll();
		}
		
		public function createLand(randPos) {
		// TODO find row of landRandom
		// subtract it from mSqAcross
		  landRandom = randPos;
		  k = Math.round(Math.random() * (mSqAcross - 5) + 5);
		  a = Math.round(Math.random() * (mSqAcross - 5) + 5);
		  for(var down:uint = 0; down < k; down++) {
			j = landRandom + (mSqAcross * down);
			if(j < Math.pow(mSqAcross , 2)) {
			  if(mapSqArr[j].mGridInfo.land == false) {
				land = new stageLand(0x000000);
				mapSqArr[j].addChild(land);
				horizantalLand(j);
				mapSqArr[j].addLandToObj(true);
				sqWlandArr.push(mapSqArr[j]);
		 	  }
			} else {
			  break;
			}
		  }
		  for(var up:uint = 0; up < a; up++) {
			l = landRandom - (mSqAcross * up);
			if(l > 0 && l < Math.pow(mSqAcross , 2)) {
			  if(mapSqArr[l].mGridInfo.land == false) {
				land = new stageLand(0xffffff);
				mapSqArr[l].addChild(land);
				horizantalLand(l);
				mapSqArr[l].addLandToObj(true);
				sqWlandArr.push(mapSqArr[l]);
			  }
			} else {
			  break;
			}
		  }
			//traceLand();
		}
		
		private function mapSquare(event:MouseEvent):void
		{
			for(var i:String in event.currentTarget.mGridInfo) {
				 trace(i + ": " + event.currentTarget.mGridInfo[i]);
			}
			trace("\n\n");
		}
		
		private function horizantalLand(j):void
		{
			if(firstLand) {
				spaceRight = mSqAcross - (landRandom % mSqAcross);
				spaceLeft = mSqAcross - (spaceRight + 1);
				if(spaceLeft > 3) {
					leftRand = Math.round(Math.random() * (spaceLeft - 2) + 2);
				} else {
					leftRand = Math.round(Math.random() * spaceLeft);
				}
				if(spaceRight > 3) {
					rightRand = Math.round(Math.random() * (spaceRight - 2)+ 2);
				} else {
					rightRand = Math.round(Math.random() * spaceRight);
				}
				firstLand = false;
			} else {
				left_gmm = new generateMapMath(leftPlus, leftRand);
				leftPlus = left_gmm._arr[0];
				leftRand = left_gmm._arr[1];
				right_gmm = new generateMapMath(rightPlus, rightRand);
				rightPlus = right_gmm._arr[0];
				rightRand = right_gmm._arr[1];
			}
			for(var i:uint = 0; i < (leftRand - 1); i++) {
				var thisBox = (j - 1) - i;
				if(thisBox > 0 && thisBox < Math.pow(mSqAcross , 2)) { 
					if(mapSqArr[thisBox].mGridInfo.land == false) {
						land = new stageLand(0x0000ff);
						mapSqArr[thisBox].addChild(land);
						mapSqArr[thisBox].addLandToObj(true);
						sqWlandArr.push(mapSqArr[thisBox]);
					}
				} else {
					break;
				}
			}
			for(var b:uint = 0; b < (rightRand); b++) {
				var thatBox = (j + 1) + b;
				if(thatBox > 0 && thatBox < Math.pow(mSqAcross , 2)) {
					if(mapSqArr[thatBox].mGridInfo.land == false) {
						land = new stageLand(0xff000);
						mapSqArr[thatBox].addChild(land);
						mapSqArr[thatBox].addLandToObj(true);
						sqWlandArr.push(mapSqArr[thatBox]);
					}
				} else {
					break;
				}
			}
		}
		
		public function traceAll() {
			for(var i:uint = 0; i < mapSqArr.length; i++) {
				myTestText = new TextField();
				myTestText.text = mapSqArr[i].name;
				mapSqArr[i].addChild(myTestText);
			}
		}
		
		public function traceLand() {
			for(var i:uint = 0; i < sqWlandArr.length; i++) {
				myTestText = new TextField();
				myTestText.text = sqWlandArr[i].name;
				sqWlandArr[i].addChild(myTestText);
			}
		}
	}
}