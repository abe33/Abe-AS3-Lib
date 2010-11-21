/**
 * @license
 */
package aesia.com.mon.utils
{
	import aesia.com.mon.logs.Log;

	import flash.errors.IllegalOperationError;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * La classe utilitaire <code>Reflection</code> fournit un ensemble de méthodes
	 * permettant de récupérer nombre d'informations sur les objets et classes
	 * au sein d'un fichier SWF.
	 *
	 * @author Cédric Néhémie
	 */
	public class Reflection
	{
		/**
		 * Le nom qualifié de la classe <code>Vector</code> afin de générer dynamiquement
		 * les vecteurs typés.
		 *
		 * @default	"Vector"
		 */
		static protected const VECTOR_CLASSNAME : String = getQualifiedClassName( Vector );
		/**
		 * Une valeur booléenne indiquant si la méthode <code>get</code> lance une
		 * alerte dans le cas où elle rencontrerait une chaîne ne pouvant être traitée et
		 * qui ne serait pas entourée de caractère <code>"</code> ou <code>'</code>.
		 *
		 * @default	true
		 */
		static public var WARN_UNWRAPPED_STRING : Boolean = true;
		/**
		 * Un objet servant de cache pour les résultats des appels à
		 * la fonction <code>describeClass</code>.
		 *
		 * @default	{}
		 * @see #describeClass()
		 */
		static protected var _describeTypeCache : Object = {};
		/**
		 * Un tableau stockant les clés d'accès au cache afin d'en déterminer
		 * la taille.
		 *
		 * @default []
		 */		static protected var _describeTypeCacheKeys : Array = [];
		/**
		 * Un entier indiquant la limite maximum pour le nombre
		 * de description de classe stockées par la classe <code>Reflection</code>
		 *
		 * @default	50
		 */		static protected var _describeTypeCacheMaxLength : uint = 50;

		/**
		 * Un objet servant de cache pour les résultats de requêtes
		 * sur les balises metas d'un objet ou d'une classe.
		 *
		 * @default	{}
		 * @see #getClassMeta()		 * @see #getClassMetas()
		 * @see #getClassAndAncestorMeta()		 * @see #getClassAndAncestorMetas()		 * @see #getClassMembersWithMeta()		 * @see #getClassMembersWithMetas()
		 */		static protected var _metasCache : Object = {};
		/**
		 * Un objet contenant les raccourcis spécifiques définit
		 * par l'utilisateur.
		 *
		 * @default {}
		 */
		static protected var _customShortcuts : Object = {};
		/**
		 * Ajoute un raccourci définit par l'utilisateur pour être pris
		 * en compte dans la fonction <code>get</code>.
		 * <p>
		 * Un raccourci est en pratique un remplacement effectué par la fonction
		 * afin de déterminer la requête final à éxécuter.
		 * </p>
		 * @param	s			la chaîne de caractère à replacer
		 * @param	replacement	la valeur de remplacement
		 * @example Le raccourci <code>gradient</code> pourrait être définit de la manière suivante :
		 * <listing>Reflection.addCustomShortcuts("gradient(", "new aesia.com.mon.utils.Gradient(");</listing>
		 */
		static public function addCustomShortcuts ( s : String, replacement : String ) : void
		{
			_customShortcuts [ s ] = replacement;
		}
		/**
		 * Renvoie une référence vers une classe <code>Vector</code> dont le
		 * type des éléments est <code>clazz</code>.
		 *
		 * @param	clazz				le type des éléments du vecteur
		 * @param	applicationDomain	[optionnel] le domaine d'application permettant
		 * 								d'accéder à la classe <code>Vector</code> typée
		 * @return	une référence vers une classe <code>Vector</code> dont le
		 * 			type des éléments est <code>clazz</code>
		 */
		static public function getVectorDefinition( clazz:Class , applicationDomain:ApplicationDomain = null ):Class
        {
            if ( clazz == null )
            {
                return null ;
            }
            if( applicationDomain == null )
            {
                applicationDomain = ApplicationDomain.currentDomain ;
            }
            return applicationDomain.getDefinition( VECTOR_CLASSNAME + '.<' + getQualifiedClassName( clazz ) +'>' ) as Class;
        }
		/**
		 * Renvoie une référence vers la classe de l'objet <code>o</code> passé en argument.
		 *
		 * @param	o		l'objet dont on souhaite récupérer la classe
		 * @param	domain	[optionnel] le domaine d'application permettant de récupérer la classe
		 * @return	une référence vers la classe de <code>o</code>
		 */
		static public function getClass( o : Object, domain : ApplicationDomain = null ) : Class
        {
        	return ( domain ? domain : ApplicationDomain.currentDomain ).getDefinition( getQualifiedClassName( o ) ) as Class;
        }
        /**
		 * Renvoie le nom de la classe de <code>v</code> sans le chemin
		 * du package auquel elle appartient
		 *
		 * @param	v	objet dont on souhaite récupérer le nom de la classe
		 * @return	le nom de la classe
		 * @example	<listing>trace( Reflection.extractClassName( new Point() ) ); // output : Point</listing>
		 */
		static public function extractClassName ( v : * ) : String
		{
			var a : Array = getQualifiedClassName ( v ).split ( "::" );
			return a.length > 1 ? a[1] : a[0];
		}
        /**
         * Renvoie un objet <code>XML</code> contenant la description de <code>o</code>
         * telle que renvoyée par la fonction <code>flash.utils.describeType</code>.
         * <p>
         * Le paramètre <code>useCache</code> définit si le résultat de l'appel à
         * <code>describeClass</code> doit être stocké dans le cache ou non.
         * Que ce paramètre soit <code>true</code> ou <code>false</code> la fonction
         * renverra toujours le contenu du cache en priorité. En effet le résultat
         * de <code>flash.utils.decribeType</code> ne varie pas d'une instance à l'autre.
         * </p>
         *
         * @param	o			instance ou classe dont on souhaite obtenir la description
         * @param	useCache	[optionnel] si <code>true</code> la fonction sauvegardera
         * 						le résultat dans le cache.
         * @return	un objet <code>XML</code> contenant la description de l'instance ou de
         * 			la classe
         * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/package.html#describeType() describeType()
         */
		static public function describeClass ( o : *, useCache : Boolean = true ) : XML
		{
			if( _describeTypeCache[ o ] )
				return _describeTypeCache[ o ];
			else
			{
				if( useCache )
				{
					if( _describeTypeCacheKeys.length + 1 > _describeTypeCacheMaxLength )
					{
						delete _describeTypeCache[ _describeTypeCacheKeys.shift() ];
					}
					_describeTypeCacheKeys.push( o );
					return _describeTypeCache[ o ] = describeType( o );
				}
				else
					return describeType( o );
			}
		}
		/**
         * Renvoie un objet <code>XMLList</code> contenant la description des balises de
         * metadonnées compilées avec la classe ou l'instance.
         * <p>
         * Le paramètre <code>useCache</code> définit si le résultat de l'appel à
         * <code>getClassMetas</code> doit être stocké dans le cache ou non.
         * Que ce paramètre soit <code>true</code> ou <code>false</code> la fonction
         * renverra toujours le contenu du cache en priorité.
         * </p>
         * <p>
         * La fonction <code>getClassMetas</code> ne renvoie que les metadonnées de l'instance
         * ou de la classe, et donc pas celles issues des classes dont elle hérite.
         * Pour récupérer toutes les metadonnées de l'instance ou de la classe, ainsi que de son héritage
         * il est nécessaire d'utiliser la méthode <code>getClassAndAncestorMetas</code>.
         * </p>
         *
         * @param	o			instance ou classe dont on souhaite obtenir les metadonnées
         * @param	useCache	[optionnel] si <code>true</code> la fonction sauvegardera
         * 						le résultat dans le cache.
         * @return	un objet <code>XMLList</code> contenant la description des balises de
         * 			metadonnées compilées avec la classe ou l'instance
         * @see #getClassAndAncestorMetas()
         */
		static public function getClassMetas ( o : *, useCache : Boolean = true ) : XMLList
		{
			if( _metasCache[ o ] )
				return _metasCache[ o ];
			else
			{
				var xml : XML = describeClass(o);
				if( xml.@isStatic == "false" )
				{
					if( useCache )
						return _metasCache[ o ] = xml.metadata;
					else
						return xml.metadata;
				}
				else
				{
					if( useCache )						return _metasCache[ o ] = xml.factory.metadata;
					else
						return xml.factory.metadata;
				}
			}
		}
		/**
		 * Renvoie un objet <code>XMLList</code> contenant la description des balises de
		 * metadonnées de l'instance ou de la classe, et dont le nom est <code>meta</code>.
		 * <p>
		 * Le paramètre <code>useCache</code> définit si le résultat de l'appel à
         * <code>getClassMetas</code> (utilisée en interne) doit être stocké
         * dans le cache ou non.
         * Que ce paramètre soit <code>true</code> ou <code>false</code> la fonction
         * utilisera toujours le contenu du cache en priorité.
		 * </p>
		 * <p>
         * La fonction <code>getClassMeta</code> ne renvoie que les metadonnées de l'instance
         * ou de la classe, et donc pas celles issues des classes dont elle hérite.
         * Pour récupérer toutes les metadonnées de l'instance ou de la classe, ainsi que de son héritage
         * il est nécessaire d'utiliser la méthode <code>getClassAndAncestorMeta</code>.
         * </p>
		 *
		 * @param	o			instance ou classe dont on souhaite obtenir les metadonnées
		 * @param	meta		le nom des balises de metadonnées que l'on souhaite récupérer
		 * @param	useCache	[optionnel] si <code>true</code> la fonction sauvegardera
         * 						le résultat dans le cache. Le résultat stocké est le résultat
         * 						de l'appel à <code>getClassMetas</code> effectué en interne.
		 * @return	un objet <code>XMLList</code> contenant la description des balises de
		 * 			metadonnées de l'instance ou de la classe, et dont le nom est <code>meta</code>
		 * @see #getClassAndAncestorMeta()
		 */
		static public function getClassMeta ( o : *, meta : String, useCache : Boolean = true ) : XMLList
		{
			return getClassMetas( o, useCache ).(@name==meta);
		}
		/**
		 * Renvoie un objet <code>XMLList</code> contenant la description des balises
         * de metadonnées compilées avec la classe ou l'instance ainsi que dans les
         * classes dont elle hérite.
         * <p>
         * Les metadonnées sont renvoyées dans l'ordre inverse de leur définition. Ainsi,
         * si on récupère les metadonnées d'une classe C, héritant de la classe B, elle même héritant
         * de la classe A, les metadonnées apparaitront dans l'ordre suivant :
         * </p>
         * <listing>
         * metadonnées classe C
         * metadonnées classe B
         * metadonnées classe A</listing>
         * <p>
         * Ceci garantit qu'en cas de surcharge des metadonnées d'une classe la première balise rencontrée
         * dans l'objet <code>XMLList</code> soit toujours la plus récente.
		 * </p>
		 *
		 * @param	o			instance ou classe dont on souhaite obtenir les metadonnées
		 * @param	useCache	[optionnel] si <code>true</code> la fonction sauvegardera
         * 						le résultat dans le cache. Le résultat stocké est le résultat
         * 						de l'appel à <code>getClassMetas</code> effectué en interne.
		 * @return	un objet <code>XMLList</code> contenant la description des balises de
         * 			metadonnées compilées avec la classe ou l'instance ainsi que dans les classes
         * 			dont elle hérite
		 * @see #getClassMetas()
		 */
		static public function getClassAndAncestorMetas ( o : *, useCache : Boolean = true ) : XMLList
		{
			var x : XML;

			var metas : XMLList = getClassMetas( o, useCache );
			/*
			var implementedInterfaces : XMLList = describeClass( o, useCache ).implementsInterface;
			for each( x in implementedInterfaces )
				metas = getClassMetas( getDefinitionByName( x.@type ), useCache ) + metas;
			*/

			var extendedClasses : XMLList = describeClass( o, useCache ).extendsClass;
			for each( x in extendedClasses )
				metas = getClassMetas( getDefinitionByName( x.@type ), useCache ) + metas;

			return metas;
		}
		/**
		 *  Renvoie un objet <code>XMLList</code> contenant la description des balises
         * de metadonnées compilées avec la classe ou l'instance ainsi que dans les
         * classes dont elle hérite et dont le nom est <code>meta</code>.
         * <p>
         * Les metadonnées sont renvoyées dans l'ordre inverse de leur définition. Ainsi,
         * si on récupère les metadonnées d'une classe C, héritant de la classe B, elle même héritant
         * de la classe A, les metadonnées apparaitront dans l'ordre suivant :
         * </p>
         * <listing>
         * metadonnées classe C
         * metadonnées classe B
         * metadonnées classe A</listing>
         * <p>
         * Ceci garantit qu'en cas de surcharge des metadonnées d'une classe la première balise rencontrée
         * dans l'objet <code>XMLList</code> soit toujours la plus récente.
		 * </p>
		 *
		 * @param	o			instance ou classe dont on souhaite obtenir les metadonnées
		 * @param	meta		le nom des balises de metadonnées que l'on souhaite récupérer
		 * @param	useCache	[optionnel] si <code>true</code> la fonction sauvegardera
         * 						le résultat dans le cache. Le résultat stocké est le résultat
         * 						de l'appel à <code>getClassMetas</code> effectué en interne.
		 * @return	un objet <code>XMLList</code> contenant la description des balises de metadonnées
		 * 			dont le type est <code>meta</code> compilées avec la classe ou l'instance ainsi que
		 * 			dans les classes dont elle hérite
		 * @see #getClassMeta()
		 */
		static public function getClassAndAncestorMeta ( o : *, meta:String, useCache : Boolean = true ) : XMLList
		{
			return getClassAndAncestorMetas( o, useCache ).(@name==meta);
		}
		/**
		 * Renvoie un objet <code>XMLList</code> contenant la description des membres de l'objet,
		 * ou de la classe, ayant des metadonnées associées. Les membres concernés sont aussi
		 * bien les propriétés, propriétés virtuelles (get/set) que les méthodes.
		 * <p>
		 * La fonction renvoie directement les balises des membres telles que renvoyées par la fonction
		 * <code>flash.utils.describeType</code> c'est-à-dire sous la forme :
		 * </p>
		 * <listing>
		 * &lt;[member type] ...&gt;
		 * 	&lt;metadata ...&gt;...&lt;/metadata&gt;
		 * &lt;/[member type]&gt;</listing>
		 *
		 * @param	o			instance ou classe dont on souhaite obtenir les membres
		 * 						possédant des metadonnées
		 * @param	useCache	[optionnel] si <code>true</code> la fonction sauvegardera
         * 						le résultat dans le cache. Le résultat stocké est le résultat
         * 						de l'appel à <code>describeClass</code> effectué en interne.
		 * @return	un objet <code>XMLList</code> contenant la description des membres de l'objet,
		 * 			ou de la classe, ayant des metadonnées associées
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/package.html#describeType() describeType()
		 */
		static public function getClassMembersWithMetas ( o : *, useCache : Boolean = true ) : XMLList
		{
			var xml : XML = describeClass( o, useCache );
			var xl : XMLList = xml..method + xml..variable + xml..accessor;
			var xl2 : XMLList = new XMLList();
			for each( var x : XML in xl )
			{
				if( x.hasOwnProperty( "metadata" ) )
					xl2 += x;
			}
			return xl2;
		}
		/**
		 * Renvoie un objet <code>XMLList</code> contenant la description des membres de l'objet,
		 * ou de la classe, ayant des metadonnées associées et dont le nom est <code>meta</code>.
		 * Les membres concernés sont aussi bien les propriétés, propriétés virtuelles (get/set)
		 * que les méthodes.
		 * <p>
		 * La fonction renvoie directement les balises des membres telles que renvoyées par la fonction
		 * <code>flash.utils.describeType</code> c'est-à-dire sous la forme :
		 * </p>
		 * <listing>
		 * &lt;[member type] ...&gt;
		 * 	&lt;metadata ...&gt;...&lt;/metadata&gt;
		 * &lt;/[member type]&gt;</listing>
		 *
		 * @param	o			instance ou classe dont on souhaite obtenir les membres
		 * 						possédant des metadonnées dont le nom est <code>meta</code>
		 * @param	meta		le nom des balises de metadonnées que l'on souhaite récupérer
		 * @param	useCache	[optionnel] si <code>true</code> la fonction sauvegardera
         * 						le résultat dans le cache. Le résultat stocké est le résultat
         * 						de l'appel à <code>describeClass</code> effectué en interne.
		 * @return	un objet <code>XMLList</code> contenant la description des membres de l'objet,
		 * 			ou de la classe, ayant des metadonnées associées et dont le nom est <code>meta</code>
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/package.html#describeType() describeType()
		 */
		static public function getClassMembersWithMeta ( o : *, meta : String, useCache : Boolean = false) : XMLList
		{
			return getClassMembersWithMetas( o, useCache ).(metadata.@name==meta);
		}
		/**
		 * Renvoie un objet <code>XMLList</code> contenant les descriptions
		 * des membres publiques de l'objet <code>o</code>.
		 *
		 * @param	o	objet pour lequel on souhaite récupérer les membres
		 * 				publiques
		 * @return	un objet <code>XMLList</code> contenant les descriptions
		 * 			des membres publiques de l'objet <code>o</code>
		 */
		static public function getPublicMembers (o : Object) : XMLList
		{
			var xml : XML = Reflection.describeClass(o);
			return xml..variable + xml..accessor;
		}
		/**
		 * Renvoie le résultat de l'évaluation de la chaîne <code>query</code>.
		 *
		 * @param	query	<code>String</code> à évaluer selon les règles ci-dessus.
		 * @param	domain	[optionnel] un objet <code>ApplicationDomain</code> utilisé pour
		 * 					récupérer les références aux classes demandées.
		 * @return	le résultat de l'évaluation selon les règles décrites ci-dessous.
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/package.html#getQualifiedClassName() getQualifiedClassName()
		 * @example
		 * <p>
		 * La chaîne <code>query</code> peut prendre les formes suivantes :
		 * </p>
		 * <table class="innertable" >
		 * <tr><th>Littéral</th><th>&#xA0;</th></tr>
		 * <tr>
		 * 		<td><listing>10.5</listing></td>		 * 		<td>Renvoie un <code>Number</code> de valeur <code>10.5</code>.</td>
		 * </tr>
		 * <tr>
		 * 		<td><listing>10</listing></td>
		 * 		<td>Renvoie un <code>Number</code> de valeur <code>10</code>.</td>
		 * </tr>
		 * <tr><td><listing>0xff</listing></td><td>Renvoie un <code>uint</code> de valeur <code>255</code>.</td></tr>		 * <tr><td><listing>'foo'</listing>
		 * <listing>"foo"</listing></td><td>Renvoie une <code>String</code> contenant <code>foo</code>.</td></tr>		 * <tr><td><listing>true</listing></td><td>Renvoie un <code>Boolean</code> à <code>true</code>.</td></tr>		 * <tr><td><listing>/foo/gi</listing></td><td>Renvoie une <code>RegExp</code> validant une chaîne contenant <code>foo</code>.</td></tr>
		 * <tr><td><listing>&lt;foo&gt;bar&lt;b&gt;rab&lt;/b&gt;&lt;/foo&gt;</listing></td><td>Renvoie un objet <code>XML</code> correspondant à la structure fournie
		 * en argument.</td></tr>
		 * <tr><th>Classes, propriétés et méthodes</th><th>&#xA0;</th></tr>		 * <tr><td><listing>Array</listing></td><td>Renvoie une référence vers la classe <code>Array</code>.</td></tr>		 * <tr><td><listing>Array.prototype</listing></td><td>Renvoie la valeur de la propriété <code>prototype</code> de la classe <code>Array</code>.</td></tr>		 * <tr><td><listing>flash.net::URLRequest</listing></td><td>Renvoie une référence à la classe <code>URLRequest</code> du package <code>flash.net</code>.
		 * La syntaxe utilisée ici est la même que celle utilisée dans la valeur retournée par la fonction
		 * <code>flash.utils.getQualifiedClassName</code>. Ainsi, ce genre de chose est possible :
		 * <listing>var objClass : Class = Reflection.get( getQualifiedClassName( unObjet ) );</listing></td></tr>		 * <tr><td><listing>flash.geom::Point.interpolate</listing></td><td>Renvoie une référence à la fonction <code>interpolate</code> de la classe <code>Point</code>.</td></tr>		 * <tr><td><listing>flash.utils::getTimer()</listing></td><td>Renvoie le résultat de l'appel à la fonction <code>getTimer</code>.</td></tr>		 * <tr><td><listing>aesia.com.mon.utils::Color.Black.alphaClone( 0x66 )</listing></td><td>Renvoie un clone partiellement transparent de la constante <code>Black</code>
		 * de la classe<code>Color</code>.</td></tr>		 * <tr><td><listing>aesia.com.mon.utils::Color.Black.alphaClone( 0x66 )
		 *                                 .interpolate( aesia.com.mon.utils::Color.Red,
		 *                                               0.5 )</listing></td><td>Renvoie un clone partiellement transparent de la constante <code>Black</code> mélangé à 50%
		 * avec la constante <code>Red</code>.</td></tr>
		 * <tr><th>Instanciation</th><th>&#xA0;</th></tr>		 * <tr><td><listing>new Array()</listing></td><td>Renvoie une nouvelle instance de la classe <code>Array</code>.</td></tr>		 * <tr><td><listing>new flash.geom::Point(5,5)</listing></td><td>Renvoie une nouvelle instance de la classe <code>Point</code>
		 * intialisée avec les valeurs <code>x = 5</code> et <code>y = 5</code>.</td></tr>		 * <tr><td><listing>new my.package::MyClass( new flash.geom::Point(2,2), new aesia.com.mon.utils::Color.Red )</listing></td><td>Renvoie une nouvelle instance de la classe <code>MyClass</code>
		 * intialisée avec une nouvelle instance de la classe <code>Point</code>
		 * ainsi qu'une couleur constante de la classe <code>Color</code>.</td></tr>		 * <tr><th>Tableaux</th></tr>		 * <tr><td><listing>[5,'foo',true]</listing>		 * <listing>(5,'foo',true)</listing>
		 * <listing>5,'foo',true</listing></td><td>Renvoie un <code>Array</code> contenant le nombre 5, la chaîne 'foo'		 * et le booleén <code>true</code>.</td></tr>
		 * <tr><td><listing>[[0,0,0],[0,0,0],[0,0,0]]</listing></td><td>Renvoie un tableau à deux dimensions, de dimensions 3x3 avec		 * <code>0</code> dans chaque case.</td></tr>
		 *
		 * <tr><th>Raccourcis</th></tr>
		 *		 * <tr><td><listing>color(255,255,255,100)</listing>
		 * <listing>color(0xffff0000)</listing></td><td>Renvoie un nouvel objet <code>Color</code> construit à partir des arguments fournis.</td></tr>		 * <tr><td><listing>color(Red)</listing>
		 * <listing>color(Maroon)</listing></td><td>Renvoie une référence vers une couleur enregistrée dans la classe <code>Color</code>.
		 * Si aucune couleur n'existe à ce nom, la fonction renvoie <code>null</code>.</td></tr>		 * <tr><td><listing>gradient( [ color( Red ), color( Black ) ],[ 0, 1 ] )</listing></td><td>Renvoie un objet <code>Gradient</code> avec les couleurs <code>Red</code> et <code>Black</code>
		 * à chaque extrémité.</td></tr>
		 *		 * <tr><td><listing>&#64;'http://foo.com'</listing>
		 * <listing>&#64;'http://foo.com/folder'</listing>
		 * <listing>&#64;'http://subdomain.foo.com/folder'</listing>
		 * <listing>&#64;'http://subdomain.foo.com/folder/file.foo'</listing>
		 * <listing>&#64;'file:///media/disk/folder/file.foo'</listing>
		 * <listing>&#64;'localfile.foo'</listing>
		 * <listing>&#64;'../src/localfile.foo'</listing></td><td>Renvoie un objet <code>URLRequest</code> pointant vers l'adresse correspondante. </td></tr>		 * </table>
		 */
		static public function get ( query : String, domain : ApplicationDomain = null ) : *
		{
			if( !query || StringUtils.trim(query) == "" )
				return null;

			return parseGroup( query, domain ? domain : ApplicationDomain.currentDomain );
		}
        /**
         * Fonction utilisée pour traiter les arguments dans le cas d'un appel de fonction ou
         * d'une instanciation. La différence avec la fonction <code>get</code> est que la fonction
         * <code>parseArguments</code> force un retour sous forme de tableau.
         * <p>
         * Un cas particulier se pose lorsque l'on souhaite transmettre un tableau comme unique argument
         * à une fonction. En effet, les règles d'évaluation retourne le même résultat pour une chaîne tel que
         * <code>foo( a,b,c )</code> que pour <code>foo( [a,b,c] )</code>. Pour forcer la transmission d'un seul
         * tableau en argument il s'agit de doubler la déclaration de groupe, soit <code>foo( [[a,b,c]] )</code>
         * </p>
         * @param	s		<code>String</code> à évaluer
		 * @param	domain	[optionnel] un objet <code>ApplicationDomain</code> utilisé pour
		 * 					récupérer les références aux classes demandées.
		 * @return	le résultat de l'évaluation
         */
        static public function parseArguments ( s : String, domain : ApplicationDomain = null ) : Array
		{
			if( !s || StringUtils.trim(s) == "" )
				return [];

			var res : * = parseGroup( s, domain ? domain : ApplicationDomain.currentDomain );

			return res is Array ? res : [ res ];
		}
		/**
		 * Renvoie une nouvelle instance de la classe <code>clazz</code> construite avec les
		 * arguments <code>args</code>.
		 * <p>
		 * ActionScript 3 ne permettant pas d'obtenir une référence à la fonction constructeur
		 * d'un objet, il est impossible d'utiliser les méthodes <code>call</code> et <code>apply</code>
		 * de la classe <code>Function</code> pour créer dynamiquement un objet.
		 * </p>
		 * <p>
		 * En conséquence, la fonction <code>buildInstance</code> utilise en interne une série de 30
		 * fonctions, chargées d'instancier à chaque fois un objet avec un nombre déterminé d'arguments.
		 * La fonction concrète à utiliser sera déterminé à partir du nombre d'élément contenu dans le tableau
		 * <code>args</code>.
		 * </p>
		 *
		 * @param	clazz	la classe dont on souhaite créer une instance
		 * @param	args	les arguments à transmettre au constructeur
		 * @return	une nouvelle instance de la classe <code>clazz</code> construite avec les
		 * 			arguments <code>args</code>
		 * @throws IllegalOperationError La classe ne peut être instancié avec les arguments transmis.
		 */
        static public function buildInstance( clazz : Class, args : Array = null ) : Object
        {
        	try
        	{
                var f : Function = _A[ args ? args.length : 0 ];
                var _args : Array = [clazz];
                if ( args ) _args = _args.concat( args );
                return f.apply( null, _args );
        	}
        	catch( e : Error )
        	{
        		throw new IllegalOperationError( "Can't instanciate the class '" + clazz + "' with arguments '[" + args + "]'" );
        	}
        	return null;
        }
		/*-------------------------------------------------------------------------------*
		 * 	BLACK MAGIC START HERE...
		 *-------------------------------------------------------------------------------*/
		/*
		 * Parse les groupes et tableaux, en faisant appel à la fonction splitBlock. Puis
		 * traite récursivement chaque instructions selon qu'il s'agisse de sous groupe ou d'éléments
		 * atomique.
		 */
        static private function parseGroup( element:*, domain : ApplicationDomain ) : *
		{
			var rtn : *;
			var s : String = StringUtils.trim( element.toString() );
			var instructions : Array = StringUtils.splitBlock( s );
			var l : uint = instructions.length;
			var i : uint = 0;
			var instruction : String;
			var instructionFirstChar : String;
			var hasManyTopLevelInstructions : Boolean = l > 1;
			if( hasManyTopLevelInstructions )
			{
				rtn = [];
				for( i = 0 ; i < l ; i++ )
				{
					instruction = instructions[ i ];
					instructionFirstChar = instruction.substr( 0, 1 );
					if( instructionFirstChar == "(" ||
						instructionFirstChar == "[" )
						rtn.push( parseGroup( instruction.substr( 1, instruction.length - 2 ), domain ) );
					else
						rtn.push( parseAtomic( instruction, domain ) );
				}
			}
			else
			{
				instruction = instructions[ 0 ];
				instructionFirstChar = instruction.substr( 0, 1 );
				if( instructionFirstChar == "(" ||
					instructionFirstChar == "[" )
				{
					var instructContent : String = instruction.substr( 1, instruction.length - 2 );
					if( instructContent.length == 0)
						return [];
					else
						return [parseGroup( instructContent, domain )];
				}
				else
					return parseAtomic( instruction, domain );
			}
			return rtn;
		}
		/*
		 * Traite une instruction solitaire et renvoie le résultat du traitement.
		 */
		static private function parseAtomic ( s : String, domain : ApplicationDomain ) : *
		{
			s = StringUtils.trim( s );

			var numval : Number;
			var res : Array;

			// An url as @'the url'
			if( s.search( new RegExp("^@(\"|')(.*)(\"|')$","gi") ) != -1 )
				return new URLRequest( s.substring( 2, s.length - 3 ) );
			// A regexp such /regexp/flags
			else if( ( res = new RegExp("^/(.*)/([gimsx]+)?$","gi").exec( s ) ) )
				return new RegExp( res[1], res[2] );
			// A string wrapped in ' or "
			else if( s.search( new RegExp("^(\"|')(.*)(\"|')$", "gi") ) != -1 )
				return s.substring( 1, s.length - 1 );
			// a color with r, g, b, a or 0xaarrggbb
			else if( s.indexOf("color(") == 0 )
			{
				var ar : Array = [];
				if( ( ar = (/color\(([^\d]+)\)/gi).exec( s ) ) != null )
					s = s.replace( ar[0], "aesia.com.mon.utils::Color.get( '"+ StringUtils.trim( ar[ 1 ] ) + "' )" );
				else					s = s.replace( "color(", "new aesia.com.mon.utils::Color(" );
			}
			// a gradient
			else if( s.indexOf("gradient(") == 0 )
				s = s.replace( "gradient(", "new aesia.com.mon.utils::Gradient(" );
			// An uint with 0x... notation
			else if( s.indexOf("0x") != -1 )				numval = parseInt( s );
			// Else we force an evaluation as float
			else if( s.indexOf("<") ==0 )
				return new XML( s );
			else
			{
				var bb : Boolean = false;
				for ( var i : String in _customShortcuts )
				{
					if( s.indexOf(i) == 0 )
					{
						s = s.replace( i, _customShortcuts[i] );
						bb = true;
					}
				}

				if( !bb )
					numval = parseFloat( s );
			}

			// Numval is NaN and we haven't return yet -> keywords or magic eval
			if( isNaN( numval ) )
			{
				// Looking for null
				if( s == "null" )
					return null;
				// Looking for boolean
				else if( s == "false" || s == "true" )
					return s == "true";
				// We look an object creation, a property access or a function call
				else
				{
					try
					{
						var isNewInstance : Boolean = false;
						var a : Array;
						var b : Array;
						var o : *;

						// checking for the new keyword, special case for object creation
						// the 'new' keyword is then removed from the request
						if( s.indexOf("new ") != -1 )
						{
							isNewInstance = true;
							s = s.substr( 4 );
						}

						var indent : int = 1;
						var sep: int = s.indexOf("::");

			        	if( sep != -1 )
			        		a = [ s.substr( 0, sep ), b = StringUtils.splitBlock( s.substr( sep + 2 ), "." ) ];
						else
							a = [s], b = StringUtils.splitBlock( s, "." );


						if( b.length > 0 )
							while(b.length)
							{
								var sm : String = StringUtils.trim( b.shift() );
								var p : int;
								if( ( p = sm.indexOf("(") ) != -1 )
								{
									var m : String = StringUtils.trim( sm.substr(0,p) );
									var am : String = sm.substr( p + 1, sm.length - p - 2 );
									var args : Array = parseArguments( am );

									//
									if( !o )
									{
										if( a.length > 1 )
											o = domain.getDefinition( a[0] + "::" + m );
										else
											o = domain.getDefinition( m );
									}
									else
									{
										o = o[ m ];
									}

									// on appelle la fonction avec ou sans argument selon les cas
									if( o is Function )
										if( args )
											o = ( o as Function ).apply( o, args );
										else											o = ( o as Function ).apply( o );

									// on instancie la nouvelle instance
									else if( o is Class && isNewInstance )
										o = buildInstance( o as Class, args );
								}
								else
								{
									//
									if( !o )
									{
										if( a.length > 1 )
											o = domain.getDefinition( a[0] + "::" + sm );
										else
											o = domain.getDefinition( sm );
									}
									else
									{
										o = o[ sm ];
									}
								}
							}
						return o;
					}
					catch( e : Error )
					{
						// We consider all request that failed as a String, but we warn the user that it's not a recommended
						// practice
						if( WARN_UNWRAPPED_STRING )
							Log.warn("The request : '" + s + "' cannot be parsed, the request will be returned as a string. " +
									 "If that was your purpose, use '' to wrap your request as a string.\n" + e.message + "\n" + e.getStackTrace() );

						return String(s);
						/*
						e.message = "Can't provide to the request : " + s +
									//"\n" + sp +
									"\n" + e.message;
						throw e;*/
					}
				}
			}
			else
				return numval;
        }
		/*
		 * DYNAMIC INSTANCIATION
		 */
		/*
		 * Un tableau contenant les 31 fonctions d'instanciations prenant de 0 à 30 arguments.
		 * Les fonctions sont accessibles avec leur nombre d'arguments.
		 */
        static private const _A : Array = [ _build0, _build1, _build2, _build3, _build4, _build5, _build6, _build7, _build8, _build9,
        									_build10,_build11,_build12,_build13,_build14,_build15,_build16,_build17,_build18,_build19,
        									_build20,_build21,_build22,_build23,_build24,_build25,_build26,_build27,_build28,_build29,
        									_build30 ];
       /*
        * Les 31 fonction d'instanciations de 0 à 30 arguments
        */
        static private function _build0( clazz : Class ) : Object
        { return new clazz(); }
        static private function _build1( clazz : Class ,a1:* ) : Object
        { return new clazz( a1 ); }
        static private function _build2( clazz : Class ,a1:*,a2:* ) : Object
        { return new clazz( a1,a2 ); }
        static private function _build3( clazz : Class ,a1:*,a2:*,a3:* ) : Object
        { return new clazz( a1,a2,a3 ); }
        static private function _build4( clazz : Class ,a1:*,a2:*,a3:*,a4:* ) : Object
        { return new clazz( a1,a2,a3,a4 ); }
        static private function _build5( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5 ); }
        static private function _build6( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6 ); }
        static private function _build7( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7 ); }
        static private function _build8( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8 ); }
        static private function _build9( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9 ); }
        static private function _build10( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10 ); }
        static private function _build11( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11 ); }
        static private function _build12( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12 ); }
        static private function _build13( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13 ); }
        static private function _build14( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14 ); }
        static private function _build15( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15 ); }
        static private function _build16( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16 ); }
        static private function _build17( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17 ); }
        static private function _build18( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18 ); }
        static private function _build19( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19 ); }
        static private function _build20( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20 ); }
        static private function _build21( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21 ); }
        static private function _build22( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22 ); }
        static private function _build23( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23 ); }
        static private function _build24( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24 ); }
        static private function _build25( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25 ); }
        static private function _build26( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26 ); }
        static private function _build27( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27 ); }
        static private function _build28( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:*,a28:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28 ); }
        static private function _build29( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:*,a28:*,a29:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29 ); }
        static private function _build30( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:*,a28:*,a29:*,a30:* ) : Object
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30 ); }
	}
}
