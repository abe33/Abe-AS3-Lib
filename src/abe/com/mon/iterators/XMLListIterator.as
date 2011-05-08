/**
 * @license
 */
package  abe.com.mon.iterators 
{
	import abe.com.mon.core.Iterator;
	import abe.com.mon.core.ListIterator;
	public class XMLListIterator implements Iterator, ListIterator
	{
		private var list : XMLList;
		private var length : Number;
		private var index : Number;

		public function XMLListIterator ( list : XMLList )
		{
			this.list = list;
			reset();
		}
		public function reset () : void
		{
			this.length = list.length();
			index = -1;
		}
		public function hasNext () : Boolean
		{
			return index + 1 < length;
		}
		public function next () : *
		{
			if( !hasNext() )
				throw new Error ( this + " has no more elements at " + ( index + 1 ) );
			
			return list[ ++index ];
		}
		public function nextIndex () : uint
		{
			return index + 1;
		}
		
		public function hasPrevious () : Boolean
		{
			return index >= 0;
		}		
		public function previous () : *
		{
			if( !hasPrevious() )
				throw new Error ( this + " has no more elements at " + ( index ) );
			
			return list[ index-- ];
		}

		public function previousIndex () : uint
		{
			return index;
		}

		public function set ( o : * ) : void
		{
			throw new Error( "set is not currently supported by the XMLListIterator" );
		}
		public function remove () : void
		{
			throw new Error( "remove is not currently supported by the XMLListIterator" );
		}
		public function add ( o : Object ) : void
		{
			throw new Error( "add is not currently supported by the XMLListIterator" );
		}
	}
}
