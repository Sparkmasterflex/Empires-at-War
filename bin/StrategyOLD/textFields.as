package {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	
	public class textFields extends TextField
	{
		public var tFormat:TextFormat = new TextFormat();
		public var tFormat2:TextFormat = new TextFormat();
		
		function textFields():void
		{
			x = 10;
			tFormat.size = 18;
			tFormat.color = 0x222222;
			tFormat.font = "Arial";
			tFormat2.size = 10;
			tFormat2.color = 0x222222;
			tFormat2.font = "Arial";
			autoSize = TextFieldAutoSize.LEFT;
			defaultTextFormat = tFormat;
			addEventListener(MouseEvent.MOUSE_OVER, rOver);
			addEventListener(MouseEvent.MOUSE_OUT, rOut);
			addEventListener(MouseEvent.CLICK, displayDetails);
			selectable = false;
		}
		function rOver(event:MouseEvent):void
		{
			event.target.textColor = 0x990000;
		}
		
		function rOut(event:MouseEvent):void
		{
			event.target.textColor = 0x222222;
		}
		
		public function displayDetails(event:MouseEvent):void
		{
			var eSelected = event.target;
			//this.parent.showDetails();
			(this.parent as MovieClip).showDetails(eSelected);
		}
	}
}