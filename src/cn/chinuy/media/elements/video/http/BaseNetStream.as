package cn.chinuy.media.elements.video.http {
	import cn.chinuy.media.elements.video.base.BaseStream;
	
	/**
	 * @author chin
	 */
	public class BaseNetStream extends BaseStream {
		
		protected var _timeInitial : Number = 0;
		protected var _bytesInitial : Number = 0;
		
		public function BaseNetStream() {
			super();
		}
		
		override public function get bytesInitial() : Number {
			return _bytesInitial;
		}
		
		override public function get timeInitial() : Number {
			return _timeInitial;
		}
		
		override protected function get streamTime() : Number {
			var t : Number = super.streamTime;
			if( _timeInitial > 0 && t <= 0 ) {
				t = timeTemporary;
			}
			return t;
		}
		
		override public function close() : void {
			_timeInitial = _bytesInitial = 0;
			super.close();
		}
		
		override public function play( ... parameters ) : void {
			_timeInitial = _bytesInitial = 0;
			super.play.apply( null, parameters );
		}
		
		override protected function streamSeek( offset : Number ) : Boolean {
			var s : Boolean = super.streamSeek( offset );
			if( !s ) {
				s = !durativeSeek && isSupportServerSeek();
				if( s ) {
					return serverSeek( offset );
				}
			}
			return s;
		}
		
		protected function isSupportServerSeek() : Boolean {
			return videoMetadata && videoMetadata.hasKeyframes;
		}
		
		protected function serverSeek( offset : Number ) : Boolean {
			var index : int = videoMetadata.getKeyframeIndex( offset, true );
			var s : Boolean = index >= 0;
			if( s ) {
				_bytesInitial = videoMetadata.getFileposition( index );
				_timeInitial = videoMetadata.getTime( index );
			}
			return s;
		}
	}
}
