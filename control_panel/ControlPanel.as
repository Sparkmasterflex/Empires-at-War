package control_panel {
  import com.greensock.*;
  import com.greensock.easing.*;
  import com.greensock.plugins.DropShadowFilterPlugin;
  import com.greensock.plugins.TweenPlugin;
  
  import empires.Empire;
  
  import empiresAtWar;
  TweenPlugin.activate([DropShadowFilterPlugin]);
  
  import flash.display.Loader;
  import flash.net.URLRequest;
  import flash.net.URLLoader;
  
  import common.ImgLoader;
  import common.Label;
  import common.Gradient;
  
  import control_panel.ui.SquareButton;
  import control_panel.ui.DisplayArray;
  
  import flash.display.MovieClip;
  import flash.events.*;
  
  import static_return.GameConstants;
  import dispatch.PopupEvent;
  
  public class ControlPanel extends MovieClip {
  	/*---- CONSTANTS ----*/
  	private static const COLLAPSED:int = GameConstants.STAGE_HEIGHT - 80;
  	private static const EXPANDED:int  = GameConstants.STAGE_HEIGHT - 175;
  	
  	/*---- Classes Added ----*/
  	public  var userEmp:Empire;
  	private var bg:ImgLoader;
  	private var empSymbol:ImgLoader;
  	public  var empLabel:Label;
  	public  var moneyLabel:Label;
  	public  var turnLabel:Label;
  	public  var selectedUnits:DisplayArray;
  	public  var eAtW:empiresAtWar;
  	
  	/*-- Arrays --*/
  	public var buttons:Object = new Object();
  	public var currObj:Object;
  	public var baseXML:XML;
  	/*-- Numbers --*/
  	/*-- MovieClips and Strings --*/
  	
  	/*---- Boolean ----*/
  	private var expanded:Boolean = false;
  	private var over:Boolean = false;
  	private var clicked:Boolean = false;
	
    public function ControlPanel(empire, turn, parent) {
  	  eAtW = parent;
  	  userEmp = empire;
  	  this.y = COLLAPSED;
  	  bg = new ImgLoader('controlPanel/control_panel.png');
  	  addChild(bg);
  	  addEmpireSymbol();
  	  createButtons();
  	  addEmpireInfo(turn);
  	  addSelectedUnits();
  	}
  	
  	private function addEmpireSymbol() {
  	  var emp = GameConstants.parseEmpireName(userEmp.empire());
  	  empSymbol = new ImgLoader('empireSymbols/' + emp + '.png');
  	  empSymbol.scaleX = 0.9;
  	  empSymbol.scaleY = 0.9;
  	  empSymbol.x = 5;
  	  empSymbol.y = 10;
  	  empSymbol.alpha = 0.75;
  	  addChild(empSymbol);
  	}
  	
  	public function expand(isSelected, piece) {
  	  currObj = piece;
  	  var to = expanded && !isSelected ? COLLAPSED : !expanded ? EXPANDED : null,
  		  d  = expanded ? .25 : 0;
  	  if(to) {
    		TweenLite.to(this, .35, { y: to, ease:Sine.easeIn, delay: d });
    		repositionButtons(expanded);
    		expanded = expanded ? false : true;
  	  }
  	  selectedUnits.displayThumbnails(currObj, expanded);
  	}
  	
  	private function createButtons() {
  	  buttons['turn'] = "End Turn";
  	  buttons['army'] = "recruit.png";
  	  buttons['building'] = "building.png";
  	  buttons['diplomacy'] = "diplomacy.png";
    	buttons['money'] = "money.png";
  	  
  	  for(var j:String in buttons) {
    		var str = buttons[j],
      			width = j == 'turn' ? 150 : 65,
      			fontSize = j == 'turn' ? 30 : null;
      	    buttons[j] = new SquareButton(str, width, 57, fontSize);
    		addChild(buttons[j]);
    		btnListenAndShadow(buttons[j]);
  	  }
  	  positionButtons();
  	  observeButtons();
  	}
  	
  	private function positionButtons() {
  	  var commonY = 15,
  		    hidden  = 87;
  	  
  	  buttons['turn'].x = 1020;
  	  buttons['turn'].y = commonY;
  	  buttons['diplomacy'].x = 935;
  	  buttons['diplomacy'].y = commonY;
  	  buttons['money'].x = 840;
  	  buttons['money'].y = commonY;
  	  
  	  buttons['building'].x = buttons['diplomacy'].x;
  	  buttons['building'].y = hidden;
  	  buttons['army'].x = buttons['diplomacy'].x;
  	  buttons['army'].y = hidden + 72;
  	}
  	
  	private function observeButtons() {
  	  buttons['turn'].addEventListener(MouseEvent.CLICK, endTurn);
  	  buttons['building'].addEventListener(MouseEvent.CLICK, currentConstruction);
  	  buttons['army'].addEventListener(MouseEvent.CLICK, currentTraining);
  	}
  	
  	private function addEmpireInfo(turn) {
  	  empLabel   = new Label(40, 0xffffff, 'Trebuchet MS', 'LEFT');
  	  moneyLabel = new Label(18, 0xffffff, 'Trebuchet MS', 'LEFT');
  	  turnLabel  = new Label(18, 0xffffff, 'Trebuchet MS', 'LEFT');
  	  var empStr = GameConstants.parseEmpireName(userEmp.empire());
  	  
  	  empLabel.text = empStr.match(/(Gaul|Mongols)/) ? 'The ' + empStr : empStr;
  	  turnLabel.text = 'Turn: ' + turn;
  	  moneyLabel.text = 'Treasury: ' + userEmp.treasury();
  	  
  	  empLabel.x = 30;
  	  turnLabel.x = 230;
  	  moneyLabel.x = 230;
  	  empLabel.y = 15;
  	  turnLabel.y = 15;
  	  moneyLabel.y = 45;
  	  
  	  addChild(empLabel);
  	  addChild(turnLabel);
  	  addChild(moneyLabel);
  	  
  	  TweenLite.to(empLabel, .1, {dropShadowFilter:{blurX:2, blurY:1, distance:1, alpha:0.65}});
  	  TweenLite.to(turnLabel, .1, {dropShadowFilter:{blurX:2, blurY:2, distance:1, alpha:0.65}});
  	  TweenLite.to(moneyLabel, .1, {dropShadowFilter:{blurX:2, blurY:2, distance:1, alpha:0.65}});
  	}
  	
  	private function addSelectedUnits() {
  	  selectedUnits = new DisplayArray(this);
  	  selectedUnits.x = 230;
  	  selectedUnits.y = 100;
  	  addChild(selectedUnits);
  	}
  	
  	private function repositionButtons(expanded) {
  	  var row1Y = 15, row2Y = 87;
  	  if(expanded) {
  		var endTurnY = row1Y, turnDelay = .25, diplomDelay = 0, toX = 935, buildY = row2Y, buildDelay = 0, buildSpeed = .15,
  			turnY = 15, moneyY = 45, labelX = 230, selUnitY = 100, selUnitDelay = 0;
  	  } else {
  		  endTurnY = row2Y; turnDelay = 0; diplomDelay = .2; toX = 1105; buildY = row1Y; buildDelay = .25; buildSpeed = .25;
  		  turnY = 75; moneyY = 105; labelX = 30; selUnitY = 15; selUnitDelay = .2;
  	  }
  	  
  	  TweenLite.to(buttons['turn'], .25, {y: endTurnY, ease:Sine.easeIn, delay: turnDelay});
  	  TweenLite.to(buttons['diplomacy'], .25, {x: toX, ease:Sine.easeIn, delay: diplomDelay});
  	  TweenLite.to(buttons['money'], .25, {x: (toX - 80), ease:Sine.easeIn, delay: diplomDelay});
  	  TweenLite.to(buttons['building'], buildSpeed, {y: buildY, ease:Sine.easeIn, delay: buildDelay});
  	  TweenLite.to(buttons['army'], buildSpeed, {y: (buildY + 72), ease:Sine.easeIn, delay: buildDelay});
  	  
  	  TweenLite.to(turnLabel, .2, {y: turnY, x: labelX, ease: Sine.easeIn});
  	  TweenLite.to(moneyLabel, .2, {y: moneyY, x: labelX, ease: Sine.easeIn});
  
  	  TweenLite.to(selectedUnits, .2, {y: selUnitY, ease: Sine.easeIn, delay: selUnitDelay});
  	}
  	
  	private function btnListenAndShadow(btn) {
  	  btn.addEventListener(MouseEvent.MOUSE_OVER, btnRoll);
  	  btn.addEventListener(MouseEvent.MOUSE_OUT, btnRoll);
  	  btn.addEventListener(MouseEvent.MOUSE_DOWN, onClickBtn);
  	  btn.addEventListener(MouseEvent.MOUSE_UP, onClickBtn);
  	  btn.buttonMode = true;
  	  btn.mouseChildren = false;
  	}
  	
  	/*----- Button Functions -----*/
  	private function currentConstruction(event:MouseEvent) {
  	  var xml = 'city_' + currObj.empire()[1].toLowerCase() + '.xml',
  		  xmlLoader = new URLLoader();
  	  xmlLoader.load(new URLRequest('xml/' + xml));
  	  xmlLoader.addEventListener(Event.COMPLETE, availableToBuild);
  	}
  	
  	private function availableToBuild(event:Event) {
  	  var buildingXML = new XML(event.target.data);
//          unavailable:Array = new Array()
//      currObj.building().forEach(function(build) { unavailable.push(build); });
//      currObj.buildingQueue().forEach(function(build) { unavailable.push(build); });
//      
//      unavailable.forEach(function(build) {
//  	    delete buildingXML.building.(level == build.level() && type == build.type())[0]; 
//  	  });
  	  dispatchEvent(new PopupEvent(PopupEvent.POPUP, 'City', buildingXML, currObj, true));
  	}
  
  	private function currentTraining(event:MouseEvent) {
  	  var xml = 'xml/army_base.xml',
          xmlLoader = new URLLoader();
      xmlLoader.load(new URLRequest(xml));
      xmlLoader.addEventListener(Event.COMPLETE, setBaseUnits);
  	}
    
    private function setBaseUnits(event:Event) {
      baseXML = new XML(event.target.data);
      var emp_xml = 'xml/army_' + currObj.empire()[1].toLowerCase() + '.xml',
          emp_xmlLoader = new URLLoader();
      emp_xmlLoader.load(new URLRequest(emp_xml));
      emp_xmlLoader.addEventListener(Event.COMPLETE, availableToTrain);  
    }
    
    private function availableToTrain(event:Event) {
      var empXML = new XML(event.target.data),
          available = currObj.can_train(),
          allUnits = baseXML.appendChild(empXML.*);
      dispatchEvent(new PopupEvent(PopupEvent.POPUP, 'Army', allUnits, currObj, true));
    }
  	
  	private function btnRoll(event:MouseEvent) {
  	  var curBtn = event.target;
  	  over = over ? false : true;
  	  curBtn.btnRoll.visible = over;
  	}
  	
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
  	  var curBtn = event.target,
  		    yPos = curBtn.y; 
  	  if(clicked) {
  		//TweenLite.to(curBtn, .25, { y:yPos - 2, dropShadowFilter:{blurX:.5, blurY:.5, distance:1, alpha:0.45}});
  		clicked = false;
  	  } else {
  //		clickChannel = btnClickSound.play();
  //		clickChannel.soundTransform = soundVol;
  		//TweenLite.to(curBtn, .25, { y:yPos + 2, dropShadowFilter:{blurX:0, blurY:0, distance:0, alpha:0}});
  		clicked = true;
  		// TODO add removeEL. for onClickBtn and onComp func to addEL when tween done 
  	  }
  	}
  	
  	public function endTurn(event:MouseEvent) {
  	  eAtW.currentTurn++;
  	  turnLabel.text = "Turn: " + eAtW.currentTurn;
  	  userEmp.processTurn(this)
  	}
  }
}