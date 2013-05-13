package tileworld.core {
  import citrus.core.CitrusEngine;
  import citrus.core.CitrusObject;
  import citrus.core.State;
  import citrus.core.starling.StarlingState;
  import citrus.input.InputController;
  import citrus.math.MathUtils;
  import citrus.math.MathVector;
  import citrus.objects.NapePhysicsObject;
  import citrus.objects.platformer.nape.Coin;
  import citrus.objects.platformer.nape.Enemy;
  import citrus.objects.platformer.nape.Hero;
  import citrus.objects.platformer.nape.Platform;
  import citrus.physics.box2d.Box2D;
  import citrus.physics.nape.Nape;
  import citrus.view.ACitrusView;
  import citrus.view.blittingview.BlittingArt;
  import citrus.view.blittingview.BlittingView;
  import citrus.view.starlingview.AnimationSequence;
  import citrus.view.starlingview.StarlingArt;
  import citrus.view.starlingview.StarlingView;
  
  import com.netease.pomelo.Client;
  import com.netease.pomelo.events.ClientEvent;
  
  import feathers.controls.Button;
  import feathers.controls.Callout;
  import feathers.controls.Label;
  import feathers.controls.ScreenNavigator;
  import feathers.controls.ScreenNavigatorItem;
  import feathers.controls.ScrollContainer;
  import feathers.controls.Scroller;
  import feathers.layout.AnchorLayout;
  import feathers.layout.AnchorLayoutData;
  import feathers.layout.TiledColumnsLayout;
  import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
  import feathers.system.DeviceCapabilities;
  import feathers.themes.MetalWorksMobileTheme;
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.display.MovieClip;
  import flash.display.Shape;
  import flash.events.MouseEvent;
  import flash.filters.DropShadowFilter;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.ui.Keyboard;
  
  import juice.utils.AssetManager;
  
  import nape.geom.Vec2;
  
  import starling.core.Starling;
  import starling.display.BlendMode;
  import starling.display.Image;
  import starling.display.Quad;
  import starling.display.QuadBatch;
  import starling.display.Sprite;
  import starling.events.EnterFrameEvent;
  import starling.events.Event;
  import starling.events.ResizeEvent;
  import starling.text.TextField;
  import starling.textures.Texture;
  import starling.textures.TextureAtlas;
  import starling.utils.Color;
  import starling.utils.deg2rad;
  
  import tileworld.core.Scene;
  import tileworld.networks.facebook.FacebookNetwork;
  import tileworld.objects.Entity;
  import tileworld.objects.Player;
  import tileworld.objects.Tile;
  import tileworld.servers.StokeServer;
  import tileworld.ui.debug.DebugUI;
  import tileworld.ui.editor.EditorUI;
  import tileworld.ui.game.GameUI;
  import tileworld.ui.mainMenu.MainMenuUI;
  import tileworld.ui.mainMenu.screens.ConsoleScreen;
  import tileworld.utils.Console;
  import tileworld.utils.Runtime;
  import tileworld.core.Chat;
  
  public class World extends StarlingState {
    [Embed(source="assets/tiles/blue.png")]
    private var tileBlue:Class;
    
    [Embed(source="assets/tiles/red.png")]
    private var tileRed:Class;
    
    [Embed(source="assets/tiles/blocked.png")]
    private var tileBlocked:Class;
    
    [Embed(source="assets/map/bg.png")]
    private var mapBG:Class;
    
    [Embed(source="assets/ui/logo.jpg")]
    private var uiLogo:Class;
    
    [Embed(source="assets/ui/main-bg.png")]
    private var uiMainBG:Class;
    
    public var network:FacebookNetwork;
    public var assets:AssetManager;
    public var currentArea:Area;
    public var areas:Array;
    public var scene:Scene;
    public var engine:Engine;
    public var server:StokeServer;
    public var theme:MetalWorksMobileTheme;
    public var mainMenuUI:MainMenuUI;
    public var gameUI:GameUI;
    public var debugUI:DebugUI;
    public var editorUI:EditorUI;
    public var player:Player;
    public var isEditor:Boolean;
    public var ui:Array;
    public var activeUI:String;
    public var chat:Chat;
    
    public var settings:Object = {
       game: {
           minimap_enabled: true
       }
    };
    
    public function World(engine:Engine):void {
      super();
      
      this.engine = engine;
      
      this.scene = new Scene(this);
      this.server = new StokeServer(this);
      this.network = new FacebookNetwork(this);
      this.mainMenuUI = new MainMenuUI(this);
      this.editorUI = new EditorUI(this);
      this.gameUI = new GameUI(this);
      this.debugUI = new DebugUI(this);
      this.chat = new Chat(this);
      
      this.ui = new Array();
      this.ui['mainMenu'] = this.mainMenuUI;
      this.ui['game'] = this.gameUI;
      this.ui['editor'] = this.editorUI;
      this.ui['debug'] = this.debugUI;
      
      this.isEditor = (this.engine.currentUrl.indexOf('file://') === -1) ? false : true;
      
      this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
    }
    
    private function addedToStageHandler(event:Event):void {
      var self:World = this;

      this.mainMenuUI.setup();
      this.scene.setup();
      this.setupConsole();
      this.connectToFacebook();
      
      if(this.isEditor) {
          this.setupConsole();
          this.editorUI.setup();
      }
    }
    
    public function setupConsole():void {
      var self:World = this;
      
      Console.getInstance().onMessage.add(function(message:String):void {
        ConsoleScreen.content.text += message + "\n";
        ConsoleScreen.content.verticalScrollPosition = ConsoleScreen.content.maxVerticalScrollPosition;
      });
    }
    
    public function connectToFacebook():void {
      this.network.connect();
    }
    
    public function connectToServer():void {
      this.server.connect();
    }
    
    public function getCurrentArea():Area {
      return this.currentArea;
    }
    
    public function setActiveUI(name:String):void {
        Console.log('Setting active UI to: ', name);
        
        if(this.activeUI) {
            this.ui[this.activeUI].hide();
        }
        
        this.activeUI = name;
        
        if(name === 'none') {
            this.activeUI = null;
            return;
        }
        
        this.ui[name].show();
    }
    
    public function setupSize(width:int, height:int):void {
      add(new Platform("top border", {x: 0, y: -1, width: width, height: 1}));
      add(new Platform("right border", {x: width + 1, y: 0, width: 1, height: height}));
      add(new Platform("bottom border", {x: 0, y: height + 1, width: width, height: 1}));
      add(new Platform("left border", {x: -1, y: 0, width: 1, height: height}));
    }
    
    public function start():void {
      var self:World = this;
      
      var physics:Nape = new Nape("box2d", {gravity: new Vec2(0, 0)});
      //physics.visible = true;
      add(physics);
      
      this.setupSize(1000000, 1000000);
      
      this.player = new Player("hero", {
          x: 1000, y: 1000, 
          width: 18, height: 18, 
          world: self
      });
      this.player.kind.id = 210;
      this.player.init(this.assets);
      
      add(this.player);
      
      //this.player.onGiveDamage.add(heroAttack);
      //this.player.onTakeDamage.add(heroHurt);
      this.player.onPlaceTile.add(heroPlaceTile);
      
      this.view.setupCamera(this.player, new MathVector(380, 400), new Rectangle(-380, -400, 10000000, 10000000), new MathVector(1, 1));
      
      var tx:Texture = self.assets.getTexture("map/bg");
      tx.repeat = true;
      var bg:Image = new Image(tx);
      bg.blendMode = BlendMode.NONE;
      bg.touchable = false;
      bg.width = this.stage.stageWidth;
      bg.height = this.stage.stageHeight;
      
      var scale:Number = 512;
      //compressedTexture.repeat = true;
      bg.setTexCoords(1, new Point(scale, 0));
      bg.setTexCoords(2, new Point(0, scale));
      bg.setTexCoords(3, new Point(scale, scale));
      
      this.addChild(bg);
      this.setChildIndex(bg, 100);
      
      this.setChildIndex(this.scene._container, 101);
      
      var s:StarlingView = this.view as StarlingView;
      this.setChildIndex(s.viewRoot, 201);
      
      var uiMainBG:Image = new Image(self.assets.getTexture('ui/main-bg'));
      uiMainBG.blendMode = BlendMode.NORMAL;
      uiMainBG.touchable = false;
      
      
      var uiLogo:Image = new Image(self.assets.getTexture('ui/logo'));
      uiLogo.blendMode = BlendMode.NORMAL;
      uiLogo.touchable = false;
      
      var mapContainer:Sprite = new Sprite();
      mapContainer.touchable = false;
      mapContainer.addChild(uiMainBG);
      mapContainer.addChild(uiLogo);
      
      this.addChild(mapContainer);
      
      this.setChildIndex(mapContainer, 300);
      
      this.addEventListener(Event.ENTER_FRAME, frame);
    }
    
    override public function initialize():void {
      var self:World = this;

      super.initialize();
      
      assets = new AssetManager();
      assets.verbose = true;
      
      assets.enqueue(World);
      
      //assets.enqueue("http://gamua.com/img/home/starling-flying.jpg");
      
      assets.addBitmap("tiles/blue", new tileBlue());
      assets.addBitmap("tiles/red", new tileRed());
      assets.addBitmap("tiles/blocked", new tileBlocked());
      assets.addTexture("tiles/red", Texture.fromBitmap(assets.getBitmap("tiles/red")));
      assets.addTexture("tiles/blue", Texture.fromBitmap(assets.getBitmap("tiles/blue")));
      assets.addTexture("tiles/blocked", Texture.fromBitmap(assets.getBitmap("tiles/blocked")));
      assets.addTexture("ui/main-bg", Texture.fromBitmap(new uiMainBG()));
      assets.addTexture("ui/logo", Texture.fromBitmap(new uiLogo()));
      assets.addTexture("map/bg", Texture.fromBitmap(new mapBG()));
      
      self.gameUI.showLoading();
      
      assets.loadQueue(function(ratio:Number):void {
        Console.log("Loading assets, progress:", ratio);
        
        if(ratio == 1.0 || isNaN(ratio)) {
          self.gameUI.hideLoading();
          
          self.start();
          self.startUI();
          self.connectToServer();
          self.chat.initialize();
        }
      });
    }
    
    public function startUI():void {
        var self:World = this;
        
        if(self.isEditor) {
            self.setActiveUI('editor');
        }
        else {
            //self.setActiveUI('mainMenu');
        }
    }
  
    public var hotkeyTimer:Number = 0;
    
    public function isDoingHotkey(name:String):Boolean {
      var now:Number = new Date().valueOf();
      
      if(this.engine.input.isDoing(name) && this.hotkeyTimer < now) {
        this.hotkeyTimer = now + (1 * 400);
        
        return true;
      }
      
      return false;
    }

    private function frame(e:EnterFrameEvent):void {
      if(this.isDoingHotkey('escape')) {
        if(this.activeUI == 'mainMenu') {
            this.setActiveUI('none');
            
            if(this.isEditor) {
              this.setActiveUI('editor');
            }
        }
        else {
            this.setActiveUI('mainMenu');
        }
      }
      
      if(this.engine.input.isDoing('control') && this.engine.input.isDoing('tilde')) {
        // show/hide console
        Console.log('sssss');
      }
    }
    
    public function extractName(url:String):String {
      url = url.replace(/%20/g, " "); // URLs use '%20' for spaces
      var matches:Array = /(.*[\\\/])?(.+)(\.[\w]{1,4})/.exec(url);
      
      if (matches && matches.length == 4) return matches[2];
      else throw new ArgumentError("Could not extract name from url '" + url + "'");
    }
    
    private function heroPlaceTile():void {
      var self:World = this;
      
      self.server.client.request("area.playerHandler.placeTile", {
        tile: {
          id: 1
        },
        x: 0,
        y: 0
      }, function(data:Object):void {
        
      });
    }
    
    private function heroHurt():void {
      //this.engine.sound.playSound("Hurt", 1, 0);
    }
    
    private function heroAttack():void {
      //this.engine.sound.playSound("Death", 1, 0);
    }
    
    private var updateMinimapTimer:Number = 0;
    private var updateSceneTimer:Number = 0;
    
    public function resetStaticTiles():void {
      this.scene.staticMap.reset();
    }
    
    override public function update(timeDelta:Number):void {
      var self:World = this;
      
      super.update(timeDelta);
      
      var now:Number = new Date().valueOf();
      
      if(this.currentArea && this.updateMinimapTimer < now) {
        this.updateMinimapTimer = now + (1 * 200);

        if(this.settings.game.minimap_enabled) {
          self.gameUI.updateMinimap();
        }
      }
      
      if(this.currentArea && this.updateSceneTimer < now) {
          this.updateSceneTimer = now + (1 * 10);
          
          if(self.scene.data) {
              self.processTiles();
              self.repositionStaticMap();
          }
      }
    }
    
    public function repositionCamera():void {
      //  var cameraOffsetX:int = player.x - (stage.stageWidth / 2) + 1;
      //  var cameraOffsetY:int = player.y - (stage.stageHeight / 2) - 2;
      //this.view.camera.manualPosition = new Point(cameraOffsetX, cameraOffsetY);  
    }
    
    public function repositionStaticMap():void {
        var self:World = this;
        var cameraOffsetX:int = player.x - 380 + 1;
        var cameraOffsetY:int = player.y - 400 - 2;
        
        self.scene._container.x = -cameraOffsetX;
        self.scene._container.y = -cameraOffsetY;
    }
    
    public function processTiles():void {
      var self:World = this;
      
      self.scene.staticMap.reset();
      
      var tileWidth:int = 18;
      var tileHeight:int = 18;
      var cameraOffsetX:int = player.x - (stage.stageWidth / 2);
      var cameraOffsetY:int = player.y - (stage.stageHeight / 2);
      var stageMinX:int = cameraOffsetX / tileWidth;
      var stageMaxX:int = (cameraOffsetX + stage.stageWidth) / tileWidth;
      var stageMinY:int = cameraOffsetY / tileHeight;
      var stageMaxY:int = (cameraOffsetY + stage.stageHeight) / tileHeight;
      
      var mapDataMaxX:int = self.scene.data.mapWeight / self.scene.data.tileW;
      var mapDataMaxY:int = self.scene.data.mapHeight / self.scene.data.tileH;
      
      // bound compensation
      if(stageMinX < 0)
        stageMinX = 0;
      
      if(stageMaxX < 0)
        stageMaxX = 0;
      
      if(stageMinY < 0)
        stageMinY = 0;
      
      if(stageMaxY < 0)
        stageMaxY = 0;
      
      if(stageMinX > mapDataMaxX)
        stageMinX = mapDataMaxX;
      
      if(stageMaxX > mapDataMaxX)
        stageMaxX = mapDataMaxX;
      
      if(stageMinY > mapDataMaxY)
        stageMinY = mapDataMaxY;
      
      if(stageMaxY > mapDataMaxY)
        stageMaxY = mapDataMaxY;
      
      //this.staticTiles = [];
      
      var blockedTile:Image = new Image(self.assets.getTexture("tiles/blocked"));
      blockedTile.blendMode = BlendMode.NORMAL;
      blockedTile.touchable = false;
      
      for(var x:int = stageMinX, width:int = stageMaxX; x < width; ++x) {
        for(var y:int = stageMinY, height:int = stageMaxY; y < height; ++y) {
          var xPosition:Number = (x) * 18;
          var yPosition:Number = (y) * 18;
          var tileIndex:int = (y * mapDataMaxX) + x;
          
          // check tile cache
          if(self.scene.staticTiles[tileIndex] !== undefined) {
            var tile:Tile = self.scene.staticTiles[tileIndex] as Tile;
            
            tile.view.x = xPosition;
            tile.view.y = yPosition;
            
            self.scene.staticMap.addImage(tile.view);
          }
          else {
            if(self.scene.data.weightMap[x][y] === 1) {
              // passable
            }
            else if(self.scene.data.weightMap[x][y] === null) {
              // blocked
              
              //blockedTile.removeFromParent(false);
              
              self.scene.staticMap.addImage(blockedTile);
              
              // caching
              self.scene.staticTiles[tileIndex] = new Tile('tile', {x: x * 18, y: y * 18, view: blockedTile});
            }
            else {
              Console.error('Unknown block type: ', self.scene.data.weightMap[x][y]);
            }
          }
          
          // todo: cull tiles at a far distance on a timer
        }
      }
    }
  }
}