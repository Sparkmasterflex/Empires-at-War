package {
	import fl.controls.CheckBox;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	import flash.events.Event;
	import optionLabels;
	
	public class oppose extends MovieClip
	{
		private var oppoTitle:optionLabels;
		private var inputTF:TextFormat = new TextFormat();
		public var op_cb:CheckBox;
		public var oppoArr:Array = new Array();;
		private var newArr:Boolean = true;
		public var numLimit:Number;
		public var limitedArr:Array;
		
		public function oppose():void
		{
			inputTF.font = "Arial";
			inputTF.size = 15;
			inputTF.color = 0x222222;
			oppoTitle = new optionLabels();
			oppoTitle.text = "Select Opposing Empires";
			addChild(oppoTitle);
		}
		
		public function op_empires(empires):void
		{
			var j:uint = 0;
			var yPos:Number = 30;
//			trace(empires.length);
			for(var i:uint = 0; i < empires.length; i++)
			{
				if(newArr == true) {
					//trace(yPos);
					op_cb = new CheckBox();
					if(i == 3) {
						j = 0;
						yPos = 70;
					} 
					op_cb.x = 20 + 150 * j;
					op_cb.y = yPos;
					j++;
					op_cb.label = empires[i];
					op_cb.setStyle("textFormat", inputTF);
					addChild(op_cb);
					oppoArr.push(op_cb);
					oppoArr[i].addEventListener(Event.CHANGE, addToArr);
				} else {
					oppoArr[i].label = empires[i];
				}
			}
			newArr = false;
		}
		
		public function limitChBox(limit):void
		{
			numLimit = limit;
			//if(limit != 0) {
//				disableChBox(
			limitedArr = new Array();
		}
		
		public function disableChBox(select):void
		{
			for(var i:uint = 0; i < 6; i++) {
				if(select != 0) {			
					oppoArr[i].enabled = false;
				} else {
					oppoArr[i].enabled = true;
				}
			}
		}
		
		public function addToArr(event:Event):void
		{
			if(event.target.selected == true) {
				if(limitedArr.length < (numLimit - 1)) {
					limitedArr.push(event.target);
				} else if(limitedArr.length == (numLimit - 1)) {
					for(var i:uint = 0; i < oppoArr.length; i++) {
						if(oppoArr[i].selected == false) {
							oppoArr[i].enabled = false;
						}
					}
				}
			} else {
				limitedArr.pop();
				for(i = 0; i < oppoArr.length; i++) {
					oppoArr[i].enabled = true;
				}
			}
		}
	}
}