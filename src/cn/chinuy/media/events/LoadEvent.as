package cn.chinuy.media.events {
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class LoadEvent extends Event {
		
		public static const All : String = "Media.Load.Event";
		
		public static const Start : String = "Media.Load.Start"; //--------------------- 开始加载
		public static const Stop : String = "Media.Load.Stop"; //----------------------- 加载停止
		
		private var _status : String;
		private var _time : Number;
		private var _position : uint;
		
		public function LoadEvent( status : String ) { //, time : Number, position : uint ) {
			super( All );
			_status = status;
			_time = time;
			_position = position;
		}
		
		public function get status() : String {
			return _status;
		}
		
		public function get time() : Number {
			return _time;
		}
		
		public function get position() : uint {
			return _position;
		}
		
		override public function clone() : Event {
			return new LoadEvent( status ); //, time, position );
		}
	
	}
}
