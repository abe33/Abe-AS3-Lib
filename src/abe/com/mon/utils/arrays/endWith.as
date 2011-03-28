package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function endWith ( s : String ) : Function 
	{
		return function ( o : *, ... args ) : Boolean { return String(o).indexOf(s) == String(o).length - s.length; };
	}
}
