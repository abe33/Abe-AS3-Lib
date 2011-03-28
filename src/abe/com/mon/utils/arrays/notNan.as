package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function notNan () : Function 
	{
		return function( o : *, ... args ) : Boolean { return !isNaN( o ); };
	}
}
