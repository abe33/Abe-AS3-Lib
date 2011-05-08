/**
 * @license
 */
package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.Container;
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
