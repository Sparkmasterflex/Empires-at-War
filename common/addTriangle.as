package common {
	import flash.display.Shape;
	
	public class addTriangle extends Shape
	{
		
		public function addTriangle(line, color, triHeight, angle):void
		{
			graphics.lineStyle(2, line);
			graphics.beginFill(color);
			graphics.moveTo(triHeight/2, triHeight/2);
			graphics.lineTo(0, 0);
			graphics.lineTo(0, triHeight);
			graphics.lineTo(triHeight/2, triHeight/2);
			rotation = angle;
			//trace(angle);
		}
	}
}