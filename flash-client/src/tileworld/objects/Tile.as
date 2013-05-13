package tileworld.objects {
	import citrus.objects.NapePhysicsObject;
	
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionType;
	import nape.callbacks.PreCallback;
	import nape.callbacks.PreFlag;
	import nape.callbacks.PreListener;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Image;
	
	public class Tile {
		public var id:int;
		public var x:int = 0;
		public var y:int = 0;
		public var view:Image;
		
		public function Tile(name:String, params:Object = null) {
			//super(name, params);
			
			this.view = params.view;
			this.x = params.x;
			this.y = params.y;
		}
	}
}