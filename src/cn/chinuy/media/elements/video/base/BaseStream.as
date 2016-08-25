package cn.chinuy.media.elements.video.base {
	import cn.chinuy.data.number.inRange;
	import cn.chinuy.media.elements.basic.Connection;
	import cn.chinuy.media.elements.basic.Stream;
	import cn.chinuy.media.events.BufferEvent;
	import cn.chinuy.media.events.LoadEvent;
	import cn.chinuy.media.events.PlayEvent;
	import cn.chinuy.media.events.SeekEvent;
	
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	
	/**
	 * @author chin
	 */
	public class BaseStream extends Stream {
		
		public static function getFlvURL( url : String, obj : Object ) : String {
			var paramArr : Array = [];
			for( var i : String in obj ) {
				paramArr.push( i + "=" + obj[ i ]);
			}
			var s : String = url.indexOf( "?" ) == -1 ? "?" : "&";
			return url + s + paramArr.join( "&" );
		}
		
		public static function getURL( path : String ) : String {
			return path.split( "?" )[ 0 ];
		}
		
		public static function compareURL( u1 : String, u2 : String ) : Boolean {
			if( u1 == null || u2 == null ) {
				return false;
			}
			return getURL( u1 ) == getURL( u2 );
		}
		
		public static function exact( i : Number, n : int ) : Number {
			n = Math.pow( 10, n );
			return Math.round( i * n ) / n;
		}
		
		protected var durativeSeek : Boolean;
		protected var loadCompleted : Boolean;
		protected var paused : Boolean;
		protected var seeking : Boolean;
		protected var checkPlayCompletePengding : Boolean;
		private var currentBytesLoadedValue : uint = 0;
		private var currentBytesTotalValue : uint = 0;
		private var seekFilter : Timer = new Timer( 300 );
		private var seekStateChecker : Timer = new Timer( 500 );
		private var bufferFullChecker : Timer = new Timer( 100 );
		private var loadProgressChecker : Timer = new Timer( 50 );
		private var seekOperatingValue : Boolean = false;
		
		public function BaseStream( connection : NetConnection = null ) {
			if( connection == null ) {
				connection = new Connection();
				connection.connect( null );
			}
			super( connection );
			seekFilter.addEventListener( TimerEvent.TIMER, seekTimeOut );
			seekStateChecker.addEventListener( TimerEvent.TIMER, checkSeekState );
			bufferFullChecker.addEventListener( TimerEvent.TIMER, checkBufferFull );
			loadProgressChecker.addEventListener( TimerEvent.TIMER, updateBytesLoaded );
		}
		
		override protected function initNetStatusHandler() : void {
			super.initNetStatusHandler();
			addNetStatusHandler( NetStatus.PlayStop, onPlayStop );
			addNetStatusHandler( NetStatus.SeekNotify, onSeekNotify );
			addNetStatusHandler( NetStatus.SeekComplete, onSeekComplete );
			addNetStatusHandler( NetStatus.SeekInvalidTime, onSeekInvalidTime );
		}
		
		override protected function onMetaData( metadataObj : Object ) : void {
			if( isNaN( metadataObj[ "filesize" ])) {
				metadataObj[ "filesize" ] = currentBytesTotal;
			}
			super.onMetaData( metadataObj );
		}
		
		override protected function onPlayStart() : void {
			if( !seeking ) {
				super.onPlayStart();
			}
		}
		
		override protected function onBufferEmpty() : void {
			timeTemporary = time;
			if( streamNotFound ) {
				setPlayError( false );
			} else {
				if( ns_loadEnd || buffering || paused ) {
					onInvalidBufferEmpty();
				} else {
					buffering = true;
					dispatchEvent( new BufferEvent( BufferEvent.Empty, BufferEvent.Play ));
				}
			}
		}
		
		protected function onSeekNotify() : void {
			checkPlayCompletePengding = false;
			if( seeking ) {
				seekEvent.status = SeekEvent.Notify;
				dispatchEvent( seekEvent );
			}
		}
		
		protected function onSeekComplete() : void {
		}
		
		protected function onSeekInvalidTime() : void {
			ns_seek( netStatusEvent.info[ "details" ]);
		}
		
		override protected function onBufferFull() : void {
			startCheckBufferFull();
		}
		
		protected function onPlayStop() : void {
			if( paused || seekOperating ) {
				checkPlayCompletePengding = true;
			} else {
				checkPlayCompletePengding = false;
				var end : Boolean = ( timeTotal - time ) <= 3 && timeTotal > 0;
				if( end && ns_loadEnd ) {
					finished = true;
					dispatchEvent( new PlayEvent( PlayEvent.Finish ));
				} else {
					setPlayError( true );
				}
			}
		}
		
		override protected function hs_play( url : String ) : void {
			startCheckLoadComplete();
			super.hs_play( url );
		}
		
		protected function get streamTime() : Number {
			return ns_time;
		}
		
		override protected function get waiting() : Boolean {
			return super.waiting || seeking;
		}
		
		protected function streamSeek( offset : Number ) : Boolean {
			var s : Boolean = offset >= timeInitial && ( offset < timeFinal || offset == timeTotal );
			if( s ) {
				if( offset + ns_bufferTime > timeTotal ) {
					ns_bufferTime = 0.1;
				}
				ns_seek( offset );
			}
			seekEvent.inBuffer = s;
			return s;
		}
		
		protected function adjustTime( value : Number ) : Number {
			return Math.floor( inRange( value, timeTotal ));
		}
		
		override public function seekStart( offset : Number ) : void {
			if( canSeek ) {
				offset = adjustTime( offset );
				
				durativeSeek = true;
				stopCheckBufferFull();
				ns_pause();
				stopSeekFilter();
				seekEvent = new SeekEvent( SeekEvent.Start );
				seekEvent.from = time;
				seekEvent.to = offset;
				dispatchEvent( seekEvent );
				seek( offset );
			}
		}
		
		override public function seekEnd( offset : Number ) : void {
			if( canSeek ) {
				offset = adjustTime( offset );
				
				durativeSeek = false;
				startSeekStateChecker();
				
				var success : Boolean = streamSeek( offset );
				seekEvent.to = offset;
				seekEvent.status = success ? SeekEvent.End : SeekEvent.Failed;
				dispatchEvent( seekEvent );
			}
		}
		
		override public function seek( offset : Number ) : void {
			if( canSeek ) {
				offset = adjustTime( offset );
				
				if( finished ) {
					finished = false;
					dispatchEvent( new PlayEvent( PlayEvent.Resume ));
				}
				
				var seekMode : Boolean = durativeSeek;
				if( !seekMode ) {
					seekStart( offset );
				}
				
				timeTemporary = offset;
				seeking = true;
				
				if( !seekFilterRunning ) {
					startSeekStateChecker( false );
					streamSeek( offset );
					startSeekFilter();
				}
				
				if( !seekMode ) {
					seekEnd( offset );
				}
			}
		}
		
		override public function togglePause() : void {
			if( failed )
				return;
			if( paused || finished ) {
				resume();
			} else {
				pause();
			}
		}
		
		override public function pause() : void {
			if( failed )
				return;
			if( !paused ) {
				paused = true;
				dispatchEvent( new PlayEvent( PlayEvent.Pause ));
				setVolume( 0 );
				if( canPause && !finished && !waiting ) {
					ns_pause();
				}
			}
		}
		
		override public function resume() : void {
			if( failed )
				return;
			if( finished ) {
				seek( 0 );
			} else if( paused ) {
				paused = false;
				dispatchEvent( new PlayEvent( PlayEvent.Resume ));
				setVolume( volume );
				if( canPause && !waiting ) {
					ns_resume();
				}
			}
		}
		
		override public function close() : void {
			stopSeekFilter();
			stopSeekStateChecker();
			stopCheckLoadComplete();
			super.close();
		}
		
		override public function get timeFinal() : Number {
			if( loading || buffering ) {
				return timeTemporary;
			}
			if( loadCompleted ) {
				return timeTotal;
			}
			if( videoMetadata && videoMetadata.hasKeyframes ) {
				var f : Number = bytesFinal;
				if( f >= videoMetadata.filesize ) {
					return timeTotal;
				} else {
					return exact( videoMetadata.filePosition2Time( f ), 3 );
				}
			} else if( bytesTotal > 0 && timeTotal > 0 ) {
				return exact( bytesFinal / bytesTotal * timeTotal, 3 );
			}
			return 0;
		}
		
		override public function get timeTotal() : Number {
			return videoMetadata ? videoMetadata.duration : 0;
		}
		
		override public function get time() : Number {
			if( finished ) {
				return timeTotal;
			} else if( waiting ) {
				return timeTemporary;
			} else {
				return streamTime;
			}
		}
		
		override public function get bytesFinal() : uint {
			return bytesInitial + currentBytesLoaded;
		}
		
		override public function get bytesLoaded() : uint {
			return currentBytesLoaded;
		}
		
		override public function get bytesTotal() : uint {
			if( videoMetadata ) {
				return videoMetadata.filesize;
			}
			return 0;
		}
		
		public function get currentBytesTotal() : uint {
			return currentBytesTotalValue;
		}
		
		public function get currentBytesLoaded() : uint {
			return currentBytesLoadedValue;
		}
		
		protected function get ns_loadEnd() : Boolean {
			return bytesTotal > 0 && bytesFinal >= bytesTotal;
		}
		
		protected function get ns_loadCompleted() : Boolean {
			return bytesTotal > 0 && currentBytesLoaded >= currentBytesTotal;
		}
		
		protected function get ns_loadEnough() : Boolean {
			return ns_loadEnd || bufferLength > bufferTime;
		}
		
		protected function get ns_time() : Number {
			return super.time;
		}
		
		protected function get seekOperating() : Boolean {
			return seekOperatingValue;
		}
		
		protected function startCheckLoadComplete() : void {
			ns_bufferTime = streamBufferTime;
			loadCompleted = false;
			currentBytesLoadedValue = currentBytesTotalValue = 0;
			loadProgressChecker.start();
		}
		
		protected function stopCheckLoadComplete() : void {
			ns_bufferTime = 0.1;
			loadProgressChecker.stop();
		}
		
		protected function startSeekStateChecker( seekOperateComplete : Boolean = true ) : void {
			seekOperatingValue = true;
			if( seekOperateComplete ) {
				seekStateChecker.stop();
				seekStateChecker.start();
			}
		}
		
		protected function stopSeekStateChecker() : void {
			seekStateChecker.stop();
			seekOperatingValue = false;
		}
		
		protected function startSeekFilter() : void {
			seekFilter.start();
		}
		
		protected function stopSeekFilter() : void {
			seekFilter.stop();
		}
		
		protected function get seekFilterRunning() : Boolean {
			return seekFilter.running;
		}
		
		private function checkSeekState( event : TimerEvent ) : void {
			stopSeekStateChecker();
			startCheckBufferFull();
			if( checkPlayCompletePengding ) {
				onPlayStop();
			}
		}
		
		private function seekTimeOut( e : TimerEvent ) : void {
			stopSeekFilter();
		}
		
		private function updateBytesLoaded( e : TimerEvent ) : void {
			if( !loadCompleted ) {
				var cbt : Number = base_bytesTotal;
				if(( currentBytesTotalValue > 0 && currentBytesTotalValue != cbt ) || cbt == 0xFFFFFFFF ) {
					return;
				}
				if( videoMetadata && videoMetadata.filesize <= 0 ) {
					videoMetadata.setValue( "filesize", cbt );
				}
				currentBytesLoadedValue = base_bytesLoaded;
				currentBytesTotalValue = cbt;
				checkLoadComplete();
			}
		}
		
		protected function checkLoadComplete() : void {
			if( ns_loadEnd ) {
				loadCompleted = true;
				stopCheckLoadComplete();
				dispatchEvent( new LoadEvent( LoadEvent.Stop ));
			}
		}
		
		protected function startCheckBufferFull() : void {
			bufferFullChecker.start();
			checkBufferFull();
		}
		
		protected function stopCheckBufferFull() : void {
			bufferFullChecker.stop();
		}
		
		protected function checkBufferFull( e : TimerEvent = null ) : void {
			
			if( !seekOperating && ns_loadEnough ) {
				
				stopCheckBufferFull();
				
				if( paused ) {
					ns_pause();
				} else {
					ns_resume();
				}
				
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
				
				if( seeking ) {
					seeking = false;
					seekEvent.status = SeekEvent.Full;
					dispatchEvent( seekEvent );
				}
			} else {
				ns_pause();
			}
		}
		
		protected function get base_bytesTotal() : uint {
			return super.bytesTotal;
		}
		
		protected function get base_bytesLoaded() : uint {
			return super.bytesLoaded;
		}
	}
}
