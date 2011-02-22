package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.utils.Color;
	import abe.com.mon.utils.MathUtils;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class BorderedGradientFill implements ComponentDecoration 
	{
		protected var _borderColor : Color;
		protected var _gradientColor1 : Color;
		protected var _gradientColor2 : Color;
		protected var _borders : Borders;
		protected var _gradientRotation : Number;

		public function BorderedGradientFill ( borderColor : Color, 
								     gradientColor1 : Color, 
								     gradientColor2 : Color, 
								     borders : Borders, 
								     gradientRotation : Number )
		{
			_borderColor = borderColor;
			_borders = borders;
			_gradientColor1 = gradientColor1;
			_gradientColor2 = gradientColor2;
			_gradientRotation = gradientRotation;
		}
		public function clone () : * 
		{
			return new BorderedGradientFill(_borderColor, _gradientColor1.clone(), _gradientColor2.clone(), _borders.clone(), _gradientRotation );
		}
		public function draw ( r : Rectangle, 
							   g : Graphics, 
							   c : Component, 
							   borders : Borders = null, 
							   corners : Corners = null, 
							   smoothing : Boolean = false ) : void
		{
			corners = corners ? corners : new Corners();
			
			var innerWidth : Number = r.width - ( _borders.left + _borders.right );			var innerHeight : Number = r.height - ( _borders.top + _borders.bottom );
			var innerX : Number = r.x + _borders.left;			var innerY : Number = r.y + _borders.top;
			var m : Matrix = new Matrix();
			
			m.createGradientBox( innerWidth, innerHeight, MathUtils.deg2rad(_gradientRotation), innerX, innerY );
			
			g.beginFill( _borderColor.hexa, _borderColor.alpha/255 );			
			g.drawRoundRectComplex(r.x, 
								   r.y, 
								   r.width, 
								   r.height, 
								   corners.topLeft, 
								   corners.topRight, 
								   corners.bottomLeft, 
								   corners.bottomRight );
			
			g.drawRoundRectComplex(innerX, 
								   innerY, 
								   innerWidth, 
								   innerHeight, 
								   Math.max( 0, corners.topLeft- _borders.left / 2 ), 
								   Math.max( 0, corners.topRight- _borders.top/2 ), 
								   Math.max( 0, corners.bottomLeft- _borders.right/2 ), 
								   Math.max( 0, corners.bottomRight- _borders.bottom/2 ) );
			
			g.endFill();
			
			g.beginGradientFill( GradientType.LINEAR, 
								[ _gradientColor1.hexa, _gradientColor2.hexa ], 
								[ _gradientColor1.alpha/255, _gradientColor2.alpha/255 ], 
								[0,255], m );
			
			g.drawRoundRectComplex(innerX, 
								   innerY, 
								   innerWidth, 
								   innerHeight, 
								   Math.max( 0, corners.topLeft- _borders.left / 2 ), 
								   Math.max( 0, corners.topRight- _borders.top/2 ), 
								   Math.max( 0, corners.bottomLeft- _borders.right/2 ), 
								   Math.max( 0, corners.bottomRight- _borders.bottom/2 ) );
			
			g.endFill( );
		}
		
		public function equals (o : *) : Boolean
		{
			return false;
		}
		
		public function toSource () : String
		{
			return null;
		}
		
		public function toReflectionSource () : String
		{
			return null;
		}
	}
}
