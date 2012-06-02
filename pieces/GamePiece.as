package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;
  
  import common.ImgLoader;
  
  import dispatch.AddListenerEvent;
  import dispatch.ControlPanelEvent;
  
  import empires.Empire;
  
  import flash.display.MovieClip;
  import flash.events.*;
  import flash.utils.Timer;
  
  import static_return.GameConstants;
  

  public class GamePiece extends MovieClip {
	/*--------Classes Added------------*/
	public var selected:ImgLoader;
	private var fadeTimer:Timer;
	public var selection = null;
	public var this_empire:Empire;
	
	/*--------Boolean-------*/
	public var isSelected:Boolean = false;
	
	/*--------Arrays and Objects-------*/
	public var attr:Object;
	public var directionKeys:Array = new Array(104, 105, 102, 99, 98, 97, 100, 103,
		38, 33, 39, 34, 40, 35, 37, 36);
	  
    public function GamePiece(empire) {
      super();
	  this_empire = empire;
	  addEventListener(MouseEvent.CLICK, selectThis);
    }
	
	public function obj_is(obj) {
	  if(obj) {
		return (obj == attr['pieceType'])
	  } else {
		return attr['pieceType'];
	  }
	}
	
	public function named(named=null) {
	  if(named) attr['name'] = named;
	  return attr['name'];
	}
	
	public function empire(e=null):Array {
	  if(e) attr['empire'] = [e, GameConstants.parseEmpireName(e)];
	  return attr['empire'];
	}

	public function empire_is(e=null):Boolean {
	  if(e) {
		return attr['empire'][0] == e;
	  } else {
	  	return attr['empire'];
	  }
	}
	
	public function square(sq=null):Object {
	  if(sq) {
		attr['square'] = sq;
		sq.addToSquare(this);
	  }
	  return attr['square'];
	}
	
	public function moves(num=null) {
	  if(!obj_is('city')) {
	    if(num) attr['moves'] = num;
	    return attr['moves'];
	  }
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
	  dispatchEvent(new ControlPanelEvent(ControlPanelEvent.ANIMATE, this.isSelected, attr));
	}
	
	// adding piece1 with piece2 (GamePiece or Array)
	public function combinePieces(piece2) {
	  if(obj_is('army')) {
		if(piece2.obj_is('army')) {
		  piece2.addUnits(units());
		} else if(piece2.obj_is('city')) {
		  if(piece2.army()) {
			var city_units = piece2.army()['units'];
			addUnits(city_units);
			piece2.army(attr);
		  } else {
		    piece2.army(attr);
		  }
		}
	  } else if('support') {
		trace('support');
	  }
	  piece2.selectThis(null);
	  this_empire.gStage.removeChild(this);
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
	
	/*-- over-written by Army.as --*/
	public function units() { return null; }
	
	public function addUnits(units) { return units; }
	
/*--------------- Next Turn Functions -------------*/
    public function nextTurn(turn) {
	  moves(5);
	}
  }
}