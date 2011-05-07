package abe.com.edia.fx.painters 
{
	import abe.com.mon.geom.Path;
	/**
	 * @author cedric
	 */
	public class PathPainter implements Painter 
	{
		protected var _path : Path;

		public function PathPainter ( path : Path ) 
		{
			_path = path;
		}
	}
}
