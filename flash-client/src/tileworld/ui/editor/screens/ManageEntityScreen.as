package tileworld.ui.editor.screens {
    import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.Header;
    import feathers.controls.Label;
    import feathers.controls.List;
    import feathers.controls.Screen;
    import feathers.controls.ScrollText;
    import feathers.controls.TextInput;
    import feathers.data.ListCollection;
    import feathers.system.DeviceCapabilities;
    
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Quad;
    import starling.events.Event;
    
    import tileworld.core.World;
    import tileworld.ui.editor.settings.ManageEntitySettings;
    
    [Event(name="complete", type="starling.events.Event")]
    
    public class ManageEntityScreen extends Screen {
        public var settings:ManageEntitySettings;
        private var _list:List;
        private var _header:Header;
        private var _backButton:Button;
        private var _saveButton:Button;
        private var _buttonGroup:ButtonGroup;
        private var _input:TextInput;
        private var _label:Label;
        public var _data:TextInput;
        public var _background:Quad;
        
        public function ManageEntityScreen(properties:Object = null):void {
            super();
        }
        
        override protected function initialize():void {
            this._background = new Quad(300, 400, 0xFFFFFF);
            this._background.alpha = 0.5;
            
            this.addChild(this._background);
            
            this._data = new TextInput();
            this._data.text = JSON.stringify(this.settings.entity.data);
            
            this.addChild(this._data);
            
            
            this._buttonGroup = new ButtonGroup();
            this._buttonGroup.dataProvider = new ListCollection([
                { label: "Show performance monitor", triggered: button_triggeredHandler },
                { label: "Hide minimap", triggered: button_triggeredHandler }
            ]);
            
            this.addChild(this._buttonGroup);
            
            this._header = new Header();
            this._header.title = "Options";
            this.addChild(this._header);
            
            this._label = new Label();
            this._label.text = "Entity Name";
            this.addChild(this._label);
            
            this._input = new TextInput();
            this._input.text = this.settings.entity.data.englishName;
            this.addChild(this._input);
            
            this._saveButton = new Button();
            this._saveButton.label = "Save";
            this._saveButton.addEventListener(Event.TRIGGERED, saveButton_triggeredHandler);
            this.addChild(this._saveButton);
            
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
                
            this._buttonGroup.validate();
            this._buttonGroup.x = (this.actualWidth - this._buttonGroup.width) - 10;
            this._buttonGroup.y = 60;
            
            
            this._header.width = this._buttonGroup.width + 20;
            this._header.x = (this.actualWidth - this._header.width);
            this._header.validate();
            
            this._background.x = (this.actualWidth - this._buttonGroup.width) - 20;
            this._background.y = 0;
            this._background.height = this.stage.stageHeight;
            this._background.width = this._header.width;
            
            this._label.validate();
            this._label.x = (this.actualWidth - this._buttonGroup.width) - 10;
            this._label.y = 180;
            
            this._input.validate();
            this._input.x = (this.actualWidth - this._buttonGroup.width) - 10;
            this._input.y = 200;
            
            this._saveButton.validate();
            this._saveButton.x = (this.actualWidth - this._buttonGroup.width) - 10;
            this._saveButton.y = 220;
            
            this._input.validate();
            this._data.x = (this.actualWidth - this._buttonGroup.width) - 10;
            this._data.y = 240;
            this._data.width = this._buttonGroup.width;
            this._data.height = 160;
        }
        
        private function list_changeHandler(event:Event):void {
            trace("List onChange:", this._list.selectedIndex, event);
        }
        
        private function onBackButton():void {
            this.dispatchEventWith(Event.COMPLETE);
        }
        
        private function onSaveButton():void {
            trace('saving entity');
        }
        
        private function backButton_triggeredHandler(event:Event):void {
            this.onBackButton();
        }
        
        private function saveButton_triggeredHandler(event:Event):void {
            this.onSaveButton();
        }
        
        private function button_triggeredHandler(event:Event):void {
            const button:Button = Button(event.currentTarget);
            
        }
    }
}
