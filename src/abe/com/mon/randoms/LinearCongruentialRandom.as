package abe.com.mon.randoms 
{
	/**
	 * @author cedric
	 */
	public class LinearCongruentialRandom implements RandomGenerator 
	{
		protected var _seed : uint;
		protected var _currentSeed : uint;

		public function LinearCongruentialRandom ( seed : uint = 1 ) 
		{
			_seed = seed;
			_currentSeed = seed;
		}
		public function random () : Number
		{
			var tmpseed : uint = _currentSeed;
			var q : uint = tmpseed; /* low */
			q = q >> 1;
			var p : uint = tmpseed >> 31 ; /* hi */
			var mlcg : uint = p + q;
			if (mlcg & 0x80000000) 
			{
				mlcg = mlcg & 0x7FFFFFFF;
				mlcg++;
			}
			_currentSeed = mlcg;
			 
			return mlcg / uint.MAX_VALUE; 
		}
		public function get isSeeded () : Boolean { return true; }
	}
}
