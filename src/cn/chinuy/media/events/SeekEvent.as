package cn.chinuy.media.events {
	import flash.events.Event;
	
	/**
	 * @author chin
	 */
	public class SeekEvent extends Event {
		
		public static const All : String = "Media.Seek.Event";
		
		public static const Start : String = "Media.Seek.Start"; //--------------------- 拖动操作开始
		public static const Notify : String = "Media.Seek.Notify"; //------------------- 拖动操作中
		public static const Failed : String = "Media.Seek.Failed"; //------------------- 拖动操作结束
		public static const End : String = "Media.Seek.End"; //------------------------- 拖动操作结束
		public static const Full : String = "Media.Seek.BufferFull"; //----------------- 拖动后缓冲区满
		
		public var status : String;
		public var inBuffer : Boolean;
		public var from : Number;
		public var to : Number;
		
		public function SeekEvent( status : String ) {
			super( All );
			this.status = status;
		}
		
		override public function clone() : Event {
			var seekEvent : SeekEvent = new SeekEvent( status );
			seekEvent.from = from;
			seekEvent.to = to;
			seekEvent.inBuffer = inBuffer;
			return seekEvent;
		}
	
	}
}
