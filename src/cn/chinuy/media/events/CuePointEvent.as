package cn.chinuy.media.events {
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class CuePointEvent extends Event {
		
		public static const TYPE : String = "onCuePoint";
		
		private var _data : Object;
		
		public function CuePointEvent( data : Object ) {
			super( TYPE );
			_data = data;
		}
		
		public function get data() : Object {
			return _data;
		}
		
		override public function clone() : Event {
			return new CuePointEvent( data );
		}
	
	}
}
