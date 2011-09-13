package abe.com.ponents.nodes.renderers.links 
{
    import abe.com.mon.colors.Color;
    import abe.com.ponents.nodes.core.NodeLink;

    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.SpreadMethod;
    import flash.geom.Matrix;
    import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class DashedLine implements LinkRenderer 
	{
		public var size : uint;
		public var color : Color;

		public function DashedLine ( size : uint = 1, color : Color = null) 
		{
			this.size = size;
			this.color = color ? color : Color.Black;
		}
		public function render (link : NodeLink, a : Point, b : Point, g : Graphics) : void
		{
			var m : Matrix = new Matrix();
			m.createGradientBox(10, 10, Math.atan2(a.y-b.y, a.x-b.x),0,0);
			g.clear();
			
			g.lineStyle( 8, 0, 0 );
			g.moveTo( a.x, a.y );
			g.lineTo( b.x, b.y );
						g.lineStyle( this.size );
			g.lineGradientStyle( GradientType.LINEAR, [ this.color.hexa,this.color.hexa,this.color.hexa,this.color.hexa ],[1,1,0,0],[0,127,128,255],m,SpreadMethod.REPEAT );
			g.moveTo( a.x, a.y );
			g.lineTo( b.x, b.y );
			
			g.lineStyle();
		}
	}
}
