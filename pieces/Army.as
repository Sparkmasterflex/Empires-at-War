﻿package pieces {  import armyBase;    import com.greensock.*;  import com.greensock.easing.*;    import common.ImgLoader;  import common.Label;    import dispatch.AddListenerEvent;  import dispatch.PopupEvent;    import empires.Empire;    import flash.display.MovieClip;  import flash.events.*;  import flash.utils.setTimeout;    import pieces.agents.Settler;    import static_return.FindAndTestSquare;  import static_return.GameConstants;  import static_return.GetDirection;  import static_return.UnitsStartNumbers;
    public class Army extends GamePiece {    /*--------Classes Added------------*/    public var army:armyBase;	  public var lbl:Label;    	  	public function Army(emp, troops, num, id=null) {  	  super(emp);  	  this_empire = emp;  	  army = new armyBase();  	  scaleX = .85;  	  scaleY = .85;  	  addChild(army);      this_empire.pieceArray.push(this);      this_empire.armyArray.push(this);      if(id != null) this_id(id);      empire_id(emp.attr['id']);  	  setAttributes(troops, num);  	  addEventListener(MouseEvent.CLICK, animateSelect);    }  	  	private function setAttributes(troops, num) {      attr['pieceType'] = "army";  	  setEmpire();  	  named("army_" + num + "_" + empire()[0]);  	  facing(true);  	  moves(5);  	  addUnits(troops);  	}  	  	public function facing(left=null) {  	  if(left != null) attr['facing'] = left;  	  return attr['facing'];  	}  	  	private function setEmpire() {      empire(this_empire.empire());  	  switch(empire()[0]) {  		case GameConstants.GAUL:  		  army.armyIsGaul();  		  break;  		case GameConstants.ROME:  		  army.armyIsRome();  		  break;  		default:  		  trace('none');  	  }  	}        public override function createJSON() {      var json = {};      json = {        pieceType: 20,        empire_id: empire_id(),        name: named(),        square: square().name,        moves: moves(),        units: ""      }      units().forEach(function(unit) { json['units'] += unit.type() + "," + unit.men() + "||"; });      if(agents()) agents().forEach(function(agent) { json['agents'] += agent.type + "||"; });            return json;    }      	public function animateSelect(event:MouseEvent) {  	  var frame = '';  	  if(isSelected) {    		frame = 'select-ed'    		dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));  	  } else {    		frame = 'unselect-ed';    		dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, false));  	  }  	  army.gotoAndPlay(frame);  	}		  public function pieceMoveKeyBoard(event:*) {      var key = event.keyCode,  		    currSq = square(),          obj = event.eventPhase ? this : event.prevObj,   	  	  toSq = FindAndTestSquare.ret(key, obj),  	  	  stage = this.parent,  		    section = stage.sGridArr[toSq.split('_')[0]];  	  if(directionKeys.indexOf(key) >= 0) {  	    dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, false));  	    var toSquare = section.getChildByName(toSq);          	    if(toSquare.hasLand() && moves() > 0) {  	      if(currSq) changeDirection(currSq, toSquare);          if(!toSquare.pieces() && selectedArr == null) {            // standard move            army.gotoAndPlay('walk');            TweenLite.to(this, .5,              { x:(toSquare.gridInfo.posX), y: (toSquare.gridInfo.posY), onComplete: stopWalk, onCompleteParams: [toSquare]});          } else if(!toSquare.pieces() && (selectedArr && selectedArr.length > 0)) {            if(selectedArr.every(isAgent))              split_agents_out(toSquare, key);            else              split_army(toSquare, key);          } else if(toSquare.pieces() && (selectedArr && selectedArr.length > 0)) {            if(selectedArr.every(isAgent))              send_agents_to(toSquare.pieces());            else              send_troops_to(toSquare.pieces());          } else {            if(empire()[0] == toSquare.pieces().empire()[0]) {              // test if other is enemy or not              combinePieces(toSquare.pieces())            } else {              // is enemy; do something!              army.gotoAndPlay('attack');              var _this = this;              setTimeout(function() {                dispatchEvent(new PopupEvent(PopupEvent.POPUP, 'Battle', null, [_this, toSquare.pieces()], true));              }, 1250)            }          }        } else {	        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));        }      }    }      	public function stopWalk(sq) {  	  army.gotoAndPlay('stand');  	  square(sq);  	  attr['moves']--;  	  dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));  	}        private function isAgent(obj, index, arr) {      return (obj is Settler);    }  	  	private function changeDirection(sq, newSq) {  	  var left = GetDirection.ret(sq, newSq);  	  if(facing() != left) {    		left ? this.scaleX = 0.85 : this.scaleX = -0.85;    		facing(left);  	  }  	}        public function payArmy() {      var total = 0;      units().forEach(function(unit) { total += unit.upkeep() });      return total*-1;    }  }}