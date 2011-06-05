package dispatch {
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class addListenerEvent extends Event {
	  public static const EVENT:String = "addEventListener";
	  public var movieClip:MovieClip;
	  public var listen:Boolean;
	  public var something:String = "yes";
		
		public function get addListener():String {
		  return something;
		}
		
		public function addListenerEvent(type:String, mc:MovieClip, l:Boolean){
		  super(type, true);
	      movieClip = mc;
		  listen = l;
		}
		
		public override function clone():Event {
		  return new addListenerEvent(type, movieClip, listen);
		}
		
	}
}