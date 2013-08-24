package control_panel {
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.MouseEvent;

  import com.greensock.*;
  import com.greensock.easing.*;
  
  import control_panel.ui.SquareButton;
  import control_panel.ui.slides.Slide;

  import dispatch.MoveWindowEvent;

  import pieces.GamePiece;

  import common.ImgLoader;
  import common.Label;
  
  public class InfoBox extends MovieClip {
    public var buttons;
    public var fullscreen;
    public var curr_slide:Slide;
    public var current_piece:GamePiece;
    private var eAw;

    public function InfoBox(game, p) {
      super();
      eAw = p;
      var w = 300,
          h = 200;
      setup_box(w, h);
      add_buttons(w, h);
      curr_slide = new Slide(["Use the \"Q\", \"W\", \"E\" keys to move up.","Use the \"A\", \"D\" to move left and right.","Use the \"Z\", \"X\", \"C\" keys to move down."], 'ui/controlPanel/info_box/keys.png');
      addChild(curr_slide);
      eAw.remove_preloader();
    }

    private function setup_box(w, h) {
      var bg = new ImgLoader('ui/controlPanel/info_box.png'),
          brdr = new Sprite();
      brdr.graphics.lineStyle(2, 0x444444);
      brdr.graphics.moveTo(w, 0);
      brdr.graphics.lineTo(w, h);
      brdr.graphics.lineTo(0, h);
      bg.y = -100;
      addChild(bg);
      addChild(brdr);
    }

    /* Add InfoBox control buttons
     *
     * ==== Parameters:
     * w::  Integer
     * h::  Integer
     */
    private function add_buttons(w, h) {
      buttons = new Object();
      var arr = ['rewind', 'fastforward', 'arrowdown', 'arrowup'],
          btn_size = 18,
          y_pos = (h - btn_size) - 10;
      arr.forEach(function(btn) {
        buttons[btn] = new ImgLoader('ui/controlPanel/buttons/'+btn+'.png');
        buttons[btn].name = btn;
        addChild(buttons[btn]);
      });

      // open/close buttons
      buttons['arrowup'].x = (w - btn_size) - 10;
      buttons['arrowdown'].x = (w - btn_size) - 6;
      buttons['arrowup'].y = y_pos;
      buttons['arrowdown'].y = y_pos + 3;
      buttons['arrowdown'].visible = false;

      buttons['arrowup'].addEventListener(MouseEvent.CLICK, collapse_this);
      buttons['arrowdown'].addEventListener(MouseEvent.CLICK, expand_this);
      buttons['rewind'].addEventListener(MouseEvent.CLICK, to_piece);
      buttons['fastforward'].addEventListener(MouseEvent.CLICK, to_piece);

      // previous/next buttons
      buttons['rewind'].x = buttons['arrowdown'].x - (btn_size*2 + 40);
      buttons['fastforward'].x = buttons['arrowdown'].x - (btn_size + 20);
      buttons['rewind'].y = y_pos;
      buttons['fastforward'].y = y_pos;

      fullscreen = new SquareButton("Full Screen", 125, 25, 14);
      fullscreen.x = 10;
      fullscreen.y = y_pos-5;
      addChild(fullscreen);
      fullscreen.addEventListener(MouseEvent.CLICK, eAw.goFullScreen);
    }

    /* Display and expand this for piece information
     *
     * ==== Parameters:
     * show::  Boolean
     * obj::   GamePiece
     */
    public function display(show, obj) {
      remove_current_slide();
      current_piece = obj;
      if(show) {
        curr_slide = new Slide(current_piece);
        addChild(curr_slide);
        expand_this(null);
      } else
        collapse_this(null);
    }

    /* Switch slide to previous GamePiece info
     *
     * ==== Parameters:
     * event:: Event
     *
     * ==== Returns:
     * Slide
     */
    public function to_piece(event:MouseEvent) {
      var emp = current_piece.this_empire,
          index = emp.pieceArray.indexOf(current_piece),
          to;
      if(event.currentTarget.name == 'rewind')
        to = index == 0 ? emp.pieceArray.length-1 : index-1;
      else
        to = index == emp.pieceArray.length-1 ? 0 : index+1;

      display(true, emp.pieceArray[to]);
      emp.pieceArray[to].selectThis(null);
      dispatchEvent(new MoveWindowEvent(MoveWindowEvent.WINDOW, current_piece.x, current_piece.y));
    }
    
    /* 
     * Remove curr_slide and set to null
     */
    private function remove_current_slide() {
      if(curr_slide) {
        removeChild(curr_slide);
        curr_slide = null;
      }
    }

    /* Animates this up/closed and toggles buttons
     *
     * ==== Parameters:
     * event::   MouseEvent
     */
    public function collapse_this(event:MouseEvent) {
      var _this = this;
      TweenLite.to(this, 0.5, {y: -170, onComplete: function() {
          TweenLite.to(_this, 0.25, {x: -270});
        }
      });
      
      buttons['arrowup'].visible = false;
      buttons['arrowdown'].visible = true;
    }

    /* Animates this down/opened and toggles buttons
     *
     * ==== Parameters:
     * event::  MouseEvent
     */
    public function expand_this(event:MouseEvent) {
      var _this = this;
      TweenLite.to(this, 0.25, {x: 0, onComplete: function() {
          TweenLite.to(_this, 0.5, {y: 0});
        }
      });
      
      buttons['arrowup'].visible = true;
      buttons['arrowdown'].visible = false;
    }
  }
}