/**
 * @license
 */
package  abe.com.mon.iterators
{
	import abe.com.mon.core.Iterator;
	import abe.com.mon.core.ListIterator;

	public class StringIterator implements ListIterator, Iterator
	{
		private var _sString : String;
		private var _nSize : Number;
		private var _nIndex : Number;
		private var _nI : Number;
		private var _sSafeString : String;
		private var _bRemoved : Boolean;
		private var _bAdded : Boolean;
		private var _nGap : Number;
		
		public function StringIterator ( s : String, gap : Number = 1, i : uint = 0 ) 
		{
			if( s == null )
	    		throw new Error( "The target string of " + this + "can't be null" );
	    	if( i > s.length )
	    		throw new Error ( "The passed-in index " + i + " is not a valid for a string of length " + s.length );
			if( gap < 1 || gap > s.length || s.length % gap != 0 )
				throw new Error ( "The passed-in gap " + gap + " is not a valid for a string of length " + s.length );
			
			_nI = i;
			_sSafeString = s;
			_nGap = gap;
			
			reset();
		}
		public function reset () : void
		{
			_sString = _sSafeString;
			_nSize = _sString.length / _nGap;
			_nIndex = _nI - 1;
			_bRemoved = false;
			_bAdded = false;
			
		}

		public function hasNext () : Boolean
	    {	
	        return ( _nIndex + 1 < _nSize );
	    }

	    public function next () : *
	    {
	    	if( !hasNext() )
				throw new Error ( this + " has no more elements at " + ( _nIndex + 1 ) );
				
			_bAdded = false;
	    	_bRemoved = false;
			return _sString.substr( ++_nIndex * _nGap, _nGap );
		}
		
		public function remove () : void
		{
			if( !_bRemoved )
			{
				_sString.slice( _nIndex--, 1 );
				_nSize--;
				_bRemoved = true;
			}
			else
			{
				throw new Error ( this + ".remove() have been already called for this iteration" );
			}
		}

		public function add (o : Object) : void
		{
			if( !_bAdded )
			{
				if( ( o as String ).length != 1 )
				{
					throw new Error ( "The passed-in character couldn't be added in " +
														 this + ".add(), expected length 1, get " + (o as String).length );
				}
				_sString = _sString.substr( 0, _nIndex + 1 ) + o + _sString.substring( _nIndex + 1 );
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
				
			_bAdded = false;
	    	_bRemoved = false;
			return _sString.substr( _nIndex-- * _nGap, _nGap );
		}

		public function previousIndex () : uint
		{
			return _nIndex;
		}

		public function set (o : Object) : void
		{
			if( !_bRemoved && !_bAdded )
			{
				if( ( o as String ).length != 1 )
				{
					throw new Error ( "The passed-in character couldn't be added in " +
														 this + ".add(), expected length 1, get " + (o as String).length );
				}
				_sString = _sString.substr( 0, _nIndex ) + o + _sString.substr( _nIndex + 1 );
			}
			else
			{
				throw new Error ( this + ".add() or " + this + ".remove() have been " +
												  "already called for this iteration, the set() operation cannot be done" );
			}
		}
	}
}
