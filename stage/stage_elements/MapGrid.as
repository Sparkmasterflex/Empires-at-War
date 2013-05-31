package stage.stage_elements {
  import common.ImgLoader;
  import dispatch.MoveWindowEvent;
  
  import flash.display.MovieClip;
  import flash.display.Sprite;
  
  import static_return.TerrainCalculation;

  public class MapGrid extends MovieClip {
  	/*----- TERRAIN CONSTANTS -----*/
  	private const BEACH 			=  10;
  	private const MOUNTAINS 		=  20;
  	private const HILLS				=  30;
  	private const GRASSLAND			=  40;
  	private const STEPPE			=  50;
  	private const PINE_FOREST		=  60;
  	private const DECIDUOUS_FOREST	=  70;
  	private const RAIN_FOREST		=  80;
  	private const DESERT			=  90;
  	private const LAKE				= 100;
  	private const TERRAIN = new Array(BEACH, MOUNTAINS, HILLS, GRASSLAND, STEPPE, PINE_FOREST, DECIDUOUS_FOREST, RAIN_FOREST, DESERT, LAKE);
  	
  	private const LEFT  = 10;
  	private const RIGHT = 20;
  	
  	public var hidden:Sprite;
  	public var gridInfo:Object;
  	
  	public var thisParent;
  	public var gameStage;
  	private var land:StageLand;
  	
  	public function MapGrid(parent) {
  	  thisParent = parent;
  	  hidden = new Sprite();
  	  hidden.graphics.beginFill(0xcccccc, 0);
  	  hidden.graphics.drawRect(0,0,100,100);
  	  hidden.graphics.endFill();
  	  addChild(hidden);
  	  mouseChildren = false;
  	}
  	
  	public function addObject(quad:uint, row:uint, column:uint, posX:Number, posY:Number) {
  	  gridInfo = new Object();
  	  gridInfo.row = row;
  	  gridInfo.column = column;
  	  gridInfo.section = quad;
  	  gridInfo.posX = posX;
  	  gridInfo.posY = posY;
  	  gridInfo.land = false;
  	  gridInfo.pieces = null;
  	  //findMapSquare(gridInfo.section, gridInfo.row, gridInfo.column);
  	}
  	
  	public function addLand(ld:Boolean, t=null) {
  	  land = new StageLand(0x000000);
  	  addChild(land);
  	  gridInfo.land = ld;
  	  var terrain = t == null ? setTerrain(gridInfo.section, gridInfo.row, gridInfo.column) : t,
  	      img = addTerrainImage(terrain);
  	  gridInfo.terrain = terrain; 
  	  if(img) addImgLoader(img);
  	}
  	
  	private function setTerrain(s, r, c) {
  	  var surrounding = [],
  		    mountains:Array, beaches:Array, hills:Array, grasslands:Array;
  	  for(var row:Number = -1; row < 2; row++) {
    		for(var column:Number = -1; column < 2; column++) {
    		  var neighbor = findMapSquare(s, (r + row), (c + column)),
    		      terrain = neighbor ? neighbor.gridInfo.terrain : null;
    		  if(terrain) surrounding.push(terrain);
    		}
  	  }  
  	  
  	  var r = Math.round(Math.random() * 9),
  		    thisTerrain = surrounding.length == 0 ?
  				  TERRAIN[r] :
  					  TerrainCalculation.ret(surrounding, TERRAIN);
  	  return thisTerrain;
  	}
  	
  	public function addCoastLine() {
  	  var obj = this.gridInfo,
  		  above = findMapSquare(obj.section, obj.row - 1, obj.column) || null,
  		  below = findMapSquare(obj.section, obj.row + 1, obj.column) || null,
  		  left = findMapSquare(obj.section, obj.row, obj.column - 1) || null,
  		  right = findMapSquare(obj.section, obj.row, obj.column + 1) || null;
  	  
  //	  if(above != null && above.hasLand() == false) addImgLoader('map/coast/top/coast_'+ randomizeNum(4, 1) +'.png', [-2, -55]);
  //	  if(below != null && below.hasLand() == false) addImgLoader('map/coast/bottom/coast_'+ randomizeNum(4, 1) +'.png', [-2, 100]);
  //	  if(left != null && left.hasLand() == false) addImgLoader('map/coast/left/coast_'+ randomizeNum(4, 1) +'.png', [-55, -2]);
  //	  if(right != null && right.hasLand() == false) addImgLoader('map/coast/right/coast_'+ randomizeNum(4, 1) +'.png', [100, -2]);
  	}
  	
  	private function randomizeNum(max, min):String {
  	  return Math.round(min + (max - min) *Math.random()).toString();
  	}
  	
  	public function addTerrainImage(t) {
  	  var imgGroup, imgPrefix; 
  	  switch(t) {
  //		case BEACH:
  //		  imgGroup = 'beaches';
  //		  imgPrefix = 'bch_';
  //		  break;
  		case MOUNTAINS:
  		  imgGroup = 'mountains';
  		  imgPrefix = 'mts_';
  		  break;
  		case HILLS:
  		  imgGroup = 'hills';
  		  imgPrefix = 'hls_';
  		  break;
  		case STEPPE:
  		  imgGroup = 'steppes'; 
  		  imgPrefix = 'stp_';
  		  break;
  //		case PINE_FOREST:
  //		  imgGroup = 'pines';
  //		  imgPrefix = 'pns_';
  //		  break;
  //		case DECIDUOUS_FOREST:
  //		  imgGroup = 'desiduous';
  //		  imgPrefix = 'dsd_';
  //		  break;
  //		case RAIN_FOREST:
  //		  imgGroup = 'rains';
  //		  imgPrefix = 'rns_'
  //		  break;
  		case DESERT:
  		  imgGroup = 'desert';
  		  imgPrefix = 'dst_';
  		  break;
  //		case LAKE:
  //		  imgGroup = 'lakes';
  //		  imgPrefix = 'lks_'
  //		  break;
  		default:
  		  break;
  	  }
  	  if(imgGroup)
  	  	return 'map/terrain/' + imgGroup + '/' + imgPrefix + '1.png'; // TODO change this to random # when all images are created
  	}
  	
  	public function findMapSquare(s, r, c) {
  	  var row:Number = r < 0 ? 29 : r > 29 ? 0 : r,
  		  column:Number = c < 0 ? 29 : c > 29 ? 0 : c,
  		  section:Number;
  	  
  	  switch(s) {
  		case 0:
  		  section = r < 0 ? -1 : r > 29 ? 3 : s;
  		  section = c < 0 ? -1 : c > 29 ? section + 1 : section;
  		  break;
  		case 1:
  		  section = r < 0 ? -1 : r > 29 ? 4 : s;
  		  section = c < 0 ? section - 1 : c > 29 ? section + 1 : section;
  		  break;
  		case 2:
  		  section = r < 0 ? -1 : r > 29 ? 5 : s;
  		  section = c < 0 ? section - 1 : c > 29 ? null : section;
  		  break;
  		case 3:
  		  section = r < 0 ? 0 : r > 29 ? -1 : s;
  		  section = c < 0 ? -1 : c > 29 ? section + 1 : section;
  		  break;
  		case 4:
  		  section = r < 0 ? 1 : r > 29 ? -1 : s;
  		  section = c < 0 ? section - 1 : c > 29 ? section + 1 : section;
  		  break;
  		case 5:
  		  section = r < 0 ? 2 : r > 29 ? -1 : s;
  		  section = c < 0 ? section - 1 : c > 29 ? -1 : section;
  		  break;
  	  }
  	  
  	  if(section >= 0) {
  	    var gameStage = thisParent.thisParent,
  			name = section + "_" + row + "_" + column,
  		    grid = gameStage.getChildByName('section_' + section);
  		try  {
  		  var sq = grid.getChildByName(name);
  		} catch(e:Error){ sq = null }
  	  } else { sq = null; }
  
  	  if(sq != null) return sq;
  	}
  	
  	public function hasLand() {
  	  return gridInfo.land;
  	}
  	
  	public function addImgLoader(img, pos:Array=null) {
  	  var loader = new ImgLoader(img);
  	  if(pos) {
  	    loader.x = pos[0];
  	    loader.y = pos[1];
  	  }
  	  this.addChild(loader);
  	}
  	
  	public function pieces() {
  	  return gridInfo['pieces'];
  	}

    public function empty() { return !pieces(); }
  	
  	public function addToSquare(obj, prevSq=null) {
  	  if(prevSq) prevSq.gridInfo['pieces'] = null;
  	  gridInfo['pieces'] = obj;
      obj.x = x+60;
      obj.y = y+60;
  	  if(obj.attr['primary'] == true) {
  		  dispatchEvent(new MoveWindowEvent(MoveWindowEvent.WINDOW, obj.x, obj.y));
  	  }
  	}
    
    public function removeFromSquare() {
      gridInfo['pieces'] = null;
    }
  }
}