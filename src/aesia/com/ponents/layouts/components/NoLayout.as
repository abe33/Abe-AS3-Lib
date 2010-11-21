/**
 * @license
 */
package aesia.com.ponents.layouts.components 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.Container;

	/**
	 * @author Cédric Néhémie
	 */
	public class NoLayout extends AbstractComponentLayout 
	{
		public function NoLayout (container : Container = null)
		{
			super( container );
		}
		override public function get preferredSize () : Dimension
		{
			return new Dimension( 0, 0 );
		}
	}
}
