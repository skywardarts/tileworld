package tileworld.ui.editor.settings {
  import feathers.controls.Button;
  
  import tileworld.core.World;
  
  public class MainSettings {
      public var isToggle:Boolean = false;
      public var horizontalAlign:String = Button.HORIZONTAL_ALIGN_CENTER;
      public var verticalAlign:String = Button.VERTICAL_ALIGN_MIDDLE;
      public var hasIcon:Boolean = true;
      public var iconPosition:String = Button.ICON_POSITION_LEFT;
      public var iconOffsetX:Number = 0;
      public var iconOffsetY:Number = 0;
      public var world:World;
      
    public function MainSettings(world:World):void {
      this.world = world;
    }
  }
}
