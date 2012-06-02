package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;
  
  import common.ImgLoader;
  
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  
  import static_return.CityConstants;
  import static_return.GameConstants;

  public class City extends GamePiece {
	
	public function City(emp, s, num) {
	  super(emp);
	  attr = new Object();
	  empire(this_empire.empire());
	  population(s);
	  addCityImage();
	  attr['pieceType'] = "city";
	  attr['building']  = [CityConstants.MEETING]
	  taxes(0.07);
	  population(s);
	  named("city_" + num + "_" + empire()[1]);
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
	
	public function population(p=null):String {
	  if(p) attr['population'] = p;
	  return attr['population'];
	}
	
	public function taxes(t=null) {
	  if(t) attr['taxes'] = t;
	  return attr['taxes'];
	}
	
	public function army(a=null) {
	  if(a) attr['army'] = a;
	  return attr['army'];
	}
	
	public function building(b=null) {
	  if(b) attr['building'] += b;
	  return attr['building'];
	}
	
	public function advanceBuilding() {
	  trace('not yet');
	}

	public function advanceTroops() {
	  trace('not yet');
	}
	
	public function collectTaxes() {
	  return Number(population()) * Number(taxes())
	}
  }
}