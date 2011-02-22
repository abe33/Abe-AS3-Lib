/**
 * @license
 */
package abe.com.mon.geom 
{
	import flash.geom.Point;

	/**
	 * L'interface <code>Path</code> définie une méthode permettant 
	 * de récupérer des coordonnées dans le chemin à l'aide d'une
	 * valeur de position dans ce chemin.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Path
	{
		/**
		 * Renvoie les coordonnées dans le chemin à la position 
		 * définie par <code>path</code>.
		 * 
		 * @param	path	position dans le chemin dans la plage 0-1
		 * @return	les coordonnées dans le chemin à la position 
		 * 			transmise
		 */
		function getPathPoint ( path : Number ) : Point;
		/**
		 * Renvoie l'orientation du chemin à la position
		 * définie par <code>path</code>.
		 * 
		 * @param	path	position dans le chemin dans la plage 0-1
		 * @return	l'orientation dans le chemin à la position 
		 * 			transmise
		 */
		function getPathOrientation ( path : Number ) : Number;
	}
}
