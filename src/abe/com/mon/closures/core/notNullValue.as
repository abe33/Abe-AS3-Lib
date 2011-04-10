package abe.com.mon.closures.core
{
	/**
	 * @author cedric
	 */
	public function notNullValue () : Function 
	{
		return function( o : *, ... args ) : Boolean { return o != null; };
	}
}
