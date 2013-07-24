package common {
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.display.Loader;
  import flash.net.URLRequest;
  import flash.display.Bitmap;
  
  public class ImgLoader extends MovieClip {
  	/*---- Classes ----*/
  	private var loader:Loader;
  	private var url:URLRequest;
  	private var bitMap:Bitmap;
  	public var bmWidth:Number;
  	public var bmHeight:Number;
  	
  	/*---- MovieClips and Strings ----*/
  	private var path:String = '/images/';
  	
  	public function ImgLoader(image) {
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