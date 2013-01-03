package pieces {
  import com.greensock.*;
  import com.greensock.easing.*;
  
  import common.ImgLoader;
  
  import dispatch.AddListenerEvent;
  
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import static_return.CityConstants;
  import static_return.FindAndTestSquare;
  import static_return.GameConstants;

  public class City extends GamePiece {
	
  	public function City(emp, s, num) {
  	  super(emp);
  	  attr = new Object();
  	  empire(this_empire.empire());
  	  population(s);
  	  addCityImage();
  	  attr['pieceType'] = "city";
  	  attr['building']  = []
      var gov_build = new Building({level: 1, type: CityConstants.GOVERNMENT, build_points: 0}, this); 
      building(gov_build);
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
  	
  	public function building(b=null) {
      var this_city = this;
  	  if(!attr['building']) attr['building'] = new Array();
  	  if(b) {
        var any_dup = []
        if(b is Building) {
          attr['building'].forEach(function(bld) { if(bld.level() == b.level() && bld.type() == b.type()) any_dup.push(building) });
          if(any_dup.length == 0) attr['building'].push(b);
        } else {
          for(var j:String in b) {
            b[j].forEach(function(building) {
              attr['building'].forEach(function(bld) { if(bld.level() == j && bld.type() == building) any_dup.push(building) });
              if(any_dup.length == 0) {
                var build = new Building({type: building, level: j}, this_city);
                attr['building'].push(build);
              }
            });
          }
        }
  	  }
  	  return attr['building'];
  	}
  	
  	public function buildingQueue(cb=null) {
      if(!attr['build_queue']) attr['build_queue'] = new Array();
  	  if(cb) attr['build_queue'].push(cb);
  	  return attr['build_queue'];
  	}
  	
  	public function advanceBuilding() {
  	  if(buildingQueue()[0]) {
        var first = buildingQueue()[0];
        first.build_points(population())
        if(first.turns() == 0) {
          building(first);
          buildingQueue().splice(0, 1);
        }
      }
  	}
  
  	public function advanceTroops() {
  	  trace('not yet');
  	}
  	
  	public function collectTaxes() {
  	  return Number(population()) * Number(taxes())
  	}
    
    public function pieceMoveKeyBoard(event:*) {
      var key = event.keyCode,
        currSq = square(),
        toSq = FindAndTestSquare.ret(key, this),
        stage = this.parent,
        section = stage.sGridArr[toSq.split('_')[0]],
        toSquare = section.getChildByName(toSq);
      
      if(directionKeys.indexOf(key) >= 0 && toSquare.hasLand()) {
        dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, this, false));
        if(!toSquare.pieces() && (selectedArr && selectedArr.length > 0)) {
          split_army(toSquare, key);
        } else if(toSquare.pieces() && (selectedArr && selectedArr.length > 0)) {
          send_troops_to(toSquare.pieces());
        } else {
          (toSquare.pieces().empire_is(empire()[0])) ? combinePieces(toSquare.pieces()) : trace('enemy');
        }
      }
    }
  }
}