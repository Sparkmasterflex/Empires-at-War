package control_panel.ui {
  import common.Gradient;
  import common.ImgLoader;
  import common.Label;
  
  import flash.display.MovieClip;
	
  public class DisplayThumb extends MovieClip {
	/*-- Classes Added --*/
	private var img:ImgLoader;
	private var menLbl:Label;
	public var highlight:Gradient;
	
	/*-- Numbers --*/
	/*-- MovieClips and Strings --*/
	public var UnitType;
	public var callKey:String;
	
	/*-- Boolean --*/
	public var selected:Boolean = false;
	
	public function DisplayThumb(image, obj, men=null) {
	  super();
	  var box = new Gradient(
		  [1, 0x333333], 'linear', [0x444444, 0x999999],
		  [1,1], [0,145], 75, 75,
		  (3 * Math.PI) / 2, [75,75,15,15], 'rectangle'
	  ),
		  img_path = obj['empire'].toLowerCase() + '/' + obj['pieceType'] + image;
	  img = new ImgLoader(img_path);
	  addChild(box);
	  addChild(img);
	  if(men) addMenTF(men);
	}
	
	private function addMenTF(men) {
	  menLbl = new Label(11, 0x000000, 'Arial', 'LEFT');
	  menLbl.text = men;
	  menLbl.x = 3;
	  menLbl.y = 3;
	  addChild(menLbl);
	}
  
    public function createHighLight() {
	  //var index = callKey.indexOf('unit') >= 0 ? 3 : 2;
	  highlight = new Gradient(
		[1, 0x000000], 'linear', [0x222222, 0x444444, 0x666666],
		[1,1,1], [0,45,255], 50, 60,
	    (3 * Math.PI) / 2, [75,75], 'rectangle'
	  );
	  addChild(highlight);
	  selected = true;
	  setChildIndex(highlight, this.numChildren - 3); 
	  highlight.name = 'sprite';
    }
  
    public function removeHighlight() {
	  var hL = getChildByName('sprite');
	  if(hL) removeChild(hL);
	  selected = false;
    }
  }
}