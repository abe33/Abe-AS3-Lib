/**
 * @license
 */
package  aesia.com.mon.iterators 
{
	import aesia.com.mon.core.Iterator;
	import aesia.com.mon.core.ListIterator;

	public class ArrayIterator implements Iterator, ListIterator
	{
	    private var _aArray : Array;
	    private var _nSize : Number;
	    private var _nIndex : Number;
	    private var _nI : Number;
	    private var _bRemoved : Boolean;
	    private var _bAdded : Boolean;
	    private var _nEnd : int;

		public function ArrayIterator ( a : Array, i : uint = 0, end : int = -1 )
	    {
	    	if( a == null )
	    		throw new Error( "The target array of " + this + "can't be null" );
	    	if( i > a.length )
	    		throw new Error ( "The passed-in index " + i + " is not a valid for an array of length " + a.length );
		
			_aArray = a;
			_bRemoved = false;
			_bAdded = false;
			_nI = i;
			_nEnd = -1;
			reset();
		}
		public function reset () : void
		{
			_nSize = _aArray.length;
	        _nIndex = _nI - 1;
		}
	    public function hasNext () : Boolean
	    {
	        return ( _nIndex + 1 < ( _nEnd != -1 ? _nEnd : _nSize ) );
	    }

	    public function next () : *
	    {
	    	if( !hasNext() )
				throw new Error ( this + " has no more elements at " + ( _nIndex + 1 ) );
			
	    	_bRemoved = false;
			_bAdded = false;
			return _aArray[ ++_nIndex ];
	    }

		public function remove () : void
		{
			if( _bRemoved )
			{
				_aArray.splice( _nIndex--, 1 );
				_nSize--;
				_bRemoved = true;
			}
			else
			{
				throw new Error ( this + ".remove() have been already called for this iteration" );
			}
		}

		public function add ( o : Object ) : void
		{
			if( !_bAdded )
			{
				_aArray.splice( _nIndex + 1, 0, o );
				_nSize++;
				_bAdded = true;
			}
			else
			{
				throw new Error ( this + ".add() have been already called for this iteration" );
			}
		}

		public function hasPrevious () : Boolean
		{
			return _nIndex >= 0;
		}

		public function nextIndex () : uint
		{
			return _nIndex + 1;
		}

		public function previous () : *
		{
			if( !hasPrevious() )
				throw new Error ( this + " has no more elements at " + ( _nIndex ) );
			
	    	_bRemoved = false;
			_bAdded = false;
			
			return _aArray[ _nIndex-- ];
		}

		public function previousIndex () : uint
		{
			return _nIndex;
		}

		public function set ( o : Object ) : void
		{
			if( !_bRemoved && !_bAdded )
			{
				_aArray[ _nIndex ] = o;
			}
			else
			{
				throw new Error ( this + ".add() or " + this + ".remove() have been " +
												  "already called for this iteration, the set() operation cannot be done" );
			}
		}
	}
}
