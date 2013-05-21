package control_panel.ui {
  import common.Gradient;
  import common.ImgLoader;
  
  import control_panel.ControlPanel;
  
  import dispatch.PopupEvent;
  import dispatch.AddListenerEvent;
  
  import flash.display.MovieClip;
  import flash.events.*;
  import flash.net.URLLoader;
  import flash.net.URLRequest;

  public class DisplayArray extends MovieClip {
  	public var cp:ControlPanel;
  	public var cityTab;
  	public var armyTab;
  	public var agentTab;
  	
  	/*-- Arrays --*/
  	public var current:Object;
  	private var selectedPiece:Object;
  	public var selectedArr:Array;
  	public var thumbs:Array;
  	private var rollBG:Gradient;
  	
  	/*-- Numbers --*/
  	public var numThumbs:Number;
    public var row:int;
    public var col:int;
  	
  	/*-- Boolean --*/
  	public var selectMultiple:Boolean = false;
  	private var tabOver:Boolean = false;
  	  
  	public function DisplayArray(parent) {
    	super();
  	  cp = parent;
  	  var bg = new Gradient(
  		  [2, 0x444444], 'linear', [0xaaaaaa, 0xaaaaaa],
  		  [1,1], [0,145], 655, 200,
  		  (3 * Math.PI) / 2, [655,200], 'rectangle'
  	  );
  	  addChild(bg);
  	}
  	
  	public function displayThumbnails(piece, expanded:Boolean, show=null) {
      if(thumbs) thumbs.forEach(function(t) { removeChild(t); });
  	  thumbs = new Array()
  
  	  if(expanded) {
        col = 0;
        row = 0;
  	    thumbs = new Array();
    		selectedPiece = piece;
    		addSelectedTabs(selectedPiece);
    		setupTabs(selectedPiece);
        switch(show) {
          case 'units':
            selectedPiece.units().forEach(addThumb);
            break;
          case 'agents':
            selectedPiece.agents().forEach(addThumb);
            break;
          default:
            switch(selectedPiece.obj_is()) {
              case 'agent':
                selectedPiece.agents().forEach(addThumb);
                break;
              case 'army':
                selectedPiece.units().forEach(addThumb);
                break;
              case 'city':
                selectedPiece.buildings().forEach(addThumb);
                break;
            }
        }
      }
  	}
  	
  	private function addThumb(item, index, arr) {
      if(item.build_points() <= 0) {
    	  var thumb = new DisplayThumb(item, selectedPiece);
        addChild(thumb);
        positionThumb(thumb);
        if(col == 7) {
          col = 0;
          row++;
        } else { col++; }
      }
  	}
  	
  	private function positionThumb(thumb) {
  	  thumb.x = 75 * col;
  	  thumb.y = 75 * row;
  	  thumbs.push(thumb);
  	  addChild(thumb);
  	  thumb.mouseChildren = false;
  	  thumb.doubleClickEnabled = true;
  	  thumb.addEventListener(MouseEvent.DOUBLE_CLICK, extendedDetails);
  	  thumb.addEventListener(MouseEvent.CLICK, selectThumb);
  	}
  	
  	public function selectThumb(event:MouseEvent) {
  	  if(event.target.selected) {
    		if(!selectMultiple){
    		  removeAllHighlights();
    		  if(selectedArr.length > 1) {
      			event.target.createHighLight();
      			selectedArr = new Array();
      			selectedArr.push(event.target.responds_to);
    		  }
    		  selectedArr = [];
    		} else {
    		  event.target.removeHighlight();
    		}		  	
  	  } else {
    		if(!selectMultiple) {
    		  selectedArr = new Array();
    		  removeAllHighlights();
    		}
  		  if(!selectedArr || !selectedArr.length > 0) selectedArr = new Array();
  		  event.target.createHighLight();
  	    selectedArr.push(event.target.responds_to);  
  	  }
  	  if(selectedArr.length == numThumbs) selectedArr = null;
      selectedPiece.newArmy(selectedArr);
      // NOT LIKING selectedPiece here for some reason...
      if(selectedPiece.obj_is("city")) dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, selectedPiece, true));
  	}
  	
  	private function addSelectedTabs(obj) {
  	  var tabs = ['city.png', 'army.png', 'agent.png'],
  		    i = 0;
  	  tabs.forEach(function(tab) {
    		var btnDim = 53,
      			bgColor = tab.match(obj.obj_is) ? 0xaaaaaa : 0x444444,
      			btn = new MovieClip(),
      			bg:Gradient = new Gradient(
      				['none'], 'linear', [bgColor, bgColor],
      				[1,1], [0,255], btnDim, btnDim,
      				(3 * Math.PI) / 2, [btnDim,btnDim], 'rectangle'
      			),
      			img:ImgLoader = new ImgLoader('controlPanel/buttons/' + tab);
      	    btn.addChild(bg);
    		img.alpha = 0.5;
    		btn.addChild(img);
    		btn.x = 655 - (btnDim + 1);
    		btn.y = (btnDim * i) + 2;
    		btn.mouseChildren = false;
    		addChild(btn);
    		btn.addEventListener(MouseEvent.MOUSE_OVER, rollOver);
    		btn.addEventListener(MouseEvent.MOUSE_OUT, rollOver);
    		switch(tab) {
    		  case 'city.png':
    			cityTab = btn;
    			break;
    		  case 'army.png':
    			armyTab = btn;
    			break;
    		  case 'agent.png':
    			agentTab = btn;
    			break;
    		}
    		i++;
  	  });
  	}
  	
  	public function setupTabs(piece) {
  	  if(piece.obj_is('city')) {
    		enableTab(cityTab, false);
    		if(piece.units() && piece.units().length > 0) enableTab(armyTab);
    		if(piece.agents() && piece.agents().length > 0) enableTab(agentTab);
	    } else if(piece.obj_is('army')) {
    		enableTab(armyTab, false);
    		if(piece.agents() && piece.agents().length > 0) enableTab(agentTab);
	    } else {
    		enableTab(agentTab, false);
  	  }
  	}
  	
  	public function enableTab(btn, setBG=true) {
  	  var func = btn == cityTab ? showBuildings : 
  		btn == armyTab ? showArmies : 
  		    showAgents;
  	  btn.getChildAt(1).alpha = 1;
  	  btn.addEventListener(MouseEvent.CLICK, func);
  	  if(setBG) {
  	    btn.removeChild(btn.getChildAt(0));
  	    var bg:Gradient = new Gradient(
  		  ['none'], 'linear', [0x777777, 0x777777],
  		  [1,1], [0,255], 53, 53,
  		  (3 * Math.PI) / 2, [53,53], 'rectangle'
  	    )
          btn.addChild(bg);
  	    btn.setChildIndex(bg, 0);
  	  }
  	}
  	
  	private function showBuildings(event:MouseEvent) {
  	  displayThumbnails(selectedPiece, true);
  	}
  
  	private function showArmies(event:MouseEvent) {
  	  displayThumbnails(selectedPiece, true, 'units');
  	}
  	
  	private function showAgents(event:MouseEvent) {
  	  displayThumbnails(selectedPiece, true, 'agents');
  	}
  	
  	private function extendedDetails(event:MouseEvent) {
  	  var thumb  = event.currentTarget;
  	  dispatchEvent(new PopupEvent(PopupEvent.POPUP, 'Unit', null, thumb.responds_to, true));
  	}
  	
  	private function removeAllHighlights() {
  	  for(var i:uint = 0; i < thumbs.length; i++) {
  		var thumb = thumbs[i];
  		thumb.removeHighlight();
  	  }
  	}
  	
  	private function rollOver(event:MouseEvent) {
  	  var tab = event.target;
  	  if(tabOver) {
  		tab.removeChild(rollBG);
  		tabOver = false;
  	  } else {
  		rollBG = new Gradient(
  			  ['none'], 'linear', [0xaaaaaa, 0xaaaaaa],
  			  [1,1], [0,255], tab.width, tab.height,
  			  (3 * Math.PI) / 2, [tab.width,tab.height], 'rectangle'
  		);
  		tab.addChild(rollBG);
  		tab.setChildIndex(rollBG, (tab.numChildren - 2));
  		tabOver = true;
  	  }
  	}
  }
}