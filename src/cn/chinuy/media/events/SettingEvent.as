package cn.chinuy.media.events {
	import flash.events.Event;
	
	/**
	 * @author Chin
	 */
	public class SettingEvent extends Event {
		
		public static const All : String = "Media.Setting.Event";
		
		public static const BrightnessChanged : String = "Media.Setting.Brightness"; //----- 亮度
		public static const ContrastChanged : String = "Media.Setting.Contrast"; //--------- 对比度
		public static const ScaleChanged : String = "Media.Setting.Scale"; //--------------- 高宽比例
		public static const ZoomChanged : String = "Media.Setting.Zoom"; //--------------- 缩放
		public static const VolumeChanged : String = "Media.Setting.Volume"; //------------- 音量
		
		private var _settingType : String;
		private var _value : Number;
		
		public function SettingEvent( settingType : String, value : Number = NaN ) {
			super( All );
			_settingType = settingType;
			_value = value;
		}
		
		override public function clone() : Event {
			return new SettingEvent( settingType, value );
		}
		
		public function get settingType() : String {
			return _settingType;
		}
		
		public function get value() : Number {
			return _value;
		}
	}
}
