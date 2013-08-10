package empires {
  import flash.display.Sprite;
  import flash.external.ExternalInterface;
  import flash.utils.setTimeout;
  
  import common.Label;
  
  import game_setup.StartsWith;
  
  import pieces.*;
  import pieces.agents.Settler;
  
  import stage.GameStage;
  
  import static_return.CalculateStartPositions;
  import static_return.GameConstants;
  import static_return.CityConstants;
  
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
    public var destroying:Array;
    public var selected_piece:GamePiece;
  	
  	/*-- Numbers --*/
    private var difficulty:int;
  	
  	public function Empire(emp, game, stge, parent) {
      super();
      gStage = stge;
  	  eAtW = parent;
  	  attr = new Object();
  	  attr['id'] = emp.id;
      attr['money'] = emp.treasury;
      attr['playable'] = false;
      playable(emp.user_id);
  	  empire(emp.clan);
      destroying = new Array();
  	  
      pieceArray = new Array();
  	  armyArray = new Array()
  	  cityArray = new Array()
  	  agentArray = new Array()
  	  difficulty = game.difficulty;
      
      if(game.status == GameConstants.NEW_GAME) {
        createGamePieces(emp, stge);
      } else {
        if(GameConstants.ENVIRONMENT == 'flash') {
          var piece_arr = emp.id == 1 ?
            [
              //{"primary": true, "agents":null,"building_queue":null,"buildings":null,"built_id":null,"created_at":"2013-07-27T21:27:37Z","empire_id":1,"general":null,"id":6,"moves":5,"name":"army_2_40","pieceType":20,"population":null,"square":"0_15_19","units":"2,200||2,200||3,200||4,100||5,100||8,200||8,200||10,200||","units_queue":null,"updated_at":"2013-07-27T21:27:37Z"}
              {"primary": true, "agents":null,"building_queue":null,"buildings":"1,60,0||","built_id":1,"created_at":"2013-07-27T21:27:37Z","empire_id":1,"general":null,"id":6,"moves":5,"name":"city_2_40","pieceType":30,"population":10000,"square":"0_15_19","units":"2,200||2,200||3,200||","units_queue":null,"updated_at":"2013-07-27T21:27:37Z"} //4,100||5,100||8,200||8,200||10,200||
              /*{"agents":"","building_queue":null,"buildings":"1,60,0||","built_id":1,"created_at":"2013-07-27T21:27:37Z","empire_id":1,"general":null,"id":1,"moves":null,"name":"city_0_40","pieceType":30,"population":10000,"square":"0_28_16","units":"","units_queue":null,"updated_at":"2013-07-27T21:27:37Z"},
              {"agents":"settler||","building_queue":null,"buildings":null,"built_id":1,"created_at":"2013-07-27T21:27:37Z","empire_id":1,"general":null,"id":2,"moves":null,"name":"agent_0_40","pieceType":10,"population":null,"square":"0_28_17","units":null,"units_queue":null,"updated_at":"2013-07-27T21:27:37Z"},
              {"agents":"settler||","building_queue":null,"buildings":null,"built_id":1,"created_at":"2013-07-27T21:27:37Z","empire_id":1,"general":null,"id":3,"moves":null,"name":"agent_1_40","pieceType":10,"population":null,"square":"0_29_13","units":null,"units_queue":null,"updated_at":"2013-07-27T21:27:37Z"},
              {"agents":null,"building_queue":null,"buildings":null,"built_id":null,"created_at":"2013-07-27T21:27:37Z","empire_id":1,"general":null,"id":4,"moves":5,"name":"army_0_40","pieceType":20,"population":null,"square":"0_28_14","units":"2,200||2,200||3,200||4,100||5,100||8,200||8,200||10,200||","units_queue":null,"updated_at":"2013-07-27T21:27:37Z"},
              {"agents":null,"building_queue":null,"buildings":null,"built_id":null,"created_at":"2013-07-27T21:27:37Z","empire_id":1,"general":null,"id":5,"moves":5,"name":"army_1_40","pieceType":20,"population":null,"square":"0_27_17","units":"2,200||2,200||3,200||8,200||7,1||","units_queue":null,"updated_at":"2013-07-27T21:27:37Z"},
              {"agents":null,"building_queue":null,"buildings":null,"built_id":null,"created_at":"2013-07-27T21:27:37Z","empire_id":1,"general":null,"id":6,"moves":5,"name":"army_2_40","pieceType":20,"population":null,"square":"0_25_16","units":"2,200||2,200||3,200||4,100||5,100||8,200||8,200||10,200||","units_queue":null,"updated_at":"2013-07-27T21:27:37Z"}*/
            ] :
            [
              {"agents":null,"building_queue":null,"buildings":null,"built_id":null,"created_at":"2013-07-27T21:27:39Z","empire_id":2,"general":null,"id":8,"moves":5,"name":"army_0_20","pieceType":20,"population":null,"square":"0_15_18","units":"2,200||2,200||3,200||4,100||10,200||5,100||8,200||8,200||","units_queue":null,"updated_at":"2013-07-27T21:27:39Z"}
              /*{"agents":"","building_queue":null,"buildings":"1,60,0||","built_id":2,"created_at":"2013-07-27T21:27:39Z","empire_id":2,"general":null,"id":7,"moves":null,"name":"city_0_20","pieceType":30,"population":10000,"square":"0_9_10","units":"","units_queue":null,"updated_at":"2013-07-27T21:27:39Z"},
              {"agents":null,"building_queue":null,"buildings":null,"built_id":null,"created_at":"2013-07-27T21:27:39Z","empire_id":2,"general":null,"id":8,"moves":5,"name":"army_0_20","pieceType":20,"population":null,"square":"0_7_12","units":"2,200||2,200||3,200||4,100||5,100||8,200||8,200||10,200||","units_queue":null,"updated_at":"2013-07-27T21:27:39Z"},
              {"agents":null,"building_queue":null,"buildings":null,"built_id":null,"created_at":"2013-07-27T21:27:39Z","empire_id":2,"general":null,"id":9,"moves":5,"name":"army_1_20","pieceType":20,"population":null,"square":"0_9_12","units":"2,200||2,200||3,200||8,200||7,1||","units_queue":null,"updated_at":"2013-07-27T21:27:39Z"},
              {"agents":null,"building_queue":null,"buildings":null,"built_id":null,"created_at":"2013-07-27T21:27:39Z","empire_id":2,"general":null,"id":10,"moves":5,"name":"army_2_20","pieceType":20,"population":null,"square":"0_10_10","units":"2,200||2,200||3,200||4,100||5,100||8,200||8,200||10,200||","units_queue":null,"updated_at":"2013-07-27T21:27:39Z"},
              {"agents":"settler||","building_queue":null,"buildings":null,"built_id":2,"created_at":"2013-07-27T21:27:39Z","empire_id":2,"general":null,"id":11,"moves":null,"name":"agent_0_20","pieceType":10,"population":null,"square":"0_8_10","units":null,"units_queue":null,"updated_at":"2013-07-27T21:27:39Z"},
              {"agents":"settler||","building_queue":null,"buildings":null,"built_id":2,"created_at":"2013-07-27T21:27:39Z","empire_id":2,"general":null,"id":12,"moves":null,"name":"agent_1_20","pieceType":10,"population":null,"square":"0_10_9","units":null,"units_queue":null,"updated_at":"2013-07-27T21:27:39Z"}*/
            ];
          returnPieces(piece_arr);
        } else {
          ExternalInterface.addCallback('returnPieces', returnPieces);
          ExternalInterface.call('get_empire_pieces', emp.id);
        }
      }
    }

    /* Determines if this Empire is the player controlled empire
     *
     * ==== Parameters:
     * user_id::  Integer
     *
     * ==== Returns:
     * Boolean
     */
    public function playable(user_id=null) {
      if(user_id && user_id != "") attr['playable'] = true;
      return attr['playable'];
    }
  	  
    private function createGamePieces(emp, stge) {
  	  var toStart = StartsWith.userStarts(difficulty),
    		  randGrid = gStage.sGridArr[0],  //[Math.round(Math.random() * gStage.sGridArr.length)],
    		  startSq = randGrid.landSquares[Math.round(Math.random() * randGrid.landSquares.length)];
      
    	posArr = CalculateStartPositions.ret(startSq);
  	  for(var j:String in toStart) {
  	    switch(j) {
    		  case 'ARMY':
            for(var army_index:int=0; army_index<toStart.ARMY; army_index++) addArmy({units: toStart.armyUnits[army_index]});
    		    break;
    		  case 'SETTLER':
            for(var settler_index:int=0; settler_index<toStart.SETTLER; settler_index++) addAgent({agents: [GameConstants.SETTLER]});
    		    break;
    		  case 'CITY':
    		    for(var city_index:int=0; city_index<toStart.CITY; city_index++) addCity({population: CityConstants.START, square: startSq, buildings: [[1,CityConstants.GOVERNMENT, 0]]});
    		    break;
    		}
  	  }
  	}
  
    public function piece_by_name(str) {
      var p;
      pieceArray.forEach(function(piece) {
        if(piece.named() == str) p = piece;
      });
      return p
    }
    
    public function returnPieces(json) {
      var parsed_pieces = GameConstants.ENVIRONMENT == 'flash' ? json : JSON.parse(json);
      parsed_pieces.forEach(function(p) {
        switch(p.pieceType) {
          case 10:
            addAgent(p);
            break;
          case 20:
            addArmy(p);
            break;
          case 30:
            addCity(p);
            break;
          default:
            break;
        }
      });

    }
	
    /* Creates and adds City to stage
     *
     * ==== Parameters:
     * attrs::Object
     *
     */
    public function addCity(attrs) {
      var city:City;
      if(attrs.square is String) attrs.square = gStage.find_sq(attrs.square);
      // if not from database (attrs.id) then save right away
      if(!attrs.id) attrs.instant_save = true
      if(difficulty == GameConstants.EASYGAME && cityArray.length == 0) attrs.primary = true // for moving window to city
      city = new City(this, cityArray.length, attrs);
      gStage.addChild(city);
    }
  	
    /* Creates and adds Army to stage
     *
     * ==== Parameters:
     * attrs::Object
     *
     */
    public function addArmy(attrs) {
      var army:Army;
      attrs.square = !attrs.square ? getLandSquare() : gStage.find_sq(attrs.square);
      // if not from database (attrs.id) then save right away
      if(!attrs.id) attrs.instant_save = true
      if(difficulty != GameConstants.EASYGAME && armyArray.length == 0) attrs.primary = true // for moving window to city
      army = new Army(this, armyArray.length, attrs);
      gStage.addChild(army);
    }

    /* Creates and adds Agent to stage
     *
     * ==== Parameters:
     * attrs::Object
     *
     */
    public function addAgent(attrs) {
      var agent:Agent;
      attrs.square = !attrs.square ? getLandSquare() : gStage.find_sq(attrs.square);
      // if not from database (attrs.id) then save right away
      if(!attrs.id) attrs.instant_save = true
      agent = new Agent(this, agentArray.length, attrs);
      gStage.addChild(agent);
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

    public function named() {
      return attr['named'];
    }
  	
  	public function empire(e=null) {
  	  if(e) {
        attr['empire'] = e;
        attr['named'] = GameConstants.parseEmpireName(e);
      }
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
        piece.saveAttributes()
      });
      calculateMoneyEarned();
      ExternalInterface.call('saveEmpire', createJSON());
  	}

    private function createJSON() {
      return {
        id: attr['id'],
        treasury: treasury(),
        armies_count: armyArray.length,
        cities_count: cityArray.length,
        agents_count: agentArray.length,
        destroying: destroying
      }

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