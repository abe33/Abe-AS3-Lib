package abe.com.patibility.humanize
{
	/**
	 * @author cedric
	 */
	public function plural ( value : Number, singular : String, plural : String ) : String 
	{
		return value > 1 ? plural : singular;
	}
}
