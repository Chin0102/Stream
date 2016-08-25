package cn.chinuy.media.elements.live {
	import cn.chinuy.media.elements.video.base.NetStatus;
	import cn.chinuy.media.events.PublishEvent;
	
	import flash.net.NetConnection;
	
	/**
	 * @author chin
	 */
	public class PublishStream extends LiveStream {
		
		public function PublishStream( connection : NetConnection ) {
			super( connection );
		}
		
		override protected function initNetStatusHandler() : void {
			super.initNetStatusHandler();
			addNetStatusHandler( NetStatus.PublishStart, onPublishStart );
		}
		
		protected function onPublishStart() : void {
			dispatchEvent( new PublishEvent( PublishEvent.Start ));
		}
	}
}
