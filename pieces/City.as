package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;

  import common.ImgLoader;
  
  import dispatch.AddListenerEvent;
  
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.utils.*;
  import flash.external.ExternalInterface;
  
  import pieces.agents.Settler;
  
  import settlerBase;
  
  import static_return.GameConstants;
  import static_return.CityConstants;
  import static_return.FindAndTestSquare;

  public class City extends GamePiece {
    /*--------Classes Added------------*/
    public var city_img:ImgLoader;
    public var status_img:ImgLoader;
    
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
  	
    /* Add/Change city image
     *
     * ==== Parameters:
     * destroy:: Boolean
     *
     */
    public function addCityImage(destroy=false) {
      if(city_img) removeChild(city_img);
  	  var size = destroy ? 'destroyed.png' : CityConstants.IMAGES[determineCitySize(population())],
  		    str = empire()[1].toLowerCase() + '/city/' + size;
  	  city_img = new ImgLoader(str);
  	  city_img.x = -60;
  	  city_img.y = -60;
  	  addChild(city_img);
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

    /* Humanize population() adding commas
     *
     * ==== Parameters:
     * params
     *
     * ==== Returns:
     * String
     */
    public function humanize_population() {
      var integer:String = "",
          fraction:String = "",
          pop = population(),
          string:String = pop.toString(),
          array:Array = string.split("."),
          regex:RegExp = /(\d+)(\d{3})/;
     
      integer = array[0];
     
      while(regex.test(integer)) {
        integer = integer.replace(regex,'$1' + ',' + '$2');
      }
     
      if(array[1]){ fraction = integer.length > 0 ? '.' + array[1] : ''; }
     
      return integer + fraction;
    }
    
    public function increasePopulation() {
      var pop = population(),
          prev_level = level(),
          growth = 1+pop_growth();
      if(pop >= 10000) {
        if(builders && builders.length > 0) removeBuilders();
        population(pop*growth);
      } else {
        population(pop + 10000);
      }
      if(level() > prev_level) addCityImage();
      return population();
    }

    /* Calculate % of growth for city
     *
     * ==== Returns:
     * Float
     */
    public function pop_growth() {
      var population_effects = 0;
      buildings().forEach(function(bld) {
        population_effects += parseFloat(bld.population_benefits());
      });
      return (0.015 + population_effects);
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
      buildings().forEach(function(bld) { 
        arr.push(bld.armies_allowed()); // TODO: if this is an array...
      });
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

    private function add_looted_image() {
      status_img = new ImgLoader("/ui/tmp_looting.png");
      status_img.x = this.width - 5;
      status_img.y = this.height - 10;
      addChild(status_img);
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
      if(buildings()) buildings().forEach(function(bld) { json['buildings'] +=  bld.level() + "," + bld.type() + "," + bld.build_points() + "||"; });
      if(units()) units().forEach(function(unit) { json['units'] += unit.type() + "," + unit.men() + "||"; });
      if(agents()) agents().forEach(function(agent) { json['agents'] += agent.type + "||"; });
      
      return json;
    }
    
    /* Sets self conquered by enemy passed
     *
     * ==== Parameters:
     * enemy:: GamePiece
     */
    public function conquered_by(enemy) {
      // set cities empire as enemy's
      empire(enemy.empire()[0]);
      empire_id(enemy.empire_id());
      this_empire = enemy.this_empire;
      // TODO: clean up empire()
      //   ---> really just set to this_empire and parse what is needed from that
      enemy.combinePieces(this);
      if(tmp_army) removeChild(tmp_army);
      return this;
    }

    /* 
     * Set city to be destroyed
     *   removes ability to select
     *   sets 5 turn countdown to remove
     *   adds 'destroyed.png' as city_img
     */
    public override function set_to_destroyed() {
      addCityImage(true);
      removeEventListener(MouseEvent.CLICK, selectThis);
      population(0);
      status(GameConstants.DESTROY);
      change_status_in(5, true);
    }

    /* 
     * Set city to be destroyed
     *   removes ability to select
     *   sets 5 turn countdown to remove
     *   adds 'destroyed.png' as city_img
     */
    public function set_to_looted() {
      add_looted_image();
      status(GameConstants.LOOTED);
      change_status_in(2, true);
    }

    /* 
     * Remove city ruins from board
     */
    public override function remove_ruins() {
      this_empire.destroying.push(this_id());
      this_stage.removeChild(this);
    }

    /* 
     * Remove city looting image from city
     */
    public override function remove_looting() {
      removeChild(status_img);
    }
  }
}