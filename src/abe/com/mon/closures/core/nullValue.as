package abe.com.mon.closures.core
{
	/**
	 * @author cedric
	 */
	public function nullValue () : Function 
	{
		return function (o : *, ... args) : Boolean { return o == null; };
	}
}
