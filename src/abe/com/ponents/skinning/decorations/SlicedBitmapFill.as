/**
 * @license
 */
package abe.com.ponents.skinning.decorations 
{
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class SlicedBitmapFill implements ComponentDecoration
	{
		public var bitmap : BitmapData;
		public var scale9Grid : Rectangle;
		
		public function SlicedBitmapFill ( bitmap : BitmapData = null, scale9Grid : Rectangle = null )
		{
			this.bitmap = bitmap ? bitmap : new BitmapData(16, 16, false, 0 );
			this.scale9Grid = scale9Grid ? scale9Grid : new Rectangle( 1, 1, this.bitmap.width-2, this.bitmap.height - 2);
		}
		public function clone () : *
		{
			return new SlicedBitmapFill(bitmap.clone(), scale9Grid.clone() );
		}
		public function draw( r : Rectangle, g : Graphics, c : Component, borders : Borders = null,corners:Corners = null, smoothing : Boolean = false ) : void
		{
			corners = corners ? corners : new Corners();
			
			var sourceCornerLeftWidth : Number = scale9Grid.x;
			var sourceCornerRightWidth : Number = bitmap.width - scale9Grid.right;
			var sourceCornerTopHeight : Number = scale9Grid.y;
			var sourceCornerBottomHeight : Number = bitmap.height - scale9Grid.bottom;
			
			var sourceCornersWidth : Number = sourceCornerLeftWidth + sourceCornerRightWidth;
			var sourceCornersHeight : Number = sourceCornerBottomHeight + sourceCornerTopHeight;
			
			var sourceStretchWidth : Number = bitmap.width - sourceCornersWidth;
			var sourceStretchHeight : Number = bitmap.height - sourceCornersHeight;
			
			var targetCornerLeftWidth : Number;
			var targetCornerRightWidth : Number;
			var targetCornerTopHeight : Number;
			var targetCornerBottomHeight : Number;
			var rate : Number;
			if( sourceCornersWidth > r.width ) 
			{
				rate = r.width / sourceCornersWidth;	
				targetCornerLeftWidth = sourceCornerLeftWidth * rate;
				targetCornerRightWidth = sourceCornerRightWidth * rate;
			}
			else
			{
				targetCornerLeftWidth = sourceCornerLeftWidth;
				targetCornerRightWidth = sourceCornerRightWidth;
			}
			
			if( sourceCornersHeight > r.height ) 
			{
				rate = r.height / sourceCornersHeight;	
				targetCornerTopHeight = sourceCornerTopHeight * rate;
				targetCornerBottomHeight = sourceCornerBottomHeight * rate;
			}
			else
			{
				targetCornerTopHeight = sourceCornerTopHeight;
				targetCornerBottomHeight = sourceCornerBottomHeight;
			}
			var targetCornersWidth : Number = targetCornerLeftWidth + targetCornerRightWidth;
			var targetCornersHeight : Number = targetCornerBottomHeight + targetCornerTopHeight;
			
			var targetStretchWidth : Number = r.width - targetCornersWidth;
			var targetStretchHeight : Number = r.height - targetCornersHeight;
			
			var xleft : Number = r.x;
			var ytop : Number = r.y;
			var xright : Number = r.x + r.width - targetCornerRightWidth;
			var ybottom : Number = r.y + r.height - targetCornerBottomHeight;
			
			// top left
			drawPiece( g, 
					   xleft, 
					   ytop, 
					   targetCornerLeftWidth, 
					   targetCornerTopHeight,
					   0, 
					   0, 
					   sourceCornerLeftWidth,
					   sourceCornerTopHeight,
					   corners.topLeft, 0, 0, 0,  
					   smoothing );
						 				
			// top right
			drawPiece( g, 
					   xright,
					   ytop, 
					   targetCornerRightWidth, 
					   targetCornerTopHeight, 
					   scale9Grid.right, 
					   0, 
					   sourceCornerRightWidth,
					   sourceCornerTopHeight,
					   0,  corners.topRight, 0, 0, smoothing );
				
			// bottom left			 				
			drawPiece( g, 
					   xleft, 
					   ybottom, 
					   targetCornerLeftWidth, 
					   targetCornerBottomHeight, 
					   0, 
					   scale9Grid.bottom,
					   sourceCornerLeftWidth,
					   sourceCornerBottomHeight,
					   0, 0, corners.bottomLeft, 0, smoothing );
					 							 				
			// bottom right			 				
			drawPiece( g, 
					   xright, 
					   ybottom,
					   targetCornerRightWidth, 
					   targetCornerBottomHeight, 
					   scale9Grid.right, 
					   scale9Grid.bottom, 
					   sourceCornerRightWidth,
					   sourceCornerBottomHeight, 
					   0, 0, 0, corners.bottomRight, smoothing );
						  
			if( targetStretchWidth > 0 )
			{
				// top stretch
				drawPiece( g,
						   xleft + targetCornerLeftWidth,
						   ytop, 
						   targetStretchWidth, 
						   targetCornerTopHeight, 
						   sourceCornerLeftWidth,
						   0, 
						   sourceStretchWidth,
						   sourceCornerTopHeight,
						   0,0,0,0,
					 	   smoothing );
							 				
				// bottom stretch
				drawPiece( g, 
						   xleft + targetCornerLeftWidth,
						   ybottom,
						   targetStretchWidth, 
						   targetCornerBottomHeight,
						   sourceCornerLeftWidth,
						   scale9Grid.bottom, 
						   sourceStretchWidth,
						   sourceCornerBottomHeight,
						   0,0,0,0,
					  	   smoothing );
			}
			
			if( targetStretchHeight > 0 )
			{	
				// left stretch
				drawPiece( g, 
						   xleft, 
						   ytop + targetCornerTopHeight,
						   targetCornerLeftWidth,
						   targetStretchHeight,
						   0, 
						   sourceCornerTopHeight,
						   sourceCornerLeftWidth,
						   sourceStretchHeight,
						   0,0,0,0,
					 	   smoothing );
				// right stretch
				drawPiece( g, 
						   xright,
						   ytop + targetCornerTopHeight,
						   targetCornerLeftWidth,
						   targetStretchHeight,
						   scale9Grid.right, 
						   sourceCornerTopHeight, 
						   sourceCornerLeftWidth,
						   sourceStretchHeight,
						   0,0,0,0,
					 	   smoothing );
			}
			
			if( targetStretchHeight > 0 && targetStretchWidth > 0 )
			{
				//center stretch
				drawPiece( g, 
						   xleft + targetCornerLeftWidth,
						   ytop + targetCornerTopHeight,
						   targetStretchWidth, 
						   targetStretchHeight,
						   sourceCornerLeftWidth, 
						   sourceCornerTopHeight, 
						   sourceStretchWidth,
						   sourceStretchHeight,
						   0,0,0,0,
						   smoothing );
			}
		}
		private var mat : Matrix = new Matrix();
		public function drawPiece ( g : Graphics, 
									targetX : Number,
									targetY : Number,
									targetWidth : Number,
									targetHeight : Number,
									sourceX : Number,
									sourceY : Number,
									sourceWidth : Number,
									sourceHeight : Number,
									ulradius : Number = 0,
									urradius : Number = 0,
									blradius : Number = 0,
									brradius : Number = 0,
								    smoothing : Boolean = false ) : void
		{
			var rw : Number = targetWidth / sourceWidth;
			var rh : Number = targetHeight / sourceHeight;
			
			mat.identity();
			mat.scale( rw, rh );
			mat.translate( targetX - sourceX * rw, 
						   targetY - sourceY * rh );
			
			g.beginBitmapFill( bitmap, mat, false, smoothing );
			g.drawRoundRectComplex( targetX, targetY, targetWidth, targetHeight, ulradius, urradius, blradius, brradius );
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
