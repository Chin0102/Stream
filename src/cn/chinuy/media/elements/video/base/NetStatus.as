package cn.chinuy.media.elements.video.base {
	
	/**
	 * @author Chin
	 */
	public class NetStatus {
		
		public static const BufferEmpty : String = "NetStream.Buffer.Empty";
		public static const BufferFull : String = "NetStream.Buffer.Full";
		public static const BufferFlush : String = "NetStream.Buffer.Flush";
		
		public static const PlayStart : String = "NetStream.Play.Start";
		public static const PlayStop : String = "NetStream.Play.Stop";
		public static const PlayComplete : String = "NetStream.Play.Complete";
		public static const StreamNotFound : String = "NetStream.Play.StreamNotFound";
		
		public static const SeekNotify : String = "NetStream.Seek.Notify";
		public static const SeekComplete : String = "NetStream.Seek.Complete";
		public static const SeekInvalidTime : String = "NetStream.Seek.InvalidTime";
		
//		public static const PauseNotify : String = "NetStream.Pause.Notify";
//		public static const UnpauseNotify : String = "NetStream.Unpause.Notify";
		
		//Connection
		public static const ConnectSuccess : String = "NetConnection.Connect.Success";
		public static const ConnectClosed : String = "NetConnection.Connect.Closed";
		public static const NetworkChange : String = "NetConnection.Connect.NetworkChange";
		
		//Publish
		public static const BadStreamName : String = "NetStream.Publish.BadName";
		public static const PublishStart : String = "NetStream.Publish.Start";
	
	}
}
