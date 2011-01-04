/**
 * @license
 */
package  aesia.com.mon.geom
{
	import aesia.com.mon.core.Cloneable;
	import aesia.com.mon.core.Equatable;
	import aesia.com.mon.core.FormMetaProvider;
	import aesia.com.mon.core.Serializable;
	import aesia.com.mon.utils.StringUtils;

	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	/**
	 * Un objet <code>Dimension</code> contient les données nécessaire à la représentation
	 * d'une surface en deux dimensions.
	 *
	 * @author Cédric Néhémie
	 */
	public class Dimension implements Cloneable, Serializable, Equatable, FormMetaProvider
	{
		[Form(type="floatSpinner",
			  label="Width",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="0")]
		/**
		 * Longueur de la surface représenté par cet objet <code>Dimension</code>.
		 */		public var width : Number;

		[Form(type="floatSpinner",
			  label="Height",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="1")]
		/**
		 * Hauteur de la surface représenté par cet objet <code>Dimension</code>.
		 */
		public var height : Number;

		/**
		 * Constructeur de la classe <code>Dimension</code>.
		 *
		 * @param	width	longueur de cet objet <code>Dimension</code>
		 * @param	height	hauteur de cet objet <code>Dimension</code>
		 */
		public function Dimension ( width : Number = 0, height : Number = 0 )
		{
			this.width = width;
			this.height = height;
		}
		/**
		 * Renvoie <code>true</code> si l'instance <code>d</code> est égale
		 * à l'instance courante.
		 *
		 * @param	d	instance à comparer
		 * @return	<code>true</code> si l'instance <code>d</code> est égale
		 * 			à l'instance courante
		 */
		public function equals ( d : * ) : Boolean
		{
			if( d is Dimension )
				return (width == d.width && height == d.height );

			return false;
		}
		/**
		 * Copie les données contenue dans l'objet <code>dimension</code>
		 * au sein de cette instance.
		 *
		 * @param	dimension	objet fournissant les nouvelles dimensions
		 */
		public function setSize ( dimension : Dimension ) : void
		{
			width = dimension.width;
			height = dimension.height;
		}
		/**
		 * Modifie cet objet <code>Dimension</code> avec les données transmises en paramètre.
		 *
		 * @param	width	nouvelle longueur pour cet objet
		 * @param	height	nouvelle hauteur pour cet objet
		 */
		public function setSizeWH ( width : Number, height : Number ) : void
		{
			this.width = width;
			this.height = height;
		}
		/**
		 * Renvoie un nouvel objet <code>Dimension</code> résultant de
		 * l'addition des données de cette instance avec les valeurs
		 * passées en paramètres.
		 *
		 * @param	w	valeur à ajouter à la longueur de cet objet
		 * @param	h	valeur à ajouter à la hauteur de cet objet
		 * @return	un nouvel objet <code>Dimension</code>
		 */
		public function grow ( w : Number, h : Number ) : Dimension
		{
			return new Dimension( width + w, height + h);
		}
		/**
		 * Renvoie un nouvel objet <code>Dimension</code> résultant de
		 * ma multiplication des données de cette instance avec la valeur
		 * passée en paramètre.
		 *
		 * @param	n	valeur de multiplication des dimensions de cet objet
		 * @return	un nouvel objet <code>Dimension</code>
		 */
		public function scale ( n : Number ) : Dimension
		{
			return new Dimension( width * n, height * n );
		}
		/**
		 * Renvoie un nouvel objet <code>dimension</code> correspondant
		 * à l'union de cette instance avec celle passée en paramètre.
		 *
		 * @param	d	instance à joindre à cette instance
		 * @return	un nouvel objet <code>Dimension</code>
		 */
		public function union ( d : Dimension ) : Dimension
		{
			return new Dimension( Math.max( d.width, width ),
								  Math.max( d.height, height ) );
		}
		/**
		 * Renvoie un nouvel objet <code>dimension</code> correspondant
		 * à l'union de cette instance avec les données passées en paramètres.
		 *
		 * @param	w	longueur à joindre à cette instance		 * @param	h	hauteur à joindre à cette instance
		 * @return	un nouvel objet <code>Dimension</code>
		 */
		public function unionWH ( w : Number, h : Number ) : Dimension
		{
			return new Dimension( Math.max( w, width ),
								  Math.max( h, height ) );
		}
		/**
		 * Renvoie une copie parfaite de cet objet <code>Dimension</code>.
		 *
		 * @return	une copie parfaite de cet objet <code>Dimension</code>
		 */
		public function clone() : *
		{
			return new Dimension ( width, height );
		}
		/**
		 * Renvoie un objet <code>Point</code> contenant les mêmes valeurs
		 * que cet objet <code>Dimension</code>.
		 *
		 * @return	un objet <code>Point</code> contenant les mêmes valeurs
		 * 			que cet objet <code>Dimension</code>
		 */
		public function toPoint () : Point
		{
			return new Point( width, height );
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
			return "new " + getQualifiedClassName(this) + "(" + width + ", "+ height + ")";
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 *
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString() : String
		{
			return StringUtils.stringify(this,{ width:width, height:height } );
		}
	}
}
