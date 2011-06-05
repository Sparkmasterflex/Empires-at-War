package dispatch {
   import flash.events.Event;
   
   public class pathEvent extends Event {
      public static const PATHSET:String = "set path";
      
      public var current_selected;
			public var csX:Number;
			public var csY:Number;
			public var selectedUnit:Boolean = false;
      public var curObj:Object;
			
      public function get path():String {
        return current_selected;
      }
      
      public function pathEvent(type:String, select, currentSelected, thisX, thisY/*, inObj:Object*/){
         super(type, true);
				 //trace(select);
				 selectedUnit = select;
         current_selected = currentSelected;
				 csX = thisX;
				 csY = thisY;
				 //curObj = inObj;
      }
      
      public override function clone():Event {
         return new pathEvent(type, selectedUnit, current_selected, csX, csY/*, curObj*/);
      }
   }
}