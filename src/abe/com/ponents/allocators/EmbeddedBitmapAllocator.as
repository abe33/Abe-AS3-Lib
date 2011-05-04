/**
 * @license
 */
package abe.com.ponents.allocators 
{
	import abe.com.mon.core.Allocator;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	/**
	 * 
	 * 
	 * @author Cédric Néhémie
	 */
	public class EmbeddedBitmapAllocator implements Allocator
	{
		protected var _bitmaps : Dictionary;		protected var _bitmapsRefCounts : Dictionary;
		
		public function EmbeddedBitmapAllocator ()
		{
			_bitmaps = new Dictionary();			_bitmapsRefCounts = new Dictionary();
		}
		
		public function get (c : Class, defaults : Object = null) : *
		{
			if( !contains( c ) )
				_bitmaps[ c ] = ( new c() as Bitmap ).bitmapData;
			
			if( !containsRefCount( c ) )
				_bitmapsRefCounts[ c ] = 0; 
			
			_bitmapsRefCounts[c]++;			
			return new Bitmap( _bitmaps[ c ] as BitmapData, "auto", true );
		}
		
		public function contains ( c : Class ) : Boolean
		{
			return _bitmaps[ c ] != undefined;
		}
		protected function containsRefCount ( c : Class ) : Boolean
		{
			return _bitmapsRefCounts[ c ] != undefined;
		}
		public function release ( o : *, cl : Class = null ) : void
		{
			if( o is Bitmap )
			  	o = (o as Bitmap).bitmapData;		
			
			var c : Class = getAssociatedClass( o );
			if( c )
			{
				_bitmapsRefCounts[ c ]--;
				
				if( _bitmapsRefCounts[ c ] == 0 )
				{
					( _bitmaps[ c ] as BitmapData ).dispose();
					
					delete _bitmaps[ c ];
					delete _bitmapsRefCounts[ c ];
				}
			}
		}
		public function getAssociatedClass ( o : BitmapData ) : Class
		{
			for( var i : * in _bitmaps )
				if( o == _bitmaps[i] )
					return i as Class;
			
			return null;
		}
	}
}
