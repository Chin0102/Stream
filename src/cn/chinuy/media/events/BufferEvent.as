package cn.chinuy.media.events {
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class BufferEvent extends Event {
		
		public static const All : String = "Media.Buffer.Event";
		
		public static const Full : String = "Media.Buffer.Full"; //------------------- 播放中缓存区满
		public static const Empty : String = "Media.Buffer.Empty"; //----------------- 播放中缓存区空
		public static const Flush : String = "Media.Buffer.Flush"; //----------------- 播放中缓存区空
		
		public static const Load : String = "load";
		public static const Play : String = "play";
		
		private var _status : String;
		private var _bufferType : String;
		
		public function BufferEvent( status : String, bufferType : String ) {
			super( All );
			_status = status;
			_bufferType = bufferType;
		}
		
		public function get status() : String {
			return _status;
		}
		
		public function get bufferType() : String {
			return _bufferType;
		}
		
		override public function clone() : Event {
			return new BufferEvent( status, bufferType );
		}
	}
}
