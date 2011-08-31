/**
 * @license
 */
package abe.com.ponents.tools 
{
    import org.osflash.signals.Signal;

	/**
	 * 
	 */
	public class ObjectSelection
	{
		protected var _numObjects : Number;
        
		public var objects : Array;
        
        public var selectionChanged : Signal;
		
		public function ObjectSelection ()
		{
            selectionChanged = new Signal();
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
		
		public function fireSelectionChangeEvent () : void
		{
			selectionChanged.dispatch( this );
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
