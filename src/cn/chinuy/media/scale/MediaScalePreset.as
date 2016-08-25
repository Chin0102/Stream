package cn.chinuy.media.scale {
	import cn.chinuy.media.MediaContainer;
	import cn.chinuy.media.events.ContainerEvent;
	import cn.chinuy.media.events.PlayEvent;
	
	/**
	 * @author chin
	 */
	public class MediaScalePreset {
		
		public static const OriginalValue : Number = -1;
		public static const FullValue : Number = 0;
		
		public static const Full : String = "full";
		public static const Scale43 : String = "scale43";
		public static const Scale169 : String = "scale169";
		public static const Original : String = "original";
		
		public static function createDefault( container : MediaContainer ) : MediaScalePreset {
			var scalePreset : MediaScalePreset = new MediaScalePreset( container );
			scalePreset.preset( Full, FullValue );
			scalePreset.preset( Scale43, 4 / 3 );
			scalePreset.preset( Scale169, 16 / 9 );
			scalePreset.preset( Original, OriginalValue );
			scalePreset.updateOriginalScale();
			scalePreset.scale = Original;
			return scalePreset;
		}
		
		private var _scale : String;
		private var scalePreset : Object = {};
		private var originalScale : Number = 0;
		private var container : MediaContainer;
		
		public function MediaScalePreset( container : MediaContainer ) {
			this.container = container;
			container.addEventListener( ContainerEvent.AddProvider, onAddProvider );
			container.addEventListener( PlayEvent.All, onPlayEvent );
		}
		
		private function onAddProvider( event : ContainerEvent ) : void {
			updateOriginalScale();
		}
		
		private function onPlayEvent( e : PlayEvent ) : void {
			if( e.status == PlayEvent.Ready ) {
				updateOriginalScale();
			}
		}
		
		public function updateOriginalScale() : void {
			originalScale = container.originalScale;
			if( scale == Original && originalScale > 0 ) {
				setScale( scale );
			}
		}
		
		public function get scale() : String {
			return _scale;
		}
		
		public function set scale( value : String ) : void {
			var changed : Boolean = scale != value;
			if( changed ) {
				setScale( value );
			}
		}
		
		private function setScale( value : String ) : void {
			var mediaScale : Number = scalePreset[ value ];
			if( !isNaN( mediaScale )) {
				_scale = value;
				if( mediaScale == OriginalValue ) {
					if( originalScale <= 0 ) {
						return;
					}
					mediaScale = originalScale;
				}
				container.scale = mediaScale;
			}
		}
		
		public function get value() : Number {
			return scalePreset[ scale ];
		}
		
		public function preset( name : String, value : Number = NaN ) : void {
			if( isNaN( value )) {
				delete scalePreset[ name ];
			} else {
				scalePreset[ name ] = value;
			}
		}
	}
}
