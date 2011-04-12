package abe.com.mon.closures.core
{
	/**
	 * @author cedric
	 */
	public function equalTo ( v : * ) : Function 
	{
		return function ( o : *, ... args ) : Boolean { return o == v; };
	}
}
