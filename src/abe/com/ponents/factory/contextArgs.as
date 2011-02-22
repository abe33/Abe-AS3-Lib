package abe.com.ponents.factory
{
	/**
	 * @author cedric
	 */
	public function contextArgs ( ... args ) : Function 
	{
		var b : Array = args;
		return function( context : Object ) : Array 
		{
			var a : Array = [];
			for each( var s : String in b )
				a.push( context[ s ] );

			return a;
		};
	}
}
