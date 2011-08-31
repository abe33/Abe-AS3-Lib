package abe.com.mon.geom
{
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public function tmpPt ( x : Number = 0, y : Number = 0 ) : Point
    {
        var p : Point = pool.get();
        p.x = x;
        p.y = y;
        return p;
    }
}
import abe.com.mon.utils.ObjectPool;

import flash.geom.Point;
internal const pool : ObjectPool = new ObjectPool( Point, 30 );