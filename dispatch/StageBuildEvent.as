package dispatch {
  import flash.events.Event;

  public class StageBuildEvent extends Event {
	public static const ALL_DONE:String = "done";
	public var something:String = "yes";
	public var all_done:String;

	public function get done():String {
	  return something;
	}
	
	public function StageBuildEvent(type:String, str:String) {
	  super(type, true);
	  all_done = str;
	}
	
	public override function clone():Event {
	  return new StageBuildEvent(type, all_done);
	}
  }
}