package stage {
  import flash.display.MovieClip;
  import flash.text.TextField;
  import flash.events.Event;
  import dispatch.StageBuildEvent;
  import static_return.GameConstants;
  
  import stage.stage_elements.SectionGrid;
  
  public class GameStage extends MovieClip {
	
	/*---- Added Classes ----*/
	public var sGrid:SectionGrid;
	
	/*---- Arrays & Objects ----*/
	public var sGridArr:Array = new Array();
	public var pieceArray:Array;
	
	/*---- Numbers ----*/
	
	/*---- MovieClips & Strings ----*/
	public var empire;
	public var difficulty;
	public var enemies;
    
	public function GameStage(params) {
	  empire = params.empire;
	  difficulty = params.difficulty;
	  enemies = params.enemies;
	  createStage(params); 
	}
	
	public function createStage(params) { // TODO: debug dispatchEvent issue
	  var j:uint = 0,
		  k:uint = 0,
		  section_arr:Array = params.sections.split('||');
	  
	  for(var i:uint = 0; i < 6; i++) {
		var randomPos = Math.round(Math.random() * 899);
		sGrid = new SectionGrid(this, i);
		sGrid.x = (3000 * j);
		sGrid.y = (3000 * k);
		sGrid.name = 'section_' + i;
		j++;
		if(j == 3) { j = 0; k++; }
		addChild(sGrid);
		sGridArr.push(sGrid);
		if(int(params.status) == GameConstants.NEW_GAME) {
		  var status = i == 5 ? GameConstants.ACTIVE : GameConstants.NEW_GAME;
		  sGrid.createLand(randomPos);
		} else {
		  sGrid.rebuildLand(section_arr[i]);
		}
	  }
	  for(var s:uint = 0; s < sGridArr.length; s++) {
		sGridArr[s].createCoast();
		if(int(params.status) == GameConstants.NEW_GAME) sGrid.recordSection(status);
		if(s == (sGridArr.length - 1)) {
		  dispatchEvent(new StageBuildEvent(StageBuildEvent.ALL_DONE, 'yes'));  
		}
	  }
	}
  }
}