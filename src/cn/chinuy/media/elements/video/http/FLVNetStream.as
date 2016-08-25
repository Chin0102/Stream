package cn.chinuy.media.elements.video.http {
	import cn.chinuy.media.events.LoadEvent;
	
	/**
	 * @author chin
	 */
	public class FLVNetStream extends BaseNetStream {
		
		public function FLVNetStream( loadPolicyFile : Boolean = false ) {
			super();
			checkPolicyFile = loadPolicyFile;
		}
		
		override protected function serverSeek( offset : Number ) : Boolean {
			var s : Boolean = super.serverSeek( offset );
			if( s ) {
				dispatchEvent( new LoadEvent( LoadEvent.Stop ));
				hs_play( getFlvURL( url, { start:bytesInitial }));
			}
			return s;
		}
	
	}
}
