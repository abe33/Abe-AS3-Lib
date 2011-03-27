package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function lowerThanOrEqualTo ( v : Number ) : Function 
	{
		return function( o : *, ... args ) : Boolean { return o <= v; };
	}
}
