package abe.com.mon.utils.objects
{
	/**
	 * @author cedric
	 */
	public function keys ( o : Object ) : Array 
	{
		var a : Array = [];
		
		for( var i : String in o )
			a.push(i);
		
		return a;
	}
}
