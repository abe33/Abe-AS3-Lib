/**
 * @license
 */
package aesia.com.ponents.skinning.decorations 
{
	import flash.utils.getQualifiedClassName;
	import aesia.com.mon.core.Equatable;
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class SimpleFill implements ComponentDecoration, Equatable
	{
		public var color : Color;
		
		public function SimpleFill ( color : Color = null )
		{
			this.color = color ? color : Color.White;
		}

		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null,corners : Corners = null, smoothing : Boolean = false ) : void
		{
			corners = corners ? corners : new Corners();
			g.beginFill( color.hexa, color.alpha/255 );
			g.drawRoundRectComplex(r.x, r.y, r.width, r.height, corners.topLeft, corners.topRight, corners.bottomLeft, corners.bottomRight );
			g.endFill( );
		}
		
		public function equals (o : *) : Boolean
		{
			if( o is SimpleFill )
				return ( o as SimpleFill ).color.equals( color );
				
			return false;
		}
		
		public function toSource () : String
		{
			return "new "+ getQualifiedClassName(this).replace("::", ".") + "(" + color.toSource() +")" ;
		}
		public function toReflectionSource () : String
		{
			return "new "+ getQualifiedClassName(this) + "(" + color.toReflectionSource() +")" ;
		}
	}
}
