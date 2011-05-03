package abe.com.mon.randoms 
{
	import abe.com.mon.randoms.RandomGenerator;
	/**
	 * @author cedric
	 */
	public class NoRandom implements RandomGenerator 
	{
		private var value : Number;		private var increment : Number;
		public function NoRandom ( increment : Number = 0.001 ) 
		{
			this.increment = increment;
			this.value = 0;
		}
		public function random () : Number
		{
			value += increment;
			return value % 1;
		}
		public function get isSeeded () : Boolean { return false; }
	}
}
