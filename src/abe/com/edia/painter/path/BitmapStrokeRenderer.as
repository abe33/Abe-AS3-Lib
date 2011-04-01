package abe.com.edia.painter.path 
{
	import abe.com.mon.logs.Log;
	import abe.com.mon.geom.Path;
	import abe.com.mon.utils.PointUtils;

	import flash.display.BitmapData;
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
		public var currentProceedLength : Number; 		public var pathLength : Number; 
	
		public function BitmapStrokeRenderer ( bitmapData : BitmapData, lineWidth : Number = 1 ) 
		{
			this.bitmapData = bitmapData;
			this.lineWidth = lineWidth;
		}
		public function beforePaint ( path : Path, on : Graphics ) : void 
		{
			currentProceedLength = 0; 
			pathLength = path.length;
		}
		public function afterPaint ( path : Path, on : Graphics ) : void 
		{
			currentProceedLength = 0;
		}
		public function paint ( path : Path, on : Graphics, from : Point, to : Point, fromPathPos : Number, toPathPos : Number ) : void
		{
			var v : Point = to.subtract( from );
			var a : Number = Math.atan2(v.y, v.x);
			var aa : Number = a + Math.PI/2;
			var pj : Point = PointUtils.getProjection( aa, lineWidth/2 );
			var ppj : Point = PointUtils.getProjection( a, currentProceedLength );
			
			currentProceedLength += ( toPathPos - fromPathPos ) * pathLength;
			
			var r : Number = lineWidth / bitmapData.height;
			var m : Matrix = new Matrix();
			m.createBox( r,r, a, from.x + pj.x - ppj.x, from.y + pj.y - ppj.y );
			
			var pj1 : Point = path.getTangentAt( fromPathPos ); 			var pj2 : Point = path.getTangentAt( toPathPos ); 
			
			pj1.normalize( lineWidth /2 );			pj2.normalize( lineWidth /2 );
			
			pj1 = PointUtils.rotate(pj1, Math.PI /2);			pj2 = PointUtils.rotate(pj2, Math.PI /2);
			
			on.beginBitmapFill( bitmapData, m, true, true );
			on.moveTo(from.x-pj1.x, from.y-pj1.y);
			on.lineTo(to.x-pj2.x, to.y-pj2.y);			on.lineTo(to.x+pj2.x, to.y+pj2.y);			on.lineTo(from.x+pj1.x, from.y+pj1.y);			on.lineTo(from.x-pj1.x, from.y-pj1.y);
			on.endFill();
		}
	}
}
