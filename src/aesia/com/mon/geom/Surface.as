package aesia.com.mon.geom
{
	import flash.geom.Point;

	/**
	 * L'interface <code>Surface</code> définie les propriétés
	 * et méthodes qu'un objet possédant une surface se doit
	 * d'implémenter.
	 *
	 * @author Cédric Néhémie
	 */
	public interface Surface
	{
		/**
		 * La superficie de cet objet en <code>px²</code>.
		 */
		function get acreage () : Number;
		/**
		 * Renvoie un objet <code>Point</code> contenant des coordonnées
		 * définies aléatoirement et comprises dans la surface de cet objet.
		 *
		 * @return	un objet <code>Point</code> contenant des coordonnées
		 * 			définies aléatoirement et comprises dans la surface de cet objet
		 */
		function getRandomPointInSurface() : Point;
		/**
		 * Renvoie <code>true</code> si le point <code>p</code>
		 * est situé à l'intérieur de cet objet <code>Surface</code>.
		 *
		 * @param	p	point dont on souhait savoir si il se situe
		 * 				à l'intérieur de la surface
		 * @return	<code>true</code> si le point est situé à l'intérieur
		 * 			de la surface
		 */
		function containsPoint( p : Point ) : Boolean;
		/**
		 * Renvoie <code>true</code> si les coordonnées <code>x</code>
		 * et <code>y</code> sont situées à l'intérieur de cet objet
		 * <code>Surface</code>.
		 *
		 * @param	x	coordonnée sur l'axe x à vérifier		 * @param	y	coordonnée sur l'axe y à vérifier
		 * @return	<code>true</code> si les coordonnées sont situées
		 * 			à l'intérieur la surface
		 */
		function contains( x : Number, y : Number ) : Boolean;
		/**
		 * Renvoie <code>true</code> si la géometry <code>geom</code>
		 * est toute entière contenue dans cette surface.
		 *
		 * @param	geom	géométrie à tester
		 * @return	<code>true</code> si la géometry est toute
		 * 			entière contenue dans cette surface
		 */
		function containsGeometry( geom : Geometry ) : Boolean;
	}
}
