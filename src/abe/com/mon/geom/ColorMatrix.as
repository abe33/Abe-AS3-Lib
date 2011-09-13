/** * @license */package  abe.com.mon.geom{    import abe.com.mon.core.Cloneable;	/**	 * The <code>ColorMatrix</code> class provides methods to create	 * a transformation matrix for use with a <code>ColorMatrixFilter</code>.	 * 	 * <fr>	 * La classe <code>ColorMatrix</code> fournie des méthodes	 * permettant de constituer une matrice de transformation	 * utilisable avec un objet <code>ColorMatrixFilter</code>.	 * </fr>	 * 	 * @author Grant Skinner	 * @example Example of using a <code>ColorMatrix</code> 	 * with a <code>ColorMatrixFilter</code>:	 * <fr>	 * Exemple d'utilisation de la classe <code>ColorMatrix</code>	 * avec un objet <code>ColorMatrixFilter</code> :	 * </fr> 	 * <listing>var m : ColorMatrix = new ColorMatrix();	 * m.adjustContrast(45);	 * m.adjustBrightness(75);	 *	 * var filter : ColorMatrixFilter = new ColorMatrixFilter( m );</listing>	 */	dynamic public class ColorMatrix extends Array implements Cloneable	{		// constant for contrast calculations:		private static const DELTA_INDEX : Array = [			0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,			0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,			0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,			0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68,			0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,			1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,			1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25,			2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,			4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,			7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8,			10.0 ];		// identity matrix constant:		private static const IDENTITY_MATRIX : Array = [ 1,0,0,0,0,														 0,1,0,0,0,														 0,0,1,0,0,														 0,0,0,1,0,														 0,0,0,0,1 ];		private static const LENGTH : Number = IDENTITY_MATRIX.length;		/**		 * <code>ColorMatrix</code> constructor.		 * 		 * <fr>Constructeur de la classe <code>ColorMatrix</code>.</fr>		 *		 * @param	matrix	an array of a transformation matrix to		 * 					manipulate		 * 					<fr>un tableau représentant une matrice		 * 					de transformation à manipuler</fr>		 */		public function ColorMatrix (matrix : Array = null)		{			matrix = fixMatrix( matrix );			copyMatrix( ((matrix.length == LENGTH) ? matrix : IDENTITY_MATRIX) );		}		// public methods:		public function reset () : void		{			for (var i : uint = 0; i < LENGTH ; i++)			{				this[i] = IDENTITY_MATRIX[i];			}		}		public function adjustColor (brightness : Number,contrast : Number,saturation : Number,hue : Number) : void		{			adjustHue( hue );			adjustContrast( contrast );			adjustBrightness( brightness );			adjustSaturation( saturation );		}		public function adjustBrightness (val : Number) : void		{			val = cleanValue( val, 100 );			if (val == 0 || isNaN( val ))			{				return;			}			multiplyMatrix( [ 1,0,0,0,val,							  0,1,0,0,val,							  0,0,1,0,val,							  0,0,0,1,0,							  0,0,0,0,1 ] );		}		public function adjustContrast (val : Number) : void		{			val = cleanValue( val, 100 );			if (val == 0 || isNaN( val ))			{				return;			}			var x : Number;			if (val < 0)			{				x = 127 + val / 100 * 127;			} else			{				x = val % 1;				if (x == 0)				{					x = DELTA_INDEX[val];				} else				{					//x = DELTA_INDEX[(val<<0)]; // this is how the IDE does it.					x = DELTA_INDEX[(val << 0)] * (1 - x) + DELTA_INDEX[(val << 0) + 1] * x; // use linear interpolation for more granularity.				}				x = x * 127 + 127;			}			multiplyMatrix( [ x / 127,0,0,0,0.5 * (127 - x),							  0,x / 127,0,0,0.5 * (127 - x),							  0,0,x / 127,0,0.5 * (127 - x),							  0,0,0,1,0,							  0,0,0,0,1 ] );		}		public function adjustAlpha (val : Number) : void		{			multiplyMatrix( [ 1,0,0,0,0,							  0,1,0,0,0,							  0,0,1,0,0,							  0,0,0,1,val,							  0,0,0,0,1 ] );		}		public function adjustSaturation (val : Number) : void		{			val = cleanValue( val, 100 );			if (val == 0 || isNaN( val ))			{				return;			}			var x : Number = 1 + ((val > 0) ? 3 * val / 100 : val / 100);			var lumR : Number = 0.3086;			var lumG : Number = 0.6094;			var lumB : Number = 0.0820;			multiplyMatrix( [ lumR * (1 - x) + x,lumG * (1 - x),lumB * (1 - x),0,0,				lumR * (1 - x),lumG * (1 - x) + x,lumB * (1 - x),0,0,				lumR * (1 - x),lumG * (1 - x),lumB * (1 - x) + x,0,0,				0,0,0,1,0,				0,0,0,0,1 ] );		}		public function adjustHue (val : Number) : void		{			val = cleanValue( val, 180 ) / 180 * Math.PI;			if (val == 0 || isNaN( val ))			{				return;			}			var cosVal : Number = Math.cos( val );			var sinVal : Number = Math.sin( val );			var lumR : Number = 0.213;			var lumG : Number = 0.715;			var lumB : Number = 0.072;			multiplyMatrix( [ lumR + cosVal * (1 - lumR) + sinVal * (-lumR),lumG + cosVal * (-lumG) + sinVal * (-lumG),lumB + cosVal * (-lumB) + sinVal * (1 - lumB),0,0,				lumR + cosVal * (-lumR) + sinVal * (0.143),lumG + cosVal * (1 - lumG) + sinVal * (0.140),lumB + cosVal * (-lumB) + sinVal * (-0.283),0,0,				lumR + cosVal * (-lumR) + sinVal * (-(1 - lumR)),lumG + cosVal * (-lumG) + sinVal * (lumG),lumB + cosVal * (1 - lumB) + sinVal * (lumB),0,0,				0,0,0,1,0,				0,0,0,0,1 ] );		}		public function concat ( matrix : Array ) : void		{			matrix = fixMatrix( matrix );			if (matrix.length != LENGTH)			{				return;			}			multiplyMatrix( matrix );		}				/**		 * @inheritDoc		 */		public function clone () : *		{			return new ColorMatrix( this );		}		/**		 * Returns the representation of the object as a string.		 * <fr>		 * Renvoie la représentation de l'objet sous forme de chaîne.		 * </fr>		 * @return	the representation of the object as a string		 * 			<fr>la représentation de l'objet sous forme de chaîne</fr>		 */		public function toString () : String		{			return "ColorMatrix [ " + this.join( " , " ) + " ]";		}		/**		 * Returns the current instance as an <code>Array</code>.		 * 		 * @return	the current instance as an <code>Array</code>		 */		public function toArray () : Array		{			return slice( 0, 20 );		}		// private methods:		// copy the specified matrix's values to this matrix:		protected function copyMatrix (matrix : Array) : void		{			var l : Number = LENGTH;			for (var i : uint = 0; i < l ;i++)			{				this[i] = matrix[i];			}		}		// multiplies one matrix against another:		protected function multiplyMatrix (matrix : Array) : void		{			var col : Array = [];			for (var i : uint = 0; i < 5 ;i++)			{				for (var j : uint = 0; j < 5 ;j++)				{					col[j] = this[j + i * 5];				}				for (j = 0; j < 5 ;j++)				{					var val : Number = 0;					for (var k : Number = 0; k < 5 ;k++)					{						val += matrix[j + k * 5] * col[k];					}					this[j + i * 5] = val;				}			}		}		// make sure values are within the specified range, hue has a limit of 180, others are 100:		protected function cleanValue (val : Number,limit : Number) : Number		{			return Math.min( limit, Math.max( -limit, val ) );		}		// makes sure matrixes are 5x5 (25 long):		protected function fixMatrix (matrix : Array = null) : Array		{			if (matrix == null)			{				return IDENTITY_MATRIX;			}			if (matrix is ColorMatrix)			{				matrix = matrix.slice( 0 );			}			if (matrix.length < LENGTH)			{				matrix = matrix.slice( 0, matrix.length ).concat( IDENTITY_MATRIX.slice( matrix.length, LENGTH ) );			} else if (matrix.length > LENGTH)			{				matrix = matrix.slice( 0, LENGTH );			}			return matrix;		}	}}