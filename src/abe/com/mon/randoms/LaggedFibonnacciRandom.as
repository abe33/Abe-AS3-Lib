package abe.com.mon.randoms 
{
	/**
	 * @author cedric
	 */
	public class LaggedFibonnacciRandom implements RandomGenerator, SeededRandomGenerator 
	{
		private var c : Number;
		private var cd : Number;
		private var cm : Number;
		private var u : Array;
		private var i97 : int;
		private var j97 : int;

		public function LaggedFibonnacciRandom ( seed : uint = 0 ) 
		{
			plantSeed( seed );
		}
		public function random () : Number
		{
			var uni : Number;

			uni = u[i97] - u[j97];
			if (uni < 0.0) uni += 1.0;
			u[i97] = uni;
			if (--i97 < 0) i97 = 96;
			if (--j97 < 0) j97 = 96;
			c -= cd;
			if (c < 0.0) c += cm;
			uni -= c;
			if (uni < 0.0) uni += 1.0;
			return(uni);
		}
		public function plantSeed ( seed : uint ) : void
		{
			
			var ij : int;
			var kl : int;
			var i : int;
			var ii : int;
			var j : int;
			var jj : int;
			var k : int;
			var l : int;
			var m : int;
			var s : Number;
			var t : Number;

			u = new Array( 97 );

			ij = seed / 30082;
			kl = seed - 30082 * ij;

			i = ((ij / 177) % 177) + 2 ;
			j = (ij % 177) + 2 ;
			k = ((kl / 169) % 178) + 1 ;
			l = kl % 169 ;
			for (ii = 0; ii < 97; ii++)
			{
				s = 0.0 ;
				t = 0.5 ;
				for (jj = 0; jj < 24; jj++)
				{
					m = (((i * j) % 179) * k) % 179 ;
					i = j ;
					j = k ;
					k = m ;
					l = (53 * l + 1) % 169 ;
					if ( ((l * m) % 64) >= 32) s += t ;
					t *= 0.5 ;
				}
				u[ii] = s ;
			}
			c = 362436.0 / 16777216.0 ;
			cd = 7654321.0 / 16777216.0 ;
			cm = 16777213.0 / 16777216.0 ;
			i97 = 96 ;
			j97 = 32 ;
		}
	}
}
