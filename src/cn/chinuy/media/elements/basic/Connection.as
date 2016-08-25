package cn.chinuy.media.elements.basic {
	import cn.chinuy.media.events.ConnectEvent;
	
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	
	/**
	 * @author chin
	 */
	public class Connection extends NetConnection {
		
		private var connectionConnected : Boolean;
		private var timer : Timer;
		
		public function Connection( timeout : int = 10000, client : Object = null ) {
			super();
			if( client == null ) {
				client = { onBWDone:function( ... rest ) : void {}};
			}
			this.client = client;
			addEventListener( NetStatusEvent.NET_STATUS, onNetStatus, false, int.MAX_VALUE );
			setTimeOut( timeout );
		}
		
		public function setTimeOut( time : int ) : void {
			if( timer == null ) {
				timer = new Timer( time );
			} else {
				timer.delay = time;
			}
		}
		
		override public function connect( command : String, ... parameters ) : void {
			if( timer ) {
				timer.addEventListener( TimerEvent.TIMER, onTimeOut );
				timer.start();
			}
			super.connect.apply( this, [ command ].concat( parameters ));
		}
		
		override public function close() : void {
			stopTimer();
			try {
				super.close();
			} catch( e : Error ) {
			}
		}
		
		private function stopTimer() : void {
			if( timer ) {
				timer.removeEventListener( TimerEvent.TIMER, onTimeOut );
				timer.stop();
			}
		}
		
		override public function get connected() : Boolean {
			return connectionConnected;
		}
		
		private function onTimeOut( event : TimerEvent ) : void {
			dispatchEvent( new NetStatusEvent( NetStatusEvent.NET_STATUS, false, false, { code:ConnectEvent.ConnectFailed, level:"error" }));
			close();
		}
		
		private function onNetStatus( event : NetStatusEvent ) : void {
			var code : String = event.info[ "code" ];
			switch( code ) {
				case ConnectEvent.ConnectSuccess:
					connectionConnected = true;
					stopTimer();
					break;
				default:
					connectionConnected = false;
					break;
			}
		}
	
	}
}
