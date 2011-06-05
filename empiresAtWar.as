package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.geom.Rectangle;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import gameSetup.Constants;
	import stage.gameStage;
    import gameSetup.darkenEdges;
    
    import common.handCursor;	
	import control_Panel.controlPanel;
	import control_Panel.popups.OverLay;
    
    import dispatch.removeEvent;
	import dispatch.pathEvent;
	import dispatch.walkEvent;
	import dispatch.displayEvent;
	import dispatch.positionEvent;
	import dispatch.moveWindowEvent;
	import dispatch.addListenerEvent;
	import dispatch.popupEvent;
	
	import staticReturn.determinePopup;
	
	public class empiresAtWar extends MovieClip
	{	
		/*-- Empires --*/
		public static const EGYPT:int 			= 10;
		public static const ROME:int 			= 20;
		public static const GREECE:int 			= 30;
		public static const GAUL:int 			= 40;
		public static const CARTHAGE:int 		= 50;
		public static const JAPAN:int 			= 60;
		public static const MONGOLS:int 		= 70;
		public static const UNDEAD:int 			= 80;
		public static const STAGE_WIDTH:Number  = 1200;
        public static const STAGE_HEIGHT:Number = 800;
		public static const WIDTH_CENTER:Number  = 600;
		public static const HEIGHT_CENTER:Number = 400;
		
		/*-- Game Difficulty --*/
		public static const EASYGAME:int		= 10;
		public static const MEDGAME:int			= 20;
		public static const HARDGAME:int		= 30;
	
		public const SEL_EMPIRE:int = Constants.GAUL;
		private var isNew:Boolean = true;
		private var userName:String = "sparkMasterFlex";
		public var enemies:Array = new Array('Egypt', 'Rome', 'Greece', 'Carthage', 'Japan', 'Mongols', 'Undead');
		/*-- Will be defined by flashvars later --*/
		
		/*-- Classes Added --*/
		public var gStage:gameStage;
		public var cPanel:controlPanel;
		private var edgeTop:darkenEdges;
		private var edgeLeft:darkenEdges;
		private var cursor:handCursor;
		private var overlay:OverLay;
		
		/*-- Numbers --*/
		/*-- Arrays and Objects --*/
		/*-- Booleans --*/
		private var dragOn:Boolean = false;
		private var spaceDown:Boolean = false;
		
		/*-- Strings and MovieClips --*/
		private var pop;
		
		public function empiresAtWar(/*isNew, userName, empire, difficulty, enemies:Array*/) {
		  addEventListener(moveWindowEvent.WINDOW, moveWindowHandler);
		  (isNew) ? createGame(userName, SEL_EMPIRE, EASYGAME, enemies) : continueGame(userName);
			
		  edgeTop = new darkenEdges((3 * Math.PI)/2);
		  edgeLeft = new darkenEdges(0);
		  stage.addChild(edgeTop);
		  stage.addChild(edgeLeft);
		  addEventListener(removeEvent.REMOVE, removeHandler);
		  addEventListener(addListenerEvent.EVENT, addListenerHandler);
		  addEventListener(popupEvent.POPUP, popupHandler);
		}
		
		private function createGame(name, empire, difficulty, enemies:Array) {
		  gStage = new gameStage(empire, difficulty, enemies);
		  addChild(gStage);
		  cPanel = new controlPanel(empire, 0, 2000);
		  cPanel.x = (stage.stageWidth / 2) - 475;
		  cPanel.y = stage.stageHeight - 200;
		  addChild(cPanel);
		  eventLiseners();
		}
		
		private function continueGame(name):void
		{
		  trace(name);
		  eventLiseners();
		}
		
		private function eventLiseners() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListenerDown);
			addEventListener(displayEvent.DISPLAY, toCPanel);
		}
			
