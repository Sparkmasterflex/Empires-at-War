package pieces.events {
  import control_panel.ui.popups.BattlePopup;
  
  import flash.display.MovieClip;
  import flash.utils.clearInterval;
  import flash.utils.setInterval;
  
  import pieces.Army;
  
  public class Battle extends MovieClip {
    private const ATTACK_TOTAL:int  = 15;
    private const DEFENSE_TOTAL:int = 12;
    private const MEN_TOTAL:int     =  8;
    
    /*---- Classes added -----*/
    public var popup:BattlePopup;
    
    /*---- Objects and Arrays -----*/
    public var attacker:Array; 
    public var defender:Array;
    public var attk_points:Object;
    public var defn_points:Object;
        
    /*---- Numbers -----*/
    private var skimish_interval:uint;
    private var num_skirmish:int;
    
    public function Battle(pop) {
      super();
      popup = pop;
      attacker = popup.attacker_thumbs;
      defender = popup.defender_thumbs;
      
      attk_points = parsePoints(attacker);
      defn_points = parsePoints(defender);
      num_skirmish = 0;
    }
    
    public function startBattle() {
      skimish_interval = setInterval(skirmish, 500); 
    }
    
    private function parsePoints(thumb_arr) {
      var pts = {men: 0, attack: 0, defense: 0, bonus: 0};
      
      thumb_arr.forEach(function(thumb) {
        var unit = thumb.responds_to;
        pts['attack'] += unit.attack() * unit.men();
        pts['defense'] += unit.defense() * unit.men(); 
        pts['men'] += unit.men(); 
      });
      
      return pts;
    }
    
    private function skirmish() {
      if(attk_points['men'] > 0 && defn_points['men'] > 0) {
        var larger = attacker.length > defender.length ? attacker.length : defender.length,
            attk_percent = Math.round((attk_points['attack']/(attk_points['attack']+defn_points['attack']))*100),
            defn_percent = Math.round((attk_points['defense']/(attk_points['defense']+defn_points['defense']))*100),
            men_percent = Math.round((attk_points['men']/(attk_points['men']+defn_points['men']))*100),
            multiplier = num_skirmish <= 1 ? 3 : 1;
            // first two skirmishes are the most bloody
        
        for(var i:int=0; i<larger; i++) {
          var a_rand = Math.random()*100,
              d_rand = Math.random()*100,
              m_rand = Math.random()*100;

          var attk_loser = a_rand > attk_percent ? attacker[i] : defender[i],
              defn_loser = d_rand > defn_percent ? attacker[i] : defender[i],
              men_loser = m_rand > men_percent ? attacker[i] : defender[i];
          
          if(attk_loser) attk_loser.responds_to.men(Math.ceil(attk_loser.responds_to.men()*(multiplier*0.07)), true);
          if(defn_loser) defn_loser.responds_to.men(Math.ceil(defn_loser.responds_to.men()*(multiplier*0.10)), true);
          if(men_loser) men_loser.responds_to.men(Math.round(men_loser.responds_to.men()*(multiplier*0.05)), true);
          if(attacker[i]) {
            var a_th = attacker[i],
                a_u = a_th.responds_to;
            a_th.menLbl.text = a_u.men();
            if(a_u.men() == 0) popup.removeDestroyedUnit(a_th, true)
          }
          if(defender[i]) {
            var d_th = defender[i],
                d_u = d_th.responds_to;
            d_th.menLbl.text = d_u.men();
            if(d_u.men() == 0) popup.removeDestroyedUnit(d_th, false)
          }
        }
        attk_points = parsePoints(attacker);
        defn_points = parsePoints(defender);
        popup.updateStats()
        num_skirmish++;
      } else {
        trace('battle over');
        clearInterval(skimish_interval);
      }
    }
    
    private function get_chances(attk_val, defn_val) {
      var total = attk_val + defn_val,
          attk_percent = attk_val/total,
          defn_percent = defn_val/total;
      return {attk: attk_percent, defn: defn_percent}
    }
  }
}