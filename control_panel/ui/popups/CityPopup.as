package control_panel.ui.popups {
  import com.greensock.loading.ImageLoader;
  
  import common.Gradient;
  import common.ImgLoader;
  
  import common.Label;
  
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
//    private var popup_for;
    public var availBG:Gradient;
    public var currentBG:Gradient;
    public var queue;
  	
  	public function CityPopup(params, object) {
  	  super(700, 550);
  	  currObj = object;
  	  title.text = "City Information";
  	  setupAvailable(params);
      setupQueue();
  	}
    
    private function setupAvailable(params) {
  	  var thumbs:XMLList = createXMLList(params), //popup_for == 'Army' ? params.unit : params.building,
  	  	  emp = GameConstants.parseEmpireName(currObj.empire());
  		availBG = new Gradient(
			  [1, 0x444444], 'linear', [0xeeeeee, 0xcccccc], 
			  [1,1], [0,145], 680, 150, 
			  (3*Math.PI), [680, 150], 'rectangle');
  	  availBG.x = 10;
  	  availBG.y = 245;
  	  addChild(availBG);
      createAndPositionThumbs(thumbs, availBG);
      additionalAvailable(thumbs.length(), availBG);
  	}
    
    private function setupQueue() {
      queue = getQueue();
      currentBG = new Gradient(
        [1, 0x444444], 'linear', [0xeeeeee, 0xcccccc], 
        [1,1], [0,145], 680, 75, 
        (3*Math.PI)/2, [680, 75], 'rectangle');
      currentBG.x = 10;
      currentBG.y = 465;
      addChild(currentBG);
      createAndPositionThumbs(queue, currentBG);
  	}
	
  	private function createAndPositionThumbs(thumbs, bg) {
  	  var j:uint=0, k:uint=0, thumb, setOverlay,
        length = (thumbs is XMLList) ? thumbs.length() : thumbs.length;
      
  	  for(var i:int=0; i<length; i++) {
    		if(thumbs is XMLList) {
          var image = thumbs[i].thumbnail,
              attributes = createThumbAttributes(thumbs[i], image);
          setOverlay = false;
          thumb = new DisplayThumb(attributes, currObj);
    		} else {
          thumb = new DisplayThumb(thumbs[i], currObj);
          setOverlay = true;
        }
    	  
        if(setOverlay) thumb.addOverlay(thumbs[i].build_points(), thumbs[i].originalPoints);
        addThumbnail(thumb, bg, j, k);
    		if(j == 7) {
    		  j = 0;
    		  k++;
    		} else { j++; }
  	  }
  	}
    
    public function addThumbnail(thumb, bg, j, k) {
      thumb.x = 75 * j;
      thumb.y = 75 * k;
      bg.addChild(thumb);
      thumb.mouseChildren = false;
      thumb.doubleClickEnabled = true;
      //		thumb.addEventListener(MouseEvent.DOUBLE_CLICK, extendedDetails);
      thumb.addEventListener(MouseEvent.CLICK, selectObject);
    }
    
    public function createQueueLabel(str) {
      var label = new Label(30, 0x444444, "Arial", 'LEFT');
      label.text = str;
      label.x = 10;
      label.y = 420;
      addChild(label);
    }
	
  	public function selectObject(event:MouseEvent) {
      var parent = this.parent,
          userEmp = parent.userEmpire,
          target = event.target;

      if(userEmp.treasury() >= target.responds_to.cost) {
        createSelectedObject(target);
        var thumb = new DisplayThumb(target.responds_to, currObj);
    	  
        userEmp.treasury(target.responds_to.cost*-1)
        if(target.responds_to.cost > userEmp.treasury()) {
          target.alpha = .5;
          target.removeEventListener(MouseEvent.CLICK, selectObject);
        }
        thumb.x = currentBG.numChildren * 75;
        currentBG.addChild(thumb);
      }
  	}
    
    public function createXMLList(params) { return false; }
    public function createThumbAttributes(thumb, image) { return false; }
    public function createSelectedObject(target) { return false; }
    public function getQueue() { return false; }
    public function additionalAvailable(len, bg) { return false; }
  }
}