package {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class eInfo extends TextField
	{
		public var infoFormat:TextFormat = new TextFormat();
		public var gaulText:String = "&#34;They who are engaged in battles";
			
		public function eInfo():void
		{	
			gaulText += " and dangers, either sacrifice men as victims, or vow that ";
			gaulText += "they will sacrifice them, and employ the Druids as the performers ";
			gaulText += "of those sacrifices &#34;";
			x = 80;
			y = 405;
			infoFormat.size = 12;
			infoFormat.font = "Arial";
			infoFormat.color = 0x222222;
			infoFormat.leading = 6;
			defaultTextFormat = infoFormat;
			multiline = true;
			wordWrap = true;
			width = 250;
			height = 400;
			htmlText = gaulText;
			
		}
	}
}