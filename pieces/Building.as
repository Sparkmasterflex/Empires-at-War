package pieces {
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  import static_return.CityConstants;
  
  public class Building {
  	public var attr:Object = new Object();
    public var originalPoints = null;
  	
  	public function Building(building, c) {
      type(building.type);
      level(building.level);
      if(building.build_points != null) originalPoints = building.build_points
      city(c);
  	  getXML();
  	}
    
    public function is_a(str) { return (str == "Building"); }
  	
    public function city(c=null) {
      if(c) attr['city'] = c;
      return attr['city'];
    }
    
  	public function type(t=null) {
  	  if(t) attr['type'] = t;
  	  return attr['type'];
  	}
  	
  	public function level(lvl=null) {
  	  if(lvl) attr['level'] = lvl;
  	  return attr['level'];
  	}

    public function this_parent(p=null) {
      if(p) attr['parent'] = p;
      return attr['parent'];
    }

    public function obj_call(oc=null) {
  	  if(oc) attr['obj_call'] = oc;
  	  return attr['obj_call'];
  	}
    
    public function name(n=null) {
  	  if(n) attr['name'] = n;
  	  return attr['name'];
  	}

    public function thumb(t=null) {
  	  if(t) attr['thumb'] = t;
  	  return attr['thumb'];
  	}

    public function image(img=null) {
  	  if(img) attr['image'] = img;
  	  return attr['image'];
  	}
    
    public function cost(c=null) {
      if(c) attr['cost'] = c;
      return attr['cost'];
    }
    
    public function build_points(bp=null, subtract=true) {
      if(!attr['build_points']) attr['build_points'] = 0; 
      if(bp)
        attr['build_points'] = subtract ? (attr['build_points'] - bp) : bp;
      return attr['build_points'];
    }
    
    public function turns() {
      var city = city()
      return Math.round(build_points()/city.population())
    }
  	
  	public function benefits(specific=null, value=null) {
      if(!attr['benefits']) attr['benefits'] = new Object();
  	  if(specific) {
        if(value) attr['benefits'][specific] = value;
  		  return attr['benefits'][specific];
  	  } else
  	  	return attr['benefits'];
  	}
  	
  	public function allows(specific=null, value=null) {
      if(!attr['allows']) attr['allows'] = new Object();
      if(specific) {
        if(!attr['allows'][specific]) attr['allows'][specific] = new Array();
        if(value) {
          var arr = value.split(',');
          arr.forEach(function(item) { attr['allows'][specific].push(item); });
        }
        return attr['allows'][specific];
      } else
        return attr['allows'];
  	}
    
    private function getXML() {
      var xml = "xml/city_" + city().empire()[1].toLowerCase() + ".xml",
          xmlLoader = new URLLoader();
      xmlLoader.load(new URLRequest(xml));
      xmlLoader.addEventListener(Event.COMPLETE, setupAttributes);
    }
    
    private function setupAttributes(event:Event) {
      var buildingXML = new XML(event.target.data),
          tp = type(), lvl = level(), 
          list:XMLList = buildingXML.building.(type == tp && level == lvl),
          bp = originalPoints != null ? originalPoints : list.build_points;
      obj_call(list.objCall);
      name(list.name);
      image(list.image);
      thumb(list.thumbnail);
      cost(list.cost);
      build_points(bp, false);
      for each (var benefit:XML in list.benefits.children()) benefits(benefit.name(), benefit);
      for each (var allow:XML in list.allows.children()) allows(allow.name(), allow);
    }
	
    /*-- benefits --*/
  	public function army_benefits() { return benefits('army'); }
  	public function population_benefits() { return benefits('population'); }
  	public function order_benefits() { return benefits('order'); }
  	public function taxes_benefits() { return benefits('taxes'); }
  	public function other_benefits() { return benefits('other'); }
  	
  	/*-- allows --*/
  	public function armies_allowed() { 
      return allows('army'); 
    }
  	public function buildings_allowed() { return allows('building'); }
  }
}