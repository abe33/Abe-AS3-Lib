/**
 * @license
 */
package abe.com.ponents.layouts 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.utils.Insets;
	/**
	 * L'interface <code>Layout</code> définie les méthodes de base qu'un
	 * objet chargé de mettre en page des objets graphiques se doit d'implémenter.
	 * <p>
	 * Un objet <code>Layout</code> à deux responsabilités : 
	 * </p>
	 * <ul>
	 * <li>La première est de fournir une dimension de préférence pour un composant. 
	 * Cette taille de préférence étant a priori calculée sur la base du contenu
	 * de ce composant.</li>
	 * <li>Le seconde est de mettre en page concrètement le contenu d'un composant
	 * en fonction des données fournies.</li>
	 * </ul>
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Layout 
	{
		/**
		 * Met en page le contenu d'un composant selon les donnés fournie à la fonction.
		 * <p>
		 * Un objet <code>Layout</code> devrait toujours tenter de respecter la taille
		 * fournie en paramètre lors de sa mise en page, même si la taille est différente
		 * de la taille de préférence que celui-ci à renvoyé.
		 * </p>
		 * <p>
		 * L'objet <code>insets</code> fournit devrait être systématiquement soustrait
		 * aux dimensions fournies pour cet mise en page.
		 * </p>
		 * 
		 * @param	preferredSize	la taille de référence qui représente l'espace disponible
		 * 							pour mettre en page le contenu d'un composants	
		 * @param	insets			un objet <code>Insets</code> représentant les marges intérieures
		 * 							à appliquer lors de la mise en page
		 */
		function layout( preferredSize : Dimension = null, insets : Insets = null ) : void;
		
		/**
		 * Un objet <code>Dimension</code> représentant la taille idéale calculée pour un composant
		 * et basé sur le contenu de celui-ci.
		 */
		function get preferredSize(): Dimension;
				function get maximumContentSize(): Dimension;
	}
}
