package abe.com.ponents.actions.builtin 
{
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.text.Label;
	/**
	 * @author cedric
	 */
	public class AboutAction extends AbstractAction 
	{
		protected var _appName : String;
		protected var _appVersion : String;
		protected var _appAbout : String;
		protected var _appCopyright : String;

		public function AboutAction ( 
										appName : String,
										appVersion : String,
										appAbout : String,										appCopyright : String,
										
										actionName : String = "", 
										actionIcon : Icon = null, 
										
										actionDescription : String = null, 
										actionAccelerator : KeyStroke = null
									)
		{
			super( actionName, actionIcon, actionDescription, actionAccelerator );
			_appName = appName;
			_appVersion = appVersion;			_appAbout = appAbout;
			_appCopyright = appCopyright;
		}
		override public function execute( ... args ) : void 
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
