package abe.com.edia.particles.display
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    /**
     * @author cedric
     */
    public function bitmapShape ( bmp : * ) : Function
    {
        if( bmp is Class )
            bmp = new bmp();
            
        if( bmp is Bitmap )
            bmp = bmp.bitmapData;
            
        if( !( bmp is BitmapData)  )
        	throw new Error( "bitmapShape only accept BitmapData instance, Bitmap instance or BitmapData Class as argument, was "+ bmp +"." );
        
        return function():Shape {
            
            var w : Number = bmp.width;
            var h : Number = bmp.height;
            var m : Matrix = new Matrix();
            m.translate(-w/2, -h/2);
            
            var s : Shape = new Shape();
            s.graphics.beginBitmapFill(bmp, m, false, true );
            s.graphics.drawRect(-w/2, -h/2, w, h);
            s.graphics.endFill();
            return s;
        };
    }
}
