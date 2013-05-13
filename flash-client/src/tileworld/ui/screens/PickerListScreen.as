package tileworld.ui.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.system.DeviceCapabilities;

	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class PickerListScreen extends Screen
	{
		public function PickerListScreen()
		{
			super();
		}
		
		private var _header:Header;
		private var _backButton:Button;
		private var _list:PickerList;
		
		override protected function initialize():void
		{
			var items:Array = [];
			for(var i:int = 0; i < 150; i++)
			{
				var item:Object = {text: "Item " + (i + 1).toString()};
				items.push(item);
			}
			items.fixed = true;

			this._list = new PickerList();
			this._list.prompt = "Select an Item";
			this._list.dataProvider = new ListCollection(items);
			//normally, the first item is selected, but let's show the prompt
			this._list.selectedIndex = -1;
			this.addChildAt(this._list, 0);

			//the typical item helps us set an ideal width for the button
			//if we don't use a typical item, the button will resize to fit
			//the currently selected item.
			this._list.typicalItem = { text: "Item 1000"};
			this._list.labelField = "text";

			//notice that we're setting typicalItem on the list separately. we
			//may want to have the list measure at a different width, so it
			//might need a different typical item than the picker list's button.
			this._list.listProperties.typicalItem = { text: "Item 1000" };

			//notice that we're setting labelField on the item renderers
			//separately. the default item renderer has a labelField property,
			//but a custom item renderer may not even have a label, so
			//PickerList cannot simply pass its labelField down to item
			//renderers automatically
			this._list.listProperties.@itemRendererProperties.labelField = "text";

			this._header = new Header();
			this._header.title = "Picker List";
			this.addChild(this._header);

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.label = "Back";
				this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

				this._header.leftItems = new <DisplayObject>
				[
					this._backButton
				];
			}
			
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		}
		
		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();
			
			this._list.validate();
			this._list.x = (this.actualWidth - this._list.width) / 2;
			this._list.y = this._header.height + (this.actualHeight - this._header.height - this._list.height) / 2;
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}