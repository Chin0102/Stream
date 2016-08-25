package cn.chinuy.media.events {
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class PlayEvent extends Event {
		
		public static const All : String = "Media.Play.Event";
		
		public static const Start : String = "Media.Play.Start"; //--------------------- 开始播放
		public static const Ready : String = "Media.Play.Ready"; //--------------------- 准备就绪
		public static const Pause : String = "Media.Play.Pause"; //--------------------- 暂停播放
		public static const Resume : String = "Media.Play.Resume"; //------------------- 恢复播放
		public static const Finish : String = "Media.Play.Finish"; //------------------- 播放结束
		public static const Error : String = "Media.Play.Error"; //--------------------- 播放失败
		
		private var _status : String;
		
		public function PlayEvent( status : String ) {
			super( All );
			_status = status;
		}
		
		public function get status() : String {
			return _status;
		}
		
		override public function clone() : Event {
			return new PlayEvent( status );
		}
	
	}
}
