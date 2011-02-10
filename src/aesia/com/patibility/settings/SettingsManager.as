package aesia.com.patibility.settings 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.patibility.settings.backends.SettingsBackend;
	/**
	 * @author cedric
	 */
	public class SettingsManager 
	{
		protected var _backend : SettingsBackend;

		public function SettingsManager () {}
		
		public function get ( o : *, p : String, defaults : * = null ) : *
		{
			var res: *;
			if( _backend )
				res = _backend.get(o, p);
			
			return  res != null ? res : defaults;
		}
		public function set ( o : *, p : String, value : * ) : Boolean
		{
			if( _backend )
				return _backend.set(o, p, value);
			else
				return false;
		}
		public function get settingsList () : Array { return _backend.settingsList; }
		public function get backend () : SettingsBackend { return _backend; }
		public function set backend (backend : SettingsBackend) : void
		{
			if(!_backend)
			{
				_backend = backend;
			}
			else throw new Error( _("The settings backend for a SettingsManager instance can be set only once.") );	
		}
		public function discardBackend () : void
		{
			var backend : SettingsBackend = _backend;
			_backend = null;
			
			/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
			Log.warn( _$( _("The settings backend $0 have been discarded, however discarding a settings backend isn't recommended. The discard backend can occur during the preload process if the backend don't respond during its initialization."), backend ) );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
	}
}
