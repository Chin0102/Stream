package cn.chinuy.media.elements.live {
	import cn.chinuy.media.elements.basic.Stream;
	import cn.chinuy.media.elements.video.base.NetStatus;
	import cn.chinuy.media.events.BufferEvent;
	
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	
	/**
	 * @author chin
	 */
	public class LiveStream extends Stream {
		
		private var bufferChecker : Timer;
		
		public function LiveStream( connection : NetConnection, peerID : String = "connectToFMS" ) {
			super( connection, peerID );
			bufferChecker = new Timer( 50 );
			bufferChecker.addEventListener( TimerEvent.TIMER, checkBuffer );
		}
		
//		override protected function onMetaData( metadataObj : Object ) : void {
//			ready_metadata = false;
//			super.onMetaData( metadataObj );
//		}
//		
//		override protected function checkStreamReady() : void {
//			ready_metadata = true;
//			super.checkStreamReady();
//		}
		
		override protected function initNetStatusHandler() : void {
			super.initNetStatusHandler();
			addNetStatusHandler( NetStatus.BufferFlush, onBufferFlush );
		}
		
		override protected function onBufferFull() : void {
			bufferChecker.stop();
			super.onBufferFull();
		}
		
		protected function onBufferFlush() : void {
			bufferChecker.start();
		}
		
		private function checkBuffer( event : TimerEvent ) : void {
			if( ns_bufferLength <= 0 ) {
				loading = true;
				bufferChecker.stop();
				dispatchEvent( new BufferEvent( BufferEvent.Flush, BufferEvent.Play ));
			}
		}
	}
}
