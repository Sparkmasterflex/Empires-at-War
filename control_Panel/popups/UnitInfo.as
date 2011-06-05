package control_Panel.popups {
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import fl.controls.TextArea;
  import flash.text.StyleSheet;
  import flash.events.*;
  
  import common.imgLoader;
  import common.gradient;
  import common.textFields;
	
  public class UnitInfo extends MovieClip {
    /*---- Classes ----*/
    public var bg:imgLoader;
    public var lgImg:imgLoader;
    private var empSymbol:imgLoader;
    private var imgBG:gradient;
    private var imgMask:gradient;
    private var unitName:textFields;
    private var unitType:textFields;
    /*public var css:URLRequest = new URLRequest('/styles/styles.css');
    public var style:StyleSheet = new StyleSheet;
    public var cssLoader:URLLoader = new URLLoader();*/
    
    /*---- MovieClips and Strings ----*/
    private var display:MovieClip;
    private var underName:Sprite;
    
    public function UnitInfo(params, empire){	  
	  bg = new imgLoader('/controlPanel/paper_550x.png');
	  addChild(bg);
	  addImageToPopup(params[0].image, empire);
	  createAndAddMask();
	  showNameAndType(params[0]);
	  showStats(params);
	  showDescription(params[0].description);
	  /*cssLoader.load(css);
      cssLoader.addEventListener(Event.COMPLETE, cssComplete);*/
    }
    
    private function addImageToPopup(image, emp) {
      var img = emp.toLowerCase() + '/' + image;
      display = new MovieClip();
      imgBG = new gradient([1, 0x666666], 'linear', [0x222222, 0x000000, 0x444444], [1,1,1],
                           [0,45,255], 230, 300, (3 * Math.PI) / 2, [250,300], 'rectangle' );
      display.addChild(imgBG);
      empSymbol = new imgLoader('empireSymbols/' + emp.toLowerCase() + '.png');
      empSymbol.x = -20;
      empSymbol.y = 20;
      display.addChild(empSymbol);
      lgImg = new imgLoader(img);
      lgImg.x = 10;
      display.addChild(lgImg);
      display.x = 20;
      display.y = 20;
      addChild(display);      
    }
    
    private function createAndAddMask() {
      imgMask = new gradient(['none', 'none'], 'solid', [0x009900], [1], [0], 230, 300, 0, [230,300], 'rectangle');
      imgMask.x = 20;
      imgMask.y = 20;
      addChild(imgMask);
      display.mask = imgMask;
    }
    
    private function showNameAndType(p) {
      unitName = new textFields(36, 0x000000, 'AR JULIAN', 'LEFT');
      unitName.text = p.unitName;
      unitName.x = 260;
      unitName.y = 20;
      addChild(unitName);
      
      underName = new Sprite();
      createLine(underName);
      underName.y = 58;
      
      unitType = new textFields(28, 0x000000, 'AR JULIAN', 'LEFT');
      unitType.text = p.type;
      unitType.x = 270;
      unitType.y = 58;
      addChild(unitType);
    }
    
    private function showStats(p) {
      var lblArr:Array = new Array('Attack Points', 'Defense Points', 'Upkeep Cost', 'Number of Men', 'Bonus'),
          valArr:Array = new Array(p[0].attack, p[0].defense, p[0].cost, p[1], p[0].bonuses);
      for(var i:uint = 0; i < lblArr.length; i++) {
        statText(lblArr[i], valArr[i],(120 + (35 * i)));
      }
    }
    
    private function statText(lbl, val, posY) {
      var valAlign = (lbl != 'Bonus') ? 'RIGHT' : null,
          tFlbl = new textFields(18, 0x000000, 'Arial', 'LEFT'),
          tFval = new textFields(18, 0x000000, 'Arial', valAlign);
                   
       tFlbl.x = 270;
       tFlbl.y = posY;
       tFlbl.text = lbl;
       tFval.x = 490;
       tFval.y = posY;
       tFval.text = val;
       if(lbl == 'Bonus') {
         tFval.width = 240;
         tFval.wordWrap = true;
         tFval.y += 20;
         tFval.x = 280;
       }
       addChild(tFlbl);
       addChild(tFval);
    }
    
    private function showDescription(desc) {
      var tA:TextArea = new TextArea();
      //tA.editable = false;
      tA.htmlText = "<p>" + desc + "</p>";
      tA.width = 510;
      tA.height = 200;
      tA.y = 330;
      tA.x = 20;
      //tA.textField.styleSheet = style;
      addChild(tA);
    }
    
    private function createLine(mc) {
      mc.graphics.lineStyle(2, 0x000000);
      mc.graphics.moveTo(0, 0);
      mc.graphics.lineTo(260, 0);
      mc.x = 255;
      addChild(mc);
    }
    
    /*private function cssComplete(event:Event) {
      style.parseCSS(cssLoader.data)
    }*/
    
  }
}