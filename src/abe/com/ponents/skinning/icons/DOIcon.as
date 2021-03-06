package abe.com.ponents.skinning.icons 
{
	import abe.com.mon.geom.dm;

	import flash.display.DisplayObject;
	/**
	 * @author Cédric Néhémie
	 */
	public class DOIcon extends Icon 
	{
		protected var _class : Class;
		protected var _icon : DisplayObject;
		
		public function DOIcon ( c : Class )
		{
			_class = c;
			_contentType = "DisplayObject";
			super();
			styleKey = "EmptyComponent";
		}
		override public function dispose () : void 
		{
			if( _icon && _childrenContainer.contains( _icon ) )
				_childrenContainer.removeChild( _icon );
				
			super.dispose();
		}		
		override public function init () : void 
		{
			_icon = new _class() as DisplayObject;
			if( _icon )
				_childrenContainer.addChild( _icon );
			
			super.init();
		}
		override public function clone () : * 
		{ 
			return new DOIcon( _class ); 
		}
		override public function invalidatePreferredSizeCache () : void
		{
			_preferredSizeCache = _icon ? dm(_icon.width,_icon.height) : dm(0,0);
			invalidate( false );
		}
		
	}
}
