package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;

  import armyBase;

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
    public var tmp_army:armyBase;
    public var interval;
  	
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

	  /*---------- Numbers ---------*/
    public var child_length:uint;
	  
    public function GamePiece(empire) {
      this_stage = empire.gStage
      attr = new Object();
      child_length = 0;
  	  this_empire = empire;
      attr['rally'] = false;
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

    /* Tests if playable by human player
     *
     * ==== Returns:
     * Boolean
     */
    public function playable() {
      return this_empire.playable();
    }
    
  	public function named(named=null) {
  	  if(named) attr['name'] = named;
  	  return attr['name'];
  	}
  	
  	public function empire(e=null):Array {
  	  if(e) attr['empire'] = [e, GameConstants.parseEmpireName(e)];
  	  return attr['empire'];
  	}

    /* Tests if this piece is primary, on game start focus window here
     *
     * ==== Parameters:
     * p:: Boolean
     *
     * ==== Returns:
     * Boolean
     */
    public function primary(p=false) {
      if(p) attr['primary'] = p;
      return attr['primary'];
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

    /* Set status
     *
     * ==== Parameters:
     * s:: Integer
     *
     * ==== Returns:
     * Integer
     */
    public function status(s=null) {
      if(s != null) attr['status'] = s;
      return attr['status'];
    }

    /* set turn timer to remove 
     * 
     * ==== Parameters:
     * t:: Integer
     *
     * ==== Returns:
     * Integer
     */
    public function change_status_in(t=null, start_count=false) {
      // if setting status_change or incrementing down save piece
      if(start_count || t != null) changed(true);
      if(start_count)
        attr['status_change'] = t;
       else if(t != null)
        attr['status_change'] -= t;
      return attr['status_change'];
    }

    /* Change status to arguement passed
     *   reset status() && change_status_in() to null
     *
     * ==== Parameters:
     * st:: Integer
     *
     * ==== Returns:
     * status
     */
    public function change_status_to(st) {
      switch(st) {
        case GameConstants.DESTROY:
          if(obj_is('city')) remove_ruins();
          break;
        case GameConstants.LOOTED:
          if(obj_is('city')) remove_looting();
      }

      status(false);
      change_status_in(false);
      return status();
    }
    
    public function saveAttributes() {
      if(changed()) {
        ExternalInterface.call("savePiece", createJSON());
        changed(false);
      }
    }

    public function test_for_save(len) {
      if(child_length >= len) {
        if(attr['units']) displayTotalMenBar();
        ExternalInterface.call('savePiece', createJSON());
        clearInterval(interval);
      }
    }

    /* builds array of Units
     * 
     * ==== Parameters:
     * arr::Array
     * 
     * ==== Returns
     * Array
     */
    public function build_units(arr) {
      var units = new Array();
      arr.forEach(function(u) {
        units.push(new Unit(u, this_empire.named()));
      });
      return units;
    }

    /* creates array of unit data based on string from DB
     * 
     * ==== Parameters:
     * str::String
     * 
     * ==== Returns
     * Array
     */
    public function parseUnitsString(str) {
      var units = new Array(),
          arr = str.split('||');
      arr.forEach(function(str) {
        if(str != "") units.push(str.split(','));
      });

      return units;
    }

    /* builds array of Agents
     * 
     * ==== Parameters:
     * arr::Array
     * 
     * ==== Returns
     * Array
     */
    public function build_agents(arr) {
      var agents = new Array();
      arr.forEach(function(a) { 
        switch(a) {
          case GameConstants.SETTLER:
          case "Settler":
            agents.push(new Settler());
            break;
        }
      });

      return agents;
    }

    /* creates array of agent data based on string from DB
     * 
     * ==== Parameters:
     * str::String
     * 
     * ==== Returns
     * Array
     */
    public function parseAgentsString(str) {
      var agents = new Array(),
          agent = '',
          arr = str.split('||');
      arr.forEach(function(str) {
        if(str != "") {
          switch(str) {
            case 'settler':
              agent = GameConstants.SETTLER;
              break;
          }
          agents.push(agent);
        }
      });

      return agents;
    }

    /* builds array of Agents
     * 
     * ==== Parameters:
     * arr::Array
     * 
     * ==== Returns
     * Array
     */
    public function build_buildings(arr) {
      var buildings = new Array();
      arr.forEach(function(b) {
        var bld_attr = {type: b[1], level: b[0], build_points: b[2], obj_call: b[3]}
        buildings.push(new Building(bld_attr, this_empire.named()));
      });
      return buildings;
    }

    /* creates array of building data based on string from DB
     * 
     * ==== Parameters:
     * str::String
     * 
     * ==== Returns
     * Array
     */
    public function parseBuildingsString(str) {
      var buildings = new Array(),
          arr = str.split('||');
      arr.forEach(function(str) {
        if(str != "") buildings.push(str.split(','));
      });

      return buildings;
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
          toSq = FindAndTestSquare.ret(key, obj.square()),
          sq_arr = toSq.split('_'),
          section = this_stage.sGridArr[0];

      if(directionKeys.indexOf(key) >= 0) {
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, false));
        var toSquare = section.getChildByName(toSq),
            other = toSquare.pieces();

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
            if(is_enemy(other)) {
              attack(other);
            } else {
              split_piece_children(toSquare, key, toSquare.pieces());
              selectedArr = null;
            }

          //------ simple combine pieces
          } else {
            is_enemy(other) ? 
              attack(other) : 
                combinePieces(other);
          }
        } else {
          dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));
        }
      }
    }

    /* 
     * Moves piece 3 squares out of danger
     */
    public function retreat_from_battle() {
      if(obj_is('city')) {
        if(tmp_army) removeChild(tmp_army);
      } else {
        var _this = this,
            direction_arr = create_three_step(),
            toSquare = square(),
            i = 0;
        game_piece.gotoAndPlay('walk');
        var interval = setInterval(function() {
          if(i >= direction_arr.length) {
            clearInterval(interval);
            game_piece.gotoAndPlay('stand');
            square(toSquare);
          } else {
            var toSq = FindAndTestSquare.ret(direction_arr[i], toSquare),
              section = this_stage.getChildByName("section_" + toSq.split('_')[0]);
            toSquare = section.getChildByName(toSq);
            if(toSquare.empty() && toSquare.hasLand()) TweenLite.to(_this, .5, { x:(toSquare.gridInfo.posX), y: (toSquare.gridInfo.posY)});
            i++;
          }
        }, 500);
      }
    }

    /* Creates an array of directions for piece to move
     *
     * ==== Parameters:
     * params
     *
     * ==== Returns:
     * Array
     */
    private function create_three_step() {
      var arr = [81, 87, 69, 65, 68, 90, 88, 67],
          start_index = Math.ceil(Math.random()*arr.length-1),
          new_arr = [arr[start_index]];
      for(var i:int=0; i<2; i++) {
        var next_dir = new_arr[i] == arr[arr.length-1] ? arr[0] : 
              new_arr[i] == arr[0] ? arr[1] :
                arr[start_index+(i+1)];
        new_arr.push(next_dir);
      }

      return new_arr;
    }

    private function changeDirection(sq, newSq) {
      if(!obj_is('city')) {
        var left = GetDirection.ret(sq, newSq);
        if(facing() != left) {
          left ? this.scaleX = 0.85 : this.scaleX = -0.85;
          facing(left);
        }
      }
    }

    public function facing(left=null) {
      if(left != null) attr['facing'] = left;
      return attr['facing'];
    }

    /* Set and/or test piece has been changed since last save
     *
     * ==== Parameters:
     * has_change:: Boolean
     *
     * ==== Returns:
     * Boolean
     */
    public function changed(has_change=null) {
      if(has_change != null) attr['changed'] = has_change;
      return attr['changed'];
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
        split_agents_out(sq, key, piece); // TODO: handle changed()/saveAttributes()
      else
        split_army(sq, key, piece);
    }

    // splitting army
    public function split_army(toSquare, key, piece=null) {
      // remove selected units from units() and update piece attributes
      selectedArr.forEach(function(unit) { units().splice(units().indexOf(unit),1); });
      displayTotalMenBar();
      changed(true);

      // if piece != null then add selected to piece.units()
      if(piece && !piece.obj_is('agent')) {
        piece.concat_units(selectedArr);
        piece.displayTotalMenBar();
        piece.changed(true);
        piece.selectThis(null);
      } else {
        // else make new army
        var attr = {
          units: selectedArr,
          agents: (piece ? piece.agents() : null)
        },
            new_army = new Army(this_empire, this_empire.armyArray.length, attr);
        addAndMove(new_army, key);
      }
    }
    
    // creating new Agent and add agents() to it
    public function split_agents_out(toSquare, key, piece=null) {
      selectedArr.forEach(function(agent) { agents().splice(agents().indexOf(agent),1) });
      var new_agent = new Agent(this_empire, this_empire.agentArray.length, {agents: selectedArr});
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
      return piece && empire()[0] != piece.empire()[0];
    }

    /* Begins attack process
     *
     * ==== Parameters:
     * enemy::  GamePiece
     */
    public function attack(enemy) {
      if(enemy.obj_is('agent'))
        combinePieces(enemy);
      else if(obj_is('agent')) {
        trace('no!');
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));
      } else {
        if(enemy.obj_is('city') && !enemy.units()) {
          dispatchEvent(new PopupEvent(PopupEvent.POPUP, 'Conquer', null, [this, enemy], true));
          //enemy.conquered_by(this);
        } else {
          if(enemy.obj_is('city')) enemy.addTemporaryArmy();
          if(obj_is('city')) {
            addTemporaryArmy();
            tmp_army.gotoAndPlay('attack');
          } else
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

      /* if selected piece is an Agent
       *   added this.agents() to new piece
       *   and destroy moving piece
       */
      if(obj_is('agent')) {
        piece2.addAgents(agents());

      /* else if stationary piece is an agent
       *   add piece2.agent() to selected piece
       *   replace stationary piece with selected
       */
      } else if(piece2.obj_is('agent')) {
        addAgents(piece2.agents());
        square(piece2.square());
        x = square().x + 60;
        y = square().y + 60;
        changed(true);
        piece2.destroy();

      /* else neither piece is an agent
       *   combine troops to stationary piece
       *   if agents() add to piece2
       */
      } else {
        piece2.concat_units(units());
        piece2.displayTotalMenBar();
        if(agents()) piece2.addAgents(agents());
      }
      // piece2 is removed if agent so don't select if so
      if(!piece2.obj_is('agent') || (obj_is('agent') && piece2.obj_is('agent'))) {
        piece2.selectThis(null);
        piece2.changed(true);
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, piece2, true));
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
    
    /* Remove unit from Army
     *
     * ==== Parameters:
     * unit:: Unit
     *
     */
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
        agents().splice(agents().lastIndexOf(Settler),1);
        var attrs = {
          population: 0, 
          units: (units() != null && units().length > 0 ? units() : null), 
          agents: agents(),
          square: square()
        }
        var city:City = new City(this_empire, this_empire.cityArray.length, attrs);
        this_stage.addChild(city);
        city.selectThis(null);
        destroy();
      }
    }

    /* 
     * Destroy and remove from game
     */
    public function destroy() {
      square().removeFromSquare();
      this_empire.destroying.push(this_id());
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

    /* Sets/returns if army is currently rallying
     *
     * ==== Parameters:
     * r:: Boolean
     *
     * ==== Returns:
     * Boolean
     */
    public function rally(r=null) {
      if(r != null) attr['rally'] = r;
      return attr['rally'];
    }

    /* Set Temporary Army's empire
     * 
     * ==== Parameters:
     * army:: armyBase
     * 
     */
    public function addTemporaryArmy() {
      tmp_army = new armyBase();
      switch(empire()[0]) {
        case GameConstants.GAUL:
          tmp_army.armyIsGaul();
          break;
        case GameConstants.ROME:
          tmp_army.armyIsRome();
          break;
        default:
          trace('none');
        }
      tmp_army.scaleX = 0.85;
      tmp_army.scaleY = 0.85;
      addChild(tmp_army);
    }
    
    public function createJSON() { return JSON.stringify({general: 'Hannabal'}); }
    public function stopWalk(sq) { return false; }
    public function set_to_destroyed() { return false; }
    public function remove_ruins() { return false; }
    public function remove_looting() { return false; }
	
/*--------------- Next Turn Functions -------------*/
    public function nextTurn(turn) { moves(5); }
  }
}