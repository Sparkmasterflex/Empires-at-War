package {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.display.MovieClip;
	
	public class optionResults extends MovieClip
	{
		public var rLabel:TextField;
		public var empSelection:TextField = new TextField();
		public var empSTF:TextFormat = new TextFormat();
		public var otherOptions:TextField;
		private var labelTF:TextFormat = new TextFormat();
		private var oOptTF:TextFormat = new TextFormat();
		
		private var labelArr:Array = new Array("Empire:", "Difficulty:", "Enemies:");
		public var otherArr:Array = new Array();
		
		public function optionResults() {
			empSTF.size = 20;
			empSTF.font = "Arial Black";
			empSTF.color = 0x222222;
			empSTF.letterSpacing = 5;
			empSelection.defaultTextFormat = empSTF;
			empSelection.autoSize = TextFieldAutoSize.LEFT;
			labelTF.color = 0x222222;
			labelTF.font = "Papyrus";
			labelTF.size = 14;
			labelTF.align = TextFormatAlign.RIGHT;
			oOptTF.color = 0x111111;
			oOptTF.size = 16;
			oOptTF.font = "Arial";
			empSelection.x = 765;
			empSelection.y = 620;
			addChild(empSelection);
			for(var i:uint = 0; i < 3; i++)
			{
				rLabel = new TextField();
				otherOptions = new TextField();
				rLabel.defaultTextFormat = labelTF;
				otherOptions.defaultTextFormat = oOptTF;
				rLabel.text = labelArr[i];
				//otherOptions.text = labelArr[i];
				rLabel.x = 655;
				otherOptions.x = 765;
				rLabel.y = 620 + (35 * i);
				otherOptions.y = 660 + (35 * i);
				addChild(rLabel);
				addChild(otherOptions);
				otherArr.push(otherOptions);
			}
			removeLast();
		}
		
		private function removeLast():void
		{
			removeChild(otherArr[2]);
		}
		
		public function showSelectedEmp(select):void
		{
			empSelection.text = select;
		}
	}
}