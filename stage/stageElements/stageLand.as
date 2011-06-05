package stage.stageElements {
	import flash.display.Sprite;
	
	public class stageLand extends Sprite {
		private var testColor:Number;
		
		public function stageLand(color):void
		{
			testColor = color;
			graphics.lineStyle(1, 0x000000, .05);
			graphics.beginFill(0x009900, 1);
			graphics.drawRect(0,0,100,100);
			graphics.endFill();
		}
	}
}