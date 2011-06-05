package control_Panel.buttons {
	import flash.display.MovieClip;
	import common.addTriangle;
	
	public class nextPrevBtn extends MovieClip
	{
		/*-- Classes Added --*/
		private var triangle:addTriangle;
		/*-- Arrays --*/		
		/*-- Numbers --*/
		/*-- MovieClips and Strings --*/
		/*-- Boolean --*/
		
		public function nextPrevBtn(a:Number):void
		{
			triangle = new addTriangle(0xe1a619, 0xf7cb62, 20, a);
			scaleX = 1.75;
			addChild(triangle);
		}
	}
}