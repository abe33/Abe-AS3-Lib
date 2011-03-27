package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function strictlyEqualTo ( v : * ) : Function 
	{
		return function ( o : *, ... args ) : Boolean { return o === v; };
	}
}
