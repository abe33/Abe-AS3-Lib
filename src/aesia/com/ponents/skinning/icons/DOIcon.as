package aesia.com.ponents.skinning.icons 
{
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
			super( );
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
		
	}
}
