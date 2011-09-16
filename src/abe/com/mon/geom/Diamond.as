package abe.com.mon.geom
{
    import abe.com.mon.utils.GeometryUtils;
    import abe.com.mon.utils.MathUtils;
    import abe.com.mon.utils.PointUtils;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Copyable;
    import abe.com.mon.core.Equatable;
    import abe.com.mon.core.FormMetaProvider;
    import abe.com.mon.core.Randomizable;
    import abe.com.mon.core.Serializable;
    import abe.com.mon.randoms.Random;

    import flash.display.Graphics;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    [Serialize(constructorArgs="x, y, leftDistance, upperDistance, rightDistance, bottomDistance, rotation, randomSource,pathBasedOnLength")]
    public class Diamond implements Geometry, 
                                    ClosedGeometry, 
    								Path, 
                                    Surface, 
                                    FormMetaProvider, 
                                    Serializable, 
                                    Copyable, 
                                    Cloneable, 
                                    Equatable, 
                                    Randomizable
    {
        
        public var x : Number;
        public var y : Number;
        public var leftDistance : Number;
        public var upperDistance : Number;
        public var rightDistance : Number;
        public var bottomDistance : Number;
        public var rotation : Number;
        public var pathBasedOnLength : Boolean;
        
        protected var _randomSource : Random;
        
        public function Diamond ( x : Number = 0, 
        						  y : Number = 0, 
                                  leftDistance : Number = 1,
                                  upperDistance : Number = 1,
                                  rightDistance : Number = 1,
                                  bottomDistance : Number = 1,
                                  rotation : Number = 0,
                                  random : Random = null,
                                  pathBasedOnLength : Boolean = false
                                )
        {
            this.x = x;
            this.y = y;
            this.upperDistance = upperDistance;
            this.leftDistance = leftDistance;
            this.bottomDistance = bottomDistance;
            this.rightDistance = rightDistance;
            this.rotation = rotation;
            this.pathBasedOnLength = pathBasedOnLength;
            
            _randomSource = random ? random : RandomUtils;
        }
        
        public function get upperCorner () : Point {
            var p : Point = pt( 0, -upperDistance );
            p = PointUtils.rotate(p, rotation);
            p.x += x;
            p.y += y;
            return p;
        }
        public function get leftCorner () : Point {
            var p : Point = pt( -leftDistance );
            p = PointUtils.rotate(p, rotation);
            p.x += x;
            p.y += y;
            return p;
        }
        public function get bottomCorner () : Point {
            var p : Point = pt( 0, bottomDistance );
            p = PointUtils.rotate(p, rotation);
            p.x += x;
            p.y += y;
            return p;
        }
        public function get rightCorner () : Point {
            var p : Point = pt( rightDistance );
            p = PointUtils.rotate(p, rotation);
            p.x += x;
            p.y += y;
            return p;
        }
        public function get upperLeftQuadrant():Triangle { return new Triangle(pt(x,y), upperCorner, leftCorner ); }
        public function get upperRightQuadrant():Triangle { return new Triangle(pt(x,y), upperCorner, rightCorner ); }
        public function get bottomLeftQuadrant():Triangle { return new Triangle(pt(x,y), bottomCorner, leftCorner ); }
        public function get bottomRightQuadrant():Triangle { return new Triangle(pt(x,y), bottomCorner, rightCorner ); }
        
        public function get upperRightEdge():Point { return rightCorner.subtract(upperCorner); } 
        public function get bottomRightEdge():Point { return bottomCorner.subtract(rightCorner); } 
        public function get bottomLeftEdge():Point { return leftCorner.subtract(bottomCorner); } 
        public function get upperLeftEdge():Point { return upperCorner.subtract(leftCorner); } 
        
		public function get length () : Number 
        { 
            return Point.distance( leftCorner, 	upperCorner ) + 
            	   Point.distance( rightCorner, upperCorner ) +
                   Point.distance( leftCorner, 	bottomCorner ) +
                   Point.distance( rightCorner, bottomCorner ); 
        }
        public function get points () : Array { return [ leftCorner, upperCorner, rightCorner, bottomCorner, leftCorner ]; }
        public function get acreage () : Number 
        { 
            return upperLeftQuadrant.acreage + 
            	   bottomLeftQuadrant.acreage + 
                   upperRightQuadrant.acreage + 
                   bottomRightQuadrant.acreage;
        }
        public function get randomSource () : Random { return _randomSource; }
        public function set randomSource ( randomSource : Random ) : void { _randomSource = randomSource; }
        
		public function getPathPoint ( path : Number ) : Point
        {
            if(pathBasedOnLength)
            {
                var l1 : Number = upperRightEdge.length;
                var l2 : Number = bottomRightEdge.length;
                var l3 : Number = bottomLeftEdge.length;
                var l4 : Number = upperLeftEdge.length;
                var l : Number = l1+l2+l3+l4;
                
                var r1 : Number = l1/l;
                var r2 : Number = l2/l;
                var r3 : Number = l3/l;
                var r4 : Number = l4/l;
                
                if( path < r1)
                	return upperCorner.add( PointUtils.scaleNew( upperRightEdge,  path / r1 ) );
                else if( path < r1+r2)
                	return rightCorner.add( PointUtils.scaleNew( bottomRightEdge, ( path -r1 ) / r2 ) );
                else if( path < r1+r2+r3 )
                	return bottomCorner.add( PointUtils.scaleNew( bottomLeftEdge, ( path -r1-r2 )/r3 ) );
                else
                	return leftCorner.add( PointUtils.scaleNew( upperLeftEdge, ( path -r1-r2-r3 ) /r4 ) );
            }
            else
            {
                if( path < 1/4 )
                	return upperCorner.add( PointUtils.scaleNew( upperRightEdge, path * 4 ) );
                else if( path < 1/2)
                	return rightCorner.add( PointUtils.scaleNew( bottomRightEdge, ( path-1/4 ) * 4 ) );
                else if( path < 3/4 )
                	return bottomCorner.add( PointUtils.scaleNew( bottomLeftEdge, ( path-2/4 ) * 4) );
                else
                	return leftCorner.add( PointUtils.scaleNew( upperLeftEdge, ( path-3/4 ) * 4 ) );
            }
        }

        public function getPathOrientation ( path : Number ) : Number
        {
            var p : Point = getTangentAt( path );
            return Math.atan2( p.y, p.x );
        }

        public function getTangentAt ( pos : Number, posDetail : Number = 0.01 ) : Point
        {
            var p1 : Point = getPathPoint(pos-0.001);
            var p2 : Point = getPathPoint(pos+0.001);
            var d : Point = p2.subtract(p1);
            return d; 
        }
        public function getPointAtAngle ( a : Number ) : Point
        {
            var maxD : Number = MathUtils.max( 
            	upperDistance,
                rightDistance,
                leftDistance,
                bottomDistance
            ) + 50 ;
            var a2:Number = a - rotation;
            var r : Number = a2 / (Math.PI * 2);
            var proj : Point = tmpPt( Math.cos( a ) * maxD, Math.sin( a ) * maxD );
            var pref : Point;
            var pvec : Point;
            if( r < 1/4 )
            {
                pref = upperCorner;
                pvec = upperRightEdge;
            }
            else if( r < 2/4 )
            {
                pref = rightCorner;
                pvec = bottomRightEdge;
            }
            else if( r < 3/4 )
            {
                pref = bottomCorner;
                pvec = bottomLeftEdge;
            }
            else
            {
                pref = leftCorner;
                pvec = upperLeftEdge;
            }
            
            return GeometryUtils.perCrossing(pt(x,y), proj, pref, pvec);
        }
        public function getRandomPointInSurface () : Point
        {
            var q1 : Triangle = upperRightQuadrant;
            var q2 : Triangle = bottomRightQuadrant;
            var q3 : Triangle = bottomLeftQuadrant;
            var q4 : Triangle = upperLeftQuadrant;
            
            var a1 : Number = q1.acreage;
            var a2 : Number = q2.acreage;
            var a3 : Number = q3.acreage;
            var a4 : Number = q4.acreage;
            var a : Number = a1+a2+a3+a4;
            
            var l1 : Number = a1/a;
            var l2 : Number = a2/a;
            var l3 : Number = a3/a;
            var l4 : Number = a4/a;
            
            var n : Number = _randomSource.random();
            
            if( n < l1 )
            	return q1.getRandomPointInSurface();
            else if( n < l1+l2 )
            	return q2.getRandomPointInSurface();
            else if( n < l1+l2+l3 )
            	return q3.getRandomPointInSurface();
            else
            	return q4.getRandomPointInSurface();            	 
        }
        
		public function copyTo ( o : Object ) : void
        {
            o["x"] = x;
            o["y"] = y;
            o["upperDistance"] = upperDistance;
            o["leftDistance"] = leftDistance;
            o["rightDistance"] = rightDistance;
            o["bottomDistance"] = bottomDistance;
            o["rotation"] = rotation;
        }
        
        public function copyFrom ( o : Object ) : void
        {
            x = o["x"];
            y = o["y"];
            upperDistance = o["upperDistance"];
            leftDistance = o["leftDistance"];
            rightDistance = o["rightDistance"];
            bottomDistance = o["bottomDistance"];
            rotation = o["rotation"];
        }
        
        public function clone () : *
        {
            return new Diamond(x, y, leftDistance, upperDistance, rightDistance, bottomDistance, rotation, _randomSource );
        }

        public function draw ( g : Graphics, c : Color ) : void
        {
            g.lineStyle( 0, c.hexa, c.alpha / 255 );
            g.moveTo( upperCorner.x , upperCorner.y);
            g.lineTo( rightCorner.x , rightCorner.y);
            g.lineTo( bottomCorner.x , bottomCorner.y);
            g.lineTo( leftCorner.x , leftCorner.y);
            g.lineTo( upperCorner.x , upperCorner.y);
            g.lineStyle();
        }

        public function fill ( g : Graphics, c : Color ) : void
        {
            g.beginFill( c.hexa, c.alpha / 255 );
            g.moveTo( upperCorner.x , upperCorner.y);
            g.lineTo( rightCorner.x , rightCorner.y);
            g.lineTo( bottomCorner.x , bottomCorner.y);
            g.lineTo( leftCorner.x , leftCorner.y);
            g.lineTo( upperCorner.x , upperCorner.y);
            g.endFill();
        }
        
		public function containsPoint ( p : Point ) : Boolean
        {
            return false;
        }

        public function contains ( x : Number, y : Number ) : Boolean
        {
            return false;
        }

        public function containsGeometry ( geom : Geometry ) : Boolean
        {
            return false;
        }
        public function intersectGeometry ( geom : Geometry ) : Boolean
        {
            return false;
        }

        public function intersections ( geom : Geometry ) : Array
        {
            return null;
        }

        public function equals ( o : * ) : Boolean
        {
            return false;
        }
    }
}
