/**
 * @license
 */
package abe.com.mon.utils
{
	import abe.com.mon.core.Cloneable;

	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;


	/**
	 * Renvoie une copie de l'objet <code>v</code>.
	 * <p>
	 * La méthode <code>magicClone</code> à trois stratégies
	 * distinctes pour réaliser la copie d'un objet :
	 * </p>
	 * <ul>
	 * <li>Si l'objet implémente l'interface <code>Cloneable</code>,
	 * la fonction appelle la méthode <code>clone</code> de cet objet.</li>
	 * <li>Si l'objet n'implémente pas l'interface <code>Cloneable</code>
	 * mais qu'il possède une méthode <code>clone</code>, la fonction
	 * l'appelle.</li>
	 * <li>Si l'objet ne possède aucune méthode <code>clone</code> la
	 * fonction utilise un objet <code>ByteArray</code> pour réaliser
	 * la copie de l'objet. Dans ce cas, la classe de l'objet est alors
	 * enregistrée à l'aide de la méthode <code>registerClassAlias</code>.
	 * Dans le cas où <code>v</code> est de type <code>Array</code>,
	 * les éléments qu'il contient sont parcourus afin de les enregistrés
	 * à l'aide de <code>registerClassAlias</code>.</li>
	 * </ul>
	 *
	 * @param	v	l'objet à cloner
	 * @return	une copie de l'objet
	 * @author	Cédric Néhémie
	 * @see	abe.com.mon.core.Cloneable
	 */
	public function magicClone ( v : * ) : *
	{
		if( v is Cloneable )
			return ( v as Cloneable ).clone();

		if( (v as Object).hasOwnProperty("clone") )
			return (v as Object).clone();

		var t : String = typeof v;
		switch( t )
		{
			case "string" :
			case "boolean" :
			case "number" :
				return v;
			case "object" :
			case "xml" :
				if( v is Array )
				{
					var l : uint = (v as Array).length;
					var a : Array = [];
					for(var i : uint = 0; i <l; i++)
						a.push(magicClone(v[i]));
					return a;
				}
				registerClassAlias( getQualifiedClassName(v).replace("::", ".") , Reflection.getClass( v ) );
				
				var ba : ByteArray = new ByteArray();
				ba.writeObject( v );
				ba.position = 0;
				return ba.readObject();
				break;
		}
	}
}
