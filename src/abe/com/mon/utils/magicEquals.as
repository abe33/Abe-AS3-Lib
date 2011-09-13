/**
 * @license
 */
package abe.com.mon.utils
{
    import abe.com.mon.core.Equatable;

    import flash.utils.getQualifiedClassName;
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
		if( ( a == null || a == "null" ) && ( b == null || b == "null" ) )
			return true;
		else if( a == null || a == "null" )
			return false;
		else if( b == null || b == "null" )
			return false;
		else if( a is Equatable && b is Equatable )
			return ( a as Equatable ).equals( b );
		else if( a is Array && b is Array )
		{
			if( a.length != b.length )
				return false;
			else
				return a.every( function(o:Object,i:int,... args) : Boolean { return magicEquals(o, b[i] ); } );
		}
		else if( getQualifiedClassName( a ) == getQualifiedClassName( b ) && a.hasOwnProperty("equals")  )
		{
			try { return a.equals( b ); } catch( e : Error ) { return false; }
		}
		else if( Reflection.isObject( a ) && 
				 Reflection.isObject( b ) )
		{
			var i : String;
			var o : Object = {};
			for( i in a )
			{
				if( !(b as Object).hasOwnProperty( i ) )
					return false;
				else if( b[i] != a[i] )
					return false;
				
				o[i] = true;
			}
			for( i in b )
			{
				if( o.hasOwnProperty(i) )
					continue;
				
				if( !(a as Object).hasOwnProperty( i ) )
					return false;
				else if( a[i] != b[i] )
					return false;
			}
			return true;
		}
		
		return a == b;
	}
}
