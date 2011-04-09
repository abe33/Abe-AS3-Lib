package abe.com.mon.closures.numbers
{
	/**
	 * @author cedric
	 */
	public function greaterThan ( v : Number ) : Function 
	{
		return function( o : *, ... args ) : Boolean { return o > v; };
	}
}
