package aesia.com.ponents.nodes.renderers.links 
{
	
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.nodes.core.NodeLink;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class DiamondLine implements ComplexRendererElement 
	{
		public var size : Number;
		public var color : Color;
		public var diamondSideSize : Number;
		public var diamondSpread : Number;
		
		public function DiamondLine ( size : Number = 1, color : Color = null, diamondSideSize : Number = 10, diamondSpread : Number = .5 ) 
		{
			this.size = size;
			this.color = color ? color : Color.Black,
			this.diamondSideSize = diamondSideSize;
			this.diamondSpread = diamondSpread;
		}
		public function render (link : NodeLink, a : Point, b : Point, g : Graphics) : void
		{
			var d : Point = a.subtract( b );
			var t : Number = Math.atan2( d.y, d.x );
			d.normalize( length );
			g.lineStyle(size, color.hexa, color.alpha/255);
			
			g.moveTo( b.x , b.y );
			g.lineTo( b.x + Math.cos(t+diamondSpread) * diamondSideSize, b.y + Math.sin(t+diamondSpread) * diamondSideSize );
			g.lineTo( b.x + d.x, b.y + d.y );
			g.lineTo( b.x + Math.cos(t-diamondSpread) * diamondSideSize, b.y + Math.sin(t-diamondSpread) * diamondSideSize );			g.lineTo( b.x, b.y);
			
			g.lineStyle();
		}
		public function get length () : Number
		{
			return Math.abs( Math.cos( diamondSpread ) * diamondSideSize ) * 2;
		}
	}
}
