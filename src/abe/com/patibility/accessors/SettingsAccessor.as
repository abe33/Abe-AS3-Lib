package abe.com.patibility.accessors 
{
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.StringUtils;
	import abe.com.patibility.settings.SettingsManager;
	/**
	 * @author cedric
	 */
	public class SettingsAccessor implements Accessor 
	{
		protected var _manager : SettingsManager;
		protected var _setting : String;

		public function SettingsAccessor ( manager : SettingsManager, setting : String ) 
		{
			_manager = manager;
			_setting = setting;
		}
		public function get () : * { return _manager.backend.getWithQuery( _setting ); }
		public function set (v : *) : void { _manager.backend.setWithQuery( _setting, v );  }
		
		public function get value () : * { return get(); }
		public function set value (v : *) : void { set( v ); 
		}
		public function get manager () : SettingsManager { return _manager; }
		public function set manager (manager : SettingsManager) : void { _manager = manager; }
		
		public function get setting () : String { return _setting; }
		public function set setting (setting : String) : void { _setting = setting;	}
		
		public function get type() : String { return Reflection.getClassName( get() ); }
		
		 public function toString() : String { return StringUtils.stringify( this, {'setting':_setting} ); }
	}
}
