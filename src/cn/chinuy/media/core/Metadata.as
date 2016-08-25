package cn.chinuy.media.core {
	
	/**
	 * @author chin
	 */
	public class Metadata {
		
		private var _data : Object;
		
		public function Metadata( data : Object ) {
			_data = data;
		}
		
		protected function get data() : Object {
			return _data;
		}
		
		public function setValue( key : String, value : * ) : void {
			data[ key ] = value;
		}
		
		public function getValue( key : String ) : * {
			return data[ key ];
		}
		
		public function get width() : Number {
			return 0;
		}
		
		public function get height() : Number {
			return 0;
		}
		
		public function get scale() : Number {
			return 0;
		}
		
		public function get duration() : Number {
			return 0;
		}
		
		public function get filesize() : Number {
			return 0;
		}
		
		public function copyData() : Object {
			var newData : Object = {};
			for( var i : String in data ) {
				newData[ i ] = data[ i ];
			}
			return newData;
		}
	
	}
}
