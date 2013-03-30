package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;
  
  import common.ImgLoader;
  
  import dispatch.AddListenerEvent;
  import dispatch.ControlPanelEvent;
  
  import empires.Empire;
  
  import flash.display.MovieClip;
  import flash.events.*;
  import flash.utils.*;
  import flash.external.ExternalInterface;
  
  import pieces.PercentBar;
  import pieces.agents.Settler;
  
  import static_return.GameConstants;
  

  public class GamePiece extends MovieClip {
  	/*--------Classes Added------------*/
  	public var selected:ImgLoader;
  	private var fadeTimer:Timer;
  	public var selection = null;
  	public var this_empire:Empire;
    public var bar:PercentBar;
  	
  	/*--------Boolean-------*/
  	public var isSelected:Boolean = false;
	
	/*--------Arrays and Objects-------*/
  	public var attr:Object;
    public var selectedArr:Array;
  	public var directionKeys:Array = new Array(104, 105, 102, 99, 98, 97, 100, 103,
  		38, 33, 39, 34, 40, 35, 37, 36);
	  
    public function GamePiece(empire) {
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
  	
  	public function selectThis(event:MouseEvent) {
      var stage = this.parent,
  		    allPieces = this_empire.pieceArray,
  		    current = this;
  	  for(var i:uint=0; i<allPieces.length; i++) { if(allPieces[i].isSelected) selection = allPieces[i]; }
  	  if(current.isSelected || selection) {
    		if(selection) {
    		  current = selection;
    		  addSelected();
    		}
    		removeSelected(current);
    		selection = null;
  	  } else {
  		  addSelected();
  	  }
  	  dispatchEvent(new ControlPanelEvent(ControlPanelEvent.ANIMATE, this.isSelected, this));
  	}
    
    public function newArmy(arr) { selectedArr = arr; }
  	
  	// adding piece1 with piece2 (GamePiece or Array)
  	public function combinePieces(piece2) {
      if(obj_is('agent')) {
        piece2.addAgents(agents());
      } else if(piece2.obj_is('agent')) {
        addAgents(piece2.agents());
        square(piece2.square());
        x = square().x + 60;
        y = square().y + 60;
        piece2.square().removeFromSquare();
        this_empire.gStage.removeChild(piece2);
      } else {
        piece2.addUnits(units());
        if(agents()) piece2.addAgents(agents());
      }
      if(!piece2.obj_is('agent')) {
        piece2.selectThis(null);
        square().removeFromSquare();
        this_empire.gStage.removeChild(this);
      }
  	}
    
    // splitting army
    public function split_army(toSquare, key) {
      selectedArr.forEach(function(unit) { units().splice(units().indexOf(unit),1) });
      var new_army = new Army(this_empire, selectedArr, this_empire.armyArray.length);
      addAndMove(new_army, key);
    }
    
    // creating new Agent and add agents() to it
    public function split_agents_out(toSquare, key) {
      selectedArr.forEach(function(agent) { agents().splice(agents().indexOf(agent),1) });
      var new_agent = new Agent(this_empire, selectedArr);
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
  	
  	private function removeSelected(current) {
  	  if(!current.obj_is('city')) dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, current, false));
  	  current.removeChild(current.selected);
  	  current.fadeTimer.removeEventListener(TimerEvent.TIMER, fadeInOut);
  	  current.fadeTimer.stop();
  	  current.isSelected = false;
  	}
  	
  	private function addSelected() {
  	  selected = new ImgLoader('ui/selected.png');
  	  fadeTimer = new Timer(1000);
  	  selected.x = -80;
  	  selected.y = -40;
  	  addChild(selected);
  	  setChildIndex(selected, 0);
  	  fadeTimer.addEventListener(TimerEvent.TIMER, fadeInOut);
  	  fadeTimer.start();
  	  isSelected = true;
  	}
  	
  	private function fadeInOut(event:TimerEvent) {
  	  var fade = selected.alpha == 1 ? 0 : 1;
  	  TweenLite.to(selected, .75, { alpha: fade, ease:Sine.easeIn });
  	}
    
    public function agents() { return attr['agents']; }
  	
  	public function units() { return attr['units']; }
  	
    public function addUnits(troops:*) {
      if(!attr['units']) attr['units'] = new Array();
      if(troops is Array) {
        for(var i:int=0; i<troops.length; i++) {
          if(troops[i] is int) {
            var unit = new Unit(troops[i], this);
            attr['units'].push(unit);
          } else {
            attr['units'].push(troops[i]);
          }
        }
      } else {
        attr['units'].push(troops);
      }
      setTimeout(displayTotalMenBar, 1000);
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
      units().forEach(function(unit) {
        totalMen += parseInt(unit.men()); 
      });
      return totalMen;
    }
    
    private function percentOfMen() {
      var percent = 0;
      percent = Math.round((totalMen() / GameConstants.TOTAL_TROOPS) * 100);
      return percent;
    }
    
    public function createJSON() { return null; }
	
/*--------------- Next Turn Functions -------------*/
    public function nextTurn(turn) { moves(5); }
  }
}