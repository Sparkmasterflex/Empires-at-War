package dispatch {
   import flash.events.Event;
   
   public class walkEvent extends Event {
      public static const WALKSET:String = "walk path";
      
      public var current_selected;
			public var toX:Number;
			public var toY:Number;
			public var selectedUnit:Boolean = true;
			public var directWalk:String;
      
      public function get walk():String {
         return current_selected;
      }
      
      public function walkEvent(type:String, dirWalk, select, currentSelected, thisX, thisY){
         super(type, true);
				 //trace(select);
				 selectedUnit = select;
         current_selected = currentSelected;
				 toX = thisX + 5;
				 toY = thisY + 15;
				 directWalk = dirWalk;
      }
      
      public override function clone():Event {
         return new walkEvent(type, directWalk, selectedUnit, current_selected, toX, toY);
      }
   }
}