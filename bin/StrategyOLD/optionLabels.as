package {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.filters.DropShadowFilter;
	import flash.events.MouseEvent;
	
	public class optionLabels extends TextField {
		public var btnFormat:TextFormat = new TextFormat();
		public var iDs:DropShadowFilter = new DropShadowFilter();
		public var iDsArr:Array = new Array(iDs);
		public var ds:DropShadowFilter = new DropShadowFilter();
		public var dsArr:Array = new Array(ds);
		
		
		public function optionLabels():void {
			btnFormat.size = 18;
			btnFormat.font = "Futura Hv";
			btnFormat.letterSpacing = 3;
			btnFormat.color = 0xffffff;
			autoSize = TextFieldAutoSize.LEFT;
			defaultTextFormat = btnFormat;
			iDs.color = 0x000000;
			iDs.blurX = 1;
			iDs.blurY = 1;
			iDs.angle = 30;
			iDs.alpha = 0.3;
			iDs.inner = true;
			iDs.distance = 1;
			filters = iDsArr;
			selectable = false;
		}
	}
}