package stageElements {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class stageOcean extends MovieClip {
		private var ocean:Sprite;
		
		public function stageOcean() {
			ocean = new Sprite();
			ocean.graphics.beginFill(0x1C6BA0);
			ocean.graphics.drawRect(0, 0, 4000, 3000);
			ocean.graphics.endFill();
			addChild(ocean);
		}
		
	}
}