package abe.com.mon.closures.strings
{
	/**
	 * @author cedric
	 */
	public function endWith ( s : String ) : Function 
	{
		return function ( o : *, ... args ) : Boolean { return String(o).substr(-s.length) == s; };
	}
}
