package common {
  import flash.display.Sprite;
  import flash.geom.Matrix;
  import flash.display.GradientType;
  import flash.display.SpreadMethod;
	
  public class Gradient extends Sprite {

    public function Gradient(lineStyle:Array, type:String, colors:Array, alphas:Array, ratios:Array, grWidth:Number, grHeight:Number, angle, shapeDim:Array, shapeType:String) {
	  super();
	  var matr:Matrix = new Matrix(),
		  sprMethod:String = SpreadMethod.PAD;
	  if(lineStyle[0] != 'none') graphics.lineStyle(lineStyle[0], lineStyle[1]);
	  switch(type) {
		case('solid'):
		  graphics.beginFill(colors[0]);
		  break;
		case('linear'):
		  var fType:String = GradientType.LINEAR;
		  matr.createGradientBox(grWidth, grHeight, angle, 0, 0);
		  graphics.beginGradientFill(fType, colors, alphas, ratios, matr, sprMethod);
	  }
	  switch(shapeType) {
		case 'rectangle':
		  graphics.drawRect(0, 0, shapeDim[0], shapeDim[1]);
		  break;
		case 'roundRect':
		  graphics.drawRoundRect(0, 0, shapeDim[0], shapeDim[1], shapeDim[2], shapeDim[3]);
		  break; 
		case 'circle':
		  graphics.drawCircle(0, 0, shapeDim[0]);
		  break;
		  //case 'triangle':
		  //		  b.drawTriangle(shapeDim);
		  //		  break; 
	  }
	  graphics.endFill();
    }
  }
}