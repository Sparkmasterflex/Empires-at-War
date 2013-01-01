package control_panel.ui {
  import common.Gradient;
  import common.ImgLoader;
  import common.Label;
  
  import flash.display.MovieClip;
  
  public class Popup extends MovieClip {
	public var bg:Gradient;
	public var title:Label;
	  
    public function Popup(w=700, h=550) {
	  super();
	  bg = new Gradient(
	    [0, 0x444444], 'linear', [0xb4920b, 0xd2b12d],
	    [1,1], [0,159], w, h,
	    (3 * Math.PI) / 2, [w,h], 'rectangle'
	  );
	  addChild(bg);
	  title = new Label(30, 0x444444, "Arial", "CENTER");
	  title.text = "Empires at War";
	  positionTitle();
    }
	
	public function positionTitle() {
	  title.x = (bg.width/2) - (title.width/2);
	  title.y = 15;
      addChild(title);
	}
  }
}