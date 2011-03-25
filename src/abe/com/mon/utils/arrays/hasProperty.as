package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function hasProperty ( p : String, v : * = null ) : Function 
	{
		if( v )
		{
			if( v is Function )
				return function ( o : *, ... args ) : Boolean { return (o as Object).hasOwnProperty( p ) && v( o[p] ); };			else
				return function ( o : *, ... args ) : Boolean { return (o as Object).hasOwnProperty( p ) && o[p] == v; };
		}
		else
			return function ( o : *, ... args ) : Boolean { return (o as Object).hasOwnProperty( p ); };
	}
}
