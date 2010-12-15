/**
 * @license
 */
package aesia.com.mon.utils
{
	import aesia.com.mon.core.Serializable;

	/**
	 * Renvoie le code source de l'objet <code>o</code> permettant
	 * de le reconstruire à l'aide de la méthode <code>Reflection.get</code>.
	 * <p>
	 * La méthode utilise plusieurs stratégies afin de réaliser cette opération :
	 * </p>
	 * <ul>
	 * <li>Si l'objet implémente l'interface <code>Serializable</code>,
	 * la fonction appelle la méthode <code>toReflectionSource</code>
	 * de l'objet.</li>
	 * <li>Si l'objet n'implémente pas l'interface <code>Serializable</code>,
	 * mais qu'il possède une méthode <code>toReflectionSource</code>, celle-ci
	 * est appellée.</li>
	 * <li>Si l'objet est une primitive, la fonction renvoie le résultat de
	 * son transtypage en <code>String</code>.</li>
	 * <li>Si l'objet est un tableau, la fonction parcours le tableau est
	 * appelle <code>magicToReflectionSource</code> sur son contenu.</li>
	 * <li>Si l'objet ne passe pas dans les cas précédent, la fonction
	 * renvoie un appel au constructeur de la méthode sans aucun argument.
	 * En effet, l'API de reflection de Flash ne permet pas de connaîre
	 * les arguments du constructeur.</li>
	 * </ul>
	 *
	 * @param	o	l'objet pour lequel on veut récupérer le code source
	 * @return	le code source de l'objet <code>o</code> permettant
	 * 			de le reconstruire à l'aide de la méthode
	 * 			<code>Reflection.get</code>
	 * @author	Cédric Néhémie
	 * @see	Reflection#get()
	 */
	public function magicToReflectionSource ( o : Object ) : String
	{
		if( o == null )
			return "null";
		
		if( o is Serializable )
			return (o as Serializable).toReflectionSource();

		else if( typeof o == "string" )
			return "\'"+o+"\'";

		else if( typeof o != "object" )
			return String(o);

		else if( o["toReflectionSource"] != null )
			return o.toReflectionSource();

		else
			return getConstructorCall( o );
	}
}
import aesia.com.mon.utils.magicToReflectionSource;

import flash.utils.getQualifiedClassName;

internal function getConstructorCall( o : * ) : String
{
	if( o is Array )
		return "[" + (o as Array).map(function(o:*,...args):String{ return magicToReflectionSource(o); }).join(",")+"]";
	else
		return "new " + getQualifiedClassName(o)+"()";
}
