package stage {
	import com.greensock.*;
  import com.greensock.easing.*;
  import com.demonsters.debugger.MonsterDebugger;
  
  import flash.display.MovieClip;
  
  import game_setup.DarkenEdges;
  import static_return.GameConstants;
  import control_panel.*;
  
  public class ViewPort extends MovieClip {
  	/*---- Classes Added ----*/
  	private var edgeTop:DarkenEdges;
    private var edgeLeft:DarkenEdges;
    public  var ctrl_panel:ControlPanel;
  	public  var info_box:InfoBox;
  	public  var eAw;

    public var turn:int;
    
    public function ViewPort(p) {
      super();
      MonsterDebugger.initialize(this);
      eAw = p;
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
      MonsterDebugger.trace(this, 1/scX);
      MonsterDebugger.trace(this, 1/scY);
      new Array([ctrl_panel, info_box]).forEach(function(el) {
        el.scaleX = 0.8;
        el.scaleY = 0.3;
      });
    }
  }
}