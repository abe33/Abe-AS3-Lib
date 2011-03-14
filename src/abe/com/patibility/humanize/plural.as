package abe.com.patibility.humanize
{
	/**
	 * @author cedric
	 */
	public function plural ( value : Number, singular : String, plural : String ) : String 
	{
		if( isNaN( value ) )
			return singular;
		
		return ( value > 1 || value < -1 ) ? plural : singular;
	}
}
