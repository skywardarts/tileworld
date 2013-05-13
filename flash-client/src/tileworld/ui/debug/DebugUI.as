package tileworld.ui.debug {
  import starling.core.Starling;
  
  import tileworld.core.World;

  public class DebugUI {
    public var world:World;

    public function DebugUI(world:World):void {
      this.world = world;
    }

    public function showPerformance():void {
      Starling.current.showStats = true;
    }

    public function hidePerformance():void {
      Starling.current.showStats = false;
    }
  }
}