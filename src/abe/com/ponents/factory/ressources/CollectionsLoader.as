package abe.com.ponents.factory.ressources 
{
	import flash.system.ApplicationDomain;
	import abe.com.mands.load.LoaderQueue;
	import abe.com.mands.load.URLLoaderEntry;
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.url;

	import com.kode80.swf.SWF;
	import com.kode80.swf.tags.SymbolClassTag;
	import com.kode80.swf.tags.TagCodes;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;

	[Event(type="flash.events.ProgressEvent", name="progress")]
	public class CollectionsLoader extends LoaderQueue 
	{
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _collections : Array;
		TARGET::FLASH_10
		protected var _collections : Vector.<ClassCollection>;
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _collections : Vector.<ClassCollection>;
		
		public function CollectionsLoader ()
		{
			super();
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _collections = []; }
			TARGET::FLASH_10 { _collections = new Vector.<ClassCollection>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_collections = new Vector.<ClassCollection>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		/*FDT_IGNORE*/
		TARGET::FLASH_9 {
		public function get collections () : Array { return _collections; }
		public function set collections ( o : Array ) : void { _collections = o; }
		}
		TARGET::FLASH_10 {
		public function get collections () : Vector.<ClassCollection> { return _collections; }
		public function set collections ( o : Vector.<ClassCollection> ) : void { _collections = o; }
		}
		TARGET::FLASH_10_1 { /*FDT_IGNORE*/
		public function get collections () : Vector.<ClassCollection> { return _collections; }
		public function set collections ( o : Vector.<ClassCollection> ) : void { _collections = o; }
		/*FDT_IGNORE*/}/*FDT_IGNORE*/
		
		public function loadCollection( s : String ) : void
		{
			addLoader( new Loader(), url( s ) );
		}
		
		public function getCollectionByName( name : String ) : ClassCollection
		{
			var l : uint = _collections.length;
			for( var i : uint = 0; i<l; i++ )
				if( _collections[i].collectionName == name )
					return _collections[i];
			return null;
		}
		public function getCollectionsByType( type : String ) : Array
		{
			var a : Array = [];
			var l : uint = _collections.length;
			for( var i : uint = 0; i<l; i++ )
				if( _collections[i].collectionType == type )
					a.push( _collections[i] );
			return a;
		}
		public function getClassesByType( type : String ) : Array
		{
			var a : Array = [];
			var l : uint = _collections.length;
			for( var i : uint = 0; i<l; i++ )
				if( _collections[i].collectionType == type )
					a = a.concat( _collections[i].classes );
			return a;
		}
		public function getAllClasses () : Array
		{
			var a : Array = [];
			var l : uint = _collections.length;
			for( var i : uint = 0; i<l; i++ )
				a = a.concat( _collections[i].classes );
			return a;
		}
		static public function getCollectionFromSWF( swf : SWF, url : String, loader : Loader ) : ClassCollection
		{
			var a : Array = swf.getTagsByCode ( TagCodes.SYMBOL_CLASS );
			var l : uint = a.length;
			var c : Array = [];
			var tag : SymbolClassTag;
			for(var i:int=0;i<l;i++)
			{
				tag = a[i];
				for(var j:int=0;j<tag.numberOfSymbols;j++)
				{
					var className : String = tag.getClassName( tag.getID( j ) );
					
					var path : String;
					var index : int = className.lastIndexOf(".");
					
					if( index != -1 )
						path = className.substr(0, index) + "::" + className.substr(index+1);
					else
						path = className;

					var cls : Class = Reflection.get( path, loader ? loader.contentLoaderInfo.applicationDomain : ApplicationDomain.currentDomain );
					c.push( cls );
				}
			}
			
			var col : ClassCollection = new ClassCollection();
			col.collectionURL = url;
			col.collectionType = RessourcesType.MIXED;
			col.name = url;
			col.classes = c;
			return col;
		}
		private var entry : URLLoaderEntry;
		override public function complete (e : Event) : void 
		{
			if( _currentLoader.content is ClassCollection )
			{
				var col : ClassCollection = _currentLoader.content as ClassCollection;
				col.collectionURL = _currentRequest.url;
				_collections.push( col );
				super.complete( e );
			}
			else
			{
				var f : Function = super.complete; 
				entry = new URLLoaderEntry( _currentRequest, function( entry : URLLoaderEntry ):void {
					
					var bytes : ByteArray  = entry.loader.data;
					bytes.position = 0;
					var swf : SWF = new SWF();
					swf.readFrom(bytes);
					
					var col : ClassCollection = getCollectionFromSWF( swf, _currentRequest.url, _currentLoader );
					_collections.push( col );
					f( e );
				});
				entry.loader.dataFormat = URLLoaderDataFormat.BINARY;
				entry.execute();
			}
		}
	}
}
