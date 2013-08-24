package control_panel.ui.popups {
  import com.greensock.*;
  import flash.display.MovieClip;
  import control_panel.ui.*;

  import common.Gradient;
  import common.ImgLoader;
  import common.Label;
  
  import flash.events.*;
  import dispatch.PopupEvent;
  import dispatch.AddListenerEvent;
  
  import pieces.*;
  
  public class ConquerPopup extends Popup {
  	public var winner:GamePiece;
  	public var loser:City;
    public var user_note:Label;

    public static const LOOT   = {pop: 0.060, income: 1.25};
    public static const OCCUPY = {pop: 0.013, income: 0.40};
    public static const SACK   = {pop: 0.330, income: 3.20};
    public static const RAZE   = {pop: 1.000, income: 1.80};

    public function ConquerPopup(type, conquered, conqueror) {
      super(600, 550, false);
      winner = conqueror;
      loser = conquered;
      title.visible = false;

      add_popup_image("ui/popups/placeholder3.jpg", {});
      add_city_information();
      add_conquer_options();
      add_user_instructions();
    }

    /* 
     * Create labels to display city information
     */
    private function add_city_information() {
      var bg_gradient = new Gradient(
            [1, 0x444444], 'linear', [0xeeeeee, 0xcccccc], 
            [1,1], [0,145], 290, 200, 
            (3 * Math.PI)/2, [290, 200], 'rectangle'),
          city_name = new Label(30, 0x333333, "Arial", "LEFT"),
      		city_population = new Label(16, 0x333333, "Arial", "LEFT"),
      		city_buildings = new Label(16, 0x333333, "Arial", "LEFT"),
      		city_taxes = new Label(16, 0x333333, "Arial", "LEFT");
      bg_gradient.x = 10;
      bg_gradient.y = 340;
      city_name.x = 20;
      city_name.y = 350;
      city_name.text = loser.named();

      city_population.x = 30;
      city_population.y = city_name.y + 40;
      city_population.text = "Population:\t" + loser.humanize_population();
			
			city_taxes.x = 30;
      city_taxes.y = city_population.y + 20;
      city_taxes.text = "Income:\t\t" + Math.round(loser.taxes() * loser.population());

      city_buildings.x = 30;
      city_buildings.y = city_taxes.y + 20;
      city_buildings.text = "Buildings:\n" + building_names();

      addChild(bg_gradient);
      addChild(city_name);
      addChild(city_population);
      addChild(city_taxes);
      addChild(city_buildings);
    }

    /* 
     * Add buttons for different options of conquering army
     */
    private function add_conquer_options() {
      var arr = new Array("Loot", "Occupy", "Sack", "Raze");//loot_btn, occupy_btn, sack_btn, raze_btn);

      arr.forEach(function(str, i) {
        var btn = new SquareButton(str, 135, 40, 20);
        btn.name = str;
        btn.x = 10 + (148*i)
        btn.y = 290;
        btn.addEventListener(MouseEvent.ROLL_OVER, change_user_note);
        btn.addEventListener(MouseEvent.CLICK, handle_conquering);
        addChild(btn);
      });
    }

    /* 
     * Add note for user directions to user.
     */
    private function add_user_instructions() {
      user_note = new Label(16, 0x000000, "Arial", "CENTER");
      user_note.x = 310;
      user_note.y = 340;
      user_note.width = 280;
      user_note.multiline = true;
      user_note.wordWrap = true;
      user_note.text = "Select how you wish to treat the conquered city.\n\nBe merciful or destroy them all?"
      addChild(user_note);
    }

    /* On MouseOver change user_note to reflect details about choice user is hovered on
     *
     * ==== Parameters:
     * event:: MouseEvent
     *
     */
    private function change_user_note(event:MouseEvent) {
      var note = "",
          pop = loser.population(),
          loser_income = loser.taxes() * pop;
      switch(event.currentTarget.name) {
        case "Loot":
          note = "Allow your army to loot the city before leaving it to the current occupants.\n\n" + Math.round(pop*LOOT.pop) + " of the population will be killed.\n\nYour troops will capture " + Math.round(loser_income*LOOT.income) + " gold for your empire.";
          break;
        case "Occupy":
          note = "Control your army and attempt to assimilate the population into your culture.\n\n" + Math.round(pop*OCCUPY.pop) + " of the population will be killed.\n\nYour troops will capture " + Math.round(loser_income*OCCUPY.income) + " gold for your empire.";
          break;
        case "Sack":
          note = "Loot the city for all its worth and suppress the population under any circumstances.\n\n" + Math.round(pop*SACK.pop) + " of the population will be killed.\n\nYour troops will capture " + Math.round(loser_income*SACK.income) + " gold for your empire.";
          break;
        case "Raze":
          note = "Have your army steal anything of worth before destroying the city with it's population still inside.\n\n" + pop + " of the population will be killed and the city will be reduced to ash.\n\nYour troops will capture " + Math.round(loser_income*RAZE.income) + " gold for your empire.";
          break;
        default:
          note = "Select how you wish to treat the conquered city.\n\nBe merciful or destroy them all?";
      }
      user_note.text = note;
    }

    /* On button Click determine user's choice in conquering city
     *
     * ==== Parameters:
     * event:: MouseEvent
     *
     */
    private function handle_conquering(event:MouseEvent) {
      var pop = loser.population(),
          loser_income = loser.taxes() * pop;
      switch(event.currentTarget.name) {
        case "Loot":
          loser.population((pop*LOOT.pop)*-1);
          loser.set_to_looted();
          winner.this_empire.treasury(Math.round(loser_income*LOOT.income));
          break;
        case "Raze":
          winner.this_empire.treasury(Math.round(loser_income*RAZE.income));
          winner.square(loser.square());
          if(loser.tmp_army) loser.removeChild(loser.tmp_army);
          loser.set_to_destroyed();
          break;
        default:
          var choice = event.currentTarget.name == "Occupy" ? OCCUPY : SACK;
          winner.this_empire.treasury(Math.round(loser_income*choice.income));
          loser.population(pop-(pop*choice.pop));
          loser.conquered_by(winner);
      }

      dispatchEvent(new AddListenerEvent(AddListenerEvent.EVENT, winner, true));
      dispatchEvent(new PopupEvent(PopupEvent.POPUP, this));
    }

    /* Build and return string of City Buildings
     *
     * ==== Parameters:
     * params
     *
     * ==== Returns:
     * String
     */
    private function building_names() {
    	var str = "";
      loser.buildings().forEach(function(bld) {
      	str += "\t" + bld.named() + "\n";
      });

      return str;
    }
  }
}