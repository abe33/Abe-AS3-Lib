package abe.com.ponents.factory
{
	/**
	 * @author cedric
	 */
	public function contextKwargsArg ( key : String ) : Function 
	{
		var kk : String = key;
		return function( o : *, k : String, context : Object ) : * { return context[ kk ]; };
	}
}
