package gameSetup {
	
	public class armyLeaders
	{
		/*-- Classes Added --*/
		/*-- Arrays --*/		
		public static var captains:Array = new Array(
																								 'Bob villa', 'Frank Sinatra', 'Joe Mama', 'Frank Lloyd Wrong',
																								 'Bob Saget', 'William Schattner','John Adams', 'Bob Dylan', 'Walter Mathews',
																								 'Chris Cornel', 'Dr. Zoidberg', 'Attila the Cat', 'Antonio Bendarous');
		public static var generals:Array = new Array('Alexander', 'Ghengis Khan', 'Caeser', 'Napolean');
		/*-- Numbers --*/
		public static var num:Number;
		/*-- MovieClips and Strings --*/
		public static var leader:String;
		/*-- Boolean --*/
		
		public function armyLeaders():void
		{
			// empty construtor
		}
		
		public static function ret(type:String):String {
			if(type == 'general') {
				num = Math.round(Math.random() * (generals.length -1));
				leader = generals[num];
			} else {
				num = Math.round(Math.random() * (captains.length - 1));
				leader = captains[num];
				captains.splice(num, 1);
			}
			return leader;
		}
	}
}