package control_Panel {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import common.gradient;
	import common.textFields;
	
	public class unitThumbMC extends MovieClip
	{
		/*-- Classes Added --*/
		private var bg:gradient;
		private var highlight:gradient;
		private var imgLoader:Loader;
		private var imgURL:URLRequest;
		public var menTF:textFields;
		
		/*-- Arrays --*/
		public var unitXML:XMLList;
		/*-- Numbers --*/
		/*-- MovieClips and Strings --*/
		public var UnitType;
		public var callKey:String;
		
		/*-- Boolean --*/
		public var selected:Boolean = false;
		
		public function unitThumbMC(key, list:*, empire:String, men:Number = 0)	{
		  callKey = key;
  		  if(list is XMLList) unitXML = list;
  		  		    
		  createBG();
		  var imgPath = list is String ? list : list.thumbnail,
			  fullPath = 'images/' + empire + imgPath
		  imgURL = new URLRequest(fullPath);
		  imgLoader = new Loader();
		  imgLoader.load(imgURL);
		  imgLoader.x = 5;
		  imgLoader.y = 10;
		  addChild(imgLoader);
		  if(men != 0) addMenNum(men);
		}
		
		private function createBG() {
		  bg = new gradient([1, 0x666666], 'linear', [0x222222, 0x000000, 0x444444], [1,1,1],
				[0,45,255], 50, 60, (3 * Math.PI) / 2, [50,60], 'rectangle' );
		  addChild(bg);
		}
		
		public function createHighLight() {
		  var index = callKey.indexOf('unit') >= 0 ? 3 : 2;
          highlight = new gradient(
                 [1, 0x000000], 'linear', [0x666666, 0x777777, 0xaaaaaa],
                 [1,1,1], [0,45,255], 50, 60,
                 (3 * Math.PI) / 2, [50,60], 'rectangle'
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
		
		private function addMenNum(m) {
		  menTF = new textFields(10, 0xffffff, 'Arial', 'CENTER');
		  menTF.text = m.toString();
		  menTF.x = (50 - menTF.width) - 5;
		  menTF.y = 5;
		  addChild(menTF);
		}
	}
}