/*--------------------------------------- Move Game Stage ------*/		
		private function keyListenerDown(event:KeyboardEvent) {	  
		  if(event.keyCode == 32) {
		    gStage.mouseChildren = false;
			Mouse.hide();
			if(!spaceDown) {
			  cursor = new handCursor();
			  addChild(cursor);
			  spaceDown = true;
			  stage.addEventListener(Event.ENTER_FRAME, cursorMove);
			}
			stage.addEventListener(KeyboardEvent.KEY_UP, keyListenerUp);
			this.addEventListener(MouseEvent.MOUSE_DOWN, startStageDrag);
		  }
		  
		  if(event.keyCode == 16) {
		    cPanel.display.selectMultiple = true;
		    stage.addEventListener(KeyboardEvent.KEY_UP, keyListenerUp);
		  }
		}
		
		private function keyListenerUp(event:KeyboardEvent) {
		  if(event.keyCode == 32) {
			gStage.mouseChildren = true;
			this.stopDrag();
  		    stage.removeEventListener(Event.ENTER_FRAME, cursorMove);
			Mouse.show();
			removeChild(cursor);
			spaceDown = false;
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyListenerUp);
			removeEventListener(MouseEvent.MOUSE_DOWN, startStageDrag);
 		  }
 		  
 		  if(event.keyCode == 16) {
            cPanel.display.selectMultiple = false;
            stage.removeEventListener(KeyboardEvent.KEY_UP, keyListenerUp);
          }
		}
		
		private function startStageDrag(event:MouseEvent) {
		  if(!dragOn) {
			cursor.closeCursor(true);
			dragOn = true;
		  }
		  var bounds:Rectangle = new Rectangle(
			  stage.stageWidth - gStage.width,
			  stage.stageHeight - gStage.height,
			  gStage.width - stage.stageWidth,
			  gStage.height - stage.stageHeight
			);
		  gStage.startDrag(false, bounds);
		  addEventListener(MouseEvent.MOUSE_UP, stopStageDrag);
		}
		
		private function stopStageDrag(event:MouseEvent) {
		  cursor.closeCursor(false);
		  dragOn = false;
		  gStage.stopDrag();
		}
		
		private function cursorMove(event:Event) {
	      cursor.mouseEnabled = false;
		  cursor.x = mouseX;
		  cursor.y = mouseY;
		}
		
		private function showPopup(popup) {
		  var centerW = WIDTH_CENTER - 200;
		  overlay = new OverLay(STAGE_WIDTH, STAGE_HEIGHT, popup);
		  overlay.alpha = 0;
		  addChild(overlay);
		  setChildIndex(overlay, this.numChildren - 2)
		  popup.x = centerW;
		  popup.y = 100;
		  popup.alpha = 0;
		  addChild(popup);
          TweenLite.to(overlay, .25, { alpha:.4 }); 
		  TweenLite.to(popup, .25, { y:25, alpha:1 }); 
		}
		
		private function tweenOutPopup(popup) {
		  TweenLite.to(popup, .25, {x: 300, y: -50, scaleX:1.35, scaleY:1.35, alpha:0});
          TweenLite.to(overlay, .25, {alpha:0, onComplete: removePopup, onCompleteParams: [popup]});
		}
		
		private function removePopup(p) {
          removeChild(p);
          removeChild(overlay);
          pop = null;
        }
		
/*--------------------------------------- ToControlPanel ------*/		
		private function toCPanel(event:displayEvent) {
			var userSelected:Object = event.displayObj;
			var isSel = event.isSelected;
			if(isSel){
  			  cPanel.displaySelectedInfo(userSelected);
			} else {
			  cPanel.unSelect();
			}
		}
		
/*--------------------------------------- FormControlPanel ------*/
	    private function popupHandler(event:popupEvent) {
	      var params = event.parameters,
	          show = event.showPopup,
	          empire = event.empire;	         
	      if(show) {
	       	if(pop) removePopup(pop);
	        pop = determinePopup.ret(event.popup, params, empire);         
	        showPopup(pop);
	      } else {
	      	tweenOutPopup(event.popup);
	      }
	    }
	    
/*--------------------------------------- DispatchedEvents ------*/       
		private function removeHandler(event:removeEvent) {
			var mc = event.movieClip;
			var toClass = event.neededClass;
			
			toClass.removeChild(mc);
		}
		
		private function addListenerHandler(event:addListenerEvent) {
		  var mc = event.movieClip,
			  listen = event.listen;
			//gStage.beginLayingPath(mc, listen);
		  (listen) ?
            stage.addEventListener(KeyboardEvent.KEY_DOWN, mc.pieceMoveKeyBoard) :
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, mc.pieceMoveKeyBoard);
        }
        
        private function moveWindowHandler(event:moveWindowEvent) {
          gStage.x -= event.posX - WIDTH_CENTER;
          gStage.y -= event.posY - HEIGHT_CENTER;
          removeEventListener(moveWindowEvent.WINDOW, moveWindowHandler);
        }
	}
}