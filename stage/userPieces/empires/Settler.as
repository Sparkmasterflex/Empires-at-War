package stage.userPieces.empires {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import settlerBase;
	import stage.userPieces.empires.addSettlerInfo;
	
	public class Settler extends MovieClip {
		public var pieceDetails:Object;
		private var walking:Boolean = false;
		private var thisSelected:Boolean = false;
		public var settler:settlerBase;
		
		public function Settler(empire):void
		{
		  settler = new settlerBase();
		  switch(empire) {
			case '40':
			  settler.settlerIsGaul();
			  break;
		    case '20':
			  settler.settlerIsRome();
			  break;
		  }
		  scaleX = .75;
		  scaleY = .75;
		  addChild(settler);
	      pieceDetails = new Object();
		}
		
		/*public function addSettlerDetails(obj) {
			pieceDetails = new addSettlerInfo(obj);
		}*/
		
		public function walk(walking):void {
          (walking) ? settler.gotoAndStop('wait') : settler.gotoAndPlay('walk');
        }
        
        public function changeFacing(left) {
          settler.scaleX = left ? 1 : -1;  
        }
	}
}