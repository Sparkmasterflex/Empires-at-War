package empires {
  import flash.display.Sprite;
  
  import game_setup.StartsWith;
  
  import pieces.Agent;
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
	public var agentArray:Array;
	public var attr:Object;
	public var posArr:Array;
	
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
	  agentArray = new Array()
	  difficulty = params['difficulty'];
	  
	  var toStart = StartsWith.userStarts(difficulty),
  		  randGrid = gStage.sGridArr[0],  //[Math.round(Math.random() * gStage.sGridArr.length)],
  		  startSq = randGrid.landSquares[Math.round(Math.random() * randGrid.landSquares.length)];
  	posArr = CalculateStartPositions.ret(startSq);
	  
	  treasury(params['money']);
	  
	  for(var j:String in toStart) {
	    switch(j) {
  		  case 'ARMY':
  		    addArmy(toStart.ARMY, toStart.armyUnits);
  		    break;
  		  case 'SETTLER':
  		    addSettler(toStart.SETTLER);
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
  	
  	public function addArmy(num, units) {
  	  for(var i:uint = 0; i < num; i++) {
    		var sq = getLandSquare(),
            army:Army = new Army(this, units[i], armyArray.length);
        army.x = sq.x + 60;
        army.y = sq.y + 60;
        army.square(sq);
        gStage.addChild(army);
        if(difficulty != GameConstants.EASYGAME && i == 0) army.attr['primary'] = true;
  	  }
  	}
    
    public function addSettler(num) {
      for(var i:int = 0; i<num; i++) {
        var sq = getLandSquare();
        if(!sq.pieces()) {
          var settler = new Agent(this, [GameConstants.SETTLER]);
          settler.x = sq.x + 60;
          settler.y = sq.y + 60;
          settler.square(sq);
          gStage.addChild(settler);
        } else {
          sq.pieces().addAgents([GameConstants.SETTLER]);
        }
      }
    }
	
  	private function getLandSquare() {
  	  var rand = Math.round(Math.random() * (posArr.length-1));
  		var sq_name = posArr[rand],
  		    section = gStage.getChildByName('section_' + sq_name.split('_')[0]),
  		    sq = section.getChildByName(sq_name);
      posArr.splice(posArr.indexOf(sq_name), 1);
  	  sq = (sq != null && !sq.pieces() && sq.hasLand()) ? sq : getLandSquare();
  	
  	  return sq;
  	}
  	
  	public function treasury(m=null) {
  	  if(m) {
        attr['money'] += m;
        if(eAtW.cp) eAtW.cp.moneyLabel.text = "Treasury: " + attr['money'];
      }
  	  return Math.ceil(attr['money']);
  	}
  	
  	public function empire(e=null) {
  	  if(e) attr['empire'] = e;
  	  return attr['empire'];
  	}
  	
  	public function processTurn(cp) {
  	  pieceArray.forEach(function(piece) {
    		piece.nextTurn(eAtW.currentTurn);
    		if(piece.obj_is('city')) {
          piece.increasePopulation();
    		  piece.advanceBuilding();
    		  piece.advanceUnits();
    		}
  	  });
  	  calculateMoneyEarned();
  	}
	
  	private function calculateMoneyEarned() {
      var fromCities = 0,
          before = treasury();
  	  cityArray.forEach(function(city) { treasury(city.collectTaxes()); });
      armyArray.forEach(function(army) { treasury(army.payArmy()); });
  	  return treasury();
  	}
  }
}