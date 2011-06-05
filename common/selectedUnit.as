package common {
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	import flash.display.Graphics;
		
	public class selectedUnit extends Sprite {
		public var selType:String;
		public var selColors:Array;
		public var selAlphas:Array;
		public var selRatios:Array;
		public var selGrWidth:Number;
		public var selGrHeight:Number;
		public var angle;
		public var selDimensions:Array;
		public var shapeType:String;
		
		public function selectedUnit(radius) {
			selType = GradientType.RADIAL;
			//selLineStyle = new Array(1, 0x660000);
			selColors = new Array(0x660000, 0x990000, 0xff0000);
			selAlphas = new Array(1, .75, .5);
			selRatios = new Array(0, 120, 255);
			var matr:Matrix = new Matrix();
				matr.createGradientBox(40, 40, 0, -20, -20);
			var sprMethod:String = SpreadMethod.PAD;
			var b:Graphics = this.graphics;
			b.lineStyle(1, 0x660000);
			b.beginGradientFill(selType, selColors, selAlphas, selRatios, matr, sprMethod);
			b.drawCircle(0, 0, radius);
			b.endFill();
			x = -5;
			y = -20;
			animateSelect();
		}
		
		public function animateSelect() {
			TweenLite.to(this, .5, {scaleX:1.5, scaleY:1.5, onComplete:shrink});
		}
		
		public function shrink() {
			TweenLite.to(this, .5, {scaleX:1, scaleY:1, onComplete:animateSelect});
		}
	}
}

