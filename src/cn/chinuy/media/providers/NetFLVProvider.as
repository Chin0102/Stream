package cn.chinuy.media.providers {
	import cn.chinuy.media.elements.video.http.FLVNetStream;
	
	/**
	 * @author chin
	 */
	public class NetFLVProvider extends VideoProvider {
		
		public function NetFLVProvider( loadPolicyFile : Boolean = false, useTime : Boolean = false, key : String = "start" ) {
			super( new FLVNetStream( loadPolicyFile, useTime, key ));
		}
	}
}
