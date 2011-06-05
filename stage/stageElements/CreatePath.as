package stage.stageElements {
  import flash.display.MovieClip;
  import flash.display.Sprite;
	
  public class CreatePath extends MovieClip {
  	private var path:Sprite;
  	
    public function CreatePath(start, end) {
	  path = new Sprite();
	  path.graphics.lineStyle(5, 0x990000);
	  path.graphics.moveTo((start.x + 50), (start.y + 50));
	  path.graphics.lineTo((end.x + 50), (end.y + 50));
	  addChild(path);
	}	
  }
}