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
			renderer.beforePaint(path, on);			for( var i : uint = 0; i < bias; i++ )
			{
				var pos1 : Number = i / bias;				var pos2 : Number = ( i+1 ) / bias;
				var p1 : Point = path.getPathPoint( pos1 );
				var p2 : Point = path.getPathPoint( pos2 );				renderer.paint(on, p1, p2, pos1, pos2);
			}
			renderer.afterPaint(path, on);
		}
	}
}
