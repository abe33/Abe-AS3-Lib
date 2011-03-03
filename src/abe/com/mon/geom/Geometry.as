/**
 * @license
 */
package  abe.com.mon.geom
{
	import abe.com.mon.utils.Color;

	import flash.display.Graphics;

	/**
	 * The <code>Geometry</code> interface defines the methods that a geometric object
	 * have to implement in order to interact with other geometric objects.
	 * <p>
	 * All concrets classes should take care of implementing the methods related to
	 * intersection between geometries. In most case, the concret class will just have
	 * to use the corresponding methods in the <code>GeometryUtils</code> class. But, if
	 * a more efficient way to compute intersections can be implemented for a specific kind
	 * of geometry, the class can implement its own method. 
	 * </p>
	 * 
	 * <fr>
	 * L'interface <code>Geometry</code> définie les méthodes qu'un objet vectoriel
	 * se doit d'implémenter afin de pouvoir interagir avec d'autres objets géométriques.
	 * <p>
	 * Toutes les implémentations de l'interface <code>Geometry</code> devraient et doivent
	 * implémenter les méthodes de calculs d'intersections entre géométries. Dans la plupart
	 * des cas il suffira à une classe concrète de faire appel aux méthodes correspondantes
	 * de la classe <code>GeometryUtils</code>.
	 * </p>
	 * </fr>
	 * @author	Cédric Néhémie
	 * @see	abe.com.mon.utils.GeometryUtils
	 */
	public interface Geometry
	{
		/**
		 * Draws the outline of the geometry into the passed-in <code>Graphics</code>
		 * object using the color <code>c</code>.
		 * 
		 * <fr>
		 * Dessine les contours de la géométrie dans l'objet <code>Graphics</code>
		 * à l'aide de la couleur <code>c</code>.
		 * </fr>
		 * @param	g	<code>Graphics</code> object in which drawing the geometry
		 * 				<fr>objet <code>Graphics</code> dans lequel dessiné</fr>
		 * @param	c	color with which to draw the geometry
		 * 				<fr>couleur avec laquelle dessiner la géométrie</fr>
		 */
		function draw ( g : Graphics, c : Color ) : void;
		/**
		 * Draw the fill of the geometry into the passed-in <code>Graphics</code> object
		 * using the color <code>c</code>.
		 * 
		 * <fr>
		 * Dessine en plein la géométrie dans l'objet <code>Graphics</code>
		 * à l'aide de la couleur <code>c</code>.
		 * </fr>
		 * @param	g	<code>Graphics</code> object in which drawing the geometry
		 * 				<fr>objet <code>Graphics</code> dans lequel dessiné</fr>
		 * @param	c	color with which to draw the geometry
		 * 				<fr>couleur avec laquelle dessiner la géométrie</fr>
		 */
		function fill ( g : Graphics, c : Color ) : void;
		/**
		 * A reference to an array containing the points constituting the representation
		 * of this geometry.
		 * <p>
		 * Some implementations of the interface <code>Geometry</code> may be subject
		 * to a deterioration of their model when the geometry is translated to the screen,
		 * in this case, the <code> points</code> should also take
		 * consider this degradation to be as faithful as possible to the screen 
		 * version of this geometry.
		 * </p>
		 * <p>
		 * When the geometry is a closed shape, the first and the latest coordinates 
		 * must be identical to allow to browse all of the edges of the geometry 
		 * in a for loop.
		 * </p>
		 * 
		 * <fr>Une référence vers un tableau contenant les points constituant la représentation
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
		 * </fr>
		 */
		function get points () : Array;
		/**
		 * Returns <code>true</code> if this geometry and <code>geom</code> intersects.
		 * <p>
		 * A standard implementation of this method can simply call
		 * to <code>GeometryUtils.geometriesIntersects</code> to
		 * perform the calculation of intersections with the geometry.
		 * </p>
		 * 
		 * <fr>
		 * Renvoie <code>true</code> si cette géométrie et <code>geom</code> s'entrecroise.
		 * <p>
		 * Une implémentation standard de cette méthode peut simplement faire appel
		 * à la méthode <code>GeometryUtils.geometriesIntersects</code> afin de
		 * réaliser le calcul des intersections avec la géométrie.
		 * </p>
		 * </fr>
		 * @param	geom	geometry for which test intersections
		 * 					<fr>la géometrie pour laquelle tester l'intersection</fr>
		 * @return	<code>true</code> if this geometry and <code>geom</code> intersects
		 * 			<fr><code>true</code> si cette géométrie et <code>geom</code> s'entrecroise</fr>
		 * @see	abe.com.mon.utils.GeometryUtils#geometriesIntersects()
		 */
		function intersectGeometry ( geom : Geometry ) : Boolean;
		/**
		 * Returns an array containing all the points where the geometry crosses 
		 * the geometry <code>geom</code>. If no intersection is found,
		 * the function returns <code>null</code>.
		 * <p>
		 * A standard implementation of this method can simply call 
		 * to <code>GeometryUtils.geometriesIntersections</code> to
		 * perform the calculation of intersections with the geometry.
		 * </p>
		 * 
		 * <fr>
		 * Renvoie un tableau contenant tout les points où cette géométrie croise
		 * la géométrie <code>geom</code>. Si aucune intersection n'est trouvée,
		 * la fonction renvoie <code>null</code>.
		 * <p>
		 * Une implémentation standard de cette méthode peut simplement faire appel
		 * à la méthode <code>GeometryUtils.geometriesIntersections</code> afin de
		 * réaliser le calcul des intersections avec la géométrie.
		 * </p>
		 * </fr>
		 * 
		 * @param	geom	geometry for which to retrieve the intersections
		 * 					<fr>la géometrie pour laquelle récupérer les intersections</fr>
		 * @return	an array containing all the points where the geometry crosses
		 * 			geometry <code>geom</code>
		 * 			<fr>un tableau contenant tous les points où cette géométrie croise
		 * 			la géométrie <code>geom</code></fr>
		 * @see	abe.com.mon.utils.GeometryUtils#geometriesIntersections()
		 */
		function intersections ( geom : Geometry ) : Array;
	}
}
