package tileworld.core {
	import tileworld.objects.Entity;
	
	public class Area {
		public var entities:Array;
		public var id:int;
		
		public function Area():void {
	/*		this.playerId = opts.playerId;
			this.entities = {};
			this.players = {};
			this.map = null;
			this.componentAdder = new ComponentAdder({area: this});
			
			//this.scene;
			this.skch = opts.skch;
			this.gd = opts.gd;
			this.gv = opts.gv;
			
			this.mapData = mapData;
			this.isStopped = false;*/
			this.entities = new Array();
		}

		public function addEntity(entity:Entity):void {
			this.entities[entity.id] = entity;
		}
		
		public function removeEntity(entity:Entity):void {
			delete this.entities[entity.id];
		}
		
		public function getEntity(id:int):Entity {
			return this.entities[id];
		}
	}
}