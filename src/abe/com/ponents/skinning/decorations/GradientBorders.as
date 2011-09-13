/**
 * @license
 */
package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.utils.MathUtils;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
    [Serialize(constructorArgs="gradient,gradientRotation")]    
	public class GradientBorders implements ComponentDecoration
	{
		public var gradientRotation : Number;
		public var gradient : Gradient;

		public function GradientBorders ( gradient : Gradient = null,
								       gradientRotation : Number = 0 )
		{
			this.gradient = gradient ? gradient : new Gradient([Color.Black, Color.White],[0,1]);
			this.gradientRotation = gradientRotation;
		}
		public function clone () : * 
		{
			return new GradientBorders(gradient.clone(), gradientRotation);	
		}
		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null , smoothing : Boolean = false ) : void
		{
			var m : Matrix = new Matrix();
			corners = corners ? corners : new Corners();
			m.createGradientBox( r.width, r.height, MathUtils.deg2rad(gradientRotation), r.x, r.y );
			
			g.beginGradientFill( GradientType.LINEAR, 
								gradient.toGradientFillColorsArray(), 
								gradient.toGradientFillAlphasArray( ), 
								gradient.toGradientFillPositionsArray(), 
								m );
								
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
			if( o is GradientBorders )
			{
				var g : GradientBorders = o as GradientBorders;
				return g.gradient.equals( gradient ) && 
					   g.gradientRotation == gradientRotation;
			}
			return false;
		}
	}
}
