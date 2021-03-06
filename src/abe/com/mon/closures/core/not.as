package abe.com.mon.closures.core
{
	/**
	 * @author cedric
	 */
	public function not ( v : * ) : Function 
	{
		if( v is Function )
			return function( o : *, ... args ) : Boolean { return !(v as Function).apply( null, [o].concat(args) ); };
		else
			return function( o : *, ... args ) : Boolean { return o != v; };
	}
}
