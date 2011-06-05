package staticReturn {
  import flash.display.MovieClip;
	
  public class grabPiece {

	public function grabPiece(){
	  //empty	
    }
    
    public static function ret(parent):MovieClip {
      var mc = parent.getChildAt(parent.numChildren - 1);
      
      return mc;
    }
	
	public static function bottomPiece(parent):MovieClip {
	  var mc = parent.getChildAt(0);
	  
	  return mc;
	}
  }
}