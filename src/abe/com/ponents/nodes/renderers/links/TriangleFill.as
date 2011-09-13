package abe.com.ponents.nodes.renderers.links 
{
    import abe.com.mon.colors.Color;
    import abe.com.ponents.nodes.core.NodeLink;

    import flash.display.Graphics;
    import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class TriangleFill extends TriangleLine 
	{
		private var fillColor : Color;

		public function TriangleFill (size : Number = 1, color : Color = null, fillColor : Color = null, arrowSize : Number = 10, arrowSpread : Number = .5)
		{
			super( size, color, arrowSize, arrowSpread );
			this.fillColor = fillColor ? fillColor : Color.Black;
		}
		override public function render (link : NodeLink, a : Point, b : Point, g : Graphics) : void 
		{
			g.beginFill( fillColor.hexa, fillColor.alpha/255 );
			super.render( link, a, b, g );
			g.endFill();
		}
	}
}
