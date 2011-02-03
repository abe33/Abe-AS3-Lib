package aesia.com.ponents.layouts.display 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.geom.dm;
	import aesia.com.ponents.utils.Insets;

	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class DOCenterBBox extends AbstractDisplayObjectLayout 
	{
		public function DOCenterBBox (container : DisplayObjectContainer = null)
		{
			super( container );
		}

		override public function get preferredSize () : Dimension 
		{
			return computeSize();
		}

		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void 
		{
			if( !insets )
				insets = new Insets();
			
			if( !preferredSize )
				preferredSize = computeSize().grow(insets.horizontal, insets.vertical );
			
			var bb : Rectangle = _container.getBounds( _container.parent );
			
			var xoff : uint = ( ( preferredSize.width - bb.width ) / 2 ) - bb.left; 			var yoff : uint = ( ( preferredSize.height - bb.height ) / 2 ) - bb.top;
			
			_container.x = xoff;			_container.y = yoff;
		}

		protected function computeSize () : Dimension 
		{
			var bb : Rectangle = _container.getBounds( _container.parent );
			return dm( bb.width, bb.height );
		}
	}
}
