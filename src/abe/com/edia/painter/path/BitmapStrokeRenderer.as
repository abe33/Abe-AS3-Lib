package abe.com.edia.painter.path 
{
	import abe.com.mon.geom.Path;
	import abe.com.mon.utils.PointUtils;

	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class BitmapStrokeRenderer implements PathRenderer 
	{
		public var bitmapData : BitmapData;		
		public var lineWidth : Number;
	
		public function BitmapStrokeRenderer ( bitmapData : BitmapData, lineWidth : Number = 1 ) 
		{
			this.bitmapData = bitmapData;
			this.lineWidth = lineWidth;
		}
		public function beforePaint ( path : Path, on : Graphics ) : void 
		{
			on.lineStyle(lineWidth, 0, 1, true, "normal", CapsStyle.NONE );
		}
		public function afterPaint ( path : Path, on : Graphics ) : void {}
		
		public function paint (on : Graphics, from : Point, to : Point, fromPathPos : Number, toPathPos : Number) : void
		{
			var v : Point = to.subtract( from );
			var a : Number = Math.atan2(v.y, v.x);
			var a2 : Number = a + Math.PI/2;
			var pj : Point = PointUtils.getProjection( a2, lineWidth/2 );
			
			var r : Number = lineWidth / bitmapData.height;
			var m : Matrix = new Matrix();
			m.createBox( r,r, a, from.x + pj.x, from.y + pj.y );
			on.lineBitmapStyle( bitmapData, m, true, true );
			on.moveTo(from.x, from.y);
			on.lineTo(to.x, to.y);
		}
	}
}
