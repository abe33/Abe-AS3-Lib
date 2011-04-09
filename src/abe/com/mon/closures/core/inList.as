package abe.com.mon.closures.core
{
	/**
	 * @author cedric
	 */
	public function inList ( ... list ) : Function 
	{
		return function( o : *, ... args ) : Boolean 
		{
			return list.indexOf( o ) != -1;
		};
	}
}
