package abe.com.mon.randoms 
{
	/**
	 * @author cedric
	 */
	public class LinearCongruentialRandom implements RandomGenerator, SeededRandomGenerator
	{
		protected var _seed : uint;

		public function LinearCongruentialRandom ( seed : uint = 1 ) 
		{
			plantSeed(seed);
		}
		public function random () : Number
		{
			var tmpseed : uint = _seed;
			var q : uint = tmpseed; /* low */
			q = q << 1;
			var p : uint = tmpseed << 32 ; /* hi */
			var mlcg : uint = p + q;
			if (mlcg & 0x80000000) 
			{
				mlcg = mlcg & 0x7FFFFFFF;
				mlcg++;
			}
			_seed = mlcg;
			return mlcg / 0x80000000; 
		}
		public function plantSeed (seed : uint) : void { _seed = seed; }
	}
}
