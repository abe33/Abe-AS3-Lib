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
			for( var i : uint = 0; i < l; i++ )
			{
				var c : * = fn[i];
				if( c is Function )
				{
					if( (c as Function).apply( null, [o].concat(args) ) )
						return true;
				}		
				else
				{
					if( c == o )
						return true;
				}
			}
			return false;
		};
	}
}
