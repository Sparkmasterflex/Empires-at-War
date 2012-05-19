package dispatch {
  import flash.events.Event;

  public class StageBuildEvent extends Event {
	public static const ALL_DONE:String = "done";
	public var something:String = "yes";

	public function get done():String {
	  return something;
	}
	
	public function StageBuildEvent(type:String) {
	  super(type, true);
	}
	
	public override function clone():Event {
	  return new StageBuildEvent(type);
	}
  }
}