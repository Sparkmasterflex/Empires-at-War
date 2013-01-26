package game_setup {
  import static_return.GameConstants;

  public class StartsWith {

    public function StartsWith() {
	  // empty constructor
	}
	
	public static function userStarts(difficulty):Object {
	  var userStarts:Object = new Object();
	  switch(difficulty) {
		case GameConstants.EASYGAME:
		  userStarts.ARMY = 3;
		  userStarts.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 10, 7],[2, 2, 3, 8, 10],[2, 2, 3, 4, 5, 8, 8, 10, 7]];
		  userStarts.CITY = 1;
		  userStarts.SETTLER = 2;
		  userStarts.AGENT = ['spy_scout','diplomat'];
		  break;
		case GameConstants.MEDGAME:
		  userStarts.ARMY = 2;
		  userStarts.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 7],[2, 2, 3, 8, 10]];
		  userStarts.CITY = 0;
		  userStarts.SETTLER = 1;
		  userStarts.AGENT = ['diplomat'];
		  break;
		case GameConstants.HARDGAME:
		  userStarts.ARMY = 1;
		  userStarts.armyUnits = [[2, 2, 3, 4, 8, 8, 7]];
		  userStarts.CITY = 0;
		  userStarts.SETTLER = 1;
		  userStarts.AGENT = [];
		  break;
	  }
	  return userStarts;
	}
	
	public static function enemiesStarts(difficulty):Object {
      var enemiesStart:Object = new Object();
	  switch(difficulty) {
		case GameConstants.EASYGAME:
		  enemiesStart.ARMY = 1;
		  enemiesStart.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 10, 7]];
		  enemiesStart.CITY = 0;
		  enemiesStart.SETTLER = 2;
		  enemiesStart.AGENT = ['diplomat'];
		  break;
		case GameConstants.MEDGAME:
		  enemiesStart.ARMY = 2;
		  enemiesStart.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 10, 7],[2, 2, 3, 8, 10]];
		  enemiesStart.CITY = 0;
		  enemiesStart.SETTLER = 1;
		  enemiesStart.AGENT = ['diplomat'];
		  break;
		case GameConstants.HARDGAME:
		  enemiesStart.ARMY = 2;
		  enemiesStart.armyUnits = [[2, 2, 3, 4, 5, 8, 8, 10, 7],[2, 2, 3, 8, 10]];
		  enemiesStart.CITY = 1;
		  enemiesStart.SETTLER = 2;
		  enemiesStart.AGENT = ['spy_scout','diplomat'];
		  break;
	  }
	  return enemiesStart;
	}
  }
}