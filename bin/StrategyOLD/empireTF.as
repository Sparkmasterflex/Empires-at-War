package {
	import flash.text.TextField; 
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class empireTF extends TextField 
	{
		public var tFormat:TextFormat = new TextFormat();
		public var smFormat:TextFormat = new TextFormat();
				
		
		public function empireTF() {
			tFormat.size = 16;
			tFormat.color = 0x222222;
			tFormat.font = "Arial";
			smFormat.size = 10;
			smFormat.color = 0x222222;
			smFormat.font = "Arial";
			y = 10;
			autoSize = TextFieldAutoSize.CENTER;
			defaultTextFormat = tFormat;
		}
		
		public function changeFont(fSize:Number) {
			//trace(fSize);
			if(fSize == 10) {
				this.defaultTextFormat = smFormat;
				//trace(defaultTextFormat.size);
			} else {
				defaultTextFormat = tFormat;
			}
		}
	}
}

