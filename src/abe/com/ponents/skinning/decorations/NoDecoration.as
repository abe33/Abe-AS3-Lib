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
	public class NoDecoration implements ComponentDecoration
	{
		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
		}
		public function equals (o : *) : Boolean
		{
			return o is NoDecoration;
		}
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		public function toReflectionSource () : String
		{
			return "new "+ getQualifiedClassName(this) + "()" ;
		}
		public function clone () : *
		{
			return new NoDecoration();
		}
	}
}
