package com.facebook.graph.data.fql.status
{
	import com.facebook.graph.data.api.status.FacebookStatusMessage;
	import com.facebook.graph.utils.FacebookDataUtils;
	
	/**
	 * VO to hold information about a queried status message.
	 */
	public class FQLStatus
	{
		/**
		 * The ID of the owner of the status message being queried.
		 */
		public var uid:Number;
		
		/**
		 * The ID of the status message being queried.
		 */
		public var status_id:Number;
		
		/**
		 * The message of the status message being queried.
		 */
		public var message:String;
		
		/**
		 * The source of the status message being queried.
		 */
		public var source:String;
		
		/**
		 * The time of the status message being queried.
		 */
		public var time:Date;
		
		/**
		 * Creates a new FQLStatus.
		 */
		public function FQLStatus()
		{
		}
		
		/**
		 * Populates and returns a new FQLStatus from a decoded JSON object.
		 * 
		 * @param result A decoded JSON object.
		 * 
		 * @return A new FQLStatus.
		 */
		public static function fromJSON( result:Object ):FQLStatus
		{
			var status:FQLStatus = new FQLStatus();
			status.fromJSON( result );
			return status;
		}
		
		/**
		 * Populates the user from a decoded JSON object.
		 */
		public function fromJSON( result:Object ):void
		{
			if( result != null )
			{
				for( var property:String in result )
				{
					switch( property )
					{
						case "time":
							if( hasOwnProperty( property ) ) this[ property ] = FacebookDataUtils.stringToDate( result[ property ] );
							break;
						
						default:
							if( hasOwnProperty( property ) ) this[ property ] = result[ property ];
							break;
					}
				}
			}
		}
		
		/**
		 * Provides the string value of this instance.
		 */
		public function toString():String
		{
			return '[ uid: ' + uid + ', message: ' + message + ' ]';
		}
		
	}
}