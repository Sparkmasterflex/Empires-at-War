package staticReturn {

  public class ReturnEmpire {
  
    public function ReturnEmpire(){
	  //empty constructor
	}
	
	public static function ret(e):String {
	  var empire:String;
      switch(e) {
        case '10':
          empire =  'Egypt';
          break;
        case '20':
          empire =  'Rome';
          break;
        case '30':
          empire =  'Greece';
          break;
        case '40':
          empire =  'Gaul';
          break;
        case '50':
          empire =  'Carthage';
          break;
        case '60':
          empire =  'Japan';
          break;
        case '70':
          empire =  'Mongols';
          break;
        case '80':
          empire =  'Undead';
          break;
      }
      return empire;
	}
  }	
}