package abe.com.ponents.layouts.display 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.dm;
	import abe.com.ponents.utils.Insets;

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
			
			var xoff : uint = ( ( preferredSize.width - bb.width ) / 2 ) - bb.left; 
			
			_container.x = xoff;
		}

		protected function computeSize () : Dimension 
		{
			var bb : Rectangle = _container.getBounds( _container.parent );
			return dm( bb.width, bb.height );
		}
	}
}