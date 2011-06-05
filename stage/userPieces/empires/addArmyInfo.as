package stage.userPieces.empires {

	public dynamic class addArmyInfo extends Object {
		private var men:Number = 0;
		
		public function addArmyInfo(obj, arr) {
		  this.type = obj.type;
		  this.name = obj.name;
		  this.builtBy = obj.builtBy;
		  this.controlled = obj.controlled;
		  for(var i:uint = 0; i < arr.length; i++) {
			this['unit' + i] = arr[i];
			men += arr[i][1];
		  }
		  this.menTotal = men;
		  this.general = obj.general;
		  this.civilian = obj.civilian;
		  this.section = obj.curSection;
		  this.square = obj.square;
		}
	}
}