package cn.chinuy.media.elements.video.http {
	import cn.chinuy.media.events.LoadEvent;
	
	/**
	 * @author chin
	 */
	public class FLVNetStream extends BaseNetStream {
		
		private var useTime : Boolean;
		private var key : String;
		
		public function FLVNetStream( loadPolicyFile : Boolean = false, useTime : Boolean = false, key : String = "start" ) {
			super();
			checkPolicyFile = loadPolicyFile;
			this.useTime = useTime;
			this.key = key;
		}
		
		override protected function serverSeek( offset : Number ) : Boolean {
			var s : Boolean = super.serverSeek( offset );
			if( s ) {
				dispatchEvent( new LoadEvent( LoadEvent.Stop ));
				var p : Object = {};
				p[ key ] = useTime ? Math.round( timeInitial ) : bytesInitial;
				hs_play( getFlvURL( url, p ));
			}
			return s;
		}
	
	}
}
