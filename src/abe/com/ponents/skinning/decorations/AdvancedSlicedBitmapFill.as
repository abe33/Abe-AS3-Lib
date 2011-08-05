/**
 * @license
 */
package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.utils.magicClone;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class AdvancedSlicedBitmapFill implements ComponentDecoration
	{
		static public const STANDARD_REPEAT_BOX : Array = [ {h:'stretch', v:'stretch'}, {h:'tile', v:'stretch'}, {h:'stretch', v:'stretch'},
															{h:'stretch', v:'tile'},	{h:'tile', v:'tile'},    {h:'stretch', v:'tile'},
															{h:'stretch', v:'stretch'}, {h:'tile', v:'stretch'}, {h:'stretch', v:'stretch'} ];
		
		static public const STANDARD_STRETCH_BOX : Array = [ {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'},
															 {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'},
															 {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'}, {h:'stretch', v:'stretch'} ];
		
		
		protected var _scale9grid : Rectangle;		protected var _scale9rules : Array;
		protected var _bitmap : BitmapData;
		
		protected var upperLeftBitmap : BitmapData;		protected var upperRightBitmap : BitmapData;		protected var lowerleftBitmap : BitmapData;		protected var lowerRightBitmap : BitmapData;		protected var upperTileBitmap : BitmapData;		protected var lowerTileBitmap : BitmapData;		protected var leftTileBitmap : BitmapData;		protected var rightTileBitmap : BitmapData;		protected var centerTileBitmap : BitmapData;
		

		public function AdvancedSlicedBitmapFill ( bitmap : BitmapData = null, scale9Grid : Rectangle = null, scale9rules : Array = null )
		{
			this._bitmap = bitmap ? bitmap : new BitmapData(16, 16, false, 0 );
			this._scale9grid = scale9Grid ? scale9Grid : new Rectangle( 1, 1, this.bitmap.width-2, this.bitmap.height - 2);
			this._scale9rules = scale9rules ? scale9rules : magicClone( STANDARD_STRETCH_BOX );
			
			createSlices ();
		}
		
		public function clone () : *
		{
			return new AdvancedSlicedBitmapFill( _bitmap.clone(), _scale9grid.clone(), magicClone(_scale9rules ) );
		}
		public function equals (o : *) : Boolean
		{
			if( o is AdvancedSlicedBitmapFill )
			{
				
			}
			return false;
		}
		
		public function get scale9grid () : Rectangle {	return _scale9grid;	}		
		public function set scale9grid (scale9grid : Rectangle) : void
		{
			if( upperLeftBitmap )
				cleanSlices();
				
			_scale9grid = scale9grid;
			createSlices();
		}
		
		public function get scale9rules () : Array { return _scale9rules; }		
		public function set scale9rules (scale9rules : Array) : void
		{
			if( upperLeftBitmap )
				cleanSlices();
				
			_scale9rules = scale9rules;
			createSlices();
		}
		
		public function get bitmap () : BitmapData { return _bitmap; }		
		public function set bitmap (bitmap : BitmapData) : void
		{
			if( upperLeftBitmap )
				cleanSlices();
				
			_bitmap = bitmap;
			createSlices();
		}
		
		public function cleanSlices () : void
		{
			upperLeftBitmap.dispose();
			upperRightBitmap.dispose();
			upperTileBitmap.dispose();
			lowerleftBitmap.dispose();
			lowerRightBitmap.dispose();
			lowerTileBitmap.dispose();
			leftTileBitmap.dispose();
			rightTileBitmap.dispose();
			centerTileBitmap.dispose();
			
			upperLeftBitmap = null;
			upperRightBitmap = null;
			upperTileBitmap = null;
			lowerleftBitmap = null;
			lowerRightBitmap = null;
			lowerTileBitmap = null;
			leftTileBitmap = null;
			rightTileBitmap = null;
			centerTileBitmap = null;
		}

		public function createSlices () : void
		{
			upperLeftBitmap = sliceBitmap( new Rectangle( 0,
														  0, 
														  _scale9grid.left, 
														  _scale9grid.top ), 
										   _bitmap );
						upperRightBitmap = sliceBitmap( new Rectangle( _scale9grid.right, 
														   0, 
														   _bitmap.width - _scale9grid.right, 
														   _scale9grid.top ), 
											_bitmap );
						lowerRightBitmap = sliceBitmap( new Rectangle( _scale9grid.right, 
														   _scale9grid.bottom, 
														   _bitmap.width - _scale9grid.right, 
														   _bitmap.height - _scale9grid.bottom ), 
											_bitmap );
														lowerleftBitmap = sliceBitmap( new Rectangle( 0,
														   _scale9grid.bottom,
														   _scale9grid.left,
														   _bitmap.height - _scale9grid.bottom ),
											_bitmap );
			leftTileBitmap = sliceBitmap( new Rectangle( 0,
														 _scale9grid.top, 
														 _scale9grid.left, 
														 _scale9grid.bottom - _scale9grid.top ), 
										  _bitmap );
										  			rightTileBitmap = sliceBitmap( new Rectangle( _scale9grid.right, 
														  _scale9grid.top, 
														  _bitmap.width - _scale9grid.right, 
														  _scale9grid.bottom - _scale9grid.top ),
										   _bitmap );
										   			upperTileBitmap = sliceBitmap( new Rectangle( _scale9grid.left, 
														  0, 
														  _scale9grid.right - _scale9grid.left, 
														  _scale9grid.top ), 
										   _bitmap );
										   			lowerTileBitmap = sliceBitmap( new Rectangle( _scale9grid.left, 
														  _scale9grid.bottom, 
														  _scale9grid.right - _scale9grid.left, 
														  _bitmap.height - _scale9grid.bottom ), 
										   _bitmap );
										   
			centerTileBitmap = sliceBitmap( new Rectangle( _scale9grid.left, 
														   _scale9grid.top, 
														   _scale9grid.right - _scale9grid.left, 
														   _scale9grid.bottom - _scale9grid.top ), 
										    _bitmap );		}
		public function draw ( r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false ) : void
		{
			corners = corners ? corners : new Corners();
			var sourceCornersWidth : Number = upperLeftBitmap.width + upperRightBitmap.width;
			var sourceCornersHeight : Number = upperLeftBitmap.height + lowerleftBitmap.height;
			
			var targetCornerLeftWidth : Number = upperLeftBitmap.width;
			var targetCornerRightWidth : Number = upperRightBitmap.width;
			var targetCornerTopHeight : Number = upperLeftBitmap.height;
			var targetCornerBottomHeight : Number = lowerleftBitmap.height;
			
			var rate : Number;
			if( sourceCornersWidth > r.width ) 
			{
				rate = r.width / sourceCornersWidth;	
				targetCornerLeftWidth = upperLeftBitmap.width * rate;
				targetCornerRightWidth = upperRightBitmap.width * rate;
			}			
			if( sourceCornersHeight > r.height ) 
			{
				rate = r.height / sourceCornersHeight;	
				targetCornerTopHeight = upperLeftBitmap.height * rate;
				targetCornerBottomHeight = lowerleftBitmap.height * rate;
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
					   upperLeftBitmap,
					   _scale9rules[0],
					   corners.topLeft, 0, 0, 0, smoothing );
						 				
			// top right
			drawPiece( g, 
					   xright,
					   ytop, 
					   targetCornerRightWidth, 
					   targetCornerTopHeight, 
					   upperRightBitmap,
					   _scale9rules[2],
					   0,corners.topRight, 0, 0, smoothing );
				
			// bottom left			 				
			drawPiece( g, 
					   xleft, 
					   ybottom, 
					   targetCornerLeftWidth, 
					   targetCornerBottomHeight, 
					   lowerleftBitmap,
					   _scale9rules[6],
					   0,0,corners.bottomLeft, 0, smoothing );
					 							 				
			// bottom right			 				
			drawPiece( g, 
					   xright, 
					   ybottom,
					   targetCornerRightWidth, 
					   targetCornerBottomHeight, 
					   lowerRightBitmap,
					   _scale9rules[8],
					   0,0,0,corners.bottomRight, smoothing );
						  
			if( targetStretchWidth > 0 )
			{
				// top stretch
				drawPiece( g,
						   xleft + targetCornerLeftWidth,
						   ytop, 
						   targetStretchWidth, 
						   targetCornerTopHeight, 
						   upperTileBitmap,
					 	   _scale9rules[1],
					 	   0,0,0,0,
					  	   smoothing );
							 				
				// bottom stretch
				drawPiece( g, 
						   xleft + targetCornerLeftWidth,
						   ybottom,
						   targetStretchWidth, 
						   targetCornerBottomHeight,
						   lowerTileBitmap,
					  	   _scale9rules[7],
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
						   leftTileBitmap,
					 	   _scale9rules[3],
					 	   0,0,0,0,
					   	   smoothing );
				// right stretch
				drawPiece( g, 
						   xright,
						   ytop + targetCornerTopHeight,
						   targetCornerLeftWidth,
						   targetStretchHeight,
						   rightTileBitmap,
					 	   _scale9rules[5],
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
						   centerTileBitmap,
						   _scale9rules[4],
						   0,0,0,0,
					   	   smoothing );
			}
		}
		protected function sliceBitmap ( rsource : Rectangle, bitmap : BitmapData ) : BitmapData
		{
			var b : BitmapData = new BitmapData( rsource.width, rsource.height, true, 0x00000000 );
			b.copyPixels( bitmap, rsource, new Point(), null, null, true );
			return b;
		}
		private var mat : Matrix = new Matrix();	
		protected function drawPiece (  g : Graphics, 
										targetX : Number,
										targetY : Number,
										targetWidth : Number,
										targetHeight : Number,
										bitmap : BitmapData,
										rules : Object,
										ulradius : Number = 0,
										urradius : Number = 0,
										blradius : Number = 0,
										brradius : Number = 0,
									    smoothing : Boolean = false ) : void
		{
			var rw : Number;
			var rh : Number;
			
			mat.identity();
			
			if( rules.h == "stretch" )
				rw = targetWidth / bitmap.width;
			else
				rw = 1;
			
			if( rules.v == "stretch" )
				rh = targetHeight / bitmap.height;
			else
				rh = 1;
			
			mat.scale( rw, rh );
			mat.translate( targetX, 
						   targetY );
			
			g.beginBitmapFill( bitmap, mat, true, smoothing );
			g.drawRoundRectComplex( targetX, targetY, targetWidth, targetHeight, ulradius, urradius, blradius, brradius );
			g.endFill( );
		}
		
		public function toSource () : String
		{
			// TODO: Auto-generated method stub
			return null;
		}
		
		public function toReflectionSource () : String
		{
			// TODO: Auto-generated method stub
			return null;
		}
	}
}
