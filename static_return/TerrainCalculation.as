package static_return {

  public class TerrainCalculation {

	public function TerrainCalculation() {
	  // empty
	}
	
	public static function ret(surrounding:Array, terrainArr:Array):int {
	  var t:Array = surrounding.concat(terrainArr),
	  	  rTerrain = t[Math.round(Math.random() * (t.length - 1))];
	  return rTerrain;
	}
  }
}