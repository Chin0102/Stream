package cn.chinuy.media.elements.basic {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class Container extends Sprite {
		
		private var _width : int;
		private var _height : int;
		private var _mask : Shape;
		
		public function Container() {
			super();
		}
		
		override public function get mask() : DisplayObject {
			if( _mask == null ) {
				_mask = new Shape();
				_mask.graphics.clear();
				_mask.graphics.beginFill( 0 );
				_mask.graphics.drawRect( 0, 0, width, height );
				_mask.graphics.endFill();
				addChild( _mask );
				mask = _mask;
			}
			return _mask;
		}
		
		override public function get height() : Number {
			return _height;
		}
		
		override public function set height( value : Number ) : void {
			_height = value;
			onResizeHandler();
		}
		
		override public function get width() : Number {
			return _width;
		}
		
		override public function set width( value : Number ) : void {
			_width = value;
			onResizeHandler();
		}
		
		public function setSize( width : Number, height : Number ) : void {
			_width = width;
			_height = height;
			onResizeHandler();
		}
		
		protected function onResize() : void {
		}
		
		private function onResizeHandler() : void {
			onResize();
			dispatchEvent( new Event( Event.RESIZE ));
		}
	
	}
}
