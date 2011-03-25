package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function equalTo ( v : * ) : Function 
	{
		return function ( o : *, ... args ) : Boolean { return o == v; };
	}
}
