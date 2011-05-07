package abe.com.mon.geom.transforms 
{
	import abe.com.mon.geom.Geometry;
	import abe.com.mon.geom.Polygon;
	import abe.com.mon.geom.pt;
	import abe.com.mon.utils.PointUtils;

	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class Roundify implements GeometryTransform 
	{
		public var transformBias : uint;
		public var strength : Number;
		public var radius : Number;
		public var center : Point;

		public function Roundify ( strength : Number = 1, radius : Number = 100, center : Point = null, transformBias : uint = 24 ) 
		{
			this.transformBias = transformBias;
			this.strength = strength;
			this.radius = radius;
			this.center = center ? center : pt();
		}
		public function transform (geom : Geometry) : Geometry
		{
			var points : Array = [];			var points2 : Array = [];
			for( var i : uint = 0; i < transformBias; i++ )
				points.push( geom.getPathPoint( i / transformBias ) );
			
			for each( var p : Point in points )
			{
				var dif : Point = p.subtract( center );
				var a : Number = Math.atan2( dif.y, dif.x );
				var pj : Point = PointUtils.getProjection(a, radius);
				points2.push( center.add( PointUtils.interpolate( dif, pj, strength ) ) );
			}
			
			return new Polygon( points2 );
		}
	}
}
