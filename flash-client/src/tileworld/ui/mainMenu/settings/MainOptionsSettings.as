package tileworld.ui.mainMenu.settings {
  import feathers.controls.Button;
  
  import tileworld.core.World;
  
  public class MainOptionsSettings {
    public var world:World;
      
    public function MainOptionsSettings(world:World):void {
      this.world = world;
    }
  }
}