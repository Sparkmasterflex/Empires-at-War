package pieces.agents {
  import dispatch.AddListenerEvent;
  
  import flash.display.MovieClip;
  import flash.events.*;
  
  import pieces.Agent;
  import pieces.GamePiece;
  
  public class Settler extends MovieClip {
    public var parent_obj:GamePiece;
    public var type = 'settler';
    public var parent_type = 'agent';
    public var cost = 750;
    
    public function Settler(p) {
      parent_obj = p;
    }
    
    public function img_path() {
      return 'agents/settler.png'
    }
    
    public function build_points(bp=null) {
      if(!parent_obj.attr['build_points']) parent_obj.attr['build_points'] = 0
      if(bp) parent_obj.attr['build_points'] -= bp;
      return parent_obj.attr['build_points'];
    }
  }
}