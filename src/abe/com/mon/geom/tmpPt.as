package abe.com.mon.geom
{
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public function tmpPt ( x : Number = 0, y : Number = 0 ) : Point
    {
        var p : Point = __tmp__[__iter__++];
        p.x = x;
        p.y = y;
        if( __iter__ >= 30 )
        	__iter__ = 0;
        return p;
    }
}
import abe.com.mon.geom.pt;

internal var __iter__ : Number = 0;
internal const __tmp__ : Array = [ 
	pt(),pt(),pt(),pt(),pt(),
    pt(),pt(),pt(),pt(),pt(), 
    pt(),pt(),pt(),pt(),pt(), 
    pt(),pt(),pt(),pt(),pt(), 
	pt(),pt(),pt(),pt(),pt(),
    pt(),pt(),pt(),pt(),pt() 
];