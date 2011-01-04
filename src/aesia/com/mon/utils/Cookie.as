/**
 * @license
 */
package  aesia.com.mon.utils
{
	import aesia.com.mon.core.Clearable;

	import flash.net.SharedObject;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;
	/**
	 * Un objet <code>Cookie</code> fonctionne comme un proxy vers un <code>SharedObject</code>,
	 * la classe étant dynamique et étendant la classe <code>Proxy</code> tout les appels à une
	 * propriété sont en fait réalisé sur l'objet <code>SharedObject</code> utilisé en interne.
	 * 
	 * @author Cédric Néhémie
	 */
	dynamic public class Cookie extends Proxy implements Clearable
	{
		/**
		 * Constante pour le nom du champ d'enregistrement des noms de propriétés
		 * de cet objet <code>Cookie</code>.
		 */
		static public const PROPRETIES_TABLE_NAME : String = "PROPERTIES_TABLE";
		
		
		/*----------------------------------------------------
		 * 		CLASS MEMBERS
		 *---------------------------------------------------*/
		/*
		 * Map des instances par canaux
		 */
		static private var _instances : Object = {};
		/**
		 * Renvoie l'instance de la classe <code>Cookie</code> dédiée
		 * au canal <code>channel</code>.
		 * 
		 * @param	channel	canal pour lequel récupérer un cookie
		 * @return	le cookie correspondant au canal
		 */
		static public function getInstance( channel : String ) : Cookie
		{
			if( !_instances[ channel ] ) 
				_instances[ channel ] = new Cookie( channel );
			
			return _instances[ channel ];
		}
		/**
		 * Supprime l'instance pour le canal <code>channel</code>.
		 * 
		 * @param	channel	canal de l'instance à supprimer
		 */	
		static public function release( channel : String ) : void
		{
			delete _instances[ channel ];
		}
		/*----------------------------------------------------
		 * 		INSTANCE MEMBERS
		 *---------------------------------------------------*/
		/**
		 * Une chaîne représentant le canal de ce <code>Cookie</code>.
		 */
		protected var _channel : String;
		/**
		 * Une chaîne représentant le chemin local de ce <code>Cookie</code>.
		 */
		protected var _cookieLocalPath : String;
		/**
		 * Une valeur booléenne indiquant si ce <code>Cookie</code> est sécurisé.
		 */
		protected var _secured : Boolean;
		/**
		 * Une chaîne utilisée pour stocker les chemins successifs d'une requête sur
		 * le <code>cookie</code>.
		 */
		protected var _localPath : String;
		/**
		 * Une chaîne utilisée pour stocker le chemin racine pour ce <code>Cookie</code>
		 */		protected var _rootPath : String;
		/**
		 * Un tableau contenant la liste des propriétés définies pour ce <code>Cookie</code>.
		 */
		protected var _propertiesTable : Array;
		
		/**
		 * Constructeur de la classe <code>Cookie</code>.
		 * 
		 * @param	channel		canal d'accès pour le <code>SharedObject</code>
		 * @param	localPath	chemin d'accès pour le <code>SharedObject</code>
		 * @param	secure		une valeur booléenne indiquant si le cookie est sécurisé
		 */
		public function Cookie ( channel : String, localPath : String = "/", secure : Boolean = false )
		{
			_channel = channel;
			_cookieLocalPath = localPath;
			_secured = secure;
			
			_rootPath = "";
			_localPath = "";
			
			var o : String = this[ PROPRETIES_TABLE_NAME ];
			if( o )
				_propertiesTable = o.split(",");
			else
				_propertiesTable = [];
		}
		/**
		 * Récupère les appels fait à une fonction non définie et les utilise en tant
		 * qu'élément de construction d'un chemin complèxe.
		 * 
		 * @param 	methodName	nom de la méthode appelée, elle sera utilisée 
		 * 						comme élement de chemin
		 * @param	args		non utilisé
		 * @return	l'instance courante afin de permettre la multiplication des
		 * @example L'exemple suivant montre comment utilisé les appels à des méthodes
		 * afin de construire des chemins complexe : 
		 * <listing>var data : * = cookie.path1().path2().data;</listing>
		 * L'appel ci-dessus correspond à l'accès au chemin <code>path1.path2.data</code>
		 * dans le <code>SharedObject</code>.
		 */
		override flash_proxy function callProperty( methodName : *, ... args ) : *
		{
			appendLocalPath( methodName );
			return this;
		}
		/**
		 * Récupère les appels fait en lecture à des propriétés non définies et renvoie la valeur
		 * contenue dans le <code>SharedObject</code> à ce chemin.
		 * <p>
		 * Si des appels à des méthodes ont été faits avant l'appel à une propriété, les
		 * noms des méthodes sont utilisées afin de construire un chemin plus poussé.
		 * </p>
		 * @param	propertyName	nom de la propriété à récupérer sur le <code>SharedObject</code>
		 * @return	la valeur contenue dans la propriété correspondante du <code>SharedObject</code>
		 * @example	Accède à une propriété à la racine du cookie 
		 * <listing>var data : * = cookie.data;</listing>
		 * Accède à une propriété d'un sous-objets du cookie 		 * <listing>var data : * = cookie.object().data;</listing>
		 */
		override flash_proxy function getProperty( propertyName : * ) : *
		{
			var path : String = appendPath( propertyName );
			var content : * = __getSO().data[ path ];
			
			localPath = "";
	
			return content;
		}
		/**
		 * Récupère les appels fait en écritures à des propriétés non définies et affecte
		 * la valeur au chemin correspondant dans le <code>SharedObject</code>
		 * 
		 * @param propertyName	nom de la propriété à modifier
		 * @param value			nouvelle valeur pour cette propriété
		 * @example	Écrit dans une propriété à la racine du cookie 
		 * <listing>cookie.data = 50;</listing>
		 * Écrit dans une propriété d'un sous-objets du cookie 
		 * <listing>cookie.object().data = 50;</listing>
		 */		
		override flash_proxy function setProperty( propertyName : *, value : * ) : void
		{
			var save : SharedObject = __getSO();
			var path : String = appendPath( propertyName );
			save.data[ path ] = value;
			
			if( !isPathRegistered( path ) )
			{
				_propertiesTable.push( path );
				save.data[ PROPRETIES_TABLE_NAME ] = _propertiesTable.join();
			}
			localPath = "";
		}
		/**
		 * Supprime toutes les données contenues actuellement dans le <code>SharedObject</code>.
		 */
		public function clear() : void
		{
			__getSO().clear();
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne de caractères.
		 * 
		 * @return	la représentation de l'objet sous forme de chaîne de caractères
		 */
		public function toString() : String
		{
			return getQualifiedClassName( this );
		}
		/*-----------------------------------------------------------
		 * 		PROPERTIES TABLES MANAGEMENT
		 *-----------------------------------------------------------*/
		/**
		 * Renvoie un tableau contenant la liste des propriétés définie
		 * sur cet objet <code>Cookie</code>.
		 * 
		 * @return	un tableau contenant la liste des propriétés définie
		 * 			sur cet objet <code>Cookie</code>
		 */
		public function get propertiesTable () : Array
		{
			return _propertiesTable;
		}
		/**
		 * Renvoie <code>true</code> si le chemin <code>path</code>
		 * est définie sur ce <code>Cookie</code>.
		 * 
		 * @param	path	le chemin dont on souhaite savoir s'il existe
		 * @return	<code>true</code> si le chemin <code>path</code>
		 * 			est définie sur ce <code>Cookie</code>
		 */
		public function isPathRegistered ( path : String) : Boolean 
		{
			return  _propertiesTable.indexOf( path ) != -1;
		}
		/*-----------------------------------------------------------
		 * 		ROOT PATH MANAGEMENT
		 *-----------------------------------------------------------*/
		/**
		 * Une chaîne de caractère utilisée pour définir un chemin d'accès
		 * de base lors des accès à des propriétés du <code>Cookie</code>.
		 * 
		 * @example <listing>// on créer un cookie 
		 * var cookie : Cookie = new Cookie("channel");
		 * // on récupère une donnée à la racine
		 * var data : * = cookie.data;
		 * // on change la racine du cookie
		 * cookie.rootPath = "object.subobject";
		 * // on réaccède à une propriété
		 * // mais cette fois le chemin réel appelée est object.subobject.data
		 * var data2 : * = cookie.data;</listing>
		 */		
		public function get rootPath () : String { return _rootPath; }
		public function set rootPath ( path : String ) : void
		{
			_rootPath = path;
		}
		/**
		 * Renvoie <code>true</code> si un chemin racine a été défini.
		 * 
		 * @return	<code>true</code> si un chemin racine a été défini
		 */
		public function hasRootPath () : Boolean
		{
			return _rootPath != "";
		}
		/*-----------------------------------------------------------
		 * 		FINAL PATH MANAGEMENT
		 *-----------------------------------------------------------*/
		/**
		 * Une chaîne de caractère correspondant au chemin complet courant
		 * pour ce <code>Cookie</code>.
		 * <p>
		 * Le chemin complet est la combinaison du chemin racine et du 
		 * chemin local.
		 * </p>
		 */
		protected function get path () : String 
		{
			return 	hasRootPath() ? 
					rootPath + ( hasLocalPath() ? "." : "" ) + localPath :
				    localPath;
		}
		/**
		 * Renvoie <code>true</code> si ce <code>Cookie</code> possède
		 * un chemin d'accès.
		 * 
		 * @return	<code>true</code> si ce <code>Cookie</code> possède
		 * 			un chemin d'accès
		 */
		protected function hasPath () : Boolean 
		{
			return path != "";
		}
		/**
		 * Renvoie le chemin complet pour ce <code>Cookie</code>
		 * compléter avec la chaîne <code>path</code> transmise 
		 * en argument.
		 * 
		 * @param	path	chemin à ajouter au chemin courant
		 * @return	le chemin compléter avec la chaîne <code>path</code>
		 */
		protected function appendPath( path : String ) : String
		{
			return hasPath() ? this.path + "." + path : path;
		}
		
		/*-----------------------------------------------------------
		 * 		LOCAL PATH MANAGEMENT
		 *-----------------------------------------------------------*/
		/**
		 * Une référence vers le chemin local courant de ce <code>Cookie</code>.
		 * <p>
		 * Le chemin local courant est constitué à l'aide des appels de méthodes
		 * sur le <code>Cookie</code>.
		 * </p>
		 */
		protected function get localPath() : String { return _localPath; }
		protected function set localPath ( path : String ) : void
		{			
			_localPath = path;
		}	
		/**
		 * Renvoie <code>true</code> si le <code>Cookie</code> possède
		 * un chemin local courant.
		 * 
		 * @return	<code>true</code> si le <code>Cookie</code> possède
		 * 			un chemin local courant
		 */	
		protected function hasLocalPath () : Boolean
		{
			return _localPath != "";
		}
		/**
		 * Ajoute la chaîne <code>path</code> au chemin local courant.
		 * 
		 * @param	path	chemin à ajouter au chemin courant
		 */
		protected function appendLocalPath( path : String ) : void
		{
			if( hasLocalPath() )
				_localPath += "." + path;
			else
				_localPath = path;
		}
		
		/*-----------------------------------------------------------
		 * 		PRIVATE MEMBER
		 *-----------------------------------------------------------*/
		/*
		 * Renvoie une référence vers le SharedObject utilisé en interne
		 */
		private function __getSO () : SharedObject
		{
			return SharedObject.getLocal( _channel, _cookieLocalPath, _secured );
		}
	}
}
