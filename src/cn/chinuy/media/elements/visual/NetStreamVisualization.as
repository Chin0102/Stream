package cn.chinuy.media.elements.visual {
	import cn.chinuy.media.elements.basic.Container;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetStream;
	
	/**
	 * @author Chin
	 */
	public class NetStreamVisualization extends Container implements IVisualization {
		
		protected var video : Video;
		protected var cover : Sprite;
		
		public function NetStreamVisualization() {
			super();
			
			video = new Video();
			video.smoothing = true;
			video.deblocking = 1;
			addChild( video );
			
			cover = new Sprite();
			addChild( cover );
		
		}
		
		public function display( visualData : * ) : void {
			var ns : NetStream = visualData as NetStream;
			if( ns ) {
				video.attachNetStream( ns );
			}
		}
		
		public function clear() : void {
			video.clear();
		}
		
		public function get displayObject() : DisplayObject {
			return this;
		}
		
		public function get visualDisplay() : * {
			return video;
		}
		
		override protected function onResize() : void {
			video.width = width;
			video.height = height;
			cover.graphics.clear();
			cover.graphics.beginFill( 0, 0 );
			cover.graphics.drawRect( 0, 0, width, height );
			cover.graphics.endFill();
		}
	}
}
