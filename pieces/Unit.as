package pieces {
  import flash.events.*;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  public class Unit {
    /*---- Arrays and Objects ----*/
    public var attr:Object = new Object();
    
    public function Unit(t, a) {
      type(t);
      army(a);
      getXML();
//      setMenAndImage()
    }
    
    public function is_a(str) { return (str == "Unit"); }

    public function type(t=null) {
      if(t) attr['type'] = t;
      return attr['type'];
    }

    public function army(a=null) {
      if(a) attr['army'] = a;
      return attr['army'];
    }

    public function men(m=null) {
      if(m) attr['men'] = m;
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
      if(a) attr['attack'] = a;
      return attr['attack'];
    }

    public function defense(d=null) {
      if(d) attr['defense'] = d;
      return attr['defense'];
    }

    public function cost(c=null) {
      if(c) attr['cost'] = c;
      return attr['cost'];
    }
    
    public function bonuses(b=null) {
      if(b) attr['bonuses'] = b;
      return attr['bonuses'];
    }
    
    public function description(d=null) {
      if(d) attr['description'] = d;
      return attr['description'];
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
      men(list.menStart)
      thumb(list.thumbnail)
      image(list.image)
      name(list.unitName);
      attack(list.attack);
      defense(list.defense);
      cost(list.cost);
      bonuses(list.bonuses);
      description(list.description);
    }
  }
}