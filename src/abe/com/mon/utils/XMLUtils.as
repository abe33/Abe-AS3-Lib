/**
 * @license
 */
package abe.com.mon.utils 
{

	/**
	 * Classe utilitaire fournissant des méthodes permettant
	 * d'opérer sur des objets de type <code>XML</code> ou
	 * <code>XMLList</code>.
	 * 
	 * @author Cédric Néhémie
	 */
	public class XMLUtils 
	{
		/**
		 * Renvoie <code>true</code> si l'objet <code>XML node</code> possède
		 * un attribut nommé de la valeur de <code>att</code>.
		 * 
		 * @param	node	objet <code>XML</code> à tester
		 * @param	att		nom de l'attibut à vérfier
		 * @return	<code>true</code> si l'objet <code>XML node</code> possède
		 * 			un attribut nommé de la valeur de <code>att</code>
		 */
		static public function hasAttribute ( node : XML, att : String ) : Boolean
		{
			return node.attribute( att ).length() != 0;
		}
		
	}
}
