package cn.chinuy.media.core {
	
	/**
	 * @author Chin
	 */
	public interface IMediaContainer extends IMediaProvider {
		function get presetZoom() : String
		function set presetZoom( zoom : String ) : void;
		function get presetScale() : String;
		function set presetScale( scale : String ) : void;
		function get provider() : IMediaProvider;
		function set provider( m : IMediaProvider ) : void;
		function get hasProvider() : Boolean;
		function removeProvider() : void;
	}
}
