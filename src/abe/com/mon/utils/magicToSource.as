/**
 * @license
 */
package abe.com.mon.utils
{
    import abe.com.patibility.serialize.SourceSerializer;

	/**
	 * Renvoie le code source de l'objet <code>o</code> permettant
	 * de le reconstruire.
	 * <p>
	 * La méthode utilise plusieurs stratégies afin de réaliser cette opération :
	 * </p>
	 * <ul>
	 * <li>Si l'objet implémente l'interface <code>Serializable</code>,
	 * la fonction appelle la méthode <code>toSource</code>
	 * de l'objet.</li>
	 * <li>Si l'objet n'implémente pas l'interface <code>Serializable</code>,
	 * mais qu'il possède une méthode <code>toSource</code>, celle-ci
	 * est appellée.</li>
	 * <li>Si l'objet est une primitive, la fonction renvoie le résultat de
	 * son transtypage en <code>String</code>.</li>
	 * <li>Si l'objet est un tableau, la fonction parcours le tableau est
	 * appelle <code>magicToSource</code> sur son contenu.</li>
	 * <li>Si l'objet ne passe pas dans les cas précédent, la fonction
	 * renvoie un appel au constructeur de la méthode sans aucun argument.
	 * En effet, l'API de reflection de Flash ne permet pas de connaîre
	 * les arguments du constructeur.</li>
	 * </ul>
	 *
	 * @param	o	l'objet pour lequel on veut récupérer le code source
	 * @return	le code source de l'objet <code>o</code> permettant
	 * 			de le reconstruire
	 * @author	Cédric Néhémie
	 */
	public function magicToSource ( o : Object ) : String
	{
        return new SourceSerializer().serialize(o);
	}
}
