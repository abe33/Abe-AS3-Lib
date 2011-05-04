/**
 * @license
 */
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
	public class SimpleBorders implements ComponentDecoration
	{
		public var color : Color;

		public function SimpleBorders ( color : Color = null ) 
		{
			this.color = color ? color : Color.Black;
		}
		public function clone () : *
		{
			return new SimpleBorders(color);
		}
		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null , smoothing : Boolean = false ) : void
		{
			corners = corners ? corners : new Corners();
			g.beginFill( color.hexa, color.alpha/255 );
			g.drawRoundRectComplex(	r.x, 
									r.y, 
									r.width, 
									r.height, 
									corners.topLeft, 
									corners.topRight, 
									corners.bottomLeft, 
									corners.bottomRight );
												g.drawRoundRectComplex(	r.x+borders.left, 
									r.y+borders.top, 
									r.width-(borders.left+borders.right), 
									r.height-(borders.top+borders.bottom), 
									Math.max( 0, corners.topLeft - 1 ), 
									Math.max( 0, corners.topRight - 1 ), 
									Math.max( 0, corners.bottomLeft - 1 ), 
									Math.max( 0, corners.bottomRight - 1 ) );
			g.endFill();
		}
		public function equals (o : *) : Boolean
		{
			if( o is SimpleBorders )
				return ( o as SimpleBorders ).color.equals( color );
				
			return false;
		}
		public function toSource () : String
		{
			return "new "+ getQualifiedClassName(this).replace("::", ".") + "(" + color.toSource() + ")" ;
		}
		public function toReflectionSource () : String
		{
			return "new "+ getQualifiedClassName(this) + "(" + color.toReflectionSource() + ")" ;
		}
	}
}
