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

	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	/**
	 * A <code>Dimension</code> object contains the data needed to
	 * represent a surface in two dimensions.
	 * <fr>
	 * Un objet <code>Dimension</code> contient les données nécessaire à la représentation
	 * d'une surface en deux dimensions.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class Dimension implements Cloneable, 
									  Copyable,
									  Serializable, 
									  Equatable, 
									  FormMetaProvider
	{
		[Form(type="floatSpinner",
			  label="Width",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="0")]
		/**
		 * Width of the surface represented by this object <code>Dimension</code>.
		 * <fr>
		 * Longueur de la surface représenté par cet objet <code>Dimension</code>.
		 * </fr>
		 */		public var width : Number;

		[Form(type="floatSpinner",
			  label="Height",
			  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
			  step="1",
			  order="1")]
		/**
		 * Height of the surface represented by this object <code>Dimension</code>.
		 * <fr>
		 * Hauteur de la surface représenté par cet objet <code>Dimension</code>.
		 * </fr>
		 */
		public var height : Number;

		/**
		 * <code>Dimension</code> class constructor.
		 * <fr>
		 * Constructeur de la classe <code>Dimension</code>.
		 * </fr>
		 * @param	width	width of this <code>Dimension</code> object
		 * 					<fr>longueur de cet objet <code>Dimension</code></fr>
		 * @param	height	height of this <code>Dimension</code> object
		 * 					<fr>hauteur de cet objet <code>Dimension</code></fr>
		 */
		public function Dimension ( width : Number = 0, height : Number = 0 )
		{
			this.width = width;
			this.height = height;
		}
		/**
		 * Copy the data contained in the <code>dimension</code> argument in this instance.
		 * <fr>
		 * Copie les données contenue dans l'objet <code>dimension</code>
		 * au sein de cette instance.
		 * </fr>
		 * @param	dimension	object providing the new dimensions
		 * 						<fr>objet fournissant les nouvelles dimensions</fr>
		 * @see	#copyFrom()
		 */
		public function setSize ( dimension : Dimension ) : void { copyFrom( dimension ); }
		/**
		 * Amends this <code>Dimension</code> with the data transmitted as a parameter.
		 * <fr>
		 * Modifie cet objet <code>Dimension</code> avec les données transmises en paramètre.
		 * </fr>
		 * @param	width	nouvelle longueur pour cet objet
		 * @param	height	nouvelle hauteur pour cet objet
		 */
		public function setSizeWH ( width : Number, height : Number ) : void
		{
			this.width = width;
			this.height = height;
		}
		/**
		 * Returns a new object <code>Dimension</code> resulting
		 * from the addition of data from this instance with
		 * the values passed as parameters.
		 * <fr>
		 * Renvoie un nouvel objet <code>Dimension</code> résultant de
		 * l'addition des données de cette instance avec les valeurs
		 * passées en paramètres.
		 * </fr>
		 * @param	w	value to add to the width of this object
		 * 				<fr>valeur à ajouter à la longueur de cet objet</fr>
		 * @param	h	value to add to the height of this object
		 * 				<fr>valeur à ajouter à la hauteur de cet objet</fr>
		 * @return	a new <code>Dimension</code> object
		 * 			<fr>un nouvel objet <code>Dimension</code></fr>
		 */
		public function grow ( w : Number, h : Number ) : Dimension
		{
			return new Dimension( width + w, height + h);
		}
		/**
		 * Returns a new object <code>Dimension</code> by multiplying
		 * the data in this instance with the value passed as parameter.
		 * <fr>
		 * Renvoie un nouvel objet <code>Dimension</code> résultant de
		 * la multiplication des données de cette instance avec la valeur
		 * passée en paramètre.
		 * </fr>
		 * @param	n	multiplication value of the dimensions of this item
		 * 				<fr>valeur de multiplication des dimensions de cet objet</fr>
		 * @return	a new <code>Dimension</code> object
		 * 			<fr>un nouvel objet <code>Dimension</code></fr>
		 */
		public function scale ( n : Number ) : Dimension
		{
			return new Dimension( width * n, height * n );
		}
		/**
		 * Returns a new object <code>Dimension</code> corresponding 
		 * to the union of this instance with the one passed as parameter.
		 * <fr>
		 * Renvoie un nouvel objet <code>Dimension</code> correspondant
		 * à l'union de cette instance avec celle passée en paramètre.
		 * </fr>
		 * @param	d	instance to join the current one
		 * 				<fr>instance à joindre à cette instance</fr>
		 * @return	a new <code>Dimension</code> object
		 * 			<fr>un nouvel objet <code>Dimension</code></fr>
		 */
		public function union ( d : Dimension ) : Dimension
		{
			return new Dimension( Math.max( d.width, width ),
								  Math.max( d.height, height ) );
		}
		/**
		 * Returns a new object <code>Dimension</code> corresponding
		 * to the union of this instance with data passed as parameters.
		 * <fr>
		 * Renvoie un nouvel objet <code>Dimension</code> correspondant
		 * à l'union de cette instance avec les données passées en paramètres.
		 * </fr>
		 * @param	w	width to join to this instance
		 * 				<fr>longueur à joindre à cette instance</fr>		 * @param	h	height to join to this instance
		 * 				<fr>hauteur à joindre à cette instance</fr>
		 * @return	a new <code>Dimension</code> object
		 * 			<fr>un nouvel objet <code>Dimension</code></fr>
		 */
		public function unionWH ( w : Number, h : Number ) : Dimension
		{
			return new Dimension( Math.max( w, width ),
								  Math.max( h, height ) );
		}
		/**
		 * @inheritDoc
		 */
		public function clone() : *
		{
			return new Dimension ( width, height );
		}
		/**
		 * @inheritDoc
		 */
		public function copyTo (o : Object) : void
		{
			o["width"] = width;			o["height"] = height;
		}
		/**
		 * @inheritDoc
		 */
		public function copyFrom (o : Object) : void
		{
			width = o["width"];			height = o["height"];
		}
		/**
		 * @inheritDoc
		 */
		public function equals ( d : * ) : Boolean
		{
			if( d is Dimension )
				return ( width == d["width"] && height == d["height"] );
			else if ( d is Point )
				return ( width == d["x"] && height == d["y"] );
			else if( d is Object )
			{
				var o : Object = d as Object;
				if( o.hasOwnProperty("width") && o.hasOwnProperty("height") )
					return ( width == o["width"] && height == o["height"] );
			}
			return false;
		}
		/**
		 * Returns an object <code>Point</code> containing 
		 * the same values as this object <code>Dimension</code>.
		 * <fr>
		 * Renvoie un objet <code>Point</code> contenant les mêmes valeurs
		 * que cet objet <code>Dimension</code>.
		 * </fr>
		 * @return	an object <code>Point</code> containing 
		 * 			the same values as this object <code>Dimension</code>
		 * 			<fr>un objet <code>Point</code> contenant les mêmes valeurs
		 * 			que cet objet <code>Dimension</code></fr>
		 */
		public function toPoint () : Point
		{
			return new Point( width, height );
		}
		/**
		 * @inheritDoc
		 */
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		/**
		 * @inheritDoc
		 */
		public function toReflectionSource () : String
		{
			return "new " + getQualifiedClassName(this) + "(" + width + ", "+ height + ")";
		}
		/**
		 * Returns the representation of the object as a string.
		 * <fr>
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 * </fr>
		 * @return	the representation of the object as a string
		 * 			<fr>la représentation de l'objet sous forme de chaîne</fr>
		 */
		public function toString() : String
		{
			return StringUtils.stringify(this,{ width:width, height:height } );
		}
	}
}
