package abe.com.mon.closures.strings
{
	/**
	 * @author cedric
	 */
	public function re ( r : RegExp ) : Function 
	{ 
		return function( o : *, ... args ) : Boolean { return r.test( String( o ) ); };
	}
}
