package abe.com.edia.painter.path 
{
	import abe.com.mon.geom.Path;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class PathPainter 
	{
		public function paint( path : Path, on : Graphics, renderer : PathRenderer, bias : uint = 15 ) : void
		{
			renderer.beforePaint(path, on);
			{
				var pos1 : Number = i / bias;
				
				var p1 : Point = path.getPathPoint( pos1 );
				var p2 : Point = path.getPathPoint( pos2 );
			}
			renderer.afterPaint(path, on);
		}
	}
}