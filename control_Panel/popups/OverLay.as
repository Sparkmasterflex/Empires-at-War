package control_Panel.popups {
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  
  import dispatch.popupEvent;

  public class OverLay extends Sprite {
  	private var toClose;
     
    public function OverLay(w, h, popup){
      toClose = popup;
	  this.graphics.beginFill(0x000000);
	  this.graphics.drawRect(0, 0, w, h);
	  this.graphics.endFill();
	  addEventListener(MouseEvent.CLICK, closePopups);
	}
	
	private function closePopups(event:MouseEvent) {
	  dispatchEvent(new popupEvent(popupEvent.POPUP, toClose));
	}
  }
}