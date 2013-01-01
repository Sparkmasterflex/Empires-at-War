package control_panel.ui {
  import common.Gradient;
  import common.ImgLoader;
  import common.Label;
  
  import flash.display.MovieClip;
  
  import pieces.Unit;
	
  public class DisplayThumb extends MovieClip {
  	/*-- Classes Added --*/
  	private var img:ImgLoader;
    private var menLbl:Label;
  	public var highlight:Gradient;
  	public var overlay:Gradient;
  	public var building;
    public var responds_to;
  	
  	/*-- Numbers --*/
  	/*-- Array and Objects --*/
    public var attr:Object = new Object();
    
  	/*-- MovieClips and Strings --*/
  	public var UnitType;
  	public var callKey:String;
    public var img_string = ""
  	
  	/*-- Boolean --*/
  	public var selected:Boolean = false;
  	
  	public function DisplayThumb(item, obj) {
  	  super();
      responds_to = item;
      img_string = item.is_a("Unit") ? "/army" : "/city";
      img_string += item.thumb();
  	  var box = new Gradient(
          		  [1, 0x333333], 'linear', [0x444444, 0x999999],
          		  [1,1], [0,145], 75, 75,
          		  (3 * Math.PI) / 2, [75,75,15,15], 'rectangle'
          	  ),
  		    img_path = obj.empire()[1].toLowerCase() + img_string;
  	  img = new ImgLoader(img_path);
  	  addChild(box);
  	  addChild(img);
  	  if(obj.obj_is('army')) addMenTF(item.men());
  	}
    
    public function key(k=null) {
      if(k) attr['key'] = k;
      return attr['key'];
    }
    
    public function type(t=null) {
      if(t) attr['type'] = t;
      return attr['type'];
    }
    
    public function men(m=null) {
      if(m) attr['men'] = m;
      return attr['men'];
    }
  	
  	private function addMenTF(men) {
  	  menLbl = new Label(11, 0x000000, 'Arial', 'LEFT');
  	  menLbl.text = men;
  	  menLbl.x = 3;
  	  menLbl.y = 3;
  	  addChild(menLbl);
  	}
  
    public function createHighLight() {
  	  var index = menLbl ? 3 : 2;
  	  highlight = new Gradient(
    		[1, 0x000000], 'linear', [0x222222, 0x444444, 0x666666],
    		[1,1,1], [0,45,255], 50, 60,
    	    (3 * Math.PI) / 2, [75,75], 'rectangle'
  	  );
  	  addChild(highlight);
  	  selected = true;
  	  setChildIndex(highlight, this.numChildren - index); 
  	  highlight.name = 'sprite';
      }
    
     public function removeHighlight() {
	    var hL = getChildByName('sprite');
	    if(hL) removeChild(hL);
	    selected = false;
    }
      
    public function addOverlay(points, total) {
      overlay = new Gradient(
        ['none'], 'linear', [0x444444, 0x333333],
        [0.4,0.4], [0, 255], 50, 60,
        (3 * Math.PI) / 2, [75,75], 'rectangle'
      );
      var percent = points > 0 ? points/total : 0;
      overlay.height = 75*percent;
      overlay.y = 75 - overlay.height
      addChild(overlay);
    }
  }
}