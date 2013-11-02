package stage {
	import com.greensock.*;
  import com.greensock.easing.*;

  import flash.display.MovieClip;

  import game_setup.DarkenEdges;
  import static_return.GameConstants;

  import dispatch.*;
  import control_panel.*;
  import control_panel.ui.*;
  import control_panel.ui.popups.*;

  public class ViewPort extends MovieClip {
  	/*---- Classes Added ----*/
  	private var edgeTop:DarkenEdges;
    private var edgeLeft:DarkenEdges;
    public  var ctrl_panel:ControlPanel;
  	public  var info_box:InfoBox;
    public  var eAw;
  	public  var userEmpire;
    public  var overlay:Overlay;

    private var pop;

    public var turn:int;

    public function ViewPort(p) {
      super();
      eAw = p;
      addEventListener(PopupEvent.POPUP, popupHandler);
      mouseEnabled = false;
      edgeTop = new DarkenEdges((3 * Math.PI)/2);
  	  edgeLeft = new DarkenEdges(0);
  	  addChild(edgeTop);
  	  addChild(edgeLeft);
    }

    /* Description
     *
     * ==== Parameters:
     * params
     *
     * ==== Returns:
     * returns
     */
    public function addControlPanel(game, emp) {
  	  turn = game.turn;
  	  ctrl_panel = new ControlPanel(emp, turn, eAw);
  	  addChild(ctrl_panel);
  	  return ctrl_panel;
  	}

  	/* Description
  	 *
  	 * ==== Parameters:
  	 * params
  	 *
  	 * ==== Returns:
  	 * returns
  	 */
  	public function addInformationBox(game) {
      info_box = new InfoBox(game, eAw);
      info_box.x = 0;
      info_box.y = -300;
      addChild(info_box);
      TweenLite.to(info_box, 0.75, {y: 0, delay: 3});

      return info_box;
    }

    /*--------------------------------------- Popup Functions -------*/
    private function showPopup(popup) {
      var centerW = GameConstants.WIDTH_CENTER - popup.this_width/2;
      overlay = new Overlay(GameConstants.STAGE_WIDTH, GameConstants.STAGE_HEIGHT, popup);
      overlay.alpha = 0;
      addChild(overlay);
      setChildIndex(overlay, this.numChildren - 2);
      popup.x = centerW;
      popup.y = 100;
      popup.alpha = 0;
      addChild(popup);
      TweenLite.to(overlay, 0.25, { alpha:0.4 });
      TweenLite.to(popup, 0.25, { y:25, alpha:1 });
    }

    private function tweenOutPopup(popup) {
      TweenLite.to(popup, .25, {x: (GameConstants.WIDTH_CENTER - (popup.width*1.35)/2), y: -50, scaleX:1.35, scaleY:1.35, alpha:0});
      TweenLite.to(overlay, .25, {alpha:0, onComplete: removePopup, onCompleteParams: [popup]});
    }

    private function removePopup(p) {
      removeChild(p);
      removeChild(overlay);
      pop = null;
    }

    /*--------------------------------------- FormControlPanel ------*/
    public function popupHandler(event:PopupEvent) {
      var popup = event.popup,
          params = event.parameters,
          show = event.showPopup,
          object = event.object,
          type = event.popup;

      if(show) {
        if(pop) removePopup(pop);
        switch(popup) {
          case 'City':
            pop = new BuildPopup(params, object);
            break;
          case 'Army':
            pop = new RecruitPopup(params, object);
            break;
          case 'Battle':
            // when battle, object is array of attacker and defender
            // actual gamepieces
            pop = new BattlePopup(type, object[0], object[1]);
            break;
          case 'Conquer':
            // object[1] is conqueror
            // object[0] is conquered
            pop = new ConquerPopup(type, object[1], object[0]);
            break;
          case 'Unit':
            pop = new UnitPopup(type, object);
            break;
          default:
            null;
        }
        showPopup(pop);
      } else {
        tweenOutPopup(event.popup);
      }
    }

    /* Prevent ctrl_panel and info_box from scaling
     *
     * ==== Parameters:
     * w:: int
     * h:: int
     *
     */
    public function prevent_children_scale(w, h) {
      var scX = w/GameConstants.STAGE_WIDTH,
          scY = h/GameConstants.STAGE_HEIGHT;
      new Array([ctrl_panel, info_box]).forEach(function(el) {
        el.scaleX = 0.8;
        el.scaleY = 0.3;
      });
    }
  }
}