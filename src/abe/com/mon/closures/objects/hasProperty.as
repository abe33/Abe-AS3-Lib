package abe.com.mon.closures.objects
{
	/**
	 * @author cedric
	 */
	public function hasProperty ( p : String, v : * = null ) : Function 
	{
		if( v )
		{
			if( v is Function )
				return function ( o : *, ... args ) : Boolean { return (o as Object).hasOwnProperty( p ) && (v as Function).apply( null, [o[p]].concat(args) ); };			else
				return function ( o : *, ... args ) : Boolean { return (o as Object).hasOwnProperty( p ) && o[p] == v; };
		}
		else
			return function ( o : *, ... args ) : Boolean { return (o as Object).hasOwnProperty( p ); };
	}
}
