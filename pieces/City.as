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
	
	public function City(e, s, num) {
	  super();
	  addCityImage(e.toLowerCase(), s);
	  attr = new Object();
	  attr['pieceType'] = "city";
	  attr['building']  = [CityConstants.MEETING]
	  empire(e);
	  population(s);
	  named("city_" + num + "_" + e);
	}
	
	public function addCityImage(e, s) {
	  var size = determineCitySize(s),
		  str = e + '/city/' + size,
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
	  
      return CityConstants.IMAGES[size];
	}

	public function population(p=null):String {
	  if(p) attr['population'] = p;
	  return attr['population'];
	}
	
	public function army(a=null) {
	  if(a) attr['army'] = a;
	  return attr['army'];
	}
	
	public function building(b=null) {
	  if(b) attr['building'] += b;
	  return attr['building'];
	}
  }
}