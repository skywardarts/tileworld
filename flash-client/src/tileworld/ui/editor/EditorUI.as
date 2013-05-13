package tileworld.ui.editor {
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
    
    import starling.core.Starling;
    import starling.events.Event;
    import starling.events.ResizeEvent;
    import starling.display.Quad;
    
    import tileworld.core.World;
    import tileworld.ui.editor.screens.MainScreen;
    import tileworld.ui.editor.screens.ManageEntityScreen;
    import tileworld.ui.editor.settings.MainSettings;
    import tileworld.ui.editor.settings.ManageEntitySettings;
    
    public class EditorUI {
        private static const MAIN:String = "main";
        private static const MANAGE_ENTITY:String = "manageEntity";
        
        public var _navigator:ScreenNavigator;
        private var _transitionManager:ScreenSlidingStackTransitionManager;
        private var _container:ScrollContainer;
        public var theme:MetalWorksMobileTheme;
        public var world:World;
        
        private static const EVENTS:Object = {
            showMain: MAIN,
            showManageEntity: MANAGE_ENTITY
        };
        
        public function EditorUI(world:World):void {
            this.world = world;
            this.world.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
        }
        
        private function mainEventHandler(event:Event):void {
            const screenName:String = EVENTS[event.type];
            //because we're controlling the navigation externally, it doesn't
            //make sense to transition or keep a history
            this._transitionManager.clearStack();
            this._transitionManager.skipNextTransition = true;
            this._navigator.showScreen(screenName);
        }
        
        public function isShown():Boolean {
            return this.world.contains(this._container);
        }
        
        public function hide():void {
            this.world.removeChild(this._container);
            this.world.theme = null;
        }
        
        public function show():void {
            if(this.isShown())
                return; // already shown
            
            this.world.addChild(this._container);
            this.world.theme = this.theme;
        }
        
        public function resize():void {
            this.layoutForTablet();
        }
        
        private function removedFromStageHandler(event:Event):void {
            this.world.stage.removeEventListener(ResizeEvent.RESIZE, this.resizeStageHandler);
        }
        
        private function resizeStageHandler(event:ResizeEvent):void {
            this.resize();
        }
        
        public function setup():void {
            var self:EditorUI = this;
            
            this.theme = new MetalWorksMobileTheme(this.world.stage);
            
            this.world.stage.addEventListener(ResizeEvent.RESIZE, this.resizeStageHandler);
            
            this._navigator = new ScreenNavigator();
            
            const mainSettings:MainSettings = new MainSettings(this.world);
            
            this._navigator.addScreen(MAIN, new ScreenNavigatorItem(MainScreen, {
                complete: MAIN,
                showManageEntity: MANAGE_ENTITY
            }, {
                settings: mainSettings
            }));
            
            this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator); /**/
            this._transitionManager.duration = 0.4;
            
            if(DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
                this.world.stage.addEventListener(ResizeEvent.RESIZE, this.resizeStageHandler);
                
                this._container = new ScrollContainer();
                this._container.layout = new AnchorLayout();
                this._container.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
                this._container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
                
                this._navigator.clipContent = true;
                
                const navigatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
                
                navigatorLayoutData.top = 0;
                navigatorLayoutData.right = 0;
                navigatorLayoutData.bottom = 0;
                navigatorLayoutData.left = 0;
                
                this._navigator.layoutData = navigatorLayoutData;
                this._container.addChild(this._navigator);
                
                //this._navigator.showScreen(MANAGE_ENTITY);
                
                this.layoutForTablet();
            }
            else {
                this._navigator.addScreen(MAIN, new ScreenNavigatorItem(MainScreen, EVENTS));
                
                this.world.addChild(this._navigator);
                this._navigator.showScreen(MAIN);
            }
        }
        
        private function layoutForTablet():void {
            this._container.width = this.world.stage.stageWidth;
            this._container.height = this.world.stage.stageHeight;
        }
    }
}