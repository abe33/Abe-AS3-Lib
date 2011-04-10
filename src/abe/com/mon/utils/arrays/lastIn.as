package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function lastIn ( ... args ) : * 
	{
		if( args.length == 0 )
			return null;
		else if( args.length == 1 && args[0] is Array )
		{
			var a : Array = args[0];
			return a[a.length-1];
		}
		else
			return args[args.length-1];
	}
}
