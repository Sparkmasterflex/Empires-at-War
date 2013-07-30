package control_panel.ui.popups {
  import common.ImgLoader;
  import pieces.Building;
  
  public class BuildPopup extends CityPopup {
  
    public function BuildPopup(params:*, object:*) {
      super(params, object);
    }
    
    private function addPopupImage() {
      var img = new ImgLoader('ui/popups/placeholder2.jpg');
      img.x = 10;
      img.y = 10;
      addChild(img);
      createQueueLabel("Building Queue");
    }
    
    // TODO: fix this
    public override function createXMLList(params) {
      currObj.unavailable().forEach(function(ua) {
        if(ua != null && ua.toString() != "") delete params.building.(objCall == ua.toString())[0];
      });
      return params.building.(level == currObj.level())
    }
    
    public override function createThumbAttributes(thumb, image) {
      return {thumb_for: 'City', type: thumb.type, level: thumb.level, cost: thumb.cost, points: thumb.build_points, thumb: image, name: thumb.name}
    }
    
    public override function createSelectedObject(target) {
      var new_obj = new Building(target.responds_to, currObj.empire()[1]);
      currObj.buildingQueue(new_obj);
      availBG.removeChild(target);
    }
    
    public override function getQueue() {
      addPopupImage();
      return currObj.buildingQueue();
    }
  }
}