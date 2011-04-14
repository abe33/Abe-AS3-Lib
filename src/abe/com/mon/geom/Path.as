/**
 * @license
 */
package abe.com.mon.geom 
{
	import flash.geom.Point;
	/**
	 * The interface <code>Path</code> defined a method to retrieve
	 * the coordinates in the path with a position value.
	 * <fr>
	 * L'interface <code>Path</code> définie une méthode permettant 
	 * de récupérer des coordonnées dans le chemin à l'aide d'une
	 * valeur de position dans ce chemin.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface Path
	{
		/**
		 * Returns the coordinates in the path to position
		 * defined by <code>path</code>.
		 * <fr>
		 * Renvoie les coordonnées dans le chemin à la position 
		 * définie par <code>path</code>.
		 * </fr>
		 * @param	path	path position in the range 0-1
		 * 					<fr>position dans le chemin dans la plage 0-1</fr>
		 * @return	coordinates in the path at the specified position
		 * 			<fr>les coordonnées dans le chemin à la position transmise</fr>
		 */
		function getPathPoint ( path : Number ) : Point;
		/**
		 * Returns the orientation of the path to position 
		 * defined by <code>path</code>.
		 * <fr>
		 * Renvoie l'orientation du chemin à la position
		 * définie par <code>path</code>.
		 * </fr>
		 * @param	path	path position in the range 0-1
		 * 					<fr>position dans le chemin dans la plage 0-1</fr>
		 * @return	orientation in the path at the specified position
		 * 			<fr>l'orientation dans le chemin à la position transmise</fr>
		 */
		function getPathOrientation ( path : Number ) : Number;
		/**
		 * Returns the tangent of the path at the coordinates <code>pos</code>
		 * in this <code>Spline</code>.
		 * <fr>
		 * Renvoie la tangente de la courbe aux coordonnées situées à la position
		 * <code>pos</code> du chemin de cette <code>Spline</code>.
		 * </fr>
		 * @param	pos			position at which calculated the tangent
		 * 						<fr>position à laquelle calculer la tangente</fr>
		 * @param 	posDetail	fineness of computation of the the tangent
		 * 						<fr>finesse de calcul de la position pour le calcul
		 * 						de la tangente</fr>
		 * @return	curve tangent at the specified coordinates
		 * 			<fr>la tangente de la courbe aux coordonnées situées à la position
		 * 			transmise en argument</fr>
		 */
		function getTangentAt( pos : Number, posDetail : Number = 0.01 ) : Point;
		/**
		 * The length of this <code>Path</code>.
		 * <fr>
		 * La longueur de ce <code>Path</code>.
		 * </fr>
		 */
		function get length () : Number;
	}
}
