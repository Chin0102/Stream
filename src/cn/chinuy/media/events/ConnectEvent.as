package cn.chinuy.media.events {
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class ConnectEvent extends Event {
		
		public static const All : String = "Media.Connect.Event";
		
		public static const ConnectSuccess : String = "NetConnection.Connect.Success";
		public static const ConnectFailed : String = "NetConnection.Connect.Failed";
		public static const ConnectClosed : String = "NetConnection.Connect.Closed";
		public static const NetworkChange : String = "NetConnection.Connect.NetworkChange";
		
		private var _status : String;
		
		public function ConnectEvent( status : String ) {
			super( All );
			_status = status;
		}
		
		public function get status() : String {
			return _status;
		}
		
		override public function clone() : Event {
			return new ConnectEvent( status );
		}
	}
}
