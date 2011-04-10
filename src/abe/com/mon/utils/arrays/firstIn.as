package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function firstIn ( ... args ) : * 
	{
		if( args.length == 0 )
			return null;
		else if( args.length == 1 && args[0] is Array )
		{
			var a : Array = args[0];
			return a[0];
		}
		else
			return args[0];
	}
}
