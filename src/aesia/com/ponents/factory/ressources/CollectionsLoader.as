package aesia.com.ponents.factory.ressources 
{
	import aesia.com.mands.load.LoaderQueue;
	import aesia.com.mon.utils.url;

	import flash.display.Loader;
	import flash.events.Event;
	
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
		override public function complete (e : Event) : void 
		{
			if( _currentLoader.content is ClassCollection )
			{
				var col : ClassCollection = _currentLoader.content as ClassCollection;
				col.collectionURL = _currentRequest.url;
				_collections.push( col );
			}
			
			super.complete( e );
		}
	}
}
