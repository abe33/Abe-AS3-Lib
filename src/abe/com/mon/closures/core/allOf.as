package abe.com.mon.closures.core
{
	/**
	 * @author cedric
	 */
	public function allOf ( ... fn ) : Function 
	{
		return function( o : *, ... args ) : Boolean 
		{
			var l : uint = fn.length;
			for( var i : uint = 0; i < l; i++ )
			{
				var c : * = fn[i];
				if( c is Function )
				{
					if( !(c as Function).apply( null, [o].concat(args) ) )
						return false;
				}
				else
				{
					if( c != o )
						return false;
				}
			}
			return true;
		};
	}
}
