package tileworld.networks.facebook {
	import com.facebook.graph.Facebook;
	//import flash.system.Security;
	
	import tileworld.utils.Console;
	import tileworld.core.World;
	
	public class FacebookNetwork {
		protected static const APP_ID:String = "280992815359883";

		public var world:World;
		
		public function FacebookNetwork(world:World):void {
			this.world = world;
		}

		public function connect():void {
			//Security.loadPolicyFile("http://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
			
			//http://graph.facebook.com/" + userid + "/picture
			
			if(Facebook.available()) {
				Console.log('fb init');
				
				Facebook.init(APP_ID, onInit);
			}
			//Facebook.api('', onCallApi, {}, 'POST');
		}
		
		protected function onInit(result:Object, fail:Object):void {						
			if(result) { //already logged in because of existing session
				Console.log( "onInit, Logged In\n");
			} else {
				Console.log("onInit, Not Logged In\n");
			}
		}
		
		protected function onCallApi(result:Object, fail:Object):void {
			if(result) {
				Console.log("\n\nRESULT:\n" + JSON.stringify(result)); 
			} else {
				Console.log("\n\nFAIL:\n" +JSON.stringify(fail)); 
			}
		}
		
		protected function onLogin(result:Object, fail:Object):void {
			if(result) { //successfully logged in
				Console.log("Logged In");
			} else {
				Console.log("Login Failed\n");				
			}
		}
		
		protected function onLogout(success:Boolean):void {			
			Console.log("Logged Out");				
		}
	}
}