package control_panel.ui {
  import flash.events.MouseEvent;
  
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
  	public var tF:Label;
  	public var disabledLabel:Label;
  	
  	/*-- Arrays --*/		
  	/*-- Numbers --*/
  	/*-- MovieClips and Strings --*/
  	private var img_path = "ui/controlPanel/buttons/";
  	
  	/*-- Boolean --*/
    private var over:Boolean = false;
    private var clicked:Boolean = false;
  		
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
  	  label.match(/\.(png|jpg)$/) ?
  		addImage(label) :
  		textFieldCreation(label, fontSize)
      addEventListener(MouseEvent.MOUSE_OVER, buttonRoll);
      addEventListener(MouseEvent.MOUSE_OUT, buttonRoll);
      addEventListener(MouseEvent.MOUSE_DOWN, onClickBtn);
      addEventListener(MouseEvent.MOUSE_UP, onClickBtn);
      buttonMode = true;
      mouseChildren = false;
  	}
  	
  	private function textFieldCreation(label, fs=null) {
  	  var fontSize = fs || 30;
      tF = new Label(fontSize, 0xffffff, 'Trebuchet MS', 'LEFT');
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
    
    private function buttonRoll(event:MouseEvent) {
      over = over ? false : true;
      btnRoll.visible = over;
    }
    
    private function rollLabelVisible(event:MouseEvent) {
      if(over) {
        rollLabel.visible = false;
        btnLabel.visible = true;
        over = false;
      } else {
        rollLabel.visible = true;
        btnLabel.visible = false;
        over = true;
      }
    }
    
    private function onClickBtn(event:MouseEvent) {
      var yPos = this.y;
      if(clicked) {
        //TweenLite.to(curBtn, .25, { y:yPos - 2, dropShadowFilter:{blurX:.5, blurY:.5, distance:1, alpha:0.45}});
        clicked = false;
      } else {
        //		clickChannel = btnClickSound.play();
        //		clickChannel.soundTransform = soundVol;
        //TweenLite.to(curBtn, .25, { y:yPos + 2, dropShadowFilter:{blurX:0, blurY:0, distance:0, alpha:0}});
        clicked = true;
        // TODO add removeEL. for onClickBtn and onComp func to addEL when tween done 
      }
    }
  	
  	public function disableBtn() {
  	  btnRoll.visible = false;
  	  btnLabel.visible = false;
  	  btnBG.visible = false;
  	}

    /* Change the text in the label
     *
     * ==== Parameters:
     * str:: String
     *
     * ==== Returns:
     * this
     */
    public function change_text(str) {
      tF.text = str;
      tF.x = (btnBG.width / 2) - (tF.width / 2);
      tF.y = (btnBG.height / 2) - (tF.height / 2);
      return this;
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