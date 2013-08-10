package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;
  import com.demonsters.debugger.MonsterDebugger;

  import common.ImgLoader;
  
  import dispatch.AddListenerEvent;
  
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.utils.*;
  import flash.external.ExternalInterface;
  
  import pieces.agents.Settler;
  
  import settlerBase;
  
  import static_return.CityConstants;
  import static_return.FindAndTestSquare;
  import static_return.GameConstants;

  public class City extends GamePiece {
    /*--------Classes Added------------*/
    
    /*------ Arrays and Objects -----*/
    public var builders:Array;

	
  	public function City(emp, num, attributes) {
      super(emp);
      this_empire = emp;
      empire(this_empire.empire());
      if(attributes.id != null) this_id(attributes.id);
      empire_id(emp.attr['id']);
      this_empire.cityArray.push(this);
      this_empire.pieceArray.push(this);
      addCityImage();
      setAttributes(num, attributes);
      changed(true);
    }

    private function setAttributes(num, a=null) {
      attr['pieceType'] = "city";
      attr['buildings'] = []
      named("city_" + num + "_" + empire()[0]);
      if(a.primary) primary(true);

      population(a.population);
      if(population() == 0) addBuilders();
      taxes(0.07);

      if(!a.instant_save && !a.id) {
        if(a.units) units(a.units);
        if(a.agents) agents(a.agents);
      } else {
        var building_arr = a.id ? parseBuildingsString(a.buildings) : a.buildings,
            unit_arr = (a.id && a.units) ? parseUnitsString(a.units) : a.units,
            agent_arr = (a.id && a.agents) ? parseAgentsString(a.agents) : a.agents;
        if(building_arr) buildings(build_buildings(building_arr));
        if(unit_arr) units(build_units(unit_arr));
        if(agent_arr) agents(build_agents(agent_arr));
      }

      if(a.square) square(a.square);
      if(a.instant_save) {// on game load/reload if not in DB
        var test_against = unit_arr ? (unit_arr.length + building_arr.length) : building_arr.length;
        interval = setInterval(test_for_save, 100, test_against);
      } else
        if(unit_arr) displayTotalMenBar();
    }
  	
  	public function addCityImage() {
  	  var size = CityConstants.IMAGES[determineCitySize(population())],
  		    str = empire()[1].toLowerCase() + '/city/' + size,
  	      img:ImgLoader = new ImgLoader(str);
  	  img.x = -60;
  	  img.y = -60;
  	  addChild(img);
  	}
  	
  	public function determineCitySize(s) {
  	  var size = (s <= CityConstants.VILLAGE) ? 'VILLAGE' :
  				  (s <= CityConstants.TOWN) ? 'TOWN' :
  					  (s <= CityConstants.SMALL_CITY) ? 'SMALL_CITY' :
  					    (s <= CityConstants.CITY) ? 'CITY' :
  					 	    (s <= CityConstants.LARGE_CITY) ? 'LARGE_CITY' :
  					   	    'METROPOLIOUS';
  	  
      return size;
  	}
  	
  	public function population(p=null):int {
  	  if(p) attr['population'] = p;
  	  return attr['population'];
  	}
    
    public function increasePopulation() {
      var population_effects = 0,
          pop = population(),
          percent;
      if(pop >= 10000) {
        if(builders && builders.length > 0) removeBuilders();
        buildings().forEach(function(bld) { population_effects += parseFloat(bld.population_benefits()); });
        percent = (1.015 + population_effects);
        population(pop*percent);
      } else {
        population(pop + 10000);
      }
      level();
    }

    /* Sets/returns city level based on population
     *
     * ==== Returns:
     * Integer
     */
    public function level() {
      var level = population() <= CityConstants.VILLAGE ? 1 :
                    population() <= CityConstants.TOWN ? 2 :
                      population() <= CityConstants.SMALL_CITY ? 3 :
                        population() <= CityConstants.CITY ? 4 :
                          population() <= CityConstants.LARGE_CITY ? 5 :
                            6;
      return level;
    }
    
  	public function taxes(t=null) {
  	  if(t) attr['taxes'] = t;
      if(population() >= 10000) {
        var additional_taxes = 0,
            percent;
        buildings().forEach(function(bld) { additional_taxes += parseFloat(bld.taxes_benefits()); });
        percent = (attr['taxes'] + additional_taxes);
        return Math.round(percent*100)/100
      } else
        return 0;
  	}
    
    public function can_train() {
      var arr = new Array();
      buildings().forEach(function(bld) { arr.concat(bld.armies_allowed()); });
      return arr;
    }
  	
  	public function buildings(blds=null) {
      var _this = this;
      if(blds) {
        blds.forEach(function(b) { 
          b.this_parent(_this);
          unavailable(b);
        });
        attr['buildings'] = blds;
      }
      
      return attr['buildings'];
  	}

    public function addBuilding(building=null) {
      if(!attr['buildings']) attr['buildings'] = new Array();
      attr['buildings'].push(building);
      unavailable(building);
      return attr['buildings'];
    }
  	
  	public function buildingQueue(cb=null) {
      if(!attr['build_queue']) attr['build_queue'] = new Array();
  	  if(cb) {
        attr['build_queue'].push(cb);
        unavailable(cb);
      }
  	  return attr['build_queue'];
  	}
    
    public function unavailable(bld=null) {
      if(!attr['unavailable_buildings']) attr['unavailable_buildings'] = new Array();
      if(bld) attr['unavailable_buildings'].push(bld.obj_call());
      return attr['unavailable_buildings'];
    }
    
    //private function add_allowed_units(bld) {
      //bld.armies_allowed().forEach(function(u) {
        //if(can_train().indexOf(u) < 0) can_train(u);
      //});
    //}
  	
  	public function advanceBuilding() {
  	  if(buildingQueue()[0]) {
        var first = buildingQueue()[0];
        first.build_points(population())
        if(first.turns() == 0) {
          addBuilding(first);
          buildingQueue().splice(0, 1);
        }
      }
  	}
    
    public function unitsQueue(tr=null) {
      if(!attr['units_queue']) attr['units_queue'] = new Array();
      if(tr) attr['units_queue'].push(tr);
      return attr['units_queue'];
    }
  
  	public function advanceUnits() {
      if(unitsQueue()[0]) {
        var first = unitsQueue()[0];
        if(unitsQueue()[0].parent_type == 'agent') {
          addAgents(first);
        } else {
          addUnit(first);
        }
        unitsQueue().splice(0, 1);
      }
  	}
    
    private function addBuilders() {
      builders = new Array();
      for(var i:int=0; i<3; i++) {
        var builder = new settlerBase();
        builder.scaleX = i%2 == 0 ? -0.35 : 0.35;
        builder.scaleY = 0.35;
        builder.x = (40*i) - 50;
        builder.y = 20;
        addChild(builder);
        builder.gotoAndPlay('build');
        builders.push(builder);
      }
    }
    
    private function removeBuilders() {
      for(var i:int=0; i<builders.length; i++) removeChild(builders[i]);
      builders = null;
    }
  	
  	public function collectTaxes() {
  	  return Math.round(population() * taxes())
  	}

    public override function saveAttributes() {
      ExternalInterface.call("savePiece", createJSON());
    }

    public override function createJSON() {
      var json = {};
      json = {
        id: this_id(),
        pieceType: 30,
        empire_id: empire_id(),
        built_id: empire_id(),
        name: named(),
        square: square().name,
        population: population(),
        buildings: "",
        units: "",
        agents: ""
      }
      if(buildings()) buildings().forEach(function(bld) { json['buildings'] += bld.type() + "," + bld.level() + "," + bld.build_points() + "||"; });
      if(units()) units().forEach(function(unit) { json['units'] += unit.type() + "," + unit.men() + "||"; });
      if(agents()) agents().forEach(function(agent) { json['agents'] += agent.type + "||"; });
      
      return json;
    }
    
    /* Sets self conquored by enemy passed
     *
     * ==== Parameters:
     * enemy:: GamePiece
     */
    public function conquored_by(enemy) {
      // set cities empire as enemy's
      empire(enemy.empire()[0]);
      empire_id(enemy.empire_id());
      enemy.combinePieces(this);
      removeChild(tmp_army);
      // TODO: create popup to alert user that this has been conquored
      //----- Also allow them to choose (occupy, sack or raze)
      return this;
    }
  }
}