package aesia.com.ponents.swf
{
	import flash.text.TextFormat;
	import flash.text.TextField;
	import aesia.com.mon.utils.Reflection;

	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.text.Font;

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

		public function LibraryAsset ( path : String, file : String, domain : ApplicationDomain = null )
		{
			_packagePath = path;
			var index : int = _packagePath.lastIndexOf(".");

			if( index != -1 )
			{
				_accessPath = path.substr(0, index) + "::" + path.substr(index+1);
				_name = path.substr(index+1);
			}
			else
			{
				_accessPath = _packagePath;
				_name = _packagePath;
			}
			_file = file;
			_type = Reflection.get( _accessPath, domain );
		}
		public function get name () : String { return _name; }
		public function get type () : Class { return _type; }
		public function get file () : String { return _file; }
		public function get accessPath () : String { return _accessPath; }
		public function get packagePath () : String { return _packagePath; }

		public function get preview () : DisplayObject
		{
			var o : * = new _type();

			if( o is DisplayObject )
				return o;
			else if( o is Font )
			{
				Font.registerFont( o );
				var txt : TextField = new TextField();
				var tf : TextFormat = new TextFormat ( (o as Font).fontName, 12, 0 );
				txt.embedFonts = true;
				txt.selectable = false;
				txt.autoSize = "left";
				txt.defaultTextFormat = tf;
				txt.text = "The quick brown fox jumps over the lazy dog.";
				return txt;
			}
			else return null;
		}
	}
}