package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import optionLabels;
	
	public class lgButtons extends MovieClip
	{
		private var btnBG:Sprite = new Sprite();
		private var rollBG:Sprite = new Sprite();
		public var bLabel:optionLabels = new optionLabels();
		private var mouseOn:Boolean = false;
		//private var rollColor:ColorTransform = btnBG.transform.colorTransform;
		private var fType:String = GradientType.LINEAR;
		private var colors:Array = [ 0xf5c655, 0xf0b62a];  // 
		private var alphas:Array = [ 1, 1 ];
		private var ratios:Array = [ 30, 255 ];
		private var matr:Matrix = new Matrix();
		private var sprMethod:String = SpreadMethod.PAD;
		private var btn:Graphics 
		
		public function lgButtons(btnLabel):void
		{
			//rollColor.color = 0xcccccc;
			bLabel.text = btnLabel;
			bLabel.x = 23;
			bLabel.y = 5;
			makeBG();
			rollBox();
			rollBG.x = 2;
			rollBG.y = 2;
			addChild(btnBG);
			addChild(rollBG);
			addChild(bLabel);
			rollBG.visible = false;
			addEventListener(MouseEvent.MOUSE_OVER, btnRoll);
			addEventListener(MouseEvent.MOUSE_OUT, btnRoll);
		}
		
		private function makeBG():void
		{
			btn = btnBG.graphics;
			matr.createGradientBox( 20, 260, (3*Math.PI/2), 0, 0 );
			btn.lineStyle(3,0xe2a719);
			btn.beginGradientFill( fType, colors, alphas, ratios, matr, sprMethod );
			btn.drawRoundRect( 0, 0, 100, 40, 10, 10  );
		}
		
		private function rollBox():void
		{
			rollBG = new Sprite();
			rollBG.graphics.beginFill(0x222222);
			rollBG.graphics.drawRoundRect(0, 0, 96, 36, 10, 10);
			rollBG.graphics.endFill();
			//addChild(rollBG);
			//setChildIndex(rollBG, 1);
		}
		
		public function btnRoll(event:MouseEvent):void
		{
			if(mouseOn == false) {
				//rollBox();
				rollBG.visible = true;
				mouseOn = true;
			} else {
				//removeChild(rollBG);
				rollBG.visible = false;
				mouseOn = false;
			}
		}
	}
}