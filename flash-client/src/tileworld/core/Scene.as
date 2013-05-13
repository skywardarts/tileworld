package tileworld.core {
  import flash.geom.Rectangle;
  import flash.events.MouseEvent;
  
  import starling.display.QuadBatch;
  import starling.display.Sprite;
    
  import citrus.math.MathVector;

  public class Scene {
    public var data:Object;
    public var staticMap:QuadBatch;
    public var staticTiles:Array;
    public var target:Object;
    public var world:World;
    public var _container:Sprite;

    public function Scene(world:World):void {
      this.world = world;
      this.staticMap = new QuadBatch();
      this.staticTiles = new Array();
      this._container = new Sprite();
      
      this._container.touchable = false;
      this._container.addChild(this.staticMap);
      
      this.world.addChild(this._container);
    }
    
    public function setup():void {
        this.world.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
    }
    
    private function onMouseWheel(e:MouseEvent):void {
      var scaleX:Number = e.delta > 0 ? scaleX + 0.03 : scaleX - 0.03;
      var scaleY:Number = scaleX;
      
      this.world.view.camera.offset = new MathVector(this.world.stage.stageWidth / 2 / scaleX, this.world.stage.stageHeight / 2 / scaleY);
      this.world.view.camera.bounds = new Rectangle(0, 0, 1550 * scaleX, 450 * scaleY);
    }
  }
}