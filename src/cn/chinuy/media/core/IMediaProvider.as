package cn.chinuy.media.core {
	import cn.chinuy.media.elements.visual.IVisualization;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * @author Chin
	 */
	public interface IMediaProvider extends IMediaElement {
		
		function clear() : void;
		
		function set visible( value : Boolean ) : void;
		function get visible() : Boolean;
		
		function set brightness( v : Number ) : void;
		function get brightness() : Number;
		
		function set contrast( c : Number ) : void;
		function get contrast() : Number;
		
		function get originalScale() : Number;
		
		function set scale( s : Number ) : void;
		function get scale() : Number;
		
		function set zoom( s : Number ) : void
		function get zoom() : Number;
		
		function get x() : Number;
		function set x( value : Number ) : void;
		
		function get y() : Number;
		function set y( value : Number ) : void;
		
		function get width() : Number;
		function set width( value : Number ) : void;
		
		function get height() : Number;
		function set height( value : Number ) : void;
		
		function setSize( width : Number, height : Number ) : void;
		
		function get visual() : IVisualization;
		function get visualRect() : Rectangle;
		function get displayObject() : DisplayObject;
	}
}
