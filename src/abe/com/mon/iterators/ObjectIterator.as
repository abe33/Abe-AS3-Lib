/**
 * @license
 */
package  abe.com.mon.iterators
{
	import abe.com.mon.core.Iterator;
	public class ObjectIterator implements Iterator
	{
	    protected var _oObject : Object;
	    protected var _aKeys : Array;
		protected var _nSize : Number;
		protected var _nIndex : Number;
	    protected var _bRemoved : Boolean;
		
		public function ObjectIterator ( o : Object )
		{
			_oObject = o;
			_aKeys = new Array();
			
			for( var k : String in _oObject ) { _aKeys.push( k ); }
			
			_bRemoved = false;
			
			reset();
		}
		public function reset () : void
		{
			_nIndex = -1;
			_nSize = _aKeys.length;
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
			return _oObject[ _aKeys[ ++_nIndex ] ];
		}
	
		public function remove () : void
		{
			if( !_bRemoved )
			{
				if( delete _oObject[ _aKeys[ _nIndex ] ] )
				{
					_nIndex--;
					_bRemoved = true;
				}
				else
				{
					throw new Error( this + ".remove() can't delete " + _oObject + "." + _aKeys[ _nIndex ] );
				}
			}
			else
			{
				throw new Error ( this + ".remove() have been already called for this iteration" );
			}
		}
	}
}
