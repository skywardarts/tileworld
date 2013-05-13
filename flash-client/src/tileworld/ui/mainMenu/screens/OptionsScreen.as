package tileworld.ui.mainMenu.screens {
  import feathers.controls.Button;
  import feathers.controls.ButtonGroup;
  import feathers.controls.Header;
  import feathers.controls.List;
  import feathers.controls.Screen;
  import feathers.data.ListCollection;
  import feathers.system.DeviceCapabilities;
  
  import starling.core.Starling;
  import starling.display.DisplayObject;
  import starling.events.Event;
  
  import tileworld.ui.mainMenu.settings.OptionsSettings;
  import tileworld.core.World;

  [Event(name="complete", type="starling.events.Event")]

  public class OptionsScreen extends Screen {
      public var settings:OptionsSettings;
      private var _list:List;
      private var _header:Header;
      private var _backButton:Button;
      private var _buttonGroup:ButtonGroup;
      
    public function OptionsScreen(properties:Object = null):void {
      super();
    }

    override protected function initialize():void {
      var items:Array = [];
      
      var options:Array = [{
        title: 'Game'
      }, {
        title: 'Sound'
      }, {
        title: 'Graphics'
      }, {
        title: 'Network'
      }];
      
      for(var i:int = 0, l:int = options.length; i < l; ++i) {
        var option:Object = options[i];
        var item:Object = {text: option.title};
        items.push(item);
      }
      
      items.fixed = true;
      
      this._list = new List();
      this._list.dataProvider = new ListCollection(items);
      this._list.typicalItem = {text: "?"};
      this._list.isSelectable = this.settings.isSelectable;
      this._list.scrollerProperties.hasElasticEdges = this.settings.hasElasticEdges;
      this._list.itemRendererProperties.labelField = "text";
      this._list.addEventListener(Event.CHANGE, list_changeHandler);
      this.addChildAt(this._list, 0);
      
      this._buttonGroup = new ButtonGroup();
      this._buttonGroup.dataProvider = new ListCollection([
        { label: "Show performance monitor", triggered: button_triggeredHandler },
        { label: "Hide minimap", triggered: button_triggeredHandler }
      ]);
      
      this.addChild(this._buttonGroup);

      this._header = new Header();
      this._header.title = "Options";
      this.addChild(this._header);

      if(!DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
        this._backButton = new Button();
        this._backButton.label = "Back";
        this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

        this._header.leftItems = new <DisplayObject> [
          this._backButton
        ];
      }

      // handles the back hardware key on android
      this.backButtonHandler = this.onBackButton;
    }

    override protected function draw():void {
      this._header.width = this.actualWidth;
      this._header.validate();

      this._buttonGroup.validate();
      this._buttonGroup.x = (this.actualWidth - this._buttonGroup.width) / 2;
      this._buttonGroup.y = this._header.height + (this.actualHeight - this._header.height - this._buttonGroup.height) / 2;
      
      
      this._list.y = this._header.height;
      this._list.width = 140;
      this._list.height = this.actualHeight - this._list.y;
    }
    
    private function list_changeHandler(event:Event):void {
      trace("List onChange:", this._list.selectedIndex, event);
    }

    private function onBackButton():void {
      this.dispatchEventWith(Event.COMPLETE);
    }

    private function backButton_triggeredHandler(event:Event):void {
      this.onBackButton();
    }

    private function button_triggeredHandler(event:Event):void {
      const button:Button = Button(event.currentTarget);
      
      if(button.label == 'Show performance monitor') {
        this.settings.world.debugUI.showPerformance();
        button.label = 'Hide performance monitor';
      }
      else if(button.label == 'Hide performance monitor') {
          this.settings.world.debugUI.hidePerformance();
        button.label = 'Show performance monitor';
      }
      else if(button.label == 'Hide minimap') {
          this.settings.world.settings.game.minimap_enabled = false;
          this.settings.world.gameUI.hideMinimap();
          button.label = 'Show minimap';
      }
      else if(button.label == 'Show minimap') {
          this.settings.world.settings.game.minimap_enabled = true;
          button.label = 'Hide minimap';
      }
    }
  }
}
