package dispatch {
  import flash.events.Event;
  import flash.display.*;
  
  public class sendEvent extends Event {
  	public static const VARIABLE:String = "sendVariable";
  	public var neededInstance;
  	public var toFunc;
  	public var variable1;
  	public var variable2;
  	public var variable3;
  	public var variable4;
  	public var variable5;	
    public var something:String = "yes";
    
    public function get sendVariable():String {
      return something;
    }
  	
    public function sendEvent(type:String, to:*, func:Function, v1:*, v2:*=null, v3:*=null, v4:*=null, v5:*=null) {
	  super(type, true);
	  neededInstance = to;
	  toFunc = func;
      variable1 = v1;
      variable2 = v2;
      variable3 = v3;
      variable4 = v4;
      variable5 = v5;
	}
	
	public override function clone():Event {
      return new sendEvent(type, neededInstance, toFunc, variable1, variable2, variable3, variable4, variable5);
    }
  }
}