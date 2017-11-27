package cn.chinuy.media.elements.video.base {
	import cn.chinuy.media.core.Metadata;
	
	/**
	 * @author Chin
	 */
	public class VideoMetadata extends Metadata {
		
		private var _keyframeLength : uint;
		private var _filepositions : Array;
		private var _times : Array;
		
		public function VideoMetadata( data : Object ) {
			super( data );
			var keyframes : Object = data[ "keyframes" ];
			if( keyframes ) {
				_filepositions = keyframes[ "filepositions" ];
				_times = keyframes[ "times" ];
				_keyframeLength = _filepositions.length;
			} else {
				_filepositions = [];
				_times = [];
				var seekpoints : Array = data[ "seekpoints" ];
				if( seekpoints ) {
					_keyframeLength = seekpoints.length;
					for( var i : int = 0; i < _keyframeLength; i++ ) {
						_filepositions.push( seekpoints[ i ][ "offset" ]);
						_times.push( seekpoints[ i ][ "time" ]);
					}
				}
			}
		}
		
		override public function get duration() : Number {
			var d : Number = getValue( "duration" );
			if( isNaN( d ))
				d = 0;
			return d;
		}
		
		override public function get filesize() : Number {
			var size : Number = getValue( "filesize" );
			if( isNaN( size ))
				size = 0;
			return size;
		}
		
		override public function get width() : Number {
			return getValue( "width" );
		}
		
		override public function get height() : Number {
			return getValue( "height" );
		}
		
		override public function get scale() : Number {
			var _w : Number = width;
			var _h : Number = height;
			if( !isNaN( _w ) && !isNaN( _h )) {
				return _w / _h;
			}
			return 0;
		}
		
		public function get canSeekToEnd() : Boolean {
			return getValue( "canSeekToEnd" ) || getTime( _keyframeLength - 1 ) == duration;
		}
		
		public function get hasKeyframes() : Boolean {
			return _keyframeLength > 0;
		}
		
		public function get keyframeLength() : int {
			return _keyframeLength;
		}
		
		public function getFileposition( index : int ) : Number {
			if( index < 0 || index >= _keyframeLength )
				return -1;
			return _filepositions[ index ];
		}
		
		public function getTime( index : int ) : Number {
			if( index < 0 || index >= _keyframeLength )
				return -1;
			return _times[ index ];
		}
		
		public function getFilepositionIndex( fileposition : Number ) : int {
			return _filepositions.indexOf( fileposition );
		}
		
		public function getTimeIndex( time : Number ) : int {
			return _times.indexOf( time );
		}
		
		public function setKeyframe( index : int, filePosition : Number, time : Number ) : void {
			if( hasKeyframes && index < _filepositions.length ) {
				_times[ index ] = time;
				_filepositions[ index ] = filePosition;
			}
		}
		
		public function removeKeyframes( index : int ) : void {
			if( hasKeyframes ) {
				_times.splice( index, 1 );
				_filepositions.splice( index, 1 );
				_keyframeLength = _filepositions.length;
			}
		}
		
		public function getKeyframeIndex( position : Number, byTime : Boolean = true ) : int {
			if( !hasKeyframes )
				return -1;
			var arr : Array = byTime ? _times : _filepositions;
			
			var start : int = 0;
			var end : int = _keyframeLength; // - ( canSeekToEnd ? 2 : 1 );
			
			while( end - start > 1 ) {
				var index : int = start + Math.floor(( end - start ) / 2 );
				if( position >= arr[ index ]) {
					start = index;
				} else {
					end = index;
				}
			}
			
			return start;
		}
		
		public function filePosition2Time( filePosition : Number ) : Number {
			if( hasKeyframes ) {
				var i1 : int = getKeyframeIndex( filePosition, false );
				var t1 : Number = getTime( i1 );
				var f1 : Number = getFileposition( i1 );
				var i2 : int = i1 + 1;
				var t2 : Number, f2 : Number;
				if( i2 < keyframeLength ) {
					t2 = getTime( i2 );
					f2 = getFileposition( i2 );
				} else {
					t2 = duration;
					f2 = filesize;
				}
				if( t1 >= 0 && t2 >= 0 && f1 >= 0 && f1 >= 0 ) {
					var t : Number = (( filePosition - f1 ) * ( t2 - t1 )) / ( f2 - f1 ) + t1;
					return t; //exact( t, 3 );
				}
			} else {
				return filePosition / duration * filesize;
			}
			return 0;
		}
	
	}
}
