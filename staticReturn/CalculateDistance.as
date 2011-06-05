package staticReturn {
	
  public class CalculateDistance {
  	
	public function CalculateDistance(){
	  // empty	
	}
	
	public static function ret(startMC, finishMC):Number {
	  var startX = startMC.x,
	      startY = startMC.y,
	      finX = finishMC.x,
	      finY = finishMC.y;
	      
	  var distX = startX < finX ? finX - startX : startX - finX,
    	  distY = startY < finY ? finY - startY : startY - finY;
	  
	  return Math.ceil(Math.sqrt(Math.pow(distX, 2) + Math.pow(distY, 2)));
	}
  }
}