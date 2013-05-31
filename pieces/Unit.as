package pieces {
  import flash.events.*;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  public class Unit {
    /*---- Arrays and Objects ----*/
    public var attr:Object = new Object();
    public var parent_type = 'army';
    private var empire:String;
    
    public function Unit(t, emp, p=null) {
      if(t is int) { 
        type(t);
      } else {
        type(t[0]);
        men(t[1]);
      }
      empire = emp;
      if(p) this_parent(p);
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

    /* Sets parent Object (Army or City)
     * 
     * ==== Parameters:
     * p::GamePiece (Army or City)
     *
     * ==== Returns
     * GamePiece (Army or City)
     */
    public function this_parent(p=null) {
      if(p) attr['parent'] = p;
      return attr['parent'];
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

    public function img_path(ip=null) {
      if(ip) attr['img_path'] = ip;
      return attr['img_path'];
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
      var xml = "xml/army_" + empire.toLowerCase() + ".xml",
          xmlLoader = new URLLoader();
      xmlLoader.load(new URLRequest(xml));
      xmlLoader.addEventListener(Event.COMPLETE, setupAttributes);
    }
    
    private function setupAttributes(event:Event) {
      var unitXML = new XML(event.target.data),
          tp = type(),
          list:XMLList = unitXML.unit.(objCall == tp);
      if(!men()) men(list.menStart);
      img_path(empire.toLowerCase() + "/" + "army")
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