package dispatch {
  import flash.events.Event;

  public class MoveWindowEvent extends Event {
	public static const WINDOW:String = "window";
	public var posX:Number;
	public var posY:Number;
	public var something:String = "yes";
	
	public function get window():String {
	  return something;
	}
	
	public function MoveWindowEvent(type:String, pX:Number, pY:Number) {
	  super(type, true);
	  posX = pX;
	  posY = pY;
	}
	
	public override function clone():Event {
	  return new MoveWindowEvent(type, posX, posY);
	}
  }
}