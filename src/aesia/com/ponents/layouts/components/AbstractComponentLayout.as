/**
 * @license
 */
package aesia.com.ponents.layouts.components 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.utils.Insets;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Cédric Néhémie
	 */
	public class AbstractComponentLayout extends EventDispatcher implements ComponentLayout 
	{
		protected var _container : Container;
		
		public function AbstractComponentLayout ( container : Container = null )
		{
			super(null);
			this.container = container;
		}

		public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.LAYOUT ) );
		}
		
	
		public function get preferredSize () : Dimension { return null; }
		
		public function get container () : Container { return _container; }
		public function set container (o : Container) : void
		{
			_container = o;
		}
		
		override public function dispatchEvent( evt : Event) : Boolean 
		{
		 	if (hasEventListener(evt.type) || evt.bubbles) 
		  		return super.dispatchEvent(evt);
		 	return true;
		}
	}
}
