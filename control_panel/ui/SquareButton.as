package control_panel.ui {
  import common.Gradient;
  import common.ImgLoader;
  import common.Label;
  
  import com.greensock.*;
  import com.greensock.plugins.TweenPlugin;
  import com.greensock.plugins.DropShadowFilterPlugin;
  TweenPlugin.activate([DropShadowFilterPlugin]);
  
  import flash.display.MovieClip;
	
  public class SquareButton extends MovieClip	{
	/*-- Classes Added --*/
	private var btnBG:Gradient;
	public var btnRoll:Gradient;
	public var btnDisabled:Gradient;
	public var btnLabel:Label;
	public var rollLabel:Label;
	public var disabledLabel:Label;
	
	/*-- Arrays --*/		
	/*-- Numbers --*/
	/*-- MovieClips and Strings --*/
	private var img_path = "controlPanel/buttons/";
	
	/*-- Boolean --*/
		
	public function SquareButton(label:String, w, h, fontSize=null):void {
	  btnBG = new Gradient(
		[2, 0x444444], 'linear', [0x666666, 0xbbbbbb],
		[1,1], [0,145], w, h,
		(3 * Math.PI) / 2, [w,h,15,15], 'roundRect'
	  );
	  btnRoll = new Gradient(
		[2, 0x222222], 'linear', [0x888888, 0xaaaaaa],
		[1,1], [0,145], w, h,
		(3 * Math.PI) / 2, [w, h, 15, 15], 'roundRect'
	  );
	  btnDisabled = new Gradient(
		[2, 0xcccccc], 'linear', [0x444444, 0x666666],
		[1,1], [0,145], w, h,
		(3 * Math.PI) / 2, [w, h, 15, 15], 'roundRect'
	  );
	  addChild(btnDisabled);
	  addChild(btnBG);
	  addChild(btnRoll);
	  btnRoll.visible = false;
	  label.match(/\.(png|jpg)/) ?
		addImage(label) :
		  textFieldCreation(label)
	}
	
	private function textFieldCreation(label) {
	  var tF:Label = new Label(30, 0xffffff, 'Trebuchet MS', 'LEFT');
	  tF.text = label;
	  tF.x = (btnBG.width / 2) - (tF.width / 2);
	  tF.y = (btnBG.height / 2) - (tF.height / 2);	
	  addChild(tF);
	  TweenLite.to(tF, .1, {dropShadowFilter:{blurX:1, blurY:1, distance:1, alpha:0.65}});
	}
	
	private function addImage(label) {
	  var img:ImgLoader = new ImgLoader(img_path + label);
	  addChild(img);
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

/*
btnLabel = new Label(fS, 0xffffff, 'Arial', 'CENTER');
rollLabel = new Label(fS, 0x222222, 'Arial', 'CENTER');
disabledLabel = new Label(fS, 0x888888, 'Arial', 'CENTER');
textFieldCreation(btnLabel, bL);
textFieldCreation(rollLabel, bL);
textFieldCreation(disabledLabel, bL);
*/