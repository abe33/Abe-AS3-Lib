/**
 * @license
 */
package aesia.com.mon.utils
{
	import flash.system.ApplicationDomain;
	/**
	 * Renvoie le résultat de l'évaluation de la chaîne <code>query</code>.
	 *
	 * @param	query	<code>String</code> à évaluer selon les règles ci-dessus.
	 * @param	domain	[optionnel] un objet <code>ApplicationDomain</code> utilisé pour
	 * 					récupérer les références aux classes demandées.
	 * @return	le résultat de l'évaluation selon les règles décrites ci-dessous.
	 * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/package.html#getQualifiedClassName() getQualifiedClassName()
	 * @see Reflection#get()
	 * @example
	 * <p>
	 * La chaîne <code>query</code> peut prendre les formes suivantes :
	 * </p>
	 * <table class="innertable" >
	 * <tr><th>Littéral</th><th>&#xA0;</th></tr>
	 * <tr>
	 * 		<td><listing>10.5</listing></td>
	 * 		<td>Renvoie un <code>Number</code> de valeur <code>10.5</code>.</td>
	 * </tr>
	 * <tr>
	 * 		<td><listing>10</listing></td>
	 * 		<td>Renvoie un <code>Number</code> de valeur <code>10</code>.</td>
	 * </tr>
	 * <tr><td><listing>0xff</listing></td><td>Renvoie un <code>uint</code> de valeur <code>255</code>.</td></tr>
	 * <tr><td><listing>'foo'</listing>
	 * <listing>"foo"</listing></td><td>Renvoie une <code>String</code> contenant <code>foo</code>.</td></tr>
	 * <tr><td><listing>true</listing></td><td>Renvoie un <code>Boolean</code> à <code>true</code>.</td></tr>
	 * <tr><td><listing>/foo/gi</listing></td><td>Renvoie une <code>RegExp</code> validant une chaîne contenant <code>foo</code>.</td></tr>
	 * <tr><td><listing>&lt;foo&gt;bar&lt;b&gt;rab&lt;/b&gt;&lt;/foo&gt;</listing></td><td>Renvoie un objet <code>XML</code> correspondant à la structure fournie
	 * en argument.</td></tr>
	 * <tr><th>Classes, propriétés et méthodes</th><th>&#xA0;</th></tr>
	 * <tr><td><listing>Array</listing></td><td>Renvoie une référence vers la classe <code>Array</code>.</td></tr>
	 * <tr><td><listing>Array.prototype</listing></td><td>Renvoie la valeur de la propriété <code>prototype</code> de la classe <code>Array</code>.</td></tr>
	 * <tr><td><listing>flash.net::URLRequest</listing></td><td>Renvoie une référence à la classe <code>URLRequest</code> du package <code>flash.net</code>.
	 * La syntaxe utilisée ici est la même que celle utilisée dans la valeur retournée par la fonction
	 * <code>flash.utils.getQualifiedClassName</code>. Ainsi, ce genre de chose est possible :
	 * <listing>var objClass : Class = Reflection.get( getQualifiedClassName( unObjet ) );</listing></td></tr>
	 * <tr><td><listing>flash.geom::Point.interpolate</listing></td><td>Renvoie une référence à la fonction <code>interpolate</code> de la classe <code>Point</code>.</td></tr>
	 * <tr><td><listing>flash.utils::getTimer()</listing></td><td>Renvoie le résultat de l'appel à la fonction <code>getTimer</code>.</td></tr>
	 * <tr><td><listing>aesia.com.mon.utils::Color.Black.alphaClone( 0x66 )</listing></td><td>Renvoie un clone partiellement transparent de la constante <code>Black</code>
	 * de la classe<code>Color</code>.</td></tr>
	 * <tr><td><listing>aesia.com.mon.utils::Color.Black.alphaClone( 0x66 )
	 *                                 .interpolate( aesia.com.mon.utils::Color.Red,
	 *                                               0.5 )</listing></td><td>Renvoie un clone partiellement transparent de la constante <code>Black</code> mélangé à 50%
	 * avec la constante <code>Red</code>.</td></tr>
	 * <tr><th>Instanciation</th><th>&#xA0;</th></tr>
	 * <tr><td><listing>new Array()</listing></td><td>Renvoie une nouvelle instance de la classe <code>Array</code>.</td></tr>
	 * <tr><td><listing>new flash.geom::Point(5,5)</listing></td><td>Renvoie une nouvelle instance de la classe <code>Point</code>
	 * intialisée avec les valeurs <code>x = 5</code> et <code>y = 5</code>.</td></tr>
	 * <tr><td><listing>new my.package::MyClass( new flash.geom::Point(2,2), new aesia.com.mon.utils::Color.Red )</listing></td><td>Renvoie une nouvelle instance de la classe <code>MyClass</code>
	 * intialisée avec une nouvelle instance de la classe <code>Point</code>
	 * ainsi qu'une couleur constante de la classe <code>Color</code>.</td></tr>
	 * <tr><th>Tableaux</th></tr>
	 * <tr><td><listing>[5,'foo',true]</listing>
	 * <listing>(5,'foo',true)</listing>
	 * <listing>5,'foo',true</listing></td><td>Renvoie un <code>Array</code> contenant le nombre 5, la chaîne 'foo'
	 * et le booleén <code>true</code>.</td></tr>
	 * <tr><td><listing>[[0,0,0],[0,0,0],[0,0,0]]</listing></td><td>Renvoie un tableau à deux dimensions, de dimensions 3x3 avec
	 * <code>0</code> dans chaque case.</td></tr>
	 *
	 * <tr><th>Raccourcis</th></tr>
	 *
	 * <tr><td><listing>color(255,255,255,100)</listing>
	 * <listing>color(0xffff0000)</listing></td><td>Renvoie un nouvel objet <code>Color</code> construit à partir des arguments fournis.</td></tr>
	 * <tr><td><listing>color(Red)</listing>
	 * <listing>color(Maroon)</listing></td><td>Renvoie une référence vers une couleur enregistrée dans la classe <code>Color</code>.
	 * Si aucune couleur n'existe à ce nom, la fonction renvoie <code>null</code>.</td></tr>
	 * <tr><td><listing>gradient( [ color( Red ), color( Black ) ],[ 0, 1 ] )</listing></td><td>Renvoie un objet <code>Gradient</code> avec les couleurs <code>Red</code> et <code>Black</code>
	 * à chaque extrémité.</td></tr>
	 *
	 * <tr><td><listing>&#64;'http://foo.com'</listing>
	 * <listing>&#64;'http://foo.com/folder'</listing>
	 * <listing>&#64;'http://subdomain.foo.com/folder'</listing>
	 * <listing>&#64;'http://subdomain.foo.com/folder/file.foo'</listing>
	 * <listing>&#64;'file:///media/disk/folder/file.foo'</listing>
	 * <listing>&#64;'localfile.foo'</listing>
	 * <listing>&#64;'../src/localfile.foo'</listing></td><td>Renvoie un objet <code>URLRequest</code> pointant vers l'adresse correspondante. </td></tr>
	 * </table>
	 */
	public function $ ( query : String, domain : ApplicationDomain ) : *
	{
		return Reflection.get( query, domain );
	}
}