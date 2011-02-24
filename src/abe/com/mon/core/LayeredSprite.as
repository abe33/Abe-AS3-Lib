/**
 * @license
 */
package abe.com.mon.core 
{
	import flash.display.Sprite;

	/**
	 * A <code>LayeredSprite</code> is a graphical entity which provide
	 * two specific levels, <code>background</code> and <code>foreground</code>,
	 * that wraps the object content.
	 * <p>
	 * Using that two levels, it's possible to create volumetric effects by
	 * playing with superimposition or change in the graphic referent.
	 * </p>
	 * 
	 * <fr>
	 * Un objet <code>LayeredSprite</code> est un objet graphique fournissant
	 * deux niveaux spécifiques <code>background</code> et <code>foreground</code>.
	 * <p>
	 * Il est possible à l'aide de ces deux niveaux de créer des effets volumétriques
	 * autour de cet objets en utilisant des jeux de superpositions et de changements
	 * de référents graphique.
	 * </p>
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface LayeredSprite extends IDisplayObjectContainer
	{
		/**
		 * Reference to the object placed on the front of the content.
		 * 
		 * <fr>
		 * Référence vers l'objet graphique représentant l'avant-plan.
		 * </fr>
		 */
		function get background() : Sprite;
		/**
		 * Reference to the object placed between the decorative layers.
		 * 
		 * <fr>
		 * Référence vers l'objet graphique situé entre l'avant-plan 
		 * et l'arrière-plan.
		 * </fr>
		 */
		function get middle() : Sprite;
		/**
		 * Reference to the object placed on the back of the content.
		 * 
		 * <fr>
		 * Référence vers l'objet graphique représentant l'arrière-plan.
		 * </fr>
		 */		function get foreground() : Sprite;
		
		/**
		 * Remove all the content and drawings done on the back sprite
		 * of this object.
		 * <p>
		 * The cleaning should be processed only once per frame, no matter
		 * how many times the method was called.
		 * </p>
		 * 
		 * <fr>
		 * Supprime tout les éléments graphiques construits avec les
		 * méthodes de l'objet <code>Graphics</code> de l'arrière-plan.
		 * <p>
		 * Le néttoyage ne sera réaliser concrètement qu'une seule fois
		 * par frame, quelque soit le nombre d'appel fait à la fonction.
		 * </p>
		 * </fr>
		 */
		function clearBackgroundGraphics () : void;
		/**
		 * Remove all the content and drawings done on the front sprite
		 * of this object.
		 * <p>
		 * The cleaning should be processed only once per frame, no matter
		 * how many times the method was called.
		 * </p>
		 * 
		 * <fr>
		 * Supprime tout les éléments graphiques construits avec les
		 * méthodes de l'objet <code>Graphics</code> de l'avant-plan.
		 * <p>
		 * Le néttoyage ne sera réaliser concrètement qu'une seule fois
		 * par frame, quelque soit le nombre d'appel fait à la fonction.
		 * </p>
		 * </fr>
		 */		function clearForegroundGraphics () : void;
		
	}
}
