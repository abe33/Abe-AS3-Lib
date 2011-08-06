package abe.com.mon.utils
{
    import abe.com.mon.geom.Circle;
    import abe.com.mon.geom.Rectangle2;
    import abe.com.mon.geom.pt;

    import flash.display.BitmapData;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public class BitmapUtils
    {
        /**
         * Returns an array of coordinates for pixels that match against
         * <code>threshold</code> all along the vector <code>from-&gt;to</code>.
         * 
         * @param	bmp			source bitmap
         * @param	from		origin point
         * @param 	to			destination point
         * @param 	threshold	pixel mask for valid pixel
         * @return 	coordinates of all pixels that match <code>threshold</code> 
         */
        static public function linearBitmapScan ( bmp : BitmapData, from : Point, to : Point, pixelLookup : Function ) : Array
        {
            var d : Point = to.subtract ( from );
            var o : Point = from.clone ();
            var l : Number = d.length;
            var m : Number = 0;
            var b : Array = [];
            var x : Number;
            var y : Number;

            d.normalize ( 1 );
            
            if( !bmp.rect.containsPoint( from ) && !bmp.rect.containsPoint( to ) )
            	return [];

            while ( m < l )
            {
                x = Math.floor ( o.x );
                y = Math.floor ( o.y );
                
                if( x < 0 || x > bmp.width || y < 0 || y > bmp.height )
                	continue;

                if ( pixelLookup ( bmp, x, y ) )
                    b.push ( pt ( x, y ) );

                o.x += d.x;
                o.y += d.y;
                m += d.length;
            }
            return b;
        }

        /**
         * Returns an array of coordinates for pixels that match
         * <code>threshold</code> all along a circle of size 
         * <code>radius</code> and position <code>center</code>.
         * 
         * @param bmp
         * @param center
         * @param radius
         * @param threshold
         * @return coordinates of all pixels that match <code>threshold</code> 
         */
        static public function circularBitmapScan ( bmp : BitmapData, center : Point, radius : Number, pixelLookup : Function ) : Array
        {
            var rtnArray : Array = [];
            var radius2 : Number = radius * radius;
            var angleIncrement : Number = Math.acos ( ( radius2 + radius2 - 1 ) / ( 2 * radius2 ) );
            var c : Circle = new Circle ( center.x, center.y, radius );
            var r : Rectangle2 = new Rectangle2 ( 0, 0, bmp.width, bmp.height );
            var starts : Array = c.intersections ( r );
            var a : Number;
            var x : Number;
            var y : Number;

            if ( starts )
            {
                for each ( var p : Point in starts )
                {
                    var n : Number = 0;
                    
                    a = Math.atan2 ( p.y - center.y, p.x - center.x ) + angleIncrement;
                    do
                    {
                        x = center.x + Math.floor ( Math.cos ( a ) * radius );
                        y = center.y + Math.floor ( Math.sin ( a ) * radius );
                        
                        if ( pixelLookup ( bmp, x, y ) )
                            rtnArray.push ( pt ( x, y ) );

                        a += angleIncrement;
                    }
                    while ( r.contains ( x, y ) && n++ < 100 );
                }
            }
            else
            {
                if ( r.containsPoint ( center ) && radius < bmp.width )
                {
                    a = 0;
                    
                    while ( a < Math.PI * 2 )
                    {
                        x = center.x + Math.floor ( Math.cos ( a ) * radius );
                        y = center.y + Math.floor ( Math.sin ( a ) * radius );

                        if ( pixelLookup ( bmp, x, y ) )
                            rtnArray.push ( pt ( x, y ) );

                        a += angleIncrement;
                    }
                }
            }

            return rtnArray;
        }
        
        public static function radialBitmapScan ( bmp : BitmapData, center : Point, angle : Number, pixelLookup : Function ) : Array
        {	
            
            var dir : Point = pt( Math.cos(angle), Math.sin(angle) );
            dir.normalize( 1000 );
            
            var intersection : Array = GeometryUtils.vectorGeomIntersection(center, center.add(dir), new Rectangle2(bmp.rect) );
            if( !intersection )
            	return [];
            
            return linearBitmapScan(bmp, 
            						center, 
                                    intersection[0], 
                                    pixelLookup);
        }

        /**
         * 
         * 
         * @param bmp
         * @param x
         * @param y
         * @param threshold
         * @return
         */
        static public function thresholdLookup ( bmp : BitmapData, x : uint, y : uint, threshold : uint = 0x33000000 ) : Boolean
        {
            return ( bmp.getPixel32 ( x, y ) & threshold ) > 0;
        }
        static public function borderPixelLookup( bmp : BitmapData, x : uint, y : uint, threshold : uint = 0x66000000 ) : Boolean
        {
            function isEmpty( x : Number, y : Number ) : Boolean 
            {
                return ( bmp.getPixel32( x, y ) & threshold ) > 0;
            }
            var ul : Boolean = isEmpty(x-1, y-1);
            var u : Boolean  = isEmpty(  x, y-1);
            var ur : Boolean = isEmpty(x+1, y-1);
            var l : Boolean  = isEmpty(x-1, y  );
            var r : Boolean  = isEmpty(x+1, y  );
            var bl : Boolean = isEmpty(x-1, y+1);
            var b : Boolean  = isEmpty(  x, y+1);
            var br : Boolean = isEmpty(x+1, y+1);
            
            return ( 
            	!ul && (bl && ur) || 
            	!u  && ( l && r ) || 
            	!ur && (ul && br) || 
            	!l  && ( u && b ) || 
            	!r  && ( u && b ) || 
            	!bl && (ul && br) || 
            	!b  && ( l && r ) || 
            	!br && (ur && bl)              
            );
        }
    }
}
