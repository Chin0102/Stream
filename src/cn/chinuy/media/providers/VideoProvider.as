package cn.chinuy.media.providers {
	import cn.chinuy.media.core.IMediaElement;
	import cn.chinuy.media.elements.video.base.BaseStream;
	import cn.chinuy.media.elements.visual.NetStreamVisualization;
	
	/**
	 * @author chin
	 */
	public class VideoProvider extends MediaProvider {
		
		public function VideoProvider( element : IMediaElement = null ) {
			super( new NetStreamVisualization());
			if( element == null ) {
				element = new BaseStream();
			}
			initElement( element );
			width = 500;
			height = 400;
		}
	
	}
}
