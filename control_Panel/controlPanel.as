package control_Panel {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import staticReturn.grabPiece;
	import staticReturn.ReturnEmpire;
	import common.textFields;
	import common.imgLoader;
	import common.gradient;
	import control_Panel.buttons.nextPrevBtn;
	import control_Panel.buttons.squareBtn;
	import control_Panel.displayInComponent;
	
	import com.greensock.*;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.DropShadowFilterPlugin;
	TweenPlugin.activate([DropShadowFilterPlugin]);
	
	public class controlPanel extends MovieClip
	{
		/*-- Classes Added --*/
		private var cPanelBG:Loader;
		private var empireSym:imgLoader;
		private var cPMask:gradient;
		private var cPBG:URLRequest = new URLRequest('images/controlPanel/cPanelBG.png');
		public var display:displayInComponent;
		private var unitBaseLoader:URLLoader = new URLLoader();
		private var unitSpecificLoader:URLLoader = new URLLoader();
		public var baseUnits:XML;
		public var specificUnits:XML;
		private var leaderTF:textFields;
		private var prevTri:nextPrevBtn;
		private var nextTri:nextPrevBtn;
		private var endTurnBtn:squareBtn;
		private var empInfoBtn:squareBtn;
		private var CityBtn:squareBtn;
		private var MilitaryBtn:squareBtn;
		private var CivilianBtn:squareBtn;
		public var turnTxt:textFields;
		public var moneyTxt:textFields;
				
		/*-- Arrays --*/
		public var unitArr:Array;
		
		/*-- Numbers --*/
		public var money:Number;
		public var turn:uint;
		private var tabNum:uint;
		
		/*-- MovieClips and Strings --*/
		public var leaderName;
		public var empire;		
		private var currentTab = null;
		
		/*-- Booleans --*/
		private var over:Boolean = false;
		private var clicked:Boolean = false;
		private var showingThumbs:Boolean = false;
		
		/*-- Sounds --*/
		public var btnClickSound:Sound = new Sound(new URLRequest("sounds/button_click.mp3"));
		private var clickChannel:SoundChannel = new SoundChannel();
		private var soundVol:SoundTransform = new SoundTransform();
				
		public function controlPanel(e:String, t:uint, m:Number):void {
			empire = ReturnEmpire.ret(e);
			turn = t;
			money = m;
			unitBaseLoader.load(new URLRequest("xml/units_base.xml"));
			unitBaseLoader.addEventListener(Event.COMPLETE, processUnits);
			unitSpecificLoader.load(new URLRequest("xml/units_" + empire + ".xml"));  
			unitSpecificLoader.addEventListener(Event.COMPLETE, processSpecificUnits);
			addCPanelBG();
			soundVol.volume = .25;
		}
		
		private function processUnits(event:Event):void {
		  baseUnits = new XML(event.target.data);
		}
		
		private function processSpecificUnits(event:Event):void {
		  specificUnits = new XML(event.target.data);
	      mergeXML();
		}
		
		private function mergeXML() {
  		  baseUnits.appendChild(specificUnits.*);
		}
		
		private function addCPanelBG() {
			cPanelBG = new Loader();
			cPanelBG.load(cPBG);
			addChild(cPanelBG);
			addEmpireSymbol();
			
			cPanelBG.contentLoaderInfo.addEventListener(Event.COMPLETE, buildControlPanel);
		}
		
		private function addEmpireSymbol() {
          empireSym = new imgLoader('empireSymbols/' + empire + '.png');
          empireSym.x = -35;
          empireSym.y = -15;
          empireSym.alpha = .5;
          addChild(empireSym);          
        }
		
		private function buildControlPanel(event:Event):void
		{
		  addTabBtns('City');
		  addTabBtns('Military');
		  addTabBtns('Civilian');
		  createDisplayBox();
		  empireName(empire);
		  addTextArea(turn, money);
		  addNextPrevBtns();
		  addEndTurnBtn();
		  addEmpireInfoBtn();
		  createAndAddMask();
		}
		
		private function createAndAddMask() {
		  cPMask = new gradient(['none', 'none'], 'solid', [0x009900], [1], [0], 950, 193, 0, [950,193], 'rectangle');
		  addChild(cPMask);
		  empireSym.mask = cPMask;
		}
		
		private function addTabBtns(btnText) {
		  var btnName = btnText + 'btn',
		      btn = new squareBtn(btnText, 16, 80, 35);
		  btn.x = ((btn.width + 15) * tabNum) + 280;
		  btn.y = 132;
		  btn.name = btnName;
		  btn.disableBtn();
		  addChild(btn);
		  tabNum++;
		  btnListenAndShadow(btn);
		}
		
		private function createDisplayBox() {
		  display = new displayInComponent();
		  display.x = 265;
		  display.y = 15;
		  addChild(display);
		  TweenLite.to(display, .1, {dropShadowFilter:{blurX:2, blurY:2, distance:2, alpha:0.6, inner:true}});
		}
		
		private function empireName(e:String) {
		  leaderTF = new textFields(14, 0x222222, 'Arial', 'CENTER');
		  leaderTF.x = (50 - (leaderTF.width / 2)) + 40;
		  leaderTF.y = 20;
		  leaderTF.text = empire;
		  addChild(leaderTF);
		}
		
		public function addTextArea(t:uint, m:Number) {
		  turnTxt = new textFields(14, 0x222222, 'Arial', 'LEFT');
		  moneyTxt = new textFields(14, 0x222222, 'Arial', 'LEFT');
		  turnTxt.text = "Turn:   " + t.toString();
		  moneyTxt.text = "Money:    " + m.toString();
		  turnTxt.x = 20 + (turnTxt.width / 2);
		  turnTxt.y = 50;
		  moneyTxt.x = 20 + (turnTxt.width / 2);
		  moneyTxt.y = 70;
		  addChild(turnTxt);
		  addChild(moneyTxt);
		}
		
		private function addNextPrevBtns() {
		  prevTri = new nextPrevBtn(180);
		  nextTri = new nextPrevBtn(0);
		  prevTri.x = 40;
		  prevTri.y = 40;
		  nextTri.x = 140;
		  nextTri.y = 20;
		  addChild(prevTri);
		  addChild(nextTri);
		  btnListenAndShadow(prevTri);
		  btnListenAndShadow(nextTri);
		}
		
		private function addEndTurnBtn() {
		  endTurnBtn = new squareBtn('End Turn', 21, 120, 35);
		  endTurnBtn.x = 30;
		  endTurnBtn.y = 140;
		  addChild(endTurnBtn);
		  btnListenAndShadow(endTurnBtn);
		}
		
		private function addEmpireInfoBtn() {
		  empInfoBtn = new squareBtn('Empire\n   Info', 12, 75, 30);
		  empInfoBtn.x = 180;
		  empInfoBtn.y = 15;
		  addChild(empInfoBtn);
		  btnListenAndShadow(empInfoBtn);
		}
		
		private function btnListenAndShadow(btn) {
		  TweenLite.to(btn, .1, {dropShadowFilter:{blurX:1, blurY:2, distance:2, alpha:0.6}});
		  btn.addEventListener(MouseEvent.MOUSE_OVER, btnRoll);
		  btn.addEventListener(MouseEvent.MOUSE_OUT, btnRoll);
		  btn.addEventListener(MouseEvent.MOUSE_DOWN, onClickBtn);
		  btn.addEventListener(MouseEvent.MOUSE_UP, onClickBtn);
		  btn.buttonMode = true;
		  btn.mouseChildren = false;
		  if(btn != '[object nextPrevBtn]') {
			btn.addEventListener(MouseEvent.MOUSE_OVER, rollLabelVisible);
			btn.addEventListener(MouseEvent.MOUSE_OUT, rollLabelVisible);
		  }
		}
		
/*----- Button Functions -----*/		
	  private function btnRoll(event:MouseEvent) { var curBtn = event.target; }
	  
	  private function rollLabelVisible(event:MouseEvent) {
		var curBtn = event.target;
		if(over) {
			curBtn.rollLabel.visible = false;
			curBtn.btnLabel.visible = true;
			over = false;
		} else {
			curBtn.rollLabel.visible = true;
			curBtn.btnLabel.visible = false;
			over = true;
		}
	  }
	  
	  private function onClickBtn(event:Event) {
		trace(event.target.name);
		var curBtn = event.target,
			yPos = curBtn.y; 
		if(clicked) {
		  TweenLite.to(curBtn, .25, { y:yPos - 2, dropShadowFilter:{blurX:1, blurY:2, distance:2, alpha:0.6}});
		  clicked = false;
		} else {
		  clickChannel = btnClickSound.play();
		  clickChannel.soundTransform = soundVol;
		  TweenLite.to(curBtn, .25, { y:yPos + 2, dropShadowFilter:{blurX:0, blurY:0, distance:0, alpha:0}});
		  clicked = true;
		  // TODO add removeEL. for onClickBtn and onComp func to addEL when tween done 
		}
	  }
	  
	  private function tabOnAndAvailable(obj) {
		var city = getChildByName('Citybtn'),
			military = getChildByName('Militarybtn'),
			civilian = getChildByName('Civilianbtn');
		if(currentTab) currentTab.btnRoll.visible = false;
		switch(obj.type) {
		  case 'city':
		    currentTab = city;
			if(obj.army) military.enableBtn();
			if(obj.support) civilian.enableBtn();
			break;
		  case 'army':
			currentTab = military;
			if(obj.support) civilian.enableBtn();
			break;
		  case 'settler':
			currentTab = civilian;
			break;
		}
		currentTab.btnRoll.visible = true;
	  }
		
/*----- From eAW.as -----*/
		public function displaySelectedInfo(obj:Object) {
		  unSelect(false);
		  switch(obj.type) {
		  	case 'army':
		  	  leaderTF.text = obj.general;
		  	  display.seperateUnitsInObj(baseUnits, obj, empire);
		  	  break;
		  	case 'settler':
		  	  display.displayThumbs('/thumb/settler.png', empire, obj.supportPieces);
		  	  break;
		  	case 'city':
		  	  var army = obj.army;
		  	  leaderTF.text = army.general;
    		  display.seperateUnitsInObj(baseUnits, army, empire);			  
		  	  break;
		  }
		  tabOnAndAvailable(obj);
          showingThumbs = true;
		}
		
		public function unSelect(noneSelected:Boolean = true) {
		  var city = getChildByName('Citybtn'),
			military = getChildByName('Militarybtn'),
			civilian = getChildByName('Civilianbtn');
		  leaderTF.text = empire;
		  if(showingThumbs) {
    		display.removeThumbs();
    		showingThumbs = false;
			if(noneSelected) {
			  city.disableBtn();
			  military.disableBtn();
			  civilian.disableBtn();
			  currentTab = null;
			}
    	  }
		}
	}	
}