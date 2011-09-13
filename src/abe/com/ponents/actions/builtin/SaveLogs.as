package abe.com.ponents.actions.builtin 
{
    import abe.com.mon.utils.KeyStroke;
    import abe.com.ponents.monitors.LogView;
    import abe.com.ponents.skinning.icons.Icon;

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
		override public function execute( ... args ) : void 
		{
			this.data = _logView.textfield.text;
			super.execute.apply( this, args );
		}
	}
}
