package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function notNullValue () : Function 
	{
		return function( o : *, ... args ) : Boolean { return o != null; };
	}
}
