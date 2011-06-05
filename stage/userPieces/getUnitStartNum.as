package stage.userPieces {
	
	public class getUnitStartNum {
		public var men:Number;
		
		public function getUnitStartNum(type:Number, empire:String) {
			switch(type) {
				case 1:
				case 2:
				case 3:
					men = 200;
					break;
				case 4:
				case 5:
				case 6:
					men = 100;
					break;
				case 7:
					men = 1;
					break;
				case 8:
				case 9:
					if(empire == 'mongol' && type == 9) {
						men = 100;
					} else {
						men = 150;
					}
				case 10:
					if(empire == 'mongol') 
						men = 10;
					else
						men = 75;
			}
		}
	}
}