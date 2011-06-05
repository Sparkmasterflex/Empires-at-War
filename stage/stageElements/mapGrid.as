package stage.stageElements {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class mapGrid extends MovieClip {
		public var hidden:Sprite;
		public var mGridInfo:Object;
		
		public function mapGrid():void {
			hidden = new Sprite();
			//hidden.graphics.lineStyle(1, 0x000000, .05);
			hidden.graphics.beginFill(0xcccccc, 0);
			hidden.graphics.drawRect(0,0,100,100);
			hidden.graphics.endFill();
			addChild(hidden);
			mouseChildren = false;
		}
		
		public function addObject(quad:uint, row:uint, column:uint, posX:Number, posY:Number):void
		{
			mGridInfo = new Object();
            mGridInfo.row = row;
            mGridInfo.column = column;
            mGridInfo.section = quad;
			mGridInfo.posX = posX;
			mGridInfo.posY = posY;		
			mGridInfo.land = false;
			mGridInfo.pieces = [];
		}
		
		public function addLandToObj(land:Boolean) {
			mGridInfo.land = land;
		}
	}
}