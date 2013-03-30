﻿package {  import com.greensock.*;  import com.greensock.easing.*;    import common.HandCursor;  import common.Label;    import control_panel.ControlPanel;  import control_panel.ui.Overlay;  import control_panel.ui.Popup;  import control_panel.ui.popups.BattlePopup;  import control_panel.ui.popups.BuildPopup;  import control_panel.ui.popups.RecruitPopup;    import dispatch.AddListenerEvent;  import dispatch.ControlPanelEvent;  import dispatch.MoveWindowEvent;  import dispatch.PopupEvent;  import dispatch.StageBuildEvent;    import empires.Empire;    import flash.display.LoaderInfo;  import flash.display.Sprite;  import flash.display.StageDisplayState;  import flash.events.*;  import flash.external.ExternalInterface;  import flash.geom.Rectangle;  import flash.net.URLRequest;  import flash.text.TextField;  import flash.ui.Mouse;    import game_setup.DarkenEdges;    import stage.GameStage;    import static_return.CalculateStartPositions;  import static_return.GameConstants;  public class empiresAtWar extends Sprite {		/*---- Classes Added ----*/    private var edgeTop:DarkenEdges;    private var edgeLeft:DarkenEdges;  	public  var gStage:GameStage;  	public  var userEmpire:Empire;  	public  var grids:Array;  	private var cursor:HandCursor;  	private var tF:TextField;  	public  var cp:ControlPanel;  	public  var overlay:Overlay;	  	/*---- Numbers ----*/  	public var currentTurn:int;  	  	/*---- Boolean ----*/  	private var isNew:Boolean = true;  	private var dragOn:Boolean = false;  	private var spaceDown:Boolean = false;  	  	/*-- Objects & Arrays --*/  	public var params;  	public var posArr:Array;    public var empireArr:Array;      	/*-- Strings and MovieClips --*/  	private var pop;  	  	/*-- FlashVars --*/  	public var userName:String;  	public var enemies:Array;  	/*-- Will be defined by flashvars later --*/	    	public function empiresAtWar() {  	  addEventListener(MoveWindowEvent.WINDOW, moveWindowHandler);  	  addEventListener(StageBuildEvent.ALL_DONE, stageBuiltHandler);  	  addEventListener(ControlPanelEvent.ANIMATE, controlPanelHandler);      empireArr = new Array();//  	  inFlash();  	  inBrowser();  	  edgeTop = new DarkenEdges((3 * Math.PI)/2);  	  edgeLeft = new DarkenEdges(0);  	  this.parent.stage.addChild(edgeTop);  	  this.parent.stage.addChild(edgeLeft);  	    	  //ExternalInterface.addCallback("goToFullScreen", goFullScreen);  	  //ExternalInterface.call("sendFullScreen");  	  addEventListener(PopupEvent.POPUP, popupHandler);  	}  	  	private function inFlash() {  	  params = new Object();  	  params['username']   = 'Sparkmasterflex';  	  params['empire'].empire	   = GameConstants.GAUL;  	  params['game'].difficulty = GameConstants.EASYGAME;  	  params['game'].status 	   = GameConstants.NEW_GAME;  	  params['game'].turn	   = 1;  	  params['empire'].money	   = 1000;  	  params['stage'].sections   = "0_5_13: terrain>20,0_5_12: terrain>40,0_5_11: terrain>20,0_5_15: terrain>30,0_5_16: terrain>10,0_5_14: terrain>10,0_6_13: terrain>90,0_6_12: terrain>100,0_6_15: terrain>90,0_6_14: terrain>30,0_7_13: terrain>80,0_7_14: terrain>90,0_8_13: terrain>40,0_8_12: terrain>40,0_8_15: terrain>80,0_8_14: terrain>10,0_9_13: terrain>60,0_9_12: terrain>60,0_9_11: terrain>50,0_9_15: terrain>30,0_9_16: terrain>30,0_9_14: terrain>60,0_10_13: terrain>60,0_10_12: terrain>40,0_10_11: terrain>100,0_10_10: terrain>100,0_10_15: terrain>40,0_10_16: terrain>20,0_10_17: terrain>60,0_10_14: terrain>50,0_4_13: terrain>40,0_4_12: terrain>20,0_4_11: terrain>60,0_4_10: terrain>100,0_4_9: terrain>40,0_4_15: terrain>10,0_4_16: terrain>50,0_4_17: terrain>70,0_4_18: terrain>70,0_4_14: terrain>80,0_3_13: terrain>80,0_3_12: terrain>40,0_3_11: terrain>60,0_3_10: terrain>60,0_3_9: terrain>20,0_3_8: terrain>90,0_3_15: terrain>40,0_3_16: terrain>60,0_3_17: terrain>60,0_3_18: terrain>60,0_3_19: terrain>20,0_3_14: terrain>60,0_2_13: terrain>20,0_2_12: terrain>20,0_2_11: terrain>20,0_2_10: terrain>20,0_2_9: terrain>50,0_2_15: terrain>10,0_2_16: terrain>90,0_2_17: terrain>70,0_2_18: terrain>30,0_2_19: terrain>80,0_2_20: terrain>40,0_2_14: terrain>90,0_1_13: terrain>90,0_1_12: terrain>80,0_1_11: terrain>60,0_1_10: terrain>90,0_1_15: terrain>90,0_1_16: terrain>60,0_1_17: terrain>70,0_1_18: terrain>10,0_1_19: terrain>80,0_1_14: terrain>50,";   	  buildMap(params);  	}    	private function inBrowser() {  	  params = getFlashVars();      buildMap(JSON.parse(params.json));  	}  	  	private function getFlashVars() {      return Object( LoaderInfo( this.loaderInfo ).parameters )  	}  	  	private function goFullScreen() {  	  this.parent.stage.displayState = StageDisplayState.FULL_SCREEN;  	}  	    public function buildMap(params) {  	  var empire = GameConstants.parseEmpireName(params['empire'].empire);  	  gStage = new GameStage(params, this);  	  addChild(gStage);  	    	  eventLiseners();  	  userEmpire = new Empire(params, gStage, this);      empireArr.push(userEmpire);  	  addChild(userEmpire);      addControlPanel(params);	        // adding first enemy empire//      params['empire'].empire = GameConstants.ROME;//      var enemyEmpire = new Empire(params, gStage, this);//      empireArr.push(enemyEmpire);//      addChild(userEmpire);  	}  	  	public function addControlPanel(params) {  	  currentTurn = params['game'].turn;  	  cp = new ControlPanel(userEmpire, currentTurn, this);  	  addChild(cp);  	}  	  	  	private function eventLiseners() {  	  this.parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListenerDown);  	  addEventListener(AddListenerEvent.EVENT, addListenerHandler);  	  //addEventListener(displayEvent.DISPLAY, toCPanel);  	}    	  /*--------------------------------------- Move Game Stage ------*/		  	private function keyListenerDown(event:KeyboardEvent) {	    	  if(event.keyCode == 32) {  	    gStage.mouseChildren = false;  	    Mouse.hide();    		if(!spaceDown) {    		  cursor = new HandCursor();    		  addChild(cursor);    		  spaceDown = true;    		  this.parent.stage.addEventListener(Event.ENTER_FRAME, cursorMove);    		}    		this.parent.stage.addEventListener(KeyboardEvent.KEY_UP, keyListenerUp);    		this.addEventListener(MouseEvent.MOUSE_DOWN, startStageDrag);  	  }  	  if(event.keyCode == 16) {    		cp.selectedUnits.selectMultiple = true;    		this.parent.stage.addEventListener(KeyboardEvent.KEY_UP, keyListenerUp);  	  }  	}  	  	private function keyListenerUp(event:KeyboardEvent) {  	  if(event.keyCode == 32) {    		gStage.mouseChildren = true;    		this.stopDrag();    		this.parent.stage.removeEventListener(Event.ENTER_FRAME, cursorMove);    		Mouse.show();    		removeChild(cursor);    		spaceDown = false;    		this.parent.stage.removeEventListener(KeyboardEvent.KEY_UP, keyListenerUp);    		removeEventListener(MouseEvent.MOUSE_DOWN, startStageDrag);  	  }    	  if(event.keyCode == 16) {    		cp.selectedUnits.selectMultiple = false;    		this.parent.stage.removeEventListener(KeyboardEvent.KEY_UP, keyListenerUp);  	  }  	}  	  	private function startStageDrag(event:MouseEvent) {  	  if(!dragOn) {  		cursor.closeCursor(true);  		dragOn = true;  	  }  	  var bounds:Rectangle = new Rectangle(  		  this.parent.stage.stageWidth - gStage.width,  		  this.parent.stage.stageHeight - gStage.height,  		  gStage.width - this.parent.stage.stageWidth,  		  gStage.height - this.parent.stage.stageHeight  		);  	  gStage.startDrag(false, bounds);  	  addEventListener(MouseEvent.MOUSE_UP, stopStageDrag);  	}  	  	private function stopStageDrag(event:MouseEvent) {  	  cursor.closeCursor(false);  	  dragOn = false;  	  gStage.stopDrag();  	}  	  	private function cursorMove(event:Event) {  	  cursor.mouseEnabled = false;  	  cursor.x = mouseX;  	  cursor.y = mouseY;  	}  	  	public function stageBuiltHandler(event:StageBuildEvent) {  	  //addUserControlled(GameConstants.parseEmpireName(params['empire']), params['difficulty']);  	}  	  	private function moveWindowHandler(event:MoveWindowEvent) {  	  gStage.x -= event.posX - GameConstants.WIDTH_CENTER;  	  gStage.y -= event.posY - GameConstants.HEIGHT_CENTER;  	  removeEventListener(MoveWindowEvent.WINDOW, moveWindowHandler);  	}  	  	private function controlPanelHandler(event:ControlPanelEvent) {  	  cp.expand(event.isSelected, event.attr)  	}  	  	private function addListenerHandler(event:AddListenerEvent) {  	  var mc = event.movieClip,  		    listen = event.listen;  	  (listen) ?    		this.parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, mc.pieceMoveKeyBoard) :    		  this.parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN, mc.pieceMoveKeyBoard);  	}  	  	/*--------------------------------------- Popup Functions -------*/  	private function showPopup(popup) {  	  var centerW = GameConstants.WIDTH_CENTER - popup.this_width/2;  	  overlay = new Overlay(GameConstants.STAGE_WIDTH, GameConstants.STAGE_HEIGHT, popup);  	  overlay.alpha = 0;  	  addChild(overlay);  	  setChildIndex(overlay, this.numChildren - 2);  	  popup.x = centerW;  	  popup.y = 100;  	  popup.alpha = 0;  	  addChild(popup);  	  TweenLite.to(overlay, .25, { alpha:.4 });   	  TweenLite.to(popup, .25, { y:25, alpha:1 });   	}  	  	private function tweenOutPopup(popup) {  	  TweenLite.to(popup, .25, {x: (GameConstants.WIDTH_CENTER - (popup.width*1.35)/2), y: -50, scaleX:1.35, scaleY:1.35, alpha:0});  	  TweenLite.to(overlay, .25, {alpha:0, onComplete: removePopup, onCompleteParams: [popup]});  	}  	  	private function removePopup(p) {  	  removeChild(p);  	  removeChild(overlay);  	  pop = null;  	}  	  	/*--------------------------------------- FormControlPanel ------*/  	private function popupHandler(event:PopupEvent) {  	  var popup = event.popup,  	      params = event.parameters,    		  show = event.showPopup,    		  object = event.object,          type = event.popup;  	    	  if(show) {    		if(pop) removePopup(pop);    		switch(popup) {          case 'City':            pop = new BuildPopup(params, object);            break;          case 'Army':            pop = new RecruitPopup(params, object);            break;          case 'Battle':            // when battle, object is array of attacker and defender            pop = new BattlePopup(type, object[0], object[1])            break;          default:            null;        }    		showPopup(pop);  	  } else {  		  tweenOutPopup(event.popup);  	  }  	}  }}