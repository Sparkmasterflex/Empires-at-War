package dispatch {
  import flash.events.Event;
  import flash.display.MovieClip;

  public class RemoveEvent extends Event {
	public static const REMOVE:String = "remove";
	public var movieClip:MovieClip;
	public var neededClass;
	public var something:String = "yes";

	public function get remove():String{
	  return something;
	}

    public function RemoveEvent(type:String, mc:MovieClip, toClass) {
	  super(type, true);
	  movieClip = mc;
	  neededClass = toClass;
	}

	public override function clone():Event {
	  return new RemoveEvent(type, movieClip, neededClass);
	}
  }
}