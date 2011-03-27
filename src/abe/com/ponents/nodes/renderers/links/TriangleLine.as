package abe.com.ponents.nodes.renderers.links 
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.nodes.core.NodeLink;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class TriangleLine extends ArrowLine implements ComplexRendererElement 
	{
		public function TriangleLine ( size : Number = 1, color : Color = null, arrowSize : Number = 10, arrowSpread : Number = .5 ) 
		{
			super(size,color,arrowSize,arrowSpread);
		}
		override public function render (link : NodeLink, a : Point, b : Point, g : Graphics) : void
		{
			var d : Point = a.subtract( b );
			var t : Number = Math.atan2( d.y, d.x );
			
			g.lineStyle(size, color.hexa, color.alpha/255);
			
			g.moveTo( b.x , b.y );
			g.lineTo( b.x + Math.cos(t+arrowSpread) * arrowSize, b.y + Math.sin(t+arrowSpread) * arrowSize );
			g.lineTo( b.x + Math.cos(t-arrowSpread) * arrowSize, b.y + Math.sin(t-arrowSpread) * arrowSize );
			g.lineTo( b.x, b.y);
			
			g.lineStyle();
		}
		override public function get length () : Number
		{
			return Math.abs( Math.cos( arrowSpread ) * arrowSize );
		}
	}
}
