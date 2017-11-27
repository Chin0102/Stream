package cn.chinuy.media.core {
	
	import flash.events.IEventDispatcher;
	
	/**
	 * @author chin
	 */
	public interface IMediaElement extends IEventDispatcher {
		
		function play( ... parameters ) : void;
		function close() : void;
		
		function seekStart( offset : Number ) : void;
		function seekEnd( offset : Number ) : void;
		function seek( offset : Number ) : void;
		
		function togglePause() : void;
		function pause() : void;
		function resume() : void;
		
		function get visualData() : *;
		function set volume( value : Number ) : void;
		function get volume() : Number;
		
		function get url() : String;
		function get metadata() : Metadata;
		function get canPause() : Boolean;
		function get canSeek() : Boolean;
		
		function get bufferLength() : Number;
		function get bufferTime() : Number;
		function set bufferTime( value : Number ) : void;
		
		//当前加载段的起始位置
		function get bytesInitial() : Number;
		//当前加载段的结束位置
		function get bytesFinal() : Number;
		
		function get timeInitial() : Number;
		function get timeFinal() : Number;
		function get time() : Number;
		function get timeTotal() : Number;
	}
}
