package static_return {
	
  public class CalculateStartPositions {

	public function CalculateStartPositions(){
	  // empty	
	}
		
	public static function ret(pos):Array {
	  var arr = pos.name.split("_"),
		  posArr:Array = new Array();

      for(var i:uint = 1; i < 13; i++) posArr.push(selectSquare(arr, i));
	  return posArr;
    }
		// NEED to test if row and column are 0 and/or 29
	private static function selectSquare(arr, i):String {
	  var row = arr[1], column = arr[2], section = arr[0],
		  rand:Number = Math.round(Math.random() * 2) + 1,
		  newRow, newCol, name;

	  switch(i) {
		case 1:
		case 4:
		  newRow = (int(row) + rand) < 29 ? (int(row) + rand).toString() : 29;
		  newCol = column;
		  break;
		case 7:
		case 10:
		  newRow = (int(row) - rand) > 0 ? (int(row) - rand).toString() : 0;
		  newCol = column;
		  break;
		case 2:
		case 5:
		  newRow = row;
		  newCol = (int(column) + rand) < 29 ? (int(column) + rand).toString() : 29;
		  break;
		case 8:
		case 11:
		  newRow = row;
		  newCol = (int(column) - rand) > 0 ? (int(column) - rand).toString() : 0;
		  break;
		case 3:
		case 6:
		  newRow = (int(row) + rand) < 29 ? (int(row) + rand).toString() : 29;
		  newCol = (int(column) - rand) > 0 ? (int(column) - rand).toString() : 0;
		  break;
		case 9:
		case 12:
		  newRow = (int(row) - rand) > 0 ? (int(row) - rand).toString() : 0;
		  newCol = (int(column) + rand) < 29 ? (int(column) + rand).toString() : 29;
		  break;
	  }
	    
	  name = section + '_' + newRow + "_" + newCol;

	  return name;
	}
  }
}