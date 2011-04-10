/**
 * @license
 */
package abe.com.edia.fx.emitters 
{
	import flash.geom.Point;

	/**
	 * L'interface <code>Emitter</code> définie la méthode <code>get</code>
	 * laquelle renvoie des coordonnées utilisables dans le cadre de générations
	 * de particules ou du placement aléatoire d'objets.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Emitter 
	{
		/**
		 * Renvoie des coordonnées déterminées aléatoirement ou non. Le choix
		 * de la méthode de calculs des coordonnées à renvoyer et laissé à la
		 * discrétion des classes concrètes implémentant l'interface <code>Emitter</code>.
		 * 
		 * @param	n	une valeur aléatoire fournie à la fonction
		 * @return	des coordonnées déterminées aléatoirement ou non
		 */
		function get( n : Number = NaN ) : Point;
	}
}
