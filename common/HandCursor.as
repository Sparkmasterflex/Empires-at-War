package common {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class HandCursor extends MovieClip {
	  private var openHand:URLRequest = new URLRequest('images/ui/openHand_20.png');
	  private var closeHand:URLRequest = new URLRequest('images/ui/closedHand_15.png');
	  private var openCursor:Loader;
	  private var closedCursor:Loader;
		
	  public function HandCursor() {
		openCursor = new Loader();
		openCursor.load(openHand);
		closedCursor = new Loader();
		closedCursor.load(closeHand);
		addChild(openCursor); 
		addChild(closedCursor); 
		closedCursor.visible = false;
	  }
		
	  public function closeCursor(handOpen:Boolean) {
		if(handOpen) {
		  openCursor.visible = false;
		  closedCursor.visible = true;
		} else {
		  openCursor.visible = true;
		  closedCursor.visible = false;
		}
	  }
	}
}