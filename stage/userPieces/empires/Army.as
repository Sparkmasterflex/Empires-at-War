package stage.userPieces.empires {
	import com.greensock.*
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.DropShadowFilterPlugin;
	TweenPlugin.activate([DropShadowFilterPlugin]);
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import dispatch.displayEvent;
	import common.percentBar;
	import armyBase;
	
	public class Army extends MovieClip {
	  /*---- Classes ----*/
	  public var army:armyBase;
	  public var bar:percentBar;
	  
	  /*---- Boolean ----*/
	  private var walking:Boolean = false;
	  private var thisSelected:Boolean = false;
	  
	  /*---- Numbers ----*/  
	
	  /*---- Arrays and Objects ----*/
	  public var pieceDetails:Object;
      public var unitInfo:Object;

      /*---- MovieClips and Strings ----*/
      public var currEmpire;      		

	  public function Army(empire):void {
	    currEmpire = empire;
	    army = new armyBase();
  	    switch(currEmpire) {
	  	  case '40':
			army.armyIsGaul();
			break;
		  case '20':
			army.armyIsRome();
		  	break;
		}
		scaleX = .85;
		scaleY = .85;
		addChild(army);
		pieceDetails = new Object();
	  }
		
		public function walk(walking):void {
  		  (walking) ? army.gotoAndStop('stand') : army.gotoAndPlay('walk');
		}
		
		public function attack(event:MouseEvent):void {
		  army.gotoAndPlay('attack');
		}
		
		public function displayTotalMenBar(m, percent) {
		  bar = new percentBar(currEmpire, percent);
		  bar.x = 25;
		  addChild(bar);
		  this.setChildIndex(bar, 0);
		  TweenLite.to(bar, .1, {dropShadowFilter:{blurX:1, blurY:1, distance:1, alpha:0.6}});
		}
		
		public function changeFacing(left) {
		  army.scaleX = left ? 1 : -1;	
		}
	}
}