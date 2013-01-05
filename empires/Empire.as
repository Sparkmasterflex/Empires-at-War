package empires {
  import flash.display.Sprite;
  
  import game_setup.StartsWith;
  
  import pieces.Army;
  import pieces.City;
  
  import stage.GameStage;
  
  import static_return.CalculateStartPositions;
  import static_return.GameConstants;
  
  public class Empire extends Sprite {
	/*-- Classes--*/
	public var eAtW:empiresAtWar;
	public var gStage:GameStage;
	
	/*-- Arrays and Objects --*/
	public var pieceArray:Array;
	public var armyArray:Array;
	public var cityArray:Array;
	public var supportArray:Array;
	public var attr:Object;
	
	/*-- Numbers --*/
	private var difficulty:int; 
	
	public function Empire(params, stge, parent) {
	  gStage = stge;
	  eAtW = parent;
	  attr = new Object();
	  attr['money'] = 0;
	  empire(params['empire'])
	  pieceArray = new Array();
	  armyArray = new Array()
	  cityArray = new Array()
	  supportArray = new Array()
	  difficulty = params['difficulty'];
	  
	  var toStart = StartsWith.userStarts(difficulty),
		  randGrid = gStage.sGridArr[0],  //[Math.round(Math.random() * gStage.sGridArr.length)],
		  startSq = randGrid.landSquares[Math.round(Math.random() * randGrid.landSquares.length)],
		  posArr = CalculateStartPositions.ret(startSq);
	  
	  treasury(params['money']);
	  
	  for(var j:String in toStart) {
	    switch(j) {
  		  case 'ARMY':
  		    addArmy(toStart.ARMY, toStart.armyUnits, posArr);
  		    break;
  		  case 'SETTLER':
  		    //addUserSettler(userObj.SETTLER);
  		    break;
  		  case 'CITY':
  		    addCity(toStart.CITY, startSq);
  		    break;
  		}
	  }
	}
	
  	public function addCity(num, sq) {
  	  for(var i:uint = 0; i < num; i++) {
    		var city:City = new City(this, 10000, cityArray.length);
    		city.x = sq.x + 60;
    		city.y = sq.y + 60;
    		if(difficulty == GameConstants.EASYGAME && i == 0) city.attr['primary'] = true;
    		city.square(sq);
    		gStage.addChild(city);
    		pieceArray.push(city);
    		cityArray.push(city);
  	  }
  	}
  	
  	public function addArmy(num, units, posArr) {
  	  for(var i:uint = 0; i < num; i++) {
    		var army:Army = new Army(this, units[i], armyArray.length),
    			sq = getLandSquare(posArr);
    		army.x = sq.x + 60;
    		army.y = sq.y + 60;
    		if(difficulty != GameConstants.EASYGAME && i == 0) army.attr['primary'] = true;
    		army.square(sq);
    		gStage.addChild(army);
  	  }
  	}
	
  	private function getLandSquare(pos) {
  	  var rand = Math.round(Math.random() * 11),
  		    sq_name = pos[rand],
  		    section = gStage.getChildByName('section_' + sq_name.split('_')[0]),
  		    sq = section.getChildByName(sq_name);
  	  sq = (sq != null && !sq.gridInfo['army'] && sq.hasLand()) ? sq : getLandSquare(pos);
  	
  	  return sq;
  	}
  	
  	public function treasury(m=null) {
  	  if(m) {
        attr['money'] += m;
        if(eAtW.cp) eAtW.cp.moneyLabel.text = "Treasury: " + attr['money'];
      }
  	  return attr['money'];
  	}
  	
  	public function empire(e=null) {
  	  if(e) attr['empire'] = e;
  	  return attr['empire'];
  	}
  	
  	public function processTurn(cp) {
  	  pieceArray.forEach(function(piece) {
    		piece.nextTurn(eAtW.currentTurn);
    		if(piece.obj_is('city')) {
    		  piece.advanceBuilding();
    		  piece.advanceUnits();
    		}
  	  });
  	  calculateMoneyEarned();
  	}
	
  	private function calculateMoneyEarned() {
  	  var fromCities = 0;
  	  cityArray.forEach(function(city) { treasury(city.collectTaxes()); });
  	  
  	  return treasury()
  	}
  }
}