package abe.com.mon.utils.objects
{
	/**
	 * @author cedric
	 */
	public function hasOwnProperties ( o : Object, ... properties ) : Boolean 
	{
		var p : Array;
		if( properties.length == 1 && properties[0] is Array )
			p = properties[0];
		else
			p = properties;
		
		for each( var key : String in p)
			if( !o.hasOwnProperty( key ) )
				return false;
				
		return true;
	}
}
