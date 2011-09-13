package abe.com.ponents.skinning.icons 
{
    import abe.com.ponents.allocators.ExternalBitmapAllocatorInstance;

    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.net.URLRequest;
	/**
	 * @author Cédric Néhémie
	 */
    [Serialize(constructorArgs="url")]
	public class ExternalBitmapIcon extends BitmapIcon
	{
		protected var _url : URLRequest;
		
		protected var _loadingIcon : DisplayObject;		protected var _failureIcon : DisplayObject;
		
		public function ExternalBitmapIcon ( url : URLRequest = null )
		{
			_contentType = "External BitmapData";
			_loadingIcon = new LoadingIcon();
			_failureIcon = new LoadingFailureIcon();
			
			this.url = url;
		}	
		[Form(type="url",label="Bitmap URL", order="0")]
		public function get url () : URLRequest { return _url; }		
		public function set url (url : URLRequest) : void
		{
			if( _bitmap && _childrenContainer.contains(_bitmap) )
			{
				_childrenContainer.removeChild( _bitmap );	
				ExternalBitmapAllocatorInstance.release( _bitmap );
			}
			else if( _childrenContainer.contains(_loadingIcon) )
				_childrenContainer.removeChild(_loadingIcon);
			else if( _childrenContainer.contains( _failureIcon ) )
				_childrenContainer.removeChild( _failureIcon ); 
			
			_url = url;
			if( _url )
			{
				_bitmap = ExternalBitmapAllocatorInstance.get( _url, onBitmapAvailable, onBitmapLoadingFailure );
				if( !_bitmap )
					_childrenContainer.addChild( _loadingIcon );
				else 
					super.init();
			}
			invalidatePreferredSizeCache();
		}
			
		protected function onBitmapAvailable ( bmp : Bitmap ) : void
		{
			if( _childrenContainer.contains( _loadingIcon ) )
				_childrenContainer.removeChild( _loadingIcon );
			_bitmap = bmp;
			super.init();
			fireComponentResizedSignal();
		}
		
		protected function onBitmapLoadingFailure () : void
		{
			if( _childrenContainer.contains( _loadingIcon ) )
				_childrenContainer.removeChild( _loadingIcon );
			_childrenContainer.addChild( _failureIcon );
			super.init();
			fireComponentResizedSignal();
		}
		override public function init () : void {}
		override public function clone () : *
		{
			return new ExternalBitmapIcon( _url );
		}

	}
}
