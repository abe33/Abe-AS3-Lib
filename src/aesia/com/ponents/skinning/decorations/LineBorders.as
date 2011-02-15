package aesia.com.ponents.skinning.decorations
{
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
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
		public function toSource () : String
		{
			return "new " + getQualifiedClassName ( this ).replace ( "::", "." ) + "(" + color.toSource () + ", " + lineWidth + ")" ;
		}
		public function toReflectionSource () : String
		{
			return "new "+ getQualifiedClassName(this) + "(" + color.toReflectionSource() + ", " + lineWidth + ")" ;
		}
	}
}
