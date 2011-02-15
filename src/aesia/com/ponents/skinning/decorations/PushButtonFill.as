package aesia.com.ponents.skinning.decorations 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class PushButtonFill implements ComponentDecoration
	{
		protected var _height : Number;
		protected var _maxheight : Number;
		protected var _faceColor : Color; 
		protected var _sideColor : Color; 
		protected var _borderColor : Color;
		
		public function PushButtonFill ( h : Number = 0, maxh : Number = 10, faceColor : Color = null, sideColor : Color = null, borderColor : Color = null )
		{
			_height = h;
			_maxheight = maxh;
			_faceColor = faceColor;
			_borderColor = borderColor;
			_sideColor = sideColor;
		}
		public function draw (r : Rectangle, 
								g : Graphics, 
								c : Component,
								borders : Borders = null,
								corners : Corners = null, 
								smoothing : Boolean = false) : void
		{
			drawPushButton( r.x+2, 
							r.y + _maxheight - ( _height > 0 ? _height : 0), 
							r.width - 4 , 
							r.height - _maxheight - 4, 
							_height, 
							g, 
							_faceColor,
							_sideColor,
							_borderColor,
							/*
							Color.LightSeaGreen, 
							Color.Teal, 
							Color.DarkSlateGray,*/ 
							2, 
							corners );
		}
		public function clone () : *
		{
			return new PushButtonFill( _height, _maxheight, _faceColor, _sideColor, _borderColor );
		}
		protected function drawPushButton( x : Number,
											   y : Number,
											   faceWidth : Number,
											   faceHeight : Number, 
											   sideHeight : Number,
											   g : Graphics, 
											   faceColor : Color, 
											   sideColor : Color, 
											   borderColor : Color,
											   borderSize : Number = 2,
											   cornerSize : Corners = null ) : void
		{
			g.lineStyle();
			if( sideHeight > 0 )
			{
				
				g.beginFill( borderColor.hexa );
				/*
				g.drawRoundRectComplex(x-borderSize, 
								y-borderSize, 
								faceWidth + borderSize*2, 
								faceHeight + sideHeight + borderSize*2,
								cornerSize.topLeft + borderSize * 2, 
								cornerSize.topRight + borderSize * 2, 
								cornerSize.bottomLeft + borderSize * 2, 
								cornerSize.bottomRight + borderSize * 2 );
				

				*/
				g.drawRoundRectComplex(x-borderSize, 
								y-borderSize + sideHeight, 
								faceWidth + borderSize*2, 
								faceHeight + borderSize*2,
								cornerSize.topLeft + borderSize * 2, 
								cornerSize.topRight + borderSize * 2, 
								cornerSize.bottomLeft + borderSize * 2, 
								cornerSize.bottomRight + borderSize * 2
								 );
				g.endFill(); 
				
				g.beginFill( sideColor.hexa );
				g.drawRoundRectComplex(x, y, faceWidth, faceHeight + sideHeight, cornerSize.topLeft, cornerSize.topRight, cornerSize.bottomLeft, cornerSize.bottomRight );
				g.endFill();
				
				g.beginFill( faceColor.hexa );
				g.drawRoundRectComplex( x, y, faceWidth, faceHeight, cornerSize.topLeft, cornerSize.topRight, cornerSize.bottomLeft, cornerSize.bottomRight );
				g.endFill();
				
				//g.lineStyle( borderSize, borderColor.hexa, 1, true  );
				//g.drawRoundRect(x, y, faceWidth, faceHeight + sideHeight, cornerSize );
			}
			else if ( sideHeight == 0 )
			{
				g.beginFill( borderColor.hexa );
				g.drawRoundRectComplex(x-borderSize, 
								y-borderSize, 
								faceWidth + borderSize*2, 
								faceHeight + borderSize*2,
								cornerSize.topLeft + borderSize * 2, 
								cornerSize.topRight + borderSize * 2, 
								cornerSize.bottomLeft + borderSize * 2, 
								cornerSize.bottomRight + borderSize * 2 );
				g.endFill(); 
				
				//g.lineStyle( borderSize, borderColor.hexa, 1, true );
				/*
				g.beginFill( sideColor.hexa );
				g.drawRoundRect(x, y, faceWidth, faceHeight, cornerSize );
				g.endFill();
				*/
				g.beginFill( faceColor.hexa );
				g.drawRoundRectComplex(x, y, faceWidth, faceHeight, cornerSize.topLeft-2, cornerSize.topRight-2, cornerSize.bottomLeft-2, cornerSize.bottomRight-2 );
				g.endFill();
			}
			else
			{
				g.beginFill( borderColor.hexa );
				g.drawRoundRectComplex(x-borderSize, 
								y-borderSize, 
								faceWidth + borderSize*2, 
								faceHeight + borderSize*2,
								cornerSize.topLeft-2 + borderSize * 2, 
								cornerSize.topRight-2 + borderSize * 2, 
								cornerSize.bottomLeft-2 + borderSize * 2, 
								cornerSize.bottomRight-2 + borderSize * 2 );
				g.endFill(); 
				
				g.beginFill( sideColor.hexa );
				g.drawRoundRectComplex(x, y, faceWidth, faceHeight, cornerSize.topLeft, cornerSize.topRight, cornerSize.bottomLeft, cornerSize.bottomRight );
				g.endFill();
				
				g.beginFill( faceColor.hexa );
				g.drawRoundRectComplex( x, y - sideHeight, faceWidth, faceHeight + sideHeight, cornerSize.topLeft, cornerSize.topRight, cornerSize.bottomLeft, cornerSize.bottomRight );
				g.endFill();
				
				//g.lineStyle( borderSize, borderColor.hexa, 1, true  );
				//g.drawRoundRect(x, y, faceWidth, faceHeight, cornerSize );
			}
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
