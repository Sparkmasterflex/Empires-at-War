package control_panel.ui.popups {
  import com.greensock.*;

  import dispatch.PopupEvent;
  import control_panel.ui.*;
  import control_panel.ui.popups.BattleAlert;
  
  import common.Gradient;
  import common.ImgLoader;
  import common.Label;
  
  import flash.events.*;
  
  import pieces.*;
  import pieces.events.Battle;
  
  public class BattlePopup extends Popup {
    /*---- Classes Added ----*/
    public var attacker:GamePiece;
    public var defender:GamePiece;
    public var battle:Battle;
    public var alert:BattleAlert;
    public var balanceBar:BalanceBar;
    public var startButton:SquareButton;
    public var cancelButton:SquareButton;

    /*---- Arrays and Objects----*/
    public var attacker_thumbs:Array;
    public var defender_thumbs:Array;
    public var labels:Object;
    
    /*---- Numbers ----*/
    public var list_num:int;
    
    public function BattlePopup(type, attk, defn) {
      super(870, 750, false);
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
      add_popup_image('battles/placeholder.jpg', {});
      battle_controls();
      createBalanceBar();
    }
    
    private function battle_controls() {
      if(alert) fade_and_remove(alert);
      var attk_pts = battle.attk_points['attack'] + battle.attk_points['defense'] + battle.attk_points['men'],
          defn_pts = battle.defn_points['attack'] + battle.defn_points['defense'] + battle.defn_points['men'],
          attk_per = Math.round((attk_pts/(attk_pts+defn_pts))*100),
          defn_per = Math.round((defn_pts/(attk_pts+defn_pts))*100);
      alert = new BattleAlert('battle_controls', this, {attacker: attacker, attk_per: attk_per, defender: defender, defn_per: defn_per});
      add_and_tween(alert);
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
    
    public function startBattle(event:MouseEvent) {
      if(event.currentTarget.name == "rally_troops") battle.losing().rally(true);
      if(alert) fade_and_remove(alert);
      battle.startBattle();
    }

    /* Calls retreat from player's army
     *
     * ==== Parameters:
     * event:: MouseEvent
     *
     */
    public function soundRetreat(event:MouseEvent) {
      if(alert) fade_and_remove(alert);
      battle.soundRetreat();
    }

    /* Display current battle standing to player
     *   allow opportunity to continue battle or retreat
     * 
     * ==== Parameters:
     * attk_per:: Float
     * defn_per:: Float
     */
    public function offer_retreat(attk_per, defn_per) {
      battle.allow_continue(true);
      if(alert) fade_and_remove(alert);
      alert = new BattleAlert('offer_retreat', this, {attacker: attacker, attk_per: (100-attk_per), defender: defender, defn_per: (100-defn_per)});
      add_and_tween(alert);
    }

    /* Display current battle standing to player
     *   alert computer retreating
     * 
     * ==== Parameters:
     * attk_per:: Float
     * defn_per:: Float
     */
    public function computer_retreating(attk_per, defn_per) {
      if(alert) fade_and_remove(alert);
      alert = new BattleAlert('computer_retreat', this, {attacker: attacker, attk_per: (100-attk_per), defender: defender, defn_per: (100-defn_per)});
      add_and_tween(alert);
    }

    /* Display the battle results and button to remove popup
     *
     * ==== Parameters:
     * winner:: String
     * attk_per:: Float
     * defn_per:: Float
     *
     * ==== Returns:
     * returns
     */
    public function display_battle_results(winner, attk_per, defn_per) {
      if(alert) fade_and_remove(alert);
      alert = new BattleAlert('battle_results', this, {winner: winner, attacker: attacker, attk_per: (100-attk_per), defender: defender, defn_per: (100-defn_per)});
      add_and_tween(alert);
    }

    /* Conclude battle, close popup
     *
     * ==== Parameters:
     * event::  MouseEvent
     *
     * ==== Returns:
     * Boolean
     */
    public function concludeBattle(event:MouseEvent) {
      if(alert) fade_and_remove(alert);
      if(battle.winner)
        dispatchEvent(new PopupEvent(PopupEvent.POPUP, this))
      else {
        // at this point sending computer retreat
        // 33/67 chance computer is rallying/retreating
        if(Math.random() < 0.33) battle.losing().rally(true)
        battle.soundRetreat();
      }
    }

    /* Conclude battle, close popup
     *
     * ==== Parameters:
     * event::  MouseEvent
     */
    public function cancelBattle(event:MouseEvent) {
      dispatchEvent(new PopupEvent(PopupEvent.POPUP, this));
    }

    /* Add argument (MC) and tween up and in
     *
     * ==== Parameters:
     * mc:: MovieClip
     *
     * ==== Returns:
     * returns
     */
    private function add_and_tween(mc) {
      mc.alpha = 0;
      mc.x = (width/2) - (mc.width/2);
      mc.y = 100;
      addChild(mc);
      TweenLite.to(mc, 0.5, {alpha: 1, y: 75, dropShadowFilter:{blurX:2, blurY:2, distance:3, alpha:0.6} });
    }

    /* Tweens argument (MC) down and out then removes
     *
     * ==== Parameters:
     * mc:: MovieClip
     *
     * ==== Returns:
     * returns
     */
    private function fade_and_remove(mc) {
      alert = null;
      TweenLite.to(mc, 0.5, {alpha: 0, y: (mc.y + 25), onComplete: function() { removeChild(mc); } });
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