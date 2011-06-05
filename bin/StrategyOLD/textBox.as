package {
	import flash.display.Sprite;
	
	public class textBox extends Sprite {
		
		function textBox():void {
			graphics.lineStyle(1,0x222222);
			graphics.beginFill(0xffffff);
			graphics.drawRoundRect(0,0,160,380,25,25);
			graphics.endFill();
			x = 10;
			y = 10;
			alpha = .85;
		}
	}
}