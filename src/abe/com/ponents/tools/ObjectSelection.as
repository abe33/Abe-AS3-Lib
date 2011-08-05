/**
 * @license
 */
package abe.com.ponents.tools 
{
	import abe.com.ponents.events.ComponentEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * 
	 */
	public class ObjectSelection extends EventDispatcher
	{
		public var objects : Array;
		protected var _numObjects : Number;
		
		public function ObjectSelection ()
		{
			objects = [];
			_numObjects = 0;
		}
		
		public function containsMany (a : Array) : Boolean
		{
			return a.every(function(o:Object, ... args ) : Boolean { return objects.indexOf( o ) != -1; } );
		}

		public function set ( a : Array ) : void
		{
			objects = a;
			fireSelectionChangeEvent();
		}
		public function add ( o : Object ) : void
		{
			if( !contains( o ) )
				objects.push( o );
			fireSelectionChangeEvent ();
		}
		public function addMany( a : Array ):void
		{
			var l : uint = a.length;
			for( var i:uint = 0;i<l;i++ )
			{
				var o : * = a[i];
				if( !contains(o) )
					objects.push(o);
			}
			fireSelectionChangeEvent();
		}
		public function contains( o : Object ) : Boolean
		{
			return objects.indexOf(o) != -1;
		}

		public function remove ( o : Object ) : void
		{
			if( contains( o ) )
				objects.splice( objects.indexOf( o ), 1 );
			
			fireSelectionChangeEvent ();
		}
		public function removeMany ( a : Array) : void 
		{
			var l : uint = a.length;
			while ( l-- )
			{
				var o : * = a[l];
				if( contains(o) )
					objects.splice( objects.indexOf(o), 1 );
			}
			fireSelectionChangeEvent();
		}
		public function removeAll () : void
		{
			objects = [];
			fireSelectionChangeEvent ();
		}
		
		protected function fireSelectionChangeEvent () : void
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.SELECTION_CHANGE ) );
		}

		override public function dispatchEvent( evt : Event ) : Boolean 
		{
		 	if (hasEventListener(evt.type) || evt.bubbles) 
		  		return super.dispatchEvent(evt);
		 	return true;
		}
		
		public function get numObjects () : Number
		{
			return objects.length;
		}
		public function isEmpty() : Boolean
		{
			return objects.length == 0;
		}
	}
}
