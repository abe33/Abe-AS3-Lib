package abe.com.mon.utils 
{
	/**
	 * @author cedric
	 */
	public class ObjectUtils 
	{
		static public function isEmptyObject( o : Object ) : Boolean
		{
			for( var i : String in o )
				return false;
			
			return true;
		}
	}
}
