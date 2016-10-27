package cn.chinuy.media.elements.video.http {
	import cn.chinuy.media.elements.video.base.VideoMetadata;
	import cn.chinuy.media.events.LoadEvent;
	
	/**
	 * @author chin
	 */
	public class MP4NetStream extends BaseNetStream {
		
		private var useTime : Boolean;
		private var key : String;
		
		public function MP4NetStream( loadPolicyFile : Boolean = false, useTime : Boolean = true, key : String = "start" ) {
			super();
			checkPolicyFile = loadPolicyFile;
			this.useTime = useTime;
			this.key = key;
		}
		
		override public function get time() : Number {
			return waiting ? timeTemporary : ( timeInitial + ns_time );
		}
		
		override protected function ns_seek( offset : Number ) : void {
			super.ns_seek( offset - timeInitial );
		}
		
		override protected function onMetaData( metadataObj : Object ) : void {
			super.onMetaData( metadataObj );
			var vmd : VideoMetadata = new VideoMetadata( metadataObj );
			_timeInitial = timeTotal - vmd.duration;
			if( vmd.filesize > 0 ) {
				_bytesInitial = bytesTotal - vmd.filesize;
			} else {
				_bytesInitial = bytesTotal * ( _timeInitial / timeTotal );
			}
		}
		
		override protected function checkLoadComplete() : void {
			_bytesInitial = bytesTotal - currentBytesTotal;
			super.checkLoadComplete();
		}
		
		override protected function isSupportServerSeek() : Boolean {
			return videoMetadata != null;
		}
		
		override protected function serverSeek( offset : Number ) : Boolean {
			if( !videoMetadata.hasKeyframes || !super.serverSeek( offset )) {
				_bytesInitial = bytesTotal * ( offset / timeTotal );
				_timeInitial = offset;
			}
			dispatchEvent( new LoadEvent( LoadEvent.Stop ));
			var p : Object = {};
			p[ key ] = useTime ? bytesInitial : timeInitial;
			hs_play( getFlvURL( url, p ));
			return true;
		}
	
	}
}
