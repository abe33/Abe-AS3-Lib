/**
 * @license
 */
package abe.com.mon.utils
{
	import abe.com.mon.core.Equatable;
	/**
	 * La fonction compare deux objets <code>a</code> et <code>b</code>
	 * et renvoie <code>true</code> si ceux-ci sont égaux.
	 * <p>
	 * La fonction <code>magicEquals</code> utilise des stratégies différentes
	 * selon les cas :
	 * </p>
	 * <ul>
	 * <li>Si les objets implémentent l'interface <code>Equatable</code>,
	 * la fonction utilise leur méthode <code>equals</code> pour les
	 * comparer.</li>
	 * <li>Si les objets n'implémentent pas l'interface <code>Equatable</code>
	 * mais qu'ils possèdent une méthode <code>equals</code>, celle-ci est
	 * utilisée pour les comparer.</li>
	 * <li>Si les deux objets sont des tableaux, et qu'ils sont de même longueur,
	 * la fonction parcours les tableaux et appelle <code>magicEquals</code> sur
	 * leur contenu.</li>
	 * <li>Si les deux  objets ne possèdent pas de fonction <code>equals</code>
	 * ils sont alors comparés à l'aide de l'opérateur <code>==</code>.</li>
	 * </ul>
	 *
	 * @param	a	premier objet à comparer
	 * @param	b	second objet à comparer
	 * @return	<code>true</code> si les deux objets sont égaux
	 * @author	Cédric Néhémie
	 * @see	abe.com.mon.core.Equatable
	 */
	public function magicEquals ( a : Object, b : Object ) : Boolean
	{
		// les 2 sont null, donc null == null = true
		if( ( a == null || a == "null" ) && ( b == null || b == "null" ) )
			return true;
		// l'un des deux est null donc o == null = false
		else if( a == null || a == "null" )
			return false;
		else if( b == null || b == "null" )
			return false;
		// les deux sont Equatable, on passe par la méthode equals
		else if( a is Equatable && b is Equatable )
			return ( a as Equatable ).equals( b );
		// pour les tableaux on parcours les tableaux si de meme longueurs
		else if( a is Array && b is Array )
			if( a.length != b.length )
				return false;
			else
				return a.every( function(o:Object,i:int,... args) : Boolean { return magicEquals(o, b[i] ); } );
		// si l'un des deux a une fonction equals on test le resultat
		else if( a.hasOwnProperty("equals") )
			return a.equals( b );
		else if( b.hasOwnProperty("equals") )
			return b.equals( a );
		// enfin on fait un test d'égalité simple
		else
			return a == b;
	}
}
