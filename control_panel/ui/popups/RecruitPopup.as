package control_panel.ui.popups {
  import common.ImgLoader;
  
  import control_panel.ui.DisplayThumb;
  
  import pieces.Unit;
  import pieces.agents.Settler;
  
  public class RecruitPopup extends CityPopup {
    
    public function RecruitPopup(params:*, object:*) {
      super(params, object);
    }
    
    private function addPopupImage() {
      var img = new ImgLoader('ui/popups/placeholder.jpg');
      img.x = 10;
      img.y = 10;
      addChild(img);
      createQueueLabel("Recruiting Queue");
    }
    
    public override function createXMLList(params) {
      var xml:XML = new XML(<units></units>);
      currObj.can_train().forEach(function(u) {
        xml.appendChild(params.unit.(objCall == u.toString()))
      });
      return xml.unit
    }
    
    public override function createThumbAttributes(thumb, image) {
      return {thumb_for: 'Army', type: thumb.objCall, cost: thumb.cost, thumb: image}
    }
    
    public override function createSelectedObject(target) {
      var new_obj = target.responds_to.parent_type == 'agent' ?
        target.responds_to :
          new Unit(target.obj_call(), currObj);
      currObj.unitsQueue(new_obj);
    }
    
    public override function getQueue() {
      addPopupImage();
      return currObj.unitsQueue();
    }

    public override function additionalAvailable(len, bg) {
      if(currObj.population() >= 15000) {
        var settler = new Settler(currObj),
            j = len%7,
            k = Math.floor(len/7),
            thumb = new DisplayThumb(settler,currObj);
        addThumbnail(thumb, bg, j, k);
      }
    }
  }
}