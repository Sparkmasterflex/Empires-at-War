package static_return {
  public class GetDirection {
	public function GetDirection() {
	  // empty constructor
	}
	
	public static function ret(prevSq, newSq):Boolean {
	  // TODO check for section as well
	  var prevCol = prevSq.name.split("_")[2],
		  newCol = newSq.name.split("_")[2];
	  return (prevCol > newCol);
	}
  }
}