package aesia.com.mon.utils 
{
	import aesia.com.mon.core.Randomizable;
	/**
	 * @author cedric
	 */
	public class BaseRandom implements RandomGenerator 
	{
		static public function init( o : Randomizable ) : Randomizable
		{
			o.randomSource = new Random();
			return o;
		}
		public function random () : Number
		{
			return Math.random();
		}
	}
}
