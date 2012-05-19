package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;
  
  import common.ImgLoader;
  
  import dispatch.ControlPanelEvent;
  import dispatch.AddListenerEvent;
  
  import flash.display.MovieClip;
  import flash.events.*;
  import flash.utils.Timer;
  

  public class GamePiece extends MovieClip {
	/*--------Classes Added------------*/
	public var selected:ImgLoader;
	private var fadeTimer:Timer;
	public var selection = null;
	
	/*--------Boolean-------*/
	public var isSelected:Boolean = false;
	
	/*--------Arrays and Objects-------*/
	public var attr:Object;
	public var directionKeys:Array = new Array(104, 105, 102, 99, 98, 97, 100, 103,
		38, 33, 39, 34, 40, 35, 37, 36);
	  
    public function GamePiece() {
      super();
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
	
	public function empire(e=null):String {
	  if(e) attr['empire'] = e;
	  return attr['empire'];
	}
	
	public function square(sq=null):Object {
	  if(sq) {
		attr['square'] = sq;
		sq.addToSquare(this);
	  }
	  return attr['square'];
	}
	
	public function selectThis(event:MouseEvent) {
	  var stage = this.parent,
		  allPieces = stage.pieceArray,
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
	
//	public function checkForMultipleUnits(sq):Array {
//	  //TODO check to see if combined armies units > 18
//	  //       if so do not remove prev Army and leave overflow 
//	  var pieces = sq.gridInfo.pieces,
//		  order:Array = new Array(),
//		  armyOrder = new Array(), settlerOrder = new Array(), otherOrder = new Array();
//		
//		if(pieces.length > 1) {
//		  //for (var m:int = 0; m < pieces.length; m++) trace(grabPiece.ret(pieces[m]).pieceDetails.type);
//		  for(var i:uint = 0; i < pieces.length; i++) {
//			switch(obj_is()) {
//			  case 'city':	  var city = pieces[i];  			break;
//			  case 'army':    armyOrder.push(pieces[i].attrs);  break;
//			  case 'settler': settlerOrder.push(pieces[i]); 	break;
//			  default:        otherOrder.push(pieces[i]);   	break;
//		  }
//		}
//			
//		if(city) { 
//		  pieceStationedInCity(city, pieceSelected);
//		} else if(armyOrder.length > 1) { 
//		  for(var a:uint = 0; a < armyOrder.length; a++) pieceToNewSquare(armyOrder[a], null, sq);
//		  var armyArr = combineArmies(armyOrder);
//		  addUserArmy(1, armyArr[0], armyArr[1], sq);
//		  changeSelected(pieceSelected, userPiece);
//		}
//			
//		if(settlerOrder.length > 1) {
//		  for(var s:uint = 1; s < settlerOrder.length; s++) {
//			pieceToNewSquare(settlerOrder[s], null, sq);
//			grabPiece.ret(settlerOrder[0]).pieceDetails.supportPieces.push('settler');
//			removeChild(settlerOrder[s]);
//			changeSelected(pieceSelected, settlerOrder[0]);
//		  }
//		}
//			
//		/*for(var a:uint = 0; a < armyOrder.length; a++) order.push(armyOrder[a]);
//		for(var s:uint = 0; s < settlerOrder.length; s++) order.push(settlerOrder[s]);
//		for(var o:uint = 0; o < otherOrder.length; o++) order.push(otherOrder[o]);*/
//	  }
//		
//	  return order;
//	}
  }
}