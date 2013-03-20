package control_panel.ui {
  import com.greensock.*;
  import com.greensock.plugins.TweenPlugin;
  import com.greensock.plugins.DropShadowFilterPlugin;
  TweenPlugin.activate([DropShadowFilterPlugin]);
  
  import common.Gradient;
  
  import control_panel.ui.popups.BattlePopup;
  
  import flash.display.MovieClip;
  import flash.display.Sprite;
  
  import static_return.GameConstants;
  
  public class BalanceBar extends MovieClip {
    /*---- Classes Added ----*/
    public var popup:BattlePopup;
    public var attacker:Object;
    public var defender:Object;
    private var boundingBox:Sprite;
    public var attackerBar:Sprite;
    public var defenderBar:Sprite;
    
    /*---- Numbers ----*/
    private var this_width:int = 250;
    private var this_height:int = 25;
    private var total_pts:int;
    
    public function BalanceBar(battle) {
      super();
      popup = battle.popup;
      attacker = battle.attk_points;
      defender = battle.defn_points
      total_pts = armyPoints(attacker) + armyPoints(defender);
      createBoundingBox();
      addPercents();
    }
    
    private function createBoundingBox() {
      boundingBox = new Sprite();
      boundingBox.graphics.lineStyle(1, 0x222222);
      boundingBox.graphics.moveTo(0,0);
      boundingBox.graphics.lineTo(this_width,0);
      boundingBox.graphics.lineTo(this_width,this_height);
      boundingBox.graphics.lineTo(0,this_height);
      boundingBox.graphics.lineTo(0,0);
      addChild(boundingBox);
    }
    
    private function armyPoints(army) {
      var total = army.attack;
      total += army.defense;
      total += army.men;
      return total;
    }
    
    private function addPercents() {
      attackerBar = new Sprite();
      defenderBar = new Sprite();
      drawBox(attackerBar, true, popup.attacker.empire()[0]);
      drawBox(defenderBar, false, popup.defender.empire()[0]);
    }
    
    private function drawBox(sprite, is_attk, emp) {
      var color = getColor(emp),
          points = is_attk ? armyPoints(attacker) : armyPoints(defender),
          w = boundingBox.width*(points/total_pts);
      sprite.graphics.beginFill(color);
      sprite.graphics.drawRect(0, 0, w-2, 24);
      sprite.graphics.endFill();
      boundingBox.addChild(sprite);
      sprite.x = is_attk ? 1 : (boundingBox.width - sprite.width)-2;
      sprite.y = 1;
    }
    
    public function update() {
      var attk_pts = armyPoints(popup.battle.attk_points),
          defn_pts = armyPoints(popup.battle.defn_points);
      total_pts = (attk_pts + defn_pts)-2;
      var df_w = boundingBox.width*(defn_pts/total_pts);
      TweenLite.to(attackerBar, .25, {width: Math.floor(boundingBox.width*(attk_pts/total_pts))})
      TweenLite.to(defenderBar, .25, {width: Math.floor(df_w), x: (boundingBox.width-df_w)})
    }
    
    private function getColor(empire) {
      var color;
      switch(int(empire)) {
        case GameConstants.EGYPT:
          color = 'EGYPT';
          break;
        case GameConstants.ROME:
          color = 'ROME';
          break;
        case GameConstants.GREECE:
          color = 'GREECE';
          break;
        case GameConstants.GAUL:
          color = 'GAUL';
          break;
        case GameConstants.CARTHAGE:
          color = 'CARTHAGE';
          break;
        case GameConstants.JAPAN:
          color = 'JAPAN';
          break;
        case GameConstants.MONGOLS:
          color = 'MONGOLS';
          break;
        case GameConstants.UNDEAD:
          color = 'UNDEAD';
          break;
      }
      return GameConstants.EMPIRE_COLORS[color];
    }
  }
}