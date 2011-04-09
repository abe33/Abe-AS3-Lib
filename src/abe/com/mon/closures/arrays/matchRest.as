package abe.com.mon.closures.arrays
{
	/**
	 * @author cedric
	 */
	public function matchRest ( ... struct ) : Function 
	{
		return function ( o : *, i : int, a : Array ) : Boolean 
		{
			// the last struct argument is the rest and is optionnal
			if( i == 0 && a.length < struct.length - 1 )
				return false;
			
			// lock the struct cursor to the rest arg when reached
			var i2 : int = Math.min(i, struct.length - 1);
			var v : * = struct[i2];
			
			if( v is Function )
				return v( o, i, a );
			else
				return o == v;
		};
	}
}
