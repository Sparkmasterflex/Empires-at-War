package stage.stage_elements {
  import common.GenerateMapMath;
  
  import flash.display.MovieClip;
  import flash.display.Stage;
  import flash.external.ExternalInterface;
  import flash.text.TextField;
  
  import stage.stage_elements.MapGrid;
  import stage.stage_elements.StageLand;
  
  public class SectionGrid extends MovieClip {
	/*---- Constants ----*/
	private const LEFT:uint  = 10;
	private const RIGHT:uint = 20;
	
	/*---- Added Classes ----*/
	public var mapSq:MapGrid;
	private var left_gmm:GenerateMapMath;
	private var right_gmm:GenerateMapMath;
	
	/*---- Numbers ----*/
	public var section:uint;
	public var sqAcross:Number = 30;
	private var j:uint = 0;
	private var k:uint = 1;
	private var a:uint = 0;
	private var l:uint = 0;
	public var row:uint;
	public var column:uint;
	private var leftRand:Number = 0;
	private var rightRand:Number = 0;
	private var leftPlus:Number = 0;
	private var rightPlus:Number = 0;
	
	/*---- Arrays & Objects ----*/
	public var mapSqArr:Array = new Array();
	public var landSquares:Array = new Array();
	
	/*-- Booleans --*/
	private var firstLand:Boolean = true;
	
	/*---- MovieClips & Strings ----*/
	public var thisParent;
	
	public function SectionGrid(parent, quadrant) {
	  thisParent = parent;
	  section = quadrant;
	  for(var i:uint = 0; i < Math.pow(sqAcross, 2); i++) {
		mapSq = new MapGrid(this);
		mapSq.x = 100 * j;
		mapSq.y = 100 * (k -1);
		column = j;
		row = k;
		j++;
		if(j == sqAcross) { j = 0; k++; }
		addChild(mapSq);
		mapSq.name = quadrant.toString() + "_" + row.toString() + "_" + column.toString();
		mapSq.addObject(section, row, column, (mapSq.x + 50), (mapSq.y + 60));
		mapSqArr.push(mapSq);
	  }
	}
	
	public function rebuildLand(section) {
	  var sq_names:Array = section.match(/\d_(\d\d|\d)_(\d\d|\d)?/g),
		  terrain:Array = section.match(/terrain\>(\d\d\d|\d\d)/g);
	  for(var i:int = 0; i<sq_names.length; i++) {
		var sq = getChildByName(sq_names[i]),
			t = terrain[i].replace(/terrain\>/, '');
		if(sq.gridInfo.land == false) {
		  sq.addLand(true, int(t));
		  landSquares.push(sq);
		}
	  }
	}
	
	public function createLand(rPos) {
	  k = Math.round(Math.random() * (sqAcross - 5) + 5);
	  a = Math.round(Math.random() * (sqAcross - 5) + 5);
	  for(var down:uint = 0; down < k; down++) {
		j = rPos + (sqAcross * down);
		if(j < Math.pow(sqAcross, 2)) {
		  if(mapSqArr[j].gridInfo.land == false) {
			horizantalLand(j, rPos);
			mapSqArr[j].addLand(true);
			landSquares.push(mapSqArr[j]);
		  }
		} else { break; }
	  }
	  for(var up:uint = 0; up < a; up++) {
		l = rPos - (sqAcross * up);
		if(l > 0 && l < Math.pow(sqAcross, 2)) {
		  if(mapSqArr[l].gridInfo.land == false) {
			horizantalLand(l, rPos);
			mapSqArr[l].addLand(true);
			landSquares.push(mapSqArr[l]);
		  }
		} else { break; }
	  }
	}
	
	private function horizantalLand(j, rPos) {
	  if(firstLand) {
		var spaceRight = sqAcross - (rPos % sqAcross),
			spaceLeft 	= sqAcross - (spaceRight + 1);
		leftRand = spaceLeft > 3 ?
					Math.round(Math.random() * (spaceLeft - 2) + 2) :
					  Math.round(Math.random() * spaceLeft),
		rightRand = spaceRight > 3 ?
					  Math.round(Math.random() * (spaceRight - 2)+ 2) :
					    Math.round(Math.random() * spaceRight);
		firstLand = false;
	  } else {
		left_gmm = new GenerateMapMath(leftPlus, leftRand);
		right_gmm = new GenerateMapMath(rightPlus, rightRand);
		leftPlus = left_gmm._arr[0];
		leftRand = left_gmm._arr[1];
		rightPlus = right_gmm._arr[0];
		rightRand = right_gmm._arr[1];
	  }
	  for(var i:uint = 0; i < (leftRand - 1); i++) {
		  var thisBox = (j -1) - i;
		  if(thisBox > 0 && thisBox < Math.pow(sqAcross, 2)) {
			  if(mapSqArr[thisBox].gridInfo.land == false) {
				  mapSqArr[thisBox].addLand(true);
				  landSquares.push(mapSqArr[thisBox]);
			  }
		  } else { break; }
	  }
	  for(var b:uint = 0; b < (rightRand); b++) {
		  var thatBox = (j + 1) + b;
		  if(thatBox > 0 && thatBox < Math.pow(sqAcross , 2)) {
			  if(mapSqArr[thatBox].gridInfo.land == false) {
				  mapSqArr[thatBox].addLand(true);
				  landSquares.push(mapSqArr[thatBox]);
			  }
		  } else { break; }
	  }
	}
	
	public function recordSection(status) {
	  var column:String = "section_" + section,
		  value:String = "";
	  for(var i:uint = 0; i < landSquares.length; i++) {
		value += landSquares[i].name + ": terrain>" + landSquares[i].gridInfo.terrain + ",";
	  }
	  //ExternalInterface.call("saveMapSection", column, value, status);
	}
	
	public function createCoast() {
	  for(var i:uint = 0; i < landSquares.length; i++) landSquares[i].addCoastLine();
	}
  }
}