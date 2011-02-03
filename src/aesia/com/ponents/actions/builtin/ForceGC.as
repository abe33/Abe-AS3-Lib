/**
 * @license
 */
package aesia.com.ponents.actions.builtin 
{
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.skinning.icons.Icon;

	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	/**
	 * @author Cédric Néhémie
	 */
	public class ForceGC extends AbstractAction 
	{
		public function ForceGC (name : String = "", icon : Icon = null, longDescription : String = null, accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
		}

		override public function execute (e : Event = null) : void 
		{
			if( Capabilities.isDebugger )
			{
				System.gc();
			}
			else
			{
				try 
				{
				   new LocalConnection().connect('foo');
				   new LocalConnection().connect('foo');
				} 
				catch (e:*){}
			}
			super.execute( e );
		}
	}
}
