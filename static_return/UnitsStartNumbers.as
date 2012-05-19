package static_return {

  public class UnitsStartNumbers {
	  
	public function UnitsStartNumbers() {
	  // nothing here
	}
		
    public static function ret(type:Number, empire:String):Number {
	  var men:Number;
	  switch(type) {
	    case 1:
		case 2:
		case 3:
		  men = 200;
		  break;
	    case 4:
	    case 5:
	    case 6:
		  men = 100;
		  break;
		case 7:
		  men = 1;
		  break;
		case 8:
		case 9:
		  men = (empire == 'mongol' && type == 9) ? 100 : 150;
		  break;
		case 10:
		  men = (empire == 'mongol') ? 10 : 75;
		  break;
	  }
	  return men;
	}
  }
}