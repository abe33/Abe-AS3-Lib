package abe.com.mon.utils.arrays
{
	/**
	 * @author cedric
	 */
	public function hasProperties ( props : Object ) : Function 
	{
		return function ( o : *, ... args ) : Boolean 
		{
			for( var i : String in props )
			{ 
				var v : * = props[ i ];
				if( v is Function )
				{
					if( !( o as Object ).hasOwnProperty(i) || !(v as Function).apply( null, [o[i]].concat(args) ) )
						return false;
				}
				else
				{
					if( !( o as Object ).hasOwnProperty(i) || o[i] != v )
						return false;
				}
			}
			return true;
		};
	}
}
