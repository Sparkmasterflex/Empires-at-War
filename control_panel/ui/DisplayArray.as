package control_panel.ui {
  import common.Gradient;
  import common.ImgLoader;
  
  import dispatch.PopupEvent;
  
  import flash.display.MovieClip;
  import flash.events.*;
  import flash.net.URLLoader;
  import flash.net.URLRequest;

  public class DisplayArray extends MovieClip {
	public var xmlLoader:URLLoader;
	public var baseArmyLoader:URLLoader;
	public var selectedXML:XML;
	
	/*-- Arrays --*/
	private var current:Object;
	public var selectedArr:Array;
	public var thumbs:Array;
	private var rollBG:Gradient;
	
	/*-- Numbers --*/
	public var numThumbs:Number;
	
	/*-- Boolean --*/
	public var selectMultiple:Boolean = false;
	private var tabOver:Boolean = false;
	  
	public function DisplayArray() {
  	  super();
	  var bg = new Gradient(
		  [2, 0x444444], 'linear', [0xaaaaaa, 0xaaaaaa],
		  [1,1], [0,145], 655, 200,
		  (3 * Math.PI) / 2, [655,200], 'rectangle'
	  );
	  addChild(bg);
	}
	
	public function neededXML(obj, expanded:Boolean) {
      if(thumbs) thumbs.forEach(function(t) { removeChild(t); });
	  current = obj;
	  var empire = current['empire'].toLowerCase(),
		  xml = current['pieceType'] + "_" + empire + '.xml';
	  if(expanded) {
	    xmlLoader = new URLLoader();
	    xmlLoader.load(new URLRequest('xml/' + xml));
	    thumbs = new Array();
		addSelectedTabs(obj);
	    switch(current['pieceType']) {
		  case 'city':
		    xmlLoader.addEventListener(Event.COMPLETE, displayCityBuildings);
		    break;
		  case 'army':
			baseArmyLoader = new URLLoader();
			baseArmyLoader.load(new URLRequest('xml/army_base.xml'));
		    xmlLoader.addEventListener(Event.COMPLETE, armyUnitsReady);
		    baseArmyLoader.addEventListener(Event.COMPLETE, baseUnitsReady);
		    break;
	    }
	  }
	}
	
	public function displayCityBuildings(event:Event) {
	  selectedXML = new XML(event.target.data);
	  var j:uint = 0, k:uint = 0;
	  for(var i:int = 0; i < current['building'].length; i++) {
		var list:XMLList = selectedXML.building.(objCall == current['building'][i]),
		    thumb = new DisplayThumb(list.thumbnail, current);
		positionThumb(thumb, j, k)
		if(j == 8) {
		  j = 0;
		  k++;
		} else { j++; }
	  }
	}
	
	private function armyUnitsReady(event:Event) { selectedXML = new XML(event.target.data); }
	
	private function baseUnitsReady(event:Event) {
	  var baseUnits = new XML(event.target.data);
	  displayArmyUnits(baseUnits);
	}
	
	private function displayArmyUnits(base) {
	  var allUnits = base.appendChild(selectedXML.*),
		  selectedArmy = current['units'],
		  j:uint=0, k:uint=0;
	  for(var a:String in selectedArmy) {
		var list:XMLList = allUnits.unit.(objCall == selectedArmy[a][0]),
			thumb = new DisplayThumb(list.thumbnail, current, selectedArmy[a][1]);
		positionThumb(thumb, j, k);
		if(j == 7) {
		  j = 0;
		  k++;
		} else { j++; }
	  }
	}
	
	private function positionThumb(thumb, j, k) {
	  thumb.x = 75 * j;
	  thumb.y = 75 * k;
	  thumbs.push(thumb);
	  addChild(thumb);
	  thumb.mouseChildren = false;
	  thumb.doubleClickEnabled = true;
	  thumb.addEventListener(MouseEvent.DOUBLE_CLICK, extendedDetails);
	  thumb.addEventListener(MouseEvent.CLICK, selectThumb);
	}
	
	public function selectThumb(event:MouseEvent) {
	  if(event.target.selected) {
		if(!selectMultiple){
		  removeAllHighlights();
		  if(selectedArr.length > 1) {
			event.target.createHighLight();
			selectedArr = new Array();
			selectedArr.push(event.target.callKey);
		  }
		  selectedArr = [];
		} else {
		  event.target.removeHighlight();
		}		  	
	  } else {
		if(!selectMultiple) {
		  selectedArr = new Array();
		  removeAllHighlights();
		}
		if(!selectedArr || !selectedArr.length > 0) selectedArr = new Array();
		event.target.createHighLight();
	    selectedArr.push(event.target.callKey);  
	  }
	  if(selectedArr.length == numThumbs) selectedArr = null;
//		var eAW = this.parent.parent,
//			uC = eAW.gStage.userContr;
		//event.target.callKey.indexOf('unit') >= 0 ? uC.newArmy(selectedArr) : uC.seperateSupport(selectedArr);
	}
	
	private function addSelectedTabs(obj) {
	  var tabs = ['city.png', 'army.png', 'agent.png'],
		  i = 0;
	  tabs.forEach(function(tab) {
		var btnDim = 53,
			bgColor = tab.match(obj.pieceType) ? 0xaaaaaa : 0x777777,
			btn = new MovieClip(),
			bg:Gradient = new Gradient(
				['none'], 'linear', [bgColor, bgColor],
				[1,1], [0,255], btnDim, btnDim,
				(3 * Math.PI) / 2, [btnDim,btnDim], 'rectangle'
			),
			img:ImgLoader = new ImgLoader('controlPanel/buttons/' + tab);
	    btn.addChild(bg);
		btn.addChild(img);
		btn.x = 655 - (btnDim + 1);
		btn.y = (btnDim * i) + 2;
		btn.mouseChildren = false;
		addChild(btn);
		btn.addEventListener(MouseEvent.MOUSE_OVER, rollOver);
		btn.addEventListener(MouseEvent.MOUSE_OUT, rollOver);
		i++;
	  });
	}
	
	private function extendedDetails(event:MouseEvent) {
	  var thumb  = event.currentTarget;//,
//		  men    = int(thumb.menTF.text),
//		  info   = [thumb.unitXML, men];
	  dispatchEvent(new PopupEvent(PopupEvent.POPUP, 'UnitInfo', null, current['empire'].toLowerCase(), true));
	}
	
	private function removeAllHighlights() {
	  for(var i:uint = 0; i < thumbs.length; i++) {
		var thumb = thumbs[i];
		thumb.removeHighlight();
	  }
	}
	
	private function rollOver(event:MouseEvent) {
	  var tab = event.target;
	  if(tabOver) {
		tab.removeChild(rollBG);
		tabOver = false;
	  } else {
		rollBG = new Gradient(
			  ['none'], 'linear', [0xaaaaaa, 0xaaaaaa],
			  [1,1], [0,255], tab.width, tab.height,
			  (3 * Math.PI) / 2, [tab.width,tab.height], 'rectangle'
		);
		tab.addChild(rollBG);
		tab.setChildIndex(rollBG, (tab.numChildren - 2));
		tabOver = true;
	  }
	}
  }
}