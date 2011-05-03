package abe.com.edia.fx.emitters 
{
	import abe.com.mon.utils.Delegate;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.randoms.Random;
	import abe.com.mon.utils.RandomUtils;
	/**
	 * @author cedric
	 */
	public class Distributions 
	{
		static public function constant ( n : Number ) : Number
		{
			return n;
		}
		static public function firstHalf ( n : Number ) : Number
		{
			return n/2;
		}
		static public function secondHalf ( n : Number ) : Number
		{
			return 0.5 + n/2;
		}
		static public function pow2 ( n : Number ) : Number 
		{
			return n * n;
		}
		static public function pow3 ( n : Number ) : Number 
		{
			return n * n * n;
		}
		static public function pow4 ( n : Number ) : Number 
		{
			return n * n * n * n;
		}
		
		static public function dashed ( dash : Number ) : Function
		{
			return Delegate.create( dashedDistribution, dash );
		}
		
		static protected function dashedDistribution ( n : Number, dash : Number ) : Number 
		{
			var a : Number = n * dash;
			var rest : Number = a - Math.floor(a);
			a = Math.floor(a) + rest/2;
			return a/dash;
		}
		
		static public function inv ( f : Function) : Function 
		{
			return function( n : Number ) : Number
			{
				return f(1-n);
			};
		}
		static public function randomize ( f : Function, amplitude : Number = 0, randomSource : Random = null, restrict : Boolean = false ) : Function 
		{
			if( !randomSource )
				randomSource = RandomUtils.RANDOM;
			return function(n:Number):Number
			{
				return f( restrict ? 
							 MathUtils.restrict( n + randomSource.balance( amplitude ), 0, 1 ) :
							 n + randomSource.balance( amplitude ) );
			};
		}
		public static function cut (f : Function, cutLength : Number = .5 ) : Function 
		{
			return function( n : Number):Number
			{
				return MathUtils.restrict( n, cutLength, 1 );
			};
		}
	}
}
