package common {
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.display.Loader;
  import flash.net.URLRequest;
  import flash.display.Bitmap;

  import static_return.GameConstants;
  
  public class ImgLoader extends MovieClip {
  	/*---- Classes ----*/
  	private var loader:Loader;
  	private var url:URLRequest;
  	private var bitMap:Bitmap;
  	public var bmWidth:Number;
  	public var bmHeight:Number;
  	
  	/*---- MovieClips and Strings ----*/
  	private var path:String;
  	
  	public function ImgLoader(image) {
      path = GameConstants.ENVIRONMENT == 'flash' ? 'images/' : '/images/';
  	  loader = new Loader();
  	  url = new URLRequest(path + image);
  	  loader.contentLoaderInfo.addEventListener(Event.COMPLETE, ret);
  	  loader.load(url);
  	}
  	
  	private function ret(event:Event) {
  	  bitMap = Bitmap(loader.content);
  	  bmWidth = bitMap.width;
  	  bmHeight = bitMap.height;
  	  addChild(loader);
  	}
  }
}