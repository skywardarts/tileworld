package tileworld.utils {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import org.osflash.signals.Signal;
	
	public class Console extends EventDispatcher {
		// nice class: http://stackoverflow.com/questions/8053057/as3-monster-debuger-in-starling-framework
		public static var _instance:Console;
		
		public var onMessage:Signal;
		
		public function Console():void {
			this.onMessage = new Signal();	
		}
		
		public static function getInstance():Console {
			if(!_instance)
				_instance = new Console();
			
			return _instance;	
		}
		
		public function info():void {
			
		}
		
		public function debug():void {
			
		}
		
		public function warning():void {
			
		}
		
		public function log(message:*, ...rest):String {
			var result:String = "";
			var data:Array = rest as Array;
			
			data.unshift(message);
			
			trace.apply(this, data);
			
			for(var i:int = 0, l:int = data.length; i < l; ++i) {
				result += data[i].toString() + " ";
			}
			
			if(ExternalInterface.available) {
				ExternalInterface.call("console.log", result);
			}
			
			// @todo: do one better: call console.log.apply with strings that are JSON.parse'd
			
			this.onMessage.dispatch(result);
      
      return result;
		}
		
		public static function log(message:*, ...rest):void {
			var data:Array = rest as Array;
			
			data.unshift(message);
		
			_instance.log.apply(message, data);
		}
    
    public static function error(message:*, ...rest):void {
        var data:Array = rest as Array;
        
        data.unshift(message);
        
        var result:String = _instance.log.apply(message, data);
        
        throw result;
    }
	}
}