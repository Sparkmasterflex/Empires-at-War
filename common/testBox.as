package common {
	import flash.display.MovieClip;
	import common.gradient;
	
	public class testBox extends MovieClip
	{
		/*-- Classes Added --*/
		private var box:gradient;
		/*-- Arrays --*/		
		/*-- Numbers --*/
		/*-- MovieClips and Strings --*/
		/*-- Boolean --*/
		
		public function testBox():void
		{
			box = new gradient(
												['none', 'none'],
												'solid',
												[0xff0000],
												[1,1,1],
												[0,45,255],
												100, 155,
												(3 * Math.PI) / 2,
												[100,155],
												'rectangle'
											);
			addChild(box);
		}
	}
}