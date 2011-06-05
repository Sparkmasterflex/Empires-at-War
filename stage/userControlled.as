package stage {
	import flash.display.MovieClip;
	import flash.events.*;
	import gameSetup.Constants;
	import gameSetup.calculateStartPositions;
	import stage.userPieces.gamePiece;
	import dispatch.displayEvent;
    import dispatch.addListenerEvent;
	import gameSetup.armyLeaders;
	import staticReturn.grabPiece;
	import dispatch.moveWindowEvent;
	import stage.userPieces.empires.addArmyInfo;
	
	public class userControlled extends MovieClip
	{
		/*-- Game Pieces --*/
		public static const ARMY:int			    = 10;
		public static const SETTLER:int			    = 20;
        public static const CITY:int                = 30
		public static const WORKER:int		      	= 40; 
		public static const AGENT:int			    = 50;  //may need to be seperated
		
		public static const TOTAL_TROOPS:Number    	= 3600;
		
		public static const VILLAGE_POP:Number      = 10000
		public static const TOWN_POP:Number         = 20001
		public static const SM_CITY_POP:Number      = 40001
		public static const CITY_POP:Number         = 100001
		public static const LG_CITY_POP:Number      = 300001
		public static const METRO_POP:Number        = 500001
		
		/*-- Classes Added --*/
		public var userPiece:gamePiece;
		
		/*-- Arrays and Objects --*/		
		public var userObj:Object;
		public var posArr:Array;
		public var armyArr:Array = new Array();
		public var settlerArr:Array = new Array();
		public var cityArr:Array = new Array();
		private var tempArr:Array;
		private var selectedArr:Array;
		private var newUnitArr:Array;
		private var newMenArr:Array;
		public var directionKeys:Array = new Array(104, 105, 102, 99, 98, 97, 100, 103,
                                                   38, 33, 39, 34, 40, 35, 37, 36);
		
		/*-- Numbers --*/
		public var difficulty:uint;
		public var section:uint;
		private var posIndex:uint;
		public var armyNumber:Number = 0;
		public var settlerNumber:Number = 0;
		public var cityNumber:Number = 0;
		
		/*-- MovieClips and Strings --*/
		public var empire;
		public var pieceSelected;
		public var startPos;
		public var thisParent;
		public var unitSquare:MovieClip;
		
		/*-- Boolean --*/
		public var isSelected:Boolean = false;
		public var isNew:Boolean = true;
		private var gameStart:Boolean = true;
		
		public function userControlled(e, d, s:uint, square:MovieClip, obj:Object):void {
		  section = s;
		  difficulty = d;
		  empire = e;
	 	  userObj = obj;
		  startPos = square;
		  posArr = calculateStartPositions.ret(startPos, userObj);
		}
		
		public function getParent(p) {
          thisParent = p;
          for(var j:String in userObj) {
            switch(j) {
                case 'ARMY':
                  addUserArmy(userObj.ARMY, userObj.armyUnits);
                  break;
                case 'SETTLER':
                  addUserSettler(userObj.SETTLER);
                  break;
                case 'CITY':
                  addUserCity(userObj.CITY);
                  break;
            }
          }
          pieceStationedInCity(cityArr[0], armyArr[0]);
          gameStart = false;
        }
		
		public function addUserArmy(num:int, arr:Array, men:*=true, square:MovieClip = null, civilian:Array=null, general:String = null) {
		  for(var i:uint = 0; i < num; i++) {
			userPiece = new gamePiece(ARMY, empire);
			userPiece.name = "army " + armyNumber + "-" + empire;
			(gameStart) ? tryToAddPiece() : addGamePiece(square);
			
			armyArr.push(userPiece);
			var uArr = (gameStart) ? arr[i] : arr;
			createArmyObj(men, uArr, civilian, general);
			armyNumber++;
			addArmyMenBar(userPiece);
			pieceEventListeners();
		  }
		  addEventListener(Event.ENTER_FRAME, moveWindowToArmy);
		}
		
		public function addUserSettler(num, square:MovieClip = null, support:Array = null){
		  for(var i:uint = 0; i < num; i++) {
			userPiece = new gamePiece(SETTLER, empire);
			userPiece.name = "settler " + settlerNumber + "-" + empire;
			(gameStart) ? tryToAddPiece() : addGamePiece(square);
			
			settlerArr.push(userPiece);
			createSettlerObj(support);
			settlerNumber++;
			pieceEventListeners();
		  }
		}
		
		public function addUserCity(num, square:MovieClip = null) {
	      for(var i:uint = 0; i < num; i++) {
	        userPiece = new gamePiece(CITY, empire);
	        userPiece.name = "city " + cityNumber + "-" + empire;
	        (gameStart) ? tryToAddPiece() : addGamePiece(square);
	        
            cityArr.push(userPiece);
            createCityObj();
            cityNumber++;
            pieceEventListeners();
	      }
		}
		
		private function tryToAddPiece() {
	      try {
            addChildAndPosition();
          } catch(errObject:Error) {
            trace(errObject.message);
            addChildAndPosition();
          }
		}
		
		public function addChildAndPosition() {
		  var currGrid = thisParent.sGridArr[section],
		      posIndex = Math.round(Math.random() * posArr.length);
		  unitSquare = currGrid.getChildByName(posArr[posIndex]);
		  
		  (unitSquare.mGridInfo.land === true) ? addGamePiece(unitSquare) : addChildAndPosition();
          posArr.splice(posIndex, 1);
		}
		
		public function addGamePiece(sq) {
		  unitSquare = sq;
		  userPiece.x = unitSquare.x + 50;
		  userPiece.y = unitSquare.y + 60;
		  addChild(userPiece);
          pieceToNewSquare(userPiece, unitSquare);
		}
		
		private function createArmyObj(men, arr:Array, civilian:Array = null, general:String = null, p = null) { 
		  var piece = p || userPiece,
		      obj:Object = new Object()
		      pieceDetails:addArmyInfo;
			 
		  arr = piece.addUnitArr(arr, men);
		  obj.type        = 'army';
		  obj.name        = userPiece.name;
		  obj.builtBy     = empire;
		  obj.controlled  = empire;
		  obj.civilian    = civilian;
		  obj.general     = armyLeaders.ret('captain');
		  obj.curSection  = section;
		  obj.square      = unitSquare;
		  obj.facingLeft  = true;
		  grabPiece.ret(piece).pieceDetails = new addArmyInfo(obj, arr);
		}
		
		private function createSettlerObj(others:Array=null) {
		  var obj = grabPiece.ret(userPiece).pieceDetails;
		  obj.type           = 'settler';
		  obj.name           = userPiece.name;
		  obj.builtBy        = empire;
		  obj.controlled     = empire;
		  obj.supportPieces  = others ? others : ['settler'];
		  obj.curSection     = section;
		  obj.square         = unitSquare;
		  obj.facingLeft     = true;
		}
		
		private function createCityObj(civilian:Array=null) {
		  var obj = grabPiece.ret(userPiece).pieceDetails;
		  obj.type         = 'city';
		  obj.name         = userPiece.name;
		  obj.cityName     = "my " + userPiece.name  // TODO create class with city names for each empire. Also create a popup window that allows user to name?
		  obj.builtBy      = empire;
		  obj.controlled   = empire;
		  obj.civilian     = civilian;
		  obj.population   = VILLAGE_POP;
		  obj.buildings    = ['warlord circle', 'warrior center', 'town square'];
		  obj.construction = null;
		  obj.training     = null;
		  obj.taxRate      = .15;
		  obj.curSection   = section;
		  obj.square       = unitSquare;
		}
		
		
		private function pieceEventListeners() {
		  userPiece.addEventListener(MouseEvent.CLICK, newSelection);	
		}
		
		public function newSelection(event:MouseEvent) {
		  if(isSelected) {
			if(grabPiece.ret(pieceSelected) != grabPiece.ret(event.target)) { 
            //piece clicked on is not same as selected, selected new
			pieceSelected.unSelect();
			pieceSelected = event.target;
			pieceSelected.selectPiece();
			dispatchEvent(new addListenerEvent(addListenerEvent.EVENT, this, true));
		  } else {
			//piece clicked is selected, unselect
			pieceSelected.unSelect();
			pieceSelected = event.target;
			dispatchEvent(new addListenerEvent(addListenerEvent.EVENT, this, false));
			isSelected = false;
		  }
		} else {
		  //nothing selected - new selection
		  pieceSelected = event.target;
		  pieceSelected.selectPiece();
		  dispatchEvent(new addListenerEvent(addListenerEvent.EVENT, this, true));
		  isSelected = true;
		}
	    dispatchEvent(new displayEvent(displayEvent.DISPLAY, grabPiece.ret(pieceSelected).pieceDetails, isSelected));
	  }
		
		public function moveWindowToArmy(event:Event) {
		  removeEventListener(Event.ENTER_FRAME, moveWindowToArmy);
		  dispatchEvent(new moveWindowEvent(moveWindowEvent.WINDOW, armyArr[0].x, armyArr[0].y));
		}
		
		public function addArmyMenBar(obj) {
		  if(grabPiece.ret(obj).bar) grabPiece.ret(obj).removeChild(grabPiece.ret(obj).bar);
		  var piece = grabPiece.ret(obj),
		      men = piece.pieceDetails.type == 'army' ?
					  piece.pieceDetails.menTotal : 
						piece.pieceDetails.army.menTotal,
			  percentOfMen = Math.round((men / TOTAL_TROOPS) * 100);
		  piece.displayTotalMenBar(men, percentOfMen);	  
		}
		
		public function pieceStationedInCity(c, p) {
		  // TODO: with city, army, and settler - causing issue with grabPiece.ret() for unselect in newSelection?
    	  var city = grabPiece.ret(c),
    	      piece = grabPiece.ret(p),
    	      cObj = city.pieceDetails,
    	      pObj = piece.pieceDetails,
			  parent = p.parent;
    	  pieceToNewSquare(p, cObj.square, pObj.square);
    	  p.x = c.x + 20;
    	  p.y = c.y;
    	  if(pObj.type == 'army') {
			if(cObj.army == null) {
			  removeChild(p);
			  cObj.army = pObj; 
			} else {
			  var armyArrs = combineArmies([cObj.army, pObj]);
			  cObj.army = createArmyObj(armyArrs[1], armyArrs[0], null, cObj.army.general, c);
			}
			addArmyMenBar(c);
		  } else {
			cObj.civilian = pObj;
			removeChild(p);
			for(var j:String in cObj.civilian) trace(j + ": " + cObj.civilian[j]);
		  }
		}
		
		private function testContact(event:Event) {
		  var testing = event.currentTarget;
		  if(testing.hitTestObject(userPiece)) {
			//if(testing.name != userPiece.name) {
			  //if(testing.y > userPiece) {
				trace(testing.name + " " + userPiece.name);
				//testing.parent.setChildIndex(testing, testing.parent.numChildren-1);
			  //}
			//} 
		  }
		}
		
	  public function pieceMoveKeyBoard(event:KeyboardEvent) {
		var type = grabPiece.ret(pieceSelected).pieceDetails.type,
			piece = pieceSelected,
			selObj = (type == 'city') ?
					  grabPiece.ret(piece).pieceDetails.army : 
						grabPiece.ret(piece).pieceDetails;
		  
		if(directionKeys.indexOf(event.keyCode) >= 0) {
		  if(selectedArr && selectedArr.length > 0){
		    for(var i:uint = 0; i < selectedArr.length; i++) {
		      var unit = selectedArr[i].toString();
		      selObj[unit] = null;
		    }
		    switch(type) {
			  case 'city':
				addUserArmy(1, newUnitArr, newMenArr, grabPiece.ret(piece).pieceDetails.square);
				break;
			  case 'army':
				addUserArmy(1, newUnitArr, newMenArr, selObj.square);
				refreshArmyDetails(piece);
			    break;
			  case 'settler':
			    removeSupportFrom(selObj);
			    addUserSettler(1, selObj.square, selectedArr);
				break;
			}
		    changeSelected(pieceSelected, userPiece);
		  }
		  pieceSelected.pieceMove(event.keyCode);
		 
		  selectedArr = [];
		}
	  }
		
	  public function newArmy(newArr) {
		var type = grabPiece.ret(pieceSelected).pieceDetails.type;
        selectedArr = newArr;
        newUnitArr = new Array();
        newMenArr = new Array();
        var tempUnitArr:Array = new Array(),
            piece = grabPiece.ret(pieceSelected);
        for(var i:uint = 0; i < selectedArr.length; i++) {3
          var unit = selectedArr[i].toString(),
              obj = (type == 'city') ? piece.pieceDetails.army : piece.pieceDetails;
    
          newUnitArr.push(obj[unit][0]);
          newMenArr.push(obj[unit][1]);
        }
      }
	  
	  public function seperateSupport(newArr) { selectedArr = newArr; }
	  
	  private function removeSupportFrom(obj) {
		for (var i:uint = 0; i < selectedArr.length; i++){
		  var index = obj.supportPieces.indexOf(selectedArr[i]);
		  obj.supportPieces.splice(index, 1);
		}
	  }
      
      public function checkForMultipleUnits(sq):Array {
      	//TODO check to see if combined armies units > 18
      	//       if so do not remove prev Army and leave overflow 
      	var pieces = sq.mGridInfo.pieces,
      	    order:Array = new Array(),
      	    armyOrder = new Array(), settlerOrder = new Array(), otherOrder = new Array();
      	    
      	if(pieces.length > 1) {
		  //for (var m:int = 0; m < pieces.length; m++) trace(grabPiece.ret(pieces[m]).pieceDetails.type);
      	  for(var i:uint = 0; i < pieces.length; i++) {
            switch(grabPiece.ret(pieces[i]).pieceDetails.type) {
              case 'city':	var city = pieces[i];  break;
              case 'army':  armyOrder.push(grabPiece.ret(pieces[i]).pieceDetails);  break;
              case 'settler': settlerOrder.push(pieces[i]); break;s
              default:        otherOrder.push(pieces[i]);   break;
            }
		  }
		  
		  if(city) { 
			pieceStationedInCity(city, pieceSelected);
		  } else if(armyOrder.length > 1) { 
		  	for(var a:uint = 0; a < armyOrder.length; a++) pieceToNewSquare(armyOrder[a], null, sq);
		  	var armyArr = combineArmies(armyOrder);
		  	addUserArmy(1, armyArr[0], armyArr[1], sq);
		  	changeSelected(pieceSelected, userPiece);
		  }
		  
		  if(settlerOrder.length > 1) {
		  	for(var s:uint = 1; s < settlerOrder.length; s++) {
		  	  pieceToNewSquare(settlerOrder[s], null, sq);
		  	  grabPiece.ret(settlerOrder[0]).pieceDetails.supportPieces.push('settler');
		  	  removeChild(settlerOrder[s]);
		  	  changeSelected(pieceSelected, settlerOrder[0]);9
		  	}
		  }
		  
		  /*for(var a:uint = 0; a < armyOrder.length; a++) order.push(armyOrder[a]);
		  for(var s:uint = 0; s < settlerOrder.length; s++) order.push(settlerOrder[s]);
          for(var o:uint = 0; o < otherOrder.length; o++) order.push(otherOrder[o]);*/
      	}
      	
      	return order;
      }
      
      public function combineArmies(arr):Array {
      	newUnitArr = new Array(),
      	newMenArr  = new Array();
      	for(var i:uint = 0; i < arr.length; i++) {
		  var obj = arr[i];
		  for(var j:String in obj) {	  	
		    if(j.indexOf('unit') >= 0) {
		      if(obj[j]) {
		        newUnitArr.push(obj[j][0]);
		        newMenArr.push(obj[j][1]);
		      }
		    }
		  }
		  var piece = getChildByName(obj.name);
		  if(piece != null) removeChild(piece);
		}

		return [newUnitArr, newMenArr];
      }
      
      public function changeSelected(unSel, sel) {
      	unSel.unSelect();        
        sel.selectPiece();
        pieceSelected = sel;
        dispatchEvent(new displayEvent(displayEvent.DISPLAY, grabPiece.ret(sel).pieceDetails, isSelected));
      }
        
      public function refreshArmyDetails(army) {
      	var obj = grabPiece.ret(army).pieceDetails,
      	    men:Number = 0;
        for(var j:String in obj) {
		  if(j.indexOf('unit') >= 0) {
		  	if(obj[j] != null) men += obj[j][1];
		  }
		}
		obj.menTotal = men;
        addArmyMenBar(army);
      }
      
      public function pieceToNewSquare(piece, newSq = null, prevSq = null) {
      	if(prevSq) prevSq.mGridInfo.pieces.splice(prevSq.mGridInfo.pieces.indexOf(piece), 1);
      	if(newSq) newSq.mGridInfo.pieces.push(piece);
      }
	}
}