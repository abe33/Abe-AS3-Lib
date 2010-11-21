package aesia.com.ponents.skinning.decorations 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class GraphMonitorBorder extends SimpleBorders implements ComponentDecoration 
	{
		public function GraphMonitorBorder ( color : Color = null )
		{
			super( color );
		}
		
		override public function equals (o : *) : Boolean 
		{
			if( o is GraphMonitorBorder )
			{
				return (o as GraphMonitorBorder).color.equals(color);
			}
			return false;
		}
		
		override public function draw (	r : Rectangle, 
										g : Graphics, 
										c : Component, 
										borders : Borders = null, 
										corners : Corners = null, 
										smoothing : Boolean = false) : void
		{
			super.draw(r, g, c, borders, corners, smoothing );
			
			g.lineStyle( 0, color.hexa, .5 );
			g.moveTo( 0, r.height *.5 );			g.lineTo( r.width, r.height *.5 );
			
			g.lineStyle( 0, color.hexa, .25 );
			g.moveTo( 0, r.height * .25 );
			g.lineTo( r.width, r.height *.25 );
			g.moveTo( 0, r.height * .75 );
			g.lineTo( r.width, r.height *.75 );
		}
	}
}
