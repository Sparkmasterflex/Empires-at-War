package stage.userPieces {
	import flash.display.MovieClip;
	import flash.events.*;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import dispatch.pathEvent;
	import dispatch.positionEvent;
	import dispatch.addListenerEvent;
    import staticReturn.getDirection;
    import staticReturn.findSquareAndTest;
    import staticReturn.grabPiece;
	import stage.userPieces.getUnitStartNum;
    	
	import common.selectedUnit;
	import common.testBox;
	
	import stage.userPieces.empires.Army;
    import stage.userPieces.empires.Settler;
    import stage.userPieces.empires.City;
	
	public class gamePiece extends MovieClip
	{		
		/*-- Classes Added --*/
		public var army:Army;
		public var settler:Settler;
		public var city:City;
		public var selectCircle:selectedUnit;
		public var onMoveTest:testBox;
		public var stationaryTest:testBox;
		private var calcMen:getUnitStartNum;
		
		/*-- Numbers --*/
		public var csX:Number;
		public var csY:Number;
		private var dx, dy, dist:Number;
		private var speed = 150;
		private var numMen:Number;
		
		/*-- Arrays --*/
		public var unitsInArmy:Array;
		
		/*-- Strings and MovieClips --*/
		public var pieceEmpire;
		public var current_selected;
		private var facing:String = 'northWest';
		
		/*-- Booleans --*/
		public var thisSelected:Boolean = false;

		public function gamePiece(piece, empire):void {
			mouseChildren = false;
			pieceEmpire = empire;
			switch(piece) {
			  case 10:
				army = new Army(empire);
				addChild(army);
				break;
			  case 20:
				settler = new Settler(empire);
				addChild(settler);
				break;
			  case 30:
				city = new City(empire);
				addChild(city);
				break;
			  default:
				army = new Army(empire);
				addChild(army);
			    break;
			}
			/*onMoveTest = new testBox();
			stationaryTest = new testBox();
			onMoveTest.x = -50;
			onMoveTest.y = -155;
			onMoveTest.alpha = 0;
			stationaryTest.x = -50;
			stationaryTest.y = -155;
			stationaryTest.alpha = 0;
			addChild(onMoveTest);
			addChild(stationaryTest);
			onMoveTest.visible = false;*/
		}
		
	  public function selectPiece(){
		var typeSel = grabPiece.ret(this);
		grabPiece.ret(typeSel).gotoAndPlay('select-ed');
		selectCircle = new selectedUnit(20);
		addChild(selectCircle);
		setChildIndex(selectCircle, 0);
		is_selected(true);
	  }
	  
	  public function unSelect() {
		var typeSel = grabPiece.ret(this);
		grabPiece.ret(typeSel).gotoAndPlay('unselect-ed');
		removeChild(selectCircle);
		is_selected(false);
	  }
	  
	  public function pieceMove(keyCode) {
		var keyPressed = keyCode,
			uCont = this.parent,
			prevSq = grabPiece.ret(this).pieceDetails['square'],
			toSquare = findSquareAndTest.ret(keyPressed, this),
			section = uCont.parent.sGridArr[toSquare.split("_")[2]];
		
		dispatchEvent(new addListenerEvent(addListenerEvent.EVENT, uCont, false));
		toSquare = section.getChildByName(toSquare);
		if(toSquare.mGridInfo.land === true) {
		  var facing = getDirection.ret(prevSq, toSquare);
		  if(grabPiece.ret(this).pieceDetails.leftFacing != facing) {
			grabPiece.ret(this).changeFacing(facing);
			grabPiece.ret(this).pieceDetails.leftFacing = facing;
		  }
				
		grabPiece.ret(this).walk(false);
		TweenLite.to(this, .5,
		   { x:toSquare.mGridInfo.posX, y:toSquare.mGridInfo.posY, onComplete: stopWalk, onCompleteParams: [uCont, toSquare] });
		} else {
		  dispatchEvent(new addListenerEvent(addListenerEvent.EVENT, uCont, true));
		  trace('no!');
		}
	  }
	  
	  public function is_selected(b) {
		thisSelected = b;
	  }
	  
	  public function stopWalk(uCont, newSq) {
		dispatchEvent(new addListenerEvent(addListenerEvent.EVENT, uCont, true));
		grabPiece.ret(this).walk(true);
		uCont.pieceToNewSquare(this, newSq, grabPiece.ret(this).pieceDetails.square);
		grabPiece.ret(this).pieceDetails.square = newSq;
		var onSquareArr = uCont.checkForMultipleUnits(newSq);
		for(var i:uint = 0; i < onSquareArr.length; i++) {
		  trace(onSquareArr[i].name);
		}
	  }
	  
	  public function addUnitArr(unitNums:Array, numbers:*):Array {
		unitsInArmy = new Array();
		for(var i:uint = 0; i < unitNums.length; i++) {
			if(numbers === true) {
			  calcMen = new getUnitStartNum(unitNums[i], pieceEmpire);
			  numMen = calcMen.men;
			} else {
			  if(numbers[i] == 'new') {
				calcMen = new getUnitStartNum(unitNums[i], pieceEmpire);
				numMen = calcMen.men;
			  } else {
				numMen = numbers[i];
			  }
			}
		  unitsInArmy.push([unitNums[i], numMen]);
		}
	  return unitsInArmy;
	}
  }
}