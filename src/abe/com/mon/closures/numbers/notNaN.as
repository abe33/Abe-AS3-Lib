package abe.com.mon.closures.numbers
{
	/**
	 * @author cedric
	 */
	public function notNaN () : Function 
	{
		return function( o : *, ... args ) : Boolean { return !isNaN( o ); };
	}
}
