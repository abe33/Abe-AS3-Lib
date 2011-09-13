/**
 * @license
 */
package abe.com.ponents.actions.builtin 
{
    import abe.com.mon.utils.KeyStroke;
    import abe.com.ponents.actions.AbstractAction;
    import abe.com.ponents.skinning.icons.Icon;

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

		override public function execute( ... args ) : void 
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
			super.execute.apply( this, args );
		}
	}
}
