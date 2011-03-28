package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function nan () : Function 
	{
		return function( o : *, ... args ) : Boolean { return isNaN( o ); };
	}
}
