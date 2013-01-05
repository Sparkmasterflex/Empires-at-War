package control_panel.ui.popups {
  import common.Gradient;
  
  import control_panel.ui.DisplayThumb;
  import control_panel.ui.Popup;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.setTimeout;
  
  import pieces.Building;
  import pieces.Unit;
  
  import static_return.GameConstants;

  public class CityPopup extends Popup {
  	public var currObj;
    private var popup_for;
    public var availBG:Gradient;
    public var currentBG:Gradient;
  	
  	public function CityPopup(params, type, object) {
  	  super(700, 550);
  	  currObj = object;
      popup_for = type;
  	  title.text = "City Information";
  	  setupAvailable(params);
  	  setupQueue();
  	}
  	
  	private function setupAvailable(params) {
  	  var thumbs:XMLList = createXMLList(params, popup_for), //popup_for == 'Army' ? params.unit : params.building,
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
    
    private function createXMLList(params, popup_for) {
      if(popup_for == "Army") {
        var xml:XML = new XML(<units></units>);
        currObj.can_train().forEach(function(u) {
          xml.appendChild(params.unit.(objCall == u.toString()))
        });
        return xml.unit
      } else {
        currObj.unavailable().forEach(function(ua) {
          if(ua != null && ua.toString() != "") delete params.building.(objCall == ua.toString())[0];
        });
        return params.building
      }
    }
    
  	private function setupQueue() {
      currentBG = new Gradient(
        [1, 0x444444], 'linear', [0xcccccc, 0x999999], 
        [1,1], [0,145], 600, 75, 
        (3*Math.PI), [600, 75], 'rectangle');
      currentBG.x = 50;
      currentBG.y = 400;
      addChild(currentBG);
      var queue = popup_for == 'Army' ? currObj.unitsQueue() : currObj.buildingQueue(); 
      createAndPositionThumbs(queue, currentBG);
  	}
	
  	  
  	private function createAndPositionThumbs(thumbs, bg) {
  	  var j:uint=0, k:uint=0, thumb, setOverlay,
          length = thumbs is XMLList ? thumbs.length() : thumbs.length;
  	  for(var i:int=0; i<length; i++) {
    		if(thumbs is XMLList) {
          var image = thumbs[i].thumbnail,
              attributes = popup_for == 'Army' ? 
                {thumb_for: popup_for, type: thumbs[i].objCall, cost: thumbs[i].cost, thumb: image} :
                  {thumb_for: popup_for, type: thumbs[i].type, level: thumbs[i].level, cost: thumbs[i].cost, points: thumbs[i].build_points, thumb: image}
          setOverlay = false;
          thumb = new DisplayThumb(attributes, currObj);
    		} else {
          thumb = new DisplayThumb(thumbs[i], currObj);
          setOverlay = true;
        }
    	  
        if(setOverlay) thumb.addOverlay(thumbs[i].build_points(), thumbs[i].originalPoints);
    		thumb.x = 75 * j;
    		thumb.y = 75 * k;
    		bg.addChild(thumb);
    		thumb.mouseChildren = false;
    		thumb.doubleClickEnabled = true;
    //		thumb.addEventListener(MouseEvent.DOUBLE_CLICK, extendedDetails);
    		thumb.addEventListener(MouseEvent.CLICK, selectObject);
    		if(j == 7) {
    		  j = 0;
    		  k++;
    		} else { j++; }
  	  }
  	}
	
  	public function selectObject(event:MouseEvent) {
      var parent = this.parent,
          userEmp = parent.userEmpire,
          target = event.target;

      if(userEmp.treasury() >= target.responds_to.cost) {
        var new_obj;
        if(popup_for == 'Army') {
          new_obj = new Unit(target.obj_call(), currObj);
          currObj.unitsQueue(new_obj);
        } else {
          new_obj = new Building(target.responds_to, currObj),
          currObj.buildingQueue(new_obj);
        }
        var thumb = new DisplayThumb(target.responds_to, currObj);
    	  
        userEmp.treasury(target.responds_to.cost*-1)
        if(popup_for != 'Army') availBG.removeChild(target);
        if(target.responds_to.cost > userEmp.treasury()) {
          target.alpha = .5;
          target.removeEventListener(MouseEvent.CLICK, selectObject);
        }
        thumb.x = currentBG.numChildren * 75;
        currentBG.addChild(thumb);
      }
  	}
  }
}