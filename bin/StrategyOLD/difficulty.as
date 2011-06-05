package {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.controls.RadioButton;
	
	public class difficulty extends MovieClip
	{
		public var diffLabel:optionLabels = new optionLabels();
		private var inputTF:TextFormat = new TextFormat();
		public var diffRadio:RadioButton;
		public var diffArr:Array;
		private var dLabelArr:Array = new Array("Peasant", "Warlord", "Emperor");
		
		public function difficulty():void
		{
			inputTF.font = "Arial";
			inputTF.size = 15;
			inputTF.color = 0x222222;
			diffLabel.text = "Difficulty:"
			addChild(diffLabel);
			diffArr = new Array();
			for(var i:uint = 0; i < 3; i++) {
				diffRadio = new RadioButton();
				diffRadio.setStyle("textFormat", inputTF);
				diffRadio.label = dLabelArr[i];
				diffRadio.x = 15 + (diffRadio.width * i);
				diffRadio.y = 30
				addChild(diffRadio);
				diffArr.push(diffRadio);
				diffArr[0].selected = true;
			}
		}
	}
}

