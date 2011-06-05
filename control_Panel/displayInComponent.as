package control_Panel {
	import flash.display.MovieClip;
	import flash.events.*;
	import common.gradient;
	import control_Panel.unitThumbMC;
	import dispatch.popupEvent;
	import dispatch.sendEvent;

	public class displayInComponent extends MovieClip {
/*-- Added Classes --*/
	  private var inComponentBox:gradient;
	  private var thumbMask:gradient;
	  private var thumbUnit:unitThumbMC;

/*-- Arrays --*/
//public var newArmy:Object;
	  public var selectedArr:Array;
	  private var unitAndMen:Array;
	  public var unitsXML:XML;
	/*-- Numbers --*/
	public var numThumbs:Number;
	/*-- Boolean --*/
	  public var selectMultiple:Boolean = false;

/*-- MovieClips and Strings --*/
	  public var thumbs:MovieClip;
	  public var empire:String;

	  public function displayInComponent() {
		inComponentBox = new gradient(
		['none', 'none'], 'linear', [0xcccccc, 0xdddddd, 0xffffff],
		[1,1,1], [0,45,255], 448, 124,
		(3 * Math.PI) / 2, [448,124,25,25], 'roundRect'
		);
		addChild(inComponentBox);
	  }

	  public function seperateUnitsInObj(xml, obj, empire) {
		unitsXML = xml;
		unitAndMen = new Array();
		for(var j:String in obj) {
		  if(j.indexOf('unit') >= 0) {			  	
			if(obj[j]) unitAndMen.push([j, obj[j][0], obj[j][1]]);				
		  }
		}
		displayThumbs(xml, empire, unitAndMen);
	  }

	  public function displayThumbs(imgSrc:*, e:String, units:*) {
		empire = e;
		thumbs = new MovieClip();
		addChild(thumbs);
		var num = units.length,
		j:uint = 0,
		k:uint = 0;

		for(var i:uint = 0; i < num; i++) {
		  if(imgSrc is String) {
			thumbUnit = new unitThumbMC(units[i], imgSrc, empire);
		  } else {
			var objKey = units[i][0],
			unit = units[i][1].toString(),
			men = units[i][2],
			unitType:XMLList = imgSrc.unit.(objCall == unit);
			thumbUnit = new unitThumbMC(objKey, unitType, empire, men);
		  }
		  thumbUnit.x = (50 * j) - 1;
		  thumbUnit.y = (60 * k) - 1;
		  if(j == 8) {
			j = 0;
			k++;
		  } else {
			j++;
		  }
		  thumbs.addChild(thumbUnit);
		  thumbUnit.mouseChildren = false;
		  thumbUnit.doubleClickEnabled = true;
		  thumbUnit.addEventListener(MouseEvent.DOUBLE_CLICK, extendedUnitDetails);
		  thumbUnit.addEventListener(MouseEvent.CLICK, selectThumb);
		  addMask(thumbs);
		}
		numThumbs = thumbs.numChildren;
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
		  var eAW = this.parent.parent,
			  uC = eAW.gStage.userContr;
			event.target.callKey.indexOf('unit') >= 0 ? uC.newArmy(selectedArr) : uC.seperateSupport(selectedArr);
		}

		private function addMask(mc) {
		  thumbMask = new gradient(
		    ['none', 'none'], 'solid', [0x009900],
		    [1], [0], 448, 124,
		    0, [448,124,25,25], 'roundRect'
		  );
		  addChild(thumbMask);
		  thumbMask.visible = false;
		  mc.mask = thumbMask;
		}

		public function removeThumbs() {
		  removeChild(thumbs);
		  removeChild(thumbMask);
		}

		private function removeAllHighlights() {
		  for(var i:uint = 0; i < thumbs.numChildren; i++) {
			var thumb = thumbs.getChildAt(i);
			thumb.removeHighlight();
		  }
		}

		public function extendedUnitDetails(event:MouseEvent) {
			var thumb  = event.currentTarget,
			men    = int(thumb.menTF.text),
			info   = [thumb.unitXML, men];
			dispatchEvent(new popupEvent(popupEvent.POPUP, 'UnitInfo', info, empire, true));
		}
	}
}