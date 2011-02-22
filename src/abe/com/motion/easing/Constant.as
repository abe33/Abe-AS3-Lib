package abe.com.motion.easing 
{
	import abe.com.mon.utils.MathUtils;
	/**
	 * @author cedric
	 */
	public class Constant 
	{
		static public function easeOne (t:Number, b:Number, c:Number, d:Number):Number
		{
			return c + b;
		}
		static public function easeZero (t:Number, b:Number, c:Number, d:Number):Number
		{
			return b;
		}
		static public function easeAbsSin (t:Number, b:Number, c:Number, d:Number):Number
		{
			return Math.abs( Math.sin(t/d*MathUtils.PI2) * ( c + b ) );
		}
		static public function easeAbsCos (t:Number, b:Number, c:Number, d:Number):Number
		{
			return Math.abs( Math.cos(t/d*MathUtils.PI2) * ( c + b ) );
		}
	}
}
