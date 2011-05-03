package abe.com.motion.easing 
{
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.randoms.Random;
	import abe.com.mon.utils.RandomUtils;
	/**
	 * @author cedric
	 */
	public class Easing 
	{
		static public function inv( f : Function ) : Function
		{
			return function(t:Number, b:Number, c:Number, d:Number):Number
			{
				return f( 1-t, b, c, d );
			};
		}
		static public function randomize ( f : Function, amplitude : Number = 0, randomSource : Random = null, restrict : Boolean = false ) : Function 
		{
			if( !randomSource )
				randomSource = RandomUtils.RANDOM;
			return function(t:Number, b:Number, c:Number, d:Number):Number
			{
				return f( restrict ? 
							 MathUtils.restrict( t + randomSource.balance( amplitude ), 0, d ) :
							 t + randomSource.balance( amplitude ),
						  b, c, d );
			};
		}
	}
}
