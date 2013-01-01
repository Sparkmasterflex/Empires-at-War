package static_return {
	
  public class GameConstants {
  	public static const EGYPT:int 			 = 10;
	public static const ROME:int 			 = 20;
	public static const GREECE:int 			 = 30;
	public static const GAUL:int 			 = 40;
	public static const CARTHAGE:int 		 = 50;
	public static const JAPAN:int 			 = 60;
	public static const MONGOLS:int 		 = 70;
	public static const UNDEAD:int 			 = 80;
	public static const EMPIRES:Object = {EGYPT: "Egypt", ROME: "Rome", JAPAN: "Japan", GAUL: "Gaul"};
	
	public static const STAGE_WIDTH:Number   = 1200;
	public static const STAGE_HEIGHT:Number  = 800;
	public static const WIDTH_CENTER:Number  = 600;
	public static const HEIGHT_CENTER:Number = 400;
	
	public static const NEW_GAME:int  = 10;
	public static const ACTIVE:int    = 20;
	public static const VICTORY:int   = 30;
	
	public static const EASYGAME:int  = 10;
	public static const MEDGAME:int	  = 20;
	public static const HARDGAME:int  = 30;

	public static const TOTAL_TROOPS:Number  = 3600;
	
	public static const ARROW_KEYS:Object  = {'up': 38, 'right': 39, 'bottom': 40, 'left': 37 };
//	public var directionKeys:Array = new Array(104, 105, 102, 99, 98, 97, 100, 103,
//		38, 33, 39, 34, 40, 35, 37, 36);
	
	
	public function GameConstants() {
	  
	}
	
	public static function parseEmpireName(emp):String {
	  var empire:String;
	  emp = int(emp);
      switch(emp) {
		case EGYPT:
		  empire = EMPIRES['EGYPT'];
		  break;
		case ROME:
		  empire = EMPIRES['ROME'];
		  break;
		case JAPAN:
		  empire = EMPIRES['JAPAN'];
		  break;
		case GAUL:
		  empire = EMPIRES['GAUL'];
		  break;
	  }
		
	  return empire;
	}
  }
}