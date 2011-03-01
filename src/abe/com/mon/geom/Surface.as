package abe.com.mon.geom
{
	import flash.geom.Point;

	/**
	 * The interface <code>size</code> defines the properties 
	 * and methods that an object with a surface must implement.
	 * <fr>
	 * L'interface <code>Surface</code> définie les propriétés
	 * et méthodes qu'un objet possédant une surface se doit
	 * d'implémenter.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface Surface
	{
		/**
		 * The size of this object in <code>px²</code>.
		 * <fr>
		 * La superficie de cet objet en <code>px²</code>.
		 * </fr>
		 */
		function get acreage () : Number;
		/**
		 * Returns an object <code>Point</code> containing random coordinates
		 * defined and contained in the surface of the object.
		 * <fr>
		 * Renvoie un objet <code>Point</code> contenant des coordonnées
		 * définies aléatoirement et comprises dans la surface de cet objet.
		 * </fr>
		 * 
		 * @return	an object <code>Point</code> containing random coordinates
		 * 			defined and contained in the surface of the object
		 * 			<fr>un objet <code>Point</code> contenant des coordonnées
		 * 			définies aléatoirement et comprises dans la surface de cet objet</fr>
		 */
		function getRandomPointInSurface() : Point;
		/**
		 * Returns <code>true</code> if the point <code>p</code> is located 
		 * within this surface
		 * 
		 * <fr>
		 * Renvoie <code>true</code> si le point <code>p</code>
		 * est situé à l'intérieur de cet objet <code>Surface</code>.
		 * </fr>
		 * @param	p	point which we wish to know if it is inside the surface
		 * 				<fr>point dont on souhait savoir si il se situe
		 * 				à l'intérieur de la surface</fr>
		 * @return	<code>true</code> if the point <code>p</code> is located 
		 * 			within this surface
		 */
		function containsPoint( p : Point ) : Boolean;
		/**
		 * Returns <code>true</ code> if the coordinates <code>x</code> and <code>y</code>
		 * are located within this surface.
		 * 
		 * <fr>
		 * Renvoie <code>true</code> si les coordonnées <code>x</code>
		 * et <code>y</code> sont situées à l'intérieur de cet objet
		 * <code>Surface</code>.
		 * </fr>
		 * @param	x	x axis coordinate to verify
		 * 				<fr>coordonnée sur l'axe x à vérifier</fr>		 * @param	y	y axis coordinate to verify
		 * 				<fr>coordonnée sur l'axe y à vérifier</fr>
		 * @return	<code>true</ code> if the coordinates <code>x</code> and <code>y</code>
		 * 			are located within this surface.
		 * 			<fr><code>true</code> si les coordonnées sont situées
		 * 			à l'intérieur la surface</fr>
		 */
		function contains( x : Number, y : Number ) : Boolean;
		/**
		 * Returns <code>true</code> if the geometry <code>geom</code> 
		 * is entirely contained within that surface.
		 * <fr>
		 * Renvoie <code>true</code> si la géometry <code>geom</code>
		 * est toute entière contenue dans cette surface.
		 * </fr>
		 * @param	geom	test geometry
		 * 					<fr>géométrie à tester</fr>
		 * @return	<code>true</code> if the geometry <code>geom</code> 
		 * 			is entirely contained within that surface
		 */
		function containsGeometry( geom : Geometry ) : Boolean;
	}
}
