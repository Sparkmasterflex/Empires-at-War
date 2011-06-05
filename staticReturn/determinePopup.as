package staticReturn {
  import flash.display.MovieClip;
  
  import control_Panel.popups.UnitInfo;
	
  public class determinePopup {
  	
	public function determinePopup(){
	  // empty constructor
	}
	
	public static function ret(type:String, params, emp:String):MovieClip {
	  var mc;
	  switch(type) {
	  	case 'UnitInfo':
          var uInfo:UnitInfo = new UnitInfo(params, emp);
          mc = uInfo;
          break;
        
	  }
	  return mc;
	}
  }
}