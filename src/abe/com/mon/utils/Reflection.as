/**
 * @license
 */
package abe.com.mon.utils
{
	import abe.com.mon.closures.core.isA;
	import abe.com.mon.logs.Log;

	import flash.errors.IllegalOperationError;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * The <code>Reflection</code> class provides a set of methods to inspect objects
	 * and to evaluate strings.
	 * <fr>
	 * La classe utilitaire <code>Reflection</code> fournit un ensemble de méthodes
	 * permettant de récupérer nombre d'informations sur les objets et classes
	 * au sein d'un fichier SWF.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public class Reflection
	{
		/**
		 * Stores the qualified class name of the <code>Vector</code> class. 
		 * <fr>
		 * Le nom qualifié de la classe <code>Vector</code> afin de générer dynamiquement
		 * les vecteurs typés.
		 * </fr>
		 * @default	"Vector"
		 */
		/*FDT_IGNORE*/ TARGET::FLASH_10 
		static protected const VECTOR_CLASSNAME : String = getQualifiedClassName( Vector );
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		static protected const VECTOR_CLASSNAME : String = getQualifiedClassName( Vector );
		
		/**
		 * A <code>boolean</code> value that specify if the <code>get</code> method
		 * should send a warning if a passed-in string can't be evaluated and will be
		 * returned as a <code>String</code>. 
		 * <fr>
		 * Une valeur booléenne indiquant si la méthode <code>get</code> lance une
		 * alerte dans le cas où elle rencontrerait une chaîne ne pouvant être traitée et
		 * qui ne serait pas entourée de caractère <code>"</code> ou <code>'</code>.
		 * </fr>
		 * @default	true
		 */
		static public var WARN_UNWRAPPED_STRING : Boolean = true;
		/**
		 * The cache object which stores the results of the <code>describeClass</code>
		 * method.
		 * <fr>
		 * Un objet servant de cache pour les résultats des appels à
		 * la fonction <code>describeClass</code>.
		 * </fr>
		 * @default	{}
		 * @see #describeClass()
		 */
		static protected var _describeTypeCache : Object = {};
		/**
		 * Stores the keys of the <code>describleClass</code> cache. It allow
		 * to know the size of the current cache.
		 * <fr>
		 * Un tableau stockant les clés d'accès au cache afin d'en déterminer
		 * la taille.
		 * </fr>
		 * @default []
		 */		static protected var _describeTypeCacheKeys : Array = [];
		/**
		 * An integer which represent the maximum length for the <code>describeClass</code>
		 * cache.
		 * <fr>
		 * Un entier indiquant la limite maximum pour le nombre
		 * de description de classe stockées par la classe <code>Reflection</code>
		 * </fr>
		 * @default	50
		 */		static protected var _describeTypeCacheMaxLength : uint = 50;

		/**
		 * The cache object for the metas request performed using the different
		 * meta methods.
		 * <fr>
		 * Un objet servant de cache pour les résultats de requêtes
		 * sur les balises metas d'un objet ou d'une classe.
		 * </fr>
		 * @default	{}
		 * @see #getClassMeta()		 * @see #getClassMetas()
		 * @see #getClassAndAncestorMeta()		 * @see #getClassAndAncestorMetas()		 * @see #getClassMembersWithMeta()		 * @see #getClassMembersWithMetas()
		 */		static protected var _metasCache : Object = {};
		/**
		 * A <code>Dictionary</code> used to stores the custom shortcuts
		 * that apply to the <code>get</code> method.
		 * <fr>
		 * Un objet contenant les raccourcis spécifiques définit
		 * par l'utilisateur.
		 * </fr>
		 * @default new Dictionary()
		 */
		static protected var _customShortcuts : Dictionary = new Dictionary();
		/**
		 * Adds a custom shortcuts which will apply to all the next calls to the
		 * <code>get</code> method.
		 * <p>
		 * A shortcut is made up of two elements, the matcher, and the replacement.
		 * The matcher could be either a <code>String</code> or a <code>RegExp</code>
		 * object. The replacement can be any expression that can be used as the second
		 * argument for the <code>String.replace</code> method. 
		 * </p>
		 * <fr>
		 * Ajoute un raccourci définit par l'utilisateur pour être pris
		 * en compte dans la fonction <code>get</code>.
		 * <p>
		 * Un raccourci est en pratique un remplacement effectué par la fonction
		 * afin de déterminer la requête final à éxécuter.
		 * </p>
		 * </fr>
		 * @param	s			either a <code>String</code> or a <code>RegExp</code> object		
		 * 						<fr>la chaîne de caractère à replacer</fr>
		 * @param	replacement	any expression that can be used as the second
		 * 						argument for the <code>String.replace</code> method
		 * 						<fr>la valeur de remplacement</fr>
		 * @example For example, the native <code>gradient</code> shortcuts can be defined as below : 
		 * <fr>Le raccourci natif <code>gradient</code> pourrait être définit de la manière suivante :</fr>
		 * <listing>Reflection.addCustomShortcuts("gradient(", "new abe.com.mon.utils::Gradient(");</listing>
		 */
		static public function addCustomShortcuts ( s : *, replacement : * ) : void
		{
			_customShortcuts [ s ] = replacement;
		}
		/**
		 * Removes a previously added custom shortcuts.
		 * 
		 * @param	s	the matcher object used to define the shortcuts
		 * @return	the results of the <code>delete</code> operation 
		 */
		static public function removeCustomShortcuts( s : * ) : Boolean
		{
			return delete _customShortcuts [ s ];
		}
		
		/**
		 * Returns a reference to a typed vector class definition corresponding
		 * to the passed-in <code>Class</code>.
		 * <fr>
		 * Renvoie une référence vers une classe <code>Vector</code> dont le
		 * type des éléments est <code>clazz</code>.
		 * </fr>
		 * @param	clazz				the type of the vector's elements
		 * 								<fr>le type des éléments du vecteur</fr>
		 * @param	applicationDomain	an optional domain to retreive the class definition
		 * 								<fr>[optionnel] le domaine d'application permettant
		 * 								d'accéder à la classe <code>Vector</code> typée</fr>
		 * @return	a reference to a typed vector class definition corresponding
		 * 			to the passed-in <code>Class</code>
		 * 			<fr>une référence vers une classe <code>Vector</code> dont le
		 * 			type des éléments est <code>clazz</code></fr>
		 */
		/*FDT_IGNORE*/ 
		TARGET::FLASH_10
		static public function getVectorDefinition( clazz:Class , applicationDomain:ApplicationDomain = null ):Class
        {
            if ( clazz == null )
                return null ;
                
            if( applicationDomain == null )
                applicationDomain = ApplicationDomain.currentDomain ;
            
            return applicationDomain.getDefinition( VECTOR_CLASSNAME + '.<' + getQualifiedClassName( clazz ) +'>' ) as Class;
        }
        TARGET::FLASH_10_1 /*FDT_IGNORE*/
		static public function getVectorDefinition( clazz:Class , applicationDomain:ApplicationDomain = null ):Class
        {
            if ( clazz == null )
                return null ;
              
            if( applicationDomain == null )
                applicationDomain = ApplicationDomain.currentDomain ;
            return applicationDomain.getDefinition( VECTOR_CLASSNAME + '.<' + getQualifiedClassName( clazz ) +'>' ) as Class;
        }
		/**
		 * Returns a reference to the class of the object <code>o</code>.
		 * <fr>
		 * Renvoie une référence vers la classe de l'objet <code>o</code> passé en argument.
		 * </fr>
		 * @param	o		the object for which retreiving its class
		 * 					<fr>l'objet dont on souhaite récupérer la classe</fr>
		 * @param	domain	an optional domain to retreive the class definition
		 * 					<fr>[optionnel] le domaine d'application permettant
		 * 					d'accéder à la classe <code>Vector</code> typée</fr>
		 * @return	a reference to the class of <code>o</code> 
		 * 			<fr>une référence vers la classe de <code>o</code></fr>
		 */
		static public function getClass( o : Object, domain : ApplicationDomain = null ) : Class
        {
        	if( o == null )
        		return null;
        	
        	var s : String = getQualifiedClassName(o);
        	
        	if( s == null )
        		return null;
        	return ( domain ? domain : ApplicationDomain.currentDomain ).getDefinition( s ) as Class;
        }
        /**
		 * Renvoie le nom de la classe de <code>v</code> sans le chemin
		 * du package auquel elle appartient
		 *
		 * @param	v	objet dont on souhaite récupérer le nom de la classe
		 * @return	le nom de la classe
		 * @example	<listing>trace( Reflection.extractClassName( new Point() ) ); // output : Point</listing>
		 */
		static public function getClassName ( v : * ) : String
		{
			var a : Array = getQualifiedClassName ( v ).split ( "::" );
			var s : String = a.length > 1 ? a.slice(1).join("::") : a[0];
			if( s.indexOf( "<")!= -1 )
				s = s.substr(0, s.indexOf("<")+1) + s.substr(s.indexOf("::") + 2);
			
			return s;
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
			var cls : String = getQualifiedClassName(o);
			if( _describeTypeCache[ cls ] )
				return _describeTypeCache[ cls ];
			else
			{
				if( useCache )
				{
					if( _describeTypeCacheKeys.length + 1 > _describeTypeCacheMaxLength )
					{
						delete _describeTypeCache[ _describeTypeCacheKeys.shift() ];
					}
					_describeTypeCacheKeys.push( String(cls) );
					return _describeTypeCache[ cls ] = describeType( o );
				}
				else
					return describeType( o );
			}
		}
		public static function isObject ( o : * ) : Boolean 
		{
			return getClass(o) == Object;
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
			var list : XMLList = getClassMembersWithMetas( o, useCache );
			var rtn : XMLList = new XMLList();
			for each( var x : XML in list )
			{
				var emptyClone : XML = x.copy();
				
				delete emptyClone.*;
				
				for each ( var m : XML in x.children() )
					if( m.@name == meta ) 
						emptyClone.appendChild( m );
				
				if( emptyClone.children().length() > 0 )
					rtn += new XMLList ( emptyClone );
			}
			return rtn;
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
		 * 
		 */
		static public function asAnonymousObject( o : Object, allowReadOnly : Boolean = true ) : Object
		{
			var members : XMLList = getPublicMembers(o);
			
			var res : Object = {};
			for each( var x : XML in members )
			{
				if( o.hasOwnProperty(x.@name) && x.@access != "writeonly" && ( allowReadOnly || x.@access != "readonly" ) )
					res[x.@name] = o[x.@name];
			}
			return res;
		}
		/**
		 * Returns the result of the evaluation of the string <code>query</code>.
		 * <p>
		 * The evaluation process first separates the blocks by level. For instance, 
		 * a string looking like <code>'a, b(c,d), e'</code> will be split in three expressions
		 * <code>'a'</code>, <code>'b(c,d)'</code> and <code>'e'</code>. Then each expression will
		 * be evaluated as well, and the block split will be performed recursively.
		 * </p>
		 * <p>
		 * The block split is realized using the <code>StringUtils.splitBlock()</code>
		 * method, which ensure that nested blocks are preserved when the split occurs.
		 * </p>
		 * @param	query	<code>String</code> to be evaluated according to the rules below
		 * @param	domain	an <code>ApplicationDomain</code> used to retrieve
		 * 					references to the requested classes
		 * @return	the result of the evaluation according to the rules described below
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/utils/package.html#getQualifiedClassName() getQualifiedClassName()
		 * 
		 * @example <p>The <code>query</code> string can take the following forms:</p> 
		 * <table class="innertable">
		 * <tr><th>Literal</th><th>&#xA0;</th></tr>
		 * <tr><td><listing>10.5</listing></td>
		 * 	   <td>Returns a <code>Number</code> with a value of <code>10.5</code>.</td></tr>
		 * 
		 * <tr><td><listing>10</listing></td>
		 * 	   <td>Returns a <code>Number</code> with a value of <code>10</code>.</td></tr>
		 * 	
		 * <tr><td><listing>0xff</listing></td>
		 * 	   <td>Returns a <code>uint</code> with a value of <code>255</code>.</td></tr>
		 *
		 * <tr><td><listing>'foo'</listing>
		 * 		   <listing>"foo"</listing></td>
		 * 	   <td>Returns a <code>String</code> containing <code>foo</code>.</td></tr>
		 * 
		 * <tr><td><listing>true</listing></td>
		 * 	   <td>Returns a  <code>Boolean</code> value set to <code>true</code>.</td></tr>
		 * 	
		 * <tr><td><listing>/foo/gi</listing></td>
		 * 	   <td>Returns a <code>RegExp</code> to validate a string containing <code>foo</code>.</td></tr>
		 * 
		 * <tr><td><listing>&lt;foo&gt;bar&lt;b&gt;rab&lt;/b&gt;&lt;/foo&gt;</listing></td>
		 * 	   <td>Returns an <code>XML</code> object corresponding to the provided structure.</td></tr>
		 * 
		 * <tr><th>Classes, properties and methods</th><th>&#xA0;</th></tr>
		 * <tr><td><listing>Array</listing></td>
		 * 	   <td>Returns a reference to the class <code>Array</code>.</td></tr>
		 * 
		 * <tr><td><listing>Array.prototype</listing></td>
		 *     <td>Returns the value of the property <code>prototype</code> of the class <code>Array</code>.</td></tr>
		 * 
		 * <tr><td><listing>flash.net::URLRequest</listing></td>
		 * 	   <td>Returns a reference to the class <code>URLRequest</code> in the package <code>flash.net</code>.
		 * 	       The syntax used here is the same as the one used in the return of the function 
		 * 	       <code>flash.utils.getQualifiedClassName</code>. Thus, this kind of thing is possible: 
		 * 		   <listing>var objClass: Class = Reflection.get (getQualifiedClassName (anObject));</listing></td></tr>
		 * 
		 * <tr><td><listing>flash.geom::Point.interpolate</listing></td>
		 * 	   <td>Returns a reference to the <code>interpolate</code> method of the class <code>Point</code>.</td></tr>
		 * 
		 * <tr><td><listing>flash.utils::getTimer()</listing></td>
		 * 	   <td>Returns the result of the call to <code>getTimer</code>.</td></tr>
		 * 
		 * <tr><td><listing>abe.com.mon.colors::Color.Black.alphaClone (0x66)</listing></td>
		 * 	   <td>Returns a clone partially transparent of the constant <code>Black</code> from the class <code>Color</code>.</td></tr>
		 * 	 
		 * <tr><td><listing>abe.com.mon.colors::Color.Black.alphaClone (0x66)
		 * 	.interpolate (abe.com.mon.colors::Color.Red, 0.5)</listing></td>
		 * 	   <td>Returns a clone partially transparent of the constant <code>Black</code> blended with 50% of the constant <code>Red</code>.</td></tr>
		 * 
		 * <tr><th>Instantiation</th><th>&#xA0;</th></tr>
		 * <tr><td><listing>new Array ()</listing></td>
		 * 	   <td>Returns a new instance of the class <code>Array</code>.</td></tr>
		 * 
		 * <tr><td><listing>new flash.geom::Point (5.5)</listing>
		 * 	   </td><td>Returns a new instance of the class <code>Point</code> initialized with the values <code>x = 5</code> and <code>y = 5</code>.</td></tr>
		 * 
		 * <tr><td><listing>new my.package::MyClass ( 
		 * 	new flash.geom::Point(2,2), 
		 * 	abe.com.mon.colors::Color.Red )</listing></td>
		 *	   <td>Returns a new instance of class <code>MyClass</code> initialized with a new instance of the class <code>Point</code> and a constant from 
		 * 	  	   the class <code>Color</code>.</td></tr>
		 * 
		 * <tr><th>Arrays</th><th>&#xA0;</th></tr>
		 * <tr><td><listing>[5, 'foo', true]</listing>
		 * 		   <listing>(5, 'foo', true)</listing>
		 * 		   <listing>5, 'foo', true</listing></td>
		 * 	   <td>Returns an <code>Array</code> containing the number <code>5</code>, the string <code>'foo'</code> and the boolean <code>true</code>.</td></tr>
		 * 
		 * <tr><td><listing>[[0,0,0], [0,0,0], [0,0,0]]</listing></td>
		 * 	   <td>Returns an array with two dimensions, with size 3x3 and the value <code>0</code> in each slot.</td></tr>
		 * 
		 * <tr><th>Objects</th><th>&#xA0;</th></tr>
		 * <tr><td><listing>{'foo':15, 'bar':"foobar"}</listing></td>
		 * 	   <td>Returns an <code>Object</code> with two properties <code>foo</code> and <code>bar</code>.</td></tr>
		 * 	  
		 * <tr><td><listing>{'foo'}</listing></td>
		 * 	   <td>Returns an <code>Object</code> with the property <code>foo</code> set to <code>true</code>.</td></tr>
		 * 
		 * <tr><td><listing>{new flash.geom::Point:"A Point", 'foo':"bar"}</listing></td>
		 * 	   <td>Keys can be any expressions supported by the <code>get</code> method, but if the result of the evaluation
		 * 	   	  of one of the keys is not a <code>String</code>, a <code>Dictionary</code> is returned instead
		 * 	   	  of an <code>Object</code>. The choice between <code>Object</code> and <code>Dictionary</code> is
		 * 	   	  performed after all the evaluations, then, if an expression can't be evaluated and is returned as a
		 * 	   	  </code>String</code>, the function will return an <code>Object</code>, such as in the example below : 
		 * 	   	  <listing>{foo:25} // returns an Object with a property named 'foo'</listing></td></tr>
		 * 
		 * <tr><th>Shortcuts</th><th>&#xA0;</th></tr>
		 * <tr><td><listing>color (255,255,255,100)</listing>
		 * 		   <listing>color (0xFFFF0000)</listing></td>
		 * 	   <td>Returns a new object <code>Color</code> constructed from the supplied arguments.</td></tr>
		 * 
		 * <tr><td><listing>color (Red)</listing>
		 * 		   <listing>color (Maroon)</listing></td>
		 * 	   <td>Returns a reference to a color stored in the class <code>Color</code>. If there is no color with this name, 
		 * 	   	   the function returns <code>null</code>.</td></tr>
		 * 
		 * <tr><td><listing>gradient ([color (Red), color (Black)], [0, 1])</listing></td>
		 *	   <td>Returns a <code>Gradient</code> with the colors <code>Red</code> and <code>Black</code> at each extremity.</td></tr>
		 * 
		 * <tr><td><listing>&#64;'http://foo.com'</listing>
		 * 		   <listing>&#64;'http://foo.com/folder'</listing>
		 * 		   <listing>&#64;'http://subdomain.foo.com/folder'</listing>
		 * 		   <listing>&#64;'http://subdomain.foo.com/folder/file.foo'</listing>
		 * 		   <listing>&#64;'file:///media/disk/folder/file.foo'</listing>
		 * 		   <listing>&#64;'localfile.foo'</listing>
		 * 		   <listing>&#64;'../src/localfile.foo '</listing></td>
		 * 	  <td>Returns a <code>URLRequest</code> pointing to the corresponding address.</td></tr>
		 * </table>
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
         * 
         * @param	s		<code>String</code> à évaluer
		 * @param	domain	[optionnel] un objet <code>ApplicationDomain</code> utilisé pour
		 * 					récupérer les références aux classes demandées.
		 * @return	le résultat de l'évaluation
         */
        static public function parseArguments ( s : String, domain : ApplicationDomain = null ) : Array
		{
			if( !s || StringUtils.trim(s) == "" )
				return [];
			
			var res : *;
			var instructions : Array = StringUtils.splitBlock( s );
			var l : uint = instructions.length;
			var hasManyTopLevelInstructions : Boolean = l > 1;
			if( hasManyTopLevelInstructions )
				res = parseGroup( s, domain ? domain : ApplicationDomain.currentDomain );			else
				res = [parseGroup( s, domain ? domain : ApplicationDomain.currentDomain )];

			return /*res is Array ? res :*/ res;
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
					instruction = StringUtils.trim( instructions[ i ] );
					if( instruction.length == 0 )
					{
						if( i == l - 1 )
							break;
						else
						{
							rtn.push( null );
							continue;
						}
					}
					instructionFirstChar = instruction.substr( 0, 1 );
					if( instructionFirstChar == "{" )
						rtn.push( parseObject( instruction ) );
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
				if( instructionFirstChar == "{" )
					return parseObject( instruction );
				else if( instructionFirstChar == "(" ||
					instructionFirstChar == "[" )
				{
					var instructContent : String = instruction.substr( 1, instruction.length - 2 );
					if( instructContent.length == 0)
						return [];
					else
						return parseGroup( instructContent, domain );
				}
				else
					return parseAtomic( instruction, domain );
			}
			return rtn;
		}
		/*
		 * 
		 */
		static private function parseObject (instruction : String) : * 
		{
			var instructContent : String = instruction.substr( 1, instruction.length - 2 );
			var propertiesDeclarations : Array = StringUtils.splitBlock( instructContent );
			var property : String;
			var a : Array;
			var key : *;
			var value : *;
			var keys : Array = [];
			var values : Array = [];  
			var rtn : *;
			var l : uint;
			var i : uint;
			
			for each( property in propertiesDeclarations )
			{
				property = StringUtils.trim( property.replace("::", "<<PACKAGE_TOKEN>>") );
				
				if( property.length == 0 )
					continue;
				
				a = property.split(":");
				
				if( a[0].length == 0 )
					continue;
				
				key = Reflection.get( a[0].replace("<<PACKAGE_TOKEN>>", "::" ) );
				
				if( a.length == 1 )
					value = true;
				else 
				{
					if( a[1].length == 0 )
						continue;
					
					value = Reflection.get(a[1].replace("<<PACKAGE_TOKEN>>", "::" ) );
				}
				keys.push( key );				values.push( value );
			}
			if( keys.every( isA( String ) ) )
				rtn = new Object();
			else
				rtn = new Dictionary();
			
			l = keys.length;
			for( i = 0; i<l; i++ )
				rtn[ keys[i] ] = values[i];
			
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
			if( s.search( new RegExp("^@(\"|')(.*)(\"|')$","gi") ) == 0 )
				return new URLRequest( s.substring( 2, s.length - 1 ) );
			// A regexp such /regexp/flags
			else if( ( res = new RegExp("^/(.*)/([gimsx]+)?$","gi").exec( s ) ) )
				return new RegExp( res[1], res[2] );
			// A string wrapped in ' or "
			else if( s.search( new RegExp("^(\"|')(.*)(\"|')$", "gi") ) == 0 )
				return s.substring( 1, s.length - 1 );
			// a color with r, g, b, a or 0xaarrggbb
			else if( s.indexOf("color(") == 0 )
			{
				var ar : Array = [];
				if( ( ar = (/color\(([^\d]+)\)/gi).exec( s ) ) != null )
					s = s.replace( ar[0], "abe.com.mon.colors::Color.get( '"+ StringUtils.trim( ar[ 1 ] ) + "' )" );
				else					s = s.replace( "color(", "new abe.com.mon.colors::Color(" );
			}
			// a gradient
			else if( s.indexOf("gradient(") == 0 )
				s = s.replace( "gradient(", "new abe.com.mon.colors::Gradient(" );
			// 
			else if( s.indexOf("0x") == 0 )				numval = parseInt( s );
			// If is an XML string
			else if( s.indexOf("<") ==0 )
				return new XML( s );
			else
			{
				// handling custom shortcuts
				var bb : Boolean = false;
				for ( var i : * in _customShortcuts )
				{
					if( s.search(i) != -1 )
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
			        	{
							a = [s];
							b = StringUtils.splitBlock( s, "." );
			        	}

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

									if( !o )
									{
										if( a.length > 1 )
											o = domain.getDefinition( a[0] + "::" + m );
										else
											o = domain.getDefinition( m );
									}
									else
										o = o[ m ];
								
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
						s = isNewInstance ? "new " + s : s;
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
        { return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30 ); 
		}
	}
}
