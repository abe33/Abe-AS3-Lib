package abe.com.mon.geom.transforms 
{
	import abe.com.mon.geom.Geometry;
	/**
	 * A <code>GeometryTransform</code> object takes a <code>Geometry</code>, and realize a transformation
	 * on its points according to the implementation specificities. For instance an implementation can choose
	 * to produces its own series of coordinates from a given geometry, then perform the transformation and
	 * returns a <code>Polygon</code> object which represent the transformation result.
	 * 
	 * @author Cédric Néhémie 
	 */
	public interface GeometryTransform 
	{
		function transform( geom : Geometry ) : Geometry;
	}
}
