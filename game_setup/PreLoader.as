package game_setup {
  import common.ImgLoader;
  
  import flash.display.MovieClip;
  import flash.events.Event;
  
  public class PreLoader extends MovieClip {
	public var shield:ImgLoader;
	public var theStage;
    
	public function PreLoader(s) {
	  theStage = s;
	  shield = new ImgLoader('ui/shield_preloader.png');
	  
	  addChild(shield);
	  this.addEventListener(Event.ENTER_FRAME, updateLoader);
	}
	
	private function updateLoader(event:Event) {
	  var total:Number = theStage.loaderInfo.bytesTotal,
		  loaded:Number = theStage.loaderInfo.bytesLoaded;
	  
	  trace(loaded.toString() + '/' + total.toString());
	  trace(((loaded/total)*100).toString() + '%');
	  if(loaded >= total) this.removeEventListener(Event.ENTER_FRAME, updateLoader);
	}
  }
}