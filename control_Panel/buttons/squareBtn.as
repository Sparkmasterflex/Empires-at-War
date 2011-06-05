package control_Panel.buttons {
	import flash.display.MovieClip;
	import common.gradient;
	import common.textFields;
	
	public class squareBtn extends MovieClip
	{
		/*-- Classes Added --*/
		private var btnBG:gradient;
		public var btnRoll:gradient;
		public var btnDisabled:gradient;
		public var btnLabel:textFields;
		public var rollLabel:textFields;
		public var disabledLabel:textFields;
		/*-- Arrays --*/		
		/*-- Numbers --*/
		/*-- MovieClips and Strings --*/
		/*-- Boolean --*/
		
		public function squareBtn(bL:String, fS, w, h):void
		{
		  btnBG = new gradient(
								[2, 0xe1a619], 'linear', [0xf9d06d, 0xf5c655],
								[1,1], [0,145], w, h,
								(3 * Math.PI) / 2, [w,h,15,15], 'roundRect'
							  );
		  btnRoll = new gradient(
								  [2, 0xea8a02], 'linear', [0xcb9002, 0xf4b620],
								  [1,1], [0,145], w, h,
								  (3 * Math.PI) / 2, [w, h, 15, 15], 'roundRect'
								);
		  btnDisabled = new gradient(
								  [2, 0xcccccc], 'linear', [0xcccccc, 0xaaaaaa],
								  [1,1], [0,145], w, h,
								  (3 * Math.PI) / 2, [w, h, 15, 15], 'roundRect'
								);
		  addChild(btnDisabled);
		  addChild(btnBG);
		  addChild(btnRoll);		  
		  btnLabel = new textFields(fS, 0xffffff, 'Arial', 'CENTER');
		  rollLabel = new textFields(fS, 0x222222, 'Arial', 'CENTER');
		  disabledLabel = new textFields(fS, 0x888888, 'Arial', 'CENTER');
		  textFieldCreation(btnLabel, bL);
		  textFieldCreation(rollLabel, bL);
		  textFieldCreation(disabledLabel, bL);
		  addChild(disabledLabel);
		  addChild(btnLabel);
		  addChild(rollLabel);
		  btnRoll.visible = false;
		  rollLabel.visible = false;
		}
		
		private function textFieldCreation(tF, bL) {
		  tF.text = bL;
		  tF.x = (btnBG.width / 2) - (tF.width / 2);
		  tF.y = (btnBG.height / 2) - (tF.height / 2);	
		}
		
		public function enableBtn() {
		  btnLabel.visible = true;
		  btnBG.visible = true;
		}
		
		public function disableBtn() {
		  btnRoll.visible = false;
		  btnLabel.visible = false;
		  btnBG.visible = false;
		}
	}
}