package abe.com.patibility.humanize
{
	/**
	 * @author cedric
	 */
	public function intcomma ( v : int ) : String 
	{
		var s1 : String = String( v );
		var s2 : String = "";
		var l : uint = s1.length;
		var n : uint = 0;
		while( l-- )
		{
			n++;
			if( n == 3 )
			{
				s2 = s1.substr(-3) + "," + s2;
				s1 = s1.substr(0,-3);
				n = 0;
			}
		}
		return s2;
	}
}
