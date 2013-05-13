package tileworld.handlers {
	import flash.geom.Rectangle;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
  
  import citrus.math.MathUtils;
  
	import tileworld.core.Area;
	import tileworld.core.World;
	import tileworld.objects.Entity;
	import tileworld.objects.Player;
	import tileworld.objects.Tile;
	import tileworld.utils.Console;
	
	public class WorldMessageHandler {
		public var world:World;
		
		public function WorldMessageHandler(world:World):void {
			this.world = world;
		}
		
		public function init():void {
			var self:WorldMessageHandler = this;
			
			/**
			 * Handle add entities message
			 * @param data {Object} The message, contains entities to add
			 */
			self.world.server.client.on('addEntities', function(data:Object):void {
        self.world.server.addEntities(data.entities);
			});
			
			self.world.server.client.on('removeEntities', function(data:Object):void {
				var entities:Array = data.entities;
				var area:Area = self.world.getCurrentArea();
				
				if(!area) {
					return;
				}
				
				for(var i:int = 0, l:int = entities.length; i < l; ++i) {
					var entity:Entity = area.getEntity(entities[i]);
					
					if(entity) {
						area.removeEntity(entity);
						self.world.remove(entity);
					}
				}
			});
			
			self.world.server.client.on('onMove', function(data:Object):void {
				var area:Area = self.world.getCurrentArea();
				var entity:Entity = area.getEntity(data.entityId);
				
				if(!area) {
					return;
				}
				
				if(!entity) {
					return;
				}
				
				var tween:Tween = new Tween(entity, 0.5);
				
				tween.animate("x", data.path[1].x);
				tween.animate("y", data.path[1].y);
				
				Starling.juggler.add(tween);
				
				//entity.x = data.path[1].x;
				//entity.y = data.path[1].y;
			});
			
			self.world.server.client.on('onAttack', function(data:Object):void {/*
				attacker: 13784
				attackerPos: Object
					x: 454.84644227981687
					y: 867.2368747345855
				result: Object
					damage: 17
					mpUse: ""
					result: 1
				route: "onAttack"
				skillId: 1
				target: 13807*/
			});
			
			self.world.player.onMove.add(function(player:Player, direction:String):void {
				if(!self.world.server.client) {
					Console.error('no client');
					return;
				}
				
				var fromX:int = player.x;
				var fromY:int = player.y;
				var toX:int = direction == 'left' ? player.x - 18 : (direction == 'right' ? player.x + 18 : player.x);
				var toY:int = direction == 'up' ? player.y - 18 : (direction == 'down' ? player.y + 18 : player.y);
				
        if(toX < 0 || toY < 0)
            return;
        
				var playerBox:Rectangle = new Rectangle(toX, toY, 18, 18);
				var entities:Array = self.world.getCurrentArea().entities;
				
				for each(var entity:Entity in entities) {
					var entityBox:Rectangle = new Rectangle(entity.x, entity.y, 18, 18);
					//trace(MathUtils.DistanceBetweenTwoPoints(playerBox.x, entityBox.x, playerBox.y, entityBox.y));
					if(playerBox.intersects(entityBox)) {
						return;
					}
				}
				
				var tiles:Array = self.world.scene.staticTiles;
				
				for(var i:int = 0, l:int = tiles.length; i < l; ++i) {
					if(tiles[i] == undefined)
						continue;
					
					var tile:Tile = tiles[i];
					
					var tileBox:Rectangle = new Rectangle(tile.x, tile.y, 18, 18);
					
					if(playerBox.intersects(tileBox)) {
						return;
					}
				}
				
				self.world.server.client.request("area.playerHandler.move", {
					path: [{ // from
						x: fromX,
						y: fromY
					}, { // to
						x: toX,
						y: toY
					}]
				}, function(data:Object):void {
					
				});
        
        self.world.repositionCamera();
        
        var tween:Tween = new Tween(player, 0.1);
        
        tween.animate("x", toX);
        tween.animate("y", toY);
        
        Starling.juggler.removeTweens(player);
        Starling.juggler.add(tween);
			});
		}
	}
}