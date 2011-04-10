package abe.com.mon.closures.numbers
{
	/**
	 * @author cedric
	 */
	public function between ( a : Number, b : Number, exclusive : Boolean = true ) : Function 
	{
		if( a > b )
			throw new Error ("a couldn't be lower than b"); 
		return function( o : *, ... args ) : Boolean 
		{ 
			return exclusive ? 
						o > a && o < b :						o >= a && o <= b; 
		};
	}
}
