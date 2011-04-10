package abe.com.mon.closures.numbers
{
	/**
	 * @author cedric
	 */
	public function closeTo ( v : Number, dist : Number = 1 ) : Function 
	{
		return function( o : *, ... args ) : Boolean { return Math.abs( v - o ) <= dist; };
	}
}
