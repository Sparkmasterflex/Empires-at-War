package control_panel.ui.popups {
  import com.greensock.*;
  
  import common.Gradient;
  import common.ImgLoader;
  import common.Label;
  
  import control_panel.ui.DisplayThumb;
  import control_panel.ui.Popup;
  import control_panel.ui.SquareButton;
  import control_panel.ui.BalanceBar;
  
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import pieces.Army;
  import pieces.events.Battle;
  
  public class BattlePopup extends Popup {
    /*---- Classes Added ----*/
    public var attacker:Army;
    public var defender:Army;
    public var battle:Battle;
    public var balanceBar:BalanceBar;

    /*---- Arrays and Objects----*/
    public var attacker_thumbs:Array;
    public var defender_thumbs:Array;
    public var labels:Object;
    
    /*---- Numbers ----*/
    public var list_num:int;
    
    public function BattlePopup(type, attk, defn) {
      super(870, 750);
      list_num = 0;
      attacker = attk;
      defender = defn;
      title.visible = false;
      labels = new Object();
      
      // create battle and armies
      attacker_thumbs = createUnitList(attacker);
      defender_thumbs = createUnitList(defender);
      setupBattle();
      
      // create popup ui
      addBattleImage();
      addStartButton();
      createBalanceBar();
    }
    
    private function addBattleImage() {
      var img = new ImgLoader('battles/placeholder.jpg');
      img.x = 10;
      img.y = 10;
      addChild(img);
      return img;
    }
    
    private function addStartButton() {
      var startButton = new SquareButton("Start Battle", 200, 50, 21);
      startButton.x = this.width - (startButton.width + 15);
      startButton.y = 349 - startButton.height;
      addChild(startButton);
      startButton.addEventListener(MouseEvent.CLICK, startBattle);
    }
    
    private function createBalanceBar() {
      balanceBar = new BalanceBar(battle);
      balanceBar.x = (width/2) - (balanceBar.width/2);
      balanceBar.y = 390;
      addChild(balanceBar);
    }
    
    private function createUnitList(army) {
      var bg = listBG(),
          armyLbl = armyLabel(army, bg),
          unit_arr = new Array(),
          col = 0, row = 0;
      for(var i:int=0; i<army.units().length; i++) {
        var thumb = new DisplayThumb(army.units()[i], army);
        thumb.x = (75*col) + bg.x;
        thumb.y = (75*row) + bg.y;
        addChild(thumb);
        unit_arr.push(thumb);
        if(col == 4) {
          col = 0;
          row++;
        } else { col++; }
      }
      
      return unit_arr;
    }
    
    private function listBG() {
      var gradient = new Gradient(
        [1, 0x444444], 'linear', [0xeeeeee, 0xcccccc], 
        [1,1], [0,145], 375, 300, 
        (3 * Math.PI)/2, [375, 300], 'rectangle');
      
      gradient.x = (475*list_num)+10;
      gradient.y = 440;
      addChild(gradient);
      list_num++;
      return gradient;
    }
    
    public function armyLabel(army, bg) {
      var is_attk = army == attacker,
          align = is_attk ? "LEFT" : "RIGHT",
          label = new Label(30, 0x444444, "Arial", align),
          key = is_attk ? 'attacker' : 'defender';
      label.text = army.empire()[1] + ": " + army.totalMen();
      label.x = is_attk ? bg.x : (bg.width + bg.x) - label.width;
      label.y = bg.y - 50;
      labels[key] = label;
      addChild(label);
    }
    
    public function updateStats() {
      labels['attacker'].text = attacker.empire()[1] + ": " + attacker.totalMen();
      labels['defender'].text = defender.empire()[1] + ": " + defender.totalMen();
      balanceBar.update()
    }
   
    public function setupBattle() {
      battle = new Battle(this);
      addChild(battle);
    }
    
    private function startBattle(event:MouseEvent) {
      battle.startBattle();
      TweenLite.to(event.target, .25, {alpha: 0});
    }
    
    public function removeDestroyedUnit(thumb, is_attk) {
      var arr = is_attk ? attacker_thumbs : defender_thumbs,
          army = is_attk ? attacker : defender;
      arr.splice(arr.indexOf(thumb), 1);
      removeChild(thumb);
      army.removeUnit(thumb.responds_to);
    }
  }
}