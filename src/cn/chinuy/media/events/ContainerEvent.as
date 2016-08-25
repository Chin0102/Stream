package cn.chinuy.media.events {
	import cn.chinuy.media.core.IMediaProvider;
	
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class ContainerEvent extends Event {
		
		public static const AddProvider : String = "AddProvider";
		public static const RemoveProvider : String = "RemoveProvider";
		
		private var _mediaProvider : IMediaProvider;
		
		public function ContainerEvent( type : String, mediaProvider : IMediaProvider ) {
			super( type );
			_mediaProvider = mediaProvider;
		}
		
		public function get mediaProvider() : IMediaProvider {
			return _mediaProvider;
		}
		
		override public function clone() : Event {
			return new ContainerEvent( type, mediaProvider );
		}
	
	}
}
