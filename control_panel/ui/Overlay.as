package control_panel.ui {
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  
  import dispatch.PopupEvent;
  
  public class Overlay extends Sprite {
  	private var toClose;
  	
      public function Overlay(w, h, popup) {
  	  super();
  	  toClose = popup;
  	  this.graphics.beginFill(0x000000);
  	  this.graphics.drawRect(0, 0, w, h);
  	  this.graphics.endFill();
  	  if(popup.can_click_overlay()) addEventListener(MouseEvent.CLICK, closePopups);
  	}
  	
  	private function closePopups(event:MouseEvent) {
  	  dispatchEvent(new PopupEvent(PopupEvent.POPUP, toClose));
  	}
  }
}