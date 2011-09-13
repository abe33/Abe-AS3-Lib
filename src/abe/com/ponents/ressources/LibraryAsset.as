package abe.com.ponents.ressources
{
    import abe.com.mon.utils.Reflection;

    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;
	/**
	 * @author cedric
	 */
	public class LibraryAsset
	{
		
		protected var _name : String;
		protected var _type : Class;
		protected var _file : String;
		protected var _accessPath : String;
		protected var _packagePath : String;
		
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
		public function get extendsClasses () : Array {	return _extendsClasses; }
		public function get implementsInterfaces () : Array { return _implementsInterfaces; }
		
		protected function initDescription () : void 
		{
			var xmlListToArray : Function = function( xmlList : XMLList ):Array
			{ 
				var a : Array = [];
				for each( var x : XML in xmlList )
					a.push( x );	
				return a.join(",").split(",");
			};
			var xml : XML = Reflection.describeClass( _type );
			_extendsClasses  = xmlListToArray( xml.factory.extendsClass.@type );
			_implementsInterfaces  = xmlListToArray( xml.factory.implementsInterface.@type );
		}
	}
}