package gameSetup {
	
	public class startsWith {
		
		public function startsWith() {
			//empty constructor
		}
		
		public static function ret(difficulty, empire):Array {
			var userStarts:Object = new Object();
			var enemiesStart:Object = new Object();
			switch(difficulty) {
				case 10:
					userStarts.ARMY = 3;
					userStarts.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 10, 7],[2, 2, 3, 8, 10],[2, 2, 3, 4, 5, 8, 8, 10, 7]];
					userStarts.CITY = 1;
					userStarts.SETTLER = 2;
					userStarts.AGENT = ['spy_scout','diplomat'];
					
					enemiesStart.ARMY = 1;
					enemiesStart.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 10, 7]];
					enemiesStart.CITY = 0;
					enemiesStart.SETTLER = 2;
					enemiesStart.AGENT = ['diplomat'];
					break;
				case 20:
					userStarts.ARMY = 2;
					userStarts.armyUnit = [[2, 2, 3, 4, 5, 8, 8, 10, 7],[2, 2, 3, 8, 10]];
					userStarts.CITY = 0;
					userStarts.SETTLER = 1;
					userStarts.AGENT = ['diplomat'];
					
					enemiesStart.ARMY = 2;
					enemiesStart.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 10, 7],[2, 2, 3, 8, 10]];
					enemiesStart.CITY = 0;
					enemiesStart.SETTLER = 1;
					enemiesStart.AGENT = ['diplomat'];
					break;
				case 30:
					userStarts.ARMY = 1;
					userStarts.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 10, 7]];
					userStarts.CITY = 0;
					userStarts.SETTLER = 1;
					userStarts.AGENT = [];
					
					enemiesStart.ARMY = 2;
					enemiesStart.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 10, 7],[2, 2, 3, 8, 10]];
					enemiesStart.CITY = 1;
					enemiesStart.SETTLER = 2;
					enemiesStart.AGENT = ['spy_scout','diplomat'];
					break;
			}
			var array:Array = new Array(userStarts, enemiesStart);
			return(array);
		}
	}
}
