package abe.com.edia.painter.path 
{
	import abe.com.mon.geom.Path;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public interface PathRenderer 
	{
		function beforePaint( path : Path, on : Graphics ) : void;		function afterPaint( path : Path, on : Graphics ) : void;
		function paint( path : Path, on : Graphics, from : Point, to : Point, fromPathPos : Number, toPathPos : Number ) : void;
	}
}
