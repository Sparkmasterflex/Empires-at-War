package pieces.events {
  import control_panel.ui.popups.BattlePopup;
  import dispatch.PopupEvent;
  
  import flash.display.MovieClip;
  import flash.utils.clearInterval;
  import flash.utils.setInterval;
  
  import pieces.*;
  
  public class Battle extends MovieClip {
    private const ATTACK_TOTAL:int  = 15;
    private const DEFENSE_TOTAL:int = 12;
    private const MEN_TOTAL:int     =  8;
    
    /*---- Classes added -----*/
    public var popup:BattlePopup;
    public var attacker_army:GamePiece;
    public var defender_army:GamePiece;
    public var winner;
    public var loser;
    
    /*---- Objects and Arrays -----*/
    public var attacker_thumbs:Array; 
    public var defender_thumbs:Array;
    public var attk_points:Object;
    public var defn_points:Object;
        
    /*---- Boolean -----*/
    public var continue_attack;

    /*---- Numbers -----*/
    private var skimish_interval:uint;
    private var num_skirmish:int;
    public var attk_total_men:int;
    public var defn_total_men:int;
    
    public function Battle(pop) {
      super();
      popup = pop;
      attacker_army = popup.attacker
      defender_army = popup.defender
      attacker_thumbs = popup.attacker_thumbs;
      defender_thumbs = popup.defender_thumbs;
      
      attk_points = parsePoints(attacker_thumbs);
      attk_total_men = attk_points.men;
      defn_points = parsePoints(defender_thumbs);
      defn_total_men = defn_points.men;
      num_skirmish = 0;
      allow_continue(false);
    }
    
    public function startBattle() {
      skimish_interval = setInterval(skirmish, 250); 
    }

    /* Sounds retreat from either player or computer
     *
     * ==== Parameters:
     * player:: Boolean
     *
     * ==== Returns:
     * returns
     */
    public function soundRetreat() {
      if(able_retreat()) {
        determine_winner();
        loser.retreat_from_battle();
      } else {
        allow_continue(true);
        startBattle();
      }
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
      if(continue_battle() || (defender_army.obj_is('city') && men_remaining())) {
        // if rallied troops add 25% to attack points
        // ---- This will prob need tweeked
        if(attacker_army.rally())
          attk_points['attack'] = attk_points['attack']*1.25;
        else if(defender_army.rally())
          defn_points['attack'] = defn_points['attack']*1.25;

        var larger = attacker_thumbs.length > defender_thumbs.length ? attacker_thumbs.length : defender_thumbs.length,
            attk_percent = Math.round((attk_points['attack']/(attk_points['attack']+defn_points['attack']))*100),
            defn_percent = Math.round((attk_points['defense']/(attk_points['defense']+defn_points['defense']))*100),
            men_percent = Math.round((attk_points['men']/(attk_points['men']+defn_points['men']))*100),
            // TODO: adjust this more... first hit is too much
            // first attack really counts
            multiplier = num_skirmish <= 1 ? 1.5 : 
              // third attack is second wind
              num_skirmish == 3 ? 1.3
                // normal attack
                : 1;
            // first two skirmishes are the most bloody
        
        for(var i:int=0; i<larger; i++) {
          var a_rand = Math.random()*100,
              d_rand = Math.random()*100,
              m_rand = Math.random()*100;

          var attk_loser = a_rand > attk_percent ? attacker_thumbs[i] : defender_thumbs[i],
              defn_loser = d_rand > defn_percent ? attacker_thumbs[i] : defender_thumbs[i],
              men_loser = m_rand > men_percent ? attacker_thumbs[i] : defender_thumbs[i];
          
          if(attk_loser) attk_loser.responds_to.men(Math.ceil(attk_loser.responds_to.men()*(multiplier*0.035)), true);
          if(defn_loser) defn_loser.responds_to.men(Math.ceil(defn_loser.responds_to.men()*(multiplier*0.05)), true);
          if(men_loser) men_loser.responds_to.men(Math.round(men_loser.responds_to.men()*(multiplier*0.025)), true);
          if(attacker_thumbs[i]) {
            var a_th = attacker_thumbs[i],
                a_u = a_th.responds_to;
            a_th.menLbl.text = a_u.men();
            if(a_u.men() == 0) popup.removeDestroyedUnit(a_th, true)
          }
          if(defender_thumbs[i]) {
            var d_th = defender_thumbs[i],
                d_u = d_th.responds_to;
            d_th.menLbl.text = d_u.men();
            if(d_u.men() == 0) popup.removeDestroyedUnit(d_th, false)
          }
        }
        attk_points = parsePoints(attacker_thumbs);
        defn_points = parsePoints(defender_thumbs);
        popup.updateStats()
        num_skirmish++;
      } else {
        clearInterval(skimish_interval);
        men_remaining() ?
          calculate_retreat() :
            determine_winner();
      }
    }

    /* Allow user to retreat from battle
     *
     * ==== Returns:
     * Boolean
     */
    public function calculate_retreat() {
      // TODO: this is off by 4 or 5%
      var losing = attacker_army.totalMen() < defender_army.totalMen() ? attacker_army : defender_army,
          attk_per = (attacker_army.totalMen()/attk_total_men)*100,
          defn_per = (defender_army.totalMen()/defn_total_men)*100;
      
      losing.playable() ?
        popup.offer_retreat(Math.round(attk_per), Math.round(defn_per)) :
          popup.computer_retreating(Math.round(attk_per), Math.round(defn_per));
    }

    /* Determine results of battle
     * == remove loser
     * == conquer city
     * == adjust winner's TotalMenBar
     *
     * ==== Returns:
     * N/A
     */
    public function determine_winner() {
      winner = attacker_army.totalMen() < defender_army.totalMen() ? defender_army : attacker_army,
      loser = winner == attacker_army ? defender_army : attacker_army;
      winner.displayTotalMenBar();
      winner.changed(true);
      if(winner.tmp_army) winner.removeChild(winner.tmp_army);
      var attk_per = (attacker_army.totalMen()/attk_total_men)*100,
          defn_per = (defender_army.totalMen()/defn_total_men)*100;

      popup.display_battle_results([winner.empire()[1], winner.playable()], Math.round(attk_per), Math.round(defn_per))
      handle_loser();
    }

    /* Determine what to do with losing army/city
     *
     * ==== Returns:
     * GamePiece
     */
    public function handle_loser() {
      if(loser.totalMen() > 0) {
        loser.displayTotalMenBar();
        loser.changed(true);
      } else {
        if(loser.isSelected) loser.selectThis(null);
        loser.obj_is('city') ? loser.conquored_by(winner) : loser.destroy();
      }
    }

    /* Calculates the army currently losing battle
     *
     * ==== Returns:
     * GamePiece
     */
    public function losing() {
      // IMPORTANT: only check this if continuing attack
      // ---- do not want losing to flip-flop back and forth
      var losing = attacker_army.totalMen() == defender_army.totalMen() ? null :
                    attacker_army.totalMen() < defender_army.totalMen() ? attacker_army :
                      defender_army;
      return losing;
    }

    /* Test if battle should continue or not
     *
     * ==== Returns:
     * Boolean
     */
    private function continue_battle() {
      // if less than 1/2 men remain give option to end
      var lowest = attk_points['men'] >= defn_points['men'] ? defn_points['men'] : attk_points['men'],
          half_of_total = attk_points['men'] >= defn_points['men'] ? (defn_total_men/2) : (attk_total_men/2),
          half = lowest >= half_of_total;
      // else continue_attack has been set to 'true' and both armies still have men
      return half == true || (allow_continue() && men_remaining());
    }

    /* Sets this.continue_battle to true
     *
     * ==== Parameters:
     * ca:: Boolean
     *
     * ==== Returns:
     * returns
     */
    public function allow_continue(ca=null) {
      if(ca != null) continue_attack = ca;
      return continue_attack;
    }
    
    /* Test if men remain on both sides
     *
     * ==== Returns:
     * Boolean
     */
    private function men_remaining() {
      return attk_points['men'] > 0 && defn_points['men'] > 0
    }

    /* Calculate 50/50 chance retreat successful
     *
     * ==== Returns:
     * Boolean
     */
    public function able_retreat() {
      return 0.5 <= Math.random();
    }
    
    private function get_chances(attk_val, defn_val) {
      var total = attk_val + defn_val,
          attk_percent = attk_val/total,
          defn_percent = defn_val/total;
      return {attk: attk_percent, defn: defn_percent}
    }
  }
}