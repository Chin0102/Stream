package cn.chinuy.media.elements.visual {
	import flash.media.Camera;
	
	/**
	 * @author chin
	 */
	public class CameraVisualization extends NetStreamVisualization {
		
		public function CameraVisualization() {
			super();
		}
		
		override public function display( visualData : * ) : void {
			var camera : Camera = visualData as Camera;
			if( camera ) {
				video.attachCamera( camera );
			}
		}
	}
}
