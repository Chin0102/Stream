package cn.chinuy.media.elements.visual {
	import flash.display.DisplayObject;
	
	/**
	 * @author Chin
	 */
	public interface IVisualization {
		
		function get visible() : Boolean;
		function set visible( value : Boolean ) : void;
		
		function get x() : Number;
		function set x( value : Number ) : void;
		
		function get y() : Number;
		function set y( value : Number ) : void;
		
		function get width() : Number;
		function set width( value : Number ) : void;
		
		function get height() : Number;
		function set height( value : Number ) : void;
		
		function get displayObject() : DisplayObject;
		function get visualDisplay() : *;
		
		function display( visualData : * ) : void;
		function clear() : void;
	}
}
