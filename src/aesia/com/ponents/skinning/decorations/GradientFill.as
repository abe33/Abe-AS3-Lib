package aesia.com.ponents.skinning.decorations 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.Gradient;
	import aesia.com.mon.utils.MathUtils;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
	public class GradientFill implements ComponentDecoration 
	{
		public var gradientRotation : Number;
		public var gradient : Gradient;

		public function GradientFill ( gradient : Gradient = null,
								       gradientRotation : Number = 0 )
		{
			this.gradient = gradient ? gradient : new Gradient([Color.Black, Color.White],[0,1]);
			this.gradientRotation = gradientRotation;
		}
		public function clone () : * 
		{
			return new GradientFill(gradient.clone(), gradientRotation);
		}
		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
			var m : Matrix = new Matrix();
			
			m.createGradientBox( r.width, r.height, MathUtils.deg2rad(gradientRotation), r.x, r.y );
			
			g.beginGradientFill( GradientType.LINEAR, 
								gradient.toGradientFillColorsArray(), 
								gradient.toGradientFillAlphasArray(), 
								gradient.toGradientFillPositionsArray(), 
								m );			
			g.drawRoundRectComplex(r.x, 
								   r.y, 
								   r.width, 
								   r.height, 
								   corners.topLeft, 
								   corners.topRight, 
								   corners.bottomLeft, 
								   corners.bottomRight );
			g.endFill( );
		}
		
		public function equals (o : *) : Boolean
		{
			if( o is GradientFill )
			{
				var g : GradientFill = o as GradientFill;
				return g.gradient.equals( gradient ) && 
					   g.gradientRotation == gradientRotation;
			}
			return false;
		}
		public function toSource () : String
		{
			return "new "+ getQualifiedClassName(this).replace("::", ".") + "(" + gradient.toSource() + "," + gradientRotation + ")" ;
		}
		public function toReflectionSource () : String
		{
			return "new "+ getQualifiedClassName(this) + "(" + gradient.toReflectionSource() + "," + gradientRotation + ")" ;
		}
	}
}
