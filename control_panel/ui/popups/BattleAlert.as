package control_panel.ui.popups {
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.MouseEvent;

  import pieces.events.Battle;
  import pieces.GamePiece;

  import common.Gradient;
  import common.Label;

  import control_panel.ui.SquareButton;
  
  public class BattleAlert extends MovieClip {
    /*---- Classes Added ----*/
  	private var background:Sprite;
    private var popup;
    private var battle:Battle;
    private var attk:GamePiece;
    private var defn:GamePiece;

    /*---- Numbers ----*/
    private var w:int;
    private var h:int;

    public function BattleAlert(alert, pop, attrs) {
      super();
      popup = pop;
      battle = popup.battle;
      w = 400;
      h = 250;
      background = add_bg();
      attk = attrs.attacker;
      defn = attrs.defender;
      switch(alert) {
        case 'battle_controls':
          add_message("Begin Battle", "Shall we begin our assault?");
          attrs['label'] = "Strength";
          add_battle_stats(attrs);
          add_battle_options();
          break;
        case 'offer_retreat':
          add_message("Losing Battle", "Do you wish to retreat or continue the fight?");
          attrs['label'] = "Losses";
          add_battle_stats(attrs);
          add_retreat_options();
          break;
        case 'computer_retreat':
          add_message("Enemy Retreats", "Your enemy flees for their lives.");
          attrs['label'] = "Losses";
          add_battle_stats(attrs);
          add_continue_button();
          break;
        case 'battle_results':
          var msg = attrs.winner[1] == true ? "Your troops have vanquished their enemies!" : "Your troops have lost the battle, but the war rages on."
          add_message(attrs.winner[0] + " is Victorious", msg);
          attrs['label'] = "Losses";
          add_battle_stats(attrs);
          add_continue_button(false);
          break;
        // add alerts as needed
      }
    }

    /* Add the background for alert
     *
     * ==== Returns:
     * Sprite
     */
    private function add_bg() {
      var bg = new Gradient(
        [1, 0x000000], 'linear', [0x222222, 0x444444], 
        [0.98,0.94], [0,145], w, h, 
        (3 * Math.PI)/2, [w, h], 'rectangle');
      addChild(bg);
      return bg;
    }

    /* Add Battle status and message
     * 
     * ==== Parameters:
     * title::   String
     * message:: String
     *
     */
    private function add_message(title, message) {
      var status_lbl = new Label(20, 0xf0ab32, "Arial", "LEFT"),
          msg = new Label(14, 0xf0ab32, "Arial", "LEFT");
      status_lbl.text = title;
      msg.text = message;
      status_lbl.x = (width/2) - (status_lbl.width/2);
      status_lbl.y = 10;
      msg.x = (width/2) - (msg.width/2);
      msg.y = 40;
      addChild(status_lbl);
      addChild(msg);
    }

    /* Create and add labels for attacker/defender losses in percents
     *
     * ==== Parameters:
     * attrs::  Object
     *
     */
    private function add_battle_stats(attrs) {
      var attk_stats = new Label(20, 0xffffff, "Arial", "LEFT"),
          defn_stats = new Label(20, 0xffffff, "Arial", "LEFT"),
          attk_lbl = new Label(48, 0xffffff, "Arial", "CENTER"),
          defn_lbl = new Label(48, 0xffffff, "Arial", "CENTER"),
          ls_y = 70, ls_pad = 20, per_y = 95;

      attk_stats.text = attrs.attacker.empire()[1] + " " + attrs.label;
      attk_stats.x = ls_pad;
      attk_stats.y = ls_y;
      defn_stats.text = attrs.defender.empire()[1] + " " + attrs.label;
      defn_stats.x = w - (defn_stats.width + ls_pad);
      defn_stats.y = ls_y;

      attk_lbl.text = attrs.attk_per + "%";
      attk_lbl.x = attk_stats.x + 20;
      attk_lbl.y = per_y;
      
      defn_lbl.text = attrs.defn_per + "%";
      defn_lbl.x = defn_lbl.width >= defn_stats.width ? defn_stats.x : defn_stats.x + 20;
      defn_lbl.y = per_y;

      addChild(attk_stats);
      addChild(defn_stats);
      addChild(attk_lbl);
      addChild(defn_lbl);
    }

    /* 
     * Add buttons to allow army retreat or continue battle
     */
    private function add_retreat_options() {
      var retreat_btn = new SquareButton("Retreat", 100, 30, 18),
          continue_btn = new SquareButton("Rally", 100, 30, 18),
          or_lbl = new Label(12, 0xf0ab32, "Arial", "CENTER"),
          note_lbl = new Label(12, 0xffffff, "Arial", "CENTER"),
          btn_y = h - 85; // to bottom and up 10px
      
      retreat_btn.x = w - 180;
      retreat_btn.y = btn_y;
      continue_btn.x = 80;
      continue_btn.y = btn_y;
      or_lbl.text = "or";
      or_lbl.x = continue_btn.x + 115;
      or_lbl.y = btn_y+5;
      note_lbl.text = "There is a chance that your troops may not escape.";
      note_lbl.x = 20;
      note_lbl.y = btn_y+45;

      addChild(retreat_btn);
      addChild(continue_btn);
      addChild(or_lbl);
      addChild(note_lbl);
      continue_btn.name = "rally_troops";
      continue_btn.addEventListener(MouseEvent.CLICK, popup.startBattle);
      retreat_btn.addEventListener(MouseEvent.CLICK, popup.soundRetreat);
    }

    /* 
     * Add start and cancel buttons
     */
    private function add_battle_options() {
      var start_btn = new SquareButton("Attack", 100, 30, 18),
          cancel_btn = new SquareButton("Cancel", 100, 30, 18),
          btn_y = h - 70;

      cancel_btn.x = w - 180;
      cancel_btn.y = btn_y;
      start_btn.x = defn.obj_is('city') ? (w/2 - 50) : 80;
      start_btn.y = btn_y;
      
      addChild(start_btn);
      if(defn.obj_is('army')) {
        addChild(cancel_btn);
        cancel_btn.addEventListener(MouseEvent.CLICK, popup.cancelBattle);
      }
      start_btn.name = "start_battle";
      start_btn.addEventListener(MouseEvent.CLICK, popup.startBattle);
    }

    /* Add ok button
     * 
     * ==== Parameters:
     * note:: Boolean
     * 
     */
    private function add_continue_button(note=true) {
      var continue_btn = new SquareButton("OK", 100, 30, 18),
          btn_y = h - 85;

      continue_btn.x = w/2 - 50;
      continue_btn.y = btn_y;
      if(note) {
        var note_lbl = new Label(12, 0xffffff, "Arial", "CENTER");
        note_lbl.text = "There is a chance that enemy troops will not escape.";
        note_lbl.x = 20;
        note_lbl.y = btn_y+45;
        addChild(note_lbl);
      }
      
      addChild(continue_btn);
      continue_btn.addEventListener(MouseEvent.CLICK, popup.concludeBattle);
    }

  }
}