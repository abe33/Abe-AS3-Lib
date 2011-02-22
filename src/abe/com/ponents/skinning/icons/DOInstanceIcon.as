package abe.com.ponents.skinning.icons 
{
	import flash.display.DisplayObject;

	/**
	 * @author Cédric Néhémie
	 */
	public class DOInstanceIcon extends Icon 
	{
		private var object : DisplayObject;
		
		public function DOInstanceIcon ( o : DisplayObject )
		{
			super();
			_contentType = "DisplayObject";
			this.object = o;
		}

		override public function dispose () : void 
		{
			if( object && _childrenContainer.contains( object ) )
				_childrenContainer.removeChild( object );
				
			super.dispose();
		}		
		override public function init () : void 
		{
			if( object )
				_childrenContainer.addChild( object );
				
			super.init();
		}
	}
}
