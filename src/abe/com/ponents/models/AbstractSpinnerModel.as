package abe.com.ponents.models 
{
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.PropertyEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenuItem;
    import org.osflash.signals.Signal;
	 
	/**
	 * @author Cédric Néhémie
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
	[Event(name="propertyChange",type="abe.com.ponents.events.PropertyEvent")]
	public class AbstractSpinnerModel extends EventDispatcher implements SpinnerModel
	{
		
		TARGET::FLASH_9
		protected var _modelMenuContext : Array;
		
		TARGET::FLASH_10
		protected var _modelMenuContext : Vector.<ContextMenuItem>;
		
		TARGET::FLASH_10_1 
		protected var _modelMenuContext : Vector.<ContextMenuItem>;
		
		protected var _dataChanged : Signal;
		protected var _propertyChanged : Signal;
		    
		public function AbstractSpinnerModel ()
		{
			super();
			_dataChanged = new Signal();
			_propertyChanged = new Signal();
        
			TARGET::FLASH_9 { _modelMenuContext = []; }
			TARGET::FLASH_10 { _modelMenuContext = new Vector.<ContextMenuItem>(); }
			TARGET::FLASH_10_1 { _modelMenuContext = new Vector.<ContextMenuItem>(); } 
		}
		public function get dataChanged () : Signal { return _dataChanged; } 
		public function get propertyChanged () : Signal { return _propertyChanged; } 
		
		public function hasNextValue () : Boolean { return false; }		
		public function getNextValue () : *	{ return null; }		
		
		public function hasPreviousValue () : Boolean {	return false; }
		public function getPreviousValue () : * { return null; }
		
		public function get displayValue () : String { return null; }
		public function get value () : * { return null;	}
		public function set value (v : *) : void {}

		protected function fireDataChangedSignal () : void
		{
			_dataChanged.dispatch( this, value );
		}
		protected function firePropertyChangedSignal ( pname : String, pvalue : * ) : void
		{
			_propertyChanged.dispatch( pname, pvalue );
		}
		
		TARGET::FLASH_9
		public function get modelMenuContext () : Array { return _modelMenuContext; }
		
		TARGET::FLASH_10
		public function get modelMenuContext () : Vector.<ContextMenuItem> { return _modelMenuContext; }
		
		TARGET::FLASH_10_1 
		public function get modelMenuContext () : Vector.<ContextMenuItem> { return _modelMenuContext; }
		
		public function reset () : void {}
	}
}
