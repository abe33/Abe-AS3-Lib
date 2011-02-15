package aesia.com.ponents.skinning.icons 
{
	import flash.display.Bitmap;

	/**
	 * @author Cédric Néhémie
	 */
	public class BitmapIcon extends Icon 
	{
		protected var _bitmap : Bitmap;
		
		public function BitmapIcon ( bitmap : Bitmap = null )
		{
			super();
			_bitmap = bitmap;
			_contentType = "BitmapData";
			init();
		}
		public function get bitmap () : Bitmap
		{
			return _bitmap;
		}
		override public function init () : void
		{
			var l : uint = _childrenContainer.numChildren;
			if( l > 0 )
				while(l--)
					_childrenContainer.removeChildAt( l );
			
			if( _bitmap )
				_childrenContainer.addChild( _bitmap );
				
			super.init();
		}
		override public function dispose () : void
		{			
			if( _bitmap && _childrenContainer.contains( _bitmap ) )
				_childrenContainer.removeChild( _bitmap );
		
			super.dispose();
		}
		override public function clone () : *
		{
			return new BitmapIcon( new Bitmap( _bitmap.bitmapData, _bitmap.pixelSnapping, _bitmap.smoothing ) );
		}
		
	}
}
