package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function strictlyEqualTo () : Function 
	{
		return function ( o : *, ... args ) : Boolean { return o === v; };;
	}
}
