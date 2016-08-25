package cn.chinuy.media.events {
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class VisualResizeEvent extends Event {
		
		public static const Resize : String = "Media.VisualResize.Event";
		
		private var _x : Number;
		private var _y : Number;
		private var _w : Number;
		private var _h : Number;
		
		public function VisualResizeEvent( x : Number, y : Number, w : Number, h : Number ) {
			super( Resize );
			_x = x;
			_y = y;
			_w = w;
			_h = h;
		}
		
		public function get h() : Number {
			return _h;
		}
		
		public function get w() : Number {
			return _w;
		}
		
		public function get y() : Number {
			return _y;
		}
		
		public function get x() : Number {
			return _x;
		}
		
		override public function clone() : Event {
			return new VisualResizeEvent( x, y, w, h );
		}
	
	}
}
