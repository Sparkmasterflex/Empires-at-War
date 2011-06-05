package {
	import flash.display.MovieClip;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.*;
	
	public class textBG extends MovieClip {
		function textBG():void {
			var fType:String = GradientType.LINEAR;
			var colors:Array = [ 0x00262e, 0x424a4a, 0x13323b];
			var alphas:Array = [ 1, 1, 1 ];
			var ratios:Array = [ 30, 190, 255 ];
			var matr:Matrix = new Matrix();
				matr.createGradientBox( 20, 260, (3*Math.PI/2), 0, 0 );
			var sprMethod:String = SpreadMethod.PAD;
			
			graphics.beginGradientFill( fType, colors, alphas, ratios, matr, sprMethod );
			graphics.drawRoundRect( 0, 0, 180, 400, 25, 25 );
			y = 70;
		}
	}
}