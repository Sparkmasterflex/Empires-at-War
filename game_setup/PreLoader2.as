package game_setup {
  import flash.display.MovieClip;
  
  import game_setup.PreloaderSlide;
  import common.Gradient;
  import static_return.GameConstants;
  
  public class PreLoader2 extends MovieClip {
    private var slide:PreloaderSlide;
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
      get_random_slide();
    }

    /* Picks preloader slide randomly and displays it
     *
     * ==== Parameters:
     * params
     *
     * ==== Returns:
     * returns
     */
    public function get_random_slide() {
      slide = new PreloaderSlide('gaul', 10);
      slide.x = 50; //GameConstants.WIDTH_CENTER - slide.width/2
      slide.y = 50; //GameConstants.HEIGHT_CENTER - slide.height/2
      addChild(slide);
    }
  }
}