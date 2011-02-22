package abe.com.ponents.tools
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.dm;
	import abe.com.mon.geom.pt;
	import abe.com.ponents.utils.Insets;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class ShapeCrop extends BitmapCrop
	{
		protected var _shapeMask : BitmapData;
		protected var _shapePreview : Shape;

		public function ShapeCrop ( bitmap : BitmapData = null,
								   outputSize : Dimension = null )
		{
			super ( bitmap, outputSize );
			_shapePreview = new Shape ();
			_shapePreview.blendMode = BlendMode.DARKEN;
			_shapePreview.alpha= .5;
			addChildAt ( _shapePreview, 2 );
		}
		public function get shapeMask () : BitmapData { return _shapeMask; }
		public function set shapeMask ( shapeMask : BitmapData ) : void
		{
			_shapeMask = shapeMask;
			outputSize = dm( _shapeMask.width, _shapeMask.height );
		}
		override protected function drawSourceRect () : void
		{
			super.drawSourceRect ();
			if( _shapeMask )
			{
				var r : Rectangle;
				var rx : Number = _bitmapContainer.scaleX;
				var ry : Number = _bitmapContainer.scaleY;
				var insets : Insets = style.insets;

				r = new Rectangle ( (insets.left - _bitmapContainer.x) / rx,
									( insets.top - _bitmapContainer.y ) / ry,
									( width - insets.horizontal ) / rx,
									( height - insets.vertical ) / ry
								  );
				_shapePreview.scrollRect = r;

				_shapePreview.scaleX = _shapePreview.scaleY = _bitmapContainer.scaleX;

				var sx : Number = _shapeMask.width / _sourceRect.width;				var sy : Number = _shapeMask.height / _sourceRect.height;
				var m : Matrix = new Matrix ();
				m.createBox ( 1/sx, 1/sy, _sourceRect.rotation, _sourceRect.x, _sourceRect.y );

				var p1 : Point = _sourceRect.topLeft;
				var p2 : Point = _sourceRect.topRight;
				var p3 : Point = _sourceRect.bottomRight;
				var p4 : Point = _sourceRect.bottomLeft;
				var g : Graphics = _shapePreview.graphics;

				g.clear();
				g.lineStyle();
				g.beginBitmapFill ( _shapeMask, m, false );
				g.moveTo(p1.x,p1.y);				g.lineTo(p2.x,p2.y);				g.lineTo(p3.x,p3.y);				g.lineTo(p4.x,p4.y);				g.lineTo(p1.x,p1.y);
				g.endFill();
			}
		}

		override public function updateOutput () : void
		{
			super.updateOutput ();
			if( _shapeMask )
				_output.copyChannel ( _shapeMask, _shapeMask.rect, pt (), BitmapDataChannel.RED, BitmapDataChannel.ALPHA );
		}
	}
}
