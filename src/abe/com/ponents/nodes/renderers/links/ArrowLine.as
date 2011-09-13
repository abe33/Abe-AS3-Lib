package abe.com.ponents.nodes.renderers.links 
{
    import abe.com.mon.colors.Color;
    import abe.com.ponents.nodes.core.NodeLink;

    import flash.display.Graphics;
    import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class ArrowLine implements ComplexRendererElement 
	{
		public var size : Number;		public var color : Color;		public var arrowSize : Number;
		public var arrowSpread : Number;

		public function ArrowLine ( size : Number = 1, color : Color = null, arrowSize : Number = 10, arrowSpread : Number = .5 ) 
		{
			this.size = size;
			this.color = color ? color : Color.Black;
			this.arrowSize = arrowSize;
			this.arrowSpread = arrowSpread;
		}
		public function render (link : NodeLink, a : Point, b : Point, g : Graphics) : void
		{
			var d : Point = a.subtract( b );
			var t : Number = Math.atan2( d.y, d.x );
			
			g.lineStyle(size, color.hexa, color.alpha/255);
			
			g.moveTo( b.x , b.y );
			g.lineTo( b.x + Math.cos(t+arrowSpread) * arrowSize, b.y + Math.sin(t+arrowSpread) * arrowSize );
			
			g.moveTo( b.x , b.y );
			g.lineTo( b.x + Math.cos(t-arrowSpread) * arrowSize, b.y + Math.sin(t-arrowSpread) * arrowSize );
			
			g.lineStyle();
			
		}
		public function get length () : Number { return 0; }
	}
}
