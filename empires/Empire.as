package empires {
  import flash.display.Sprite;
  import flash.external.ExternalInterface;
  import flash.utils.setTimeout;
  
  import common.Label;
  
  import game_setup.StartsWith;
  
  import pieces.Agent;
  import pieces.Army;
  import pieces.City;
  import pieces.Building;
  import pieces.Unit;
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
  	
  	/*-- Numbers --*/
  	private var difficulty:int;
  	
  	public function Empire(emp, game, stge, parent) {
      ExternalInterface.addCallback('set_id', set_id);
  	  gStage = stge;
  	  eAtW = parent;
  	  attr = new Object();
  	  attr['id'] = emp.id;
      attr['money'] = emp.treasury;
  	  empire(emp.empire);
  	  
      pieceArray = new Array();
  	  armyArray = new Array()
  	  cityArray = new Array()
  	  agentArray = new Array()
  	  difficulty = game.difficulty;
      
      if(game.status == GameConstants.NEW_GAME) {
        createGamePieces(emp, stge);
      } else {
        ExternalInterface.addCallback('returnPieces', returnPieces);
        rebuildGamePieces(emp, stge);
      }
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
    		    for(var city_index:int=0; city_index<toStart.CITY; city_index++) addCity({square: startSq});
    		    break;
    		}
  	  }
  	}
  
    private function rebuildGamePieces(emp, stge) {
      ExternalInterface.call('get_empire_pieces', emp.id);
    }

    private function set_id(attrs) {
      var found_piece = piece_by_square(attrs.square);
      found_piece.this_id(attrs.id);
    }

    public function piece_by_square(str) {
      var p = null;
      pieceArray.forEach(function(piece) {
        if(piece.square().name == str) p = piece;
      });
      return p
    }
    
    public function returnPieces(pieces) {
      for(var j:String in pieces) {
        switch(pieces[j]['pieceType']) {
          case 10:
            addAgent(pieces[j]);
            break;
          case 20:
            addArmy(pieces[j]);
            break;
          case 30:
            addCity(pieces[j]);
            break;
        }
      }
    }
	
    /* Creates and adds City to stage
     *
     * ==== Parameters:
     * piece::Object
     *
     */
    public function addCity(piece) {
      var sq, units, agents, buildings, population, city:City;

      // if piece.square doesn't exist 
      //   then is new and not from DB
      if(piece.id) {
        var section = gStage.getChildByName('section_' + piece.square.split('_')[0]);
        sq = section.getChildByName(piece.square);
        units = parseUnitsString(piece.units);
        population = piece.population;
      } else {
        sq = piece.square
        population = CityConstants.START;
      }
      
      city = new City(this, population, cityArray.length, piece.id);
      if(units) city.units(units);
      if(piece.buildings) parseBuildingsString(piece.buildings, city).forEach(function(bld) { city.buildings(bld); });
      
      //city.addUnits(units);
      gStage.addChild(city);
      city.this_stage = gStage;
      city.square(sq);
    }
  	
    /* Creates and adds Army to stage
     *
     * ==== Parameters:
     * piece::Object
     *
     */
    public function addArmy(piece) {
      var sq, unit_arr, army:Army;

      // if piece.id doesn't exist 
      //   then is new and not from DB
      if(piece.id) {
        var section = gStage.getChildByName('section_' + piece.square.split('_')[0]);
        sq = section.getChildByName(piece.square);
        unit_arr = parseUnitsString(piece.units);
      } else {
        sq = getLandSquare()
        unit_arr = piece.units
      }
      
      army = new Army(this, armyArray.length, piece.id);
      army.units(build_units(unit_arr));
      
      gStage.addChild(army);
      army.this_stage = gStage;
      army.square(sq);
    }

    /* Creates and adds Agent to stage
     *
     * ==== Parameters:
     * piece::Object
     *
     */
    public function addAgent(piece) {
      var sq, agent_arr, agent:Agent;
      if(piece.id) {
        var section = gStage.getChildByName('section_' + piece.square.split('_')[0]);
        sq = section.getChildByName(piece.square);
        agent_arr = parseAgentsString(piece.agents)
      } else {
        sq = getLandSquare();
        agent_arr = piece.agents;
      }
      
      agent = new Agent(this, agentArray.length, piece.id);
      agent.agents(build_agents(agent_arr));
      gStage.addChild(agent);
      agent.this_stage = gStage;
      agent.square(sq);
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
    
    private function parseBuildingsString(str, c) {
      var buildings = new Array(),
          arr = str.split('||');
      arr.forEach(function(str) {
        if(str != "") {
          var bld_attrs = str.split(','),
              building = new Building({type: parseInt(bld_attrs[0]), level: parseInt(bld_attrs[1]), build_points: 0}, c);
          buildings.push(building);
        }
      });

      return buildings;
    }

    /* builds array of Units
     * 
     * ==== Parameters:
     * arr::Array
     * 
     * ==== Returns
     * Array
     */
    private function build_units(arr) {
      var units = new Array();
      arr.forEach(function(u) {
        units.push(new Unit(u, named()));
      });

      return units;
    }

    /* builds array of Agents
     * 
     * ==== Parameters:
     * arr::Array
     * 
     * ==== Returns
     * Array
     */
    private function build_agents(arr) {
      var agents = new Array();
      arr.forEach(function(a) { 
        switch(a) {
          case GameConstants.SETTLER:
          case "Settler":
            agents.push(new Settler());
            break;
        }
      });

      return agents;
    }

    /* creates array of unit data based on string from DB
     * 
     * ==== Parameters:
     * str::String
     * 
     * ==== Returns
     * Array
     */
    private function parseUnitsString(str) {
      var units = new Array(),
          arr = str.split('||');
      arr.forEach(function(str) {
        if(str != "") units.push(str.split(','));
      });

      return units;
    }

    private function parseAgentsString(str) {
      var agents = new Array(),
          agent = '',
          arr = str.split('||');
      arr.forEach(function(str) {
        if(str != "") {
          switch(str) {
            case 'settler':
              agent = GameConstants.SETTLER;
              break;
          }
          agents.push(agent);
        }
      });

      return agents;
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
      ExternalInterface.call('saveEmpire', createJSON());
  	  calculateMoneyEarned();
  	}

    private function createJSON() {
      return {
        id: attr['id'],
        treasury: treasury(),
        armies_count: armyArray.length,
        cities_count: cityArray.length,
        agents_count: agentArray.length
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