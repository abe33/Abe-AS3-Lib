package abe.com.mon.geom
{
    import flash.geom.Rectangle;

    /**
     * @author cedric
     */
    public function tmpRect ( x : Number = 0, y : Number = 0, w : Number = 0, h : Number = 0 ) : Rectangle
    {
        var p : Rectangle = pool.get();
        p.x = x;
        p.y = y;
        p.width = w;
        p.height = h;
        return p;
    }
}
import abe.com.mon.utils.ObjectPool;

import flash.geom.Rectangle;
internal const pool : ObjectPool = new ObjectPool(Rectangle, 20);
