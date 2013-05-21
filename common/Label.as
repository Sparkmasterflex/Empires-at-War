package common {
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.TextFieldAutoSize;
	
  public class Label extends TextField {
		public var tFormat:TextFormat = new TextFormat();
		public var tFormat2:TextFormat = new TextFormat();
		
		public function Label(s:Number, c:Number, f:String, align:String) {
		  super();
		  tFormat.size = s;
		  tFormat.color = c;
		  tFormat.font = f;
		  tFormat2.size = 10;
		  tFormat2.color = 0x222222;
		  tFormat2.font = "Arial";
		  if(align) autoSize = alignment(align);
		  defaultTextFormat = tFormat;
		  selectable = false;
		}
	  
		private static function alignment(a):String {
		  var align;
		  switch(a) {
		    case 'LEFT':
			  align = TextFieldAutoSize.LEFT;
			  break;
			case 'RIGHT':
			  align = TextFieldAutoSize.RIGHT;
			  break;
			case 'CENTER':
			  align = TextFieldAutoSize.CENTER;
			  break;
		  }
		  return align;
		}
  }
}