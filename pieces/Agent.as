package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;
  import com.demonsters.debugger.MonsterDebugger;
  
  import settlerBase;
  
  import dispatch.AddListenerEvent;
  
  import empires.Empire;
  
  import flash.display.MovieClip;
  import flash.events.*;
  import flash.utils.*;
  import flash.external.ExternalInterface;
  
  import pieces.agents.Settler;
  
  import static_return.FindAndTestSquare;
  import static_return.GameConstants;
  import static_return.GetDirection;
  
  public class Agent extends GamePiece {
    /*--------Classes Added------------*/

    
    public function Agent(emp, num, attributes) {
      super(emp);
      this_empire = emp;
      this_empire.pieceArray.push(this);
      this_empire.agentArray.push(this);
      if(attributes.id != null) this_id(attributes.id);
      empire_id(emp.attr['id']);
      setAttributes(num, attributes);
      createAgentType();
      addEventListener(MouseEvent.CLICK, animateSelect);
    }

    private function setAttributes(num, a=null) {
      attr['pieceType'] = "agent";
      empire(this_empire.empire());
      named("agent_" + num + "_" + empire()[0]);
      scaleX = .75;
      scaleY = .75;

      if(!a.instant_save && !a.id) {
        agents(a.agents);
      } else {
        var agent_arr = a.id ? parseAgentsString(a.agents) : a.agents;
        agents(build_agents(agent_arr));
      }
      if(a.square) square(a.square);
      facing(true);
      moves(4);
      // on game load/reload if not in DB
      if(a.instant_save) interval = setInterval(test_for_save, 100, agent_arr.length);
    }
    
    private function createAgentType() {
      // will have to add other options as they get built
      // ie Diplomat and Spies
      if(!agents() || agents().indexOf(Settler)) game_piece = new settlerBase();
      setEmpire();
      addChild(game_piece);
    }

    private function setEmpire() {
      switch(empire()[0]) {
        case GameConstants.GAUL:
          game_piece.settlerIsGaul();
          break;
        case GameConstants.ROME:
          game_piece.settlerIsRome();
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
    
    public function animateSelect(event:MouseEvent) {
      var frame = '';
      if(isSelected) {
        frame = 'select-ed'
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, true));
      } else {
        frame = 'unselect-ed';
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, false));
      }
      game_piece.gotoAndPlay(frame);
    }
    
    public override function stopWalk(sq) {
      game_piece.gotoAndPlay('stand');
      attr['changed'] = true;
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