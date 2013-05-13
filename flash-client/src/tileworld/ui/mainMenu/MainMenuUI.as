package tileworld.ui.mainMenu {
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
  import tileworld.ui.mainMenu.screens.MainMenuScreen;
  import tileworld.ui.mainMenu.screens.MainOptionsScreen;
  import tileworld.ui.mainMenu.screens.GameSettingsScreen;
  import tileworld.ui.mainMenu.screens.GraphicsSettingsScreen;
  import tileworld.ui.mainMenu.screens.NetworkSettingsScreen;
  import tileworld.ui.mainMenu.screens.OptionsScreen;
  import tileworld.ui.mainMenu.screens.SoundSettingsScreen;
  import tileworld.ui.mainMenu.settings.MainMenuSettings;
  import tileworld.ui.mainMenu.settings.MainOptionsSettings;
  import tileworld.ui.mainMenu.settings.OptionsSettings;
  import tileworld.ui.screens.ButtonScreen;
  import tileworld.ui.screens.ButtonSettingsScreen;
  import tileworld.ui.screens.CalloutScreen;
  import tileworld.ui.screens.GroupedListScreen;
  import tileworld.ui.screens.GroupedListSettingsScreen;
  import tileworld.ui.screens.ListScreen;
  import tileworld.ui.screens.ListSettingsScreen;
  import tileworld.ui.screens.PageIndicatorScreen;
  import tileworld.ui.screens.PickerListScreen;
  import tileworld.ui.screens.ProgressBarScreen;
  import tileworld.ui.screens.ScrollTextScreen;
  import tileworld.ui.screens.SliderScreen;
  import tileworld.ui.screens.SliderSettingsScreen;
  import tileworld.ui.screens.TabBarScreen;
  import tileworld.ui.screens.TextInputScreen;
  import tileworld.ui.screens.ToggleScreen;
  import tileworld.ui.settings.GroupedListSettings;
  import tileworld.ui.settings.ListSettings;
  import tileworld.ui.settings.SliderSettings;

  public class MainMenuUI {
    private static const MAIN_MENU:String = "mainMenu";
    private static const MAIN_OPTIONS:String = "mainOptions";
    private static const OPTIONS:String = "options";
    private static const GRAPHICS_SETTINGS:String = "graphicsSettings";
    private static const SOUND_SETTINGS:String = "soundSettings";
    private static const GAME_SETTINGS:String = "gameSettings";
    private static const NETWORK_SETTINGS:String = "networkSettings";
    
    private static const BUTTON_SETTINGS:String = "buttonSettings";
    private static const BUTTON_GROUP:String = "buttonGroup";
    private static const CALLOUT:String = "callout";
    private static const GROUPED_LIST:String = "groupedList";
    private static const GROUPED_LIST_SETTINGS:String = "groupedListSettings";
    private static const LIST:String = "list";
    private static const LIST_SETTINGS:String = "listSettings";
    private static const PAGE_INDICATOR:String = "pageIndicator";
    private static const PICKER_LIST:String = "pickerList";
    private static const PROGRESS_BAR:String = "progressBar";
    private static const SCROLL_TEXT:String = "scrollText";
    private static const SLIDER:String = "slider";
    private static const SLIDER_SETTINGS:String = "sliderSettings";
    private static const TAB_BAR:String = "tabBar";
    private static const TEXT_INPUT:String = "textInput";
    private static const TOGGLES:String = "toggles";
    
    private var _navigator:ScreenNavigator;
    private var _menu:MainMenuScreen;
    private var _transitionManager:ScreenSlidingStackTransitionManager;
    private var _container:ScrollContainer;
    public var theme:MetalWorksMobileTheme;
    public var world:World;

    private static const EVENTS:Object = {
      showMainMenu: MAIN_MENU,
      showMainOptions: MAIN_OPTIONS,
      showOptions: OPTIONS,
      showGraphicsSettings: GRAPHICS_SETTINGS,
      showSoundSettings: SOUND_SETTINGS,
      showNetworkSettings: NETWORK_SETTINGS,
      showGameSettings: GAME_SETTINGS,
      showCallout: CALLOUT,
      showGroupedList: GROUPED_LIST,
      showList: LIST,
      showPageIndicator: PAGE_INDICATOR,
      showPickerList: PICKER_LIST,
      showProgressBar: PROGRESS_BAR,
      showScrollText: SCROLL_TEXT,
      showSlider: SLIDER,
      showTabBar: TAB_BAR,
      showTextInput: TEXT_INPUT,
      showToggles: TOGGLES
    };

    public function MainMenuUI(world:World):void {
      this.world = world;
      this.world.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
    }
    
    private function mainMenuEventHandler(event:Event):void {
      trace('mainemeeee');
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
      var self:MainMenuUI = this;
      
      this.theme = new MetalWorksMobileTheme(this.world.stage);
      
      this.world.stage.addEventListener(ResizeEvent.RESIZE, this.resizeStageHandler);
      
      this._navigator = new ScreenNavigator();
      
      const mainMenuSettings:MainMenuSettings = new MainMenuSettings(this.world);

      this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, {
        complete: MAIN_MENU,
        showSettings: MAIN_OPTIONS,
        chooseServer: function():void {
          self.world.connectToServer();
          self.hide();
        }
      }, {
        settings: mainMenuSettings
      }));
      
      const mainOptionsSettings:MainOptionsSettings = new MainOptionsSettings(this.world);
      
      this._navigator.addScreen(MAIN_OPTIONS, new ScreenNavigatorItem(MainOptionsScreen, {
        complete: MAIN_MENU,
        chooseServer: function():void {
          self.world.connectToServer();
          self.hide();
        }
      }, {
          settings: mainOptionsSettings
      }));
      
      const optionsSettings:OptionsSettings = new OptionsSettings(this.world);
      
      this._navigator.addScreen(OPTIONS, new ScreenNavigatorItem(OptionsScreen, {
          complete: MAIN_MENU
      }, {
          settings: optionsSettings
      }));
      
      if(this.world.isEditor) {
          
          this._navigator.addScreen(CALLOUT, new ScreenNavigatorItem(CalloutScreen, {
            complete: MAIN_MENU
          }));
          
          this._navigator.addScreen(SCROLL_TEXT, new ScreenNavigatorItem(ScrollTextScreen, {
            complete: MAIN_MENU
          }));
          
          const sliderSettings:SliderSettings = new SliderSettings();
    
          this._navigator.addScreen(SLIDER, new ScreenNavigatorItem(SliderScreen, {
            complete: MAIN_MENU,
            showSettings: SLIDER_SETTINGS
          }, {
            settings: sliderSettings
          }));
          
          this._navigator.addScreen(SLIDER_SETTINGS, new ScreenNavigatorItem(SliderSettingsScreen, {
            complete: SLIDER
          }, {
            settings: sliderSettings
          }));
          
          this._navigator.addScreen(TOGGLES, new ScreenNavigatorItem(ToggleScreen, {
            complete: MAIN_MENU
          }));
          
          const groupedListSettings:GroupedListSettings = new GroupedListSettings();
    
          this._navigator.addScreen(GROUPED_LIST, new ScreenNavigatorItem(GroupedListScreen, {
            complete: MAIN_MENU,
            showSettings: GROUPED_LIST_SETTINGS
          }, {
            settings: groupedListSettings
          }));
          
          this._navigator.addScreen(GROUPED_LIST_SETTINGS, new ScreenNavigatorItem(GroupedListSettingsScreen, {
            complete: GROUPED_LIST
          }, {
            settings: groupedListSettings
          }));
          
          const listSettings:ListSettings = new ListSettings();
    
          this._navigator.addScreen(LIST, new ScreenNavigatorItem(ListScreen, {
            complete: MAIN_MENU,
            showSettings: LIST_SETTINGS
          }, {
            settings: listSettings
          }));
          
          this._navigator.addScreen(LIST_SETTINGS, new ScreenNavigatorItem(ListSettingsScreen, {
            complete: LIST
          }, {
            settings: listSettings
          }));
          
          this._navigator.addScreen(PAGE_INDICATOR, new ScreenNavigatorItem(PageIndicatorScreen, {
            complete: MAIN_MENU
          }));
          
          this._navigator.addScreen(PICKER_LIST, new ScreenNavigatorItem(PickerListScreen, {
            complete: MAIN_MENU
          }));
          
          this._navigator.addScreen(TAB_BAR, new ScreenNavigatorItem(TabBarScreen, {
            complete: MAIN_MENU
          }));
          
          this._navigator.addScreen(TEXT_INPUT, new ScreenNavigatorItem(TextInputScreen, {
            complete: MAIN_MENU
          }));
          
          this._navigator.addScreen(PROGRESS_BAR, new ScreenNavigatorItem(ProgressBarScreen, {
            complete: MAIN_MENU
          }));
      }
      
      this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator); /**/
      this._transitionManager.duration = 0.4;
      
      if(DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
        this.world.stage.addEventListener(ResizeEvent.RESIZE, this.resizeStageHandler);
        
        this._container = new ScrollContainer();
        this._container.backgroundSkin = new Quad(100, 100, 0x242424);
        this._container.backgroundSkin.alpha = 0.5;
        this._container.layout = new AnchorLayout();
        this._container.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
        this._container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
        
        this._menu = new MainMenuScreen({
          world: this.world
        });

        for(var eventType:String in EVENTS) {
          this._menu.addEventListener(eventType, mainMenuEventHandler);
        }

        this._menu.width = 400 * DeviceCapabilities.dpi / this.theme.originalDPI;

        const menuLayoutData:AnchorLayoutData = new AnchorLayoutData();

        menuLayoutData.top = 0;
        menuLayoutData.bottom = 0;
        menuLayoutData.left = 0;

        this._menu.layoutData = menuLayoutData;
        this._container.addChild(this._menu);
        
        this._navigator.clipContent = true;

        const navigatorLayoutData:AnchorLayoutData = new AnchorLayoutData();

        navigatorLayoutData.top = 0;
        navigatorLayoutData.right = 0;
        navigatorLayoutData.bottom = 0;
        navigatorLayoutData.leftAnchorDisplayObject = this._menu;
        navigatorLayoutData.left = 0;

        this._navigator.layoutData = navigatorLayoutData;
        this._container.addChild(this._navigator);
        
        this._navigator.showScreen(MAIN_OPTIONS);
        
        this.layoutForTablet();
      }
      else {
        this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, EVENTS));
        
        this.world.addChild(this._navigator);
        this._navigator.showScreen(MAIN_MENU);
      }
    }
    
    private function layoutForTablet():void {
      this._container.width = this.world.stage.stageWidth;
      this._container.height = this.world.stage.stageHeight;
    }
  }
}