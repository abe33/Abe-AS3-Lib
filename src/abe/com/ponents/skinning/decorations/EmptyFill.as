/**
 * @license
 */
package abe.com.ponents.skinning.decorations 
{
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
	public class EmptyFill implements ComponentDecoration 
	{
		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
			corners = corners ? corners : new Corners();
			g.beginFill(0,0);
			g.drawRoundRectComplex(r.x, r.y, r.width, r.height, corners.topLeft, corners.topRight, corners.bottomLeft, corners.bottomRight );
			g.endFill( );
		}
		public function clone () : * 
		{
			return new EmptyFill();
		}
		public function equals (o : *) : Boolean
		{
			return o is EmptyFill;
		}
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		public function toReflectionSource () : String
		{
			return "new "+ getQualifiedClassName(this) + "()" ;
		}
	}
}
