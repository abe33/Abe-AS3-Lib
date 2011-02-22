/**
 * @license
 */
package  abe.com.mon.geom
{
	import abe.com.mon.utils.Color;

	import flash.display.Graphics;

	/**
	 * L'interface <code>Geometry</code> définie les méthodes qu'un objet vectoriel
	 * se doit d'implémenter afin de pouvoir interagir avec d'autres objets géométriques.
	 * <p>
	 * Toutes les implémentations de l'interface <code>Geometry</code> devraient et doivent
	 * implémenter les méthodes de calculs d'intersections entre géométries. Dans la plupart
	 * des cas il suffira à une classe concrète de faire appel aux méthodes correspondantes
	 * de la classe <code>GeometryUtils</code>.
	 * </p>
	 * @author	Cédric Néhémie
	 * @see	abe.com.mon.utils.GeometryUtils
	 */
	public interface Geometry
	{
		/**
		 * Dessine les contours de la géométrie dans l'objet <code>Graphics</code>
		 * à l'aide de la couleur <code>c</code>.
		 *
		 * @param	g	objet <code>Graphics</code> dans lequel dessiné
		 * @param	c	couleur avec laquelle dessiner la géométrie
		 */
		function draw ( g : Graphics, c : Color ) : void;
		/**
		 * Dessine en plein la géométrie dans l'objet <code>Graphics</code>
		 * à l'aide de la couleur <code>c</code>.
		 *
		 * @param	g	objet <code>Graphics</code> dans lequel dessiné
		 * @param	c	couleur avec laquelle dessiner la géométrie
		 */
		function fill ( g : Graphics, c : Color ) : void;
		/**
		 * Une référence vers un tableau contenant les points constituant la représentation
		 * de cette géométrie.
		 * <p>
		 * Certaines implémentations de l'interface <code>Geometry</code> peuvent être sujettes
		 * à une dégradations de leur modèle une fois que la géométrie est traduite à l'écran,
		 * dans un tel cas, la propriété <code>points</code> devrait elle aussi prendre
		 * en compte cette dégradation afin d'être le plus fidèle possible à la version
		 * écran de cette géométrie.
		 * </p>
		 * <p>
		 * Lorsque la géométrie est une forme fermée, les premières coordonnées et les dernières coordonnées
		 * doivent être identiques afin de permettre de parcourir la totalité des arrètes de la géométrie.
		 * </p>
		 */
		function get points () : Array;
		/**
		 * Renvoie <code>true</code> si cette géométrie et <code>geom</code> s'entrecroise.
		 * <p>
		 * Une implémentation standard de cette méthode peut simplement faire appel
		 * à la méthode <code>GeometryUtils.geometriesIntersects</code> afin de
		 * réaliser le calcul des intersections avec la géométrie.
		 * </p>
		 * @param	geom	la géometrie pour laquelle tester l'intersection
		 * @return	<code>true</code> si cette géométrie et <code>geom</code> s'entrecroise
		 * @see	abe.com.mon.utils.GeometryUtils#geometriesIntersects()
		 */
		function intersectGeometry ( geom : Geometry ) : Boolean;
		/**
		 * Renvoie un tableau contenant tout les points où cette géométrie croise
		 * la géométrie <code>geom</code>. Si aucune intersection n'est trouvée,
		 * la fonction renvoie <code>null</code>.
		 * <p>
		 * Une implémentation standard de cette méthode peut simplement faire appel
		 * à la méthode <code>GeometryUtils.geometriesIntersections</code> afin de
		 * réaliser le calcul des intersections avec la géométrie.
		 * </p>
		 * @param	geom	la géometrie pour laquelle récupérer les intersections.
		 * @return	un tableau contenant tout les points où cette géométrie croise
		 * 			la géométrie <code>geom</code>
		 * @see	abe.com.mon.utils.GeometryUtils#geometriesIntersections()
		 */
		function intersections ( geom : Geometry ) : Array;
	}
}
