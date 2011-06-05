package gamePieces.empires.gaul
{
	import flash.display.MovieClip;
	//import gamePieces.empires.gaul.gaulArmyMC;
	
	public class gaulArmy extends MovieClip
	{
		private var army:gaulArmyMC;
		
		public function gaulArmy():void
		{
			army = new gaulArmyMC();
			addChild(army);
			//trace('got here');
		}
	}
}