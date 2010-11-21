package aesia.com.ponents.models 
{
	import flash.ui.ContextMenuItem;

	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.events.ComponentEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Cédric Néhémie
	 */
	[Event(name="dataChange",type="aesia.com.ponents.events.ComponentEvent")]	[Event(name="propertyChange",type="aesia.com.ponents.events.PropertyEvent")]
	public class AbstractSpinnerModel extends EventDispatcher implements SpinnerModel
	{
		protected var _modelMenuContext : Vector.<ContextMenuItem>;
		
		public function AbstractSpinnerModel ()
		{
			super();
			_modelMenuContext = new Vector.<ContextMenuItem>();
		}
		
		public function hasNextValue () : Boolean { return false; }		
		public function getNextValue () : *	{ return null; }		
		
		public function hasPreviousValue () : Boolean {	return false; }
		public function getPreviousValue () : * { return null; }
		
		public function get displayValue () : String { return null; }
		public function get value () : * { return null;	}		
		public function set value (v : *) : void
		{
		}

		protected function fireDataChange () : void
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
		protected function firePropertyChange ( pname : String, pvalue : * ) : void
		{
			dispatchEvent( new PropertyEvent( PropertyEvent.PROPERTY_CHANGE, pname, pvalue ) );
		}
		override public function dispatchEvent( evt : Event) : Boolean 
		{
		 	if (hasEventListener(evt.type) || evt.bubbles) 
		  		return super.dispatchEvent(evt);
		 	return true;
		}
		
		public function get modelMenuContext () : Vector.<ContextMenuItem> {
			return _modelMenuContext;
		}
		
		public function reset () : void
		{
		}
	}
}
