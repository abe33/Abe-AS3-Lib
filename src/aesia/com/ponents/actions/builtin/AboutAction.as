package aesia.com.ponents.actions.builtin 
{
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.containers.Dialog;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.text.Label;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class AboutAction extends AbstractAction 
	{
		private var _appName : String;
		private var _appVersion : String;
		private var _appAbout : String;
		protected var _appCopyright : String;

		public function AboutAction ( 
										appName : String,
										appVersion : String,
										appAbout : String,										appCopyright : String,
										
										name : String = "", 
										icon : Icon = null, 
										
										longDescription : String = null, 
										accelerator : KeyStroke = null
									)
		{
			super( name, icon, longDescription, accelerator );
			_appName = appName;
			_appVersion = appVersion;			_appAbout = appAbout;
			_appCopyright = appCopyright;
		}
		override public function execute (e : Event = null) : void 
		{
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout(p, 3, "left", "top", "topToBottom", true );
			
			p.addComponent( new Label( _$( "$0 v$1", _appName, _appVersion ) ) );
			p.addComponent( new Label( _appAbout ) );			p.addComponent( new Label( _appCopyright ) );
			
			var d : Dialog = new Dialog( _("About"), Dialog.CLOSE_BUTTON, p );
			d.open( Dialog.CLOSE_ON_RESULT );
			
			super.execute( e );
		}
	}
}
