package dispatch {
   import flash.events.Event;
   
   public class displayEvent extends Event {
      public static const DISPLAY:String = "display";
	  public var displayObj:Object = new Object();
	  public var unitsIn:String = 'hello world';
	  public var isSelected:Boolean;
      
      public function get display():String {
         return unitsIn;
      }
      
	  public function displayEvent(type:String, obj:Object, sel:Boolean){
	     super(type, true);
		 displayObj = obj;
		 isSelected = sel;
	  }
      
      public override function clone():Event {
         return new displayEvent(type, displayObj, isSelected);
      }
   }
}