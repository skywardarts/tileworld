package tileworld.servers {
    import com.netease.pomelo.Client;
    import com.netease.pomelo.events.ClientEvent;
    
    import feathers.controls.ScreenNavigatorItem;
    
    import flash.events.MouseEvent;
    
    import mx.utils.URLUtil;
    
    import starling.display.Image;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    
    import tileworld.core.Area;
    import tileworld.core.World;
    import tileworld.handlers.WorldMessageHandler;
    import tileworld.objects.Entity;
    import tileworld.ui.editor.screens.ManageEntityScreen;
    import tileworld.ui.editor.settings.ManageEntitySettings;
    import tileworld.utils.Console;

  public class StokeServer {
    public var client:Client;
    public var world:World;
    public var worldMessageHandler:WorldMessageHandler;

    public function StokeServer(world:World):void {
      this.world = world;
      this.worldMessageHandler = new WorldMessageHandler(this.world);
    }
    
    public function addEntities(entities:Array):void {
        var self:StokeServer = this;
        
        var area:Area = self.world.getCurrentArea();
        
        for(var i:int, l:int = entities.length; i < l; ++i) {
            var e:Object = entities[i];
            var entity:Entity = area.getEntity(e.entityId);
            
            if(!entity) {
                entity = new Entity(e.englishName, {
                    id: e.entityId, 
                    width: 18, height: 18, 
                    x: e.x, y: e.y
                });
                
                entity.data = e;
                entity.kind.id = e.kindId;
                
                entity.init(self.world.assets);
                trace(entity.view);
                entity.view.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void {
                    var touch:Touch = e.getTouch(self.world.stage);
                    trace(touch);
                    if(touch) {
                        if(touch.phase == TouchPhase.BEGAN) {
                            trace('a');
                        }  
                        else if(touch.phase == TouchPhase.ENDED) {
                            Console.log(entity);
                            
                            var screen:ScreenNavigatorItem = self.world.editorUI._navigator.getScreen('manageEntity');
                            
                            if(!screen) {
                                screen = new ScreenNavigatorItem(ManageEntityScreen, {
                                    complete: 'main'
                                }, {
                                    settings: new ManageEntitySettings(self.world, entity)
                                });
                                
                                self.world.editorUI._navigator.addScreen('manageEntity', screen);
                            }
                            else {
                                screen.screen.entity = entity;
                            }
                            
                            self.world.setActiveUI('editor');
                            self.world.editorUI._navigator.showScreen('manageEntity');
                        }
                        else if(touch.phase == TouchPhase.MOVED) {
                            trace('c');
                        }
                    }
                });
            }
            
            area.addEntity(entity);
            self.world.add(entity);
        }
    }

    public function connect():void {
      var self:StokeServer = this;
      
      var host:String = (this.world.engine.currentUrl.indexOf('file://') === -1) ? URLUtil.getServerName(this.world.engine.currentUrl) : '127.0.0.1';
      var port:int = 3014;
      
      this.client = new Client();
      this.worldMessageHandler.init();
      
      // handle disconect message, occours when the client is disconnect with servers
      this.client.on('disconnect', function(reason:Object):void {
        //showLogin();
        Console.log('show connecting');
      });
      
      self.client.init(host, port, null, function():void {
        var randomId:String = (Math.floor(Math.random() * (9999999999 - 1111111111 + 1)) + 1111111111).toString();
        
        self.client.request("auth.authHandler.login", {
          username: "user" + randomId,
          pwd: null
        }, function(data:Object):void {
          var token:String = data.token;
          
          self.client.request("gate.gateHandler.queryEntry", {
            uid: data.uid
          }, function(data:Object):void {
            self.client.disconnect();
            
            if(data.code === 2001) {
              Console.error('Servers error!');
            }
            
            self.client.init(data.host, data.port, null, function():void {
              self.client.request("connector.entryHandler.entry", {
                token: token
              }, function(data:Object):void {
                var player:Object = data.player;
                
                self.world.currentArea = new Area();
                self.world.currentArea.id = player.areaId;
                
                self.client.request("area.playerHandler.enterScene", {
                  uid: null,
                  playerId: player.id,
                  areaId: player.areaId
                }, function(data:Object):void {
                  if(data.code != 200) {
                    Console.error('Error receiving world data after entering scene');
                  }
                  
                  if(data.error) {
                    Console.error('Duplicate username');
                  }
                  
                  var data:Object = data.data;
                  
                  self.world.player.x = data.curPlayer.x;
                  self.world.player.y = data.curPlayer.y;
                  self.world.player.kind.id = data.curPlayer.kindId;
                  
                  Console.log(data.curPlayer.kindId);
                  
                  self.world.repositionCamera();
                  // data.data.curPlayer.id
                  //  areaId
                  //  attackSpeed
                  //  attackValue
                  //  bag
                  //    domain
                  /*
                  id
                  itemCount
                  items: {}
                  characterData
                  attackSpeed
                  attackValue
                  baseExp
                  defenceValue
                  dodgeRate
                  englishName
                  hitRate
                  hp
                  id
                  level
                  mp
                  name
                  upgradeParam
                  walkSpeed
                  curTasks: []
                  defenceValue
                  dodgeRate
                  entityId
                  equipments
                  amulet
                  armor
                  belt
                  domain
                  helmet
                  id
                  legguards
                  necklace
                  playerId
                  ring
                  shoes
                  weapon
                  experience
                  
                  
                  */
                  //  maxHp
                  // data.area.entities
                  
                  self.world.scene.data = data.mapData;
                  
                  self.addEntities(data.area.entities);
                });
              });
            });
          });
        });
      });
    }
  }
}