package aesia.com.motion
{
	import aesia.com.mon.geom.Path;
	import aesia.com.mon.utils.MathUtils;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	public class PathTween extends SingleTween
	{
		protected var _pathPosition : Number;		protected var _path : Path;
		protected var _targetDisplayObject : DisplayObject;
		protected var _alignObject : Boolean;

		public function PathTween ( target : DisplayObject,
									path : Path,
									duration : Number = 1000,
									alignObject : Boolean = true,
									endValue : Number = 1,
									startValue : Number = 0,
									easing : Function = null)
		{
			_path = path;
			_targetDisplayObject = target;
			_pathPosition = 0;
			_alignObject = alignObject;

			super( this,
				   "pathPosition",
				   MathUtils.restrict( endValue, 0, 1),
				   duration,
				   MathUtils.restrict( startValue, 0, 1),
				   easing );
		}
		public function get pathPosition () : Number { return _pathPosition; }
		public function set pathPosition (pathPosition : Number) : void
		{
			_pathPosition = pathPosition;
			var p : Point = _path.getPathPoint(_pathPosition);
			if( _alignObject )
			{
				var n : Number = _path.getPathOrientation( _pathPosition );
				_targetDisplayObject.rotation = MathUtils.rad2deg( n );			}
			_targetDisplayObject.x = p.x;			_targetDisplayObject.y = p.y;
		}
		public function get path () : Path { return _path; }
		public function set path (path : Path) : void
		{
			_path = path;
		}

		override public function get target () : Object { return _targetDisplayObject; }
		override public function set target (targetDisplayObject : Object) : void
		{
			_targetDisplayObject = targetDisplayObject as DisplayObject;
		}


		override public function reset () : void
		{
			_pathPosition = 0;
			super.reset( );
		}
	}
}
