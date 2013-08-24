package game_setup {
  import flash.display.MovieClip;
  import common.ImgLoader;
  import common.Label;
  
  public class PreloaderSlide extends MovieClip {
  	private static const EMPIRE = 10;
  	private static const UNIT   = 20;

    public function PreloaderSlide(slide, type) {
      super();
      type == EMPIRE ? get_empire(slide) : get_unit(slide);
      //this.width = 500;
      //this.height = 500;
    }

    /* Based on empire passed creates slide
     *
     * ==== Parameters:
     * emp:: String
     *
     * ==== Returns:
     * returns
     */
    private function get_empire(emp) {
    	var img = new ImgLoader('empireSymbols/'+emp+'.png');
    	img.x = 30;
    	img.y = 200;
    	addChild(img);

      switch(emp) {
      	case 'gaul':
      		var txt = "Gaul was a region of Western Europe during the Iron Age and Roman era, encompassing present day France, Luxembourg and Belgium, most of Switzerland, Northern Italy, as well as the parts of the Netherlands and Germany on the west bank of the Rhine. According to the testimony of Julius Caesar, Gaul was divided into three parts, inhabited by the Gauls, the Belgae and the Aquitani, and the Gauls of Gaul proper were speakers of the Gaulish (Celtic) language distinct from the Aquitanian language and the Belgic language. Archaeologically, the Gauls were bearers of the La Tène culture, which extended across all of Gaul, as well as east to Rhaetia, Noricum, Pannonia and southwestern Germania."
      		break;
      	case 'rome':
      		txt = "Gaul was a region of Western Europe during the Iron Age and Roman era, encompassing present day France, Luxembourg and Belgium, most of Switzerland, Northern Italy, as well as the parts of the Netherlands and Germany on the west bank of the Rhine. According to the testimony of Julius Caesar, Gaul was divided into three parts, inhabited by the Gauls, the Belgae and the Aquitani, and the Gauls of Gaul proper were speakers of the Gaulish (Celtic) language distinct from the Aquitanian language and the Belgic language. Archaeologically, the Gauls were bearers of the La Tène culture, which extended across all of Gaul, as well as east to Rhaetia, Noricum, Pannonia and southwestern Germania."
      		break;
      };
      var lbl = new Label(16, 0xf0ab32, "Arial", "LEFT");
      lbl.text = txt;
      lbl.x = 400;
      lbl.y = 30;
      lbl.wordWrap = true;
      lbl.multiline = true;
      lbl.width = 250;
      lbl.height = 400;
      addChild(lbl);
    }

    /* TODO
     *
     * ==== Parameters:
     * unit
     *
     * ==== Returns:
     * returns
     */
    private function get_unit(unit) {
      // code goes here
    }
  }
}