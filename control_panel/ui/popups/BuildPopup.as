package control_panel.ui.popups {
  import common.ImgLoader;
  import pieces.Building;
  
  public class BuildPopup extends CityPopup {
  
    public function BuildPopup(params:*, object:*) {
      super(params, object);
      add_popup_image("ui/popups/placeholder2.jpg", {});
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
      var new_obj = new Building(target.responds_to, currObj.empire()[1], currObj);
      currObj.buildingQueue(new_obj);
      availBG.removeChild(target);
    }
    
    public override function getQueue() {
      return currObj.buildingQueue();
    }
  }
}