package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.greensock.*;
	import com.greensock.easing.*;
	import textFields;
	
	public class selectEmpire extends MovieClip
	{
		public var egyptTF:textFields = new textFields();
		public var japanTF:textFields = new textFields();
		public var mongolTF:textFields = new textFields();
		public var carthageTF:textFields = new textFields();
		public var greeceTF:textFields = new textFields();
		public var romeTF:textFields = new textFields();
		public var gaulTF:textFields = new textFields();
		public var undeadTF:textFields = new textFields();
		private var thisPicked;
		//private var notSelect:Number;
		private var Ypos:Number = 35;
		private var empireArr:Array = new Array(egyptTF,japanTF,mongolTF,carthageTF,greeceTF,romeTF,gaulTF,undeadTF);
		private var textArr:Array = new Array('Egypt','Japan','Mongol','Carthage','Greece','Rome','Gaul','Undead');
		//private var textFieldArr:Array = new Array();
		
		function selectEmpire():void
		{
			for(var i:int = 0; i < 8; i++) {
				empireArr[i].y = Ypos * i;
				empireArr[i].text = textArr[i];
				addChild(empireArr[i]);
			}
		}
		
		public function showDetails(empireSel):void {
			//trace(this.parent.parent.parent.parent);
			MovieClip(root).expandBox();
			var j:int = 0;
			if(thisPicked != undefined) {
				thisPicked.addEventListener(MouseEvent.CLICK, empireSel.displayDetails);
				thisPicked.removeEventListener(MouseEvent.CLICK, unSelect);
			}
			thisPicked = empireSel;
			thisPicked.removeEventListener(MouseEvent.CLICK, empireSel.displayDetails);
			for(var i:int = 0; i < 8; i++) {
				if(empireArr[i].text != empireSel.text) {
					TweenLite.to(empireArr[i], .75, {y:(20 * j), x:10, scaleX:1, scaleY:1});
					j++;
				} else {
					TweenLite.to(empireSel, .75, {y:160, x:25, scaleX:1.5, scaleY:1.5});
					thisPicked.addEventListener(MouseEvent.CLICK, unSelect);
				}
			}
		}
		
		public function unSelect(event:MouseEvent):void
		{
			thisPicked = event.target;
			thisPicked.addEventListener(MouseEvent.CLICK, thisPicked.displayDetails);
			thisPicked.removeEventListener(MouseEvent.CLICK, unSelect);
			for(var i:int = 0; i < 8; i++) {
				TweenLite.to(empireArr[i], .75, {y:(Ypos * i), x:10, scaleX:1, scaleY:1});
			}
		}
	}
}