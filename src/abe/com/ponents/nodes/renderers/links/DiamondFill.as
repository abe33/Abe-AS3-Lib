package abe.com.ponents.nodes.renderers.links 
{
	import abe.com.mon.utils.Color;
	import abe.com.ponents.nodes.core.NodeLink;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class DiamondFill extends DiamondLine 
	{
		public var fillColor : Color;

		public function DiamondFill (size : Number = 1, color : Color = null, fillColor : Color = null, diamondSideSize : Number = 10, diamondSpread : Number = .5)
		{
			super( size, color, diamondSideSize, diamondSpread );
			this.fillColor = fillColor ? fillColor : Color.Black;
		}
		override public function render (link : NodeLink, a : Point, b : Point, g : Graphics) : void 
		{
			g.beginFill(fillColor.hexa, fillColor.alpha /255);
			super.render( link, a, b, g );
			g.endFill();
		}
	}
}
