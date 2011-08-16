package abe.com.mon.geom
{
    import flash.geom.Rectangle;

    /**
     * @author cedric
     */
    public function tmpRect ( x : Number = 0, y : Number = 0, w : Number = 0, h : Number = 0 ) : Rectangle
    {
        var p : Rectangle = __tmp__[__iter__++];
        p.x = x;
        p.y = y;
        p.width = w;
        p.height = h;
        if( __iter__ >= 20 )
        	__iter__ = 0;
        return p;
    }
}
import abe.com.mon.geom.rect;

internal var __iter__ : Number = 0;
internal const __tmp__ : Array = [ 
	rect(),rect(),rect(),rect(),rect(),
    rect(),rect(),rect(),rect(),rect(), 
	rect(),rect(),rect(),rect(),rect(),
    rect(),rect(),rect(),rect(),rect() 
];