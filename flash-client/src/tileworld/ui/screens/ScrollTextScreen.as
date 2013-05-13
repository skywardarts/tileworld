package tileworld.ui.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ScrollTextScreen extends Screen
	{
		public function ScrollTextScreen()
		{
		}

		private var _header:Header;
		private var _backButton:Button;
		public static var content:ScrollText = new ScrollText();

		override protected function initialize():void
		{
			this.addChild(content);

			this._header = new Header();
			this._header.title = "Debug Messages";
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

			content.width = this.actualWidth;
			content.y = this._header.height;
			content.height = this.actualHeight - content.y;
			
			//content.scrollV(content.numLines);
			trace(content.maxVerticalScrollPosition, content.verticalScrollPosition);
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
