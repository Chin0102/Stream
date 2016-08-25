package cn.chinuy.media.providers {
	import cn.chinuy.media.core.Metadata;
	import cn.chinuy.media.elements.basic.Connection;
	import cn.chinuy.media.elements.live.PublishStream;
	import cn.chinuy.media.elements.video.base.NetStatus;
	import cn.chinuy.media.elements.video.base.VideoMetadata;
	import cn.chinuy.media.elements.visual.CameraVisualization;
	import cn.chinuy.media.elements.visual.IVisualization;
	import cn.chinuy.media.events.PublishEvent;
	
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	
	/**
	 * @author chin
	 */
	public class LivePublisher extends LiveProvider {
		
		protected var publishStream : PublishStream;
		protected var publishConnection : Connection;
		protected var cameraVisualization : CameraVisualization;
		protected var streamVisualization : IVisualization;
		
		private var vm : VideoMetadata;
		
		private var streamName : String;
		
		private var _displayStream : Boolean = false;
		private var camera : Camera;
		private var microphone : Microphone;
		
		private var liveWidth : int = 640;
		private var liveHeight : int = 480;
		
		public function LivePublisher( server : String ) {
			super( server );
			streamVisualization = visualization;
			cameraVisualization = new CameraVisualization();
			publishConnection = new Connection();
			publishConnection.addEventListener( NetStatusEvent.NET_STATUS, onPublishConnectStatus );
			publishConnection.connect( server );
		}
		
		override protected function initVisualization( mediaVisualization : IVisualization ) : void {
			if( visualization != null ) {
				removeChild( visualization.displayObject );
			}
			visualization = mediaVisualization;
			addChild( visualization.displayObject );
			updateVisualization();
		}
		
		protected function onPublishConnectStatus( event : NetStatusEvent ) : void {
			if( event.info[ "code" ] == NetStatus.ConnectSuccess ) {
				createPublisher();
			}
		}
		
		protected function createPublisher() : void {
			publishStream = new PublishStream( publishConnection );
			publishStream.addEventListener( PublishEvent.All, dispatchEvent );
			publish( camera, microphone );
		}
		
		public function addCuePoint( data : Object ) : void {
			if( publishStream ) {
				data.time = publishStream.time;
				data.type = "event";
				publishStream.send( "@setDataFrame", "onCuePoint", data );
			}
		}
		
		public function addMetaData( data : Object ) : void {
			if( publishStream )
				publishStream.send( "@setDataFrame", "onMetaData", data );
		}
		
		public function send( handlerName : String, ... params ) : void {
			if( publishStream )
				publishStream.send.apply( this, [ handlerName ].concat( params ));
		}
		
		public function setLiveSize( width : int, height : int ) : void {
			liveWidth = width;
			liveHeight = height;
			if( camera ) {
				var b : Number = 220 + ( liveWidth - 320 ) * ( liveHeight - 240 ) / ( 960 * 480 ) * 480;
				var bandwidth : int = b * 1000 / 8;
				camera.setQuality( bandwidth, 0 );
				camera.setMode( liveWidth, liveHeight, 24 );
			}
		}
		
		public function publish( camera : Camera, microphone : Microphone ) : void {
			this.camera = camera;
			this.microphone = microphone;
			if( publishStream ) {
				if( camera ) {
					camera.setLoopback( true );
					camera.setKeyFrameInterval( 48 );
					setLiveSize( liveWidth, liveHeight );
					publishStream.attachCamera( camera );
				}
				if( microphone ) {
					publishStream.attachAudio( microphone );
				}
			}
		}
		
		override public function close() : void {
			super.close();
			if( publishStream ) {
				publishStream.close();
			}
			publishConnection.close();
		}
		
		override public function play( ... parameters ) : void {
			if( element ) {
				streamName = parameters[ 0 ];
				publishStream.publish( streamName );
				var data : Object = { width:camera.width, height:camera.height };
				vm = new VideoMetadata( data );
				addMetaData( data );
				switchVisualization();
			} else {
				super.play.apply( this, parameters );
			}
		}
		
		override public function get metadata() : Metadata {
			return vm;
		}
		
		override public function get time() : Number {
			if( publishStream )
				return publishStream.time;
			return 0;
		}
		
		public function get displayStream() : Boolean {
			return _displayStream;
		}
		
		public function set displayStream( value : Boolean ) : void {
			_displayStream = value;
			switchVisualization();
		}
		
		protected function switchVisualization() : void {
			if( displayStream ) {
				initVisualization( streamVisualization );
				streamVisualization.display( visualData );
				super.play( streamName );
			} else {
				initVisualization( cameraVisualization );
				cameraVisualization.display( camera );
			}
		}
	}
}
