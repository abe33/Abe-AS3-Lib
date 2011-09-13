/**
 * @license
 */
package  abe.com.mon.geom
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Copyable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.StringUtils;

	import flash.utils.getQualifiedClassName;
	/**
	 * Class <code>Range</code> represents a range of values.
	 * <fr>
	 * La classe <code>Range</code> représente une plage de valeurs.
	 * </fr>
	 * @author Cédric Néhémie
	 */
    [Serialize(constructorArgs="min,max")]
	public class Range implements Cloneable, 
								  Copyable, 
								  Serializable, 
								  Equatable, 
								  FormMetaProvider
	{
		[Form(type="floatSpinner",
			  label="Minimum",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="0")]
		/**
		 * Minimum value of the range of values.
		 * <fr>
		 * Valeur minimale de la plage de valeurs.
		 * </fr>
		 */
		public var min : Number;

		[Form(type="floatSpinner",
			  label="Maximum",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="1")]
		/**
		 * Maximum value of the range of values.
		 * <fr>
		 * Valeur maximale de la plage de valeurs.
		 * </fr>
		 */
		public var max : Number;

		/**
		 * <code>Range</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>Range</code>.
		 * </fr>
		 * @param	min	minimum value of the range
		 * 				<fr>valeur minimale de la plage</fr>
		 * @param	max	maximum value of the range
		 * 				<fr>valeur maximale de la plage</fr>
		 */
		public function Range( min : Number = Number.NEGATIVE_INFINITY,
							   max : Number = Number.POSITIVE_INFINITY )
		{
			this.min = min;
			this.max = max;
		}
		/**
		 * The median value of this object <code>Range</code>.
		 * <fr>
		 * La valeur médiane de cet objet <code>Range</code>.
		 * </fr>
		 */
		public function get middle () : Number { return ( min + max ) / 2; }

		/**
		 * Returns <code>true</code> if the range <code>r</code> overlaps
		 * the current range.
		 * <fr>
		 * Renvoie <code>true</code> si la plage <code>r</code> chevauche
		 * la plage courante.
		 * </fr>
		 * @param	r	range to check
		 * 				<fr>plage à tester</fr>
		 * @return	<code>true</code> if the range <code>r</code> overlaps
		 * 			the current range
		 * 			<fr><code>true</code> si la plage <code>r</code> chevauche
		 * 			la plage courante</fr>
		 */
		public function overlap( r : Range ) : Boolean
		{
			return ( this.max > r.min && r.max > this.min );
		}
		/**
		 * Returns <code>true</code> if the value <code>n</code>
		 * is contained in the current range.
		 * <fr>
		 * Renvoie <code>true</code> si la valeur <code>n</code>
		 * est contenue dans la plage courante.
		 * </fr>
		 * @param	n	value to check
		 * 				<fr>valeur à tester</fr>
		 * @return	<code>true</code> if the value <code>n</code>
		 * 			is contained in the current range
		 * 			<fr><code>true</code> si la valeur <code>n</code>
		 * 			est contenue dans la plage courante</fr>
		 */
		public function surround( n : Number ) : Boolean
		{
			return ( max >= n && min <= n );
		}
		/**
		 * Returns <code>true</code> if the range <code>r</code>
		 * contains the current range.
		 * <fr>
		 * Renvoie <code>true</code> si la plage <code>r</code>
		 * contient la plage courante.
		 * </fr>
		 * @param	r	reference range 
		 * 				<fr>plage de référence</fr>
		 * @return	<code>true</code> if the range <code>r</code>
		 * 			contains the current range
		 * 			<fr><code>true</code> si la plage <code>r</code>
		 * 			contient la plage courante</fr>
		 */
		public function inside ( r : Range ) : Boolean
		{
			return ( max < r.max && min > r.min );
		}
		/**
		 * Returns the size of the current range.
		 * <fr>
		 * Renvoie la taille de la plage courante.
		 * </fr>
		 * @return	the size of the current range
		 * 			<fr>la taille de la plage courante</fr>
		 */
		public function size() : Number
		{
			return max-min;
		}
		/**
		 * @inheritDoc
		 */
		public function equals ( r : * ) : Boolean
		{
			if( r is Range )
				return ( max == r.max && min == r.min );

			return false;
		}
		/**
		 * @inheritDoc
		 */
		public function clone () : *
		{
			return new Range ( min, max );
		}
		/**
		 * @inheritDoc
		 */
		public function copyTo (o : Object) : void
		{
			o["min"] = min;
			o["max"] = max;
		}
		/**
		 * @inheritDoc
		 */
		public function copyFrom (o : Object) : void
		{
			min = o["min"];
			max = o["max"];
		}
		
		/**
		 * @copy Dimension#toString()
		 */
		public function toString() : String
		{
			return StringUtils.stringify(this,{ min:min, max:max } );
		}
	}
}