package dispatch {
  import flash.events.Event;
  import flash.display.MovieClip;
	
  public class PopupEvent extends Event {
	public static const POPUP:String = "createPopup";
	public var popup;
	public var showPopup:Boolean;
	public var parameters;
	public var empire:String;
	public var something:String = "yes";
		
	public function get createPopup():String {
	  return something;
	}
		
	public function PopupEvent(type:String, pop:*, params:* = null, e:String = null, show:Boolean = false){
	  super(type, true);
	  popup = pop;
	  parameters = params;
	  empire = e;
	  showPopup = show;
	}
		
	public override function clone():Event {
	  return new PopupEvent(type, popup, parameters, empire, showPopup);
	}
  }
}