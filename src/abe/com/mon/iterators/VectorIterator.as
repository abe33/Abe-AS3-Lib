package abe.com.mon.iterators 
{
	import abe.com.mon.core.Iterator;

	/**
	 * @author Cédric Néhémie
	 */
	public class VectorIterator implements Iterator 
	{
		private var _aVector : Vector.<*>;
	    private var _nSize : Number;
	    private var _nIndex : Number;
	    private var _nI : Number;
	    private var _bRemoved : Boolean;
	    private var _bAdded : Boolean;

		public function VectorIterator ( a : Vector.<*>, i : uint = 0 )
	    {
	    	if( a == null )
	    		throw new Error( "The target Vector of " + this + "can't be null" );
	    	if( i > a.length )
	    		throw new Error ( "The passed-in index " + i + " is not a valid for an Vector of length " + a.length );
		
			_aVector = a;
			_bRemoved = false;
			_bAdded = false;
			_nI = i;
			reset();
		}
		public function reset () : void
		{
			_nSize = _aVector.length;
	        _nIndex = _nI - 1;
		}
	    public function hasNext () : Boolean
	    {
	        return ( _nIndex + 1 < _nSize );
	    }

	    public function next () : *
	    {
	    	if( !hasNext() )
				throw new Error ( this + " has no more elements at " + ( _nIndex + 1 ) );
			
	    	_bRemoved = false;
			_bAdded = false;
			return _aVector[ ++_nIndex ];
	    }

		public function remove () : void
		{
			if( _bRemoved )
			{
				_aVector.splice( _nIndex--, 1 );
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
				_aVector.splice( _nIndex + 1, 0, o );
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
			
			return _aVector[ _nIndex-- ];
		}

		public function previousIndex () : uint
		{
			return _nIndex;
		}

		public function set ( o : * ) : void
		{
			if( !_bRemoved && !_bAdded )
			{
				_aVector[ _nIndex ] = o;
			}
			else
			{
				throw new Error ( this + ".add() or " + this + ".remove() have been " +
												  "already called for this iteration, the set() operation cannot be done" );
			}
		}
	}
}
