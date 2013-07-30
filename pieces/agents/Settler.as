package pieces.agents {
  import dispatch.AddListenerEvent;
  
  import flash.display.MovieClip;
  import flash.events.*;
  
  import pieces.Agent;
  import pieces.GamePiece;
  
  public class Settler extends MovieClip {
    public var parent_obj;
    public var type = 'settler';
    public var parent_type = 'agent';
    public var cost = 750;
    
    public function Settler(p=null) {
      if(p) this_parent(p);
    }
    
    public function img_path() {
      return 'agents/settler.png'
    }

    /* Sets parent Object (Army, City or Agent)
     * 
     * ==== Parameters:
     * p::GamePiece (Army, City or Agent)
     *
     * ==== Returns
     * GamePiece (Army, City or Agent)
     */
    public function this_parent(p=null) {
      if(p) {
        parent_obj = p;
        p.child_length++;
      }
      return parent_obj;
    }
    
    public function build_points(bp=null) {
      if(!parent_obj.attr['build_points']) parent_obj.attr['build_points'] = 0
      if(bp) parent_obj.attr['build_points'] -= bp;
      return parent_obj.attr['build_points'];
    }
  }
}