package game_setup {
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	
	public class DarkenEdges extends Shape {
	  private var fType:String = GradientType.LINEAR;
	  private var colors:Array = new Array(0x000000, 0x999999, 0xffffff, 0x999999, 0x000000);
	  private var alphas:Array = new Array(.15, .05, 0, .05, .15);
	  private var ratios:Array = new Array(10, 25, 45, 230, 245);
		
		public function DarkenEdges(angle):void {
		  var matr:Matrix = new Matrix();
		  var sprMethod:String = SpreadMethod.PAD;
		  matr.createGradientBox(1200, 800, angle, 0, 0);
		  graphics.beginGradientFill(fType, colors, alphas, ratios, matr, sprMethod);
		  graphics.drawRect(0,0,1200,800);
		  graphics.endFill();
		}
	}
}