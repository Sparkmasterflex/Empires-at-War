package control_panel.ui {
  import flash.events.MouseEvent;
  import flash.display.MovieClip;

  import common.Gradient;
  import common.ImgLoader;
  import common.Label;

  import dispatch.PopupEvent;


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
      if(overlay) add_close_button();
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

    /* Adds button to allow user to close popup
     *
     * ==== Returns:
     * SquareButton
     */
    private function add_close_button() {
      var close_btn = new MovieClip(),
          x_lbl = new Label(18, 0xd2b12d, "Arial", "CENTER");
      close_btn.graphics.beginFill(0x444444);
      close_btn.graphics.lineStyle(2, 0xd2b12d);
      close_btn.graphics.drawCircle(0, 0, 15);

      close_btn.x = this_width;
      close_btn.y = 0;
      x_lbl.text = "X";
      x_lbl.x = -8;
      x_lbl.y = -12;

      close_btn.addChild(x_lbl);
      addChild(close_btn);
      close_btn.addEventListener(MouseEvent.CLICK, close_this)
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

    /* Dispatch event to close this
     *
     * ==== Parameters:
     * event:: MouseEvent
     *
     * ==== Returns:
     * returns
     */
    public function close_this(event:MouseEvent) {
      dispatchEvent(new PopupEvent(PopupEvent.POPUP, this));
    }
  }
}