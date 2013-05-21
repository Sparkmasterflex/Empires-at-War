package control_panel.ui.popups {
  import flash.display.MovieClip;
  import flash.utils.setTimeout;
  
  import control_panel.ui.Popup;
  import common.Gradient;
  import common.ImgLoader;
  import common.Label;
  
  import pieces.Unit;
  
  public class UnitPopup extends Popup {
    private var unit:Unit;

    public function UnitPopup(type, u) {
      super(700,550);
      unit = u;
      title.text = unit.name();
      title.x = 350;
      title.y = 10;
      createUnitImage()
      buildAttributeList();
    }

    private function createUnitImage() {
      var bg = new Gradient(
        [0, 0x444444], 'linear', [0xeeeeee, 0xcccccc],
        [1,1], [0,159], 320, 320,
        (3 * Math.PI) / 2, [320,320], 'rectangle'
      ),
          path = unit.img_path() + unit.image(),
          img = new ImgLoader(path);
      bg.x = 10;
      bg.y = 10;
      addChild(bg);
      setTimeout(function() {
        img.x = 10 + (160-(img.bmWidth/2));
        img.y = 10 + (160-(img.bmHeight/2));
        addChild(img);
      }, 100);
    }

    /* 
     * Creates text areas to display attributes of unit
     */
    public function buildAttributeList() {
      var fs = 18, fc = 0x444444,
          values = new Array(
            ["Unit Type:", unit.unit_type()],
            ["Men:", unit.men()],
            ["Attack:", unit.attack()],
            ["Defense:", unit.defense()],
            ["Recruitment Cost:", unit.cost()],
            ["Upkeep Costs:", unit.upkeep()]
            //["Bonuses:", unit.bonuses()]
          );
      for(var i:int=0; i<values.length; i++) {
        var lbl_txt = values[i][0],
            val_txt = values[i][1],
            lbl = new Label(fs, 0x000000, "Arial", "LEFT"),
            val = new Label(fs, fc, "Arial", "LEFT");
        lbl.width = 100;
        val.width = 100;
        val.multiline = true;
        val.wordWrap = true;
        lbl.x = 350;
        val.x = 590;
        lbl.y = (30*i)+60;
        val.y = (30*i)+60;
        lbl.text = lbl_txt;
        val.text = val_txt;
        addChild(lbl);
        addChild(val);
      }

      var desc = new Label(fs, fc, "Arial", "LEFT");
      desc.width = 630;
      desc.multiline = true;
      desc.wordWrap = true;
      desc.text = "Description:\n\n" + unit.description();
      desc.x = 10;
      desc.y = 350;
      addChild(desc);
    }
  }
}