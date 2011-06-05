package dispatch {
   import flash.events.Event;
   
   public class positionEvent extends Event {
      public static const POSSET:String = "set position";
      
      public var current_selected;
	  public var csX:Number;
	  public var csY:Number;
			//public var selectedUnit:Boolean = false;
      
      public function get position():String {
         return current_selected;
      }
      
      public function positionEvent(type:String, currentSelected, thisX, thisY){
         super(type, true);
				 //trace(thisX + " : " + thisY);
         current_selected = currentSelected;
				 csX = thisX + 5;
				 csY = thisY + 15;
      }
      
      public override function clone():Event {
         return new positionEvent(type, current_selected, csX, csY);
      }
   }
}