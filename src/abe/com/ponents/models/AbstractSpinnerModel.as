package abe.com.ponents.models 
{
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.PropertyEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenuItem;

	/**
	 * @author Cédric Néhémie
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]	[Event(name="propertyChange",type="abe.com.ponents.events.PropertyEvent")]
	public class AbstractSpinnerModel extends EventDispatcher implements SpinnerModel
	{
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _modelMenuContext : Array;
		
		TARGET::FLASH_10
		protected var _modelMenuContext : Vector.<ContextMenuItem>;
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _modelMenuContext : Vector.<ContextMenuItem>;
		
		public function AbstractSpinnerModel ()
		{
			super();
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _modelMenuContext = []; }
			TARGET::FLASH_10 { _modelMenuContext = new Vector.<ContextMenuItem>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_modelMenuContext = new Vector.<ContextMenuItem>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
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
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function get modelMenuContext () : Array { return _modelMenuContext; }
		
		TARGET::FLASH_10
		public function get modelMenuContext () : Vector.<ContextMenuItem> { return _modelMenuContext; }
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function get modelMenuContext () : Vector.<ContextMenuItem> { return _modelMenuContext; }
		
		public function reset () : void
		{
		}
	}
}
