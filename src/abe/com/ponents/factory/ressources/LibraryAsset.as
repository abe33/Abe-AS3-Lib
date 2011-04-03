package abe.com.ponents.factory.ressources
{
	import abe.com.ponents.factory.ressources.handlers.MovieClipHandler;
	import abe.com.ponents.factory.ressources.handlers.FontHandler;
	import abe.com.ponents.factory.ressources.handlers.DisplayObjectHandler;
	import abe.com.mon.utils.Reflection;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.factory.ressources.handlers.DefaultHandler;
	import abe.com.ponents.factory.ressources.handlers.TypeHandler;

	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author cedric
	 */
	public class LibraryAsset
	{
		static private var ASSET_DETAILS : String = _( "${name}\n<font size='9'><font color='#666666'><i>${path}</i></font>\n\n<font color='#666666'>Extends :</font> ${extends}\n<font color='#666666'>Implements :</font> ${implements}\n${handlerDescription}</font>" );
		static public const DEFAULT_HANDLER : DefaultHandler = new DefaultHandler();
		static public const TYPE_HANDLERS : Object = {
			'flash.display::DisplayObject':new DisplayObjectHandler(),			'flash.display::MovieClip':new MovieClipHandler(),			'flash.text::Font':new FontHandler()
		};
		
		protected var _name : String;
		protected var _type : Class;
		protected var _file : String;
		protected var _accessPath : String;
		protected var _packagePath : String;
		protected var _description : String;
		protected var _currentHandler : TypeHandler;
		
		protected var _extendsClasses : Array;		protected var _implementsInterfaces : Array;

		public function LibraryAsset ( classOrPath : *, file : String, domain : ApplicationDomain = null )
		{
			if( classOrPath is Class )
			{
				_accessPath = getQualifiedClassName( classOrPath );
				_packagePath = _accessPath.indexOf('::') != -1 ? _accessPath.split("::")[0] : "Top Level";				_name = _accessPath.indexOf('::') != -1 ? _accessPath.split("::")[1] : _accessPath;
				_type = classOrPath;
			}
			else if( classOrPath is String )
			{
				_packagePath = classOrPath;
				var index : int = _packagePath.lastIndexOf(".");
	
				if( index != -1 )
				{
					_accessPath = classOrPath.substr(0, index) + "::" + classOrPath.substr(index+1);
					_name = classOrPath.substr(index+1);
				}
				else
				{
					_accessPath = _packagePath;
					_name = _packagePath;
				}
				_type = Reflection.get( _accessPath, domain );
			}
			_file = file;
			initDescription();
		}
		public function get name () : String { return _name; }
		public function get type () : Class { return _type; }
		public function get file () : String { return _file; }
		public function get accessPath () : String { return _accessPath; }
		public function get packagePath () : String { return _packagePath; }
		public function get description () : String { return _description; }
		public function get extendsClasses () : Array {	return _extendsClasses; }
		public function get implementsInterfaces () : Array { return _implementsInterfaces; }
		public function get preview () : Component { return _currentHandler.getPreview( _type ); }		public function get iconHandler () : Function { return _currentHandler.getIconHandler(); }
		
		protected function initDescription () : void 
		{
			var xmlListToArray : Function = function( xmlList : XMLList ):Array
			{
				var a : Array = [];
				for each( var x : XML in xmlList )
					a.push( x );	
				return a.join(",").split(",");
			};
			var map : Function = function( o : *, ... args ) : String
			{
				var s : String = String(o);
				if( s.indexOf("::") != -1 )
					s = s.split("::")[1];
				return _$("<font color='#333333'>$0</font>", s );
			};
			var cls : String;
			var xml : XML = Reflection.describeClass( _type );
			var handlerFound : Boolean;
			_extendsClasses  = xmlListToArray( xml.factory.extendsClass.@type );
			_implementsInterfaces  = xmlListToArray( xml.factory.implementsInterface.@type );
			for each ( cls in _extendsClasses )
				if( TYPE_HANDLERS.hasOwnProperty( cls ) )
				{
					_currentHandler = ( TYPE_HANDLERS[ cls ] as TypeHandler );
					handlerFound = true;
					break;
				}
			if( !handlerFound )				for each ( cls in _implementsInterfaces )
					if( TYPE_HANDLERS.hasOwnProperty( cls ) )
					{
						_currentHandler = ( TYPE_HANDLERS[ cls ] as TypeHandler );
						handlerFound = true;
						break;
					}
			
			if( !handlerFound )			
				_currentHandler =  DEFAULT_HANDLER;
	
			_description = _$( ASSET_DETAILS,
							  {
								  'name':name, 
								  'path':packagePath,
								  'extends': _$( "$0 &gt; $1", 
								  				 name, _extendsClasses.map(map).join(" &gt; ") ),
								  'implements': _implementsInterfaces.map(map).join(", "),
								  'handlerDescription':_currentHandler.getDescription( _type )
							  } )
		}
	}
}