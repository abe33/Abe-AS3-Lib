/**
 * @license
 */
package abe.com.ponents.layouts.display 
{
    import abe.com.mon.geom.Dimension;
    import abe.com.ponents.utils.Insets;

    import flash.display.DisplayObjectContainer;
	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractDisplayObjectLayout implements DisplayObjectLayout 
	{
		protected var _container : DisplayObjectContainer;
		
		public function AbstractDisplayObjectLayout ( container : DisplayObjectContainer = null )
		{
			this.container = container;
		}

		public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void {}
		
		public function get preferredSize () : Dimension { return null; }
		public function get maximumContentSize () : Dimension { return null; }
		
		public function get container () : DisplayObjectContainer { return _container; }		
		public function set container (o : DisplayObjectContainer) : void { _container = o; }
	}
}
