package abe.com.ponents.actions.builtin 
{
	import abe.com.mon.utils.KeyStroke;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	/**
	 * @author cedric
	 */
	public class NavigateToURLAction extends AbstractAction 
	{
		protected var _query : URLRequest;
		protected var _target : String;

		public function NavigateToURLAction ( query : URLRequest, 
											  target : String = "_self",
											  name : String = "", 
											  icon : Icon = null, 
											  longDescription : String = null, 
											  accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
			_query = query;
			_target = target;
		}
		override public function execute (e : Event = null) : void 
		{
			navigateToURL( _query, _target );
			super.execute( e );
		}
	}
}
