package tileworld.objects {
    import flash.ui.Keyboard;
    
    import org.osflash.signals.Signal;
    
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionType;
    import nape.callbacks.PreCallback;
    import nape.callbacks.PreFlag;
    import nape.callbacks.PreListener;
    import nape.geom.Vec2;
    import nape.phys.BodyType;
    
    import citrus.objects.NapePhysicsObject;
    
    import juice.objects.topdown.Player;
    
    import tileworld.core.World;
    import tileworld.objects.Tile;
	
	public class Player extends juice.objects.topdown.Player {
		public var world:World;
		/*		this.level = opts.level;
		this.walkSpeed = opts.walkSpeed;
		
		// Health
		this.hp = opts.hp;
		this.maxHp = opts.maxHp;
		
		//magic
		this.mp = opts.mp;
		this.maxMp = opts.maxMp;
		//status
		this.died = false;*/
		public var onPlaceTile:Signal;
		public var onMove:Signal;
		
		public function Player(name:String, params:Object = null) {
			super(name, params);
			
			this.onPlaceTile = new Signal();
			this.onMove = new Signal();

			//this.onAnimationChange.add(handleHeroAnimationChange);
			// from L https://github.com/alamboley/Citrus-Engine-Examples/blob/master/src/soundpatchdemo/DemoState.as
		}
		
		public var delayMovementTimers:Array = [];
		
		public function isDoingMovement(name:String):Boolean {
			if(!delayMovementTimers[name])
				delayMovementTimers[name] = 0;
			
			var now:Number = new Date().valueOf();
			
			if(delayMovementTimers[name] > now)
				return false;
			
			this.delayMovementTimers[name] = now + 200;
			
			return _ce.input.isDoing(name);
		}
		
		override public function update(timeDelta:Number):void {
			var self:tileworld.objects.Player = this;
			
			super.update(timeDelta);
			
			if(this.isDoingMovement("place")) {
				this.onPlaceTile.dispatch();
			}
			
			if(this.isDoingMovement("up")) {
				this.onMove.dispatch(this, 'up');
			}
			
			if(this.isDoingMovement("left")) {
				this.onMove.dispatch(this, 'left');
			}
			
			if(this.isDoingMovement("down")) {
				this.onMove.dispatch(this, 'down');
			}
			
			if(this.isDoingMovement("right")) {
				this.onMove.dispatch(this, 'right');
			}
		}
	}
}