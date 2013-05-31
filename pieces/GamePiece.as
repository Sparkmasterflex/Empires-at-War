package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;

  import common.ImgLoader;
  
  import dispatch.*;
  
  import empires.Empire;
  import stage.GameStage;
  
  import flash.display.MovieClip;
  import flash.events.*;
  import flash.utils.*;
  import flash.external.ExternalInterface;
  
  import pieces.PercentBar;
  import pieces.agents.Settler;
  
  import static_return.*;
  

  public class GamePiece extends MovieClip {
  	/*--------Classes Added------------*/
  	public var highlight:ImgLoader;
  	private var fadeTimer:Timer;
  	public var this_empire:Empire;
    public var bar:PercentBar;
    public var this_stage:GameStage;
    public var game_piece;
  	
  	/*--------Boolean-------*/
  	public var isSelected:Boolean = false;
	
	  /*--------Arrays and Objects-------*/
  	public var attr:Object;
    public var selectedArr:Array;
  	public var directionKeys:Array = new Array(
      81, 87, 69, 65, 68, 90, 88, 67, // Q, W, E, A, D, Z, X, C
      104, 105, 102, 99, 98, 97, 100, 103, // numbers
  		38, 33, 39, 34, 40, 35, 37, 36 // arrow keys
    );
	  
    public function GamePiece(empire) {
      this_stage = empire.gStage
      attr = new Object();
  	  this_empire = empire;
  	  addEventListener(MouseEvent.CLICK, selectThis);
    }
	
  	public function obj_is(obj=null) {
  	  return obj ? (obj == attr['pieceType']) : attr['pieceType'];
  	}
  	
    public function this_id(id=null) {
      if(id) attr['id'] = id;
      return attr['id'];
    }
      
    public function empire_id(emp_id=null) {
      if(emp_id) attr['empire_id'] = emp_id;
      return attr['empire_id'];
    }
    
  	public function named(named=null) {
  	  if(named) attr['name'] = named;
  	  return attr['name'];
  	}
  	
  	public function empire(e=null):Array {
  	  if(e) attr['empire'] = [e, GameConstants.parseEmpireName(e)];
  	  return attr['empire'];
  	}
  	
  	public function square(sq=null):Object {
  	  if(sq) {
  		  var prev = attr['square'];
    		attr['square'] = sq;
    		sq.addToSquare(this, prev);
        x = sq.gridInfo.posX;
        y = sq.gridInfo.posY;
  	  }
  	  return attr['square'];
  	}
  	
  	public function moves(num=null) {
  	  if(!obj_is('city')) {
  	    if(num) attr['moves'] = num;
  	    return attr['moves'];
  	  }
  	}
    
    public function saveAttributes() {
      ExternalInterface.call("savePiece", createJSON());
    }

    //---------------------- Selecting GamePiece
    /* Select GamePiece
     *
     * ==== Parameters:
     * event::   MouseEvent
     */    
  	public function selectThis(event:MouseEvent) {
      if(this_empire.selected_piece == this) {
        remove_highlight();
        this_empire.selected_piece = null;
      } else {
        if(this_empire.selected_piece) this_empire.selected_piece.remove_highlight();
        add_highlight()
        this_empire.selected_piece = this;
      }

      dispatchEvent(new ControlPanelEvent(ControlPanelEvent.ANIMATE, isSelected, this));
  	}

    /* 
     * Add selection highlight
     */
    private function add_highlight() {
      highlight = new ImgLoader('ui/selected.png');
      highlight.x = -80;
      highlight.y = -40;
      addChild(highlight);
      setChildIndex(highlight, 0);

      // highlight fade in and out
      fadeTimer = new Timer(1500);
      fadeTimer.addEventListener(TimerEvent.TIMER, fadeInOut);
      fadeTimer.start();

      isSelected = true;
    }

    private function remove_highlight() {
      removeChild(highlight);
      fadeTimer.removeEventListener(TimerEvent.TIMER, fadeInOut);
      fadeTimer.stop();
      isSelected = false;
    }
    //---------------------- End Selecting GamePiece

    public function pieceMoveKeyBoard(event:*) {
      var key = event.keyCode,
          currSq = square(),
          obj = event.eventPhase ? this : event.prevObj,
          toSq = FindAndTestSquare.ret(key, obj),
          sq_arr = toSq.split('_'),
          section = this_stage.sGridArr[0];

      if(directionKeys.indexOf(key) >= 0) {
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, false));
        var toSquare = section.getChildByName(toSq);

        if(toSquare.hasLand() && (moves() > 0 || obj_is('city'))) {
          // set piece to face direction headed
          if(currSq) changeDirection(currSq, toSquare);

          //------ standard move
          if(toSquare.empty() && selectedArr == null) {
            if(!obj_is('city')) {
              game_piece.gotoAndPlay('walk');
              TweenLite.to(this, .5, { x:(toSquare.gridInfo.posX), y: (toSquare.gridInfo.posY), onComplete: stopWalk, onCompleteParams: [toSquare]});
            }

          //------ splitting piece
          } else if(selectedArr && selectedArr.length > 0) {
            split_piece_children(toSquare, key, toSquare.pieces());
            selectedArr = null;

          //------ simple combine pieces
          } else {
            var other = toSquare.pieces();
            is_enemy(other) ? 
              attack(other) : 
                combinePieces(other);
          }
        } else {
          dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));
        }
      }
    }

    private function changeDirection(sq, newSq) {
      var left = GetDirection.ret(sq, newSq);
      if(facing() != left) {
        left ? this.scaleX = 0.85 : this.scaleX = -0.85;
        facing(left);
      }
    }

    public function facing(left=null) {
      if(left != null) attr['facing'] = left;
      return attr['facing'];
    }

    /* Split selectArr
     *
     * ==== Parameters:
     * sq::      MapGrid
     * key::     Integer
     * piece::   GamePiece
     */
    public function split_piece_children(sq, key, piece=null) {
      if(selectedArr.every(isAgent))
        split_agents_out(sq, key, piece);
      else
        split_army(sq, key, piece);
    }

    // splitting army
    public function split_army(toSquare, key, piece=null) {
      // remove selected units from units()
      selectedArr.forEach(function(unit) { units().splice(units().indexOf(unit),1); });
      displayTotalMenBar();

      // if piece != null then add selected to piece.units()
      if(piece && !piece.obj_is('agent')) {
        piece.concat_units(selectedArr);
        piece.displayTotalMenBar();
        piece.selectThis(null);
      } else {
        // else make new army
        var new_army = new Army(this_empire, this_empire.armyArray.length);
        new_army.units(selectedArr);
        new_army.displayTotalMenBar();
        addAndMove(new_army, key);

        // if piece(agent) add agents to new_army and destroy piece
        if(piece) new_army.agents(piece.agents()); // TODO: somehow piece is being removed, find out how/where
      }
    }
    
    // creating new Agent and add agents() to it
    public function split_agents_out(toSquare, key, piece=null) {
      selectedArr.forEach(function(agent) { agents().splice(agents().indexOf(agent),1) });
      var new_agent = new Agent(this_empire, this_empire.agentArray.length);
      new_agent.agents(selectedArr);
      addAndMove(new_agent, key);
    }
    
    private function addAndMove(obj, key) {
      this_empire.gStage.addChild(obj);
      obj.x = square().x + 60;
      obj.y = square().y + 60;
      obj.selectThis(null);
      obj.pieceMoveKeyBoard({type: "keyDown", keyCode: key, prevObj: this, eventPhase: null});
      obj = null;
    }

    /* Tests if GamePiece is an enemy
     *
     * ==== Parameters:
     * piece::  GamePiece
     *
     * ==== Returns:
     * Boolean
     */
    public function is_enemy(piece) {
      return empire()[0] != piece.empire()[0];
    }

    /* Begins attack process
     *
     * ==== Parameters:
     * enemy::  GamePiece
     */
    public function attack(enemy) {
      if(enemy.obj_is('agent'))
        combinePieces(enemy);
      else {
        if(enemy.obj_is('city') && !enemy.units()) {
          enemy.conquored_by(this);
        } else {
          game_piece.gotoAndPlay('attack');
          var _this = this;
          setTimeout(function() {
            dispatchEvent(new PopupEvent(PopupEvent.POPUP, 'Battle', null, [_this, enemy], true));
          }, 1250)
        }
      }
    }
    
    public function newArmy(arr) { selectedArr = arr; }
  	
  	/* Adds children to GamePiece passed and removes self
     *
     * ==== Parameters:
     * piece2::  GamePiece
     */
  	public function combinePieces(piece2) {
      if(obj_is('agent')) {
        piece2.addAgents(agents());
      } else if(piece2.obj_is('agent')) {
        addAgents(piece2.agents());
        square(piece2.square());
        x = square().x + 60;
        y = square().y + 60;
        piece2.destroy();
      } else {
        piece2.concat_units(units());
        piece2.displayTotalMenBar();
        if(agents()) piece2.addAgents(agents());
      }
      if(!piece2.obj_is('agent')) {
        piece2.selectThis(null);
        destroy();
      }
  	}
    
    // sending units to another army
    public function send_troops_to(other) {
      selectedArr.forEach(function(unit) { units().splice(units().indexOf(unit),1) });
      other.addUnits(selectedArr);
      other.selectThis(null);
      dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, other, true));
    }

    // sending agents to another piece
    public function send_agents_to(other) {
      selectedArr.forEach(function(agent) { agents().splice(agents().indexOf(agent),1) });
      other.addAgents(selectedArr);
      other.selectThis(null);
      dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, other, true));
    }
  	
  	private function fadeInOut(event:TimerEvent) {
  	  var fade = highlight.alpha == 1 ? 0 : 1;
  	  TweenLite.to(highlight, .75, { alpha: fade, ease:Sine.easeIn });
  	}
    
    public function agents(agents=null) {
      var _this = this;
      if(agents) {
        agents.forEach(function(a) { a.this_parent(_this); });
        attr['agents'] = agents;
      }
      return attr['agents']; 
    }

    private function isAgent(obj, index, arr) {
      return (obj is Settler);
    }
  	
    /* Sets units
     *
     * ==== Parameters:
     * units::Array
     *
     * ==== Returns:
     * Array
     */
  	public function units(un=null) {
      var _this = this;
      if(un) {
        un.forEach(function(u) { u.this_parent(_this); });
        attr['units'] = un;
      }
      return attr['units'];
    }
  	
    /* Add a single Unit class
     *
     * ==== Parameters:
     * units::Array
     *
     * ==== Returns:
     * Array
     */
    public function addUnit(unit) {
      if(!attr['units']) attr['units'] = new Array();
      attr['units'].push(unit);
      return units();
    }

    /* Concatinating array of units into units()
     *
     * ==== Parameters:
     * new_units::   Array
     *
     * ==== Returns:
     * Array
     */
    public function concat_units(new_units) {
      attr['units'] = attr['units'] ? attr['units'].concat(new_units) : new_units;
      return attr['units'];
    }
    
    public function removeUnit(unit) {
      units().splice(units().indexOf(unit), 1);
    }
    
    public function addAgents(agents:*) {
      var agent;
      if(!attr['agents']) attr['agents'] = new Array();
      if(agents is Array) {
        for(var i:int=0; i<agents.length; i++) {
          if(agents[i] is int) {
            switch(agents[i]) {
              case GameConstants.SETTLER:
                agent = new Settler(this);
                break;
              case GameConstants.DIPLOMAT:
                trace('not yet');
                break;
            }
            attr['agents'].push(agent)
          } else {
            attr['agents'].push(agents[i])
          }
        }
      } else {
        attr['agents'].push(agents)
      }
    }
    
    public function buildCity() {
      if(hasSettler() && !obj_is('city')) {
        var city:City = new City(this_empire, 0, this_empire.cityArray.length);
        city.x = square().x + 60;
        city.y = square().y + 60;
        city.square(square());
        this_empire.gStage.addChild(city);
        this_empire.pieceArray.push(city);
        this_empire.cityArray.push(city);
        agents().splice(agents().lastIndexOf(Settler),1);
        if(obj_is('agent') && agents().length == 0) this_empire.gStage.removeChild(this);
      }
    }

    public function destroy() {
      square().removeFromSquare();
      this_stage.removeChild(this);
    }
    
    public function hasSettler():Boolean { return agents() && agents().some(function(agent) { return agent is Settler; }); }
    
    public function displayTotalMenBar() {
      if(bar) removeChild(bar);
      bar = new PercentBar(empire()[0], percentOfMen());
      bar.x = 25;
      addChild(bar);
      this.setChildIndex(bar, 0);
      TweenLite.to(bar, .1, {dropShadowFilter:{blurX:1, blurY:1, distance:1, alpha:0.6}});
    }
    
    public function totalMen() {
      var totalMen = 0;
      if(units()) {
        units().forEach(function(unit) { totalMen += parseInt(unit.men()); });
      }
      return totalMen;
    }
    
    private function percentOfMen() {
      var percent = 0;
      percent = Math.round((totalMen() / GameConstants.TOTAL_TROOPS) * 100);
      return percent;
    }
    
    public function createJSON() { return JSON.stringify({general: 'Hannabal'}); }
    public function stopWalk(sq) { return false; }
	
/*--------------- Next Turn Functions -------------*/
    public function nextTurn(turn) { moves(5); }
  }
}