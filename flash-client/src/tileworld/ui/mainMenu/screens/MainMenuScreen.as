package tileworld.ui.mainMenu.screens {
  import feathers.controls.Header;
  import feathers.controls.List;
  import feathers.controls.Screen;
  import feathers.controls.ScreenNavigatorItem;
  import feathers.data.ListCollection;
  import feathers.skins.StandardIcons;
  import feathers.system.DeviceCapabilities;
  
  import starling.core.Starling;
  import starling.events.Event;
  import starling.textures.Texture;
  
  import tileworld.ui.mainMenu.settings.MainMenuSettings;

  [Event(name="complete", type="starling.events.Event")]
  [Event(name="showButton", type="starling.events.Event")]
  [Event(name="showButtonGroup", type="starling.events.Event")]
  [Event(name="showCallout", type="starling.events.Event")]
  [Event(name="showGroupedList", type="starling.events.Event")]
  [Event(name="showList", type="starling.events.Event")]
  [Event(name="showPageIndicator", type="starling.events.Event")]
  [Event(name="showPickerList", type="starling.events.Event")]
  [Event(name="showProgressBar", type="starling.events.Event")]
  [Event(name="showScrollText", type="starling.events.Event")]
  [Event(name="showSlider", type="starling.events.Event")]
  [Event(name="showTabBar", type="starling.events.Event")]
  [Event(name="showTextInput", type="starling.events.Event")]
  [Event(name="showToggles", type="starling.events.Event")]

  public class MainMenuScreen extends Screen {
    public static const SHOW_MAIN_MENU_OPTIONS:String = "showMainMenuOptions";
    public static const SHOW_OPTIONS:String = "showOptions";
    public static const SHOW_CALLOUT:String = "showCallout";
    public static const SHOW_GROUPED_LIST:String = "showGroupedList";
    public static const SHOW_LIST:String = "showList";
    public static const SHOW_PAGE_INDICATOR:String = "showPageIndicator";
    public static const SHOW_PICKER_LIST:String = "showPickerList";
    public static const SHOW_PROGRESS_BAR:String = "showProgressBar";
    public static const SHOW_SCROLL_TEXT:String = "showScrollText";
    public static const SHOW_SLIDER:String = "showSlider";
    public static const SHOW_TAB_BAR:String = "showTabBar";
    public static const SHOW_TEXT_INPUT:String = "showTextInput";
    public static const SHOW_TOGGLES:String = "showToggles";
    
    public var settings:MainMenuSettings;
    
    private var _header:Header;
    private var _list:List;
    private var properties:Object;
    
    public function MainMenuScreen(properties:Object) {
        this.properties = properties;
        super();
    }
    
    override protected function initialize():void {
      this._header = new Header();
      this._header.title = "Tile World";
      this.addChild(this._header);

      this._list = new List();
      
      if(this.properties.world.isEditor) {
          this._list.dataProvider = new ListCollection([
              { label: "Main Menu", event: SHOW_MAIN_MENU_OPTIONS },
              { label: "Options", event: SHOW_OPTIONS },
              { label: "Callout", event: SHOW_CALLOUT },
              { label: "Help", event: SHOW_GROUPED_LIST },
              { label: "List", event: SHOW_LIST },
              { label: "Page Indicator", event: SHOW_PAGE_INDICATOR },
              { label: "Picker List", event: SHOW_PICKER_LIST },
              { label: "Progress Bar", event: SHOW_PROGRESS_BAR },
              { label: "Scroll Text", event: SHOW_SCROLL_TEXT },
              { label: "Slider", event: SHOW_SLIDER},
              { label: "Tab Bar", event: SHOW_TAB_BAR },
              { label: "Text Input", event: SHOW_TEXT_INPUT },
              { label: "Toggles", event: SHOW_TOGGLES },
          ]);
      }
      else {
          this._list.dataProvider = new ListCollection([
              { label: "Main Menu", event: SHOW_MAIN_MENU_OPTIONS },
              { label: "Options", event: SHOW_OPTIONS }
          ]);
      }

      this._list.addEventListener(Event.CHANGE, list_changeHandler);
      this._list.itemRendererProperties.labelField = "label";

      if(!DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
        this._list.itemRendererProperties.accessorySourceFunction = accessorySourceFunction;
      }
      else {
        this._list.selectedIndex = 0;
      }

      this.addChild(this._list);
    }
    
    override protected function draw():void {
      this._header.width = this.actualWidth;
      this._header.validate();

      this._list.y = this._header.height;
      this._list.width = this.actualWidth;
      this._list.height = this.actualHeight - this._list.y;
    }

    private function accessorySourceFunction(item:Object):Texture {
      return StandardIcons.listDrillDownAccessoryTexture;
    }
    
    private function list_changeHandler(event:Event):void {
      const eventType:String = this._list.selectedItem.event as String;
      this.dispatchEventWith(eventType);
    }
  }
}