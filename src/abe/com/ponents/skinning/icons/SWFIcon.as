package abe.com.ponents.skinning.icons 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	/**
	 * @author Cédric Néhémie
	 */
	public class SWFIcon extends Icon 
	{
		protected var _url : URLRequest;
		
		protected var _loadingIcon : DisplayObject;
		protected var _failureIcon : DisplayObject;
		protected var _swf : DisplayObject;
		protected var _loader : Loader;
		
		public function SWFIcon (url : URLRequest=null)
		{
			_contentType = "SWF File";
			_loadingIcon = new LoadingIcon();
			_failureIcon = new LoadingFailureIcon();
			
			this.url = url;
			
			invalidatePreferredSizeCache();
		}
		[Form(type="url",label="SWF URL", order="0")]
		public function get url () : URLRequest { return _url; }		
		public function set url (url : URLRequest) : void
		{
			if( _childrenContainer.contains( _loadingIcon ) )
				_childrenContainer.removeChild( _loadingIcon );
				
			if( _childrenContainer.contains( _failureIcon ) )
				_childrenContainer.removeChild( _failureIcon );
			
			if( _loader && _childrenContainer.contains(_loader) )
				_childrenContainer.removeChild( _loader );
			
			if( _url )
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete );
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError );
				_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError );
				_loader.unloadAndStop(true);
			}
			
			_url = url;
			
			if( _url )
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete );
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError );
				_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError );
				_loader.load( _url );
				_childrenContainer.addChild( _loadingIcon );
				invalidatePreferredSizeCache();
			}
		}
		
		protected function securityError (event : SecurityErrorEvent) : void
		{
			_childrenContainer.removeChild( _loadingIcon );
			_childrenContainer.addChild( _failureIcon );
			init();
			fireResizeEvent();
		}
		protected function ioError (event : IOErrorEvent) : void
		{
			_childrenContainer.removeChild( _loadingIcon );
			_childrenContainer.addChild( _failureIcon );
			init();
			fireResizeEvent();
		}
		protected function complete (event : Event) : void
		{
			_childrenContainer.removeChild( _loadingIcon );
			_childrenContainer.addChild( _loader );
			init();
			fireResizeEvent();
		}

		override public function clone () : *
		{
			return new SWFIcon(_url );
		}

		override public function toSource () : String
		{
			return super.toReflectionSource().replace("(", "(new flash.net.URLRequest('" + _url.url + "')" ).replace("::", ".");
		}

		override public function toReflectionSource () : String
		{
			return "@'" + _url.url +"'";
		}
	}
}
