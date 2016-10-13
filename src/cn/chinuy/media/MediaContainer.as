package cn.chinuy.media {
	import cn.chinuy.media.core.IMediaContainer;
	import cn.chinuy.media.core.IMediaProvider;
	import cn.chinuy.media.core.Metadata;
	import cn.chinuy.media.elements.basic.Container;
	import cn.chinuy.media.elements.visual.IVisualization;
	import cn.chinuy.media.events.BufferEvent;
	import cn.chinuy.media.events.ContainerEvent;
	import cn.chinuy.media.events.LoadEvent;
	import cn.chinuy.media.events.PlayEvent;
	import cn.chinuy.media.events.SeekEvent;
	import cn.chinuy.media.events.SettingEvent;
	import cn.chinuy.media.events.VisualResizeEvent;
	import cn.chinuy.media.scale.MediaScalePreset;
	import cn.chinuy.media.scale.MediaZoomPreset;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * @author chin
	 */
	public class MediaContainer extends Container implements IMediaContainer {
		
		protected var mediaProvider : IMediaProvider;
		
		private var _brightness : Number = 0;
		private var _contrast : Number = 0;
		private var _scale : Number = 0;
		private var _zoom : Number = 1;
		private var _volume : Number = 1;
		private var _bufferTime : Number = 3;
		private var _scalePreset : MediaScalePreset;
		private var _zoomPreset : MediaZoomPreset;
		private var visualRectangle : Rectangle = new Rectangle();
		
		private var bgVisible : Boolean = true;
		private var bgColor : int = 0;
		private var bgAlpha : Number = 1;
		
		public function MediaContainer() {
			super();
			_scalePreset = MediaScalePreset.createDefault( this );
			_zoomPreset = MediaZoomPreset.createDefault( this );
		}
		
		override protected function onResize() : void {
			updateBg();
			visualRectangle.width = width;
			visualRectangle.height = height;
			if( provider )
				provider.setSize( width, height );
		}
		
		public function get provider() : IMediaProvider {
			return mediaProvider;
		}
		
		public function set provider( m : IMediaProvider ) : void {
			removeProvider();
			mediaProvider = m;
			provider.addEventListener( LoadEvent.All, dispatchEvent );
			provider.addEventListener( PlayEvent.All, dispatchEvent );
			provider.addEventListener( SeekEvent.All, dispatchEvent );
			provider.addEventListener( BufferEvent.All, dispatchEvent );
			provider.addEventListener( SettingEvent.All, dispatchEvent );
			provider.addEventListener( VisualResizeEvent.Resize, dispatchEvent );
			onAddProvider();
			addChild( provider.displayObject );
		}
		
		protected function onAddProvider() : void {
			provider.brightness = brightness;
			provider.contrast = contrast;
			provider.scale = scale;
			provider.zoom = zoom;
			provider.volume = volume;
			provider.bufferTime = bufferTime;
			provider.setSize( width, height );
			dispatchEvent( new ContainerEvent( ContainerEvent.AddProvider, provider ));
		}
		
		public function get hasProvider() : Boolean {
			return provider != null;
		}
		
		public function removeProvider() : void {
			if( provider ) {
				provider.removeEventListener( LoadEvent.All, dispatchEvent );
				provider.removeEventListener( PlayEvent.All, dispatchEvent );
				provider.removeEventListener( SeekEvent.All, dispatchEvent );
				provider.removeEventListener( BufferEvent.All, dispatchEvent );
				provider.removeEventListener( SettingEvent.All, dispatchEvent );
				provider.removeEventListener( VisualResizeEvent.Resize, dispatchEvent );
				removeChild( provider.displayObject );
				dispatchEvent( new ContainerEvent( ContainerEvent.RemoveProvider, provider ));
				mediaProvider = null;
			}
		}
		
		public function clear() : void {
			if( provider )
				provider.clear();
		}
		
		protected function dispatchSettingEvent( code : String, value : * = null ) : void {
			dispatchEvent( new SettingEvent( code, value ));
		}
		
		public function set brightness( value : Number ) : void {
			_brightness = value;
			if( provider )
				provider.brightness = brightness;
			else
				dispatchSettingEvent( SettingEvent.BrightnessChanged, brightness );
		}
		
		public function get brightness() : Number {
			return _brightness;
		}
		
		public function set contrast( value : Number ) : void {
			_contrast = value;
			if( provider )
				provider.contrast = value;
			else
				dispatchSettingEvent( SettingEvent.ContrastChanged, contrast );
		}
		
		public function get contrast() : Number {
			return _contrast;
		}
		
		public function get mediaScale() : MediaScalePreset {
			return _scalePreset;
		}
		
		public function get presetScale() : String {
			return mediaScale.scale;
		}
		
		public function set presetScale( scale : String ) : void {
			mediaScale.scale = scale;
		}
		
		public function set scale( value : Number ) : void {
			_scale = value;
			if( provider )
				provider.scale = value;
			else
				dispatchSettingEvent( SettingEvent.ScaleChanged, scale );
		}
		
		public function get scale() : Number {
			return _scale;
		}
		
		public function get mediaZoom() : MediaZoomPreset {
			return _zoomPreset;
		}
		
		public function get presetZoom() : String {
			return mediaZoom.zoom;
		}
		
		public function set presetZoom( zoom : String ) : void {
			mediaZoom.zoom = zoom;
		}
		
		public function set zoom( value : Number ) : void {
			_zoom = value;
			if( provider )
				provider.zoom = value;
			else
				dispatchSettingEvent( SettingEvent.ZoomChanged, zoom );
		}
		
		public function get zoom() : Number {
			return _zoom;
		}
		
		public function set volume( value : Number ) : void {
			_volume = Math.max( 0, Math.min( 5, value ));
			if( provider )
				provider.volume = value;
			else
				dispatchSettingEvent( SettingEvent.VolumeChanged, volume );
		}
		
		public function get volume() : Number {
			return _volume;
		}
		
		public function get displayObject() : DisplayObject {
			return this;
		}
		
		public function play( ... parameters ) : void {
			if( provider )
				provider.play.apply( this, parameters );
		}
		
		public function close() : void {
			if( provider )
				provider.close();
		}
		
		public function seekStart( offset : Number ) : void {
			if( provider )
				provider.seekStart( offset );
		}
		
		public function seekEnd( offset : Number ) : void {
			if( provider )
				provider.seekEnd( offset );
		}
		
		public function seek( offset : Number ) : void {
			if( provider )
				provider.seek( offset );
		}
		
		public function togglePause() : void {
			if( provider )
				provider.togglePause();
		}
		
		public function pause() : void {
			if( provider )
				provider.pause();
		}
		
		public function resume() : void {
			if( provider )
				provider.resume();
		}
		
		public function get visualData() : * {
			if( provider )
				return provider.visualData;
			return null;
		}
		
		public function get visual() : IVisualization {
			if( provider )
				return provider.visual;
			return null;
		}
		
		public function get visualRect() : Rectangle {
			if( provider )
				return provider.visualRect;
			return visualRectangle;
		}
		
		public function get url() : String {
			if( provider )
				return provider.url;
			return null;
		}
		
		public function get metadata() : Metadata {
			if( provider )
				return provider.metadata;
			return null;
		}
		
		public function get originalScale() : Number {
			if( provider )
				return provider.originalScale;
			return 0;
		}
		
		public function get canPause() : Boolean {
			if( provider )
				return provider.canPause;
			return false;
		}
		
		public function get canSeek() : Boolean {
			if( provider )
				return provider.canSeek;
			return false;
		}
		
		public function get bufferLength() : Number {
			if( provider )
				return provider.bufferLength;
			return 0;
		}
		
		public function get bufferTime() : Number {
			return _bufferTime;
		}
		
		public function set bufferTime( value : Number ) : void {
			_bufferTime = value;
			if( provider )
				provider.bufferTime = value;
		}
		
		public function get bytesInitial() : uint {
			if( provider )
				return provider.bytesInitial;
			return 0;
		}
		
		public function get bytesLoaded() : uint {
			if( provider )
				return provider.bytesLoaded;
			return 0;
		}
		
		public function get bytesTotal() : uint {
			if( provider )
				return provider.bytesTotal;
			return 0;
		}
		
		public function get bytesFinal() : uint {
			if( provider )
				return provider.bytesFinal;
			return 0;
		}
		
		public function get timeInitial() : Number {
			if( provider )
				return provider.timeInitial;
			return 0;
		}
		
		public function get time() : Number {
			if( provider )
				return provider.time;
			return 0;
		}
		
		public function get timeFinal() : Number {
			if( provider )
				return provider.timeFinal;
			return 0;
		}
		
		public function get timeTotal() : Number {
			if( provider )
				return provider.timeTotal;
			return 0;
		}
		
		protected function updateBg() : void {
			graphics.clear();
			if( bgVisible ) {
				graphics.beginFill( bgColor, bgAlpha );
				graphics.drawRect( 0, 0, width, height );
				graphics.endFill();
			}
		}
		
		protected function setBgStyle( visible : Boolean, color : int = 0, alpha : Number = 1 ) : void {
			bgVisible = visible;
			bgColor = color;
			bgAlpha = alpha;
			updateBg();
		}
	}
}
