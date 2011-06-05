package stage.userPieces.empires {
  import com.greensock.*
  import com.greensock.plugins.TweenPlugin;
  import com.greensock.plugins.DropShadowFilterPlugin;
  TweenPlugin.activate([DropShadowFilterPlugin]);
  import flash.display.MovieClip;
  import common.imgLoader;
  import common.percentBar;

  public class City extends MovieClip {
    private static const VILLAGE:String     = 'Village'
    private static const TOWN:String        = 'Town'
    private static const SMALL_CITY:String  = 'SmCity'
    private static const CITY:String        = 'City'
    private static const LARGE_CITY:String  = 'LgCity'
    private static const METROPOLIS:String  = 'Metropolis'

  	/*---- Classes ----*/
	private var city:imgLoader;
	public var bar:percentBar;
	
	/*---- Arrays and Objects ----*/
	public var pieceDetails:Object;
	
	/*---- MovieClips and Strings ----*/
	public var currEmpire;
	
	public function City(empire, level = null) {
	  currEmpire = empire;
	  var path;
	  if(level == null) level = VILLAGE;
	  switch(empire) {
        case '40':
          path = 'gaul/cities/gaul';
          break;
        case '20':
          path = 'rome/cities/rome';
          break;
      }
      city = new imgLoader(path + level + '.png');
      city.x = -50;
      city.y = -50;
      addChild(city);
      pieceDetails = new Object();
	}
	
	public function displayTotalMenBar(m, percent) {
	  bar = new percentBar(currEmpire, percent);
	  bar.x = 25;
	  addChild(bar);
	  this.setChildIndex(bar, 0);
	  TweenLite.to(bar, .1, {dropShadowFilter:{blurX:1, blurY:1, distance:1, alpha:0.6}});
	}
  }
}