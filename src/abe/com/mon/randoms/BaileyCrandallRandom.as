package abe.com.mon.randoms 
{
    import abe.com.mon.utils.MathUtils;
	/**
	 * @author cedric
	 */
	public class BaileyCrandallRandom implements RandomGenerator, SeededRandomGenerator 
	{
		static public const POW3_33 : Number = Math.pow( 3, 33 );		static public const POW3_33_DIV_2 : Number = POW3_33 / 2;		static public const POW2_53 : Number = Math.pow( 2, 53 );
		private var d1 : Number;
		private var dd1 : Array = new Array( 2 );		private var dd2 : Array = new Array( 2 );		private var dd3 : Array = new Array( 2 );

		public function BaileyCrandallRandom ( seed : uint = 0 ) 
		{
			plantSeed( seed );
		}
		public function random () : Number
		{
			var n : Number = d1 / POW3_33;
			//Log.debug( d1 + " / POW3_33 = " + n );
			nextIterate();
			return n;
		}
		public function plantSeed (seed : uint) : void
		{
			var n : Number = MathUtils.map( seed, 0, uint.MAX_VALUE, POW3_33+100, POW2_53-1 );
			//Log.debug( seed + " gives " + n );
			ddmuldd( expm2( n - POW3_33, POW3_33 ), POW3_33_DIV_2, dd1 );
			//Log.debug( "dd1 = " + dd1 );			dddivd( dd1, POW3_33, dd2 );
			//Log.debug( "dd2 = " + dd2 );			ddmuldd( Math.floor( dd2[0] ), POW3_33, dd2 );			//Log.debug( "dd2 = " + dd2 );
			//ddsub( dd1, dd2, dd3 );
			//Log.debug( "dd3 = " +  dd3 );			d1 = dd3[0];
			//Log.debug( "d1 = " +  d1 );
		}
		public function nextIterate () : void 
		{
			dd1[0] = POW2_53 * d1;
			dd1[1] = 0.0;
			dddivd( dd1, POW3_33, dd2 );
			ddmuldd( POW3_33, Math.floor( dd2[0] ), dd2 );
			ddsub( dd1, dd2, dd3 );
			d1 = dd3[0];
			if (d1 < 0.0) 
			{
				d1 += POW3_33;
			}
		}
		private function expm2 ( p : Number, am : Number ) : Number
		{
			var ptl : Number = 1;
			while (ptl < p) 
			{
				ptl *= 2;
			}
			ptl /= 2;

			var p1 : Number = p;
			var r : Number = 1.0;
			var ddm : Array = [ am, 0.0 ];
			while (true) 
			{
				if (p1 >= ptl) 
				{
					// r = (2*r) mod am
					ddmuldd( 2.0, r, dd1 );
					if (dd1[0] > am) 
					{
						// dd1 -= ddm
						ddsub( dd1, ddm, dd2 );
						dd1[0] = dd2[0];
						dd1[1] = dd2[1];
					}
					r = dd1[0];
					p1 -= ptl;
				}
				ptl *= 0.5;
				if (ptl >= 1.0) 
				{
					/*
					 * r*r mod am == r*r - floor(r*r / am) * am
					 */
					ddmuldd( r, r, dd1 );
					dddivd( dd1, am, dd2 );
					ddmuldd( am, Math.floor( dd2[0] ), dd2 );
					ddsub( dd1, dd2, dd3 );
					r = dd3[0];
					if (r < 0.0)
                    r += am;
				} 
				else 
				{
					return r;
				}
			}
			return r;
		}

		/**
		 * Used to split doubles into hi and lo words
		 */
		private static const SPLIT : Number = 134217729.0;

		/**
		 * Double precision multiplication
		 *
		 * @param a
		 *            in: double
		 * @param b
		 *            in: double
		 * @param c
		 *            out: double double
		 */
		static private function ddmuldd ( a : Number, b : Number, c : Array ) : void
		{
			var cona : Number = a * SPLIT;
			var conb : Number = b * SPLIT;
			var a1 : Number = cona - (cona - a);
			var b1 : Number = conb - (conb - b);
			var a2 : Number = a - a1;
			var b2 : Number = b - b1;
			var s1 : Number = a * b;
			c[0] = s1;
			c[1] = (((a1 * b1 - s1) + a1 * b2) + a2 * b1) + a2 * b2;
		}
		/**
		 * Double Precision division
		 *
		 * Double-double / double = double double
		 *
		 * @param a
		 *            In: double double
		 * @param b
		 *            In: double
		 * @param c
		 *            Out: double double
		 */
		static private function dddivd ( a : Array, b : Number, c : Array) : void
		{
			var t1 : Number = a[0] / b;
			var cona : Number = t1 * SPLIT;
			var conb : Number = b * SPLIT;
			var a1 : Number = cona - (cona - t1);
			var b1 : Number = conb - (conb - b);
			var a2 : Number = t1 - a1;
			var b2 : Number = b - b1;
			var t12 : Number = t1 * b;
			var t22 : Number = (((a1 * b1 - t12) + a1 * b2) + a2 * b1) + a2 * b2;
			var t11 : Number = a[0] - t12;
			var e : Number = t11 - a[0];
			var t21 : Number = ((-t12 - e) + (a[0] - (t11 - e))) + a[1] - t22;
			var t2 : Number = (t11 + t21) / b;
			var s1 : Number = t1 + t2;
			c[0] = s1;
			c[1] = t2 - (s1 - t1);
		}
		/**
		 * Double-Precision subtraction a-b = c
		 *
		 * @param a
		 *            in: double-double
		 * @param b
		 *            in: double-double
		 * @param c
		 *            out: double-double result
		 */
		static private function ddsub ( a : Array, b : Array, c : Array ) : void
		{
			//Log.debug( "a = " + a +", b = " + b + ", c = " + c );
			
			var t1 : Number = a[0] - b[0];
			//Log.debug( "t1 = " +  t1 );
			var e : Number = t1 - a[0];
			//Log.debug( "e = " +  e );
			var t2 : Number = ((-b[0] - e) + (a[0] - (t1 - e))) + a[1] - b[1];
			//Log.debug( "t2 = " +  t2 );
			var s1 : Number = t1 + t2;
			//Log.debug( "s1 = " +  s1 );
			c[0] = s1;
			c[1] = t2 - (s1 - t1);
		}
	}
}
