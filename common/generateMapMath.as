package common {
	
	public class generateMapMath {
		public var _arr:Array;
		
		public function generateMapMath(plus, rand) {
			_arr = new Array();
			switch(plus) {
					case 0:
						plus = Math.round(Math.random() * 1);
						if(plus == 0) {
							rand--;
							plus = 0;
						} else {
							rand++;
							plus = 1;
						}
						break;
					case 1:
						plus = Math.round(Math.random() * 5);
						if(plus == 0 || plus == 3) {
							rand--;
							plus = 0;
						} else {
							rand++;
							plus = 2;
						}
						break;
					case 2:
						plus = Math.round(Math.random() * 9);
						if(plus == 0 || plus == 3 || plus == 6 || plus == 9) {
							rand--;
							plus = 0;
						} else {
							rand++;
							plus = 3;
						}
						break;
					case 3:
						plus = Math.round(Math.random() * 1);
						if(plus == 0) {
							rand--;
						} else {
							rand++;
						}
						plus = 0;
						break;
			}
			
			_arr.push(plus);
			if(rand <= 0 || rand == -1) {
				_arr.push(0);
			} else if(rand >= 20) {
				_arr.push(19);
			} else {
				_arr.push(rand);
			}
		}
	}
}