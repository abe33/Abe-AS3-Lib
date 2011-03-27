package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function anyOf ( ... fn ) : Function 
	{
		return function( o : *, ... args ) : Boolean 
		{
			var l : uint = fn.length;
			var b : Boolean = false;
			for( var i : uint = 0; i < l; i++ )
			{
				var c : * = fn[i];
				if( c is Function )
					b ||= (c as Function).apply( null, [o].concat(args) );
				else
					b ||= c == o;
			}
			return b;
		};
	}
}
