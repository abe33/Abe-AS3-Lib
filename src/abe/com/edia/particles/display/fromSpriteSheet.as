package abe.com.edia.particles.display
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.dm;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    /**
     * @author cedric
     */
    public function fromSpriteSheet ( bmp : *, frameSize : Dimension = null, sourceRect : Rectangle = null, random : Random = null ) : Function
    {
        if( bmp is Class )
            bmp = new bmp();
            
        if( bmp is Bitmap )
            bmp = bmp.bitmapData;
            
        if( !( bmp is BitmapData)  )
        	throw new Error( "bitmapShape only accept BitmapData instance, Bitmap instance or BitmapData Class as argument, was "+ bmp +"." );
        
        if( !frameSize )
        	frameSize = dm( bmp.width, bmp.height );
        
        if( !sourceRect )
        	sourceRect = bmp.rect;
        
        random = random ? random : RandomUtils;
            
        var cols : uint = Math.ceil( sourceRect.width / frameSize.width );
        var rows : uint = Math.ceil( sourceRect.height / frameSize.height );
        
        return function( p : Particle ) : Shape {
            var fx : int = random.irandom( cols-1 );
            var fy : int = random.irandom( rows-1 );
            
            var w : Number = frameSize.width;
            var h : Number = frameSize.height;
            
            var m : Matrix = new Matrix();
            m.translate(-w/2 - fx * w, -h/2 - fy * h);
            
            var s : Shape = new Shape();
            s.graphics.beginBitmapFill(bmp, m, false, true );
            s.graphics.drawRect(-w/2, -h/2, w, h);
            s.graphics.endFill();
            return s;
        };
    }
}
