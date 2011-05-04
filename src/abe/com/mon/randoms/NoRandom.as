package abe.com.mon.randoms 
{
	/**
	 * @author cedric
	 */
	public class NoRandom implements RandomGenerator 
	{
		public function random () : Number { return 0; }
		public function get isSeeded () : Boolean { return false; }
	}
}
