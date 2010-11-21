/**
 * @license
 */
package  aesia.com.mon.utils
{
	import aesia.com.mon.geom.pt;

	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * Classe utilitaire contenant des méthodes opérant sur des objets
	 * <code>Point</code>.
	 *
	 * @author	Cédric Néhémie
	 */
	public final class PointUtils
	{
		/**
		 * Renvoie le code source permettant de recréer l'objet <code>Point</code>.
		 *
		 * @param	p	objet <code>Point</code> à transformer en code source
		 * @return	le code source de <code>p</code>
		 */
		static public function toSource ( p : Point ) : String
		{
			return toReflectionSource ( p ).replace("::", ".");
		}
		/**
		 * Renvoie le code source permettant de recréer l'objet <code>Point</code>
		 * à l'aide de la méthode <code>Reflection.get</code>.
		 *
		 * @param	p	objet <code>Point</code> à transformer en code source
		 * @return	le code source de <code>p</code>
		 * @see		Reflection#get()
		 */
		static public function toReflectionSource ( p : Point ) : String
		{
			return "new flash.geom::Point(" + p.x + ", " + p.y + ")";
		}
		/**
		 * Renvoie l'objet <code>p</code> transformé après une rotation
		 * de <code>r</code> radians.
		 *
		 * @param	p	objet <code>Point</code> à transformer
		 * @param	r	angle en radians
		 * @return	l'objet <code>p</code> transformé après une rotation
		 * 			de <code>r</code> radians
		 */
		static public function rotate ( p : Point, r : Number ) : Point
		{
			var m : Matrix = new Matrix();
			m.rotate( r );
			return m.transformPoint( p );
		}
		/**
		 * Renvoie l'objet <code>p1</code> transformé après une rotation
		 * de <code>r</code> radians autour du point <code>p2</code>.
		 *
		 * @param	p1	objet <code>Point</code> à transformer		 * @param	p2	point de référence pour la transformation
		 * @param	r	angle en radians
		 * @return	l'objet <code>p1</code> transformé après une rotation
		 * 			de <code>r</code> radians autour du point <code>p2</code>
		 */
		static public function rotateAround( p1 : Point, p2 : Point, r : Number ) : Point
		{
			var d : Point = p1.subtract( p2 );
			d = PointUtils.rotate(d, r);
			var p : Point = p2.add(d);

			return p;
		}
		/**
		 * Multiplie les coordonnées dans l'objet <code>p</code> par la valeur
		 * de <code>s</code>.
		 *
		 * @param	p	point à transformer
		 * @param	s	facteur de multiplication
		 */
		static public function scale ( p : Point, s : Number ) : void
		{
			p.x *= s;
			p.y *= s;
		}
		/**
		 * Renvoie une nouvelle instance de la classe <code>Point</code>
		 * résultant de la multiplication des coordonnées contenues dans
		 * <code>p</code> par la valeur de <code>s</code>
		 *
		 * @param	p	point de référence à transformer
		 * @param	s	facteur de multiplication
		 * @return	une nouvelle instance de la classe <code>Point</code>
		 */
		static public function scaleNew ( p : Point, s : Number ) : Point
		{
			return pt( p.x * s, p.y * s );
		}
		/**
		 * Renvoie le produit scalaire des vecteurs <code>v1</code>
		 * et <code>v2</code>.
		 *
		 * @param	v1	un objet <code>Point</code> représentant le premier vecteur		 * @param	v2	un objet <code>Point</code> représentant le second vecteur
		 * @return	le produit scalaire des vecteurs <code>v1</code>
		 * 			et <code>v2</code>
		 */
		static public function dot(v1 : Point,v2 : Point):Number
		{
		    return (v1.x*v2.x) + (v1.y*v2.y);
		}
		/**
		 * Renvoie un objet <code>Point</code> représentant le vecteur
		 * reflet de <code>v</code> par rapport à la normale <code>normal</code>.
		 *
		 * @param	v		le vecteur à refléter
		 * @param	normal	la normale sur laquelle le vecteur doit se refléter
		 * @return	un objet <code>Point</code> représentant le vecteur
		 * 			reflet de <code>v</code>
		 */
		static public function reflect( v : Point, normal : Point ) : Point
		{
			normal.normalize(1);
			var d : Number = dot(v, normal);
			return new Point( v.x - 2 * d * normal.x, v.y - 2 * d * normal.y );
		}
		/**
		 * Renvoie un objet <code>Point</code> correspondant à la position
		 * <code>r</code> dans l'interpolation entre <code>pt1</code> et
		 * <code>pt2</code>.
		 *
		 * @param	pt1	premier point de l'interpolation
		 * @param	pt2	second point de l'interpolation
		 * @param	r	position dans l'interpolation
		 * @return	un objet <code>Point</code> correspondant à la position
		 * 			<code>r</code> dans l'interpolation entre <code>pt1</code>
		 * 			et <code>pt2</code>
		 */
		static public function interpolate( pt1 : Point, pt2 : Point,r : Number = 0.5 ) : Point
		{
			var s : Point = pt2.subtract(pt1);
			return new Point(	pt1.x + s.x * r,
								pt1.y + s.y * r );
		}
		/**
		 * Renvoie la valeur de l'angle formé par les deux vecteurs <code>v1</code>
		 * et <code>v2</code> en radians.
		 *
		 * @param	v1	premier vecteur		 * @param	v2	second vecteur
		 * @return	la valeur de l'angle formé par les deux vecteurs en radians
		 */
		static public function getAngle ( v1 : Point, v2 : Point) : Number
		{
			v1.normalize(1);
			v2.normalize(1);
			var d : Number = dot( v1, v2 );
			var neg : Boolean = false;
			if( d < 0 )
				neg = true;

			return Math.acos( Math.abs( d ) ) * (neg ? -1 : 1 );
		}
	}
}