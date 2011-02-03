package aesia.com.ponents.actions.builtin 
{
	import aesia.com.ponents.monitors.LogView;
	import flash.events.Event;

	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.skinning.icons.Icon;
	/**
	 * @author cedric
	 */
	public class SaveLogs extends SaveFileAction 
	{
		protected var _logView : LogView;

		public function SaveLogs (  logView : LogView,
									fileName : String = null, 
									data : * = null, 
									name : String = "", 
									icon : Icon = null, 
									longDescription : String = null, 
									accelerator : KeyStroke = null)
		{
			super( fileName, data, name, icon, longDescription, accelerator );
			_logView = logView;
		}
		override public function execute (e : Event = null) : void 
		{
			this.data = _logView.textfield.text;
			super.execute( e );
		}
	}
}
