package control_panel.ui.slides {
  import flash.display.MovieClip;
  import flash.utils.setTimeout;

  import common.*;
  
  public class Slide extends MovieClip {
    public var labels:Array;
    public var bg:Gradient;

    public function Slide(obj, img=null, bg=false) {
      super();
      labels = new Array();
      if(obj is Array) {
        add_bg();
/*        var keyboard = new ImgLoader('/ui/controlPanel/info_box/keys.png');
        keyboard.x = 20;
        keyboard.y = 20;*/
        obj.forEach(addLabel);
        //bg.addChild(keyboard);
      } else {
        parse_object_info(obj);
      }
    }

    /* 
     * Add Background for text
     */
    private function add_bg(large=false) {
      var bg_height = 140,
          bg_y = 145;
      bg = new Gradient(
        [1, 0x777777], 'linear', [0xaaaaaa, 0xaaaaaa],
        [0.75,0.75], [0,145], 280, bg_height,
        (3 * Math.PI) / 2, [280,bg_height], 'rectangle'
      );
      bg.x = 10;
      bg.y = 10; //bg_y;
      addChild(bg);
    }

    /* Create Label with text and place
     *
     * ==== Parameters:
     * txt::   String
     */
    private function addLabel(txt, i, arr) {
      var lbl = new Label(14, 0x222222, "Arial", "LEFT");
      lbl.text = txt
      lbl.width = 250;
      lbl.multiline = true;
      lbl.wordWrap = true;
      lbl.x = 25;
      lbl.y = (24*i)+10;
      labels.push(lbl);
      bg.addChild(lbl);
    }

    /* Parse needed attributes from object and display them
     *
     * ==== Parameters:
     * obj::  GamePiece
     */
    private function parse_object_info(obj) {
      add_empire_symbol(obj.empire()[1]);
      add_bg(true);
      var arr = build_array_for(obj);
      arr.forEach(addLabel);
    }

    /* Creates an array to display attributes specifically for that piece
     *
     * ==== Parameters:
     * object::  GamePiece
     *
     * ==== Returns:
     * Array
     */
    private function build_array_for(object) {
      var arr = object.obj_is('city') ?
        [object.empire()[1] + " " + object.obj_is(), "Population: " + object.population(), "Income: " + object.collectTaxes(), "General: None", "Total Men: " + object.totalMen()] :
          object.obj_is('army') ? [object.empire()[1] + " " + object.obj_is(), "General: None", "Total Men: " + object.totalMen()] :
            [object.empire()[1] + " " + object.obj_is()];

      return arr;
    }

    /* Add Empire symbol as background
     *
     * ==== Parameters:
     * empire::  String
     */
    private function add_empire_symbol(empire) {
      var empSymbol = new ImgLoader('empireSymbols/' + empire.toLowerCase() + '.png');
      empSymbol.visible = false;
      setTimeout(function() { 
        empSymbol.x = 10;
        empSymbol.y = 200-(empSymbol.bmHeight+30);
        empSymbol.visible = true;
      }, 100);
      //empSymbol.alpha = 0.75; TODO: if adding actual image here set opacity
      addChild(empSymbol);
    }
  }
}