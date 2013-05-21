package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;
  
  import settlerBase;
  
  import dispatch.AddListenerEvent;
  
  import empires.Empire;
  
  import flash.display.MovieClip;
  import flash.events.*;
  
  import pieces.agents.Settler;
  
  import static_return.FindAndTestSquare;
  import static_return.GameConstants;
  import static_return.GetDirection;
  
  public class Agent extends GamePiece {
    public var piece;
    
    public function Agent(emp, num, id=null) {
      super(emp);
      attr = new Object();
      this_empire = emp;
      attr = new Object()
      this_empire.pieceArray.push(this);
      this_empire.agentArray.push(this);
      if(id != null) this_id(id);
      empire_id(this_empire.attr['id']);
      setAttributes(num);
      createAgentType();
      facing(true);
      addEventListener(MouseEvent.CLICK, animateSelect);
    }

    private function setAttributes(num) {
      attr['pieceType'] = "agent";
      moves(4);
      empire(this_empire.empire());
      named("agent_" + num + "_" + empire()[0]);
      scaleX = .75;
      scaleY = .75;
    }
    
    private function createAgentType() {
      // will have to add other options as they get built
      // ie Diplomat and Spies
      if(!agents() || agents().indexOf(Settler)) piece = new settlerBase();
      setEmpire();
      addChild(piece);
    }

    private function setEmpire() {
      switch(empire()[0]) {
        case GameConstants.GAUL:
          piece.settlerIsGaul();
          break;
        case GameConstants.ROME:
          piece.settlerIsRome();
          break;
        default:
          trace('none');
      }
    }
    
    public override function createJSON() {
      var json = {};
      json = {
        id: this_id(),
        pieceType: 10,
        empire_id: empire_id(),
        built_id: empire_id(),
        name: named(),
        square: square().name,
        agents: ""
      }
      if(agents()) agents().forEach(function(agent) { json['agents'] +=  agent.type + "||"; });
      
      return json;
    }
    
    public function agent_is(type=null, set=false) {
      if(set) attr['agentType'] = type;
      if(type && !set) {
        return type == attr['agentType'];
      } else {
        return attr['agentType'];
      }
    }
    
    public function facing(left=null) {
      if(left) attr['facing'] = left;
      return attr['facing'];
    }
    
    public function animateSelect(event:MouseEvent) {
      var frame = '';
      if(isSelected) {
        frame = 'select-ed'
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));
      } else {
        frame = 'unselect-ed';
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, false));
      }
      piece.gotoAndPlay(frame);
    }

    public function pieceMoveKeyBoard(event:*) {
      var key = event.keyCode,
          currSq = square(),
          obj = event.eventPhase ? this : event.prevObj, 
          toSq = FindAndTestSquare.ret(key, obj),
          stage = this.parent,
          section = stage.sGridArr[toSq.split('_')[0]];
      if(directionKeys.indexOf(key) >= 0) {
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, false));
        var toSquare = section.getChildByName(toSq);
        
        if(toSquare.hasLand() && moves() > 0) {
          if(currSq) changeDirection(currSq, toSquare);
          if(!toSquare.pieces() && selectedArr == null) {
            // standard move
            piece.gotoAndPlay('walk');
            TweenLite.to(this, .5,
              { x:(toSquare.gridInfo.posX), y: (toSquare.gridInfo.posY), onComplete: stopWalk, onCompleteParams: [toSquare]});
          } else {
            if(toSquare.pieces().empire()[0] == empire()[0]) {
              combinePieces(toSquare.pieces())
            }
          }
        } else {
          dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));
        }
      }
    }
    
    public function stopWalk(sq) {
      piece.gotoAndPlay('stand');
      square(sq);
      attr['moves']--;
      dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));
    }
    
    private function changeDirection(sq, newSq) {
      var left = GetDirection.ret(sq, newSq);
      if(facing() != left) {
        left ? this.scaleX = 0.75 : this.scaleX = -0.75;
        facing(left);
      }
    }
  }
}