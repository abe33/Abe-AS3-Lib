/**
 * @license
 */
package abe.com.ponents.layouts.display 
{
	import abe.com.mon.geom.Dimension;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Cédric Néhémie
	 */
	public class DONoLayout extends AbstractDisplayObjectLayout 
	{
		public function DONoLayout (container : DisplayObjectContainer = null)
		{
			super( container );
		}
		override public function get preferredSize () : Dimension
		{
			return new Dimension( 0, 0 );
		}
	}
}
