package tileworld.objects {
    import org.osflash.signals.Signal;
    
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionType;
    import nape.callbacks.PreCallback;
    import nape.callbacks.PreFlag;
    import nape.callbacks.PreListener;
    import nape.geom.Vec2;
    import nape.phys.BodyType;
    
    import citrus.objects.NapePhysicsObject;
    
    import juice.core.Kind;
    import juice.objects.topdown.Entity;
	
	public class Entity extends juice.objects.topdown.Entity {
      public var data:Object;
      
		public function Entity(name:String, params:Object = null):void {
			super(name, params);
		}
	}
}