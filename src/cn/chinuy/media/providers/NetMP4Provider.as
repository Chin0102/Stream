package cn.chinuy.media.providers {
	import cn.chinuy.media.elements.video.http.MP4NetStream;
	
	/**
	 * @author chin
	 */
	public class NetMP4Provider extends VideoProvider {
		
		public function NetMP4Provider( loadPolicyFile : Boolean = false ) {
			super( new MP4NetStream( loadPolicyFile ));
		}
	}
}
