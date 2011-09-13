package abe.com.mon.randoms 
{
    import abe.com.mon.core.Randomizable;
	/**
	 * @author cedric
	 */
	public class MathRandom implements RandomGenerator 
	{
		static public function init( o : Randomizable ) : Randomizable
		{
			o.randomSource = new Random();
			return o;
		}
		public function random () : Number { return Math.random(); }
		public function get isSeeded () : Boolean { return false; }
	}
}
