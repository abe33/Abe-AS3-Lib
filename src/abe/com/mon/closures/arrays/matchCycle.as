package abe.com.mon.closures.arrays
{
	/**
	 * @author cedric
	 */
	public function matchCycle ( ... struct ) : Function 
	{
		return function( o : *, i : int, a : Array ) : Boolean
		{
			if( i == 0 && a.length % struct.length != 0 )
				return false;
			
			var i2 : int = i % struct.length;
			var v : * = struct[i2];
			
			if( v is Function )
				return v( o, i, a );
			else
				return o == v;
		};
	}
}
