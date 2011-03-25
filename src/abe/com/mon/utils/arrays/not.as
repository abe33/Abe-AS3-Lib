package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function not ( v : * ) : Function 
	{
		if( v is Function )
			return function( o : *, ... args ) : Boolean { return !v( o ); };
		else
			return function( o : *, ... args ) : Boolean { return o != v; };
	}
}
