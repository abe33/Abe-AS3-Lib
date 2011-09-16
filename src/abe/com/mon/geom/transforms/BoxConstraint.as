package abe.com.mon.geom.transforms
{
    import abe.com.mon.geom.Geometry;
    import abe.com.mon.geom.Polygon;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * @author cedric
     */
    public class BoxConstraint implements GeometryTransform
    {
        public var rectangle : Rectangle;
        public function BoxConstraint ( r : Rectangle )
        {
            rectangle = r;
        }

        public function transform ( geom : Geometry ) : Geometry
        {
            var pts : Array = geom.points;
            pts.pop();
            
            for each( var p : Point in pts )
            {
                if( p.x < rectangle.left )
                	p.x = rectangle.left;
                else if( p.x > rectangle.right )
                	p.x = rectangle.right;
                
                if( p.y < rectangle.top )
                	p.y = rectangle.top;
                else if( p.y > rectangle.bottom )
                	p.y = rectangle.bottom;
            }
            
            return new Polygon( pts );
        }
    }
}
