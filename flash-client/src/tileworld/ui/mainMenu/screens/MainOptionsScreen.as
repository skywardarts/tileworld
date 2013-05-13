package tileworld.ui.mainMenu.screens {
  import feathers.controls.Button;
  import feathers.controls.ButtonGroup;
  import feathers.controls.Header;
  import feathers.controls.Screen;
  import feathers.data.ListCollection;
  import feathers.system.DeviceCapabilities;
  
  import flash.net.URLRequest;
  import flash.net.navigateToURL;
  
  import starling.core.Starling;
  import starling.display.DisplayObject;
  import starling.events.Event;
  
  import tileworld.ui.mainMenu.settings.MainOptionsSettings;
  
  [Event(name="complete", type="starling.events.Event")]
  [Event(name="chooseServer", type="starling.events.Event")]

  public class MainOptionsScreen extends Screen {
    public static const CHOOSE_SERVER:String = "chooseServer";
  
    public var settings:MainOptionsSettings;
  
    private var _header:Header;
    private var _backButton:Button;
    private var _buttonGroup:ButtonGroup;
    private var properties:Object;
    
    public function MainOptionsScreen(properties:Object = null) {
        this.properties = properties;
        super();
    }

    override protected function initialize():void {
      this._buttonGroup = new ButtonGroup();
      this._buttonGroup.dataProvider = new ListCollection([
        { label: "Return to Tile World", triggered: button_triggeredHandler },
        { label: "Choose Server", triggered: button_triggeredHandler },
        { label: "Community", triggered: button_triggeredHandler },
        { label: "Help/Guide", triggered: button_triggeredHandler },
        { label: "Sign Out", triggered: button_triggeredHandler },
        { label: "Exit", triggered: button_triggeredHandler }
      ]);

      this.addChild(this._buttonGroup);

      this._header = new Header();
      this._header.title = "Main Menu";
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
    }

    private function onBackButton():void {
      this.dispatchEventWith(Event.COMPLETE);
    }

    private function backButton_triggeredHandler(event:Event):void {
      this.onBackButton();
    }

    private function button_triggeredHandler(event:Event):void {
      const button:Button = Button(event.currentTarget);
      
      if(button.label === 'Return to Tile World') {
        this.settings.world.mainMenuUI.hide();
      }
      else if(button.label === 'Choose Server') {
       this.dispatchEventWith(CHOOSE_SERVER);
      }
      else if(button.label === 'Community') {
        navigateToURL(new URLRequest("http://community.stokegames.com/tileworld"), '_blank');
      }
      else if(button.label === 'Help/Guide') {
        navigateToURL(new URLRequest("http://stokegames.com/tileworld/help"), '_blank');
      }
      else if(button.label === 'Exit') {
        navigateToURL(new URLRequest("https://facebook.com"), '_self');
      }
    }
  }
}