package tileworld.core {
  import citrus.core.CitrusEngine;
  import citrus.core.starling.StarlingCitrusEngine;
  
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.geom.Rectangle;
  import flash.ui.Keyboard;
  
  import starling.core.Starling;
  
  
  public class Engine extends StarlingCitrusEngine {
	  public var currentUrl:String;
	  
    public function Engine():void {
      super();
	  
	  trace(loaderInfo.loaderURL);
	  
	  this.currentUrl = loaderInfo.loaderURL;
	  
	  // These settings are recommended to avoid problems with touch handling
	  stage.scaleMode = StageScaleMode.NO_SCALE;
	  stage.align = StageAlign.TOP_LEFT;
	  
	  if((stage.stageWidth != 0)&&(stage.stageHeight != 0)){
		  init();
	  } else {
		  //work around IE flash embedding issues
		  trace('stage is 0x0; listening for resize event');
		  stage.addEventListener(Event.RESIZE, onResize);
	  }
	  
      //this.console.addCommand("pause", pauseGame);
      //this.console.addCommand("goto", goto);
    }
	
	private function onResize(e:Event):void
	{
		if((stage.stageWidth != 0)&&(stage.stageHeight != 0)){
			trace('stage is OK!');
			stage.removeEventListener(Event.RESIZE, onResize);
			init();
		} else {
			trace('stage is ' + stage.stageWidth + 'x' + stage.stageHeight);
		}
	}
	
	private function init():void
	{
    var viewPort:Rectangle = new Rectangle();
    viewPort.width = 760;
    viewPort.height = 600;
    viewPort.x = 0;
    viewPort.y = 0;
    
		setUpStarling(false, 1, viewPort);
		//_starling.showStatsAt("right", "bottom");
		state = new World(this);
		Starling.current.showStats = false;
		
		sound.addSound("Hurt", "assets/sounds/hurt.mp3");
		sound.addSound("Death", "assets/sounds/death.mp3");
	}
    
    private function pauseGame():void {
      this.playing = !this.playing;
    }
    
    private function goto(level:uint):void {
      trace("you should load level " + level);
    }
    
    override protected function handleAddedToStage(e:Event):void {
      super.handleAddedToStage(e);
    
      this.input.keyboard.addKeyAction("place", Keyboard.SPACE);
      this.input.keyboard.addKeyAction("up", Keyboard.UP);
      this.input.keyboard.addKeyAction("left", Keyboard.LEFT);
      this.input.keyboard.addKeyAction("down", Keyboard.DOWN);
      this.input.keyboard.addKeyAction("right", Keyboard.RIGHT);
      this.input.keyboard.addKeyAction("up", Keyboard.W);
      this.input.keyboard.addKeyAction("left", Keyboard.A);
      this.input.keyboard.addKeyAction("down", Keyboard.S);
      this.input.keyboard.addKeyAction("right", Keyboard.D);
      this.input.keyboard.addKeyAction("map", Keyboard.M);
      this.input.keyboard.addKeyAction("target", Keyboard.TAB);
      this.input.keyboard.addKeyAction("escape", Keyboard.ESCAPE);
      this.input.keyboard.addKeyAction("control", Keyboard.CONTROL);
      this.input.keyboard.addKeyAction("tilde", 192);
    }
  }
}