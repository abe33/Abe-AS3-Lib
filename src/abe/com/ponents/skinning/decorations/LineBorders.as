package abe.com.ponents.skinning.decorations
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
    [Serialize(constructorArgs="color,lineWidth")]
	public class LineBorders implements ComponentDecoration
	{
		public var color : Color;
		public var lineWidth : uint;
		
		public function LineBorders ( color : Color = null, lineWidth : uint = 0 )
		{
			this.color = color ? color : Color.Black;
			this.lineWidth = lineWidth;
		}
		public function clone () : * 
		{
			return new LineBorders(color, lineWidth);
		}
		public function draw ( r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false ) : void
		{
			corners = corners ? corners : new Corners ();
			g.lineStyle ( 0, color.hexa, color.alpha / 255 );
			g.drawRoundRectComplex(	r.x, 
									r.y, 
									r.width, 
									r.height, 
									corners.topLeft, 
									corners.topRight, 
									corners.bottomLeft, 
									corners.bottomRight );

		}

		public function equals ( o : * ) : Boolean
		{
			if( o is LineBorders )
				return ( o as LineBorders ).color.equals( color );
				
			return false;
		}
	}
}
