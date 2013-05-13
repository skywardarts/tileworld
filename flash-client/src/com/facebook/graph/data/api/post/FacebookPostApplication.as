package com.facebook.graph.data.api.post
{
	import com.facebook.graph.core.facebook_internal;
	import com.facebook.graph.data.api.core.AbstractFacebookGraphObject;
	
	use namespace facebook_internal;
	
	public class FacebookPostApplication extends AbstractFacebookGraphObject
	{
		public var name:String;
		
		public static function fromJSON( result:Object ):FacebookPostApplication
		{
			var application:FacebookPostApplication = new FacebookPostApplication();
			application.fromJSON( result );
			return application;
		}
	}
}