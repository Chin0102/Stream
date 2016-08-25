package cn.chinuy.media.scale {
	import cn.chinuy.media.MediaContainer;
	
	/**
	 * @author chin
	 */
	public class MediaZoomPreset {
		
		public static const Zoom50 : String = "zoom50";
		public static const Zoom75 : String = "zoom75";
		public static const Zoom100 : String = "zoom100";
		
		public static function createDefault( container : MediaContainer ) : MediaZoomPreset {
			var zoomPreset : MediaZoomPreset = new MediaZoomPreset( container );
			zoomPreset.preset( Zoom50, .5 );
			zoomPreset.preset( Zoom75, .75 );
			zoomPreset.preset( Zoom100, 1 );
			zoomPreset.zoom = Zoom100;
			return zoomPreset;
		}
		
		private var _zoom : String;
		private var zoomPreset : Object = {};
		private var container : MediaContainer;
		
		public function MediaZoomPreset( container : MediaContainer ) {
			this.container = container;
		}
		
		public function get zoom() : String {
			return _zoom;
		}
		
		public function set zoom( value : String ) : void {
			var changed : Boolean = zoom != value;
			if( changed ) {
				var zoomValue : Number = zoomPreset[ value ];
				if( !isNaN( zoomValue )) {
					_zoom = value;
					container.zoom = zoomValue;
				}
			}
		}
		
		public function get value() : Number {
			return zoomPreset[ zoom ];
		}
		
		public function preset( name : String, value : Number = NaN ) : void {
			if( isNaN( value )) {
				delete zoomPreset[ name ];
			} else {
				zoomPreset[ name ] = value;
			}
		}
	}
}
