/**
 * @license
 */
package abe.com.mon.core 
{
	import flash.display.Sprite;

	/**
	 * Un objet <code>LayeredSprite</code> est un objet graphique fournissant
	 * deux niveaux spécifiques <code>background</code> et <code>foreground</code>.
	 * <p>
	 * Il est possible à l'aide de ces deux niveaux de créer des effets volumétriques
	 * autour de cet objets en utilisant des jeux de superpositions et de changements
	 * de référents graphique.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public interface LayeredSprite extends IDisplayObjectContainer
	{
		/**
		 * Référence vers l'objet graphique représentant l'avant-plan.
		 */
		function get background() : Sprite;
		/**
		 * Référence vers l'objet graphique situé entre l'avant-plan 
		 * et l'arrière-plan.
		 */
		function get middle() : Sprite;
		/**
		 * Référence vers l'objet graphique représentant l'arrière-plan
		 */		function get foreground() : Sprite;
		
		/**
		 * Supprime tout les éléments graphiques construits avec les
		 * méthodes de l'objet <code>Graphics</code> de l'arrière-plan.
		 * <p>
		 * Le néttoyage ne sera réaliser concrètement qu'une seule fois
		 * par frame, quelque soit le nombre d'appel fait à la fonction.
		 * </p>
		 */
		function clearBackgroundGraphics () : void;
		/**
		 * Supprime tout les éléments graphiques construits avec les
		 * méthodes de l'objet <code>Graphics</code> de l'avant-plan.
		 * <p>
		 * Le néttoyage ne sera réaliser concrètement qu'une seule fois
		 * par frame, quelque soit le nombre d'appel fait à la fonction.
		 * </p>
		 */		function clearForegroundGraphics () : void;
		
	}
}
