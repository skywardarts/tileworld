package juice.utils {
  import flash.display.Bitmap;
  
  import starling.utils.AssetManager;

  public class AssetManager extends starling.utils.AssetManager {
    private var _bitmaps:Array;

    public function AssetManager():void {
      super();

      this._bitmaps = new Array();
    }

    public function getBitmap(name:String):Bitmap {
      return this._bitmaps[name];
    }

    public function addBitmap(name:String, bitmap:Bitmap):void {
      this._bitmaps[name] = bitmap;
    }
  }
}