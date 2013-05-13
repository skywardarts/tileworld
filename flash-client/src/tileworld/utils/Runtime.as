package tileworld.utils {
	public class Runtime {
		public static function isDebug():Boolean {
			var isDebug:Boolean = (new Error().getStackTrace().search(/:[0-9]+]$/m) > -1);
			
			return isDebug;
		}
	}
}