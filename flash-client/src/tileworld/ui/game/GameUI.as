package tileworld.ui.game {
  import flash.display.BitmapData;
  import flash.display.Shape;
  import flash.geom.Matrix;
  
  import starling.display.Image;
  import starling.display.Quad;
  import starling.text.TextField;
  import starling.textures.Texture;
  import starling.utils.Color;
  
  import tileworld.core.World;
  import tileworld.objects.Entity;
  import tileworld.ui.game.components.MinimapComponent;

  public class GameUI {
    public var minimap:MinimapComponent;
    public var world:World;
    
    public var _maskDuringLoading:Quad;
    public var _percentTF:TextField;

    public function GameUI(world:World):void {
      this.world = world;
      this.minimap = new MinimapComponent();
    }

    public function showLoading():void {
      this._maskDuringLoading = new Quad(this.world.stage.stageWidth, this.world.stage.stageHeight, Color.BLACK);
      this.world.addChild(this._maskDuringLoading);
      
      this._percentTF = new TextField(400, 200, "LOADING. PLEASE WAIT...", "Verdana", 22, Color.WHITE, true);
      
      this.world.addChild(this._percentTF);
    }

    public function hideLoading():void {
      this.world.removeChild(this._percentTF, true);
      this.world.removeChild(this._maskDuringLoading, true);
    }
    
    public function hideMinimap():void {
        if(this.world.contains(this.minimap._container))
            this.world.removeChild(this.minimap._container);
    }
    
    public function showMinimap():void {
        if(this.world.contains(this.minimap._container))
            this.world.removeChild(this.minimap._container);
        
        this.world.addChild(this.minimap._container);
    }

    public function updateMinimap():void {
      var width:int = 200;
      var scale:Number = width / (this.world.stage.stageWidth * 10);
      var height:int = this.world.stage.stageHeight * 10 * scale;
      
      var playerShape:Shape = new Shape();
      playerShape.graphics.beginFill(Color.WHITE, 0.4);
      playerShape.graphics.drawCircle(width / 2, height / 2, 7);
      playerShape.graphics.endFill();
      //shape.filters = [ new DropShadowFilter() ];
      
      var bitmap:BitmapData = new BitmapData(width, height, false, Color.BLACK);
      
      bitmap.draw(playerShape);
      
      
      var entityShape:Shape = new Shape();
      
      for each(var entity:Entity in this.world.currentArea.entities) {
        var x:Number = (entity.x - this.world.player.x) * scale + (width / 2);
        var y:Number = (entity.y - this.world.player.y) * scale + (height / 2);
        
        entityShape.graphics.beginFill(Color.RED, 0.3);
        entityShape.graphics.drawCircle(x, y, 4);
        entityShape.graphics.endFill();
      }
      
      bitmap.draw(entityShape);
      
      var texture:Texture = Texture.fromBitmapData(bitmap);
      
      this.world.removeChild(this.minimap._container);
      
      this.minimap._container = new Image(texture);
      this.minimap._container.x = this.world.stage.stageWidth - (width + 10); // 10 pixel buffer
      this.minimap._container.y = 10;
      
      this.world.addChild(this.minimap._container);
    }
  }
}