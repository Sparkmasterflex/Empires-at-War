package static_return {
	import flash.display.MovieClip;
	
	public class FindAndTestSquare {
		public static const UP            =  10
		public static const UP_RIGHT      =  20
		public static const RIGHT         =  30
		public static const DOWN_RIGHT    =  40
		public static const DOWN          =  50
		public static const DOWN_LEFT     =  60
		public static const LEFT          =  70
		public static const UP_LEFT       =  80
		
		public var grid;
		public var gridSqd;
		public var sides:Array;
		
		public function FindAndTestSquare(){
		  //empty constructor
		}
		
		public static function ret(key, sq):String {
		  var direction = testKey(key),
			  square = sq,
			  newSquare = newSquare(square, direction);
			
		  return newSquare;
		}
		
		private static function testKey(key):int {
		  var d;
			switch(key) {
			  case 104:
			  case 38:
			  case 87:
					d = UP;
			    break;

			  case 105:
			  case 33:
			  case 69:
					d = UP_RIGHT;
					break;

			  case 102:
			  case 39:
			  case 68:
					d = RIGHT;
					break;

			  case 99:
			  case 34:
			  case 67:
					d = DOWN_RIGHT;
					break;

			  case 98:
			  case 40:
			  case 88:
					d = DOWN;
					break;

			  case 97:
			  case 35:
			  case 90:
					d = DOWN_LEFT;
					break;

			  case 100:
			  case 37:
			  case 65:
					d = LEFT;
					break;

			  case 103:
			  case 36:
			  case 81:
					d = UP_LEFT;
					break;
		    }
		  return d;
		}
		
		private static function newSquare(s, d):String {
		  var grid = s.parent,
			  gridSqd = grid.sqAcross,
			  currSqName = s.name,
			  sqPos = currSqName.split("_"),
			  vertical, horizantal,
			  sides = testSurroundSection(sqPos[0]);
		  
		  switch(d) {
			case UP:
			case UP_LEFT:
			case UP_RIGHT:
			  vertical = UP;
			  break;
			case DOWN:
			case DOWN_LEFT:
			case DOWN_RIGHT:
			  vertical = DOWN;
			  break;
			}
			
		  switch(d) {
			case LEFT:
			case UP_LEFT:
			case DOWN_LEFT:
			  horizantal = LEFT;
			  break;
			case RIGHT:
			case UP_RIGHT:
			case DOWN_RIGHT:
			  horizantal = RIGHT;
			  break;
		  }

		  var sqRow = upOrDownRow(vertical, gridSqd, sides, sqPos[1]),
		      sqCol = leftOrRightColumn(horizantal, gridSqd, sides, sqPos[2]),
			  sqSection = determineSection(sqPos[0], sqRow[1], sqCol[1]);
			
		  var nSq = sqSection.toString() + "_" + sqRow[0].toString() + "_" + sqCol[0].toString();
			
		  return nSq;
		}
		
		private static function testSurroundSection(section) {
		  var NS_EW:Array;
		  switch(section) {
			case 0:
			  NS_EW = new Array(false, true, true, false);
			  break;
			case 1:
			  NS_EW = new Array(false, true, true, true);
			  break;
			case 2:
			  NS_EW = new Array(false, false, true, false);
			  break;
			case 3:
			  NS_EW = new Array(true, true, false, false);
			  break;
			case 4:
			  NS_EW = new Array(true, true, false, true);
			  break;
			case 5:
			  NS_EW = new Array(true, false, false, true);
			  break;
		  }
			
		  return NS_EW;
		}
		
		private static function upOrDownRow(direction, grid, sides, row):Array {
		  var newRow, section, error = "can't move there";
		  row = int(row)
		  if(direction == UP) {
			newRow = (row != 1) ? row - 1 : sides[0] ? grid : error;
			section = (newRow == grid) ? UP : null;
		  }	else if(direction == DOWN) {
			newRow = (row != grid) ? row + 1 : sides[2] ? 1 : error;
			section = (newRow == 1) ? DOWN : null;
		  } else {
			newRow = row;
			section = null;
		  }
		  var arr:Array = new Array(newRow, section);
		  return arr;
		}
		
		private static function leftOrRightColumn(direction, grid, sides, column):Array {
		  var newColumn,
		      error = "can't move there",
		  	  section;
			
		  column = int(column);
		  if(direction == RIGHT) {
			newColumn = (column != grid) ? column + 1 : sides[1] ? 1 : error;
			section = (newColumn == 1) ? RIGHT : null;
		  } else if(direction == LEFT) {
			newColumn = (column != 1) ? column - 1 : sides[3] ? grid : error;
			section = (newColumn == grid) ? LEFT : null;
		  } else {
			newColumn = column;
			section = null;
		  }
		  var arr:Array = new Array(newColumn, section);
		  return arr;
		}
		
		private static function determineSection(old, vertSection, horzSection):int {
		  var newSection;
		  switch(old) {
		    case 0:
			  newSection = (horzSection == RIGHT && vertSection == null) ? 1 :
				(horzSection == null  && vertSection == DOWN) ? 3 :
				  (horzSection == RIGHT && vertSection == DOWN) ? 4 :
					0;
			  break;
			case 1:
			  newSection = (horzSection == RIGHT && vertSection == null) ? 2 :
				(horzSection == LEFT  && vertSection == null) ? 0 :
				  (horzSection == null  && vertSection == DOWN) ? 4 :
					(horzSection == RIGHT && vertSection == DOWN) ? 5 :
					  (horzSection == LEFT  && vertSection == DOWN) ? 3 :
						1;
			  break;
			case 2:
			  newSection = (horzSection == LEFT  && vertSection == null) ? 1 :
				(horzSection == null  && vertSection == DOWN) ? 5 :
				  (horzSection == LEFT  && vertSection == DOWN) ? 4 :
					2;
			  break;
			case 3:
			  newSection = (horzSection == RIGHT && vertSection == null) ? 4 :
				(horzSection == null  && vertSection == UP)   ? 0 :
				  (horzSection == RIGHT && vertSection == UP)   ? 1 :
					3;
			  break;
			case 4:
			  newSection = (horzSection == RIGHT && vertSection == null) ? 3 :
			    (horzSection == LEFT  && vertSection == null) ? 5 :
				  (horzSection == null  && vertSection == UP)   ? 1 :
					(horzSection == RIGHT && vertSection == UP)   ? 2 :
					  (horzSection == LEFT  && vertSection == UP)   ? 0 :
						4;
			  break;
			case 5:
			  newSection = (horzSection == LEFT  && vertSection == null) ? 0 :
			    (horzSection == null  && vertSection == UP)   ? 2 :
				  (horzSection == LEFT  && vertSection == UP)   ? 1 :
					5;
			  break;
	  } 
	  return newSection;
	}
  }
}

