package pieces {
  import com.greensock.*
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import dispatch.RemoveEvent;
  import common.ImgLoader;
	
  public class PercentBar extends MovieClip {
	private var bar:Sprite;
	private var bgBar:Sprite;
	private var empFlag:ImgLoader;
	
	public function PercentBar(empire, percent){
	  var color:Number,
		  flag;
			
	  switch(int(empire)) {
		case 10:
		  color = 0xf4c10f;
		  break;
		case 20:
		  color = 0x820b08;
		  break;
		case 30:
		  color = 0x5bc9d6;
		  break;
		case 40:
		  color = 0x5b8e14;
		  flag = 'gaul.png';
		  break;
		case 50:
		  color = 0x1b3a93;
		  break;
		case 60:
		  color = 0x48750a;
		  break;
		case 70:
		  color = 0x8e5109;
		  break;
		case 80:
		  color = 0x383838;
		  break;
		}
	  bgBar = new Sprite();
	  bgBar.graphics.lineStyle(1, 0x111111, .4);		
	  bgBar.graphics.beginFill(0xcccccc, .4);
	  bgBar.graphics.drawRect(0, 0, 20, 150);
	  bgBar.graphics.endFill();
	  bgBar.alpha = 0;
	  bgBar.y = -150;
	  addChild(bgBar);
	
	  bar = new Sprite();
	  bar.graphics.beginFill(color, 1);
	  bar.graphics.drawRect(0, 0, 20, 5);
	  bar.graphics.endFill();
	  addChild(bar);
	  empFlag = new ImgLoader('empireSymbols/flag/' + flag);
	  empFlag.y = -5;
	  empFlag.x = -15;
	  addChild(empFlag);
	  animateBar(percent);
	}
		
	private function animateBar(p) {
	  var bgBarHeight = 150,
	      barHeight = 150 * (p / 100);
	  TweenLite.to(bar, .5, { height:barHeight, y:(barHeight * -1) });
	  TweenLite.to(empFlag, .5, { y: -170 });
	  TweenLite.to(bgBar, .25, { alpha:1 });
	}
	
	public function shrinkBar() {
	  TweenLite.to(bar, .5, { height:0, y:0, onComplete: dispatchTo});
	  TweenLite.to(bgBar, .25, { alpha:0 });
	}
	
	private function dispatchTo() {
      dispatchEvent(new RemoveEvent(RemoveEvent.REMOVE, this, this.parent));	
	}
  }
}