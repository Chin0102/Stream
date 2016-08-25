package cn.chinuy.media.events {
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class PublishEvent extends Event {
		
		public static const All : String = "Media.Publish.Event";
		
		public static const Start : String = "Media.Publish.Start";
		
//		public static const Pause : String = "Media.Play.Pause";
//		public static const Resume : String = "Media.Play.Resume";
//		public static const Finish : String = "Media.Publish.Finish";
//		public static const Error : String = "Media.Publish.Error";
		
		private var _status : String;
		
		public function PublishEvent( status : String ) {
			super( All );
			_status = status;
		}
		
		public function get status() : String {
			return _status;
		}
		
		override public function clone() : Event {
			return new PublishEvent( status );
		}
	}
}
