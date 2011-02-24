/**
 * @license
 */
package abe.com.mon.core 
{

	/**
	 * Use the <code>FormMetaProvider</code> to mark a class as providing
	 * <code>[Form]</code> metatags. The <code>FormUtils</code> class will 
	 * check if an object passed to it implements the <code>FormMetaProvider</code>
	 * interface to define how to handle it.
	 * 
	 * <fr>
	 * Interface servant de marqueur dans le cadre de la génération automatique
	 * de formulaire. Une classe implémentant l'interface <code>FormMetaProvider</code>
	 * permet d'indiquer au générateur de formulaire que la classe fournie des métadonnées
	 * de formulaire à utiliser pour générer ce dernier.
	 * </fr>
	 * 
	 * @author Cédric Néhémie
	 * @see	abe.com.ponents.forms.FormUtils
	 */
	public interface FormMetaProvider {}
}
