package control_panel.ui.popups {
  import common.Gradient;
  
  import control_panel.ui.DisplayThumb;
  import control_panel.ui.Popup;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  import pieces.Building;
  
  import static_return.GameConstants;

  public class CityPopup extends Popup {
  	public var currObj;
  	private var buildingLoader:URLLoader;
    public var availBG:Gradient;
    public var currentBG:Gradient;
  	
  	public function CityPopup(params, object) {
  	  super(700, 550);
  	  currObj = object;
  	  title.text = "City Information";
  	  setupAvailable(params);
  	  setupQueue();
  	}
  	
  	private function setupAvailable(params) {
  	  var thumbs:XMLList = params.building,
  	  	  emp = GameConstants.parseEmpireName(currObj.empire());
  		availBG = new Gradient(
			  [1, 0x444444], 'linear', [0xeeeeee, 0xcccccc], 
			  [1,1], [0,145], 600, 150, 
			  (3*Math.PI), [600, 150], 'rectangle');
  	  availBG.x = 50;
  	  availBG.y = 150;
  	  addChild(availBG);
  	  createAndPositionThumbs(thumbs, availBG);
  	}
	
  	private function setupQueue() {
  	  if(currObj.buildingQueue()) {
  		  var empire = currObj.empire()[1];
     	      buildingLoader = new URLLoader();
  	    buildingLoader.load(new URLRequest('xml/city_' + empire.toLowerCase() + '.xml'));
  		  buildingLoader.addEventListener(Event.COMPLETE, queueXMLLoaded);
  	  }
  	}
	
  	private function queueXMLLoaded(event:Event) {
  	  var xml = new XML(event.target.data);
  		currentBG = new Gradient(
			  [1, 0x444444], 'linear', [0xcccccc, 0x999999], 
			  [1,1], [0,145], 600, 75, 
			  (3*Math.PI), [600, 75], 'rectangle');
  	  currentBG.x = 50;
  	  currentBG.y = 400;
  	  addChild(currentBG);
  	  createAndPositionThumbs(currObj.buildingQueue(), currentBG, xml);
  	}
  	  
  	private function createAndPositionThumbs(thumbs, bg, xml=null) {
//  	  var j:uint=0, k:uint=0,
//  		  length = xml ? thumbs.length : thumbs.length();
//  	  for(var i:int=0; i<length; i++) {
//    		if(xml) {
//    		  var list:XMLList = xml.building.(level == thumbs[i].level() && type == thumbs[i].type()),
//              setOverlay = true,
//    			    image = list.thumbnail;
//    		} else {
//    		  image = thumbs[i].thumbnail;
//          setOverlay = false;
//        }
//    	  var thumb = new DisplayThumb(image, currObj.attr, {type: thumbs[i].type, level: thumbs[i].level, cost: thumbs[i].cost, points: thumbs[i].build_points});
//        if(setOverlay) thumb.addOverlay(thumbs[i].build_points(), thumbs[i].originalPoints);
//    		thumb.x = 75 * j;
//    		thumb.y = 75 * k;
//    		bg.addChild(thumb);
//    		thumb.mouseChildren = false;
//    		thumb.doubleClickEnabled = true;
//    //		thumb.addEventListener(MouseEvent.DOUBLE_CLICK, extendedDetails);
//    		thumb.addEventListener(MouseEvent.CLICK, selectBuilding);
//    		if(j == 7) {
//    		  j = 0;
//    		  k++;
//    		} else { j++; }
//  	  }
  	}
	
  	public function selectBuilding(event:MouseEvent) {
//      var parent = this.parent,
//          userEmp = parent.userEmpire,
//          target = event.target;
//      if(userEmp.treasury() >= target.building.cost) {
//    		var newBuilding:Building = new Building(target.building, currObj),
//            thumb = new DisplayThumb(target.img_string, currObj.attr, {level: newBuilding.level(), type: newBuilding.type()});
//    	  currObj.buildingQueue(newBuilding);
//        availBG.removeChild(target);
//        thumb.x = currentBG.numChildren * 75;
//        currentBG.addChild(thumb);
//        userEmp.treasury(target.building.cost*-1)
//      }
  	}
  }
}