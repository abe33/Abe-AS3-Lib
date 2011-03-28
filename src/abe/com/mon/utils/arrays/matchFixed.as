package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function matchFixed ( ... struct ) : Function 
	{
		return function( o : *, i : int, a : Array ) : Boolean 
		{
			if( i == 0 && a.length != struct.length )
				return false;
			
			var v : * = struct[i];
			
			if( v is Function )
				return v( o, i, a );
			else
				return o == v;
		};
	}
}
