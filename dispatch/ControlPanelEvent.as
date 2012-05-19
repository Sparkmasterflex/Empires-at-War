package dispatch {
  import flash.events.Event;

  public class ControlPanelEvent extends Event {
	public static const ANIMATE:String = "animate";
	public var something:String = "yes";
	public var attr:Object;
	public var isSelected:Boolean;
	
	public function get animate():String {
	  return something;
	}
	
	public function ControlPanelEvent(type:String, selected:Boolean, attributes:Object) {
	  super(type, true);
	  isSelected = selected;
	  attr = attributes;
	}
	
	public override function clone():Event {
	  return new ControlPanelEvent(type, isSelected, attr);
	}
  }
}