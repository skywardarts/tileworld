package tileworld.ui.editor.screens {
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
    
    import tileworld.ui.editor.settings.MainSettings;
    import tileworld.core.World;
    
    [Event(name="complete", type="starling.events.Event")]
    
    public class MainScreen extends Screen {
        public var settings:MainSettings;
        private var _list:List;
        private var _header:Header;
        private var _backButton:Button;
        private var _buttonGroup:ButtonGroup;
        
        public function MainScreen(properties:Object = null):void {
            super();
        }
        
        override protected function initialize():void {
            
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
            this._buttonGroup.x = (this.actualWidth - this._buttonGroup.width) - 20;
            this._buttonGroup.y = 20;
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
            
        }
    }
}
