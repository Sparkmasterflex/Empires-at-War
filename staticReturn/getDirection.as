package staticReturn {
    import flash.display.MovieClip;
    	
	public class getDirection {
		
	  public function getDirection(){
	    //empty constructor	
	  }
		
	  public static function ret(prevSq, newSq):Boolean {
	  	// TODO check for section as well
	  	var prevRow = prevSq.name.split("_")[1];
	  	var newRow = newSq.name.split("_")[1];
	    return (prevRow > newRow) ? true : false;	    
      }
	}
}
