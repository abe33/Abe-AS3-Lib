/**
 * @license
 */
package  abe.com.mon.geom
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.StringUtils;

	import flash.utils.getQualifiedClassName;
	/**
	 * La classe <code>Range</code> représente une plage de valeurs.
	 *
	 * @author Cédric Néhémie
	 */
	public class Range implements Cloneable, Serializable, Equatable, FormMetaProvider
	{
		[Form(type="floatSpinner",
			  label="Minimum",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="0")]
		/**
		 * Valeur minimale de la plage de valeurs.
		 */
		public var min : Number;

		[Form(type="floatSpinner",
			  label="Maximum",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="1")]
		/**
		 * Valeur maximale de la plage de valeurs.
		 */
		public var max : Number;

		/**
		 * Constructeur de la classe <code>Range</code>.
		 *
		 * @param	min	valeur minimale de la plage
		 * @param	max	valeur maximale de la plage
		 */
		public function Range( min : Number = Number.NEGATIVE_INFINITY,
							   max : Number = Number.POSITIVE_INFINITY )
		{
			this.min = min;
			this.max = max;
		}
		/**
		 * La valeur médiane de cet objet <code>Range</code>.
		 */
		public function get middle () : Number { return ( min + max ) / 2; }

		/**
		 * Renvoie <code>true</code> si la plage <code>r</code> chevauche
		 * la plage courante.
		 *
		 * @param	r	plage à tester
		 * @return	<code>true</code> si la plage <code>r</code> chevauche
		 * 			la plage courante
		 */
		public function overlap( r : Range ) : Boolean
		{
			return ( this.max > r.min && r.max > this.min );
		}
		/**
		 * Renvoie <code>true</code> si la valeur <code>n</code>
		 * est contenue dans la plage courante.
		 *
		 * @param	n	valeur à tester
		 * @return	<code>true</code> si la valeur <code>n</code>
		 * 			est contenue dans la plage courante
		 */
		public function surround( n : Number ) : Boolean
		{
			return ( max >= n && min <= n );
		}
		/**
		 * Renvoie <code>true</code> si la plage <code>r</code>
		 * contient la plage courante.
		 *
		 * @param	r	plage de référence
		 * @return	<code>true</code> si la plage <code>r</code>
		 * 			contient la plage courante
		 */
		public function inside ( r : Range ) : Boolean
		{
			return ( max < r.max && min > r.min );
		}
		/**
		 * Renvoie la taille de la plage courante.
		 *
		 * @return la taille de la plage courante
		 */
		public function size() : Number
		{
			return max-min;
		}
		/**
		 *  Renvoie <code>true</code> si l'instance <code>r</code> est égale
		 * à l'instance courante.
		 *
		 * @param	r	instance à comparer
		 * @return	<code>true</code> si l'instance <code>r</code> est égale
		 * 			à l'instance courante
		 */
		public function equals ( r : * ) : Boolean
		{
			if( r is Range )
				return ( max == r.max && min == r.min );

			return false;
		}
		/**
		 * Renvoie une copie parfaite de cet objet <code>Range</code>.
		 *
		 * @return	une copie parfaite de cet objet <code>Range</code>
		 */
		public function clone () : *
		{
			return new Range ( min, max );
		}
		/**
		 * Renvoie la représentation du code source permettant
		 * de recréer l'instance courante.
		 *
		 * @return 	la représentation du code source ayant permis
		 * 			de créer l'instance courante
		 */
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		/**
		 * Renvoie la représentation du code source permettant
		 * de recréer l'instance courante à l'aide de la méthode
		 * <code>Reflection.get</code>.
		 *
		 * @return 	la représentation du code source ayant permis
		 * 			de créer l'instance courante
		 * @see	Reflection#get()
		 */
		public function toReflectionSource () : String
		{
			return "new " + getQualifiedClassName(this) + "(" + min + ", " + max + ")";
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 *
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString() : String
		{
			return StringUtils.stringify(this,{ min:min, max:max } );
		}


	}
}