package cn.chinuy.media.providers {
	import cn.chinuy.media.core.Metadata;
	import cn.chinuy.media.elements.basic.Connection;
	import cn.chinuy.media.elements.live.LiveStream;
	import cn.chinuy.media.elements.visual.NetStreamVisualization;
	import cn.chinuy.media.events.ConnectEvent;
	import cn.chinuy.media.events.SettingEvent;
	
	import flash.events.NetStatusEvent;
	
	/**
	 * @author chin
	 */
	public class LiveProvider extends MediaProvider {
		
		protected var connection : Connection;
		private var playParameters : Array;
		private var volumeValue : Number = 1;
		private var bufferTimeValue : Number = 1;
		
		private var server : String;
		
		public function LiveProvider( server : String ) {
			super( new NetStreamVisualization());
			this.server = server;
			width = 500;
			height = 400;
			connection = new Connection();
		}
		
		protected function onConnectStatus( event : NetStatusEvent ) : void {
			var code : String = event.info[ "code" ];
			dispatchEvent( new ConnectEvent( code ));
			if( code == ConnectEvent.ConnectSuccess ) {
				createElement();
			}
		}
		
		protected function createElement() : void {
			initElement( new LiveStream( connection ));
			element.volume = volumeValue;
			element.bufferTime = bufferTimeValue;
			if( playParameters ) {
				play.apply( this, playParameters );
			}
		}
		
		public function connect() : void {
			if( connection.connected ) {
				createElement();
			} else {
				connection.addEventListener( NetStatusEvent.NET_STATUS, onConnectStatus );
				connection.connect( server );
			}
		}
		
		override public function play( ... parameters ) : void {
			if( element ) {
				super.play.apply( this, parameters );
				playParameters = null;
			} else {
				playParameters = parameters;
			}
		}
		
		override public function close() : void {
			if( element )
				element.close();
			connection.close();
		}
		
		override public function seekStart( offset : Number ) : void {
		}
		
		override public function seekEnd( offset : Number ) : void {
		}
		
		override public function seek( offset : Number ) : void {
		}
		
		override public function togglePause() : void {
		}
		
		override public function pause() : void {
		}
		
		override public function resume() : void {
		}
		
		override public function get visualData() : * {
			if( element )
				return element.visualData;
			return null;
		}
		
		override public function set volume( value : Number ) : void {
			volumeValue = value;
			if( element ) {
				element.volume = value;
			}
			dispatchSettingEvent( SettingEvent.VolumeChanged, volume );
		}
		
		override public function get volume() : Number {
			if( element )
				return element.volume;
			return volumeValue;
		}
		
		override public function get url() : String {
			if( element )
				return element.url;
			if( playParameters )
				return playParameters[ 0 ];
			return null;
		}
		
		override public function get metadata() : Metadata {
			if( element )
				return element.metadata;
			return null;
		}
		
		override public function get canPause() : Boolean {
			return false;
		}
		
		override public function get canSeek() : Boolean {
			return false;
		}
		
		override public function get bufferLength() : Number {
			if( element )
				return element.bufferLength;
			return 0;
		}
		
		override public function get bufferTime() : Number {
			if( element )
				return element.bufferTime;
			return bufferTimeValue;
		}
		
		override public function set bufferTime( value : Number ) : void {
			if( element )
				element.bufferTime = value;
			else
				bufferTimeValue = value;
		}
		
		override public function get time() : Number {
			if( element )
				return element.time;
			return 0;
		}
		
		override public function get timeInitial() : Number {
			return 0;
		}
		
		override public function get timeFinal() : Number {
			return 0;
		}
		
		override public function get timeTotal() : Number {
			return 0;
		}
		
		override public function get bytesInitial() : Number {
			return 0;
		}
		
		override public function get bytesFinal() : Number {
			return 0;
		}
	}
}
