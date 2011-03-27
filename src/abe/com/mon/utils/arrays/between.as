package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function between ( a : Number, b : Number ) : Function 
	{
		return function( o : *, ... args ) : Boolean { return o >= a && o <= b; };
	}
}
