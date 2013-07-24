package game_setup {
  import flash.display.MovieClip;
  import armyBase;
  
  import common.Gradient;
  import static_return.GameConstants;
  
  public class PreLoader2 extends MovieClip {
    private var army:armyBase;
    private var bg:Gradient;

    public function PreLoader2() {
      super();
      bg = new Gradient(
        ['none'], 'linear', [0x111111, 0x333333],
        [1,1], [0,145], 1200, 800,
        (3 * Math.PI) / 2, [1200,800], 'rectangle'
      );
      bg.x = 0;
      bg.y = 0;
      addChild(bg);
    }
  }
}