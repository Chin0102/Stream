package cn.chinuy.media.providers {
	import cn.chinuy.media.core.IMediaElement;
	import cn.chinuy.media.core.IMediaProvider;
	import cn.chinuy.media.core.Metadata;
	import cn.chinuy.media.elements.basic.Container;
	import cn.chinuy.media.elements.visual.IVisualization;
	import cn.chinuy.media.events.BufferEvent;
	import cn.chinuy.media.events.CuePointEvent;
	import cn.chinuy.media.events.LoadEvent;
	import cn.chinuy.media.events.PlayEvent;
	import cn.chinuy.media.events.SeekEvent;
	import cn.chinuy.media.events.SettingEvent;
	import cn.chinuy.media.events.VisualResizeEvent;
	import cn.chinuy.utils.ColorFilters;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * @author chin
	 */
	public class MediaProvider extends Container implements IMediaProvider {
		
		protected var element : IMediaElement;
		protected var visualization : IVisualization;
		private var scaleValue : Number = 0;
		private var zoomValue : Number = 1;
		private var visualRectangle : Rectangle = new Rectangle();
		private var colorFilters : ColorFilters = new ColorFilters();
		
		public function MediaProvider( visualization : IVisualization ) {
			super();
			initVisualization( visualization );
		}
		
		protected function initElement( mediaElement : IMediaElement ) : void {
			if( element ) {
				element.removeEventListener( LoadEvent.All, dispatchEvent );
				element.removeEventListener( PlayEvent.All, dispatchEvent );
				element.removeEventListener( SeekEvent.All, dispatchEvent );
				element.removeEventListener( BufferEvent.All, dispatchEvent );
				element.removeEventListener( CuePointEvent.TYPE, dispatchEvent );
			}
			element = mediaElement;
			element.addEventListener( LoadEvent.All, dispatchEvent );
			element.addEventListener( PlayEvent.All, dispatchEvent );
			element.addEventListener( SeekEvent.All, dispatchEvent );
			element.addEventListener( BufferEvent.All, dispatchEvent );
			element.addEventListener( CuePointEvent.TYPE, dispatchEvent );
			visualization.display( visualData );
		}
		
		protected function initVisualization( mediaVisualization : IVisualization ) : void {
			visualization = mediaVisualization;
			addChild( visualization.displayObject );
		}
		
		public function play( ... parameters ) : void {
			element.play.apply( this, parameters );
		}
		
		public function close() : void {
			element.close();
		}
		
		public function seekStart( offset : Number ) : void {
			element.seekStart( offset );
		}
		
		public function seekEnd( offset : Number ) : void {
			element.seekEnd( offset );
		}
		
		public function seek( offset : Number ) : void {
			element.seek( offset );
		}
		
		public function togglePause() : void {
			element.togglePause();
		}
		
		public function pause() : void {
			element.pause();
		}
		
		public function resume() : void {
			element.resume();
		}
		
		public function get visualData() : * {
			return element.visualData;
		}
		
		public function get visual() : IVisualization {
			return visualization;
		}
		
		public function set volume( value : Number ) : void {
			element.volume = value;
			dispatchSettingEvent( SettingEvent.VolumeChanged, volume );
		}
		
		public function get volume() : Number {
			return element.volume;
		}
		
		public function get url() : String {
			return element.url;
		}
		
		public function get metadata() : Metadata {
			return element.metadata;
		}
		
		public function get canPause() : Boolean {
			return element.canPause;
		}
		
		public function get canSeek() : Boolean {
			return element.canSeek;
		}
		
		public function get bufferLength() : Number {
			return element.bufferLength;
		}
		
		public function get bufferTime() : Number {
			return element.bufferTime;
		}
		
		public function set bufferTime( value : Number ) : void {
			element.bufferTime = value;
		}
		
		public function get bytesInitial() : uint {
			return element.bytesInitial;
		}
		
		public function get bytesFinal() : uint {
			return element.bytesFinal;
		}
		
		public function get bytesLoaded() : uint {
			return element.bytesLoaded;
		}
		
		public function get bytesTotal() : uint {
			return element.bytesTotal;
		}
		
		public function get timeInitial() : Number {
			return element.timeInitial;
		}
		
		public function get time() : Number {
			return element.time;
		}
		
		public function get timeFinal() : Number {
			return element.timeFinal;
		}
		
		public function get timeTotal() : Number {
			return element.timeTotal;
		}
		
		public function dispatchSettingEvent( code : String, value : * = null ) : void {
			dispatchEvent( new SettingEvent( code, value ));
		}
		
		public function clear() : void {
			visualization.clear();
		}
		
		public function get displayObject() : DisplayObject {
			return this;
		}
		
		public function get brightness() : Number {
			return colorFilters.brightness;
		}
		
		public function get contrast() : Number {
			return colorFilters.contrast;
		}
		
		public function set brightness( value : Number ) : void {
			colorFilters.brightness = value;
			filters = colorFilters.value;
			dispatchSettingEvent( SettingEvent.BrightnessChanged, brightness );
		}
		
		public function set contrast( value : Number ) : void {
			colorFilters.contrast = value;
			filters = colorFilters.value;
			dispatchSettingEvent( SettingEvent.ContrastChanged, contrast );
		}
		
		public function get originalScale() : Number {
			if( metadata ) {
				return metadata.scale;
			}
			return 0;
		}
		
		public function get scale() : Number {
			return scaleValue;
		}
		
		public function set scale( s : Number ) : void {
			scaleValue = s;
			updateVisualization();
			dispatchSettingEvent( SettingEvent.ScaleChanged, scale );
		}
		
		public function get zoom() : Number {
			return zoomValue;
		}
		
		public function set zoom( s : Number ) : void {
			zoomValue = s;
			updateVisualization();
			dispatchSettingEvent( SettingEvent.ZoomChanged, zoom );
		}
		
		public function get visualRect() : Rectangle {
			return visualRectangle;
		}
		
		override protected function onResize() : void {
			updateVisualization();
		}
		
		protected function updateVisualization() : void {
			var rw : Number = width;
			var rh : Number = height;
			var x_offset : Number = 0;
			var y_offset : Number = 0;
			if( zoom < 1 ) {
				x_offset = rw * ( 1 - zoom ) / 2;
				y_offset = rh * ( 1 - zoom ) / 2;
				rw *= zoom;
				rh *= zoom;
			}
			var w : Number, h : Number;
			if( scale == 0 ) {
				w = rw;
				h = rh;
			} else if( rw / rh > scale ) {
				w = rh * scale;
				h = rh;
			} else {
				w = rw;
				h = rw / scale;
			}
			visualization.x = visualRectangle.x = ( rw - w ) / 2 + x_offset;
			visualization.y = visualRectangle.y = ( rh - h ) / 2 + y_offset;
			visualization.width = visualRectangle.width = w;
			visualization.height = visualRectangle.height = h;
			dispatchEvent( new VisualResizeEvent( visualRect.x, visualRect.y, visualRect.width, visualRect.height ));
		}
	}
}
