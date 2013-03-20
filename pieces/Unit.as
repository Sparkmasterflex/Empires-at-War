package pieces {
  import flash.events.*;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  public class Unit {
    /*---- Arrays and Objects ----*/
    public var attr:Object = new Object();
    public var parent_type = 'army';
    
    public function Unit(t, a) {
      type(t);
      army(a);
      getXML();
    }
    
    public function is_a(str) { return (str == "Unit"); }

    public function type(t=null) {
      if(t) attr['type'] = t;
      return attr['type'];
    }
    
    public function unit_type(ut=null) {
      if(ut) attr['unit_type'] = ut;
      return attr['unit_type'];
    }

    public function army(a=null) {
      if(a) attr['army'] = a;
      return attr['army'];
    }

    public function men(m=null, subtract=false) {
      if(m) {
        if(subtract)          
          attr['men'] -= m;
        else
          attr['men'] = parseInt(m);
      }
      return attr['men'];
    }
    
    public function thumb(img=null) {
      if(img) attr['thumb'] = img;
      return attr['thumb'];
    }
    
    public function image(img=null) {
      if(img) attr['image'] = img;
      return attr['image'];
    }

    public function name(n=null) {
      if(n) attr['name'] = n;
      return attr['name'];
    }

    public function attack(a=null) {
      if(a) attr['attack'] = parseInt(a);
      return attr['attack'];
    }

    public function defense(d=null) {
      if(d) attr['defense'] = parseInt(d);
      return attr['defense'];
    }

    public function cost(c=null) {
      if(c) attr['cost'] = c;
      return attr['cost'];
    }

    public function upkeep(uk=null) {
      if(uk) attr['upkeep'] = uk;
      return attr['upkeep'];
    }
    
    public function bonuses(b=null) {
      if(b) attr['bonuses'] = b;
      return attr['bonuses'];
    }
    
    public function description(d=null) {
      if(d) attr['description'] = d;
      return attr['description'];
    }
    
    public function build_points(bp=null) {
      // should actually add this
      // some units I think should take longer than 1 turn
      return 0;
    }
    
    private function getXML() {
      var xml = type() >= 8 ? 
            "xml/army_" + army().empire()[1].toLowerCase() + ".xml" :
              'xml/army_base.xml',
          xmlLoader = new URLLoader();
      xmlLoader.load(new URLRequest(xml));
      xmlLoader.addEventListener(Event.COMPLETE, setupAttributes);
    }
    
    private function setupAttributes(event:Event) {
      var unitXML = new XML(event.target.data),
          tp = type(),
          list:XMLList = unitXML.unit.(objCall == tp);
      men(list.menStart);
      thumb(list.thumbnail);
      image(list.image);
      unit_type(list.type);
      name(list.unitName);
      attack(list.attack);
      defense(list.defense);
      cost(list.cost);
      upkeep(parseInt(list.upkeep));
      bonuses(list.bonuses);
      description(list.description);
    }
  }
}