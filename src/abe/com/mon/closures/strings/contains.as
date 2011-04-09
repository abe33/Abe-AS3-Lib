package abe.com.mon.closures.strings
{
	/**
	 * @author cedric
	 */
	public function contains ( s : String ) : Function 
	{
		return function ( o : *, ... args ) : Boolean { return String(o).indexOf(s) != -1; };
	}
}
