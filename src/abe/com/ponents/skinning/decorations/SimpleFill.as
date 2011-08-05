/**
 * @license
 */
package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.logs.*;
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Equatable;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
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
		public function clone () : *
		{
			return new SimpleFill(color);
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
