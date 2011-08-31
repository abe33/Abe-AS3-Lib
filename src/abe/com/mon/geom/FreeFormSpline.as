package abe.com.mon.geom
{
    import abe.com.mon.logs.Log;
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Serializable;
    import abe.com.mon.utils.GeometryUtils;
    import abe.com.mon.utils.MathUtils;
    import abe.com.mon.utils.arrays.firstIn;
    import abe.com.mon.utils.arrays.lastIn;
    import abe.com.mon.utils.magicClone;
    import abe.com.mon.utils.magicToReflectionSource;
    import abe.com.mon.utils.magicToSource;
    import abe.com.patibility.lang._$;

    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class FreeFormSpline implements Spline, Path, Geometry, Cloneable, Serializable
    {	
        protected var _vertices : Array;
        protected var _bias : Number;
        
        protected var _length : Number;
        protected var _pathBasedOnLength : Boolean;
        protected var _pathPoints : Array;
        protected var _pathLengths : Array;
        
        public var smoothCurvature : Number = .25;
        
        public function FreeFormSpline ( v : Array = null, bias : Number = 20 )
        {
            _vertices = v ? v : [];
            _bias = bias;
        }

        public function get vertices () : Array { return _vertices; }
        public function set vertices ( v : Array ) : void { _vertices = v; }
        
        public function get points () : Array {
            var a : Array = [];
			for( var i : int = 0; i <= _bias;i++)
				a.push ( _getPathPoint( ( i / _bias ) ) );
			return a;
        }
        public function get length () : Number { return _length;}
        
        public function get isClosedSpline () : Boolean 
        { 
            return _vertices.length >= 2 ? 
        	    ( firstIn(_vertices) as Point).equals(lastIn(_vertices)) : 
                false; 
        }

		public function get numSegments():int { return _vertices.length > 1 ? _vertices.length - 1 : 0; }

		public function get bias () : Number { return _bias; }
        public function set bias ( bias : Number ) : void { _bias = bias; }
        
        public function get pathBasedOnLength () : Boolean { return _pathBasedOnLength; }
        public function set pathBasedOnLength ( pathBasedOnLength : Boolean ) : void 
        { 
            _pathBasedOnLength = pathBasedOnLength;
            if( _pathBasedOnLength )
            {
                updatePathLengthCache();
            }
            else
            {
                _pathLengths = null;
                _pathPoints = null;
            }
        }
        
		public function updateSplineData():void
        {
            if( numSegments > 0 )
            	updatePathLengthCache();
        }

        public function draw ( g : Graphics, c : Color ) : void
        {
            var l : Number = numSegments;
            
            if( l == 0 )
            	return;
                
			var i : Number;

			g.lineStyle(0,c.hexa, c.alpha/255);

			for( i=0; i < l; i++ )
				drawSegment( getSegment( i ), g, c );

			g.lineStyle();

        }
        protected function drawSegment ( seg : Array, g : Graphics, c : Color ) : void
		{
			var l : Number = _bias;
			var step : Number = 1/l;
			var i : Number;

			for( i=1; i <= l; i++ ) 
			{
				var pt1 : Point = getInnerSegmentPoint( ( i - 1 ) * step , seg );
				var pt2 : Point = getInnerSegmentPoint( ( i ) * step , seg );

				g.moveTo( pt1.x, pt1.y );
				g.lineTo( pt2.x, pt2.y );
            }
        }

        public function fill ( g : Graphics, c : Color ) : void
        {
            if( isClosedSpline )
            {
                var l : Number = numSegments;
				var i : Number;

				g.beginFill(c.hexa, c.alpha/255);

				for( i=0; i < l; i++ )
					drawSegment( getSegment( i ), g, c );

				g.endFill();
            }
        }
        
        public function clone () : *
        {
            return new FreeFormSpline( magicClone( _vertices ), _bias );
        }


        public function intersectGeometry ( geom : Geometry ) : Boolean
		{
			return GeometryUtils.geometriesIntersects( this, geom );
		}
		public function intersections ( geom : Geometry ) : Array
		{
			return GeometryUtils.geometriesIntersections( this, geom );
		}
        private function updatePathLengthCache () : void
        {
            _pathLengths = [];
            _pathPoints = points;
            var l : Number = 0;
            for ( var i:int =1; i<_pathPoints.length; i++ )
            {
                var p1 : Point = _pathPoints[i-1];
                var p2 : Point = _pathPoints[i];
                l += Point.distance(p1, p2);
            }
            _length = l;
            _pathLengths.push(0);
            for ( i =1; i<_pathPoints.length; i++ )
            {
                p1 = _pathPoints[i-1];
                p2 = _pathPoints[i];
                _pathLengths.push(Point.distance(p1, p2)/l);
            }
        }

		/**
		 * @inheritDoc
		 */
		public function getPathPoint (path : Number) : Point
		{
            if( _pathBasedOnLength )
            {
                var tp : Number = 0;
                var l : int = _pathLengths.length;
                for(var i : int = 1;i<l;i++)
                {
                    var cp : Number = _pathLengths[i];
                    if( tp + cp > path )
                    {
                        var p1 : Point = _pathPoints[i-1];
                        var p2 : Point = _pathPoints[i];
                        var lr : Number = MathUtils.map( path, tp, tp+cp, 0, 1 );
                        var d : Point = p2.subtract(p1);
                        d.normalize(d.length * lr);
                        return p1.add(d);
                    }                    
                    tp += cp;
                }
                return lastIn( _pathPoints );
            }
            else
	            return _getPathPoint( path );
		}
        protected function _getPathPoint( path : Number ): Point
        {
            var p : Number = path * numSegments;
			var seg : uint = Math.floor( p );

			if( seg == numSegments )
				seg--;

			var inseg : Number = p - seg;
			return getInnerSegmentPoint( inseg, getSegment( seg ) );
        }
        public function getSegment ( n : Number ) : Array
		{
			if( n < numSegments )
				return _vertices.slice( n, n + 2 );
			else
				return null;
		}

		public function getLength ( bias : uint ) : Number
		{
			var l : uint = numSegments;
			_length = 0;
			var i : Number;

			for( i=0; i < l; i++ )
				_length += getSegmentLength ( getSegment( i ), bias );

			return _length;
		}

		protected function getInnerSegmentPoint ( t : Number, seg : Array ) : Point
		{
            var p1 : FreeFormSplineVertex = seg[0];
            var p2 : FreeFormSplineVertex = seg[1];
            var l : Number = Point.distance( p1, p2 ) * smoothCurvature;
            var index : int;
            
            var ph1 : Point;
            var ph2 : Point;
            
            if( p1.type == FreeFormSplineVertex.CORNER )
             	ph1 = p1;   
            else if( p1.type == FreeFormSplineVertex.SMOOTH )
            {
                index = _vertices.indexOf( p1 );
                if( _vertices.indexOf( p1 ) == 0 )
                	ph1 = p1;
                else
                {
                    var d : Point = p2.subtract(_vertices[index-1]);
                    d.normalize(l);
                	ph1 = p1.add(d);
                }
            }
            else
            	ph1 = p1.postHandle;
                
            if( p2.type == FreeFormSplineVertex.CORNER )
            	ph2 = p2;
            else if( p2.type == FreeFormSplineVertex.SMOOTH )
            {
                index = _vertices.indexOf( p2 );
                if( _vertices.indexOf( p2 ) == _vertices.length-1 )
                	ph2 = p2;
                else
                {
                    d = p1.subtract(_vertices[index+1]);
                    d.normalize(l);
                	ph2 = p2.add(d);
                }
            }
            else
            	ph2 = p2.preHandle;
            
			var pt : Point = new Point();
			pt.x = ( p1.x  * b1 ( t ) ) + 
            	   ( ph1.x * b2 ( t ) ) + 
                   ( ph2.x * b3 ( t ) ) + 
                   ( p2.x  * b4 ( t ) );
            
			pt.y = ( p1.y  * b1 ( t ) ) + 
            	   ( ph1.y * b2 ( t ) ) + 
                   ( ph2.y * b3 ( t ) ) + 
                   ( p2.y  * b4 ( t ) );
            
			return pt;
		}
		
		protected function getSegmentLength ( seg : Array, bias : Number ) : Number
		{
			var l : Number = bias;
			var step : Number = 1/bias;
			var i : Number;
			var _length : Number = 0;

			for( i=1; i <= l; i++ )
				_length += Point.distance(getInnerSegmentPoint( (i-1)*step , seg ), getInnerSegmentPoint( (i)*step , seg ));

			return _length;
		}
        public function getPathOrientation (path : Number) : Number
		{
			var p : Point = getTangentAt ( path );
			return Math.atan2( p.y, p.x );
		}
        public function getTangentAt ( pos : Number, posDetail : Number = 0.01 ) : Point
		{
			var tan : Point = getPathPoint( Math.min( 1, pos + posDetail ) ).subtract(
							  getPathPoint( Math.max( 0, pos - posDetail ) ) );
			tan.normalize(1);

			return tan;
		}
        
        public function toSource():String
        {
            return _$( "new $0($1)" , getQualifiedClassName( this ).replace("::","."), getSourceArguments() );
        }
        public function toReflectionSource():String
        {
            return _$( "new $0($1)" , getQualifiedClassName( this ), getReflectionSourceArguments() );
        }
        protected function getSourceArguments():String
        {
            return [ magicToSource(_vertices), _bias ].join(", ");
        }
        protected function getReflectionSourceArguments():String
        {
            return [ magicToReflectionSource( _vertices ), _bias ].join(", ");
        } 
        /**
		 * Bezier function for the first vertex of a segment.
		 * <fr>
		 * Fonction de Bezier pour le premier sommet d'un segment.
		 * </fr>
		 *
		 * @param	t	current bias value
		 * 				<fr>valeur de bias courante</fr>
		 * @return	a value to use to multiply the coordinates of the vertex
		 * 			<fr>une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet</fr>
		 */
		public function b1 ( t : Number ) : Number { return ( ( 1 - t ) * ( 1 - t ) * ( 1 - t ) ) ; }
		/**
		 * Bezier function for the second vertex of a segment.
		 * <fr>
		 * Fonction de Bezier pour le second sommet d'un segment.
		 * </fr>
		 *
		 * @param	t	current bias value
		 * 				<fr>valeur de bias courante</fr>
		 * @return	a value to use to multiply the coordinates of the vertex
		 * 			<fr>une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet</fr>
		 */
		public function b2 ( t : Number ) : Number { return ( 3 * t * ( 1 - t ) * ( 1 - t ) ) ; }
		/**
		 * Bezier function for the third vertex of a segment.
		 * <fr>
		 * Fonction de Bezier pour le troisième sommet d'un segment.
		 * </fr>
		 *
		 * @param	t	current bias value
		 * 				<fr>valeur de bias courante</fr>
		 * @return	a value to use to multiply the coordinates of the vertex
		 * 			<fr>une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet</fr>
		 */
		public function b3 ( t : Number ) : Number { return ( 3 * t * t * ( 1 - t ) ) ; }
		/**
		 * Bezier function for the last vertex of a segment.
		 * <fr>
		 * Fonction de Bezier pour le dernier sommet d'un segment.
		 * </fr>
		 *
		 * @param	t	current bias value
		 * 				<fr>valeur de bias courante</fr>
		 * @return	a value to use to multiply the coordinates of the vertex
		 * 			<fr>une valeur à utiliser pour multiplier les coordonnées
		 * 			du sommet</fr>
         */
        public function b4 ( t : Number ) : Number
        {
            return ( t * t * t ) ;
        }
    }
}
