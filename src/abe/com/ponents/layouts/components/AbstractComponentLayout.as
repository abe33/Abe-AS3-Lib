/**
 * @license
 */
package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.utils.Insets;

	import org.osflash.signals.Signal;
	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractComponentLayout implements ComponentLayout 
	{
		protected var _container : Container;
		protected var _lastMaximumContentSize:Dimension;
		
		public var layoutDone : Signal;
		
		public function AbstractComponentLayout ( container : Container = null )
		{
		    layoutDone = new Signal();
			this.container = container;
		}

		public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			layoutDone.dispatch( this );
		}
	
		public function get preferredSize () : Dimension { return null; }
		public function get maximumContentSize () : Dimension { return _lastMaximumContentSize ? _lastMaximumContentSize : preferredSize; }
		
		public function get container () : Container { return _container; }
		public function set container (o : Container) : void { _container = o; }

	}
}
