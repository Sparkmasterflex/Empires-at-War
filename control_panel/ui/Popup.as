package control_panel.ui {
  import common.Gradient;
  import common.ImgLoader;
  import common.Label;
  
  import flash.display.MovieClip;
  
  public class Popup extends MovieClip {
    /*---- Classes Added ----*/
  	public var bg:Gradient;
  	public var title:Label;
    
    /*---- Boolean ----*/
    private var overlay:Boolean;

    /*---- Numbers ----*/
    public var this_width:int;
    public var this_height:int;
	  
    public function Popup(w=700, h=550, overlay_close=true) {
  	  super();
      this_width = w;
      this_height = h;
      can_click_overlay(overlay_close);
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

    public function add_popup_image(img, attrs) {
      var img = new ImgLoader(img);
      img.x = attrs.posX || 10;
      img.y = attrs.posY || 10;
      addChild(img);
      return img;
    }
	
  	public function positionTitle() {
  	  title.x = (bg.width/2) - (title.width/2);
  	  title.y = 15;
      addChild(title);
  	}

    /* Determines if user can close popup by clicking the overlay
     *
     * ==== Parameters:
     * oc:: Boolean
     *
     * ==== Returns:
     * Boolean
     */
    public function can_click_overlay(oc=null) {
      if(oc != null) overlay = oc;
      return overlay;
    }
  }
}