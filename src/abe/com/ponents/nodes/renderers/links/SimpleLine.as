package abe.com.ponents.nodes.renderers.links 
{
	
	import abe.com.mon.utils.Color;
	import abe.com.ponents.nodes.core.NodeLink;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class SimpleLine implements LinkRenderer 
	{
		public var size : uint;
		public var color : Color;

		public function SimpleLine ( size : uint = 1, color : Color = null) 
		{
			this.size = size;
			this.color = color ? color : Color.Black;
		}
		public function render (link : NodeLink, a : Point, b : Point, g : Graphics) : void
		{
			g.clear();
			
			g.lineStyle( 8, 0, 0 );
			g.moveTo( a.x, a.y );
			g.lineTo( b.x, b.y );
			
			g.lineStyle( this.size, this.color.hexa, this.color.alpha/255 );
			g.moveTo( a.x, a.y );
			g.lineTo( b.x, b.y );
		}
	}
}
