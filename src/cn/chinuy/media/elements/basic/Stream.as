package cn.chinuy.media.elements.basic {
	import cn.chinuy.media.core.IMediaElement;
	import cn.chinuy.media.core.Metadata;
	import cn.chinuy.media.elements.video.base.BaseStream;
	import cn.chinuy.media.elements.video.base.NetStatus;
	import cn.chinuy.media.elements.video.base.VideoMetadata;
	import cn.chinuy.media.events.BufferEvent;
	import cn.chinuy.media.events.CuePointEvent;
	import cn.chinuy.media.events.LoadEvent;
	import cn.chinuy.media.events.PlayEvent;
	import cn.chinuy.media.events.SeekEvent;
	
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	/**
	 * @author chin
	 */
	public class Stream extends NetStream implements IMediaElement {
		
		protected var buffering : Boolean;
		protected var loading : Boolean;
		protected var finished : Boolean;
		protected var failed : Boolean;
		
		protected var streamNotFound : Boolean;
		protected var streamVolume : Number;
		protected var timeTemporary : Number = 0;
		protected var streamBufferTime : Number = 0.1;
		protected var videoMetadata : VideoMetadata;
		protected var ready_bufferFull : Boolean;
		protected var ready_metadata : Boolean;
		protected var netStatusEvent : NetStatusEvent;
		private var readyState : int;
		private var readyDelay : Timer = new Timer( 500 );
		private var _connection : NetConnection;
		private var ns_urlValue : String;
		private var ns_pausedValue : Boolean = false;
		private var netStatusHandlerMap : Object = {};
		
		protected var seekEvent : SeekEvent;
		
		public function Stream( connection : NetConnection, peerID : String = "connectToFMS" ) {
			super( connection, peerID );
			_connection = connection;
			readyDelay.addEventListener( TimerEvent.TIMER, dispatchStreamReady );
			addEventListener( NetStatusEvent.NET_STATUS, onStreamStatus, false, int.MAX_VALUE );
			client = newClient();
			initNetStatusHandler();
		}
		
		protected function newClient() : Object {
			return { onMetaData:onMetaData, onCuePoint:onCuePoint };
		}
		
		public function get connection() : NetConnection {
			return _connection;
		}
		
		private function onStreamStatus( event : NetStatusEvent ) : void {
			event.stopImmediatePropagation();
			netStatusEvent = event;
			var code : String = event.info[ "code" ];
			var handler : Function = netStatusHandlerMap[ code ];
			if( handler != null ) {
				handler();
			}
		}
		
		protected function initNetStatusHandler() : void {
			addNetStatusHandler( NetStatus.PlayStart, onPlayStart );
			addNetStatusHandler( NetStatus.BufferFull, onBufferFull );
			addNetStatusHandler( NetStatus.BufferEmpty, onBufferEmpty );
			addNetStatusHandler( NetStatus.StreamNotFound, onStreamNotFound );
		}
		
		protected function onCuePoint( data : Object ) : void {
			dispatchEvent( new CuePointEvent( data ));
		}
		
		protected function onMetaData( metadataObj : Object ) : void {
			if( !ready_metadata ) {
				ready_metadata = true;
				videoMetadata = new VideoMetadata( metadataObj );
				onFirstMetaData();
				checkStreamReady();
			}
		}
		
		protected function checkStreamReady() : void {
			if( ready_bufferFull && ready_metadata && readyState == 0 ) {
				readyState = 1;
				readyDelay.start();
			}
		}
		
		private function dispatchStreamReady( e : TimerEvent ) : void {
			readyState = 2;
			readyDelay.stop();
			dispatchEvent( new PlayEvent( PlayEvent.Ready ));
		}
		
		protected function onFirstMetaData() : void {
			bufferTime = streamBufferTime;
		}
		
		protected function onPlayStart() : void {
			dispatchEvent( new PlayEvent( PlayEvent.Start ));
		}
		
		protected function onBufferFull() : void {
			if( loading ) {
				loading = false;
				dispatchEvent( new BufferEvent( BufferEvent.Full, BufferEvent.Load ));
				if( !ready_bufferFull ) {
					ready_bufferFull = true;
					checkStreamReady();
				}
			}
			
			if( buffering ) {
				buffering = false;
				dispatchEvent( new BufferEvent( BufferEvent.Full, BufferEvent.Play ));
			}
		}
		
		protected function onBufferEmpty() : void {
			timeTemporary = time;
			if( streamNotFound ) {
				setPlayError( false );
			} else {
				if( buffering ) {
					onInvalidBufferEmpty();
				} else {
					buffering = true;
					dispatchEvent( new BufferEvent( BufferEvent.Empty, BufferEvent.Play ));
				}
			}
		}
		
		protected function onInvalidBufferEmpty() : void {
		}
		
		protected function onStreamNotFound() : void {
			streamNotFound = true;
			if( loading || buffering ) {
				setPlayError( false );
			}
		}
		
		protected function setPlayError( fromFinish : Boolean ) : void {
			failed = true;
			dispatchEvent( new PlayEvent( PlayEvent.Error ));
		}
		
		protected function hs_play( url : String ) : void {
			timeTemporary = time;
			loading = true;
			streamNotFound = false;
			ns_play( url );
			dispatchEvent( new LoadEvent( LoadEvent.Start ));
		}
		
		protected function get waiting() : Boolean {
			return loading || buffering;
		}
		
		protected function get stopped() : Boolean {
			return finished || failed;
		}
		
		override public function play( ... parameters ) : void {
			failed = finished = false;
			var playURL : String = parameters[ 0 ];
			var same : Boolean = BaseStream.compareURL( ns_urlValue, playURL );
			if( !same ) {
				videoMetadata = null;
				ready_metadata = ready_bufferFull = false;
			}
			ns_urlValue = playURL;
			hs_play( url );
		}
		
		public function seekStart( offset : Number ) : void {
		}
		
		public function seekEnd( offset : Number ) : void {
		}
		
		public function get visualData() : * {
			return this;
		}
		
		protected function setVolume( value : Number ) : void {
			var st : SoundTransform = soundTransform;
			st.volume = value;
			soundTransform = st;
		}
		
		public function set volume( value : Number ) : void {
			streamVolume = value;
			setVolume( value );
		}
		
		public function get volume() : Number {
			return streamVolume;
		}
		
		public function get url() : String {
			return ns_url;
		}
		
		public function get metadata() : Metadata {
			return videoMetadata;
		}
		
		public function get ready() : Boolean {
			return readyState == 2;
		}
		
		public function get canPause() : Boolean {
			return ready;
		}
		
		public function get canSeek() : Boolean {
			return ready;
		}
		
		public function get timeFinal() : Number {
			return 0;
		}
		
		public function get timeTotal() : Number {
			return 0;
		}
		
		public function get timeInitial() : Number {
			return 0;
		}
		
		public function get bytesInitial() : uint {
			return 0;
		}
		
		public function get bytesFinal() : uint {
			return 0;
		}
		
		protected function addNetStatusHandler( code : String, handler : Function ) : void {
			netStatusHandlerMap[ code ] = handler;
		}
		
		protected function delNetStatusHandler( code : String ) : void {
			delete netStatusHandlerMap[ code ];
		}
		
		protected function get ns_url() : String {
			return ns_urlValue;
		}
		
		protected function get ns_bufferLength() : Number {
			return super.bufferLength;
		}
		
		protected function get ns_bufferTime() : Number {
			return super.bufferTime;
		}
		
		protected function set ns_bufferTime( value : Number ) : void {
			super.bufferTime = value;
		}
		
		protected function get ns_bufferFull() : Boolean {
			return ns_bufferLength >= ns_bufferTime;
		}
		
		protected function get ns_paused() : Boolean {
			return ns_pausedValue;
		}
		
		protected function ns_play( url : String ) : void {
			ns_pausedValue = false;
			super.play( url );
		}
		
		protected function ns_seek( offset : Number ) : void {
			super.seek( offset );
		}
		
		protected function ns_pause() : void {
			ns_pausedValue = true;
			super.pause();
		}
		
		protected function ns_resume() : void {
			ns_pausedValue = false;
			super.resume();
		}
		
		override public function get bufferTime() : Number {
			return streamBufferTime;
		}
		
		override public function set bufferTime( bufferTime : Number ) : void {
			streamBufferTime = checkBufferTime( bufferTime );
			ns_bufferTime = streamBufferTime;
		}
		
		protected function checkBufferTime( time : Number ) : Number {
			if( videoMetadata && videoMetadata.duration < time ) {
				return 0.1;
			}
			return time;
		}
	}
}
